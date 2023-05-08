{ inputs, username, ... }:
let
  system = "x86_64-linux";
  pkgs = inputs.nixpkgs.legacyPackages.${system};
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
