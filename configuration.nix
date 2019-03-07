# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{

  imports = [./hardware-configuration.nix];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/nvme0n1p2";
      preLVM = true;
    }
  ];

  boot.extraModprobeConfig = "options snd_hda_intel power_save=1";

  networking.hostName = "ventoux"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config.allowUnfree = true ;
  environment.systemPackages = with pkgs; [
    wget
    killall
    vim
    curl
    plank
    vagrant
    nitrogen
    docker
    spotify
    terminus
    termite
    dropbox
    networkmanagerapplet
    usbutils
    rofi
    git
    htop
    powertop
    tcpdump
    telnet
    python27
    python36
    neovim
    firefox
    st
    fzf
    ripgrep
    vlc
    acpid
    neovim
    htop
    powertop
    keybase

    (python27.withPackages (ps: with ps; [pyyaml]))
  ];

  services.xserver = {
    enable = true;
    desktopManager = {
      default = "xfce";
      xterm.enable = false;
      xfce = {
        enable = true;
        #noDesktop = true;
        #enableXfwm = false;
      };
    };
    # windowManager.i3.enable = true;
    # displayManager.lightdm.enable = true;
  };

  # We want to use i3-gaps because it's prettier than i3-stdrd
  # services.xserver.windowManager.i3.package = pkgs.i3-gaps;

  # We like slim as a login window since it's so lightweight
  # services.xserver.displayManager.ly.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  #programs.vim = {
  #  enable = true;
  #  plugins = ["vim-airline" "tabular" "vim-puppet" "vim-sensible";
  #}:



  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  hardware.pulseaudio.enable = true;
  nixpkgs.config.pulseaudio = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.marco = {
    createHome = true;
    extraGroups = ["wheel" "networkmanager" "audio"];
    group = "users";
    home = "/home/marco";
    isNormalUser = true;
    shell = pkgs.zsh;
    uid = 1000;
  };

  services.xserver.xkbOptions = "ctrl:swapcaps";

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?

}
