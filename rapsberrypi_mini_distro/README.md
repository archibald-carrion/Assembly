# Building a Minimal Raspberry Pi 3B Image with Poky for ARM Assembly Learning

This guide walks you through creating a custom, minimal Linux image for the Raspberry Pi 3B using the Yocto Project (Poky) and the `meta-raspberrypi` layer. The resulting image is stripped of graphical interfaces, Bluetooth, and Wi-Fi, leaving a lighter system with the essentials for writing and running ARM assembly programs.

By following these steps, you'll end up with a bootable SD card that boots directly to a console on HDMI. You can then write raw ARM assembly, assemble it with `as`, link it with `ld`, and run it directly on the hardware.

## Step‑by‑Step Instructions

### 1. Clone Poky (Yocto Project Reference Distribution)

Create a working directory and clone the Poky repository. We'll use the **Scarthgap** branch with the following hashes `1d54d1c4736a114e1cecbe85a0306e3814d5ce70` for poky, and `2c646d29912dcc873469a57b1c207e1549c5094d` for meta-raspberrypi:

```bash
mkdir -p ~/Assembly/raspberrypi_mini_distro
cd ~/Assembly/raspberrypi_mini_distro
git clone git://git.yoctoproject.org/poky
cd poky
git checkout scarthgap
```

### 2. Clone the Raspberry Pi BSP Layer

The `meta-raspberrypi` layer provides board support for all Raspberry Pi models. Clone it inside the Poky directory and also switch to the `scarthgap` branch.

```bash
cd ~/Assembly/raspberrypi_mini_distro/poky
git clone git://git.yoctoproject.org/meta-raspberrypi
cd meta-raspberrypi
git checkout scarthgap
```

### 3. Set Up the Build Environment

Poky provides an environment setup script that creates a build directory and initializes the build configuration.

```bash
cd ~/Assembly/raspberrypi_mini_distro/poky
source oe-init-build-env build
```

This command places you inside the `build` directory and sets all necessary environment variables.

### 4. Create a Custom Layer for Your Image

Create the directory for image recipes and the recipe file itself:

```bash
mkdir -p meta-mylayer/recipes-core/images
touch meta-mylayer/recipes-core/images/asm-dev-image.bb
```

Open `asm-dev-image.bb` and add the following content:

```bitbake
SUMMARY = "Minimal ASM dev image for Raspberry Pi"

inherit core-image

IMAGE_FEATURES += "ssh-server-dropbear"

IMAGE_INSTALL = "\
    packagegroup-core-boot \
    kernel-modules \
    binutils \
    nasm \
    vim \
    dropbear \
    "
```

- `binutils` gives us `as` (assembler) and `ld` (linker).
- `nasm` -> I need to delete this one, as it is an X86/X86_64 assembler and is useless in our usecase where Pi is ARM
- `vim` is a simple text editor; feel free to replace with `nano` or another editor.
- `dropbear` is a lightweight SSH server -> I have not tested this feature yet

### 5. Configure the Build (`local.conf`)

The main build configuration is in `build/conf/local.conf`. Replace its contents with the following. This configuration targets the Raspberry Pi 3B, disables unnecessary features (X11, Wayland, Bluetooth, Wi‑Fi), and ensures the HDMI console works.

