# This is a flake for a raspberry Pi 3 SD card image

After editing the flake and config files you build with:

*Note*: The flake will need editing in order to compile on an x86_64 host,
many packages cannot be built during the compiling process so it is wise to comment out packages until you're builing on the aarch64 host.

```bash
nix run nixpkgs#nixos-generators -- -f sd-aarch64 --flake .#pi --system aarch64-linux -o ./pi.sd --show-trace
```

Once the process is complete you'll be left with a result that points to a directory or `result` called `pi.sd/`.
In this directory you'll find a `nixos-image-sd-card-*-aarch64-linux.img` file.

Now after pluggin your SD card into your PC you will run the following command:
```bash
sudo dd if=pi.sd/sd-image/nixos-image-sd-card-*aarch64-linux.img of=/dev/sdX bs=4096 conv=fsync status=progress
```
After `dd` is done running you can run `sync` and eject it safely.

*When removing your result or pi.sd in this flake, don't have the `/` when using the `rm` command.

