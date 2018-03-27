# Overview

This experiment were performed on commit -> 8bc0fee65db7a4682c6d4e62f3ef0c75dbd8fd16

Workload: 300.000 users
Time: 06h - 08:30h

## Changes:

* Removed some of the simulator bottlenecks:
  * Reducing the largest distance a driver can search for a parking spot
  * Increase the number of concurrent actors to compute drivers' routes
  * Killing drivers that don't find parking spots
* The output of the simulator was improved as well 
* We also improved the experiment output charts
