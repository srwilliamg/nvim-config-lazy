-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap.set
local opts = {
  noremap = true,
  silent = true,
}

if vim.g.vscode then
  -- VSCode Neovim
  -- next diagnostic
  keymap("n", "]f", "<cmd>lua require('vscode').action('editor.action.marker.nextInFiles')<CR>", opts)
  keymap("n", "]d", "<cmd>lua require('vscode').action('editor.action.marker.next')<CR>", opts)

  -- previous diagnostic
  keymap("n", "[f", "<cmd>lua require('vscode').action('editor.action.marker.prevInFiles')<CR>", opts)
  keymap("n", "[d", "<cmd>lua require('vscode').action('editor.action.marker.prev')<CR>", opts)

  -- removes highlighting after escaping vim search
  keymap("n", "<Esc>", "<Esc>:noh<CR>", opts)

  keymap(
    { "n", "v" },
    "<leader>b",
    "<cmd>lua require('vscode').action('editor.debug.action.toggleBreakpoint')<CR>",
    opts
  )
  keymap({ "n", "v" }, "<leader>d", "<cmd>lua require('vscode').action('editor.action.showHover')<CR>", opts)
  keymap({ "n", "v" }, "<leader>a", "<cmd>lua require('vscode').action('editor.action.quickFix')<CR>", opts)
  keymap({ "n", "v" }, "<leader>sp", "<cmd>lua require('vscode').action('workbench.actions.view.problems')<CR>", opts)
  keymap({ "n", "v" }, "<leader>cn", "<cmd>lua require('vscode').action('notifications.clearAll')<CR>", opts)
  keymap({ "n", "v" }, "<leader>cp", "<cmd>lua require('vscode').action('workbench.action.showCommands')<CR>", opts)
  keymap({ "n", "v" }, "<leader>pr", "<cmd>lua require('vscode').action('code-runner.run')<CR>")
  keymap({ "n", "v" }, "<leader>fd", "<cmd>lua require('vscode').action('editor.action.formatDocument')<CR>", opts)

  keymap({ "n", "v" }, "<leader>ff", "<cmd>lua require('vscode').action('workbench.action.quickOpen')<CR>", opts)
  keymap({ "n", "v" }, "<leader><leader>", "<cmd>lua require('vscode').action('workbench.action.quickOpen')<CR>", opts)
  keymap({ "n", "v" }, "<leader>fs", "<cmd>lua require('vscode').action('workbench.action.findInFiles')<CR>", opts)

  -- toggle sidebar
  keymap(
    { "n", "v" },
    "<leader>e",
    "<cmd>lua require('vscode').action('workbench.action.toggleSidebarVisibility')<CR>",
    opts
  )

  -- fold current block
  keymap({ "n", "v" }, "za", "<cmd>lua require('vscode').action('editor.fold')<CR>", opts)
  -- unfold current block
  keymap({ "n", "v" }, "zm", "<cmd>lua require('vscode').action('editor.unfold')<CR>", opts)
  -- unfold recursively
  keymap({ "n", "v" }, "zr", "<cmd>lua require('vscode').action('editor.unfoldRecursively')<CR>", opts)
  -- fold all blocks
  keymap({ "n", "v" }, "zR", "<cmd>lua require('vscode').action('editor.unfoldAll')<CR>", opts)
  -- unfold all blocks
  keymap({ "n", "v" }, "zM", "<cmd>lua require('vscode').action('editor.foldAll')<CR>", opts)

  -- select next occurrence of current word
  keymap({ "x", "i" }, "<C-d>", function()
    require("vscode").with_insert(function()
      require("vscode").action("editor.action.addSelectionToNextFindMatch")
    end)
  end, opts)

  -- refactor
  keymap({ "n", "x" }, "<leader>r", function()
    require("vscode").with_insert(function()
      require("vscode").action("editor.action.refactor")
    end)
  end, opts)

  -- next tab using ctrl + 0
  keymap("n", "gn", "<cmd>lua require('vscode').action('workbench.action.nextEditor')<CR>", opts)

  -- previous tab using ctrl + ,
  keymap("n", "ga", "<cmd>lua require('vscode').action('workbench.action.previousEditor')<CR>", opts)

  -- LSP-friendly mappings (require LSP configured)
  keymap("n", "gi", vim.lsp.buf.implementation, opts)
  keymap("n", "gt", vim.lsp.buf.type_definition, opts)
  keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
  keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)
else
  -- Move between spaces
  vim.keymap.set("n", "<C-h>", "<C-w>h")
  vim.keymap.set("n", "<C-j>", "<C-w>j")
  vim.keymap.set("n", "<C-k>", "<C-w>k")
  vim.keymap.set("n", "<C-l>", "<C-w>l")

  -- next diagnostic
  vim.keymap.set("n", "]d", function()
    vim.diagnostic.jump({ count = 1, float = true })
  end)

  -- previous diagnostic
  vim.keymap.set("n", "[d", function()
    vim.diagnostic.jump({ count = -1, float = true })
  end)

  -- resize
  vim.keymap.set("n", "<C-Up>", ":resize -2<CR>", opts)
  vim.keymap.set("n", "<C-Down>", ":resize +2<CR>", opts)
  vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", opts)
  vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", opts)

  -- terminal resize
  vim.keymap.set("t", "<C-Up>", "<cmd>resize -2<CR>", opts)
  vim.keymap.set("t", "<C-Down>", "<cmd>resize +2<CR>", opts)
  vim.keymap.set("t", "<C-Left>", "<cmd>vertical resize -2<CR>", opts)
  vim.keymap.set("t", "<C-Right>", "<cmd>vertical resize +2<CR>", opts)

  -- fold current block
  -- toggle fold
  -- keymap({ "n", "v" }, "za", vim.cmd.fold, opts)
  -- -- unfold current block
  -- keymap({ "n", "v" }, "zm", vim.cmd.unfold, opts)
  -- -- fold all blocks
  -- keymap({ "n", "v" }, "zR", vim.cmd.foldopen, opts)
  -- -- unfold all blocks
  -- keymap({ "n", "v" }, "zM", vim.cmd.foldclose, opts)

  -- Easy find and replace.
  vim.keymap.set(
    { "v" },
    "<leader>re",
    '"hy:%s/<C-r>h/<C-r>h/gc<left><left><left>',
    { desc = "Open search and replace for currently selected text" }
  )
  vim.keymap.set(
    { "n" },
    "<leader>re",
    ":%s/<C-r><C-w>/<C-r><C-w>/gc<Left><Left><Left>",

    { desc = "Open search and replace for word under cursor" }
  )

  -- Terminal mode escape to normal mode
  vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", opts)

  -- Goto previous buffer
  vim.keymap.set({ "n", "v" }, "ga", "<C-^>", { desc = "Goto previous buffer" })
  -- Goto next buffer
  vim.keymap.set({ "n", "v" }, "gn", ":bnext<CR>", { desc = "Goto next buffer" })

  -- Allow exiting insert mode in terminal by hitting <ESC>
  vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
  -- Feed ESC in terminal mode using <C-\>
  vim.keymap.set("t", "<C-\\>", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
  end, opts)

  vim.api.nvim_create_autocmd("TermLeave", {
    desc = "Reload buffers when leaving terminal",
    pattern = "*",
    callback = function()
      vim.cmd.checktime()
    end,
  })
end
