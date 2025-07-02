# Claude AI Assistant Notes

This file contains important information for Claude AI when working with this Neovim configuration.

## Autocomplete Configuration

### Current Setup
- **nvim-cmp**: Enabled for LSP completions
- **Augment**: Enabled for AI chat features
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
- `lua/scribe/plugins.lua` - Plugin configurations including Augment

### Augment Chat Commands
- `<leader>ac` - Enter Augment chat mode
- `<leader>an` - Create new Augment chat
- `<leader>at` - Toggle Augment chat window

## Notes for Future Changes
- Tab completion is intentionally disabled via multiple mechanisms
- The toggle function modifies nvim-cmp's enabled state
- Augment autocomplete is disabled but chat features remain active