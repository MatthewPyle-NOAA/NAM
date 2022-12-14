include ../../../conf/configure.nems

MAKEFILE = makefile

UTILINCS = -I../../share -I../libutil 
ARCH=$(shell uname -s)
GOCARTINCS = -I../../../chem/gocart/${ARCH}/include/Chem_Base \
             -I../../../chem/gocart/${ARCH}/include/GMAO_mpeu \
             -I../../../chem/gocart/${ARCH}/include/GEOSchem_GridComp

LIBRARY  = gfs_dynamics.a

#OPTS          = $(FFLAGS_GFS) $(R8) -O3 $(UTILINCS)
#OPTSGOCART    = $(FFLAGS_GFS) $(R8) -O3 $(UTILINCS) $(GOCARTINCS)
#WY added.
#---------
#OPTS     = $(FFLAGS_GFS) $(R8) -O3 $(UTILINCS) -g -traceback
#OPTS     = $(FFLAGS_GFS) $(R8) -O $(UTILINCS) -g -traceback -openmp  -mkl=sequential -check bounds -check uninit
OPTS           = $(FFLAGS_GFS) $(R8) $(UTILINCS)
OPTSGOCART     = $(FFLAGS_GFS) $(R8) $(UTILINCS) $(GOCARTINCS)

FFLAG90  = $(OPTS) $(FREE)
FFLAGS1  = $(OPTS) $(FIXED)
#FFLAG90I  = $(FFLAGS_GFS) -O3 $(FREE)
FFLAG90I  = $(FFLAGS_GFS) $(FREE)
FFLAG90GOCART  = $(OPTSGOCART) $(FREE)
FFLAGS1GOCART  = $(OPTSGOCART) $(FIXED)
FFLAGSC =

OBJS0	= \
	  num_parthds.o                         \
	  gfs_dynamics_err_msg_mod.o		\
	  gfs_dynamics_namelist_mod.o		\
	  gfs_dynamics_start_time_get_mod.o	\
	  gfs_dynamics_internal_state_mod.o	\
	  gfs_dynamics_grid_create_mod.o	\
	  gfs_dynamics_output.o          	\
	  gfs_dynamics_getcf_mod.o		\
	  GFS_AddParameterToStateMod.o          \
	  gfs_dynamics_initialize_mod.o		\
	  gfs_dynamics_initialize_slg_mod.o     \
	  gfs_dynamics_run_mod.o		\
	  gfs_dynamics_finalize_mod.o		\
	  gfs_dynamics_add_get_state_ESMFField_mod.o	\
	  gfs_dynamics_states_mod.o                \
	  gfs_dyn_physcons.o                       \
	  mpi_GV.o                                 \
	  gfs_dynamics_grid_comp_mod.o
	  
OBJS1	=
# OBJS1	= mygather.o

OBJ_MOD	= \
	  bfilt_def.o                   \
	  gfs_dyn_machine.o             \
	  gfs_dyn_resol_def.o           \
	  gfs_dyn_gg_def.o              \
	  gfs_dyn_vert_def.o            \
	  gfs_dyn_io_header.o           \
	  gfs_dyn_date_def.o            \
	  slgshr.o                      \
	  pmgrid.o                      \
	  layout_grid_tracers.o         \
	  layout_lag.o                  \
	  gfs_dyn_layout1.o             \
	  namelist_dynamics_def.o       \
	  gfs_dyn_coordinate_def.o      \
	  gfs_dyn_lon_lat_para.o        \
	  gfs_dyn_tracer_const.o  	\
	  gfs_dyn_tracer_config.o       \
	  gfs_dyn_reduce_lons_grid_module.o \
	  gfs_dyn_matrix_sig_def.o      \
	  gfs_dyn_mpi_def.o             \
	  gfs_dyn_deldifs_def.o         \
	  gfs_dyn_bfilt_def.o   	\
	  gfs_dyn_glats.o	        \
	  gfs_dyn_dfi_mod.o             \
	  nemsio_def.o	                \
	  wrtout_dynamics.o             \
	  wrtout_dynamics_slg_nemsio.o  \
	  gfidi_hyb_gc_h_w_z.o          \
	  get_w_z.o                     \
	  deldifs_def.o     

