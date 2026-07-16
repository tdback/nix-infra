{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05?shallow=1";
  inputs.nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable?shallow=1";

  inputs.flake-parts.url = "github:hercules-ci/flake-parts?shallow=1";
  inputs.flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

  inputs.home-manager.url = "github:nix-community/home-manager/release-26.05?shallow=1";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  inputs.agenix.url = "github:ryantm/agenix?shallow=1";
  inputs.agenix.inputs.nixpkgs.follows = "nixpkgs";

  inputs.nixvim.url = "github:nix-community/nixvim?shallow=1";

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { ... }:
      {
        systems = [ "x86_64-linux" ];
        imports = [ ./hosts ];
      }
    );
}
