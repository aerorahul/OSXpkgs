help([[
Load environment for running JEDI applications with MPICH.
]])

local pkgName    = myModuleName()
local pkgVersion = myModuleVersion()
local pkgNameVer = myModuleFullName()

conflict(pkgName)

load("gnu/7.3.0")
load("szip/2.1.1")
load("mpich/3.2.1")

load("eigen/3.3.5")
load("boost/1.68.0")

load("ecbuild/2.9.3")

load("eckit/0.23.0")
load("fckit/develop")

load("hdf5/1.10.3")
load("netcdf/4.6.1")

whatis("Name: ".. pkgName)
whatis("Version: ".. pkgVersion)
whatis("Category: Application")
whatis("Description: JEDI Environment with MPICH")
