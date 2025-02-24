-- This is typically placed in your treesitter configuration file
-- (e.g., ~/.config/nvim/lua/scribe/treesitter.lua)
require('nvim-treesitter.configs').setup({

  -- 1) The set of languages for which we want to install parsers.
  --    "all" is possible, but might install many unwanted parsers.
  ensure_installed = {
    "c",      -- For C/C++ highlighting
    "lua",    -- For Lua (Neovim config language)
    "vim",    -- For Vimscript
    "vimdoc", -- For help docs
    "query",  -- For Treesitter queries themselves
    "javascript",
    "rust",
    "go",
    "python",
    "cpp",
    "html",
    "json",
    "jsonc", -- JSON with comments (VSCode-style)
  },

  -- 2) If true, Parsers will be installed one-by-one and block Neovim until done.
  --    Usually false is fine: installs happen asynchronously in the background.
  sync_install = false,

  -- 3) If true, then any time you open a file for which a parser
  --    is missing, Neovim will auto-install it (requires `tree-sitter` CLI).
  auto_install = true,

  highlight = {
    -- 4) Turn on syntax highlighting using Treesitter.
    enable = true,

    -- 5) If true, Vim’s built-in regex-based syntax highlighting runs *alongside*
    --    Treesitter. This can cause performance issues or duplicate highlights,
    --    so it's recommended to leave it false unless you rely on legacy syntax
    --    features.
    additional_vim_regex_highlighting = false,

    -- 6) An optional function that can disable Treesitter for certain conditions,
    --    e.g. extremely large files. This keeps Neovim responsive.
    disable = function(_, buf)
      local max_filesize = 1024 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        -- Return true to disable Treesitter for this file
        return true
      end
      return false
    end,
  },

  -- 7) Syntax-aware indentation (language support varies).
  --    If you notice incorrect indentation in certain languages,
  --    you can disable them specifically, e.g. disable = { "python" }
  indent = {
    enable = true,
  },

  -- 8) Incremental selection: expand or shrink the current selection
  --    based on syntax nodes. Great for selecting entire functions, blocks, etc.
  incremental_selection = {
    enable = true,
    keymaps = {
      -- Start selection at cursor
      init_selection    = "gnn",
      -- Grow selection (e.g. expand to the parent node)
      node_incremental  = "grn",
      -- Grow selection even further, e.g. to next outer scope
      scope_incremental = "grc",
      -- Shrink selection back one level
      node_decremental  = "grm",
    },
  },

  -- 9) The Playground is a built-in debug tool for Treesitter.
  --    It lets you inspect syntax nodes and how highlight queries are matched.
  --    Type :TSPlaygroundToggle to use. Requires "nvim-treesitter/playground".
  playground = {
    enable = true,
    -- Time in ms after you stop typing before the Playground updates
    updatetime = 25,
    -- If set to true, your queries persist across sessions
    persist_queries = false,
  },

  -- 10) If you use a commenting plugin that supports context_commentstring,
  --    this dynamically sets the comment style based on the file context
  --    (e.g. HTML vs embedded JavaScript).
  context_commentstring = {
    enable = true,
    -- If your commenting plugin triggers an autocommand, set this to true.
    -- If not, or if you have another integration, set it to false.
    enable_autocmd = false,
  },
})
