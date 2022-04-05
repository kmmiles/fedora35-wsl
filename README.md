# fedora35-wsl
[![build](https://github.com/kmmiles/fedora35-wsl/actions/workflows/build.yml/badge.svg)](https://github.com/kmmiles/fedora35-wsl/actions/workflows/build.yml)
[![release](https://github.com/kmmiles/fedora35-wsl/actions/workflows/release.yml/badge.svg)](https://github.com/kmmiles/fedora35-wsl/actions/workflows/release.yml)

A sensible base fedora35 distro for wsl2.

Built from the `fedora:35` container with the following additions:

- a default `wsl` user with passwordless `sudo` access.
- `podman` working out of the box.
- `wl-clipboard` to facilitate copying/pasting to/from Windows via Wayland.
- access to/from other distributions @ `/mnt/wsl/instances`
- links to Windows folders in the home directory (`Desktop`, `Documents`, `Pictures`, etc)
- the `rpmfusion` repository.
- `redhat-lsb-core`, `git`, and `zsh`.

## Requirements

Windows with WSL2. 

## Install

- Download and extract the [release](https://github.com/kmmiles/fedora35-wsl/releases) zip.
- Run the `install.bat` script.

NOTE: Windows 10 lacks the `command` directive in `/etc/wsl.conf`, which allows running commands on boot.
For the bind mount feature, Windows 10 users must place the following in their `~/.zshrc` file:

```
wsl-on-boot > ~/wsl-on-boot.log 2>&1
```

## Build it yourself

You'll need `docker` or `podman`.

- Check out the source code and run `./bin/release`
- Copy the zip from `dist` to windows, extract it, and run `install.bat`

## Make your own custom distro

You can either:

- Fork this repo and add your own modifications.

- Pull this image into your own `Dockerfile` i.e.

```
FROM ghcr.io/kmmiles/fedora35-wsl
```

## How it works

WSL2 distributions are really just containers. We build a container of our liking with `docker`, then export the rootfs as a tarball.
Then this tarball can be imported as a WSL distribution with `wsl.exe --import`.
