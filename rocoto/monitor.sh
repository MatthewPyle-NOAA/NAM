#! /bin/sh
#

base=NAM_wcoss2_ops

cyc=202311070600


succ=`rocotostat -w ${base}.xml -d ${base}.db -c ${cyc} | grep 'SUCC' | wc -l`
fail=`rocotostat -w ${base}.xml -d ${base}.db -c ${cyc} | grep 'DEAD' | wc -l`

datestr=`date`

echo FOUND $succ good ones and $fail bad ones

if [ $fail -gt 0 ]
then
	rocotostat -w ${base}.xml -d ${base}.db -c ${cyc} | grep 'DEAD'
fi
