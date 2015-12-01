#!/bin/bash -e
SOURCE_FILE=$NAME-$VERSION.tar.gz
#SOURCE_REPO="http://www.adaptivecomputing.com/resources/downloads/torque/"
SOURCE_REPO="http://www.adaptivecomputing.com/index.php?wpfb_dl=2714"
# We pretend that the $SOURCE_FILE is there, even though it's actually a dir.
NAME="torque"
VERSION="2.5.13"

module load ci
module load gcc/${GCC_VERSION}

echo "REPO_DIR is "
echo ${REPO_DIR}
echo "SRC_DIR is "
echo ${SRC_DIR}
echo "WORKSPACE is "
echo ${WORKSPACE}
echo "SOFT_DIR is"
echo ${SOFT_DIR}

mkdir -p ${WORKSPACE}
mkdir -p ${SRC_DIR}
mkdir -p ${SOFT_DIR}

#  Download the source file

if [ ! -e ${SRC_DIR}/${SOURCE_FILE}.lock ] && [ ! -s ${SRC_DIR}/${SOURCE_FILE} ] ; then
  touch  ${SRC_DIR}/${SOURCE_FILE}.lock
  echo "seems like this is the first build - Let's get the $SOURCE_FILE from $SOURCE_REPO and unarchive to $WORKSPACE"
  wget ${SOURCE_REPO} -O ${SRC_DIR}/${SOURCE_FILE}
  echo "releasing lock"
  rm -v ${SRC_DIR}/${SOURCE_FILE}.lock
elif [ -e ${SRC_DIR}/${SOURCE_FILE}.lock ] ; then
  # Someone else has the file, wait till it's released
  while [ -e ${SRC_DIR}/${SOURCE_FILE}.lock ] ; do
    echo " There seems to be a download currently under way, will check again in 5 sec"
    sleep 5
  done
else
  echo "continuing from previous builds, using source at ${SRC_DIR}/${SOURCE_FILE}"
fi

echo "untar the tarball"
tar xvzf ${SRC_DIR}/${SOURCE_FILE} -C ${WORKSPACE} --skip-old-files
echo "change to working directory"
cd ${WORKSPACE}/${NAME}-${VERSION}

echo "Configuring the build"
export CC=`which gcc`
export CXX=`which g++`
echo "CC is ${CC} "
echo "CXX is $CXX"
./configure \
--prefix=${SOFT_DIR} \
--without-tcl \
--with-server-home=${SOFT_DIR}/spool
echo "Running the build"
make all
