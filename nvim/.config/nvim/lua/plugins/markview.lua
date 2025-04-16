-- For `plugins/markview.lua` users.
return {
  "OXY2DEV/markview.nvim",
  lazy = false,
  opts = {
    latex = {
      enable = true,
    },
    preview = {
      enable = false,
    },
  },
  keys = function()
    return {

      {
        "<leader>um",
        "<CMD>Markview<CR>",
        "Toggle Markdown Rendering",
      },
    }
  end,
}
