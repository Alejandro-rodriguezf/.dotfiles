{ config, pkgs, ... }:

{
    # User metadata
    home.username = "razen";
    home.homeDirectory = "/home/razen";

    # User specific packages
    home.packages = with pkgs; [
        kdePackages.kate
        vscode
        firefox
    ];

    # Git configuration
    programs.git = {
        enable = true;
        userName = "Alejandro-rodriguezf";
        userEmail = "alejandro.rodriguezf@udc.es";
    };

  # Home Manager state version
  home.stateVersion = "26.05";

  # Allow Home Manager to manage itself
  programs.home-manager.enable = true;
}