OBJ_TRAC= dyn_gocart_tracer_config.o

OBJ_TRAC_stub= dyn_gocart_tracer_config_stub.o

OBJS_PORT = \
	four2grid_thread.fftpack.o \
	noblas.o

OBJS   = \
	get_cd_hyb.o \
	get_am_bm_hyb.o \
	get_cd_hyb_gc.o \
	get_cd_hyb_gcdp.o \
	get_am_bm_hyb_gc.o \
	get_am_bm_hyb_gcdp.o \
	sltini_all.o         \
	set_halos_lag_sn.o   \
	setlats.o \
	setlats_slg.o        \
	getysk.o \
	getysk_gc.o \
	redist_lats_a.o \
	ifshuff.o \
	shuffle_grid.o \
	grid_collect.o \
	excha.o \
	info.o \
	four2grid_thread.o \
	hpmdummy.o \
	coundummy.o \
	damp_speed.o \
	damp_speed_noq.o \
	deldifs.o \
	deldifs_noq.o \
	idea_deldifs_init.o \
	idea_deldifs.o \
	idea_deldifs_noq.o \
	idea_getcoef.o \
	input_fields.o \
	input_fields_slg.o \
	input_fields_rst.o \
	delnpe.o \
	delnpo.o \
	dezouv.o \
	impadj_sig.locl.o \
	impadj_hyb.locl.o \
	impadj_hyb.locl_gc.o \
	impadj_hyb.locl_gcdp.o \
	impadj_slg.locl.o\
	dozeuv.o \
	epslon.o \
	filtereo.o \
	filter1eo.o \
	filter2eo.o  \
	filtereo_noq.o \
	filter1eo_noq.o \
	filter2eo_noq.o  \
	setlats_lag.o    \
	get_ls_node.o \
	get_lats_node_shuff_a_fix.o \
	getcon_lag.o      \
	getcon_dynamics.o \
	gfidi_tracers.o   \
	gfidi_speed.o     \
	gfidi_sig.o \
	gfidi_hyb.o \
	gfidi_hyb_gc.o \
	gfidi_hyb_gc_h.o \
	gfidi_hyb_gchdp.o \
	gfidi_gchdp_noadv_noq.o \
	ndslfv_pack.o \
	ndslfv_para.o \
	ndslfv_monoadvh2.o \
	ndslfv_monoadvh.o \
	ndslfv_monoadvv.o \
	grid_to_spect.o \
	grid_to_spect_slg.o \
	grid_to_spect_rqt.o \
	gridzz_to_spect.o \
	spect_to_grid.o \
	spect_to_grid_slg.o \
	spect_to_grid_gz.o \
	spect_to_grid_rqt.o \
	spect_to_gridxy.o \
	spectpz_to_gridxy.o \
	compns_dynamics.o \
	gozrineo.o \
	pln2eo.o \
	rms_spect.o \
	lats_shuff.o \
	uvoedz.o                     \
	mpi_quit.o                   \
	sicdif_sig.o                 \
	sicdif_hyb.o                 \
	sicdif_hyb_gc.o              \
	sicdif_hyb_gcdp.o            \
	common_to_model_vars.o       \
	getpwatptot.o                \
	sig2press.o                  \
	hyb2press.o                  \
	gch2press.o                  \
	omega_sig.o                  \
	omega_hyb.o                  \
	omega_gch.o                  \
	omega_gcdp.o                 \
	slgscan_all_redgg.o          \
	do_dynamics_mod.o            \
	get_cd_hyb_slg.o             \
	gfs_dficoll_dynamics.o       \
	gfs_dficoll_dynamics_slg.o   \
	sicdif_hyb_slg.o             \
	deldifs_tracers.o            \
	gloopa_tracers.o             \
	do_dynamics_slg_loop.o       \
	do_dynamics_one_loop.o       \
	do_dynamics_two_loop.o       \
	model_to_common_vars.o       \
	gather_times.o               \
	four_to_grid.o               \
	four2fln_gg.o                \
	four2fln.o                   \
	sortrx.o                     \
	sumder2_slg_gg.o             \
	sumfln_slg_gg.o              \
	sumfln.o                     \
	sumder2.o                    \
	triseori.o                   \
	triseof.o                    \
	uveodz.o                     \
	matinv.o                     \
	ver_sig.o                    \
	sig_io.o                     \
	get_topo_grid_grad.o         \
	ysminv.o

