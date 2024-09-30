local cmp = require('cmp')
cmp.setup({
  -- ... other configuration ...

  sources = {
    -- ... other sources ...
    { name = 'cmp_tabnine' },
  },
    mapping = {
        ['<Tab>'] = cmp.mapping.confirm({ select = true }),
    },
})

require('cmp_tabnine.config'):setup({
  disable_auto_comment = true,
  accept_keymap = '<Tab>',
  debounce_ms = 800,
  max_lines = 1000,
  max_num_results = 20,
  sort = true,
  run_on_every_keystroke = true,
  snippet_placeholder = '..',
  ignored_file_types = {
    -- default is not to ignore
    -- uncomment to ignore in lua:
    -- lua = true
  },
  show_prediction_strength = false
})

