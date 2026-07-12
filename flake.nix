{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05?shallow=true";
  inputs.nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable?shallow=true";

  inputs.flake-parts.url = "github:hercules-ci/flake-parts?shallow=true";
  inputs.flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

  inputs.agenix.url = "github:ryantm/agenix?shallow=true";
  inputs.agenix.inputs.nixpkgs.follows = "nixpkgs";

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { ... }:
      {
        systems = [ "x86_64-linux" ];
        imports = [ ./hosts ];
      }
    );
}
