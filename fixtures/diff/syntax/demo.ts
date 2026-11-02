export interface User {
  id: number;
  name: string;
  email?: string;
}

export async function greet(user: User): Promise<string> {
  // A template string reads better than concatenation.
  return `Hello, ${user.name}`;
}
