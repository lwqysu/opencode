export function number(value: number) {
  return new Intl.NumberFormat().format(value)
}

export function duration(ms: number) {
  if (ms < 1_000) return `${Math.round(ms)}ms`
  if (ms < 60_000) return `${(ms / 1_000).toFixed(ms < 10_000 ? 1 : 0)}s`
  if (ms < 3_600_000) return `${Math.round(ms / 60_000)}m`
  return `${Math.round(ms / 3_600_000)}h`
}

export function titlecase(value: string) {
  return value
    .split(/[\s_-]+/)
    .filter(Boolean)
    .map((word) => word.slice(0, 1).toUpperCase() + word.slice(1))
    .join(" ")
}

export function truncate(value: string, length: number) {
  if (value.length <= length) return value
  if (length <= 1) return value.slice(0, length)
  return value.slice(0, length - 1) + "…"
}

export function truncateMiddle(value: string, length: number) {
  if (value.length <= length) return value
  if (length <= 1) return value.slice(0, length)
  const left = Math.ceil((length - 1) / 2)
  const right = Math.floor((length - 1) / 2)
  return value.slice(0, left) + "…" + value.slice(value.length - right)
}

export function todayTimeOrDateTime(input: number | Date) {
  const date = input instanceof Date ? input : new Date(input)
  const now = new Date()
  const sameDay =
    date.getFullYear() === now.getFullYear() &&
    date.getMonth() === now.getMonth() &&
    date.getDate() === now.getDate()
  if (sameDay) return date.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" })
  return date.toLocaleString([], { month: "short", day: "numeric", hour: "2-digit", minute: "2-digit" })
}

export const Locale = {
  number,
  duration,
  titlecase,
  truncate,
  truncateMiddle,
  todayTimeOrDateTime,
}