OBJS_IO=                        \
	grid_fix.o              \
	sigio_module.o          \
	sigio_r_module.o        \
	treadeo.io.o            \
	treadeo.io_slg.o        \
	treadeo_nemsio.o        \
	treadeo_nemsio_slg.o    \
	treadg_nemsio.o         \
	treads_nemsio.o         \
	twrites_rst.o           \
	twrites_hst.o           \
	twriteg_rst.o           \
	grid_to_spect_inp.o     \
	grid_to_spect_inp_slg.o \
	setsig.o                \
	spect_to_grid_inp.o    

ifeq ($(GOCART_MODE),full)
	DEPEND_FILES = ${OBJS0:.o=.f} ${OBJ_MOD:.o=.f} ${OBJ_TRAC:.o=.f} ${OBJS:.o=.f} ${OBJS_PORT:.o=.f} ${OBJS_IO:.o=.f} ${OBJS1:.o=.c}
else
	DEPEND_FILES = ${OBJS0:.o=.f} ${OBJ_MOD:.o=.f} ${OBJ_TRAC_stub:.o=.f} ${OBJS:.o=.f} ${OBJS_PORT:.o=.f} ${OBJS_IO:.o=.f} ${OBJS1:.o=.c}
endif

all default: depend
	@gmake -f $(MAKEFILE) $(LIBRARY)

$(LIBRARY): $(OBJ_MOD) $(OBJ_TRAC_stub) $(OBJS0) $(OBJS1) $(OBJS) $(OBJS_IO)
	$(AR) $(ARFLAGS) $@ $?

gocart_stub: $(OBJ_MOD) $(OBJ_TRAC_stub) $(OBJS0) $(OBJS1) $(OBJS) $(OBJS_IO)
	$(AR) $(ARFLAGS) $(LIBRARY) $(OBJ_MOD) $(OBJ_TRAC_stub) $(OBJS0) $(OBJS1) $(OBJS) $(OBJS_IO)

gocart_full: $(OBJ_MOD) $(OBJ_TRAC) $(OBJS0) $(OBJS1) $(OBJS) $(OBJS_IO)
	$(AR) $(ARFLAGS) $(LIBRARY) $(OBJ_MOD) $(OBJ_TRAC) $(OBJS0) $(OBJS1) $(OBJS) $(OBJS_IO)

$(OBJS0): %.o: %.f90
	$(FC) $(FFLAGS1) -c $*.f90
$(OBJS1): %.o: %.c
	$(CC) -c $*.c
$(OBJS_PORT): %.o: %.f90
	$(FC) $(FFLAGS1) -c $*.f90
$(OBJ_TRAC): %.o: %.f90
	$(FC) $(FFLAGS1GOCART) -c $*.f90
$(OBJ_TRAC_stub): %.o: %.f90
	$(FC) $(FFLAGS1) -c $*.f90
$(OBJ_MOD): %.o: %.f90
	$(FC) $(FFLAGS1) -c $*.f90
$(OBJS): %.o: %.f90
	$(FC) $(FFLAGS1) -c $*.f90
$(OBJS_IO): %.o: %.f90
	$(FC) $(FFLAGS1) -c $*.f90

