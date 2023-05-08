{ inputs, username, lib, pkgs, pkgs-darwin, ... }:
{
  home.homeDirectory = builtins.break "/Users/${username}";

  services = {
  };
  home = {
    stateVersion = "22.11";
    packages = with pkgs; [
      pkgs-darwin.pinentry_mac
      pkgs-darwin.kitty
    ];

    sessionVariables = {
      GPG_TTY="$(tty)";
      SSH_AUTH_SOCK="$\{HOME\}/.gnupg/S.gpg-agent.ssh";
    };
  };

  programs = {
    zsh = {
      shellAliases = {
        nx-rebuild = "darwin-rebuild switch --flake ~/.dotfiles/nix";
        gpgreset="gpg-connect-agent killagent /bye; gpg-connect-agent updatestartuptty /bye; gpg-connect-agent /bye";
      };
    };
  };
}
