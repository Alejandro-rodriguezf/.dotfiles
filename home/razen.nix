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
        # waybar        # Ya no la necesitas si usas la barra de serpantinum
        # dunst         # Not needed - Serpantinum's Quickshell shell has its own notification popups
        # hyprpaper     # Not needed - Serpantinum has its own built-in wallpaper engine (would fight over the background layer)

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

        # Nautilus (GNOME Files) - el gestor de archivos que usa el rice original de
        # serpantinum. Solo está dentro del wrapper de serpantinum por defecto (no en tu
        # PATH normal); lo añadimos aquí para poder lanzarlo tú mismo con "nautilus".
        # Sigues teniendo dolphin como $fileManager en SUPER+E - dímelo si quieres cambiarlo.
        nautilus

        # "open archivo.pdf" al estilo macOS - abre con la app gráfica por defecto (Okular
        # para PDFs), en vez de tener que acordarte de "xdg-open"
        (writeShellScriptBin "open" ''exec xdg-open "$@"'')
    ];

  xdg.configFile = {
    "hypr".source = ./config/hypr;
    "rofi".source = ./config/rofi;
    # Only symlink kitty.conf itself (not the whole directory) - Matugen needs to write
    # colors.conf into ~/.config/kitty/ at runtime, which it can't do if the dir is read-only
    "kitty/kitty.conf".source = ./config/kitty/kitty.conf;
  };

  # ============================================================================
  # SERPANTINUM SHELL CONFIGURATION
  # ============================================================================
  programs.serpantinum = {
    enable = true;
    systemd.enable = true; # Arranca automáticamente con tu sesión de usuario

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
  # Okular: visor de PDFs gráfico de KDE (cómodo con ratón, anotaciones, etc.)

  # Para que "xdg-open archivo.pdf" (o "open archivo.pdf") abra Okular.
  # Si prefieres abrirlos con el navegador, cambia esto por el .desktop de Zen
  # (búscalo con: ls /etc/profiles/per-user/razen/share/applications | grep -i zen)
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