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
local package_path_str = "/Users/kennysheridan/.cache/nvim/packer_hererocks/2.1.1727870382/share/lua/5.1/?.lua;/Users/kennysheridan/.cache/nvim/packer_hererocks/2.1.1727870382/share/lua/5.1/?/init.lua;/Users/kennysheridan/.cache/nvim/packer_hererocks/2.1.1727870382/lib/luarocks/rocks-5.1/?.lua;/Users/kennysheridan/.cache/nvim/packer_hererocks/2.1.1727870382/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/kennysheridan/.cache/nvim/packer_hererocks/2.1.1727870382/lib/lua/5.1/?.so"
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
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["bats.vim"] = {
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/bats.vim",
    url = "https://github.com/vim-scripts/bats.vim"
  },
  ["cloak.nvim"] = {
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/cloak.nvim",
    url = "https://github.com/laytan/cloak.nvim"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-nvim-lsp-signature-help"] = {
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp-signature-help",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp-signature-help"
  },
  ["crates.nvim"] = {
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/crates.nvim",
    url = "https://github.com/saecki/crates.nvim"
  },
  ["diffview.nvim"] = {
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/diffview.nvim",
    url = "https://github.com/sindrets/diffview.nvim"
  },
  ["formatter.nvim"] = {
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/formatter.nvim",
    url = "https://github.com/mhartington/formatter.nvim"
  },
  ["friendly-snippets"] = {
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/friendly-snippets",
    url = "https://github.com/rafamadriz/friendly-snippets"
  },
  ["goyo.vim"] = {
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/goyo.vim",
    url = "https://github.com/junegunn/goyo.vim"
  },
  harpoon = {
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/harpoon",
    url = "https://github.com/theprimeagen/harpoon"
  },
  ["limelight.vim"] = {
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/limelight.vim",
    url = "https://github.com/junegunn/limelight.vim"
  },
  ["lsp-zero.nvim"] = {
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/lsp-zero.nvim",
    url = "https://github.com/VonHeikemen/lsp-zero.nvim"
  },
  ["lspkind-nvim"] = {
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/lspkind-nvim",
    url = "https://github.com/onsails/lspkind-nvim"
  },
  ["lspsaga.nvim"] = {
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/lspsaga.nvim",
    url = "https://github.com/glepnir/lspsaga.nvim"
  },
  ["markdown-preview.nvim"] = {
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/markdown-preview.nvim",
    url = "https://github.com/iamcco/markdown-preview.nvim"
  },
  ["mason-lspconfig.nvim"] = {
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/mason-lspconfig.nvim",
    url = "https://github.com/williamboman/mason-lspconfig.nvim"
  },
  ["mason.nvim"] = {
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/mason.nvim",
    url = "https://github.com/williamboman/mason.nvim"
  },
  ["neo-tree.nvim"] = {
    config = { "\27LJ\2\n›\2\0\0\6\0\f\0\0156\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\n\0005\3\b\0005\4\3\0005\5\4\0=\5\5\0045\5\6\0=\5\a\4=\4\t\3=\3\v\2B\0\2\1K\0\1\0\15filesystem\1\0\1\15filesystem\0\19filtered_items\1\0\1\19filtered_items\0\15never_show\1\3\0\0\14.DS_Store\14thumbs.db\17hide_by_name\1\3\0\0\14.DS_Store\14thumbs.db\1\0\4\15never_show\0\17hide_by_name\0\20hide_gitignored\1\18hide_dotfiles\1\nsetup\rneo-tree\frequire\0" },
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/neo-tree.nvim",
    url = "https://github.com/nvim-neo-tree/neo-tree.nvim"
  },
  ["nightfox.nvim"] = {
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/nightfox.nvim",
    url = "https://github.com/EdenEast/nightfox.nvim"
  },
  ["noice.nvim"] = {
    config = { "\27LJ\2\n3\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\nnoice\frequire\0" },
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/noice.nvim",
    url = "https://github.com/folke/noice.nvim"
  },
  ["nui.nvim"] = {
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/nui.nvim",
    url = "https://github.com/MunifTanjim/nui.nvim"
  },
  ["nvim-cmp"] = {
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-dap"] = {
    config = { "\27LJ\2\nË\2\0\0\t\0\15\1&6\0\0\0009\0\1\0009\0\2\0'\2\3\0B\0\2\0026\1\0\0009\1\1\0019\1\4\1\18\3\0\0B\1\2\0029\2\5\1:\2\1\0029\2\6\2:\2\1\0029\2\a\2'\3\b\0\18\4\2\0&\3\4\0036\4\0\0009\4\1\0049\4\t\4\18\6\3\0B\4\2\2\t\4\0\0X\4\1€L\3\2\0006\4\0\0009\4\1\0049\4\n\4'\6\v\0006\a\0\0009\a\1\a9\a\f\aB\a\1\2'\b\r\0&\a\b\a'\b\14\0D\4\4\0\tfile\19/target/debug/\vgetcwd\25Path to executable: \ninput\15executable\18target/debug/\tname\ftargets\rpackages\16json_decode0cargo metadata --format-version 1 --no-deps\vsystem\afn\bvim\2X\0\0\6\0\6\0\f6\0\0\0009\0\1\0009\0\2\0'\2\3\0B\0\2\0026\1\0\0009\1\1\0019\1\4\1\18\3\0\0'\4\5\0+\5\2\0D\1\4\0\6 \nsplit\16Arguments: \ninput\afn\bvim”\2\0\0\n\0\14\0\0296\0\0\0009\0\1\0009\0\2\0'\2\3\0B\0\2\0026\1\0\0009\1\1\0019\1\4\1\18\3\0\0B\1\2\0029\2\5\1:\2\1\0029\2\6\2:\2\1\0029\2\a\0026\3\0\0009\3\1\0039\3\b\3'\5\t\0006\6\0\0009\6\1\0069\6\n\6B\6\1\2'\a\v\0\18\b\2\0'\t\f\0&\6\t\6'\a\r\0D\3\4\0\tfile\6-\19/target/debug/\vgetcwd\30Path to test executable: \ninput\tname\ftargets\rpackages\16json_decode0cargo metadata --format-version 1 --no-deps\vsystem\afn\bvimX\0\0\6\0\6\0\f6\0\0\0009\0\1\0009\0\2\0'\2\3\0B\0\2\0026\1\0\0009\1\1\0019\1\4\1\18\3\0\0'\4\5\0+\5\2\0D\1\4\0\6 \nsplit\16Arguments: \ninput\afn\bvim\30\0\0\2\1\1\0\4-\0\0\0009\0\0\0B\0\1\1K\0\1\0\1À\topen\31\0\0\2\1\1\0\4-\0\0\0009\0\0\0B\0\1\1K\0\1\0\1À\nclose\31\0\0\2\1\1\0\4-\0\0\0009\0\0\0B\0\1\1K\0\1\0\1À\ncloseË\5\1\0\b\0\31\00036\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0029\2\3\0015\4\t\0004\5\3\0005\6\5\0005\a\4\0=\a\6\6>\6\1\0055\6\b\0005\a\a\0=\a\6\6>\6\2\5=\5\n\4B\2\2\0019\2\v\0004\3\3\0005\4\r\0003\5\14\0=\5\15\0043\5\16\0=\5\17\4>\4\1\0035\4\18\0003\5\19\0=\5\15\0043\5\20\0=\5\17\4>\4\2\3=\3\f\0029\2\21\0009\2\22\0029\2\23\0023\3\25\0=\3\24\0029\2\21\0009\2\26\0029\2\27\0023\3\28\0=\3\24\0029\2\21\0009\2\26\0029\2\29\0023\3\30\0=\3\24\0022\0\0€K\0\1\0\0\17event_exited\0\21event_terminated\vbefore\0\17dapui_config\22event_initialized\nafter\14listeners\0\0\1\0\a\16stopOnEntry\1\frequest\vlaunch\targs\0\ttype\frt_lldb\bcwd\23${workspaceFolder}\fprogram\0\tname\21Debug Rust Tests\targs\0\fprogram\0\1\0\a\16stopOnEntry\1\frequest\vlaunch\targs\0\ttype\frt_lldb\bcwd\23${workspaceFolder}\fprogram\0\tname\15Debug Rust\trust\19configurations\flayouts\1\0\1\flayouts\0\1\0\3\rposition\vbottom\tsize\3\n\relements\0\1\3\0\0\trepl\fconsole\relements\1\0\3\rposition\tleft\tsize\3(\relements\0\1\5\0\0\vscopes\16breakpoints\vstacks\fwatches\nsetup\ndapui\bdap\frequire\0" },
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/nvim-dap",
    url = "https://github.com/mfussenegger/nvim-dap"
  },
  ["nvim-dap-ui"] = {
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/nvim-dap-ui",
    url = "https://github.com/rcarriga/nvim-dap-ui"
  },
  ["nvim-lightbulb"] = {
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/nvim-lightbulb",
    url = "https://github.com/kosayoda/nvim-lightbulb"
  },
  ["nvim-lint"] = {
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/nvim-lint",
    url = "https://github.com/mfussenegger/nvim-lint"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-nio"] = {
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/nvim-nio",
    url = "https://github.com/nvim-neotest/nvim-nio"
  },
  ["nvim-notify"] = {
    config = { "\27LJ\2\nU\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\22background_colour\f#000000\nsetup\vnotify\frequire\0" },
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/nvim-notify",
    url = "https://github.com/rcarriga/nvim-notify"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/nvim-tree/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  playground = {
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/playground",
    url = "https://github.com/nvim-treesitter/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["rust-tools.nvim"] = {
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/rust-tools.nvim",
    url = "https://github.com/simrat39/rust-tools.nvim"
  },
  rustaceanvim = {
    config = { "\27LJ\2\nç\3\0\0\r\0\25\0(6\0\0\0'\2\1\0B\0\2\0029\1\2\0'\3\3\0B\1\2\2\18\4\1\0009\2\4\1B\2\2\2'\3\5\0&\2\3\2\18\3\2\0'\4\6\0&\3\4\3\18\4\2\0'\5\a\0&\4\5\0046\5\0\0'\a\b\0B\5\2\0026\6\t\0009\6\n\0065\a\15\0005\b\r\0009\t\f\5\18\v\3\0\18\f\4\0B\t\3\2=\t\14\b=\b\16\a5\b\22\0005\t\20\0005\n\18\0005\v\17\0=\v\19\n=\n\21\t=\t\23\b=\b\24\a=\a\v\6K\0\1\0\vserver\rsettings\1\0\1\rsettings\0\18rust-analyzer\1\0\1\18rust-analyzer\0\16checkOnSave\1\0\1\16checkOnSave\0\1\0\1\fcommand\vclippy\bdap\1\0\2\vserver\0\bdap\0\fadapter\1\0\1\fadapter\0\25get_codelldb_adapter\17rustaceanvim\6g\bvim\24rustaceanvim.config\27lldb/lib/liblldb.dylib\21adapter/codelldb\16/extension/\21get_install_path\rcodelldb\16get_package\19mason-registry\frequire\0" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/opt/rustaceanvim",
    url = "https://github.com/mrcjkb/rustaceanvim"
  },
  ["tabnine-nvim"] = {
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/tabnine-nvim",
    url = "https://github.com/codota/tabnine-nvim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["trouble.nvim"] = {
    config = { "\27LJ\2\n9\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\ftrouble\frequire\0" },
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/trouble.nvim",
    url = "https://github.com/folke/trouble.nvim"
  },
  undotree = {
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/undotree",
    url = "https://github.com/mbbill/undotree"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-markdown"] = {
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/vim-markdown",
    url = "https://github.com/preservim/vim-markdown"
  },
  ["vim-sh"] = {
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/vim-sh",
    url = "https://github.com/arzg/vim-sh"
  },
  ["vim-sh-indent"] = {
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/vim-sh-indent",
    url = "https://github.com/chrisbra/vim-sh-indent"
  },
  ["vim-table-mode"] = {
    loaded = true,
    path = "/Users/kennysheridan/.local/share/nvim/site/pack/packer/start/vim-table-mode",
    url = "https://github.com/dhruvasagar/vim-table-mode"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: noice.nvim
time([[Config for noice.nvim]], true)
try_loadstring("\27LJ\2\n3\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\nnoice\frequire\0", "config", "noice.nvim")
time([[Config for noice.nvim]], false)
-- Config for: nvim-dap
time([[Config for nvim-dap]], true)
try_loadstring("\27LJ\2\nË\2\0\0\t\0\15\1&6\0\0\0009\0\1\0009\0\2\0'\2\3\0B\0\2\0026\1\0\0009\1\1\0019\1\4\1\18\3\0\0B\1\2\0029\2\5\1:\2\1\0029\2\6\2:\2\1\0029\2\a\2'\3\b\0\18\4\2\0&\3\4\0036\4\0\0009\4\1\0049\4\t\4\18\6\3\0B\4\2\2\t\4\0\0X\4\1€L\3\2\0006\4\0\0009\4\1\0049\4\n\4'\6\v\0006\a\0\0009\a\1\a9\a\f\aB\a\1\2'\b\r\0&\a\b\a'\b\14\0D\4\4\0\tfile\19/target/debug/\vgetcwd\25Path to executable: \ninput\15executable\18target/debug/\tname\ftargets\rpackages\16json_decode0cargo metadata --format-version 1 --no-deps\vsystem\afn\bvim\2X\0\0\6\0\6\0\f6\0\0\0009\0\1\0009\0\2\0'\2\3\0B\0\2\0026\1\0\0009\1\1\0019\1\4\1\18\3\0\0'\4\5\0+\5\2\0D\1\4\0\6 \nsplit\16Arguments: \ninput\afn\bvim”\2\0\0\n\0\14\0\0296\0\0\0009\0\1\0009\0\2\0'\2\3\0B\0\2\0026\1\0\0009\1\1\0019\1\4\1\18\3\0\0B\1\2\0029\2\5\1:\2\1\0029\2\6\2:\2\1\0029\2\a\0026\3\0\0009\3\1\0039\3\b\3'\5\t\0006\6\0\0009\6\1\0069\6\n\6B\6\1\2'\a\v\0\18\b\2\0'\t\f\0&\6\t\6'\a\r\0D\3\4\0\tfile\6-\19/target/debug/\vgetcwd\30Path to test executable: \ninput\tname\ftargets\rpackages\16json_decode0cargo metadata --format-version 1 --no-deps\vsystem\afn\bvimX\0\0\6\0\6\0\f6\0\0\0009\0\1\0009\0\2\0'\2\3\0B\0\2\0026\1\0\0009\1\1\0019\1\4\1\18\3\0\0'\4\5\0+\5\2\0D\1\4\0\6 \nsplit\16Arguments: \ninput\afn\bvim\30\0\0\2\1\1\0\4-\0\0\0009\0\0\0B\0\1\1K\0\1\0\1À\topen\31\0\0\2\1\1\0\4-\0\0\0009\0\0\0B\0\1\1K\0\1\0\1À\nclose\31\0\0\2\1\1\0\4-\0\0\0009\0\0\0B\0\1\1K\0\1\0\1À\ncloseË\5\1\0\b\0\31\00036\0\0\0'\2\1\0B\0\2\0026\1\0\0'\3\2\0B\1\2\0029\2\3\0015\4\t\0004\5\3\0005\6\5\0005\a\4\0=\a\6\6>\6\1\0055\6\b\0005\a\a\0=\a\6\6>\6\2\5=\5\n\4B\2\2\0019\2\v\0004\3\3\0005\4\r\0003\5\14\0=\5\15\0043\5\16\0=\5\17\4>\4\1\0035\4\18\0003\5\19\0=\5\15\0043\5\20\0=\5\17\4>\4\2\3=\3\f\0029\2\21\0009\2\22\0029\2\23\0023\3\25\0=\3\24\0029\2\21\0009\2\26\0029\2\27\0023\3\28\0=\3\24\0029\2\21\0009\2\26\0029\2\29\0023\3\30\0=\3\24\0022\0\0€K\0\1\0\0\17event_exited\0\21event_terminated\vbefore\0\17dapui_config\22event_initialized\nafter\14listeners\0\0\1\0\a\16stopOnEntry\1\frequest\vlaunch\targs\0\ttype\frt_lldb\bcwd\23${workspaceFolder}\fprogram\0\tname\21Debug Rust Tests\targs\0\fprogram\0\1\0\a\16stopOnEntry\1\frequest\vlaunch\targs\0\ttype\frt_lldb\bcwd\23${workspaceFolder}\fprogram\0\tname\15Debug Rust\trust\19configurations\flayouts\1\0\1\flayouts\0\1\0\3\rposition\vbottom\tsize\3\n\relements\0\1\3\0\0\trepl\fconsole\relements\1\0\3\rposition\tleft\tsize\3(\relements\0\1\5\0\0\vscopes\16breakpoints\vstacks\fwatches\nsetup\ndapui\bdap\frequire\0", "config", "nvim-dap")
time([[Config for nvim-dap]], false)
-- Config for: neo-tree.nvim
time([[Config for neo-tree.nvim]], true)
try_loadstring("\27LJ\2\n›\2\0\0\6\0\f\0\0156\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\n\0005\3\b\0005\4\3\0005\5\4\0=\5\5\0045\5\6\0=\5\a\4=\4\t\3=\3\v\2B\0\2\1K\0\1\0\15filesystem\1\0\1\15filesystem\0\19filtered_items\1\0\1\19filtered_items\0\15never_show\1\3\0\0\14.DS_Store\14thumbs.db\17hide_by_name\1\3\0\0\14.DS_Store\14thumbs.db\1\0\4\15never_show\0\17hide_by_name\0\20hide_gitignored\1\18hide_dotfiles\1\nsetup\rneo-tree\frequire\0", "config", "neo-tree.nvim")
time([[Config for neo-tree.nvim]], false)
-- Config for: trouble.nvim
time([[Config for trouble.nvim]], true)
try_loadstring("\27LJ\2\n9\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\ftrouble\frequire\0", "config", "trouble.nvim")
time([[Config for trouble.nvim]], false)
-- Config for: nvim-notify
time([[Config for nvim-notify]], true)
try_loadstring("\27LJ\2\nU\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\22background_colour\f#000000\nsetup\vnotify\frequire\0", "config", "nvim-notify")
time([[Config for nvim-notify]], false)
vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType rust ++once lua require("packer.load")({'rustaceanvim'}, { ft = "rust" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
vim.cmd("augroup END")

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
