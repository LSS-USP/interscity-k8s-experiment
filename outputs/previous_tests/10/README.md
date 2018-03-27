# Overview

This experiment were performed on commit -> 76debc36fb42ec425a474cb6ba08f72a6cad614c

Workload: 500.000 users
Time: 05:40h - 8:20h

## Changes:

* Keep the best version of Simulator. It is running with 1 second/tick almost always
* I created a new endpoint to Data Collector that only returns the uuid of matched 
resources. This required a little change on Resource Discovery. And this removed
the main bottleneck on Data Collector, improving the perfomance considerably.

