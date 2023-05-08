{ config, lib, pkgs, ... }:
{
  imports = [ ];
  config = {
    fonts = {
      fonts = with pkgs; [
        (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono"];})
      ];
      fontDir = {
        enable = true;
      };
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search by name, run:
    # $ nix-env -qaP | grep wget
    environment.systemPackages = with pkgs; [
        wget
        direnv
        neovim
        nil
        curl
        git
        gnupg
    ];

    programs = {
      zsh = {
        enable = true;
      };
      # Don't start default agent, gpg agent will cover it            
      ssh.startAgent = false;
    };
    
    nix.settings = {
      experimental-features = ["nix-command" "flakes"];
    };
  };
}
