{
  lib,
  pkgs,
  desktop,
  ...
}:
{
  config = lib.mkIf desktop {
    # User access to audio/video devices.
    users.users.tdback.extraGroups = [
      "audio"
      "video"
    ];

    # Hardware acceleration.
    hardware.graphics.enable = true;
    hardware.graphics.enable32Bit = true;

    # Acquire realtime priority for pipewire devices.
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      wireplumber.enable = true;
      pulse.enable = true;
    };

    # System fonts.
    fonts.packages = with pkgs; [
      nerd-fonts.terminess-ttf
      google-fonts
    ];

    # Home Manager can't setup PAM to allow unlocks, so do it here.
    security.pam.services.swaylock = { };
  };
}
