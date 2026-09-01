{
    description = "NixOS / Home Manager main configuration";

    # INPUTS: Software/Repositories external sources to use 
    inputs = {
        # Main NixOS official package repository
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

        # Home Manager
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs"; # Home Manager will use same version as system for nixpkgs
        };

        # Wallpaper Manager: skwd-wall
        skwd-wall.url = "github:liixini/skwd-wall";

        # Quickshell
        quickshell = {
            url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        # Zen Browser
        zen-browser = {
            url = "github:0xc000022070/zen-browser-flake";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        # Serpantinum Shell
        serpantinum = {
            url = "github:ilyamiro/serpantinum";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    # OUTPUTS: Built from inputs.
    outputs = { self, nixpkgs, home-manager, quickshell, zen-browser, skwd-wall, serpantinum, ... }@inputs: {

        nixosConfigurations = {

            nixos = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    ./configuration.nix
                    skwd-wall.nixosModules.default
                    serpantinum.nixosModules.default # Habilita prerrequisitos del sistema

                    home-manager.nixosModules.home-manager
                    {
                        home-manager.useGlobalPkgs = true;
                        home-manager.useUserPackages = true;
                        home-manager.backupFileExtension = "backup";
                        # Pasamos serpantinum a los argumentos de Home Manager
                        home-manager.extraSpecialArgs = { inherit quickshell zen-browser serpantinum; };                        
                        home-manager.users.razen = import ./home/razen.nix;
                    }
                ];
            };
        };
    };
}