```bitbake
#
# Machine Selection
#
MACHINE ??= "raspberrypi3"

#
# Where to place downloads
#
#DL_DIR ?= "${TOPDIR}/downloads"

#
# Where to place shared-state files
#
#SSTATE_DIR ?= "${TOPDIR}/sstate-cache"

#
# Where to place the build output
#
#TMPDIR = "${TOPDIR}/tmp"

#
# Default policy config
#
DISTRO ?= "poky"

#
# Package Management configuration
#
PACKAGE_CLASSES ?= "package_rpm"

#
# Extra image configuration defaults
#
EXTRA_IMAGE_FEATURES ?= "debug-tweaks"

#
# Additional image features
#
USER_CLASSES ?= "buildstats"

#
# Interactive shell configuration
#
PATCHRESOLVE = "noop"

#
# Disk Space Monitoring during the build
#
BB_DISKMON_DIRS ??= "\
    STOPTASKS,${TMPDIR},1G,100K \
    STOPTASKS,${DL_DIR},1G,100K \
    STOPTASKS,${SSTATE_DIR},1G,100K \
    STOPTASKS,/tmp,100M,100K \
    HALT,${TMPDIR},100M,1K \
    HALT,${DL_DIR},100M,1K \
    HALT,${SSTATE_DIR},100M,1K \
    HALT,/tmp,10M,1K"

#
# Qemu configuration
#
PACKAGECONFIG:append:pn-qemu-system-native = " sdl"

# CONF_VERSION is increased each time build/conf/ changes incompatibly.
CONF_VERSION = "2"

#
# Custom settings for minimal ASM dev image
#

# Strip out unnecessary distro features (no GUI, no bluetooth, no wifi)
DISTRO_FEATURES:remove = "x11 wayland opengl bluetooth wifi 3g nfc"

# Ensure HDMI console works — tty1 is the HDMI output on RPi
CMDLINE:append = " console=tty1"
```

**Note:** The `debug-tweaks` feature allows root login without a password. This is convenient for a learning environment but **not** secure for production.

### 6. Build the Image

Now you're ready to build your custom image. This step can take a long time (hours) on the first run, as it downloads sources and compiles everything from scratch. Subsequent builds will be faster thanks to cached artifacts.

```bash
cd ~/Assembly/raspberrypi_mini_distro/poky/build
bitbake asm-dev-image
```

If the build succeeds, the final image will be located in `tmp/deploy/images/raspberrypi3/`. Look for a file named `asm-dev-image-raspberrypi3.rootfs.wic.bz2` – that is the compressed SD card image.

### 7. Flash the Image to an SD Card

Use [Balena Etcher](https://www.balena.io/etcher/) (or any tool that can write `.wic.bz2` files directly) to flash the image onto your microSD card.

1. Insert the microSD card into your host machine.
2. Open Balena Etcher.
3. Select the `.wic.bz2` file.
4. Select the target SD card.
5. Click **Flash!**.

After flashing, insert the card into your Raspberry Pi 3B.

### 8. Boot the Pi and Connect

- Connect an HDMI monitor and a USB keyboard (optional – you can also work entirely over SSH once the IP is known).
- Power on the Pi.

The system will boot and present a login prompt on the HDMI console. Because we included `debug-tweaks`, you can log in as `root` with **no password** (just press Enter).

### 9. Write and Run ARM Assembly

Now you're inside the Pi (either on the console or via SSH). Let's write a minimal ARM assembly program that prints "Hello World" using Linux syscalls.

Create a file, `touch hello.s`, with the following content:

```armasm
.section .data
msg:
    .ascii "Hello World\n"
    msg_len = . - msg

.section .text
.global _start

_start:
    @ write(1, msg, msg_len)
    mov r0, #1          @ file descriptor: 1 = stdout
    ldr r1, =msg        @ pointer to message
    mov r2, #msg_len    @ message length
    mov r7, #4          @ syscall number: write
    swi #0              @ invoke syscall

    @ exit(0)
    mov r0, #0          @ exit code 0
    mov r7, #1          @ syscall number: exit
    swi #0              @ invoke syscall
```

Assemble and link it:

```bash
as -o hello.o hello.s
ld -o hello hello.o
```

Run it:

```bash
./hello
```

You should see `Hello World` printed on the screen.

## References

- [Yocto Project Documentation](https://docs.yoctoproject.org/)
- [meta-raspberrypi Layer](https://git.yoctoproject.org/meta-raspberrypi/)
- [ARM System Calls](https://syscalls.w3challs.com/?arch=arm_strong) – a handy table of ARM Linux syscalls
- [ARM System Calls](https://arm.syscall.sh/) - another handy table of ARM sycalls


## TODO
- [ ] Add instruction on how to use ssh instead of connecting a monitor and keyboard
