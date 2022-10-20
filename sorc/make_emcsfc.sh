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

# Now build land-surface utility codes
cd ${SORCnam}/nam_land_utilities.fd/sorc
# ./build_emcsfc.sh > ${SORCnam}/build_emcsfc.log.1204 2>> build_emcsfc.log.1204
./build_emcsfc.sh > ${SORCnam}/build_emcsfc.log.1206 2>> build_emcsfc.log.1206

exit 0
