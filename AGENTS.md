# Agent Guidelines for Neovim Configuration

## Build/Lint/Test Commands

### Rust Development (when working in Rust projects)
- **Run tests**: `:CargoTest` or `<leader>dt` (runs `cargo test`)
- **Build project**: `:CargoRun` (runs `cargo run`)
- **Check code**: `:CargoCheck` (runs `cargo check`)
- **Lint with clippy**: `:CargoClippy` (runs `cargo clippy`)

### Nix Files
- **Format nix files**: Auto-formats on save using `formatter.nvim` with `nixpkgsfmt`

### Plugin Management
- **Update plugins**: `:Lazy update` (lazy.nvim package manager)
- **Sync plugins**: `:Lazy sync`

### LSP
- **Format buffer**: `<leader>f` (LSP formatting)
- **Check diagnostics**: `<leader>tt` (Trouble diagnostics toggle)

### OpenCode AI Assistant
- **Toggle embedded opencode**: `<leader>ot`
- **Ask about cursor**: `<leader>oa` (normal mode)
- **Ask about selection**: `<leader>oa` (visual mode)
- **Add buffer to prompt**: `<leader>o+` (normal mode)
- **Add selection to prompt**: `<leader>o+` (visual mode)
- **Explain code**: `<leader>oe`
- **New session**: `<leader>on`
- **Select prompt**: `<leader>os`
- **Scroll messages up**: `<S-C-u>`
- **Scroll messages down**: `<S-C-d>`

## Code Style Guidelines

### Lua Configuration Style
- **Indentation**: 4 spaces (configured in `set.lua`)
- **Line length**: 100 characters (color column enabled)
- **Comments**: Use `--` for single-line comments, descriptive and clear
- **Naming**: Use descriptive variable names, follow Lua conventions
- **Error handling**: Use `pcall()` for optional dependencies and operations
- **Table formatting**: Consistent formatting with proper alignment

### Keybindings
- **Leader key**: Space (`<Space>`)
- **Descriptions**: Always include `desc` field for keymap documentation
- **Consistency**: Follow existing patterns for similar operations

### Plugin Configuration
- **Conditional loading**: Use `pcall()` and `enabled` flags for optional plugins
- **Configuration structure**: Group related settings, use clear section headers
- **Dependencies**: Explicitly declare plugin dependencies

### LSP Configuration
- **On-attach functions**: Standard LSP keybindings (gd, gr, gi, K, etc.)
- **Formatting**: Automatic formatting on save enabled
- **Rust analyzer**: Enhanced configuration with clippy linting and inlay hints

### File Organization
- **Structure**: Keep related functionality grouped in logical modules
- **Imports**: Use `require()` consistently, avoid global pollution
- **Separation**: UI, LSP, and plugin configs in separate files when appropriate

## Important Notes

- **Tab completion**: Intentionally disabled - Tab inserts literal tabs, not completions
- **Autocomplete toggle**: Use `<leader>tc` to enable/disable nvim-cmp completion
- **Theme**: Multiple themes available, configured for light backgrounds
- **Markdown preview**: Two options available (markdown-preview.nvim and peek.nvim)
- **OpenCode integration**: AI assistant with context-aware prompts (@cursor, @selection, @buffer, etc.)
- **Auto-reload**: Buffers edited by opencode are automatically reloaded

## Testing Single Components

When working with this Neovim config:
1. Test keybindings in a new buffer
2. Verify LSP functionality with Rust/Go/TypeScript files
3. Check plugin loading with `:Lazy` commands
4. Test formatting with `<leader>f` on various file types