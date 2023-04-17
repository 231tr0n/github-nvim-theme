local M = {}

local config = require('github-theme.config')
local theme = require('github-theme.theme')
local util = require('github-theme.util')
local dep = require('github-theme.util.deprecation')

local did_setup = false

function M.reset()
  require('github-theme.config').reset()
end

-- Avoid g:colors_name reloading
local lock = false

M.load = function(opts)
  if lock then
    return
  end

  if not did_setup then
    M.setup()
  end

  lock = true

  -- Load colorscheme
  local hi = theme.setup()

  --Setting
  if vim.fn.exists('syntax_on') then
    vim.cmd('syntax reset')
  end

  vim.o.termguicolors = true

  if
    config.theme == 'github_light'
    or config.theme == 'github_light_default'
    or config.theme == 'github_light_colorblind'
  then
    vim.o.background = 'light'
  else
    vim.o.background = 'dark'
  end

  vim.g.colors_name = config.theme

  -- override colors
  local overrides = config.options.overrides(hi.colors)

  util.apply_overrides(hi.base, overrides, config.options.dev)
  util.apply_overrides(hi.plugins, overrides, config.options.dev)

  --Load ColorScheme
  util.syntax(hi.base)
  require('github-theme.autocmds').set()
  util.terminal(hi.colors)
  util.syntax(hi.plugins)
  lock = false
end

M.setup = function(opts)
  did_setup = true
  opts = opts or {}

  local override = require('github-theme.override')

  -- TODO: Remove these individual conditions when migration
  -- from old config to 'opts.options' has been DONE.
  if opts.colors then
    config.set_options({ colors = opts.colors })
  end
  if opts.overrides then
    config.set_options({ overrides = opts.overrides })
  end
  if opts.dev then
    config.set_options({ dev = opts.dev })
  end

  -- New configs
  if opts.options then
    config.set_options(opts.options)
  end

  if opts.experiments and opts.experiments.new_palettes == true then
    if opts.palettes then
      override.palettes = opts.palettes
    end
    if opts.specs then
      override.specs = opts.specs
    end
  end

  dep.check_deprecation(opts)
end

return M
