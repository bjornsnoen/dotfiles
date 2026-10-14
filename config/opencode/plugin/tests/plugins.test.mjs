import assert from 'node:assert/strict'
import { test } from 'node:test'
import ollama from '../ollama-models.ts'
import fallback from '../compaction-fallback.ts'
import guard from '../secret-file-guard.ts'

test('plugins expose V2 definitions without runtime package dependencies', () => {
    for (const plugin of [ollama, fallback, guard]) {
        assert.equal(typeof plugin.id, 'string')
        assert.equal(typeof plugin.setup, 'function')
    }
    assert.equal(new Set([ollama.id, fallback.id, guard.id]).size, 3)
})

test('Ollama discovery contributes complete provider source models', async (t) => {
    t.mock.method(globalThis, 'fetch', async () => Response.json({ models: [{ model: 'qwen3:8b' }] }))
    const provider = { id: 'ollama', settings: {}, package: 'aisdk:custom-ollama' }
    let inventory
    await ollama.setup({ provider: { transform: async (edit) => edit({
        get: () => ({ provider }),
        update: (_id, update) => update(provider),
        models: { set: (_id, models) => { inventory = models } },
    }) } })
    assert.equal(provider.package, 'aisdk:custom-ollama')
    assert.equal(inventory[0].modelID, 'qwen3:8b')
    assert.equal(inventory[0].name, 'Qwen3 8b')
    assert.equal(inventory[0].enabled, true)
})

test('unreachable Ollama leaves existing models alone', async (t) => {
    t.mock.method(globalThis, 'fetch', async () => { throw new Error('offline') })
    await ollama.setup({ provider: { transform: () => assert.fail('unexpected transform') } })
})

test('compaction fallback uses V2 inventories and model references', async (t) => {
    t.mock.method(globalThis, 'fetch', async (url) => new Response(null, {
        status: String(url).includes('api.openai.com') ? 401 : 200,
    }))
    const agent = {}
    await fallback.setup({
        location: { directory: '/project' },
        provider: { list: async () => ({ data: [{ id: 'tabby', settings: { baseURL: 'http://localhost/v1' } }] }) },
        model: { list: async () => ({ data: [{
            providerID: 'tabby', id: 'Qwen3.5-9B-exl3-6.00bpw', modelID: 'Qwen3.5-9B-exl3-6.00bpw', enabled: true,
        }] }) },
        agent: { transform: async (edit) => edit({ update: (id, update) => {
            assert.equal(id, 'compaction')
            update(agent)
        } }) },
    })
    assert.deepEqual(agent.model, { providerID: 'tabby', id: 'Qwen3.5-9B-exl3-6.00bpw' })
})

test('guard registers V2 rules and blocks forbidden inputs without reading files', async () => {
    const hooks = {}
    const agent = { id: 'general', permissions: [{ action: 'read', resource: '*', effect: 'allow' }] }
    await guard.setup({
        agent: { transform: async (edit) => edit({ list: () => [agent], update: (_id, update) => update(agent) }) },
        permission: { hook: async (name, hook) => { hooks[name] = hook } },
        tool: { hook: async (name, hook) => { hooks[name] = hook } },
        session: { get: async () => ({ location: { directory: '/project' } }) },
    })
    assert.equal(agent.permissions.at(-1).effect, 'deny')
    const evaluation = { resources: ['/project/.env.local'], effect: 'allow' }
    hooks.evaluate(evaluation)
    assert.equal(evaluation.effect, 'deny')
    for (const input of [{ filePath: '.env' }, { command: 'cat mise.toml' }, { nested: ['.env.production'] }]) {
        await assert.rejects(hooks['execute.before']({ sessionID: 'test', input }), /Security policy/)
    }
    await hooks['execute.before']({ sessionID: 'test', input: { filePath: 'README.md' } })
})
