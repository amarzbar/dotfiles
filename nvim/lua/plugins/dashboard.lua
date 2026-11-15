-- NvChad v2.5 nvdash header (square Kufic Arabic), sourced from
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua
return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      preset = {
        header = table.concat({
          "           ▄ ▄                   ",
          "       ▄   ▄▄▄     ▄ ▄▄▄ ▄ ▄     ",
          "       █ ▄ █▄█ ▄▄▄ █ █▄█ █ █     ",
          "    ▄▄ █▄█▄▄▄█ █▄█▄█▄▄█▄▄█ █     ",
          "  ▄ █▄▄█ ▄ ▄▄ ▄█ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄  ",
          "  █▄▄▄▄ ▄▄▄ █ ▄ ▄▄▄ ▄ ▄▄▄ ▄ ▄ █ ▄",
          "▄ █ █▄█ █▄█ █ █ █▄█ █ █▄█ ▄▄▄ █ █",
          "█▄█ ▄ █▄▄█▄▄█ █ ▄▄█ █ ▄ █ █▄█▄█ █",
          "    █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█ █▄█▄▄▄█    ",
        }, "\n"),
      },
    },
  },
}
