package search

import (
	"github.com/lithammer/fuzzysearch/fuzzy"
	"os"
	"path/filepath"
)

// Search finds files by fuzzy name matching starting from current directory.
func Search(query string) ([]string, error) {
	return search_dir(".", query)
}

func search_dir(dir string, query string) ([]string, error) {
	results := []string{}

	entries, err := os.ReadDir(dir)
	if err != nil {
		return results, err
	}

	for _, file := range entries {

		fullPath := filepath.Join(dir, file.Name())

		if file.IsDir() {
			subResults, err := search_dir(fullPath, query)
			if err != nil {
				return results, err
			}
			results = append(results, subResults...)
			continue
		}

		if fuzzy.Match(query, filepath.Base(fullPath)) {
			results = append(results, fullPath)
		}
	}

	return results, nil
}
