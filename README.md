# System Creation Profile

This repository contains the mkimage[1] profile for generating my workstation
image. The system boots into tmpfs and does not retain state between reboots.

# How it works?

There are three STARs (Stateless Tar ARchive) for boot:

* system - an archive with a root partition containing the necessary
  packages and settings. The profile for its creation lies in the `system/`
  subdirectory.
* kmodules - contains kernel modules of a certain version. The profile to create
  it in the `kernel/` subdirectory.
* local - the archive contains installation-specific data and settings. Such as
  network settings, password hashes, private keys, etc.

At boot time the make-initrd-pipeline-stateless[2] module is used which creates
tmpfs, unpacks all three archives and transfers control there.

# How to preserve changes?

Well, as it was said, no changes in the system are saved between reboots. If you
want the changes to remain after reboot, they must be made to the system archive
or done in the local archive.

When I said that nothing is saved between reboots, I lied a little. The home
directory and /boot are not on tmpfs. These two directories are on a real drive,
which is mounted at `/sysimage/mutable`.

# Filesystem layout.

* `/sysimage/mutable` -- The mount location of the real device.
* `/sysimage/stateless` -- Location of archives to boot.

```
/sysimage/stateless/kernel-5.14.0.322-centos-alt1.el9
/sysimage/stateless/kernel-latest -> kernel-5.14.0.322-centos-alt1.el9
/sysimage/stateless/local-20230608.star
/sysimage/stateless/local-latest.star -> local-20230608.star
/sysimage/stateless/system-20230607.star
/sysimage/stateless/system-20230608.star
/sysimage/stateless/system-stable.star -> system-20230608.star
```

[1] https://github.com/altlinux/mkimage
[2] https://git.altlinux.org/gears/m/make-initrd-pipeline-stateless.git
