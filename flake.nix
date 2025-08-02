{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim = {
      url = "github:zepi2509/nvim-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    };
  };

  outputs = { nixpkgs, ... }@inputs: 
  let
    system = "x86_64-linux";
  in
  {
    nixosConfigurations = {
      "ZEPI-Notebook" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs system; };
        modules = [ 
            ./hosts/ZEPI-Notebook
          ];
      };

      "ZEPI-Server" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ ./hosts/ZEPI-Server ];
      };
    };
  };
}
