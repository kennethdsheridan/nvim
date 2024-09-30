-- packer.lua
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- The completion engine
  use 'hrsh7th/nvim-cmp'

  -- Tabnine
  use {'tzachar/cmp-tabnine', run='./install.sh', requires = 'hrsh7th/nvim-cmp'}

  -- Git DiffView
  use "sindrets/diffview.nvim" 


  require('cmp').setup {
  sources = {
    { name = 'cmp_tabnine' },
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
    { name = 'path' },
    -- ... (your other completion sources)
  },
}

  -- Friendly Snippets
  use 'rafamadriz/friendly-snippetscmp_tabnine'

  -- Trouble Plugin
  use {
    'folke/trouble.nvim',
    requires = {'nvim-tree/nvim-web-devicons'},
    config = function()
      -- your configuration comes here
      -- or leave it empty to use the default settings
      require("trouble").setup {
        -- Example configuration:
        -- auto_preview = false,
        -- use_diagnostic_signs = true
      }
    end
  }


  -- Telescope
  use {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.6', -- Specifies the version of the Telescope plugin to use
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
  -- Add other plugins here

-- Setup mason (manages installation of LSP servers, DAP servers, linters, and formatters)
require('mason').setup()

-- Setup mason-lspconfig (bridges mason and nvim-lspconfig)
require('mason-lspconfig').setup({
    -- List of LSP servers to automatically install
    ensure_installed = {'pyright', 'rust_analyzer', 'tsserver', 
    },
    -- Automatically install LSP servers without prompt
    automatic_installation = true,
})


-- Lsp-zero setup
require('lsp-zero').preset('recommended')
-- Optionally add or override LSP server settings
require('lsp-zero').setup({
    -- Customizations or additional LSP settings can be added here
    -- Example: configuring diagnostics display
    diagnostics = {
        virtual_text = true,
        signs = true,
        underline = true,
    },
    -- Enable additional features like auto-completion, snippet support, etc.
    completion = {
        autocomplete = true,
    },
})


        -- Ensure packer compiles when changes are made to your plugins
    if packer_bootstrap then
        require('packer').sync()
    end



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

    -- LSP_Zero
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        requires = {
            --- Uncomment the two plugins below if you want to manage the language servers from neovim
             {'williamboman/mason.nvim'},
             {'williamboman/mason-lspconfig.nvim'},
             {'neovim/nvim-lspconfig'},

            {'neovim/nvim-lspconfig'},
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'L3MON4D3/LuaSnip'},
        }
    }
   
    -- Mason LSP Configuration
use 'williamboman/mason.nvim'
use 'williamboman/mason-lspconfig.nvim'
use 'neovim/nvim-lspconfig'

-- Notify Plugin Configuration
use 'rcarriga/nvim-notify'

    -- Rest of the Plugins
    use 'laytan/cloak.nvim'

      -- Rust-specific plugins
  use 'simrat39/rust-tools.nvim'
  use 'saecki/crates.nvim'

    -- Additional LSP enhancements
  use 'glepnir/lspsaga.nvim'
  use 'onsails/lspkind-nvim'
  use 'kosayoda/nvim-lightbulb'


  -- LSP and completion setup
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = {'rust_analyzer', 'pyright', 'tsserver'},
  automatic_installation = true,
})

local lsp = require('lsp-zero').preset('recommended')

