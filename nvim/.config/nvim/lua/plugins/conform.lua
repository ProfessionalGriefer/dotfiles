return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["html"] = { "prettier" },
        ["typescript "] = { "biome-check" },
        ["typescriptreact "] = { "biome-check" },
        ["json"] = { "biome-check" },
        ["css"] = { "biome-check" },
      },
    },
  },
}
