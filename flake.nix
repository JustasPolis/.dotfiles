{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-fork.url = "github:JustasPolis/nixpkgs/master";
    hello.url = "github:JustasPolis/hello-flakes/main";
  };

  outputs = { nixpkgs, nixpkgs-unstable, nixpkgs-fork, ... }@inputs: {
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
          inherit inputs;
        };
        modules = [ ./configuration.nix ];
      };
    };
  };
}
