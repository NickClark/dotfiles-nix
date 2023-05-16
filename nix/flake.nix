{
  description = "Nicks NixOS configuration";

  inputs = {
    nixpkgs.url = "flake:nixpkgs/nixpkgs-unstable";

    nixpkgs-darwin.url = "flake:nixpkgs/nixpkgs-22.11-darwin";

    nix-darwin.url = "flake:nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "flake:home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nvchad.url = "github:NvChad/NvChad/v2.0?depth=1";
    nvchad.flake = false;

    p10k.url = "github:romkatv/powerlevel10k/master?depth=1";
    p10k.flake = false;

    hyprland.url = "github:hyprwm/Hyprland";

    fufexan.url = "github:fufexan/dotfiles";
    fufexan.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs:
  let
    flakeContext = {
      inherit inputs;
      username = "nick";
      username_description = "Nick Clark";
    };
  in rec {
    nixosConfigurations = {
      aktis-vm = import ./nixosConfigurations/aktis-vm flakeContext;
      aktis = import ./nixosConfigurations/aktis flakeContext;
    };
    darwinConfigurations = {
      illume = import ./darwinConfigurations/illume flakeContext;
    };
    homeConfigurations = {
      nick = import ./homeConfigurations/nick flakeContext;
      "nick@illume" = import ./homeConfigurations/nick_darwin_arm flakeContext;
    };

    # This makes it possible, since we use home manager
    # standlone, to just run `nix run . switch` the first time, before `home-manager switch` works
    # https://www.bekk.christmas/post/2021/16/dotfiles-with-nix-and-home-manager
    defaultPackage.x86_64-linux = inputs.home-manager.defaultPackage.x86_64-linux;
    defaultPackage.x86_64-darwin = inputs.home-manager.defaultPackage.x86_64-darwin;
    defaultPackage.aarch64-darwin = inputs.home-manager.defaultPackage.aarch64-darwin;

    # Expose the package set, including overlays, for convenience.
    # I haven't used this for anything yet that I know of
    darwinPackages = darwinConfigurations.illume.pkgs;
  };
}
