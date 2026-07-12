{
  inputs,
  ...
}:
let
  mkSystem =
    {
      hostname,
      arch,
      desktop ? false
    }:
    {
      nixosConfigurations.${hostname} = inputs.nixpkgs.lib.nixosSystem {
        system = arch;
        modules = [
          "${inputs.self}/common"
          "${inputs.self}/modules"
          "${inputs.self}/hosts/${hostname}"
	  inputs.agenix.nixosModules.default
        ];
        specialArgs = {
          inherit inputs desktop;
        };
      };
    };
in
{
  flake = inputs.nixpkgs.lib.mkMerge [
    (mkSystem {
      hostname = "trout";
      arch = "x86_64-linux";
      desktop = true;
    })
  ];
}
