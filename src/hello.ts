import { add } from "./lib/math";
import { capitalize } from "./lib/strings";

export function hello(name: string): string {
  return `${capitalize("hello")}, ${name}! 1 + 2 = ${add(1, 2)}`;
}

console.log(hello("world"));
