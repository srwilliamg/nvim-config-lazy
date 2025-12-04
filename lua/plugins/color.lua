return {
  {
    "LazyVim/LazyVim",
    enabled = not vim.g.vscode,
    opts = {
      colorscheme = "kanagawa",
    },
  },
  {
    -- enabled = not vim.g.vscode,
    enabled = false,
    "ellisonleao/gruvbox.nvim",
    name = "gruvbox",
    init = function()
      vim.cmd.colorscheme("gruvbox")
      vim.o.background = "dark" -- or "light" for light mode
      vim.cmd([[colorscheme gruvbox]])
    end,
    config = function(_, opts)
      require("gruvbox").setup(opts)
    end,
    opts = {
      terminal_colors = true, -- add neovim terminal colors
      undercurl = true,
      underline = false,
      bold = true,
      italic = {
        strings = false,
        emphasis = false,
        comments = false,
        operators = false,
        folds = false,
      },
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      invert_intend_guides = false,
      inverse = true, -- invert background for search, diffs, statuslines and errors
      contrast = "", -- can be "hard", "soft" or empty string
      palette_overrides = {},
      overrides = {
        -- dark background
        CursorLineNr = { fg = "#fabd2f", bold = true },
        Search = { bg = "#fabd2f", fg = "#1d2021" },
        IncSearch = { bg = "#fabd2f", fg = "#1d2021" },
        Visual = { bg = "#3c3836" },
      },
      dim_inactive = false,
      transparent_mode = false,
    },
  },
  {
    enabled = not vim.g.vscode,
    -- enabled = false,
    "rebelot/kanagawa.nvim",
    config = function(_, opts)
      require("kanagawa").setup({
        theme = "wave", -- Load "wave" theme
        background = { -- map the value of 'background' option to a theme
          dark = "wave", -- try "dragon" !
          light = "wave",
        },
      })
    end,
    init = function()
      require("kanagawa").load("wave")
    end,
  },
  {
    enabled = false,
    -- enabled = not vim.g.vscode,
    "thesimonho/kanagawa-paper.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      theme = "kanagawa-paper-ink", -- The theme variant to use. Options are "kanagawa-paper-ink" and "kanagawa-paper-mist".
      transparent = false, -- Enable/disable setting a transparent background.
      terminalColors = true, -- Enable/disable setting terminal colors (vim.g.terminal_color_*) used in the terminal.
    },
    config = function(_, opts)
      require("kanagawa-paper").setup(opts)
    end,
    init = function()
      vim.cmd.colorscheme("kanagawa-paper-ink")
    end,
  },
}
