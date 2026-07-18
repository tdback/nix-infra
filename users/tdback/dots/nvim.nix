{
  inputs,
  config,
  lib,
  desktop,
  ...
}:
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
      plugins = {
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
