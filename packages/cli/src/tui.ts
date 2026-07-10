import { Effect } from "effect"

export function runTui(transport: { url: string; headers: RequestInit["headers"] }) {
  return Effect.sync(() => {
    console.error("The terminal interface has been removed. Use `opencode web` or `opencode serve`.")
    console.error(`Server: ${transport.url}`)
  })
}
