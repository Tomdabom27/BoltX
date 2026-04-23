# BoltX

**Fast, recursive fuzzy file search for the terminal.**

`BoltX` is a cross-platform CLI tool that searches your file system using fuzzy matching. It recursively walks the current directory tree and returns all files whose names match your query — no exact spelling required. Designed for engineers who want to locate files quickly without memorizing exact names.

---

## Features

- **Fuzzy matching** — finds files even with approximate or partial names
- **Recursive search** — walks the entire directory tree from the current working directory
- **Zero configuration** — no config files, no setup, just install and run
- **Cross-platform** — runs on Linux, macOS, and Windows
- **Fast** — pure Go implementation with no external runtime dependencies
- **Minimal output** — clean, readable results with no noise

---

## Installation

### Prebuilt Binaries (Recommended)

Download the latest release for your platform from the [Releases](https://github.com/Tomdabom27/boltx/releases) page.

**Linux (amd64)**
```bash
curl -L https://github.com/Tomdabom27/BoltX/releases/download/Linux/boltx -o boltx
chmod +x boltx
sudo mv boltx /usr/local/bin/
```

**macOS (arm64 / Apple Silicon)**
```bash
curl -L https://github.com/Tomdabom27/BoltX/releases/download/Apple-silicon/boltx -o boltx
chmod +x boltx
sudo mv boltx /usr/local/bin/
```

**macOS (amd64 / Intel)**
```bash
curl -L https://github.com/Tomdabom27/BoltX/releases/download/Apple-intel/boltx -o boltx
chmod +x boltx
sudo mv boltx /usr/local/bin/
```
> **Note:**
> On macOS, `~/.local/bin` isn’t always included in your `PATH` by default. If it’s missing, your shell won’t be able to find `boltx` after installation.
>
> Add it with:
>
> `echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc`
>
> Then restart your terminal or run `source ~/.zshrc` to apply the change.

> [!WARNING]
> macOS may block the binary on first run because it is not signed.
>
> If you see “cannot be opened because the developer cannot be verified”, run:
>
> `xattr -d com.apple.quarantine /usr/local/bin/boltx`


**Windows (amd64)**

```powershell
New-Item -ItemType Directory -Path "C:\Tools" -Force
Invoke-WebRequest "https://github.com/Tomdabom27/BoltX/releases/download/Windows/boltx.exe" -OutFile "C:\Tools\boltx.exe"
$path = [Environment]::GetEnvironmentVariable("Path","User"); [Environment]::SetEnvironmentVariable("Path", "$path;C:\Tools", "User")
```

### Go Install

Requires Go 1.21 or later.

```bash
go install github.com/Tomdabom27/boltx@latest
```

---

### Build from Source

```bash
git clone https://github.com/Tomdabom27/boltx.git
cd boltx
go build -o boltx .
sudo mv boltx /usr/local/bin/
```

---

## Usage

```
boltx <command> <query>
```

### Commands

| Command | Description |
|---|---|
| `search <query>` | Recursively search for files matching the query |

> Note:
> More commands are coming soon

### Examples

**Basic search:**
```
$ boltx search main
Searching for "main"
Found 2 results:
- ./main.go
- ./cmd/main_test.go
```

**Fuzzy match — approximate spelling:**
```
$ boltx search cnfig
Searching for "cnfig"
Found 2 results:
- ./config.yaml
- ./internal/config/loader.go
```

**No results:**
```
$ boltx search xyznonexistent
Searching for "xyznonexistent"
No results found.
```

---

## Design Philosophy

### Why fuzzy search?

Exact filename search requires you to remember the precise name of a file. In large projects, this is often impractical. Fuzzy matching tolerates typos, abbreviations, and partial recall — the way human memory actually works. `boltx` uses the [`fuzzysearch`](https://github.com/lithammer/fuzzysearch) library to score matches against every file in the tree, returning results that are good enough rather than demanding perfection.

### Why recursive?

Modern projects are deep. Source files live in nested package directories, configuration files are spread across subdirectories, and assets are organized into hierarchies. A tool that only searches the current level is rarely useful. `boltx` always starts from where you are and walks everything beneath it, so you never need to navigate to the right directory before searching.

### Developer ergonomics first

`boltx` is designed to stay out of your way. There is no configuration to write, no index to build, and no daemon to manage. Run it anywhere, get results immediately, and move on.

---

## Architecture

`boltx` is structured as a small, focused Go application with a clean separation between the CLI layer and the search engine.

**`main.go`**

The entrypoint. Responsible for parsing command-line arguments from `os.Args`, dispatching to the appropriate command handler, and formatting output. It handles argument validation and user-facing error messages. It has no search logic of its own.

**`internal/search`**

The search engine. Exports a single `Search(query string)` function that begins a recursive directory walk from the current working directory. For each file encountered, it performs a fuzzy match against the filename using `github.com/lithammer/fuzzysearch/fuzzy`. Matching file paths are collected and returned to the caller. The package is internal to `boltx` and not intended for use as a library.

---

## Roadmap

The following improvements are planned for future releases:

- **`.gitignore` and `.ignore` support** — skip files excluded by version control conventions
- **Colored output** — highlight matched characters in results for faster scanning
- **File content search** — extend fuzzy matching into file contents, not just names
- **Ranked results** — sort results by match quality rather than filesystem order
- **`--max-depth` flag** — limit recursion depth for large repositories
- **Configurable ignore patterns** — exclude directories such as `node_modules`, `.git`, and `vendor` by default
- **JSON output** — machine-readable results for use in scripts and editor integrations
- **Shell completions** — Bash, Zsh, and Fish completions

---

## Contributing

Contributions are welcome. Please follow the standard open-source workflow:

1. Fork the repository and create a branch from `main`.
2. Make your changes with clear, focused commits.
3. Ensure `go build ./...` and `go test ./...` pass with no errors.
4. Open a pull request with a description of what was changed and why.

For significant changes, open an issue first to discuss the approach before writing code.

Please keep pull requests focused on a single concern. Large, unfocused PRs are difficult to review and are likely to be asked to be split up.

---

## License

MIT License. See [LICENSE](./LICENSE) for the full text.