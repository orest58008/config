{ config, lib, pkgs, ... }:

{
  users.users.orest = {
    isNormalUser = true;
    description = "Орест";
    extraGroups = [ "docker" "networkmanager" "wheel" "input" ];
    shell = pkgs.zsh;
  };

  /* home-manager.users.orest = {
       dconf.settings = {
         "org/gnome/desktop/input-sources" = {
           sources = [
             (mkTuple [ "xkb" "us" ])
             (mkTuple [ "xkb" "ua" ])
             (mkTuple [ "ibus" "libpinyin" ])
           ];
           xkb-options = [ "compose:rctrl" "caps:menu" ];
         };

         "org/gnome/desktop/interface" = {
           cursor-theme = "Posy_Cursor";
           gtk-theme = "Materia-dark";
           font-name = "sans-serif 11";
           icon-theme = "Papirus-Dark";
         };

         "org/gnome/desktop/wm/keybindings" = {
           switch-to-workspace-1 = [ "<Alt>1" ];
           switch-to-workspace-2 = [ "<Alt>2" ];
           switch-to-workspace-3 = [ "<Alt>3" ];
           switch-to-workspace-4 = [ "<Alt>4" ];
           switch-to-workspace-5 = [ "<Alt>5" ];
           switch-to-workspace-6 = [ "<Alt>6" ];
         };
       };

       home.stateVersion = "24.05"; # Don't change
     };
  */
}
