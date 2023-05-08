{ inputs, username, ... }:
let
  system = "aarch64-darwin";
  pkgs = inputs.nixpkgs.legacyPackages.${system};
  pkgs-darwin = inputs.nixpkgs-darwin.legacyPackages.${system};
in
inputs.home-manager.lib.homeManagerConfiguration {
  modules = [
    ./home.nix
    ../shared
  ];
  extraSpecialArgs = {
    inherit inputs;
    inherit username;
    inherit pkgs-darwin;
  };
  inherit pkgs;
}
