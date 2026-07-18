{
  inputs,
  config,
  lib,
  desktop,
  ...
}:
let
  lspServers =
    servers:
    lib.genAttrs servers (_: {
      enable = true;
    });
in
{
  imports = [ inputs.nixvim.homeModules.nixvim ];

  programs.nixvim = lib.mkMerge [
    {
      enable = true;
      defaultEditor = true;

      globals = {
        mapleader = " ";
        maplocalleader = " ";
      };

      opts = {
        relativenumber = true;
        shiftwidth = 2;
        expandtab = true;
        wrap = false;
        hlsearch = false;
        incsearch = true;
        signcolumn = "yes";
        termguicolors = desktop;
        backup = false;
        swapfile = false;
        undofile = true;
        undodir = "${config.xdg.cacheHome}/nvim/undodir";
      };

      autoCmd = [
        {
          event = [ "BufWritePre" ];
          command = "%s/\\s\\+$//e";
        }
        {
          event = [ "TextYankPost" ];
          callback.__raw = ''
            function()
              vim.highlight.on_yank({
                higroup = "IncSearch",
                timeout = 50,
              })
            end
          '';
        }
      ];
    }

    (lib.mkIf desktop {
      dependencies.ripgrep.enable = config.programs.nixvim.plugins.telescope.enable;

      keymaps = lib.optional config.programs.nixvim.plugins.oil.enable {
        mode = "n";
        key = "-";
        action = "<Cmd>Oil<CR>";
      };

      plugins = {
        cmp = {
          enable = true;
          autoEnableSources = true;
          settings = {
            sources = [
              { name = "nvim_lsp"; }
              { name = "buffer"; }
              { name = "path"; }
            ];
            mapping = {
              "<C-n>" = "cmp.mapping.select_next_item()";
              "<C-p>" = "cmp.mapping.select_prev_item()";
              "<C-y>" = "cmp.mapping.confirm({ select = true })";
            };
          };
        };

        lsp = {
          enable = true;
          keymaps.lspBuf."<leader>lf" = "format";
          servers = lspServers [ "nil_ls" ];
        };

        oil = {
          enable = true;
          settings.skip_confirm_for_simple_edits = true;
        };

        telescope = {
          enable = true;
          keymaps = {
            "<leader>sf".action = "find_files";
            "<leader>sg".action = "live_grep";
            "<leader>sh".action = "help_tags";
            "<leader>sb".action = "buffers";
          };
        };

        treesitter = {
          enable = true;
          settings = {
            highlight.enable = true;
            indent.enable = true;
          };
        };
      };

      colorschemes.rose-pine = {
        enable = true;
        settings.styles = {
          italic = false;
          transparency = true;
        };
      };
    })
  ];
}
