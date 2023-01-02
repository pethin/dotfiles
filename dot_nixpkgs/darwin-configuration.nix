{ config, pkgs, ... }:

{
  services = {
    nix-daemon.enable = true;
  };

  environment = {
    systemPackages = [
      pkgs.coreutils
    ];
  };

  users = {
    users.peter = {
      name = "peter";
      home = "/Users/peter";
      shell = pkgs.zsh;
    };
  };

  nix.package = pkgs.nixUnstable;

  programs = {
    zsh = {
      # Create /etc/zshrc that loads the nix-darwin environment.
      enable = true;
      enableCompletion = false;
      enableBashCompletion = false;
      enableSyntaxHighlighting = false;
    };
  };

  system = {
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 4;
  };
}
