#!/bin/bash -e
. /etc/profile.d/modules.sh

module load ci
module add gmp
module add mpfr
module add mpc
module add ncurses
module load gcc/${GCC_VERSION}

echo "About to make the modules"
cd ${WORKSPACE}/${NAME}-${VERSION}/build-${BUILD_NUMBER}
ls
echo $?

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
module add gmp
module add mpfr
module add mpc
module add ncurses
module add gcc/${GCC_VERSION}
prereq gcc/${GCC_VERSION}

module-whatis   "${NAME} ${VERSION}. not for use in production, only integration. See https://github.com/SouthAfricaDigitalScience/torque-2.5"
setenv       TORQUE_VERSION       ${VERSION}-gcc-${GCC_VERSION}
setenv       TORQUE_DIR           /data/ci-build/$::env(SITE)/$::env(OS)/$::env(ARCH)/${NAME}/${VERSION}-gcc-${GCC_VERSION}

prepend-path    PATH                         $::env(TORQUE_DIR)/bin
prepend-path    PATH                         $::env(TORQUE_DIR)/include
prepend-path    PATH                         $::env(TORQUE_DIR)/bin
prepend-path    MANPATH                $::env(TORQUE_DIR)/man
prepend-path    LD_LIBRARY_PATH $::env(TORQUE_DIR)/lib
MODULE_FILE
) > modules/${VERSION}-gcc-${GCC_VERSION}
mkdir -p ${LIBRARIES}/${NAME}

cp modules/${VERSION}-gcc-${GCC_VERSION} ${LIBRARIES}/${NAME}/${VERSION}-gcc-${GCC_VERSION}

echo "Testing module"
module avail
module list

echo "PATH"
echo ${PATH}
echo "LD_LIBRARY_PATH"
echo ${LD_LIBRARY_PATH}

module add gmp
module add mpfr
module add mpc
module add gcc/${GCC_VERSION}
module add ${NAME}/${VERSION}-gcc-${GCC_VERSION}
module list

echo "PATH"
echo ${PATH}
echo "LD_LIBRARY_PATH"
echo ${LD_LIBRARY_PATH}

which qsub
exit 0

# Add a test to check
