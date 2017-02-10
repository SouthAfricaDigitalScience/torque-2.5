[![Build Status](https://ci.sagrid.ac.za/buildStatus/icon?job=torque-deploy)](https://ci.sagrid.ac.za/job/torque-deploy/)

# torque-2.5

A repository containing torque 2.5.13 installation scripts used by Jenkins.
This repository builds torque with various configurations.

# Dependencies

  * gmp
  * mpfr
  * mpc
  * ncurses
  * gcc/`${GCC_VERSION}`

## GCC Versions

  * 4.9.2
  * 5.1.0
  * 5.2.0

# Configuration

```
--prefix=${SOFT_DIR}-gcc-${GCC_VERSION} \
--enable-shared \
--enable-static \
--disable-gui \
--with-server-home=${SOFT_DIR}-gcc-${GCC_VERSION}/spool
```

# how to use this repo

This repo is used entirely by Jenkins to build site-specific TORQUE libraries, in order to simulate sites.
Some sites have customised TORQUEs, and we need to build flavourse of applications, such as OpenMPI, against these configurations.

# Contents of the repo

This repo contains two scripts

  1. `build.sh`
  2. `check-build.sh`
  3. `deploy.sh`

These define basically two test phases, the **build** and **functional** test phases, as well as the deploy phase respectively

## Branches

The branches track configurations of TORQUE. The master branch is the *vanilla* configuration.

## Build Test Phase

The build phase does the following things

  1. Set up the build environment variables
  2. Downloads the source code using `wget`
  4. Compile the source into an executable form.
  5. Create a modulefile which loads the dependencies and sets the environment variables needed to execute the application.

The build phase should pass iff the expected libraries and executable files are present. **It is your responsibility to define where these files are, on a case-by-case basis**.

## Functional test phase

The test phase does the following things :

  1. Loads the modulefile created by `check-build.sh`
  2. installs the libraries into the `$SOFT_DIR` directory

# When things go wrong

If you have a legitimate error, or need support, please [open an issue](../../issues)

# Citing
