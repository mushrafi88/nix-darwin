--- Plugin Manager ---
require(".lazy")
require('gitsigns').setup()

--- Colorschemes ---
vim.cmd("runtime! lua/plugins/colorschemes/*.lua")

--- All Core Files ---
vim.cmd("runtime! lua/core/*.lua")

--- All  Other Plugins ---
vim.cmd("runtime! lua/plugins/*.lua")

