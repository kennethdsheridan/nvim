
-- packer.lua
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- **Plugin Declarations**

  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Completion engine
  use 'hrsh7th/nvim-cmp'

  -- Cmp Treesitter
  use 'ray-x/cmp-treesitter'

    -- TabNine plugin
--  use { 'codota/tabnine-nvim', run = "./dl_binaries.sh" }

  -- TabNine integration with nvim-cmp
   
  -- Snippet engine and snippets
  use 'L3MON4D3/LuaSnip'
  use 'rafamadriz/friendly-snippets'

  -- Cmp Emoji (for emoji's)
  use 'hrsh7th/cmp-emoji'

  -- LSP signature
  use 'hrsh7th/cmp-nvim-lsp-signature-help'

  -- LSP configurations and tools
  use 'neovim/nvim-lspconfig'           -- LSP configurations
  use 'williamboman/mason.nvim'         -- LSP installer
  use 'williamboman/mason-lspconfig.nvim'
  use {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    requires = {
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},
      {'neovim/nvim-lspconfig'},
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'L3MON4D3/LuaSnip'},
    }
  }

  -- Additional completion sources
  use 'hrsh7th/cmp-nvim-lsp'            -- LSP completion source
  use 'hrsh7th/cmp-buffer'              -- Buffer completion source
  use 'hrsh7th/cmp-path'                -- Path completion source

  -- Icons and symbols for completion items
  use 'onsails/lspkind-nvim'            -- Provides icons for `nvim-cmp`

   -- TabNine integration with nvim-cmp
  use {'tzachar/cmp-tabnine', run='./install.sh', requires = 'hrsh7th/nvim-cmp'}

  -- LSP UI enhancements
  use 'glepnir/lspsaga.nvim'

  -- Git DiffView
  use "sindrets/diffview.nvim"

  -- Trouble Plugin
  use {
    'folke/trouble.nvim',
    requires = {'nvim-tree/nvim-web-devicons'},
    config = function()
      require("trouble").setup {}
    end
  }

  -- Telescope
  use {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.6',
    requires = {'nvim-lua/plenary.nvim'}
  }

  -- Noice
  use {
    'folke/noice.nvim',
    requires = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify'
    },
    config = function()
      require('noice').setup()
    end
  }

  -- Install the EdenEast NightFox color scheme plugin
  use 'EdenEast/nightfox.nvim'

  -- Treesitter
  use('nvim-treesitter/nvim-treesitter', {run =  ':TSUpdate'})

  -- Treesitter Playground
  use 'nvim-treesitter/playground'

  -- Harpoon
  use 'theprimeagen/harpoon'

  -- Undotree
  use 'mbbill/undotree'

  -- VIM Fugitive
  use 'tpope/vim-fugitive'

  -- Notify Plugin Configuration
  use 'rcarriga/nvim-notify'

  -- Cloak
  use 'laytan/cloak.nvim'

  -- Rust-specific plugins
  use 'simrat39/rust-tools.nvim'
  use 'saecki/crates.nvim'

  -- Additional LSP enhancements
  use 'kosayoda/nvim-lightbulb'
  use 'mfussenegger/nvim-lint'
  use 'mhartington/formatter.nvim'

  -- Bash-specific plugins
  use 'vim-scripts/bats.vim'
  use 'chrisbra/vim-sh-indent'
  use 'arzg/vim-sh'

  -- Markdown-specific plugins
  use({
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
  })
  use 'preservim/vim-markdown'
  use 'dhruvasagar/vim-table-mode'
  use 'junegunn/limelight.vim'
  use 'junegunn/goyo.vim'

  -- **Plugin Configurations**

  -- Setup mason (LSP Installer)
  require('mason').setup()
  require('mason-lspconfig').setup({
    ensure_installed = {'pyright', 'rust_analyzer', 'tsserver'},
    automatic_installation = true,
  })

  -- LSP-zero setup
  local lsp = require('lsp-zero').preset('recommended')

  lsp.on_attach(function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Key mappings for LSP functions
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  end)

  lsp.setup()

  -- CMP setup
  local cmp = require('cmp')
  local lspkind = require('lspkind') -- Added for formatting completion items

  cmp.setup({
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body) -- For LuaSnip users
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      -- Add more mappings if needed
    }),
    sources = cmp.config.sources({
      { name = 'cmp_tabnine', priority = 1000 },    -- TabNine source
      { name = 'nvim_lsp', priority = 500},       -- LSP source
      { name = 'luasnip' },        -- Snippet source
      { name = 'buffer' },         -- Buffer source
      { name = 'path' },           -- Path source
      { name = 'nvim_lua' },       -- Lua completion 
      { name = 'nvim_lsp_signature_help' },       -- Lua completion 
      { name = 'treesitter' },       -- Lua completion 
      { name = 'emoji' },       -- Lua completion 
      
      -- Add other sources if needed
    }),
    formatting = {
      format = lspkind.cmp_format({
        mode = 'symbol_text',
        maxwidth = 50,
        before = function (entry, vim_item)
          if entry.source.name == 'cmp_tabnine' then
            vim_item.kind = '🤖' -- Icon for TabNine
            vim_item.menu = '[TabNine]'
            if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
              vim_item.menu = vim_item.menu .. ' ' .. entry.completion_item.data.detail
            end
          end
          return vim_item
        end
      })
    },
    -- Add other cmp configurations here...
  })

  -- TabNine configuration
  require('cmp_tabnine.config'):setup({
    max_lines = 1000,
    max_num_results = 20,
    sort = true,
    run_on_every_keystroke = true,
    snippet_placeholder = '..',
    ignored_file_types = {},
    show_prediction_strength = false
  })

  -- Optional: Add a specific mapping for TabNine completion
  vim.api.nvim_set_keymap('i', '<C-t>', [[<Cmd>lua require('cmp').complete({config = { sources = { { name = 'cmp_tabnine' } }}})<CR>]], { noremap = true, silent = true })

  -- Rust-specific setup
  local rt = require("rust-tools")
  rt.setup({
    server = {
      on_attach = function(_, bufnr)
        -- Hover actions
        vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
        -- Code action groups
        vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
      end,
    },
  })

  -- Setup crates.nvim
