{
  description = "NixOS in MicroVMs";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-21.05";
  inputs.microvm.url = "github:astro/microvm.nix";
  inputs.microvm.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, microvm }:
    let
      system = "x86_64-linux";
    in {
        defaultPackage.${system} = self.packages.${system}.my-microvm;

        packages.${system} = {
            my-microvm = microvm.lib.runner {
                inherit system;
                hypervisor = "firecracker";

                interfaces = [
                  {
                      type = "tap";
                      id = "tap0";
                      mac = "76:49:c4:2a:48:50";
                  }
                ];

                nixosConfig = let pkgs = nixpkgs.legacyPackages.${system}; in
                	(import ./nix/guest.nix)
                	{
                    	inherit pkgs;
                    	hostName = "nomad-op-1";
                    	rootPassword = "changeme";
                	} // {
                    	boot.postBootCommands = ''
                        	systemctl mask mount-pstore.service
                    	'';
                	};

                volumes = [
                    {
                        mountpoint = "/var";
                        image = "var.img";
                        size = 5000;
                    }
                ];

                mem = 4096;
                vcpu = 4;

                socket = "firecracker.socket";
            };
        };
    };
}
