{ lib, config, pkgs, ... }:

let
  cfg = config.main-user;
in
{
  options.main-user = {
    enable 
      = lib.mkEnableOption "enable user module";

    userName = lib.mkOption {
      default = "kosta";
      description = ''
        username
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.userName} = {
      isNormalUser = true;
      initialPassword = "12345";
      description = "kosta";
      shell = pkgs.zsh;
      extraGroups = [
        "docker"
        "networkmanager"
        "wheel"
      ];
    };
  };
}

