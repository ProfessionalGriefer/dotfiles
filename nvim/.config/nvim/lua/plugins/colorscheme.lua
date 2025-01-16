return {
  -- add gruvbox
  { "catppuccin", opts = {
    transparent_background = true,
  } },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
