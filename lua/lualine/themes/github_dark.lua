local lualine = require('github-theme.plugins.lualine')

local c = require('github-theme.palette.dark')()
return lualine.build_lualine_theme(c)
