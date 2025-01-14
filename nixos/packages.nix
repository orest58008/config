{ config, pkgs, inputs, ... }:

{
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
      randomizedDelaySec = "1d";
    };
    package = pkgs.lix;
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "flakes"
        "nix-command"
        "pipe-operator"
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  programs = {
    gnupg.agent.enable = true;
    steam = {
      enable = true;
      # extest.enable = true;
    };
    zsh = {
      enable = true;
      vteIntegration = true;
    };
  };

  environment = {
    systemPackages = let
      unstable = inputs.nixpkgs-unstable.legacyPackages."${pkgs.system}";
      fjordlauncher = inputs.fjordlauncher.packages."${pkgs.system}";

      consolePackages = with pkgs; [
        aria2
        bat
        busybox
        distrobox
        eza
        fd
        git
        git-lfs
        gnumake
        gnupg
        htop
        jq
        lm_sensors
        openvpn
        starship
        steam-run
        tealdeer
        trash-cli
        vim
        wl-clipboard
        zsh
      ];

      desktopPackages = with pkgs; [
        gnomeExtensions.appindicator
        gnomeExtensions.just-perfection
        materia-theme
        papirus-icon-theme
        posy-cursors
      ];

      devPackages = with pkgs; [
        deno
        emacs29-pgtk
        jdt-language-server
        nil
        openjdk
        pyright
        python3
      ];

      programPackages = with pkgs; [
        abiword
        baobab
        celluloid
        cheese
        dconf-editor
        eog
        evince
        file-roller
        firefox
        fjordlauncher.fjordlauncher
        fragments
        geary
        gimp
        gnome-calculator
        gnome-sound-recorder
        gnome-tweaks
        inkscape
        nautilus
        nicotine-plus
        obs-studio
        rhythmbox
        steam
        telegram-desktop
        transmission_4-gtk
        unstable.ghostty
        vesktop
        vscodium-fhs
        zoom-us
      ];

      servicePackages = with pkgs; [
        binutils
        gcc
        groff
        linuxHeaders
        wineWowPackages.wayland
      ];

    in builtins.concatLists [
      consolePackages
      desktopPackages
      devPackages
      programPackages
      servicePackages
    ];
  };
}
