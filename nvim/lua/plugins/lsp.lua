-- Diagnostics: long linter messages were cut off at the window edge as virtual text.
-- Show the full message as lines under the cursor's line instead. Virtual lines don't
-- soft-wrap, so the message is wrapped here to fit the window.
-- <leader>cd still opens the message in a float.

-- Break `msg` into lines no wider than `width`, splitting on spaces.
local function wrap(msg, width)
  local out = {}
  for para in (msg .. "\n"):gmatch("(.-)\n") do
    local line = ""
    for word in para:gmatch("%S+") do
      if line ~= "" and #line + 1 + #word > width then
        out[#out + 1] = line
        line = word
      else
        line = line == "" and word or line .. " " .. word
      end
    end
    out[#out + 1] = line
  end
  return table.concat(out, "\n")
end

return {
  "neovim/nvim-lspconfig",
  opts = {
    diagnostics = {
      virtual_text = false,
      virtual_lines = {
        current_line = true,
        format = function(d)
          -- the message starts after the diagnostic's column plus the connector drawn
          -- before it, so leave room for both and for the sign/number columns
          local textoff = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1].textoff
          local width = vim.api.nvim_win_get_width(0) - textoff - d.col - 8
          return wrap(d.message, math.max(width, 30))
        end,
      },
    },
  },
}
