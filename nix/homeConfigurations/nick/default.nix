{ inputs, username, ... }:
let
  system = "x86_64-linux";
  # pkgs = inputs.nixpkgs.legacyPackages.${system};
  overlay = self: super: {
    discord = super.discord.override { withOpenASAR = true; };
    vaapiIntel = super.vaapiIntel.override { enableHybridCodec = true; };
  };
  pkgs = import inputs.nixpkgs {
    inherit system;
    overlays = [ overlay ];
    config.allowUnfree = true;
  };
in
inputs.home-manager.lib.homeManagerConfiguration {
  modules = [
    inputs.hyprland.homeManagerModules.default
    {wayland.windowManager.hyprland.enable = true;}
    ./home.nix
    ../shared
  ];
  extraSpecialArgs = {
    inherit inputs;
    inherit username;
  };
  inherit pkgs;
}
