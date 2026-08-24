{ config, pkgs, quickshell, zen-browser, ... }:

{
  # ============================================================================
  # USER METADATA & SPECIFIC PACKAGES
  # ============================================================================
    home.username = "razen";
    home.homeDirectory = "/home/razen";

    home.packages = with pkgs; [
        kdePackages.kate
        vscode
        firefox

        # Hyprland essentials & Wayland tools
        kitty           # Terminal
        rofi            # App launcher
        waybar          # Top bar (Temporary)
        dunst           # Notifications daemon
        hyprpaper       # Wallpaper manager

        # Quickshell widget framework
        quickshell.packages.${pkgs.system}.default


        zen-browser.packages.${pkgs.system}.default
    ];

  xdg.configFile = {
    "hypr".source = ./config/hypr;
    "waybar".source = ./config/waybar;
    "rofi".source = ./config/rofi;
    "kitty".source = ./config/kitty;
  };


  # ============================================================================
  # GIT CONFIGURATION
  # ============================================================================
    programs.git = {
        enable = true;
        userName = "Alejandro-rodriguezf";
        userEmail = "alejandro.rodriguezf@udc.es";
    };

  # ============================================================================
  # HOME MANAGER
  # ============================================================================
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
}