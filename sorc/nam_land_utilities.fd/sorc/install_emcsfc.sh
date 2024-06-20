SHELL=/bin/sh

#------------------------------------------------------------
# Install "emcsfc" programs.
#
# For more details, see the documentation in each
# program sub-directory.
#------------------------------------------------------------

set -x

INSTALL_accum_firedata=0
INSTALL_coldstart=0
INSTALL_fire2mdl=0
INSTALL_gridgen_sfc=0
INSTALL_ice2mdl=0
INSTALL_sfcupdate=0
INSTALL_snow2mdl=1
INSTALL_sst2mdl=0

if [ $INSTALL_accum_firedata == "1" ]
then
	echo INSTALL emcsfc_accum_firedata 
cp ../exec/emcsfc_accum_firedata  ../../../exec/.
elif [ $INSTALL_coldstart == "1" ]
then
	echo INSTALL emcsfc_coldstart
cp ../exec/emcsfc_coldstart  ../../../exec/.
elif [ $INSTALL_fire2mdl == "1" ]
then
	echo INSTALL emcsfc_fire2mdl
cp ../exec/emcsfc_fire2mdl  ../../../exec/.
elif [ $INSTALL_gridgen_sfc == "1" ]
then
	echo INSTALL emcsfc_gridgen_sfc
cp ../exec/emcsfc_gridgen_sfc  ../../../exec/.
elif [ $INSTALL_ice2mdl == "1" ]
then
	echo INSTALL emcsfc_ice2mdl
cp ../exec/emcsfc_ice2mdl  ../../../exec/.
elif [ $INSTALL_sfcupdate == "1" ]
then
	echo INSTALL emcsfc_sfcupdate
cp ../exec/emcsfc_sfcupdate  ../../../exec/.
elif [ $INSTALL_snow2mdl == "1" ]
then
	echo INSTALL emcsfc_snow2mdl
cp ../exec/emcsfc_snow2mdl  ../../../exec/.
elif [ $INSTALL_sst2mdl == "1" ]
then
	echo INSTALL emcsfc_sst2mdl
cp ../exec/emcsfc_sst2mdl  ../../../exec/.
fi


echo; echo DONE INTALLING EMCSFC PROGRAMS
