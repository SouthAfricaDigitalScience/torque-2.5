#!/bin/bash -e
# Copyright 2016 C.S.I.R. Meraka Institute
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# this should be run after check-build finishes.
. /etc/profile.d/modules.sh
echo ${SOFT_DIR}
module add deploy
module add gmp
module add mpfr
module add mpc
module add ncurses
module add gcc/${GCC_VERSION}
echo ${SOFT_DIR}
cd ${WORKSPACE}/${NAME}-${VERSION}/build-${BUILD_NUMBER}
echo "All tests have passed, will now build into ${SOFT_DIR}"
echo "Configuring the build"
export CC=`which gcc`
export CXX=`which g++`
echo "CC is ${CC} "
echo "CXX is $CXX"
rm -rf *
../configure \
--prefix=${SOFT_DIR}-gcc-${GCC_VERSION} \
--enable-shared \
--enable-static \
--disable-gui \
--with-server-home=${SOFT_DIR}-gcc-${GCC_VERSION}/spool
make install -j2
echo "Creating the modules file directory ${LIBRARIES}"
mkdir -p ${LIBRARIES}/${NAME}

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
setenv       TORQUE_VERSION          ${VERSION}
setenv       TORQUE_DIR           $::env(CVMFS_DIR)/$::env(SITE)/$::env(OS)/$::env(ARCH)/${NAME}/${VERSION}-gcc-${GCC_VERSION}

prepend-path    PATH                         $::env(TORQUE_DIR)/bin
prepend-path    PATH                         $::env(TORQUE_DIR)/include
prepend-path    PATH                         $::env(TORQUE_DIR)/bin
prepend-path    MANPATH                $::env(TORQUE_DIR)/man
prepend-path    LD_LIBRARY_PATH $::env(TORQUE_DIR)/lib
MODULE_FILE
) >  ${LIBRARIES}/${NAME}/${VERSION}-gcc-${GCC_VERSION}

module avail ${NAME}
module add ${NAME}/${VERSION}-gcc-${GCC_VERSION}
module list

echo "PATH"
echo ${PATH}
echo "LD_LIBRARY_PATH"
echo ${LD_LIBRARY_PATH}

which qsub
exit 0
