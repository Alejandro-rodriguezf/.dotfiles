{
    description = "NixOS / Home Manager main configuration";

    # INPUTS: Software/Repositories external sources to use 
    inputs = {
        # Main NixOS official package repository
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

        # Home Manager: Manages /home/razen and user programs
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs"; # Home Manager will use same version as system for nixpkgs
        };
    };

    # OUTPUTS: Built from inputs.
    outputs = {self, nixpkgs, home-manager, ...}@inputs: {

        nixosConfigurations = {

            nixos = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    ./configuration.nix

                    home-manager.nixosModules.home-manager
                    {
                        home-manager.useGlobalPkgs = true; # Uses packages installed on system level
                        home-manager.useUserPackages = true; # Installs user packages in /etc/profiles
                        home-manager.users.razen = import ./home/razen.nix; # razen config file
                    }
                ];
            };
        };
    };

};