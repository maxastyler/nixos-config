{ config, lib, pkgs, ... }: {
  users.users.max.packages = [ pkgs.android-studio ];
  # Enable this to get android godot builds https://timchi.me/blog/2024-03-08/

  programs.nix-ld = {
    enable = true;
    programs.nix-ld.libraries = with pkgs; [
      # Add any missing dynamic libraries for unpackaged programs
      # here, NOT in environment.systemPackages
      aapt
      gradle
    ];
  };

  # Enable java, including the $JAVA_HOME variable
  programs.java = {
    enable = true;
    package = pkgs.jdk17;
  };

}
