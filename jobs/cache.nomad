job "cache" {
    datacenters = ["caravan"]

    group "server" {
        network {
        	mode = "host"
        }

        task "redis" {
        	driver = "raw_exec"
        	config {
        		command = "/run/current-system/sw/bin/redis-server"
        	}
        }
    }
}
