{
  description = "Your new nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-personal.url = "github:JustasPolis/nixpkgs/master";
  };

  outputs = { self, nixpkgs, home-manager, nixpkgs-unstable, nixpkgs-personal
    , ... }@inputs:
    let inherit (self) outputs;
    in {
      nixosConfigurations = {
        justin = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs outputs nixpkgs-unstable nixpkgs-personal;
          };
          modules = [ ./configuration.nix ];
        };
      };
    };
}
