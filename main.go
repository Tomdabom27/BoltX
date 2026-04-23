package main

import (
	"fmt"
	"os"

	"github.com/Tomdabom27/boltx/internal/search"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Please enter a command. \nUsage: boltx search <query>")
		return

	} else if len(os.Args) < 3 {
		fmt.Println("Please enter a query. \nUsage: boltx search <query>")
		return

	}

	command := os.Args[1]
	query := os.Args[2]

	switch command {
	case "search":
		fmt.Printf(`Searching for "%v"`, query)
		fmt.Printf("\n")

		results, err := search.Search(query)

		if err != nil {
			fmt.Printf("An error occurred: %v\n", err)
			return
		}
		// Prevent blank list of results being printed
		if len(results) == 0 {
			fmt.Println("No results found.")
			return
		}

		// Only print plural if more than one result is found
		if len(results) == 1 {
			fmt.Printf("Found 1 result: \n")
		} else {
			fmt.Printf("Found %v results: \n", len(results))
		}

		for i := 0; i < len(results); i++ {
			fmt.Printf("- %v\n", results[i])
		}
	default:
		fmt.Println("Unknown command.")
	}
}
