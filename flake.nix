{
  # Import other flakes
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    ags.url = "github:aylur/ags";
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim.url = "github:zepi2509/nvim-flake";
    stylix.url = "github:danth/stylix";
  };

  outputs = { nixpkgs, ... }@inputs: 
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    # Define new hosts here
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
