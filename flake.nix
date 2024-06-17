{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprlock.url = "github:hyprwm/hyprlock";
    hypridle.url = "github:hyprwm/hypridle";
    xremap.url = "github:xremap/nix-flake";
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
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

          inherit inputs;
        };
        modules = [./configuration.nix];
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
