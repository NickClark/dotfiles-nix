{ inputs, ... }:
let
  configuration = { config, lib, pkgs, ... }: {
    config = {
      networking.hostName = "illume";
      # Update using the CLI, and then switch
      homebrew = {
        enable = true;
        global = {
          autoUpdate = false;
        };
        casks = [
          "google-chrome"
          "firefox"
          "opera"
          "logos"
          "neovide"
          "raycast"
          # "pinentry-mac" # Needed for GPG - but trying pkgs-darwin first
        ];
        onActivation = {
          cleanup = "zap";
          autoUpdate = false;
          upgrade = true;
        };
      };
      services = {
        nix-daemon.enable = true;
      };
      system = {
        keyboard = {
          enableKeyMapping = true;
          remapCapsLockToControl = true;
        };

        stateVersion = 4;
      };
    };
  };
in
inputs.nix-darwin.lib.darwinSystem {
  modules = [
    ../../shared/configuration.nix
    configuration
  ];
  system = "aarch64-darwin";
}
