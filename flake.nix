{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-staging.url = "github:nixos/nixpkgs/staging";
    hello.url = "github:JustasPolis/hello-flakes/main";
    nordvpn.url = "github:JustasPolis/nordvpn-linux/main";
    #gtk-waybar.url = "github:JustasPolis/gtk-waybar.rs/main";
    hyprlock.url = "github:hyprwm/hyprlock";
    hypridle.url = "github:hyprwm/hypridle";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    nixpkgs-staging,
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
          staging = import nixpkgs-staging {
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
