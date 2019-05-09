# Software Stack on OSX

This repository will facilitate building widely used packages from source, instead of using existing package managers e.g. [HomeBrew](https://brew.sh/) for OSX, [apt-get](https://linux.die.net/man/8/apt-get) for Linux, etc.

The following software can be built with the scripts under `ush` and instructions that follow:
* GCC
* Jasper
* Zlib
* SZip
* OpenMPI
* MPICH
* HDF5
* NetCDF
* Parallel NetCDF
* NCCMP
* Udunits
* NetCDF Climate Operators
* Boost (Full library or Headers only)
* Eigen
* LAPACK
* FFTW
* ecCodes
* ESMF
* ESMA-Baselibs

The following extra software required for [JEDI](https://github.com/jcsda/jedi-docs) project can also be built:
* ECBuild
* ECkit
* FCkit

### Pre-requisites
* `lmod` - Lua Modules for software stack management
* `wget`, `curl`, `git` - for fetching packages
* Other - `cmake`, `autoconf` - for building packages

### Packages
The individual packages will be fetched from their respective sources, but can be downloaded, untarred and placed under`pkg` if desired.  Most build scripts will look for directory `pkg/pkgName-pkgVersion` e.g. `pkg/hdf5-1_10_3`.

### Compiler options
Set the default compiler to build the stack.
```
export COMPILER="gnu-7.4.0"
```
If using system `gcc`, a modulefile will have to be manually deployed.

### MPI options
Set the default MPI flavour to build the stack (or disable it).
```
export MPI="" | "openmpi-3.1.2" | "mpich-3.2.1" # Disable MPI, use OpenMPI or MPICH for some software e.g. HDF5, NetCDF, Boost, etc.
```

### Installation path
Specify the installation path for packages.
```
export PREFIX="$HOME/opt"
```
If `$PREFIX` is anything other than `/opt`, the user will have to define an environment variable `export OPT=$PREFIX` in order for the modulefiles to correctly define the installation path of the packages.

### Verify installation
Check the installation; will execute ctest or make check
```
export CHECK="YES" | "NO" # Enable | Disable checking
```
### Modules
A modulefile will be created from a template and deployed to `$OPT/modulefiles` following `Lmod` Software Module hierarchy.