require('crates').setup({
  smart_insert = true,          -- Automatically insert a version if none is specified
  autoload = true,              -- Automatically load crate information when editing a file
  autoupdate = true,            -- Automatically refresh crate information on every edit
  loading_indicator = true,     -- Show a loading indicator while fetching crate data
  date_format = "%Y-%m-%d",     -- Date format for displaying crate versions
  -- `avoid_prerelease` and `disable_invalid_feature_diagnostic` are deprecated and removed

  -- Custom text for various stages
  text = {
    loading = "   Loading...", -- Text shown when crate info is being loaded
    version = "   %s",         -- Format for displaying the current version
    prerelease = "   %s",      -- Format for showing pre-release versions
    yanked = "   %s",          -- Format for displaying yanked versions
    nomatch = "   No match",   -- Text shown when no matching crate is found
    upgrade = "   %s",         -- Format for displaying upgradeable versions
    error = "   Error fetching crate", -- Error message text
  },

  -- Popup window settings for displaying crate information
  popup = {
    autofocus = false,          -- Do not auto-focus the popup window
    style = "minimal",          -- Use a minimal style for the popup window
    border = "rounded",         -- Use rounded borders for the popup window
    show_version_date = true,   -- Display the release date of each version
    max_height = 30,            -- Set maximum height for the popup window
    min_width = 20,             -- Set minimum width for the popup window
    -- Simplified popup text configuration, removed deprecated keys
    text = {
      title = " %s",           -- Format for the popup title
      version = "   %s",        -- Format for the version field
      date = "   %s",           -- Format for the date field
      features = " • Features", -- Heading for the features section
      dependencies = " • Dependencies", -- Heading for dependencies
    },
  },

  -- `completion` replaces the deprecated `src` field
  completion = {
    insert_closing_quote = true, -- Automatically insert the closing quote after a version
  },

  null_ls = {
    enabled = false,             -- Disable integration with null-ls
    name = "crates.nvim",        -- The source name for null-ls if integration is enabled
  },
})


  -- Setup nvim-lightbulb
  require('nvim-lightbulb').setup({
  sign = {
    enabled = false,
  },
  virtual_text = {
    enabled = true,
    text = "💡", -- You can customize this symbol
    virt_text_pos = 'eol', -- Valid options: "eol", "overlay", "right_align"
  },
  float = {
    enabled = false,
  },
})


  -- Update lightbulb on CursorHold and CursorHoldI
  vim.cmd([[
    autocmd CursorHold,CursorHoldI * lua require('nvim-lightbulb').update_lightbulb()
  ]])

  -- Markdown-specific configurations
  -- Add your configurations for markdown enhancements, linters, and formatters here
  -- For example:
  -- require('lspconfig').marksman.setup{}
  -- require('lint').linters_by_ft = { markdown = {'markdownlint'} }
  -- require('formatter').setup({...})

  -- Ensure packer compiles when changes are made to your plugins
  if packer_bootstrap then
    require('packer').sync()
  end

end)

