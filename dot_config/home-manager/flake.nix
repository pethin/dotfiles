{
  description = "Peter's Nix configuration";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      genPkgs = system: import nixpkgs {
        inherit system;

        config = {
          allowUnfree = true;

          permittedInsecurePackages = [];
        };
      };
    in {
      homeConfigurations.peter =
        let
          pkgs = genPkgs "x86_64-darwin";
        in home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            ./home.nix
          ];
        };
    };
}
