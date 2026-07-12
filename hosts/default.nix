{
  inputs,
  ...
}:
let
  mkSystem =
    {
      hostname,
      arch
    }:
    {
      nixosConfigurations.${hostname} = inputs.nixpkgs.lib.nixosSystem {
        system = arch;
        modules = [
          "${inputs.self}/common"
          "${inputs.self}/hosts/${hostname}"
        ];
        specialArgs = {
          inherit inputs;
        };
      };
    };
in
{
  flake = inputs.nixpkgs.lib.mkMerge [
    (mkSystem {
      hostname = "trout";
      arch = "x86_64-linux";
    })
  ];
}
