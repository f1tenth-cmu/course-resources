# Course Resources

## Table of Contents
- [Resources to keep handy throughout the course](#resources-to-keep-handy-throughout-the-course)
  - [Build / Software](#build--software)
  - [Course Resources](#course-resources)
- [Jetson Setup](#jetson-setup)
  - [Flashing](#flashing)
  - [Flashing via SD Card](#flashing-via-sd-card)
- [Vehicle Configuration & Setup](#vehicle-configuration--setup)
- [Software Setup](#software-setup-ubuntu-2204-ros2-humble)

## Resources to keep handy throughout the course

### Build / Software 
- [Build docs](https://roboracer.ai/build) *Take a quick read. This has a bunch of resources pertaining to building and calibrating the physical race car as well as initial setup of sensors. However, note that some information may be incomplete, especially regarding Jetson initial setup*
- [Calibration troubleshooting]
- [Software setup troubleshooting]

### Course Resources
- [Schedule](https://docs.google.com/spreadsheets/d/1bt0gH0tqr_f2XELPPG4ZS8G0aTcS5gUXa9uPqXclwCM/edit?gid=1504543077#gid=1504543077)
- [Setting up Simulator](https://github.com/f1tenth-cmu/f1tenth_gym_ros)
- [Labs on GitHub](https://github.com/orgs/f1tenth-cmu/repositories)

## Jetson Setup

### Flashing
> [!NOTE]
> There are normally two ways to flash the operating system for the jetson: You can directly flash to an SD card or [M.2 SSD](https://www.google.com/search?q=what+is+an+M.2+SSD). We prefer the SSD option as it has more space and better data transfer speeds which can make data collection with ROS far easier in the future.
> 
> Below are several NVIDIA resources to get started on flashing the OS.
> - [Startup Guide](https://www.jetson-ai-lab.com/tutorials/initial-setup-jetson-orin-nano/)
> - [Moving OS from SD card to SSD](https://www.jetson-ai-lab.com/tutorials/ssd-docker-setup/) *Only needed if you didn't flash directly to the SSD*

### Flashing via SD Card
> [!CAUTION]
> The information below only applies to the SD-card setup. If you are using the NVIDIA SDK Manager on a Linux PC, this is all done automatically for you.

*This information is provided in greater detail in the startup guide linked above.*

For some background, our goal is to flash Jetpack 6.2 ([what is JetPack?](https://docs.nvidia.com/jetson/jetpack/introduction/index.html)) which includes a version of Ubuntu 22.04. This only works directly if the board's UEFI version (firmware that starts up the OS and hardware) is `>v36.0`. Older Jetsons are often at `v35.x` and have to be updated to `v36.x` first, before the SD card with JetPack 6.2 just works. 

- [Instructions to check my UEFI version](https://www.jetson-ai-lab.com/tutorials/initial-setup-jetson-orin-nano/#1%EF%B8%8F%E2%83%A3-check-if-jetson-uefi-firmware-version--360)

NOTE: UNFINISHED (all further information can be figured out from the startup guide linked above, though) 

## Vehicle Configuration & Setup

> [!NOTE]
> CHECKPOINT: By this point you should have a booted and working Jetson running JetPack 6.2

#TODO: add links to roboracer documentation

## Software Setup (Ubuntu 22.04: ROS2 Humble)

> [!WARNING]
> F1tenth documentation, including Readmes, in the main repos such as `f1tenth_system` are written for ROS2 foxy (Ubuntu 20.04) and are thus out of date. Below is a list of modifications to the general process that must be undertaken with the more recent version


> [!NOTE]
> CHECKPOINT: if you don't yet understand how ROS2 works, ensure you've worked through the LAB 1 exercises and talk to your TAs if you have any questions. The following instructions assume basic familiarity with ROS2. It also assumes that the Hokuyo LiDAR and VESC have been configured. 

1. Install ROS2 from the install bash script as follows 

```bash
chmod +x scripts/install_ros2_humble.sh
sudo .scripts/install_ros2_humble.sh
```

*this will ensure that we install other required dependencies and initialize certain tools, like rosdep to work correctly.*

2. Create a folder in your main home directory called `f1tenth_ws`. You can also pick a different name, but the `*_ws` format is standard for ROS2 workspaces. Make a `src/` directory within the workspace 

> [!TIP]
> ```bash
> mkdir -p f1tenth_ws/src
> ```

3. Clone the `f1tenth_system` packages into the `src` folder. Once cloned, switch to the `/humble-devel` branch

> [!TIP]
> ```bash
> $ cd f1tenth_ws/src
> $ git clone https://github.com/f1tenth/f1tenth_system.git
> $ cd f1tenth_system
> $ git checkout humble-devel
>```

4. Ensure that you update all the submodules using the following command

> [!TIP]
> ```bash
> git submodule update --init --recursive --remote
> ```

5. Ensure that each submodule is also set to the correct ROS2 humble-related branch

> [!TIP]
> ```bash
> $ cd ackermann_mux
> $ git checkout foxy-devel # No changes between foxy and humble
> $ cd ..
> $ cd vesc
> $ git checkout humble
> $ cd ..
> $ cd teleop_tools
> $ git checkout humble-devel
> $ cd ..
>```

6. At this point you should be ready to build. navigate to the `ws` root and run `colcon build --symlink-install`. 

> [!TIP]
> A common troubleshooting technique for errors related to cmake (find_package) is to look for the corresponding package: `ros-humble-<package_name>` and install via apt