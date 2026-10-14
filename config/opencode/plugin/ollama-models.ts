import type { Model, Plugin } from "@opencode/plugin"

type OllamaTagsResponse = {
  models?: Array<{
    name?: string
    model?: string
  }>
}

function displayName(id: string) {
  const lastPart = id.split("/").at(-1) ?? id
  return lastPart.replace(/[:_-]+/g, " ").replace(/\b\w/g, (char) => char.toUpperCase())
}

async function loadOllamaModels() {
  const response = await fetch("http://localhost:11434/api/tags", { signal: AbortSignal.timeout(3000) })
  if (!response.ok) return {}

  const data = (await response.json()) as OllamaTagsResponse
  const models: Record<string, { name: string }> = {}

  for (const item of data.models ?? []) {
    const id = item.model ?? item.name
    if (!id) continue
    models[id] = { name: displayName(id) }
  }

  return models
}

export default {
  id: "dotfiles.ollama-models",
  async setup(ctx) {
    const models = await loadOllamaModels().catch(() => ({}))
    if (Object.keys(models).length === 0) return

    await ctx.provider.transform((providers) => {
      const source = providers.get("ollama")
      if (!source) return

      providers.update("ollama", (provider) => {
        provider.name = "Ollama (local)"
        provider.settings = { ...provider.settings, baseURL: "http://localhost:11434" }
      })
      providers.models.set("ollama", Object.entries(models).map(([id, { name }]) => ({
        id: id as Model.ID,
        modelID: id as Model.ID,
        providerID: source.provider.id,
        name,
        capabilities: { tools: true, input: ["text", "image"], output: ["text"] },
        variants: [],
        time: { released: 0 },
        cost: [],
        status: "active",
        enabled: true,
        limit: { context: 200000, output: 32000 },
      })))
    })
  },
} satisfies Plugin.Plugin
