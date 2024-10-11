local pluginConfs = require "configs"
local M = {}

M.plugins = {
    user = require "om.plugins",
    override = {
        ["hrsh7th/nvim-cmp"] = pluginConfs.cmp,
        ["tzachar/cmp-tabnine"] = pluginConfs.tabnine
    }
}
