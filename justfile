set quiet

update:
  nix flake update

check:
  nix flake check

build:
  sudo nixos-rebuild switch

copy $host:
  rsync --rsync-path="sudo rsync" -ax --delete ./ {{host}}:/etc/nixos/

deploy $host: (copy host)
  nixos-rebuild switch --flake .#{{host}} --target-host {{host}} --build-host {{host}} --sudo
