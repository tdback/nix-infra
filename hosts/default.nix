{
  inputs,
  ...
}:
let
  mkHomeManager = desktop: {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users = import "${inputs.self}/users";
      extraSpecialArgs = {
        inherit inputs desktop;
      };
    };
  };

  mkSystem =
    {
      hostname,
      arch,
      desktop ? false,
    }:
    {
      nixosConfigurations.${hostname} = inputs.nixpkgs.lib.nixosSystem {
        system = arch;
        modules = [
          "${inputs.self}/common"
          "${inputs.self}/modules"
          "${inputs.self}/services"
          "${inputs.self}/hosts/${hostname}"
          inputs.agenix.nixosModules.default
          inputs.home-manager.nixosModules.default
          (mkHomeManager desktop)
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
      hostname = "carp";
      arch = "x86_64-linux";
    })
    (mkSystem {
      hostname = "salmon";
      arch = "x86_64-linux";
    })
    (mkSystem {
      hostname = "sunfish";
      arch = "x86_64-linux";
    })
    (mkSystem {
      hostname = "trout";
      arch = "x86_64-linux";
      desktop = true;
    })
  ];
}
