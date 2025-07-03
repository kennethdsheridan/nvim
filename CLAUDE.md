# Claude AI Assistant Notes

This file contains important information for Claude AI when working with this Neovim configuration.

## Autocomplete Configuration

### Current Setup
- **nvim-cmp**: Enabled for LSP completions
- **Markdown Preview**: Two options available (markdown-preview.nvim and peek.nvim)
- **Tab key**: Disabled for completion acceptance (inserts literal tabs)

### Key Bindings
- `<leader>tc` - Toggle autocomplete on/off
- `<C-n>` / `<C-p>` - Navigate completion suggestions
- `<C-y>` - Accept selected completion
- `<C-Space>` - Trigger completion manually

### Important Files
- `after/plugin/disable-tab-completion.lua` - Forces Tab to insert literal tabs
- `lua/scribe/remap.lua` - Contains toggle function for autocomplete
- `after/plugin/lsp.lua` - Main nvim-cmp configuration
- `lua/scribe/plugins.lua` - Plugin configurations including peek.nvim
- `lua/scribe/markdown.lua` - Additional markdown plugin configurations

### Markdown Preview Commands
- `<leader>mp` - Toggle Markdown Preview (browser-based)
- `<leader>pk` - Open Peek preview (native webview)
- `<leader>pc` - Close Peek preview

## Notes for Future Changes
- Tab completion is intentionally disabled via multiple mechanisms
- The toggle function modifies nvim-cmp's enabled state
- Peek.nvim provides native webview markdown preview with auto-reload