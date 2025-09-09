{
  description = "Peter's Nix configuration";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    fh.url = "https://flakehub.com/f/DeterminateSystems/fh/*";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/*";
    home-manager = {
      url = "https://flakehub.com/f/nix-community/home-manager/*";
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
