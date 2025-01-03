# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ./fonts.nix ./packages.nix ./users.nix ];

  boot = {
    # crashDump.enable = true;

    kernelParams = [ "iommu=soft" ];

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  hardware.pulseaudio.enable = false;

  i18n = {
    defaultLocale = "en_GB.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "uk_UA.UTF-8";
      LC_IDENTIFICATION = "uk_UA.UTF-8";
      LC_MEASUREMENT = "uk_UA.UTF-8";
      LC_MONETARY = "uk_UA.UTF-8";
      LC_NAME = "uk_UA.UTF-8";
      LC_NUMERIC = "uk_UA.UTF-8";
      LC_PAPER = "uk_UA.UTF-8";
      LC_TELEPHONE = "uk_UA.UTF-8";
      LC_TIME = "uk_UA.UTF-8";
    };

    inputMethod = {
      enable = true;
      type = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ libpinyin ];
    };
  };

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [  ];
      allowedUDPPorts = [  ];
    };

    hostName = with builtins; concatStringsSep "-" [
      (readFile "/sys/devices/virtual/dmi/id/product_name")
      "nixos"
    ] |> replaceStrings ["\n"] [""];

    networkmanager.enable = true;
  };

  qt = {
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  services = {
    gnome = {
      core-utilities.enable = false;
      sushi.enable = true;
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    udev.packages = with pkgs; [
      gnome-settings-daemon
    ];

    xserver = {
      enable = true;
      excludePackages = with pkgs; [
        xterm
        xorg.xprop
      ];

      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };

  security = {
    rtkit.enable = true;
    sudo.extraConfig = "Defaults env_reset,pwfeedback
    Defaults env_keep += \"EDITOR VIMINIT XDG_CONFIG_HOME XDG_STATE_HOME\"";
  };

  system.stateVersion = config.system.nixos.release;
  
  time.timeZone = "Europe/Kyiv";

  virtualisation.docker.enable = true;

  xdg.portal.enable = true;
}
