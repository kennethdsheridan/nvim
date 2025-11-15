# Otter LSP Integration Setup

Otter has been configured to provide LSP features for code embedded in other files (like SQL in Python strings, bash in scripts, etc.).

## Supported Languages

Otter is activated for these languages:
- **python** - Python code
- **javascript/typescript** - JS/TS code
- **lua** - Lua code
- **rust** - Rust code
- **bash/sh** - Bash/shell scripts
- **go** - Go code
- **cpp/c** - C/C++ code
- **java** - Java code
- **ruby** - Ruby code
- **php** - PHP code
- **perl** - Perl code
- **r** - R code
- **sql** - SQL queries

## Keybindings

- `<leader>oa` - Activate Otter for current buffer
- `<leader>od` - Deactivate Otter for current buffer
- `<leader>os` - Show Otter status

## How It Works

When you open a file (like a Python script), Otter will:

1. **Detect embedded code** in strings, comments, or other contexts
2. **Provide LSP features** (completion, diagnostics, hover, etc.) for the embedded language
3. **Work alongside** your main LSP server

## Example Usage

In a Python file with embedded SQL:

```python
import sqlite3

# This SQL will get LSP features from Otter
query = """
SELECT name, age
FROM users
WHERE active = 1
ORDER BY name;
"""

conn = sqlite3.connect('database.db')
cursor = conn.execute(query)  # SQL completion and diagnostics here
```

## Configuration

Otter is configured in `lua/scribe/plugins.lua` with:
- LSP hover borders
- Diagnostic updates on file changes
- Support for quote character stripping
- Leading whitespace handling

## Testing

Use the `test_otter.py` file to see Otter in action with embedded bash and SQL code.