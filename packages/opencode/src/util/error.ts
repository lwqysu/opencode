import { isRecord } from "./record"

export function errorMessage(error: unknown): string {
  if (error instanceof Error) return error.message
  if (typeof error === "string") return error
  if (isRecord(error)) {
    if (typeof error.message === "string") return error.message
    if (typeof error.error === "string") return error.error
  }
  return String(error)
}

export function errorData(error: unknown): unknown {
  if (error instanceof Error) {
    return {
      name: error.name,
      message: error.message,
      stack: error.stack,
      cause: error.cause ? errorData(error.cause) : undefined,
    }
  }
  return error
}

export function errorFormat(error: unknown): string {
  const message = errorMessage(error)
  if (error instanceof Error && error.stack) return error.stack
  return message
}
