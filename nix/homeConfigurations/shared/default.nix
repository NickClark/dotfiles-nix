{ inputs, username, config, lib, pkgs, ... }:
{

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  services = {
    gpg-agent = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableSshSupport = true;
    };
  };
  home = {
    username = username;

    stateVersion = "22.11";
    packages = with pkgs; [
      atool
      httpie
      tree-sitter
      gcc
      ripgrep
    ];

    sessionVariables = {
        EDITOR = "nvim";
        NIX_SHELL_PRESERVE_PROMPT=1;
    };
  };

  programs = {
    bat.enable = true;
    direnv.enable = true;
    direnv.nix-direnv.enable = true;
    exa = {
      enable = true;
      enableAliases = true;
      extraOptions = [
        "--group-directories-first"
        "--header"
        "--icons"
      ];
    };
    htop.enable = true;
    jq.enable = true;

    kitty = {
      enable = true;
      font.name = if pkgs.stdenv.hostPlatform.isDarwin then "JetBrainsMono Nerd Font Regular" else "JetBrainsMono NF Regular";
      settings = {
        bold_font = if pkgs.stdenv.hostPlatform.isDarwin then "JetBrainsMono Nerd Font Bold" else "JetBrainsMono NF Bold";
        italic_font = if pkgs.stdenv.hostPlatform.isDarwin then "JetBrainsMono Nerd Font Italic" else "JetBrainsMono NF Italic";
        bold_italic_font = if pkgs.stdenv.hostPlatform.isDarwin then "JetBrainsMono Nerd Font Bold Italic" else "JetBrainsMono NF Bold Italic";
        font_size = "13.0";
      };
    };

    git = {
      enable = true;
      userName = "Nicholas Clark";
      userEmail = "nick4jesus@gmail.com";
      diff-so-fancy = {
        enable = true;
      };
      signing = {
        signByDefault = true;
        key = "822A64C8F55487365947F3E560E97AF713CA2DBE";
      };
    };

    tmux = {
      enable = true;
      historyLimit = 10000;
      terminal = "screen-256color";
      shortcut = "a";
      keyMode = "vi";
      extraConfig = ''
        # https://old.reddit.com/r/tmux/comments/mesrci/tmux_2_doesnt_seem_to_use_256_colors/
        set -g default-terminal "xterm-256color"
        set -ga terminal-overrides ",*256col*:Tc"
        set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
        set-environment -g COLORTERM "truecolor"

        # Mouse works as expected
        set -g mouse on

        # easy-to-remember split pane commands
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"
      '';
      plugins = [
        pkgs.tmuxPlugins.onedark-theme
      ];
    };

    zsh = {
      enable = true;
      autocd = true;
      enableCompletion = true;
      enableAutosuggestions = true;

      shellAliases = {
        home-rebuild = "home-manager switch --flake ~/.dotfiles/nix";
      };


      plugins = [
        # maybe try starship sometime
        {
          name = "powerlevel10k";
          src = lib.cleanSource inputs.p10k;
          file = "powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = lib.cleanSource ./p10k-config;
          file = "p10k.zsh";
        }
      ];

    };

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      # Maybe we'll switch from NvChad and just make our own collection sometime.
      # plugins = with pkgs.neovimUtils; [
        # Add your desired Neovim plugins here
      # ];
    };
  };
}
