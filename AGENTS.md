# Agent Guidelines for Neovim Configuration

## Build/Lint/Test Commands

### Single Test Execution
- **Run single Rust test**: `cargo test test_name` in terminal or `:terminal cargo test test_name`
- **Run all tests**: `:CargoTest` or `<leader>dt` (maps to `cargo test`)
- **Build project**: `:CargoRun` | **Check code**: `:CargoCheck` | **Lint**: `:CargoClippy`

### Formatting & Diagnostics
- **Format code**: `<leader>f` (LSP formatting) or `:FormatWrite` (nix files auto-format on save)
- **Check diagnostics**: `<leader>tt` (Trouble toggle) | **Toggle completion**: `<leader>tc`

### Plugin Management
- **Update plugins**: `:Lazy update` | **Sync plugins**: `:Lazy sync`

## Code Style Guidelines

### Lua Configuration Style
- **Indentation**: 4 spaces | **Line length**: 100 chars | **Comments**: `--` descriptive
- **Error handling**: Use `pcall()` for optional dependencies | **Imports**: `require()` consistently
- **Keybindings**: Always include `desc` field, leader key is Space (`<Space>`)

### File Organization & LSP
- **Structure**: Group related functionality in logical modules (after/plugin/*.lua)
- **LSP**: Standard keybindings (gd, gr, gi, K), automatic formatting on save enabled
- **Tab behavior**: Tab inserts literal tabs (completion intentionally disabled)

## Important Notes
- OpenCode AI assistant integrated with `<leader>o*` keybindings (@cursor, @selection, @buffer contexts)
- Multiple themes available, configured for light backgrounds
- Auto-reload enabled for opencode-edited buffers