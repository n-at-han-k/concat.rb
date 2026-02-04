# AGENTS.md

## Specifications

**IMPORTANT:** Before implementing any feature, consult the specifications in `specs/README.md`.

- **Assume NOT implemented.** Many specs describe planned features that may not yet exist in the codebase.
- **Check the codebase first.** Before concluding something is or isn't implemented, search the actual code. Specs describe intent; code describes reality.
- **Use specs as guidance.** When implementing a feature, follow the design patterns, types, and architecture defined in the relevant spec.
- **Spec index:** `specs/README.md` lists all specifications organized by category (core, LLM, security, etc.).

## Development Commands

```bash
# Setup
bin/setup

# Run all tests
bin/test

# Run a single test file
bin/test test/cli_test.rb

# Lint
bin/rubocop

# Interactive console
bin/console
```

## Architecture

concat.rb is a Ruby gem providing two CLI tools for file concatenation and restoration.

### Core Components

- **`Concat::CLI`** (`lib/concat/cli.rb`) - Recursively reads files from directories, outputs contents prefixed with `# File path: <path>` markers. Supports `--extensions` flag for filtering.

- **`Concat::DeconcatCLI`** (`lib/concat/deconcat_cli.rb`) - Parses concatenated output from STDIN, extracts file boundaries via `# File path:` markers, recreates directory structure and writes files.

### Entry Points

Executables in `exe/` instantiate the CLI classes and call `#call(ARGV)`, returning exit codes.

### File Format

The concatenation format uses `# File path: <relative_path>` as a delimiter:

```
# File path: ./lib/foo.rb
<file contents>

# File path: ./lib/bar.rb
<file contents>
```
