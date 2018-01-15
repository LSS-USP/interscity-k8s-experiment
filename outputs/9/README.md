# Overview

This experiment were performed on commit -> e4bbab4b5f916866f7ca16cff8a0d9ad37c38403

Workload: 500.000 users
Time: 05:40h - 8:20h

## Changes:

* Best version of Simulator. It is running with 1 second/tick almost always
* Debugging Data Collector execution time. I found that the method each,
which is responsible to load the data of the main query, is taking too long.
