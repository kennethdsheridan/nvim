# LSP Completion Setup Guide

## Current Configuration
You now have nvim-cmp configured for LSP completions with multiple navigation options.

## How to Use Completions

### Automatic Popup
- Start typing and the completion menu will appear automatically after 2-3 characters
- The menu shows suggestions from:
  - LSP (language servers) - marked with [LSP]
  - Snippets - marked with [Snippet] 
  - Buffer words - marked with [Buffer]
  - File paths - marked with [Path]

### Navigation Methods

#### Method 1: Tab Navigation (Default)
- `Tab` - Select next item in completion menu
- `Shift+Tab` - Select previous item
- `Enter` - Accept selected completion
- `Ctrl+E` - Cancel/close the menu

#### Method 2: Arrow Keys
- `↓` or `Down Arrow` - Next item
- `↑` or `Up Arrow` - Previous item
- `Enter` - Accept selection

#### Method 3: Vim-style Navigation
- `Ctrl+N` - Next item (native Vim)
- `Ctrl+P` - Previous item (native Vim)

### Manual Triggers
- `Ctrl+Space` - Manually trigger completion menu
- `Ctrl+X Ctrl+O` - Trigger omni-completion (native LSP)

### Toggle Tab Behavior
If you prefer Tab to insert literal tabs instead of navigating completions:

- `:TabCompleteOff` - Tab inserts literal tabs
- `:TabCompleteOn` - Tab navigates completions (default)
- `:TabCompleteToggle` - Toggle between modes
- `<leader>tc` - Quick toggle keybinding

## Completion Sources by File Type

### General Programming
- LSP suggestions (functions, variables, types)
- Snippets (code templates)
- Buffer words (words from current file)
- File paths (when typing paths)

### SQL Files
- Database completions (if connected via dadbod)
- SQL keywords and functions

### Git Commits
- Git-specific completions
- Conventional commit suggestions

## Tips

1. **Quick Accept**: With an item selected, press `Enter` to accept
2. **Documentation**: Hover window shows documentation for selected item
3. **Cancel**: Press `Escape` or `Ctrl+E` to close without selecting
4. **Scroll Docs**: Use `Ctrl+F`/`Ctrl+B` to scroll documentation

## Troubleshooting

### Completions Not Showing?
1. Check LSP is attached: `:LspInfo`
2. Verify language server running: `:LspStatus`
3. Ensure file type detected: `:set filetype?`

### Want Different Behavior?
Edit `/Users/kennysheridan/.config/nvim/after/plugin/completion.lua`

### Reset to Defaults
Run `:source $MYVIMRC` or restart Neovim