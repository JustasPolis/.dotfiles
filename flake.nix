{
  description = "Your new nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-fork.url = "github:JustasPolis/nixpkgs/master";
    local.url = "git+file:///home/justin/.projects/nix-test";
  };

  outputs = { self, nixpkgs, home-manager, nixpkgs-unstable, nixpkgs-fork, local
    , ... }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
        justin = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {
            unstable = import nixpkgs-unstable {
              system = system;
              config.allowUnfree = true;
            };
            fork = import nixpkgs-fork {
              system = system;
              config.allowUnfree = true;
            };
            local = import local { inherit pkgs; };
            inherit inputs outputs;
          };
          modules = [ ./configuration.nix ];
        };
      };
    };
}
