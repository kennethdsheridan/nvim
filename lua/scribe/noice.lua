require('noice').setup({
  routes = {
    { filter = { event = "msg_show", kind = "" }, opts = { skip = true } },
    -- More route filters can be added here
  },
  views = {
    cmdline = { position = "bottom", size = { height = "1" } },
    popupmenu = { relative = "editor", position = { row = "10%", col = "50%" } },
    -- More views can be added here
  },
  cmdline = {
    icons = {
      ["/"] = { icon = "", hl_group = "DiagnosticWarn", firstc = false },
      [":"] = { icon = "", hl_group = "DiagnosticInfo", firstc = false },
      -- More cmdline icons can be added here
    },
  },
  notify = {
    -- Use nvim-notify for notifications
    enabled = true,
    view = "notify",
  },
})
