set quiet

update:
  nix flake update

check:
  nix flake check

build:
  nixos-rebuild switch --sudo
