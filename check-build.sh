#!/bin/bash -e
. /etc/profile.d/modules.sh

module load ci
module load gcc/$GCC_VERSION

echo "About to make the modules"
cd $WORKSPACE/$NAME-$VERSION
ls
echo $?

echo "running make check"
make check

echo "runing make install"
make install

mkdir -p modules
(
cat <<MODULE_FILE
#%Module1.0
## $NAME modulefile
##
proc ModulesHelp { } {
   puts stderr "\tAdds Torque Resource Manager 2.5.13 to your environment"
}

prereq gcc/${GCC_VERSION}

module-whatis   "${NAME} ${VERSION}. not for use in production, only integration. See https://github.com/SouthAfricaDigitalScience/torque-2.5"
setenv       TORQUE_VERSION       ${VERSION}
setenv       TORQUE_DIR           /apprepo/$::env(SITE)/$::env(OS)/$::env(ARCH)/${NAME}/${VERSION}

prepend-path    PATH            $::env(TORQUE_DIR)/bin
prepend-path    PATH            $::env(TORQUE_DIR)/include
prepend-path    PATH            $::env(TORQUE_DIR)/bin
prepend-path    MANPATH         $::env(TORQUE_DIR)/man
prepend-path    LD_LIBRARY_PATH $::env(TORQUE_DIR)/lib
MODULE_FILE
) > modules/${VERSION}-gcc-${GCC_VERSION}
mkdir -p ${LIBRARIES_MODULES}/${NAME}

cp modules/${VERSION}-gcc-${GCC_VERSION} ${LIBRARIES_MODULES}/${NAME}/${VERSION}-gcc-${GCC_VERSION}

echo "Testing module"
module avail
module list

echo "PATH"
echo ${PATH}
echo "LD_LIBRARY_PATH"
echo ${LD_LIBRARY_PATH}

module add ${NAME}/${VERSION}-gcc-${GCC_VERSION}
module list

echo "PATH"
echo ${PATH}
echo "LD_LIBRARY_PATH"
echo ${LD_LIBRARY_PATH}

which qsub
exit 0

# Add a test to check
