#!/bin/bash

SORCnam=$(pwd)
MACHID=wcoss2

set -x

versiondir=`dirname $(readlink -f ../versions)`
echo $versiondir
. $versiondir/versions/build.ver

module purge
module load envvar/${envvar_ver}

moduledir=`dirname $(readlink -f ../modulefiles/${MACHID})`
module use ${moduledir}
source ${moduledir}/${MACHID}/build/v4.0.0_build_new

set -x
export OUTmain=`dirname $(readlink -f ../exec/ )`
export OUTDIR=${OUTmain}/exec
mkdir -p $OUTDIR

#make -f ./Makefile

# Now build the GSI
cd $SORCnam
#ls -ld nam_gsi.fd/GSI/build
rm -rf nam_gsi.fd/GSI/build

./build_gsi.sh > ${SORCnam}/build_gsi.log 2>> build_gsi.log

exit 0
