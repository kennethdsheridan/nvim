# Neovim Configuration

My personal Neovim configuration with LSP support, AI integration, and customized keybindings.

## Features

- **LSP Support**: Full language server protocol integration for multiple languages
- **Markdown Preview**: Multiple preview options (browser and native webview)
- **Completion**: nvim-cmp with LSP sources (Tab completion disabled)
- **Git Integration**: Fugitive, Gitsigns, and Diffview
- **File Navigation**: Telescope fuzzy finder and Harpoon
- **Debugging**: DAP (Debug Adapter Protocol) support
- **AI tools**: OpenCode side split and Claude terminal launcher

## Current status

- Neovim 0.12-compatible configuration
- Augment removed from the active setup
- `nvim-treesitter/playground` removed because it is incompatible with the current treesitter API
- Forgejo is the default git remote for this repo

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

### AI
- `<leader>oc` - Open OpenCode in a side split
- `<leader>cc` - Open Claude in a top terminal split

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

## Source of truth

This repo is synced into `~/.config/nvim` by Home Manager from the separate system configuration repo.

## Local Development
```bash
# Clone and work locally
git clone ssh://forgejo@parrisisland.netmaker:2224/kenneth/nvim.git ~/.config/nvim
cd ~/.config/nvim
```

## Git remotes

Forgejo is the default remote for this repo.

```bash
git remote -v
```

- `origin` points to the private Forgejo repository
- `github` points to GitHub

Push commands:

```bash
git push origin main
git push github main
```
