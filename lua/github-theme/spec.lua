local collect = require('github-theme.lib.collect')
local template = require('github-theme.util.template')

--#region Types

---@class Spec
---@field bg0 string
---@field bg1 string
---@field bg2 string
---@field bg3 string
---@field bg4 string
---@field fg0 string
---@field fg1 string
---@field fg2 string
---@field fg3 string
---@field sel0 string
---@field sel1 string
---@field sel3 string
---@field syntax SpecSyntax

---@class SpecSyntax
---@field bracket string
---@field builtin0 string
---@field builtin1 string
---@field builtin2 string
---@field builtin3 string
---@field comment string
---@field conditional string
---@field const string
---@field dep string
---@field field string
---@field func string
---@field ident string
---@field keyword string
---@field operator string
---@field preproc string
---@field regex string
---@field statement string
---@field string string
---@field type string
---@field variable string

--#endregion

local M = {}

local function override(spec, palette, ovr)
  ovr = template.parse(ovr, palette)
  return collect.deep_extend(spec, ovr)
end

function M.load(name)
  local ovr = require('github-theme.override').specs

  local function apply_ovr(key, spec, palette)
    return ovr[key] and override(spec, palette, ovr[key]) or spec
  end

  if name then
    local palette = require('github-theme.palette').load(name)
    local spec = palette.generate_spec(palette)
    spec = apply_ovr('all', spec, palette)
    spec = apply_ovr(name, spec, palette)
    spec.palette = palette
    return spec
  else
    local result = {}
    local themes = require('github-theme.palette').themes
    for n, mod in pairs(themes) do
      local palette = require('github-theme.palette').load(mod)
      local spec = palette.generate_spec(palette)
      spec = apply_ovr('all', spec, palette)
      spec = apply_ovr(n, spec, palette)
      spec.palette = palette
      result[n] = spec
    end

    -- TODO: Use comment code after renaming palette modules.
    -- for _, mod in ipairs(themes) do
    --   local palette = require('github-theme.palette').load(mod)
    --   local spec = palette.generate_spec(palette)
    --   spec = apply_ovr('all', spec, palette)
    --   spec = apply_ovr(mod, spec, palette)
    --   spec.palette = palette
    --   result[mod] = spec
    -- end
    return result
  end
end

return M
