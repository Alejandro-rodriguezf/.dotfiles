{ config, pkgs, quickshell, zen-browser, serpantinum, ... }:

{
  # ============================================================================
  # MODULE IMPORTS
  # ============================================================================
  imports = [
    serpantinum.homeManagerModules.default
  ];

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
        # waybar        # Ya no la necesitas si usas la barra de serpantinum
        dunst           # Notifications daemon
        hyprpaper       # Wallpaper manager

        # Screenshot tools
        grim            # Grab screen pixels
        slurp           # Region selector
        wl-clipboard    # Copy to clipboard
        satty           # Screenshot editor/annotation

        # Quickshell widget framework
        quickshell.packages.${pkgs.system}.default

        zen-browser.packages.${pkgs.system}.default
    ];

  xdg.configFile = {
    "hypr".source = ./config/hypr;
    "rofi".source = ./config/rofi;
    "kitty".source = ./config/kitty;
  };

  # ============================================================================
  # SERPANTINUM SHELL CONFIGURATION
  # ============================================================================
  programs.serpantinum = {
    enable = true;
    systemd.enable = true; # Arranca automáticamente con tu sesión de usuario

    settings = {
      wallpaperDir = "/home/razen/Pictures/Wallpapers";

      general = {
        language = "es";
        weatherUnit = "metric";
      };

      bar = {
        position = "top";
        style = "islands";
        width = 40;
        workspaceCount = 10;
        modules = {
          left = [ "workspaces" ];
          center = [ "time" ];
          right = [ "tray" [ "kb" "wifi" "bt" "vol" "bat" ] ];
        };
      };

      theme = {
        fontFamily = "Adwaita Mono";
        borderRadius = 12;
        matugen = true;
      };
    };
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