lsp.on_attach(function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
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
require('crates').setup()

-- Configure LSP Saga
require('lspsaga').setup({
  -- customize LSP Saga settings here
})

-- Setup nvim-lightbulb
require('nvim-lightbulb').setup({
  -- customize lightbulb settings here
})


 -- Bash-specific plugins
  use 'vim-scripts/bats.vim'  -- Syntax highlighting for Bats (Bash Automated Testing System)
  use 'chrisbra/vim-sh-indent'  -- Better indentation for shell scripts
  use 'arzg/vim-sh'  -- Better syntax highlighting for shell scripts

  -- Markdown-specific plugins
  use({
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
  })
  use 'preservim/vim-markdown'  -- Markdown syntax highlighting and more
  use 'dhruvasagar/vim-table-mode'  -- Easy table creation in Markdown
  use 'junegunn/limelight.vim'  -- Hyperfocus-writing in Vim
  use 'junegunn/goyo.vim'  -- Distraction-free writing in Vim

  -- Additional LSP and completion plugins
  use 'mfussenegger/nvim-lint'  -- Linter
  use 'mhartington/formatter.nvim'  -- Formatter

  -- Markdown-specific optimizations
use {
  'markdown-enhancements',
  requires = {
    -- Markdown Preview in the browser
    {
      "iamcco/markdown-preview.nvim",
      run = function() vim.fn["mkdp#util#install"]() end,
    },
    -- Enhanced Markdown syntax highlighting and features
    'preservim/vim-markdown',
    -- Easy table creation and formatting
    'dhruvasagar/vim-table-mode',
    -- Distraction-free writing
    'junegunn/goyo.vim',
    -- Hyperfocus writing
    'junegunn/limelight.vim',
  },
  config = function()
    -- Markdown configuration
    vim.g.vim_markdown_folding_disabled = 1
    vim.g.vim_markdown_frontmatter = 1
    vim.g.vim_markdown_conceal = 0
    vim.g.vim_markdown_fenced_languages = {
      'bash=sh', 'javascript', 'js=javascript', 'json=javascript',
      'typescript', 'ts=typescript', 'php', 'html', 'css', 'rust'
    }

    -- Table mode configuration
    vim.g.table_mode_corner = '|'

    -- Limelight configuration
    vim.g.limelight_conceal_ctermfg = 'gray'
    vim.g.limelight_conceal_guifg = 'DarkGray'

    -- Goyo and Limelight integration
    vim.cmd[[
      autocmd! User GoyoEnter Limelight
      autocmd! User GoyoLeave Limelight!
    ]]

    -- Key mappings for Markdown features
    vim.api.nvim_set_keymap('n', '<leader>mp', ':MarkdownPreview<CR>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '<leader>ms', ':MarkdownPreviewStop<CR>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '<leader>mt', ':TableModeToggle<CR>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '<leader>mf', ':Goyo<CR>', {noremap = true, silent = true})

    -- Markdown LSP setup (if you're using nvim-lspconfig)
    require('lspconfig').marksman.setup{}

    -- Linter setup for Markdown (if you're using nvim-lint)
    require('lint').linters_by_ft = {
      markdown = {'markdownlint'},
    }

    -- Auto-lint on save
    vim.cmd [[
      autocmd BufWritePost *.md lua require('lint').try_lint()
    ]]

    -- Formatter setup for Markdown (if you're using formatter.nvim)
    require('formatter').setup({
      filetype = {
        markdown = {
          function()
            return {
              exe = "prettier",
              args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), '--parser', 'markdown'},
              stdin = true
            }
          end
        },
      }
    })

    -- Auto-format on save
    vim.cmd [[
      autocmd BufWritePost *.md FormatWrite
    ]]
  end
}

-- Add this to the end of your packer.lua file

-- CmpTabnine Setup
use {'tzachar/cmp-tabnine', run='./install.sh', requires = 'hrsh7th/nvim-cmp'}

-- Ensure this is after your plugin declarations
require('cmp_tabnine.config'):setup({
  max_lines = 1000,
  max_num_results = 20,
  sort = true,
  run_on_every_keystroke = true,
  snippet_placeholder = '..',
  ignored_file_types = {
    -- Define filetypes to ignore here
  },
  show_prediction_strength = false
})

-- Update your existing cmp setup or add this if you don't have one
local cmp = require('cmp')
local lspkind = require('lspkind')

cmp.setup({
  sources = cmp.config.sources({
    { name = 'cmp_tabnine' },
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
    -- other sources...
  }),
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text',
      maxwidth = 50,
      before = function (entry, vim_item)
        if entry.source.name == 'cmp_tabnine' then
          vim_item.kind = '🤖'
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

-- Optional: Add a specific mapping for TabNine completion
vim.api.nvim_set_keymap('i', '<C-t>', [[<Cmd>lua require('cmp').complete({config = { sources = { { name = 'cmp_tabnine' } }}})<CR>]], { noremap = true, silent = true })

-- End of CmpTabnine configuration


end)


