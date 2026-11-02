package main

import (
	"fmt"
	"os"
)

func main() {
	name := os.Getenv("USER")
	fmt.Printf("hello, %s\n", name)
}
