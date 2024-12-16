{ config, pkgs, inputs, ... }:

{
  # Enable experimental features
  nix.settings.experimental-features = "nix-command flakes";

  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  # Bluetooth
  hardware.bluetooth.enable = true;

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname
  networking.networkmanager.enable = true;
  networking.wireless.enable = false;  # Enables wireless support via wpa_supplicant.

  # Set your time zone
  time.timeZone = "Europe/Sofia";

  # Enable the X11 windowing system
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment
  services.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account
  users.users.kosta = {
    isNormalUser = true;
    description = "kosta";
    extraGroups = [ "networkmanager" "wheel" "docker" ]; # Add kosta to the docker group
    packages = with pkgs; [
      kate
    ];
    shell = pkgs.zsh;  # Set Zsh as the default shell for kosta
  };

  # Enable automatic login for the user
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "kosta";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable docker.
  virtualisation.docker.enable = true;

  # Enable Zsh shell
  programs.zsh.enable = true;

  # Home manager setup
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "kosta" = import ./home.nix;
    };
  };

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    curl
    k3d
    lsof
    bitwarden
    cherrytree
    zsh
    simplescreenrecorder
    vlc
    brave
    htop
    spectacle 
    bun
    timeshift
    screen
    jq
    nodejs
  ];

  # Set environment variables, including PATH
  environment.variables = {
    PATH = "/usr/local/bin:/bin:/sbin:/usr/bin:/usr/sbin";
  };

  system.stateVersion = "24.05"; # Specify the NixOS system version
}

