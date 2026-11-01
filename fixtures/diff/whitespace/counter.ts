export class Counter {
  private count = 0;

  increment(by = 1): number {
    this.count += by;
    return this.count;
  }

  reset(): void {
    this.count = 0;
  }

  describe(): string {
    if (this.count === 0) {
      return "empty";
    }
    return `count is ${this.count}`;
  }
}
