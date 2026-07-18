{
  lib,
  pkgs,
  desktop,
  ...
}:
{
  config = lib.mkIf desktop {
    # user access to audio/video devices
    users.users.tdback.extraGroups = [
      "audio"
      "video"
    ];

    # hardware acceleration
    hardware.graphics.enable = true;
    hardware.graphics.enable32Bit = true;

    # acquire realtime priority for pipewire devices
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      wireplumber.enable = true;
      pulse.enable = true;
    };

    # system fonts
    fonts.packages = with pkgs; [
      nerd-fonts.terminess-ttf
      google-fonts
    ];

    # home-manager can't setup PAM to allow unlocks, so do it here
    security.pam.services.swaylock = { };
  };
}
