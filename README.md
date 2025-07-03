# Neovim Configuration

My personal Neovim configuration with LSP support, AI integration, and customized keybindings.

## Features

- **LSP Support**: Full language server protocol integration for multiple languages
- **Markdown Preview**: Multiple preview options (browser and native webview)
- **Completion**: nvim-cmp with LSP sources (Tab completion disabled)
- **Git Integration**: Fugitive, Gitsigns, and Diffview
- **File Navigation**: Telescope fuzzy finder and Harpoon
- **Debugging**: DAP (Debug Adapter Protocol) support

## Key Bindings

### Leader Key: `<Space>`

### Autocomplete
- `<leader>tc` - Toggle autocomplete on/off
- `<C-n>` / `<C-p>` - Navigate completion suggestions
- `<C-y>` - Accept completion
- `<C-Space>` - Trigger completion

### Markdown Preview
- `<leader>mp` - Toggle Markdown Preview (browser-based)
- `<leader>pk` - Open Peek preview (native webview)
- `<leader>pc` - Close Peek preview

### File Navigation
- `<leader>pf` - Find files
- `<C-p>` - Git files
- `<leader>/` - Live grep
- `<leader>pb` - Browse buffers

### LSP
- `gd` - Go to definition
- `gr` - Go to references
- `gi` - Go to implementation
- `K` - Hover documentation
- `<leader>rn` - Rename symbol
- `<leader>ca` - Code actions

### Git
- `<leader>gs` - Git status (Fugitive)
- `<leader>gp` - Preview git hunk
- `<leader>gb` - Git blame line

## Customizations

- Tab key inserts literal tabs (autocomplete acceptance disabled)
- Dark chalkboard color theme
- Custom status line with git integration
- Automatic formatting on save for supported languages
