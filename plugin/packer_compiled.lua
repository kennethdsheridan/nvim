-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

_G._packer = _G._packer or {}
_G._packer.inside_compile = true

local time
local profile_info
local should_profile = false
if should_profile then
  local hrtime = vim.loop.hrtime
  profile_info = {}
  time = function(chunk, start)
    if start then
      profile_info[chunk] = hrtime()
    else
      profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
    end
  end
else
  time = function(chunk, start) end
end

local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end
  if threshold then
    table.insert(results, '(Only showing plugins that took longer than ' .. threshold .. ' ms ' .. 'to load)')
  end

  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/kennethsheridan/.cache/nvim/packer_hererocks/2.1.1692716794/share/lua/5.1/?.lua;/Users/kennethsheridan/.cache/nvim/packer_hererocks/2.1.1692716794/share/lua/5.1/?/init.lua;/Users/kennethsheridan/.cache/nvim/packer_hererocks/2.1.1692716794/lib/luarocks/rocks-5.1/?.lua;/Users/kennethsheridan/.cache/nvim/packer_hererocks/2.1.1692716794/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/kennethsheridan/.cache/nvim/packer_hererocks/2.1.1692716794/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  LuaSnip = {
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["bats.vim"] = {
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/bats.vim",
    url = "https://github.com/vim-scripts/bats.vim"
  },
  ["cloak.nvim"] = {
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/cloak.nvim",
    url = "https://github.com/laytan/cloak.nvim"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-tabnine"] = {
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/cmp-tabnine",
    url = "https://github.com/tzachar/cmp-tabnine"
  },
  ["crates.nvim"] = {
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/crates.nvim",
    url = "https://github.com/saecki/crates.nvim"
  },
  ["diffview.nvim"] = {
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/diffview.nvim",
    url = "https://github.com/sindrets/diffview.nvim"
  },
  ["formatter.nvim"] = {
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/formatter.nvim",
    url = "https://github.com/mhartington/formatter.nvim"
  },
  ["friendly-snippetscmp_tabnine"] = {
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/friendly-snippetscmp_tabnine",
    url = "https://github.com/rafamadriz/friendly-snippetscmp_tabnine"
  },
  ["goyo.vim"] = {
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/goyo.vim",
    url = "https://github.com/junegunn/goyo.vim"
  },
  harpoon = {
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/harpoon",
    url = "https://github.com/theprimeagen/harpoon"
  },
  ["limelight.vim"] = {
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/limelight.vim",
    url = "https://github.com/junegunn/limelight.vim"
  },
  ["lsp-zero.nvim"] = {
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/lsp-zero.nvim",
    url = "https://github.com/VonHeikemen/lsp-zero.nvim"
  },
  ["lspkind-nvim"] = {
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/lspkind-nvim",
    url = "https://github.com/onsails/lspkind-nvim"
  },
  ["lspsaga.nvim"] = {
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/lspsaga.nvim",
    url = "https://github.com/glepnir/lspsaga.nvim"
  },
  ["markdown-enhancements"] = {
    config = { "\27LJ\2\n�\1\0\0\5\0\6\0\n5\0\0\0005\1\1\0006\2\2\0009\2\3\0029\2\4\2)\4\0\0B\2\2\2>\2\2\1=\1\5\0L\0\2\0\targs\22nvim_buf_get_name\bapi\bvim\1\5\0\0\21--stdin-filepath\0\r--parser\rmarkdown\1\0\2\nstdin\2\bexe\rprettier�\t\1\0\6\0.\0c6\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\3\0006\0\0\0009\0\1\0)\1\0\0=\1\4\0006\0\0\0009\0\1\0005\1\6\0=\1\5\0006\0\0\0009\0\1\0'\1\b\0=\1\a\0006\0\0\0009\0\1\0'\1\n\0=\1\t\0006\0\0\0009\0\1\0'\1\f\0=\1\v\0006\0\0\0009\0\r\0'\2\14\0B\0\2\0016\0\0\0009\0\15\0009\0\16\0'\2\17\0'\3\18\0'\4\19\0005\5\20\0B\0\5\0016\0\0\0009\0\15\0009\0\16\0'\2\17\0'\3\21\0'\4\22\0005\5\23\0B\0\5\0016\0\0\0009\0\15\0009\0\16\0'\2\17\0'\3\24\0'\4\25\0005\5\26\0B\0\5\0016\0\0\0009\0\15\0009\0\16\0'\2\17\0'\3\27\0'\4\28\0005\5\29\0B\0\5\0016\0\30\0'\2\31\0B\0\2\0029\0 \0009\0!\0004\2\0\0B\0\2\0016\0\30\0'\2\"\0B\0\2\0025\1%\0005\2$\0=\2&\1=\1#\0006\0\0\0009\0\r\0'\2'\0B\0\2\0016\0\30\0'\2(\0B\0\2\0029\0!\0005\2+\0005\3*\0004\4\3\0003\5)\0>\5\1\4=\4&\3=\3,\2B\0\2\0016\0\0\0009\0\r\0'\2-\0B\0\2\1K\0\1\0005      autocmd BufWritePost *.md FormatWrite\n    \rfiletype\1\0\0\1\0\0\0\14formatterH      autocmd BufWritePost *.md lua require('lint').try_lint()\n    \rmarkdown\1\0\0\1\2\0\0\17markdownlint\18linters_by_ft\tlint\nsetup\rmarksman\14lspconfig\frequire\1\0\2\fnoremap\2\vsilent\2\14:Goyo<CR>\15<leader>mf\1\0\2\fnoremap\2\vsilent\2\25:TableModeToggle<CR>\15<leader>mt\1\0\2\fnoremap\2\vsilent\2\29:MarkdownPreviewStop<CR>\15<leader>ms\1\0\2\fnoremap\2\vsilent\2\25:MarkdownPreview<CR>\15<leader>mp\6n\20nvim_set_keymap\bapiZ      autocmd! User GoyoEnter Limelight\n      autocmd! User GoyoLeave Limelight!\n    \bcmd\rDarkGray\28limelight_conceal_guifg\tgray\30limelight_conceal_ctermfg\6|\22table_mode_corner\1\v\0\0\fbash=sh\15javascript\18js=javascript\20json=javascript\15typescript\18ts=typescript\bphp\thtml\bcss\trust\"vim_markdown_fenced_languages\25vim_markdown_conceal\29vim_markdown_frontmatter\"vim_markdown_folding_disabled\6g\bvim\0" },
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/markdown-enhancements",
    url = "https://github.com/markdown-enhancements"
  },
  ["markdown-preview.nvim"] = {
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/markdown-preview.nvim",
    url = "https://github.com/iamcco/markdown-preview.nvim"
  },
  ["mason-lspconfig.nvim"] = {
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/mason-lspconfig.nvim",
    url = "https://github.com/williamboman/mason-lspconfig.nvim"
  },
  ["mason.nvim"] = {
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/mason.nvim",
    url = "https://github.com/williamboman/mason.nvim"
  },
  ["nightfox.nvim"] = {
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/nightfox.nvim",
    url = "https://github.com/EdenEast/nightfox.nvim"
  },
  ["noice.nvim"] = {
    config = { "\27LJ\2\n3\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\nnoice\frequire\0" },
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/noice.nvim",
    url = "https://github.com/folke/noice.nvim"
  },
  ["nui.nvim"] = {
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/nui.nvim",
    url = "https://github.com/MunifTanjim/nui.nvim"
  },
  ["nvim-cmp"] = {
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-lightbulb"] = {
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/nvim-lightbulb",
    url = "https://github.com/kosayoda/nvim-lightbulb"
  },
  ["nvim-lint"] = {
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/nvim-lint",
    url = "https://github.com/mfussenegger/nvim-lint"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-notify"] = {
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/nvim-notify",
    url = "https://github.com/rcarriga/nvim-notify"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/nvim-tree/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  playground = {
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/playground",
    url = "https://github.com/nvim-treesitter/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["rust-tools.nvim"] = {
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/rust-tools.nvim",
    url = "https://github.com/simrat39/rust-tools.nvim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["trouble.nvim"] = {
    config = { "\27LJ\2\n9\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\ftrouble\frequire\0" },
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/trouble.nvim",
    url = "https://github.com/folke/trouble.nvim"
  },
  undotree = {
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/undotree",
    url = "https://github.com/mbbill/undotree"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-markdown"] = {
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/vim-markdown",
    url = "https://github.com/preservim/vim-markdown"
  },
  ["vim-sh"] = {
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/vim-sh",
    url = "https://github.com/arzg/vim-sh"
  },
  ["vim-sh-indent"] = {
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/vim-sh-indent",
    url = "https://github.com/chrisbra/vim-sh-indent"
  },
  ["vim-table-mode"] = {
    loaded = true,
    path = "/Users/kennethsheridan/.local/share/nvim/site/pack/packer/start/vim-table-mode",
    url = "https://github.com/dhruvasagar/vim-table-mode"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: noice.nvim
time([[Config for noice.nvim]], true)
try_loadstring("\27LJ\2\n3\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\nnoice\frequire\0", "config", "noice.nvim")
time([[Config for noice.nvim]], false)
-- Config for: trouble.nvim
time([[Config for trouble.nvim]], true)
try_loadstring("\27LJ\2\n9\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\ftrouble\frequire\0", "config", "trouble.nvim")
time([[Config for trouble.nvim]], false)
-- Config for: markdown-enhancements
time([[Config for markdown-enhancements]], true)
try_loadstring("\27LJ\2\n�\1\0\0\5\0\6\0\n5\0\0\0005\1\1\0006\2\2\0009\2\3\0029\2\4\2)\4\0\0B\2\2\2>\2\2\1=\1\5\0L\0\2\0\targs\22nvim_buf_get_name\bapi\bvim\1\5\0\0\21--stdin-filepath\0\r--parser\rmarkdown\1\0\2\nstdin\2\bexe\rprettier�\t\1\0\6\0.\0c6\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\3\0006\0\0\0009\0\1\0)\1\0\0=\1\4\0006\0\0\0009\0\1\0005\1\6\0=\1\5\0006\0\0\0009\0\1\0'\1\b\0=\1\a\0006\0\0\0009\0\1\0'\1\n\0=\1\t\0006\0\0\0009\0\1\0'\1\f\0=\1\v\0006\0\0\0009\0\r\0'\2\14\0B\0\2\0016\0\0\0009\0\15\0009\0\16\0'\2\17\0'\3\18\0'\4\19\0005\5\20\0B\0\5\0016\0\0\0009\0\15\0009\0\16\0'\2\17\0'\3\21\0'\4\22\0005\5\23\0B\0\5\0016\0\0\0009\0\15\0009\0\16\0'\2\17\0'\3\24\0'\4\25\0005\5\26\0B\0\5\0016\0\0\0009\0\15\0009\0\16\0'\2\17\0'\3\27\0'\4\28\0005\5\29\0B\0\5\0016\0\30\0'\2\31\0B\0\2\0029\0 \0009\0!\0004\2\0\0B\0\2\0016\0\30\0'\2\"\0B\0\2\0025\1%\0005\2$\0=\2&\1=\1#\0006\0\0\0009\0\r\0'\2'\0B\0\2\0016\0\30\0'\2(\0B\0\2\0029\0!\0005\2+\0005\3*\0004\4\3\0003\5)\0>\5\1\4=\4&\3=\3,\2B\0\2\0016\0\0\0009\0\r\0'\2-\0B\0\2\1K\0\1\0005      autocmd BufWritePost *.md FormatWrite\n    \rfiletype\1\0\0\1\0\0\0\14formatterH      autocmd BufWritePost *.md lua require('lint').try_lint()\n    \rmarkdown\1\0\0\1\2\0\0\17markdownlint\18linters_by_ft\tlint\nsetup\rmarksman\14lspconfig\frequire\1\0\2\fnoremap\2\vsilent\2\14:Goyo<CR>\15<leader>mf\1\0\2\fnoremap\2\vsilent\2\25:TableModeToggle<CR>\15<leader>mt\1\0\2\fnoremap\2\vsilent\2\29:MarkdownPreviewStop<CR>\15<leader>ms\1\0\2\fnoremap\2\vsilent\2\25:MarkdownPreview<CR>\15<leader>mp\6n\20nvim_set_keymap\bapiZ      autocmd! User GoyoEnter Limelight\n      autocmd! User GoyoLeave Limelight!\n    \bcmd\rDarkGray\28limelight_conceal_guifg\tgray\30limelight_conceal_ctermfg\6|\22table_mode_corner\1\v\0\0\fbash=sh\15javascript\18js=javascript\20json=javascript\15typescript\18ts=typescript\bphp\thtml\bcss\trust\"vim_markdown_fenced_languages\25vim_markdown_conceal\29vim_markdown_frontmatter\"vim_markdown_folding_disabled\6g\bvim\0", "config", "markdown-enhancements")
time([[Config for markdown-enhancements]], false)

_G._packer.inside_compile = false
if _G._packer.needs_bufread == true then
  vim.cmd("doautocmd BufRead")
end
_G._packer.needs_bufread = false

if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
