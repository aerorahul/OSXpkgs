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
* CGAL
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

### Configuration options
Configuration for the installation is controlled via `config/config.sh`
Follow the details in each section.

Set the compiler and mpi families to build the stack.
```
export FAMILY_COMPILER="gnu"
```
If using system `gcc`, a modulefile will be deployed, but may need an update to provide correct version number e.g. `gfortran-7` instead of `gfortran`.

Specify the installation path for packages.
```
export PREFIX="$HOME/opt"
```
If `$PREFIX` is anything other than `/opt`, the user will have to define an environment variable `export OPT=$PREFIX` in order for the modulefiles to correctly define the installation path of the packages.

### Installation
Installation is performed in 2 steps:
- First if neccessary execute `build_base.sh`.  This builds or sets up the compiler and mpi family.  Only GNU compilers can be built with this script.  For CLang or Intel, follow the providers instructions.  It can also use the `native-module`; which implies to use an existing module for that compiler/mpi family.
If a modulefile does not exist, the `setup-module` option can be used to set up the modulefile.  It may need manual intervention.

### Verify installation
Check the installation; will execute ctest or make check
```
export CHECK="YES" | "NO" # Enable | Disable checking
```
### Modules
A modulefile will be created from a template and deployed to `$OPT/modulefiles` following `Lmod` Software Module hierarchy.
