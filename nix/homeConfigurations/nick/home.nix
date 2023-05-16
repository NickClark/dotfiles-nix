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
      brave
      neovide
      gnome.gnome-tweaks
      hyprpaper
      waynergy
      vscodium
      wofi
      wl-clipboard
      qt6.qtwayland
      libsForQt5.qt5.qtwayland
      libsForQt5.polkit-kde-agent
      xorg.xprop
      helix
      eww-wayland
      discord
    ];

    sessionVariables = {
    };
  };

  xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;

  programs = {
    chromium.enable = true;
    firefox = {
      enable = true;
      
      package = pkgs.firefox.override {
        cfg = {
          enableGnomeExtensions = true;
        };
      };
    };
    command-not-found.enable = true;
    zsh = {
      shellAliases = {
        nx-rebuild = "sudo nixos-rebuild switch --flake ~/.dotfiles/nix";
      };
    };
  };
}
