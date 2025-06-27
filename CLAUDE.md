# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a Neovim configuration built with the "Scribe" theme, using Lazy.nvim for plugin management and a modular Lua configuration structure.

### File Structure
- `init.lua` (root) - Nix-specific bootstrap file (sources Nix home-manager configuration)
- `lua/scribe/init.lua` - Main configuration entry point with Lazy.nvim bootstrap
- `lua/scribe/plugins.lua` - Comprehensive plugin specification (~1400 lines)
- `lua/scribe/set.lua` - Vim options and settings
- `lua/scribe/remap.lua` - Custom keybindings and mappings
- `after/plugin/` - Plugin-specific configurations (LSP, Telescope, etc.)

### Plugin Management
Uses Lazy.nvim with extensive plugin ecosystem including:
- **LSP**: Mason + lsp-zero + nvim-lspconfig for language servers
- **Completion**: nvim-cmp with multiple sources
- **Fuzzy Finding**: Telescope with multiple extensions  
- **Git Integration**: Fugitive, Gitsigns, Neogit, Diffview
- **Debugging**: nvim-dap with Rust/LLDB support
- **Themes**: Multiple colorschemes (Gruvbox, Tokyo Night, Catppuccin, etc.)
- **AI Code Completion**: Augment.vim for AI-powered code suggestions

### AI Code Completion (Augment)
Configuration includes Augment.vim (previously used Tabnine):
- **Workspace**: Configured for `/Users/kennysheridan/Documents`
- **Run Commands**: Pre-configured for multiple languages (Rust: `cargo run`, Python: `python3 %`, etc.)
- **Keybindings**: 
  - `<leader>ac` - Enter chat mode
  - `<leader>an` - Create new chat
  - `<leader>at` - Toggle chat window
- **Telescope Integration**: Custom AugmentTelescope command for project file searching
- **Lazy Loading**: Loads on VeryLazy event for better startup performance

### LSP Configuration
Dual LSP setup approach:
1. **after/plugin/lsp.lua**: Uses lsp-zero with Mason for automatic server management
2. **lua/scribe/init.lua**: Manual LSP configuration for specific servers (Rust, Lua, etc.)

Languages supported: TypeScript, Rust, Python, Go, Lua, Bash, JSON, YAML, Docker, Markdown, HTML/CSS

## Development Workflow

### Plugin Development
- Add new plugins to `lua/scribe/plugins.lua`
- Plugin-specific config goes in `after/plugin/[plugin-name].lua`
- Use Lazy.nvim's lazy loading features (ft, cmd, keys, event)

### LSP Management
- Servers installed via Mason: `:Mason` to open UI
- Add new servers to `ensure_installed` in `after/plugin/lsp.lua`
- Custom server configs go in the manual setup section

### Debugging Setup
- Rust debugging configured with CodeLLDB via Mason
- DAP keybindings: F5 (continue), F10 (step over), F11 (step into), Leader+b (breakpoint)
- Auto-builds first binary target for Rust projects

### Key Mappings (Leader = Space)
- **Files**: `<leader>pf` (find files), `<C-p>` (git files), `<leader>/` (live grep)
- **LSP**: `gd` (definition), `gr` (references), `K` (hover), `<leader>rn` (rename)
- **Git**: `<leader>gp` (preview hunk), `<leader>gt` (toggle blame)
- **Terminal**: `<leader>tt` (horizontal terminal split)
- **Projects**: `<leader>pp` (project picker)
- **AI Chat**: `<leader>ac` (Augment chat), `<leader>an` (new chat), `<leader>at` (toggle chat)

### Testing and Linting
No specific test commands configured - relies on LSP diagnostics and manual cargo/npm commands.

### Color Scheme Management
Multiple themes configured with manual switching. Current setup loads multiple themes simultaneously - consider using a theme switcher plugin or commenting out unused themes for better startup performance.

### Performance Notes
- Large plugin.lua file (~1400 lines) may impact startup time
- Consider splitting into modular plugin files by category
- Some plugins load immediately (lazy = false) - review for optimization opportunities

## Common Tasks

### Adding a New Language Server
1. Add server name to `ensure_installed` in `after/plugin/lsp.lua:18`
2. Add to `default_servers` table in `after/plugin/lsp.lua:42` 
3. Or create custom config following lua_ls/rust_analyzer examples

### Modifying Keybindings
Edit `lua/scribe/remap.lua` - uses vim.keymap.set() format

### Installing New Plugins
Add to `lua/scribe/plugins.lua` following existing pattern with proper lazy loading configuration

### Configuring Augment AI
- Workspace folders configured in `lua/scribe/plugins.lua:87`
- Run commands for different languages in `lua/scribe/plugins.lua:91-101`
- Chat functionality accessible via leader key combinations