{ config, pkgs, inputs, ... }:

{
  fonts =
    let unstable = inputs.nixpkgs-unstable.legacyPackages."${pkgs.system}";
    in {
      packages = with pkgs; [
        noto-fonts
        source-han-sans
        source-han-serif
        source-sans
        source-serif
        twitter-color-emoji
        unstable.nerd-fonts.iosevka
      ];

      fontconfig = {
        defaultFonts = {
          sansSerif = [ "Source Sans 3" ];
          serif = [ "Source Serif 4" ];
          monospace = [ "Iosevka Nerd Font Propo" "Iosevka Extended" ];
          emoji = [ "Twitter Color Emoji" ];
        };
      };
    };
}
