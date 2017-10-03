# Modules
The Modules system used to upgrade and deploy Linux OSes

Module:
-------
A bash script designed to deploy, configure or setup a certain piece of software on a specified Linux OS.

Blueprint:
----------
A bash script designed to import and then run a series of modules to convert a Linux OS into a specified Linux OS class.

How it works:
-------------
You pick the most appropriate 'deployment' script for your specific machine's OS in order to convert to the specific OS class you want. Simply copy down the script file (for example, King-Pigeon.sh for King-Pigeon) and run it. Each OS script will have specific environmental requirements.

Environmental requirements:
---------------------------

King-Pigeon.sh [in-progress]
--------------
Built for a 64-bit freshly installed, default settings Devuan Jessie Desktop AMD64 ISO.

Tumbler-Pigeon.sh [not yet ready]
-----------------
Built for a 32-bit freshly installed, default settings Devuan Jessie Desktop i368 ISO.

Borg-Pigeon [not yet ready]
-----------
Has different 'drone unit' scripts for specific types of OS to assimilate into Devuan (see below).

Borg-Pigeon Warning:
--------------------
Please be aware that Borg-Pigeon is an extremely dangerous conversion script system to use, and will very likely leave your OS in an unusable state because other OSes are largely incompatible with Devuan, and it's advisible you install Devuan via ISO. This upgrade path is intended to be a 'Live media free' upgrade/conversion route, or a way of trying to preserve system configurations whilst trying to escape systemd. Borg-Pigeon offers no guarantee of stability, and considers it's goal 'complete' when your previous OS can boot onto a Devuan image-kernel with access to Devuan repositories. This of course means that systemd is likely still installed. We choose the unpleasant connotation of a cyborg to confer an image of how unnatural the hybridisation is on purpose.

Lubuntu-1404-Drone.sh [not yet ready]
----------------
Desktop 14.04 Lubuntu OS (bit-type agnostic)

Debian-Jessie-Drone.sh [not yet ready]
---------------
Desktop Debian Jessie OS (bit-type agnostic)

