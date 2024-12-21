{ config, pkgs, ... }:

{
  nix = {
    package = pkgs.lix;
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  programs = {
    gnupg.agent.enable = true;
    zsh = {
      enable = true;
      vteIntegration = true;
    };
  };

  environment = {
    systemPackages = let
      consolePackages = with pkgs; [
        bat
        distrobox
        eza
        git
        git-lfs
        gnupg
        imagemagick
        starship
        tealdeer
        trash-cli
        vim
        wlprop
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
        aspell
        aspellDicts.uk
        aspellDicts.en
        emacs29-pgtk
        nil
        python3Packages.pandas
        python3Packages.python-lsp-server
        tree-sitter-grammars.tree-sitter-python
        tree-sitter-grammars.tree-sitter-typescript
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
        fragments
        geary
        gimp
        gnome-calculator
        gnome-sound-recorder
        gnome-terminal
        gnome-tweaks
        inkscape
        libreoffice
        nautilus
        nicotine-plus
        obs-studio
        rhythmbox
        steam
        telegram-desktop
        vesktop
        vscodium-fhs
        zoom-us
      ];

      servicePackages = with pkgs; [
        linuxHeaders
        gcc
        binutils
        openvpn
        wineWowPackages.wayland
        wl-clipboard
      ];

    in builtins.concatLists
    [ consolePackages desktopPackages emacsPackages programPackages servicePackages ];
  };
}
