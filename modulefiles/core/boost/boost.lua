help([[
]])

local pkgName    = myModuleName()
local pkgVersion = myModuleVersion()
local pkgNameVer = myModuleFullName()

conflict(pkgName)

local opt = os.getenv("OPT") or "/opt"

local base = pathJoin(opt,pkgName,pkgVersion)

prepend_path("CPATH", pathJoin(base,"include"))

setenv( "BOOST_ROOT", base)
setenv( "BOOST_VERSION", pkgVersion)

whatis("Name: " .. pkgName)
whatis("Version: " .. pkgVersion)
whatis("Category: library")
whatis("Description: Boost C++ Headers")
