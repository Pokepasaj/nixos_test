{ pkgs, lib, nur, pkgs-24_05, ... }:

let
  # google cloud with auth plugin
  gcloud = pkgs.google-cloud-sdk.withExtraComponents [
    pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin
  ];

  # https://github.com/AtaraxiaSjel/nur/tree/master/pkgs/waydroid-script
  waydroid-script = pkgs.writeShellScriptBin "waydroid-script" ''
    exec ${nur.repos.ataraxiasjel.waydroid-script}/bin/waydroid-script
  '';
in
{
  home.username = "kosta";
  home.homeDirectory = "/home/kosta";
  home.stateVersion = "24.05";
  nixpkgs.config.allowUnfree = true;

  # Packages
  home.packages = lib.unique [
    pkgs.docker
    pkgs.argocd
    pkgs.awscli2
    pkgs.biome
    pkgs.buildah
    pkgs.bun
    pkgs.cpu-x
    pkgs.delve
    pkgs.discord
    pkgs.doctl
    pkgs.firefox
    pkgs.fzf
    pkgs.gh
    pkgs.go
    pkgs.go-jsonnet
    pkgs.jan
    pkgs.jq
    pkgs.k9s
    pkgs.kubectl
    pkgs.kubectx
    pkgs.kubernetes-helm
    pkgs.nickel
    pkgs.nixd
    pkgs.nixpkgs-fmt
    pkgs.nodejs_20
    pkgs.obsidian
    pkgs.prismlauncher
    pkgs.screen
    pkgs.slack
    pkgs.syncthingtray
    pkgs.talosctl
    pkgs.terraform
    pkgs.topiary
    pkgs.ungoogled-chromium
    pkgs.vscode
    pkgs.wl-clipboard
    pkgs.zsh-powerlevel10k

    # Custom additions
    gcloud
    waydroid-script
    pkgs-24_05.azure-cli
  ];

  home.shellAliases = {
    "k" = "kubectl";
    "kcns" = "kubens";
    "ktx" = "kubectx";
    "tf" = "terraform";
    "g" = "jump";
    "s" = "bookmark";
    "d" = "deletemark";
    "l" = "showmarks";
  };

  home.sessionVariables = {
    NVM_DIR = "$HOME/.nvm";
  };

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh.enable = true;
    oh-my-zsh.theme = "robbyrussell";

    initExtraFirst = ''
      # Existing initialization
      if [[ -r "''${XDG_CACHE_HOME:-''$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-''$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source $HOME/.zshrc-extra-first

      # NVM initialization
      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
      [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    '';

    initExtra = ''
      source $HOME/.zshrc-extra
    '';

    plugins = [
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
    ];

    oh-my-zsh.plugins = [
      "colorize"
      "docker"
      "git"
      "kubectl"
    ];
  };
}

