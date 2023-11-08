#!/bin/bash -l

VERFILE=/lfs/h2/emc/lam/noscrub/Matthew.Pyle/nam.v4.2.5/versions
. $VERFILE/run.ver

module purge
module load envvar/${envvar_ver}
module load PrgEnv-intel/${PrgEnv_intel_ver}
module load intel/${intel_ver}
module load craype/${craype_ver}
module load cray-mpich/${cray_mpich_ver}
module load cray-pals/${cray_pals_ver}
module load libjpeg/${libjpeg_ver}
module load grib_util/${grib_util_ver}
module load util_shared/${util_shared_ver}

module use /apps/ops/test/nco/modulefiles/
module load core/rocoto/1.3.5

# module list
#

echo GRB2INDEX is $GRB2INDEX

which wgrib

mkdir -p /lfs/h2/emc/ptmp/Matthew.Pyle/output_para
mkdir -p /lfs/h2/emc/stmp/Matthew.Pyle/tmp

rocotorun -v 10 \
        -w /lfs/h2/emc/lam/noscrub/Matthew.Pyle/nam.v4.2.5/rocoto/NAM_wcoss2_ops.xml \
	-d /lfs/h2/emc/lam/noscrub/Matthew.Pyle/nam.v4.2.5/rocoto/NAM_wcoss2_ops.db
