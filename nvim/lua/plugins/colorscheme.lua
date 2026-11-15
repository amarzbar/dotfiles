-- Terminal-following theme.
-- Reads the palette from kitty's current theme at startup, so whatever theme
-- kitty uses (`kitty +kitten themes`), nvim matches it. Background is
-- transparent, so the terminal's own background always shows through.
-- Falls back to Cherry Midnight if the kitty theme can't be read.

local fallback = {
  background = "#101017", foreground = "#bdc3df",
  color0 = "#33333f", color1 = "#ff568e", color2 = "#64de83", color3 = "#efff73",
  color4 = "#73a9ff", color5 = "#946ff7", color6 = "#62c6da", color7 = "#dedeff",
  color8 = "#43435a", color9 = "#ff69a2", color10 = "#73de8a", color11 = "#f3ff85",
  color12 = "#85b6ff", color13 = "#a481f7", color14 = "#71c2d9", color15 = "#ebebff",
}

local function read_kitty()
  local t = vim.deepcopy(fallback)
  local f = io.open(vim.fn.expand("~/.config/kitty/current-theme.conf"), "r")
  if not f then return t end
  for line in f:lines() do
    local k, v = line:match("^%s*([%w_]+)%s+(#%x%x%x%x%x%x)")
    if k and t[k] then t[k] = v:lower() end
  end
  f:close()
  return t
end

-- mix two hex colors; amount = weight of `a`
local function blend(a, b, amount)
  local function rgb(h) return tonumber(h:sub(2, 3), 16), tonumber(h:sub(4, 5), 16), tonumber(h:sub(6, 7), 16) end
  local ar, ag, ab = rgb(a)
  local br, bg, bb = rgb(b)
  local function m(x, y) return math.floor(x * amount + y * (1 - amount) + 0.5) end
  return string.format("#%02x%02x%02x", m(ar, br), m(ag, bg), m(ab, bb))
end

local k = read_kitty()
local bg, fg = k.background, k.foreground
local p = {
  bg = bg,
  bg_alt = blend(fg, bg, 0.04),
  surface = blend(fg, bg, 0.08),
  surface2 = k.color0,
  muted = k.color8,
  comment = blend(fg, bg, 0.45),
  fg = fg,
  red = k.color1, pink = k.color9,
  green = k.color2, green_b = k.color10,
  yellow = k.color3,
  blue = k.color4, blue_b = k.color12,
  purple = k.color5, purple_b = k.color13,
  cyan = k.color6, cyan_b = k.color14,
}

return {
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night",
      transparent = true,
      cache = false, -- palette comes from kitty, don't serve stale highlights
      styles = { sidebars = "transparent", floats = "transparent" },
      on_colors = function(c)
        c.bg = p.bg
        c.bg_dark = p.bg
        c.bg_dark1 = p.bg
        c.bg_float = "NONE"
        c.bg_popup = p.bg_alt
        c.bg_sidebar = "NONE"
        c.bg_statusline = "NONE"
        c.bg_highlight = p.surface
        c.bg_visual = p.surface2
        c.bg_search = p.purple
        c.black = p.bg
        c.fg = p.fg
        c.fg_dark = p.fg
        c.fg_float = p.fg
        c.fg_sidebar = p.fg
        c.fg_gutter = p.muted
        c.comment = p.comment
        c.dark3 = p.muted
        c.dark5 = p.comment
        c.terminal_black = p.surface2
        c.border = p.surface2
        c.border_highlight = p.purple
        c.blue = p.blue
        c.blue0 = p.surface2
        c.blue1 = p.cyan_b
        c.blue2 = p.cyan
        c.blue5 = p.blue_b
        c.blue6 = p.cyan_b
        c.blue7 = p.surface2
        c.cyan = p.cyan
        c.teal = p.cyan_b
        c.green = p.green
        c.green1 = p.cyan
        c.green2 = p.green_b
        c.magenta = p.purple_b
        c.magenta2 = p.pink
        c.purple = p.purple
        c.orange = p.pink
        c.red = p.red
        c.red1 = p.red
        c.yellow = p.yellow
        c.git = { add = p.green, change = p.blue, delete = p.red, ignore = p.muted }
        c.error = p.red
        c.warning = p.yellow
        c.info = p.blue
        c.hint = p.cyan
        c.todo = p.blue
      end,
      on_highlights = function(hl)
        hl.CursorLineNr = { fg = p.pink, bold = true }
        hl.Visual = { bg = p.surface2 }
        hl.FloatBorder = { fg = p.purple, bg = "NONE" }
        hl.WinSeparator = { fg = p.surface2 }
        hl.StatusLine = { fg = p.fg, bg = "NONE" }
        hl.StatusLineNC = { fg = p.muted, bg = "NONE" }
        hl.TabLineFill = { bg = "NONE" }
      end,
    },
  },
  { "LazyVim/LazyVim", opts = { colorscheme = "tokyonight-night" } },

  -- Statusline styled like the tmux bar: transparent, coloured text, muted │ dividers,
  -- no powerline blocks. Mode is bold like the tmux session name, the clock bold pink.
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local function mode(color)
        return {
          a = { fg = color, bg = "NONE", gui = "bold" },
          b = { fg = p.blue, bg = "NONE" },
          c = { fg = p.fg, bg = "NONE" },
        }
      end
      opts.options.theme = {
        normal = mode(p.purple),
        insert = mode(p.green),
        visual = mode(p.pink),
        replace = mode(p.red),
        command = mode(p.yellow),
        terminal = mode(p.cyan),
        inactive = {
          a = { fg = p.muted, bg = "NONE" },
          b = { fg = p.muted, bg = "NONE" },
          c = { fg = p.muted, bg = "NONE" },
        },
      }
      opts.options.section_separators = ""
      opts.options.component_separators = ""

      -- a muted │ between groups, like tmux's dividers
      local bar = { function() return "│" end, color = { fg = p.muted }, padding = 0 }
      local s = opts.sections
      s.lualine_a = { { "mode", icon = "" } }
      s.lualine_b = {}
      table.insert(s.lualine_c, 1, bar)
      table.insert(s.lualine_c, 2, { "branch", color = { fg = p.blue } })
      for _, c in ipairs(s.lualine_y) do
        c.color = { fg = p.green }
      end
      table.insert(s.lualine_y, 1, bar)
      s.lualine_z = {
        bar,
        { function() return " " .. os.date("%R") end, color = { fg = p.pink, gui = "bold" } },
      }
    end,
  },
}
