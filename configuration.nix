{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # ============================================================================
  # BOOTLOADER & EFI
  # ============================================================================
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
    extraEntries = ''
      menuentry "EndeavourOS" {
        insmod part_gpt
        insmod fat
        search --no-floppy --fs-uuid --set=root 5092-5813
        linux /vmlinuz-linux root=UUID=6f2dd00e-8452-47f8-9184-62bfd4d5ff4d rw quiet
        initrd /initramfs-linux.img
      }
    '';
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # ============================================================================
  # FILE SYSTEMS & SHARED PARTITIONS
  # ============================================================================
  fileSystems."/mnt/Universidad" = {
    device = "/dev/disk/by-uuid/64af9e62-e836-4c64-a4ef-b69b956787eb";
    fsType = "ext4";
    options = [
      "defaults" # Opciones estándar de lectura/escritura
      "nofail"   # Si la partición falla o el disco no está conectado, el sistema arranca igual sin quedarse colgado
    ];
  };

  # ============================================================================
  # NETWORK & LOCALIZATION
  # ============================================================================
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Madrid";
  i18n.defaultLocale = "es_ES.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_ES.UTF-8";
    LC_IDENTIFICATION = "es_ES.UTF-8";
    LC_MEASUREMENT = "es_ES.UTF-8";
    LC_MONETARY = "es_ES.UTF-8";
    LC_NAME = "es_ES.UTF-8";
    LC_NUMERIC = "es_ES.UTF-8";
    LC_PAPER = "es_ES.UTF-8";
    LC_TELEPHONE = "es_ES.UTF-8";
    LC_TIME = "es_ES.UTF-8";
  };

  # ============================================================================
  # USER ACCOUNTS
  # ============================================================================
  users.users."razen" = {
    isNormalUser = true;
    description = "Alex";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # ============================================================================
  # KEYBOARD LAYOUT
  # ============================================================================
  services.xserver.xkb = {
    layout = "es";
    variant = "";
  };
  console.keyMap = "es";
    
  # ============================================================================
  # PLASMA DESKTOP ENVIRONMENT
  # ============================================================================
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # ============================================================================
  # HYPRLAND WINDOW MANAGER
  # ============================================================================
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Enable XDG Desktop Portals (Screenshots, file selection...)
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Recommended environment variables for Qt/GTK apps in Wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Makes Electron apps use native Wayland (Spotify, VSCode...) 
  };

  # ============================================================================
  # HARDWARE & AUDIO
  # ============================================================================
  hardware.bluetooth.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ============================================================================
  # SYSTEM PACKAGES & NIX SETTINGS
  # ============================================================================
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    git
    os-prober
    ntfs3g
  ];

  system.stateVersion = "26.05";
}