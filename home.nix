{ home-manager, pkgs, ... }:
{
  imports = [home-manager.nixosModules.home-manager];
  home-manager.users.max = {
    home.stateVersion = "22.05";
    programs = {
      git = {
        enable = true;
        userName = "maxastyler";
        userEmail = "maxastyler@gmail.com";
      };
      bash = {
        enable = true;
        historyControl = ["erasedups"];
        bashrcExtra = builtins.readFile ./vterm_bash;
      };
      direnv = {
        enable = true;
        enableBashIntegration = true;
        nix-direnv.enable = true;
        stdlib = builtins.readFile ./direnvrc;
      };
    };
  };
}
