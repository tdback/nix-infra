{
  programs.tmux = {
    enable = true;
    prefix = "C-SPACE";
    keyMode = "vi";
    escapeTime = 0;
    historyLimit = 10000;
    terminal = "tmux-256color";
    clock24 = true;
    baseIndex = 1;
    extraConfig = ''
      set-option -g renumber-windows on
      set-option -g detach-on-destroy off
      set-option -g status on
      set-option -g status-position top
      set-option -g status-justify centre
      set-option -g status-style "fg=#C5C5C5"
      set-option -g status-left " #S"
      set-option -g status-right ""
      set-window-option -g window-status-current-style "fg=colour255 bold"
      set-window-option -g window-status-current-format " #I:#W "
      bind-key x kill-pane
      bind-key ^ last-window
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R
      bind-key % split-window -h -c "#{pane_current_path}"
      bind-key '"' split-window -v -c "#{pane_current_path}"
    '';
  };
}
