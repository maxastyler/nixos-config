{ home-manager, pkgs, ... }:
{
  imports = [home-manager.nixosModules.home-manager];
  home-manager.users.max = {
    home.stateVersion = "22.05";
    programs.git = {
      enable = true;
      userName = "maxastyler";
      userEmail = "maxastyler@gmail.com";
    };
  };
}
