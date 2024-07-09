{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-old.url = "github:NixOS/nixpkgs/fbde1e7188f45e481368b69f57d805ef2c630cdc";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-local.url = "github:justaspolis/nixpkgs/master";
    hyprlock.url = "github:hyprwm/hyprlock";
    hypridle.url = "github:hyprwm/hypridle";
    xremap.url = "github:xremap/nix-flake";
    ags.url = "github:Aylur/ags";
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    nixpkgs-old,
    nixpkgs-local,
    xremap,
    home-manager,
    ...
  } @ inputs: {
    nixosConfigurations = {
      justin = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          unstable = import nixpkgs-unstable {
            system = system;
            config.allowUnfree = true;
          };
          old = import nixpkgs-old {
            system = system;
            config.allowUnfree = true;
          };

          local = import nixpkgs-local {
            system = system;
            config.allowUnfree = true;
          };

          inherit inputs;
        };
        modules = [
          ./configuration.nix
        ];
      };
    };
    homeConfigurations = {
      "justin" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs;};
        modules = [./home.nix];
      };
    };
  };
}
