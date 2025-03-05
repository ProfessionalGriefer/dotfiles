return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre path/to/my-vault/*.md",
  --   "BufNewFile path/to/my-vault/*.md",
  -- },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",
    -- "hrsh7th/nvim-cmp",

    -- see below for full list of optional dependencies 👇
  },
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "/System/Volumes/Data/Users/vincent/Library/Mobile Documents/iCloud~md~obsidian/Documents/zettelkasten",
      },
    },

    notes_subdir = "6 - Main Notes",
    daily_notes = {
      folder = "8 - Daily",
      date_format = "%Y-%m-%d",
      template = nil,
    },
    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },

    ---@param title string
    ---@return string
    note_id_func = function(title)
      return title
    end,

    preferred_link_style = "markdown",

    open_app_foreground = false,

    disable_frontmatter = true,
    templates = {
      folder = "5 - Templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
      -- A map for custom variables, the key should be the variable and the value a function
      substitutions = {},
    },
    -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
    -- URL it will be ignored but you can customize this behavior here.
    ---@param url string
    follow_url_func = function(url)
      -- Open the URL in the default web browser.
      vim.fn.jobstart({ "open", url }) -- Mac OS
      -- vim.fn.jobstart({"xdg-open", url})  -- linux
      -- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
      -- vim.ui.open(url) -- need Neovim 0.10.0+
    end,

    -- Optional, by default when you use `:ObsidianFollowLink` on a link to an image
    -- file it will be ignored but you can customize this behavior here.
    ---@param img string
    follow_img_func = function(img)
      vim.fn.jobstart({ "qlmanage", "-p", img }) -- Mac OS quick look preview
      -- vim.fn.jobstart({"xdg-open", url})  -- linux
      -- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
    end,
    sort_by = "modified",
    sort_reversed = true,
    open_notes_in = "current",

    attachments = {
      img_folder = "7 - Files",
    },
  },

  keys = function()
    local obsidian = require("obsidian")

    return {
      {
        "gf",
        function()
          obsidian.util.gf_passthrough()
        end,
        desc = "Follow links within vault",
      },
      {
        "<leader>od",
        "<CMD>ObsidianDailies<CR>",
        desc = "Show all daily notes",
      },
      {
        "<leader>o.",
        "<CMD>ObsidianToday<CR>",
        desc = "Open today's daily note",
      },
      {
        "<leader>or",
        "<CMD>ObsidianRename<CR>",
        desc = "Rename note",
      },
      {
        "<leader>ob",
        "<CMD>ObsidianBacklinks<CR>",
        desc = "Open Backlinks",
      },
      {
        "<leader>og",
        "<CMD>ObsidianSearch<CR>",
        desc = "Grep vault",
      },
      {
        "<leader>o<",
        "<CMD>ObsidianYesterday<CR>",
        desc = "Daily note for yesterday",
      },
      {
        "<leader>o>",
        "<CMD>ObsidianTomorrow<CR>",
        desc = "Daily note for tomorrow",
      },
      {
        "<leader>ot",
        "<CMD>ObsidianTemplate<CR>",
        desc = "Insert Template",
      },
      {
        "<leader>on",
        "<CMD>ObsidianNew<CR>",
        desc = "Create a new note",
      },
      {
        "<leader>oT",
        "<CMD>ObsidianNewFromTemplate<CR>",
        desc = "Create a new note from a template",
      },
      {
        "<leader>oc",
        "<CMD>ObsidianTOC<CR>",
        desc = "Show Table of Contents",
      },
      {
        "<leader>ol",
        "<CMD>ObsidianLinks<CR>",
        desc = "Show all links within note",
      },
      {
        "<leader>of",
        "<CMD>ObsidianQuickSwitch<CR>",
        desc = "Open note",
      },
      {
        "<leader>oo",
        "<CMD>ObsidianOpen<CR>",
        desc = "Open in Obsidian",
      },
      {
        "<leader>oh",
        "<CMD>ObsidianTags<CR>",
        desc = "Show all tags",
      },
      {
        "<leader>op",
        "<CMD>ObsidianPasteImg<CR>",
        desc = "Paste image from clipboard",
      },
    }
  end,
}
