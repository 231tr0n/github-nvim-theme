local lualine = require('github-theme.plugins.lualine')

local c = require('github-theme.palette').setup({ theme_style = 'light' })
return lualine.build_lualine_theme(c)
