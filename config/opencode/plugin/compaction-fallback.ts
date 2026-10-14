import type { Model, Plugin } from "@opencode/plugin"

type Providers = Awaited<ReturnType<Plugin.Context['provider']['list']>>['data']
type Models = Awaited<ReturnType<Plugin.Context['model']['list']>>['data']

const FALLBACK_MODELS = [
  "tabby/Qwen3.5-9B-exl3-6.00bpw",
  "tabby/Qwen3.8-27B-exl3-2.50bpw",
  "ollama/qwen3:8b",
  "ollama/llama3.1:8b",
]

const PROVIDER_HEALTH_ENDPOINTS: Record<string, string> = {
  tabby: "/models",
  ollama: "/api/tags",
}

async function testProvider(provider: string, options: any): Promise<boolean> {
  const controller = new AbortController()
  const timeout = setTimeout(() => controller.abort(), 3000)

  try {
    const baseURL = options?.baseURL ?? (provider === "ollama" ? "http://localhost:11434" : "http://127.0.0.1:5000/v1")
    const endpoint = PROVIDER_HEALTH_ENDPOINTS[provider] ?? "/models"

    const response = await fetch(`${baseURL}${endpoint}`, {
      method: "GET",
      signal: controller.signal,
    })

    return response.ok
  } catch {
    return false
  } finally {
    clearTimeout(timeout)
  }
}

async function testModel(provider: string, modelId: string, options: any): Promise<boolean> {
  const controller = new AbortController()
  const timeout = setTimeout(() => controller.abort(), 5000)

  try {
    const baseURL = options?.baseURL ?? (provider === "ollama" ? "http://localhost:11434/v1" : "http://127.0.0.1:5000/v1")
    const apiKey = options?.apiKey ?? ""

    const response = await fetch(`${baseURL}/chat/completions`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        ...(apiKey && { Authorization: `Bearer ${apiKey}` }),
      },
      body: JSON.stringify({
        model: modelId,
        messages: [{ role: "user", content: "test" }],
        max_tokens: 1,
      }),
      signal: controller.signal,
    })

    return response.ok
  } catch {
    return false
  } finally {
    clearTimeout(timeout)
  }
}

async function cloudAvailable(): Promise<{ available: boolean; hasCredits: boolean }> {
  if (process.env.OPENCODE_FORCE_LOCAL_COMPACTION === "1") {
    return { available: false, hasCredits: false }
  }

  const controller = new AbortController()
  const timeout = setTimeout(() => controller.abort(), 5000)

  try {
    const response = await fetch("https://api.openai.com/v1/chat/completions", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${process.env.OPENAI_API_KEY ?? ""}`,
      },
      body: JSON.stringify({
        model: "gpt-5.6-luna",
        messages: [{ role: "user", content: "test" }],
        max_tokens: 1,
      }),
      signal: controller.signal,
    })

    if (response.ok) {
      return { available: true, hasCredits: true }
    }

    if (response.status === 401 || response.status === 429 || response.status === 402) {
      return { available: true, hasCredits: false }
    }

    return { available: true, hasCredits: true }
  } catch {
    return { available: false, hasCredits: false }
  } finally {
    clearTimeout(timeout)
  }
}

async function pickWorkingFallback(providers: Providers, models: Models): Promise<Model.Ref | undefined> {
  const testedProviders = new Set<string>()

  for (const model of FALLBACK_MODELS) {
    const [provider, ...rest] = model.split("/")
    const modelId = rest.join("/")

    if (testedProviders.has(provider)) continue

    const providerConfig = providers.find((item) => item.id === provider)
    const availableModels = models.filter((item) => item.providerID === provider && item.enabled)
    if (!providerConfig || availableModels.length === 0) continue

    const providerWorks = await testProvider(provider, providerConfig.settings)
    if (!providerWorks) {
      testedProviders.add(provider)
      continue
    }

    testedProviders.add(provider)

    // Prefer the requested fallback, then try the rest of this provider's inventory.
    const orderedModels = [...availableModels].sort((a, b) => Number(b.id === modelId) - Number(a.id === modelId))
    for (const availableModel of orderedModels) {
      const works = await testModel(provider, availableModel.modelID, providerConfig.settings)
      if (works) {
        return { providerID: availableModel.providerID, id: availableModel.id } as Model.Ref
      }
    }
  }

  return undefined
}

export default {
  id: "dotfiles.compaction-fallback",
  async setup(ctx) {
    const { available, hasCredits } = await cloudAvailable()

    if (available && hasCredits) {
      return
    }

    const location = { directory: ctx.location.directory }
    const [providers, models] = await Promise.all([ctx.provider.list({ location }), ctx.model.list({ location })])
    const fallback = await pickWorkingFallback(providers.data, models.data)
    if (!fallback) {
      return
    }

    await ctx.agent.transform((agents) => {
      agents.update("compaction", (agent) => {
        agent.model = fallback
      })
    })
  },
} satisfies Plugin.Plugin
