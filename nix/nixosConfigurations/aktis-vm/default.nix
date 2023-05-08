{ inputs, ... }:
let
  username = "nick";
  username_description = "Nick Clark";
  hostname = "aktis-vm";
  hardwareConfigPath = ./aktis-vm-hardware-configuration.nix;
  nixosModule = { config, lib, pkgs, ... }: {
    config = {
      virtualisation.vmware.guest.enable = true;
      services.xserver.videoDrivers = [ "vmware" ];
    };
  };
in
inputs.nixpkgs.lib.nixosSystem {
  extraSpecialArgs = {
    inherit username username_description hostname, hardwareConfigPath;
  };
  modules = [
    nixosModule
    ../../shared/configuration.nix
  ];
  system = "x86_64-linux";
}
