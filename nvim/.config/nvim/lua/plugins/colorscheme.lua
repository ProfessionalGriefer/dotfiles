return {
  -- add gruvbox
  { "catppuccin", opts = {
    transparent_background = true,
  } },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
      -- colorscheme = function()
      --   vim.opt.termguicolors = true -- enable true-color
      --   vim.cmd("colorscheme cursor")
      -- end,
    },
  },
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
  },
}
