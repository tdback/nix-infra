set quiet

update:
  nix flake update

check:
  nix flake check

build:
  sudo nixos-rebuild switch

copy target:
  rsync --rsync-path="sudo rsync" -ax --delete ./ {{target}}:/etc/nixos/

deploy target builder=target: (copy target)
  nixos-rebuild switch --flake .#{{target}} --target-host {{target}} --build-host {{builder}} --sudo --use-substitutes
