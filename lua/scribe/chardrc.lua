local pluginConfs = require "configs"
local M = {}

M.plugins = {
    user = require "om.plugins",
    override = {
        -- DISABLED: ["hrsh7th/nvim-cmp"] = pluginConfs.cmp,
        -- DISABLED: ["tzachar/cmp-tabnine"] = pluginConfs.tabnine
    }
}
