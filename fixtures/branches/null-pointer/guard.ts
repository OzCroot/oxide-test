export function guard<T>(value: T | null): T {
  if (value === null) throw new Error("null");
  return value;
}
