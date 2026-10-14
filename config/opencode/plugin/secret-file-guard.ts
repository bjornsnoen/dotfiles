import { realpathSync } from 'node:fs'
import { basename, isAbsolute, resolve } from 'node:path'
import type { Plugin } from '@opencode/plugin'

const DENIED_PATH_PATTERNS = ['**/.env', '**/.env.*', '.env', '.env.*', '**/mise.toml', 'mise.toml'] as const
function isForbiddenBasename(path: string) {
    const name = basename(path.replaceAll('\\', '/'))
    return name === 'mise.toml' || name === '.env' || name.startsWith('.env.')
}

function mentionsForbiddenPath(value: unknown): boolean {
    if (typeof value === 'string') {
        return /(^|[\\/\s"'])mise\.toml(?=$|[\\/\s"':])/.test(value)
            || /(^|[\\/\s"'])\.env(?:\.[^\\/\s"':]+)?(?=$|[\\/\s"':])/.test(value)
    }
    if (Array.isArray(value)) return value.some(mentionsForbiddenPath)
    if (value && typeof value === 'object') return Object.values(value).some(mentionsForbiddenPath)
    return false
}

function resolvesToForbiddenPath(path: string, directory: string) {
    const absolute = isAbsolute(path) ? path : resolve(directory, path)
    if (isForbiddenBasename(absolute)) return true

    try {
        return isForbiddenBasename(realpathSync(absolute))
    } catch {
        return false
    }
}

function containsForbiddenFileArgument(value: unknown, directory: string, key = ''): boolean {
    if (typeof value === 'string') {
        if (mentionsForbiddenPath(value)) return true
        return /(?:file|path|directory|cwd)/i.test(key) && resolvesToForbiddenPath(value, directory)
    }
    if (Array.isArray(value)) return value.some((item) => containsForbiddenFileArgument(item, directory, key))
    if (!value || typeof value !== 'object') return false
    return Object.entries(value).some(([childKey, child]) => containsForbiddenFileArgument(child, directory, childKey))
}

export default {
    id: 'dotfiles.secret-file-guard',
    async setup(ctx) {
        await ctx.agent.transform((agents) => {
            for (const agent of agents.list()) {
                agents.update(String(agent.id), (draft) => {
                    for (const action of ['read', 'edit']) {
                        for (const resource of DENIED_PATH_PATTERNS) {
                            draft.permissions.push({ action, resource, effect: 'deny' })
                        }
                    }
                })
            }
        })
        await ctx.permission.hook('evaluate', (event) => {
            if (mentionsForbiddenPath(event.resources)) {
                event.effect = 'deny'
                event.message = 'Security policy permanently blocks access to .env files and mise.toml'
            }
        })
        await ctx.tool.hook('execute.before', async (event) => {
            const session = await ctx.session.get({ sessionID: event.sessionID })
            if (containsForbiddenFileArgument(event.input, session.location.directory)) {
                throw new Error('Security policy permanently blocks access to .env files and mise.toml')
            }
        })
    },
} satisfies Plugin.Plugin
