# Course Resources

> [!NOTE]
> This is the first semester we are including this GitHub Repository. As such it may be incomplete as it is. 
> If you find any resources that you think may help other students (or yourself later down the line) please open a PR, or message one of the TAs and we'll add it to this Repo. 
> 
> Thanks! - Arya
 
## Table of Contents
- [Resources to keep handy throughout the course](#resources-to-keep-handy-throughout-the-course)
  - [Build / Software](#build--software)
  - [Course Resources](#course-resources)
- [Jetson Setup](#jetson-setup)
  - [Flashing](#flashing)
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
- Tutorials
  - T01: [Intro to ROS2 & Docker](https://docs.google.com/presentation/d/1K31co8v4USm4_2cESYuqjPNqZoQiCe2PUaLETszIGgs/edit?usp=sharing)
  - T02: [Intro to F1Tenth Sim](https://docs.google.com/presentation/d/1gzLShZ_dFEMJVGpMChAIuLwfF2DFn4Bhhq5Du3wYgic/edit?usp=sharing)
  - T03: [Intro to Transforms in ROS2](https://docs.google.com/presentation/d/1knS8vr1PujoWJA4fAI38UPuO3Y_6ID6j6_iHFOGQSEM/edit?usp=sharing)
  - T04: [Setting up the F1Tenth Vehicle](https://docs.google.com/presentation/d/1qUhHTf37NphsV7j3qQJSxYWNWbWhbcixRTh88Ta6R44/edit?usp=sharing)
  - T05: [Running SLAM and Particle Filter](https://docs.google.com/presentation/d/1Hyb1tX576u7adukdh18C8gnibawEBhmE3w5rTCdUSSM/edit?usp=sharing)

## Jetson Setup

### Flashing
> [!NOTE]
> There are normally two ways to flash the operating system for the jetson: You can directly flash to an SD card or [M.2 SSD](https://www.google.com/search?q=what+is+an+M.2+SSD). We prefer the SSD option as it has more space and better data transfer speeds which can make data collection with ROS far easier in the future.
> 
> Below are several NVIDIA resources to get started on flashing the OS.
> - [Startup Guide](https://www.jetson-ai-lab.com/tutorials/initial-setup-jetson-orin-nano/)
> - [Moving OS from SD card to SSD](https://www.jetson-ai-lab.com/tutorials/ssd-docker-setup/) *Only needed if you didn't flash directly to the SSD*

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

6. Install required dependencies using rosdep

> [!TIP]
> ```bash
> # ensure you are in the workspace root (..._ws/ dir)
> $ rosdep update
> $ rosdep install --from-paths src --ignore-src -r -y
> ```

7. At this point you should be ready to build. navigate to the `ws` root and run `colcon build --symlink-install`. 

> [!TIP]
> A common troubleshooting technique for errors related to cmake (find_package) is to look for the corresponding package: `ros-humble-<package_name>` and install via apt