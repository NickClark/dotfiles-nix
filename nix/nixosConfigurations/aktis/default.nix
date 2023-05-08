{
  inputs,
  hostname ? "aktis",
  username ? "nick",
  username_description ? "Nick Clark",
  hardwareConfigPath ? ./aktis-hardware-configuration.nix,
  ...
}: let
  configuration = { config, lib, pkgs, hyprland, ... }: {
    imports = [
      hardwareConfigPath
      # ./aktis-hardware-configuration.nix
    ];
    config = {
      system = {
        stateVersion = "22.11";
      };

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users = {
        defaultUserShell = pkgs.zsh;
        users.${username} = {
          isNormalUser = true;
          description = username_description;
          extraGroups = [ "networkmanager" "wheel" ];
        };
      };

      # Check shared config for more
      environment.systemPackages = with pkgs; [
        pciutils
        winetricks
        wineWowPackages.waylandFull
        lutris
      ];

      # Allow unfree packages
      nixpkgs.config.allowUnfree = true;

      services = {
        flatpak.enable = true;
        
        gnome = {
          # Don't include ssh, since we want GPG to manage it
          gnome-keyring.enable = lib.mkForce false;
        };
        
        synergy = {
          client = {
            enable = false;
            serverAddress = "10.0.10.5";
            screenName = hostname;
            autoStart = true;
          };
        };

        xserver = {
          enable = true;
          layout = "us";
          xkbVariant = "";
          displayManager.gdm = {
            enable = true;
            wayland = true;
          };
          desktopManager.gnome.enable = true;
        };
        pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
        };
        printing.enable = true;
      };
      hardware.pulseaudio.enable = false;

      # Bootloader
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.loader.efi.efiSysMountPoint = "/boot/efi";

      networking.hostName = hostname; # Define your hostname.
      # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

      # Configure network proxy if necessary
      # networking.proxy.default = "http://user:password@proxy:port/";
      # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

      # Enable networking
      networking.networkmanager.enable = true;

      # Set your time zone.
      time.timeZone = "America/Chicago";

      # Select internationalisation properties.
      i18n.defaultLocale = "en_US.UTF-8";

      i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
      };

      nix.settings = {
        substituters = ["https://hyprland.cachix.org"];
        trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
      };
    };
  };
in
inputs.nixpkgs.lib.nixosSystem {
  modules = [
    ../../shared/configuration.nix
    configuration
  ];
  system = "x86_64-linux";
}
