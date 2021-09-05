# ninomicro: nixos+nomad+deno+microvm

## howto

### build + run

```sh
nix build
nohup sudo nix run >./guest.log &2>1 &
```

### connect as root

```sh
./scripts/ssh.sh
```

### shut it down

```sh
./scripts/kill-firevm.sh
```

## but why?

just an opinionated, experimental testbed that glues together some of my favorite bits of tech (nomad, micro-vms, deno a.k.a. typescript-on-rust) to play with lightweight cluster management ideas.

