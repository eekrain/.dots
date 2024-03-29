{
  description = "The most basic configuration";

  inputs =
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      hyprpicker.url = "github:hyprwm/hyprpicker/cc6b3234b2966acd61c8a2e5caae947774666601";
      hypr-contrib.url = "github:hyprwm/contrib/1af47a008e850c595aeddc83bb3f04fd81935caa";
      flake-utils.url = "github:numtide/flake-utils";
      picom.url = "github:yaocccc/picom";
      hyprland = {
        url = "github:hyprwm/Hyprland/b15803510c67b7b89090c99f03781d9052c959f5";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };

  outputs = inputs @ { self, nixpkgs, flake-utils, ... }:
    let
      user = "eekrain";
      selfPkgs = import ./pkgs;
    in
    flake-utils.lib.eachSystem [ "x86_64-linux" ]
      (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              self.overlays.default
            ];
          };
        in
        {
          devShells = {
            #run by `nix devlop` or `nix-shell`(legacy)
            default = import ./shell.nix { inherit pkgs; };
          };
        }
      )
    // {
      overlays.default = selfPkgs.overlay;
      nixosConfigurations = (
        # NixOS configurations
        import ./hosts {
          # Imports ./hosts/default.nix
          system = "x86_64-linux";
          inherit nixpkgs self inputs user;
        }
      );
    };
}
