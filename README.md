Wager Social Learning fMRI Study
================================

This code is associated with the following article:
Diaconescu, Stacy et al., 2020, Neural arbitration between social and individual learning systems, eLife, [10.7554/eLife.54051](https://doi.org/10.7554/eLife.54051)

Master Thesis of Madeline Stecy (Sep 2015 - Feb 2016)
Supervisor: Andreea Diaconescu
Supervisor and Sponsor: Philippe Tobler
Contributors: Lars Kasper, Christoph Mathys, Chris Burke, Zoltan Nagy
Code Review: Lars Kasper

In total, 40 subjects were scanned and analyzed at the SNS lab in Zurich.

This repository contains the code for
- fMRI preprocessing of the data (SPM 12)
    - in particular, batch reporting of preprocessing quality
- behavioral modeling via the HGF
- physiological noise modeling via the PhysIO toolbox
- integration of behav/phys models into SPM GLM estimation

Installation
------------

Getting Started
---------------
Run `startup.m` in the main code folder to set up the environment and `wagad_main.m` to run the analysis.
