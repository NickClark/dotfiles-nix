{ inputs, username, lib, pkgs, ... }:
{
  home.homeDirectory = "/home/${username}";

  services = {
    mako = {
      enable = true;
    };

    # Don't include ssh, since we want GPG to manage it
    gnome-keyring.components = ["pkcs11" "secrets"];

    gpg-agent = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableSshSupport = true;
      pinentryFlavor = "gnome3";
    };
  };
  home = {
    stateVersion = "22.11";
    packages = with pkgs; [
      firefox
      chromium
      brave
      neovide
      gnome.gnome-tweaks
      hyprpaper
      waynergy
      kitty
      vscodium
      wofi
      wl-clipboard
    ];

    sessionVariables = {
    };
  };

  xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;

  programs = {
    zsh = {
      shellAliases = {
        nx-rebuild = "sudo nixos-rebuild switch --flake ~/.dotfiles/nix";
      };
    };
  };
}