clean:
	$(RM) -f $(LIBRARY) *.o *.mod *.lst *.f90 lm map depend

#
# *****************************************************************
#

.SUFFIXES: .f .c .f90 .o

.f.f90:
	$(CPP) $< > $*.f90

.c.o:
	$(CC) $(CFLAG) $(INC) -c $<


gfs_dyn_physcons.o:	gfs_dyn_physcons.f90
		$(FC) $(FFLAG90) -c gfs_dyn_physcons.f90

sigio_module.o:	 sigio_module.f90
		$(FC) $(FFLAG90I) -c sigio_module.f90

sigio_r_module.o:	 sigio_r_module.f90
		$(FC) $(FFLAG90I) -c sigio_r_module.f90

#spect_tv_enthalpy_ps.o:	 spect_tv_enthalpy_ps.f90
#		$(FC) $(FFLAG90I) -c spect_tv_enthalpy_ps.f90
#
gfs_dynamics_err_msg_mod.o:	 gfs_dynamics_err_msg_mod.f90
		$(FC) $(FFLAG90) -c gfs_dynamics_err_msg_mod.f90

gfs_dynamics_namelist_mod.o:	 gfs_dynamics_namelist_mod.f90
		$(FC) $(FFLAG90) -c gfs_dynamics_namelist_mod.f90

gfs_dynamics_start_time_get_mod.o:	 gfs_dynamics_start_time_get_mod.f90
		$(FC) $(FFLAG90) -c gfs_dynamics_start_time_get_mod.f90

gfs_dynamics_grid_create_mod.o:	 gfs_dynamics_grid_create_mod.f90
		$(FC) $(FFLAG90) -c gfs_dynamics_grid_create_mod.f90

gfs_dynamics_output.o:	 gfs_dynamics_output.f90
		$(FC) $(FFLAG90) -c gfs_dynamics_output.f90

gfs_dynamics_getcf_mod.o:	 gfs_dynamics_getcf_mod.f90
		$(FC) $(FFLAG90) -c gfs_dynamics_getcf_mod.f90

gfs_dynamics_internal_state_mod.o:	 gfs_dynamics_internal_state_mod.f90
		$(FC) $(FFLAG90) -c gfs_dynamics_internal_state_mod.f90

GFS_AddParameterToStateMod.o:    GFS_AddParameterToStateMod.f90
	        $(FC) $(FFLAG90) -c GFS_AddParameterToStateMod.f90

gfs_dynamics_add_get_state_ESMFField_mod.o:	 gfs_dynamics_add_get_state_ESMFField_mod.f90
		$(FC) $(FFLAG90) -c gfs_dynamics_add_get_state_ESMFField_mod.f90

gfs_dynamics_states_mod.o:	 gfs_dynamics_states_mod.f90
		$(FC) $(FFLAG90) -c gfs_dynamics_states_mod.f90

gfs_dynamics_initialize_mod.o:	 gfs_dynamics_initialize_mod.f90
		$(FC) $(FFLAG90) -c gfs_dynamics_initialize_mod.f90

gfs_dynamics_initialize_slg_mod.o:	 gfs_dynamics_initialize_slg_mod.f90
		$(FC) $(FFLAG90) -c gfs_dynamics_initialize_slg_mod.f90

gfs_dynamics_run_mod.o:	 gfs_dynamics_run_mod.f90
		$(FC) $(FFLAG90) -c gfs_dynamics_run_mod.f90

gfs_dynamics_finalize_mod.o:	 gfs_dynamics_finalize_mod.f90
		$(FC) $(FFLAG90) -c gfs_dynamics_finalize_mod.f90

gfs_dynamics_grid_comp_mod.o:	 gfs_dynamics_grid_comp_mod.f90
		$(FC) $(FFLAG90) -c gfs_dynamics_grid_comp_mod.f90


#
#
#

MKDEPENDS = ../../../../exe/mkDepends.pl

include ../../../conf/make.rules

include depend
