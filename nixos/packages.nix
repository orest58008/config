{ config, pkgs, inputs, ... }:

{
  nix = {
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
      extest.enable = true;
    };
    zsh = {
      enable = true;
      vteIntegration = true;
    };
  };

  environment = {
    systemPackages = let
      unstable      = inputs.nixpkgs-unstable.legacyPackages."${pkgs.system}";
      fjordlauncher = inputs.fjordlauncher.packages."${pkgs.system}";

      consolePackages = with pkgs; [
        aria2
        bat
        distrobox
        eza
        fd
        git
        git-lfs
        gnumake
        gnupg
        jq
        starship
        tealdeer
        trash-cli
        vim
        zsh
      ];

      desktopPackages = with pkgs; [
        gnomeExtensions.appindicator
        gnomeExtensions.just-perfection
        materia-theme
        papirus-icon-theme
        posy-cursors
      ];

      emacsPackages = with pkgs; [
        deno
        emacs29-pgtk
        (haskell-language-server.override { supportedGhcVersions = [ "96" ]; })
        jdt-language-server
        nil
        python3Packages.python-lsp-server
      ];

      programPackages = with pkgs; [
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
        libreoffice
        nautilus
        nicotine-plus
        obs-studio
        rhythmbox
        steam
        telegram-desktop
        unstable.ghostty
        vesktop
        zoom-us
      ];

      servicePackages = with pkgs; [
        binutils
        gcc
        linuxHeaders
        openjdk
        openvpn
        steam-run
        wineWowPackages.wayland
        wl-clipboard
      ];

    in builtins.concatLists
    [ consolePackages desktopPackages emacsPackages programPackages servicePackages ];
  };
}
