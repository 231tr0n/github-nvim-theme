local lualine = require('github-theme.plugins.lualine')

local c = require('github-theme.palette.dark_default')()
return lualine.build_lualine_theme(c)
