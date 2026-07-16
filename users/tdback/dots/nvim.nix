{
  inputs,
  config,
  ...
}:
{
  imports = [ inputs.nixvim.homeModules.nixvim ];

  programs.nixvim = {
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
  };
}
