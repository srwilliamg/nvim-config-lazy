return {
  "stevearc/conform.nvim",
  enabled = not vim.g.vscode,
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      go = { "gofmt" },
      javascript = { "prettierd", "prettier", stop_after_first = true },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      json = { "prettierd", "prettier", stop_after_first = true },
      jsonc = { "prettierd", "prettier", stop_after_first = true },
      css = { "prettierd", "prettier", stop_after_first = true },
      jsx = { "prettierd", "prettier", stop_after_first = true },
      yaml = { "prettierd" }, -- or "yamlfmt"
      conf = { "prettierd" },
    },
    format_on_save = {
      -- These options will be passed to conform.format()
      timeout_ms = 500,
      lsp_format = "fallback",
    },
    config = function(_, opts)
      require("conform").setup(opts)
    end,
  },
}
