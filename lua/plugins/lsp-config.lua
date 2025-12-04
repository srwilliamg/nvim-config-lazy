return {
  {
    "mason-org/mason.nvim",
    enabled = not vim.g.vscode,
    opts = {
      opts = {
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    enabled = not vim.g.vscode,
    opts = {
      automatic_enable = true,
      ensure_installed = {
        "lua_ls",
        "docker_language_server",
        "eslint",
        "golangci_lint_ls",
        "gopls",
        "harper_ls",
        "jsonls",
        "stylua",
        "ts_ls",
        "yamlls",

        -- "delve",
        -- "go-debug-adapter",
        -- "goimports",
        -- "gotests",
        -- "gotestsum",
        -- "js-debug-adapter",
        -- "prettier",
        -- "prettierd",
        -- "typescript-language-server",
      },
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },
  {
    "saghen/blink.cmp",
    enabled = not vim.g.vscode,
    build = "cargo build --release",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "nvim-tree/nvim-web-devicons", -- Optional for file icons
      "onsails/lspkind.nvim", --optional icons
      -- "giuxtaposition/blink-cmp-copilot",
      "L3MON4D3/LuaSnip",
    },
    opts = {
      completion = {
        documentation = {
          auto_show = true,
        },
        ghost_text = {
          enabled = true,
          show_with_menu = false,
        },
        menu = {
          auto_show = true,
          draw = {
            -- use tree sitter to label
            treesitter = { "lsp" },
            columns = {
              { "kind_icon" },
              { "label" },
              { "source_name" },
            },
            components = {
              kind_icon = {
                ellipsis = false,
                text = function(ctx)
                  local icon = ctx.kind_icon
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      icon = dev_icon
                    end
                  else
                    icon = require("lspkind").symbolic(ctx.kind, {
                      mode = "symbol",
                    })
                  end

                  return icon .. ctx.icon_gap
                end,
              },
            },
          },
        },
      },
      keymap = {
        preset = "none",
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<CR>"] = { "select_and_accept" },
      },
      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      --- @type blink.cmp.SourceConfigPartial
      sources = {
        providers = {
          -- copilot = {
          --   enabled = false,
          --   name = "copilot",
          --   module = "blink-cmp-copilot",
          --   score_offset = 100,
          --   async = true,
          --   transform_items = function(_, items)
          --     for _, item in ipairs(items) do
          --       item.kind_icon = ""
          --       item.kind_name = "Copilot"
          --     end
          --     return items
          --   end,
          -- },
          markdown = {
            name = "markdown",
            module = "render-markdown.integ.blink",
            enabled = true,
            fallbacks = { "lsp" },
          },
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
          buffer = { max_items = 5 },
        },

        default = { "lsp", "path", "snippets", "buffer", "cmdline", "lazydev" },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    enabled = not vim.g.vscode,
    dependencies = {
      "mason-org/mason-lspconfig.nvim",
      "mason-org/mason.nvim",
      {
        "saghen/blink.cmp",
        build = "cargo build --release",
      },
    },
    config = function()
      -- go install github.com/nametake/golangci-lint-langserver@latest
      -- go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
      vim.lsp.enable("golangci_lint_ls")
      vim.lsp.enable("docker_language_server") -- go install github.com/docker/docker-language-server/cmd/docker-language-server@latest
      vim.lsp.enable("jsonls") -- npm i -g vscode-langservers-extracted

      vim.lsp.config["lua_ls"] = {
        -- Command and arguments to start the server.
        cmd = { "lua-language-server" },
        -- Filetypes to automatically attach to.
        filetypes = { "lua" },
        -- Sets the "workspace" to the directory where any of these files is found.
        -- Files that share a root directory will reuse the LSP server connection.
        -- Nested lists indicate equal priority, see |vim.lsp.Config|.
        root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
        -- Specific settings to send to the server. The schema is server-defined.
        -- Example: https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
        settings = {
          format = {
            enable = false,
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { "vim", "require" },
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = {
            enable = false,
          },
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
          },
        },
      }

      -- config also enables the lsp
      vim.lsp.config("go_ls", {
        filetypes = { "go", "gomod", "gosum", "gotmpl", "gohtmltmpl", "gotexttmpl" },
        message_level = vim.lsp.protocol.MessageType.Error,
        cmd = {
          "gopls", -- share the gopls instance if there is one already
          "-remote.debug=:0",
        },
        capabilities = {
          textDocument = {
            completion = {
              completionItem = {
                commitCharactersSupport = true,
                deprecatedSupport = true,
                documentationFormat = { "markdown", "plaintext" },
                preselectSupport = true,
                insertReplaceSupport = true,
                labelDetailsSupport = true,
                snippetSupport = true,
                resolveSupport = {
                  properties = {
                    "documentation",
                    "details",
                    "additionalTextEdits",
                  },
                },
              },
              contextSupport = true,
              dynamicRegistration = true,
            },
          },
        },
        settings = {
          gopls = {
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeLoopVariables = true,
            },
            analyses = {
              unusedparams = true,
              nilness = true,
              unusedwrite = true,
              useany = true,
            },
            staticcheck = true,
            gofumpt = true,
          },
        },
      })
      --
      -- -- disable inline hint for golang
      -- vim.keymap.set("n", "<leader>dh", function()
      --   vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      --   vim.notify("Toggled Go inline hints")
      -- end, { desc = "Toggle Go inline hints" })

      vim.lsp.config("harper_ls", {
        settings = {
          ["harper-ls"] = {
            linters = {
              SentenceCapitalization = false,
              SpellCheck = false,
            },
          },
        },
      })

      local opts = { noremap = true, silent = true }
      -- LSP-friendly mappings (require LSP configured)
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
      vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

      vim.diagnostic.config({
        signs = {
          numhl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
            [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
            [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
            [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
          },
          text = {
            [vim.diagnostic.severity.ERROR] = "X",
            [vim.diagnostic.severity.HINT] = "?",
            [vim.diagnostic.severity.INFO] = "I",
            [vim.diagnostic.severity.WARN] = "!",
          },
        },
        update_in_insert = true,
        virtual_text = false,
        virtual_lines = {
          current_line = true,
        },
      })
    end,
  },
}
