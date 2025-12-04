return {
  {
    "mfussenegger/nvim-dap",
    enabled = not vim.g.vscode,
    event = "VeryLazy",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
    },
    keys = {
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "toggle [d]ebug [b]reakpoint",
      },
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "[d]ebug [B]reakpoint",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "[d]ebug [c]ontinue (start here)",
      },
      {
        "<leader>dC",
        function()
          require("dap").run_to_cursor()
        end,
        desc = "[d]ebug [C]ursor",
      },
      {
        "<leader>dg",
        function()
          require("dap").goto_()
        end,
        desc = "[d]ebug [g]o to line",
      },
      {
        "<leader>do",
        function()
          require("dap").step_over()
        end,
        desc = "[d]ebug step [o]ver",
      },
      {
        "<leader>dO",
        function()
          require("dap").step_out()
        end,
        desc = "[d]ebug step [O]ut",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "[d]ebug [i]nto",
      },
      {
        "<leader>dj",
        function()
          require("dap").down()
        end,
        desc = "[d]ebug [j]ump down",
      },
      {
        "<leader>dk",
        function()
          require("dap").up()
        end,
        desc = "[d]ebug [k]ump up",
      },
      {
        "<leader>dl",
        function()
          require("dap").run_last()
        end,
        desc = "[d]ebug [l]ast",
      },
      {
        "<leader>dp",
        function()
          require("dap").pause()
        end,
        desc = "[d]ebug [p]ause",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.toggle()
        end,
        desc = "[d]ebug [r]epl",
      },
      {
        "<leader>dR",
        function()
          require("dap").clear_breakpoints()
        end,
        desc = "[d]ebug [R]emove breakpoints",
      },
      {
        "<leader>ds",
        function()
          require("dap").session()
        end,
        desc = "[d]ebug [s]ession",
      },
      {
        "<leader>dt",
        function()
          require("dap").terminate()
        end,
        desc = "[d]ebug [t]erminate",
      },
      {
        "<leader>dw",
        function()
          require("dap.ui.widgets").hover()
        end,
        desc = "[d]ebug [w]idgets",
      },
      {
        "<F5>",
        function()
          require("dap").continue()
        end,
        desc = "Debug: Continue",
      },
      {
        "<F10>",
        function()
          require("dap").step_over()
        end,
        { desc = "Debug: Step Over" },
      },
      {
        "<F11>",
        function()
          require("dap").step_into()
        end,
        { desc = "Debug: Step Into" },
      },
      {
        "<F12>",
        function()
          require("dap").step_out()
        end,
        { desc = "Debug: Step Out" },
      },
      {
        "<leader>b",
        function()
          require("dap").toggle_breakpoint()
        end,
        { desc = "Debug: Toggle Breakpoint" },
      },
    },
    config = function()
      local dap = require("dap")
      local local_debugger = vim.fn.expand("~/.local/share/nvim/js-debug/src/dapDebugServer.js")
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = { local_debugger, "${port}" },
        },
      }
      dap.configurations.javascript = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          sourceMaps = true,
          program = "${file}",
          protocol = "inspector",
          cwd = vim.fn.getcwd(), -- Use current working directory
          skipFiles = {
            "<node_internals>/**",
            "node_modules/**",
          },
        },
      }
      dap.configurations.typescript = {
        {
          runtimeExecutable = "npx",
          runtimeArgs = { "ts-node" },
          type = "pwa-node",
          request = "launch",
          name = "Launch TypeScript file",
          program = "${file}",
          cwd = vim.fn.getcwd(), -- Use current working directory
          skipFiles = {
            "<node_internals>/**",
            "node_modules/**",
          },
          sourceMaps = true,
        },
      }
      dap.set_log_level("TRACE")
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    enabled = not vim.g.vscode,
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    keys = {
      {
        "<leader>du",
        function()
          require("dapui").toggle({})
        end,
        desc = "Dap UI",
      },
      {
        "<leader>de",
        function()
          require("dapui").eval()
        end,
        desc = "Eval",
        mode = { "n", "v" },
      },
    },
    opts = {
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          size = 40,
          position = "left",
        },
        {
          elements = {
            { id = "repl", size = 0.5 },
            { id = "console", size = 0.5 },
          },
          size = 10,
          position = "bottom",
        },
      },
      floating = {
        max_height = 0.9,
        max_width = 0.9,
      },
      controls = {
        enabled = true,
        element = "repl",
      },
    },
    config = function(_, opts)
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup(opts)

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    enabled = not vim.g.vscode,
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      require("mason-nvim-dap").setup({
        ensure_installed = {
          "js-debug-adapter",
          "delve",
        },
        automatic_installation = true,
        handlers = {
          function(config)
            require("mason-nvim-dap").default_setup(config)
          end,
          delve = function(config)
            table.insert(config.configurations, 1, {
              args = function()
                return vim.split(vim.fn.input("args> "), " ")
              end,
              type = "delve",
              name = "file",
              request = "launch",
              program = "${file}",
              outputMode = "remote",
            })
            table.insert(config.configurations, 1, {
              args = function()
                return vim.split(vim.fn.input("args> "), " ")
              end,
              type = "delve",
              name = "file args",
              request = "launch",
              program = "${file}",
              outputMode = "remote",
            })
            require("mason-nvim-dap").default_setup(config)
          end,
        },
      })
    end,
  },
}
