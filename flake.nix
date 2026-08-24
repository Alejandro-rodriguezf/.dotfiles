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
    };

    # OUTPUTS: Built from inputs.
    outputs = {self, nixpkgs, home-manager, quickshell, zen-browser, ...}@inputs: {

        nixosConfigurations = {

            nixos = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    ./configuration.nix

                    home-manager.nixosModules.home-manager
                    {
                        home-manager.useGlobalPkgs = true; # Uses packages installed on system level
                        home-manager.useUserPackages = true; # Installs user packages in /etc/profiles
                        home-manager.backupFileExtension = "backup"; # Creates backups from conflicts (.backup)
                        home-manager.extraSpecialArgs = { inherit quickshell zen-browser; };                        home-manager.users.razen = import ./home/razen.nix; # razen config file
                    }
                ];
            };
        };
    };

}