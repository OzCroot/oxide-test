// Small string helpers used by the demo entry point.

export function capitalize(text: string): string {
  if (text.length === 0) {
    return text;
  }
  return text[0].toUpperCase() + text.slice(1);
}

export function slugify(text: string): string {
  return text
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "");
}

export function truncate(text: string, max: number): string {
  if (text.length <= max) {
    return text;
  }
  return text.slice(0, max - 1) + "…";
}

export function padLeft(text: string, width: number, fill = " "): string {
  return text.length >= width ? text : fill.repeat(width - text.length) + text;
}
