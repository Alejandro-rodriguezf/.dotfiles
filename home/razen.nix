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
      kdePackages.okular
      firefox
      discord

      # Hyprland essentials & Wayland tools
      kitty           # Terminal
      rofi            # App launcher

      # Screenshot tools
      grim            # Grab screen pixels
      slurp           # Region selector
      wl-clipboard    # Copy to clipboard
      satty           # Screenshot editor/annotation

      # Quickshell widget framework
      quickshell.packages.${pkgs.system}.default

      zen-browser.packages.${pkgs.system}.default

      # Audio management - lets you pick mic/output devices per-app (Discord etc.)
      pavucontrol     # GUI mixer/device picker
      easyeffects     # Mic noise suppression, useful for voice calls

      # eduroam CAT installer (cat.eduroam.org) needs these Python bindings to talk to
      # NetworkManager over dbus - without dbus-python it falls back to writing your
      # password in plaintext to a wpa_supplicant file, which we want to avoid
      (python3.withPackages (ps: [ ps.pygobject3 ps.dbus-python ]))
      gobject-introspection
      gtk3

      # Archive handling
      unzip

      # Nautilus (GNOME Files)
      nautilus

      # "open archivo.pdf" al estilo macOS
      (writeShellScriptBin "open" ''exec xdg-open "$@"'')
  ];

  xdg.configFile = {
    "hypr".source = ./config/hypr;
    "rofi".source = ./config/rofi;
    "kitty/kitty.conf".source = ./config/kitty/kitty.conf;
  };

  # ============================================================================
  # SERPANTINUM SHELL CONFIGURATION
  # ============================================================================
  programs.serpantinum = {
    enable = true;
    systemd.enable = true;

    settings = {
      wallpaperDir = "/home/razen/Imágenes/Wallpapers";

      general = {
        language = "es";
        weatherUnit = "metric";
      };

      bar = {
        position = "top";
        style = "modular";
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
  # PDF VIEWER
  # ============================================================================
  xdg.mimeApps.defaultApplications."application/pdf" = "zen-beta.desktop";

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