{ hostName, pkgs, rootPassword, ... }:
{
    networking = {
        inherit hostName;

        dhcpcd.enable = false;
        firewall.enable = false;

		interfaces.eth0 = {
    		useDHCP = false;
    		ipv4.addresses = [{ address = "10.3.1.2"; prefixLength = 24; }];
		};

        defaultGateway = { address = "10.3.1.1"; interface = "eth0"; };
    };

    zramSwap.enable = true;

    users.users.root = {
        openssh.authorizedKeys.keyFiles = [ ../config/ssh/guest_ssh_key.pub ];
    };

    users.mutableUsers = false;

    services.resolved.enable = true;

    services.openssh = { enable = true; permitRootLogin = "yes"; };

    services.nomad = {
        enable = true;
        package = pkgs.nomad_1_1;

        enableDocker = false;
        dropPrivileges = false;

        extraPackages = with pkgs; [
            deno
            redis
        ];

        settings = {
            datacenter = "caravan";
            plugin.raw_exec.config.enabled = true;

            server = {
                enabled = true;
                bootstrap_expect = 1;
            };

            client = {
                enabled = true;
                servers = [ "localhost" ];

            };
        };
    };

    environment.systemPackages = with pkgs; [
        curl openssl iproute2
        psmisc htop tmux moreutils
        git deno redis nomad_1_1
    ];
}
