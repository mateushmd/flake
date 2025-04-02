{ config, inputs, pkgs, ... }:
{
  imports =
  [ 
    ./hardware-configuration.nix
  ];

  boot.supportedFilesystems = [ "ntfs" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "laptop"; 

  networking.networkmanager.enable = true;

  time.timeZone = "America/Sao_Paulo";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  services.xserver.enable = true;

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };

  console.keyMap = "br-abnt2";

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.mateus = {
    isNormalUser = true;
    description = "mateus";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.firefox.enable = true;

  programs.ssh = {
    startAgent = true;
    enableAskPassword = true;
    askPassword = pkgs.lib.mkForce "${pkgs.kdePackages.ksshaskpass.out}/bin/ksshaskpass";
  };

  programs.starship = {
    enable = true;
    
    settings = {
      
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    wezterm

    vim 
    inputs.nixvim.packages.${pkgs.system}.default 
    git
    zip
    unzip    
    fzf
    bat
    gitmoji-cli

    kdePackages.ksshaskpass
    gparted

    eza
    neofetch

    discord
    obsidian
    kdePackages.kcalc

    nerd-fonts.jetbrains-mono
  ];

  environment.sessionVariables = {
    SSH_ASKPASS_REQUIRE = "prefer";
  };

  environment.localBinInPath = true;

  # Just don't 
  system.stateVersion = "24.11"; # Did you read the comment?
}
