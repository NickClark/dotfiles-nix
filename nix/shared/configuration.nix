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
        xbindkeys
        acpi
        tlp
    ];

    xdg = {
        portal = {
            enable = true;
            extraPortals = with pkgs; [
                xdg-desktop-portal-wlr
                xdg-desktop-portal-gtk
            ];
            gtkUsePortal = true;
        };
    };

    sound = {
        enable = true;
    };

    security.rtkit.enable = true;

    services = {
      pipewire = {
        enable = false;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      printing.enable = true;
    };

    
    hardware = {
        pulseaudio.enable = true;
        # bluetooth.enable = false;
        opengl = {
            enable = true;
            driSupport = true;
        };
    };

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
