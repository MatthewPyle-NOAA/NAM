cmake_minimum_required(VERSION 2.8)
# need to set CMP0046 when using add_dependencies with cmake version 3.6.2
  if(crayComp)
    cmake_policy(SET CMP0046 NEW)
  endif()
  set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/Modules/")
# get a list of all the fortran source files
  file(GLOB GSIFORT_SRC ${CMAKE_CURRENT_SOURCE_DIR}/*90 )
# get a list of all the c source files
  file(GLOB GSI_C_SRC ${CMAKE_CURRENT_SOURCE_DIR}/*c )
# get a list of all cplr files
  file(GLOB CLASS_SRC ${CMAKE_CURRENT_SOURCE_DIR}/class*90 )
# create a list of all corresponding stub files
  string(REGEX REPLACE "class" "stub" STUB_SRC "${CLASS_SRC}") 
# create a list of all corresponding class files
  string(REGEX REPLACE "class" "cplr" CPLR_SRC "${CLASS_SRC}") 

# GSIMAIN_SRC is a list of Fortram main(s), to be used to define GSIEXEC,
# and to be excluded from GSI libraries.
  set(GSIMAIN_SRC
    ${CMAKE_CURRENT_SOURCE_DIR}/gsimain.f90
    ${CMAKE_CURRENT_SOURCE_DIR}/gsimod.F90
  )

# GSIUTIL_SRC is a list of all Fortran modules as *base level* utilities.
# This list can be extended to include any module, which depends (USEs)
# only on module(s) already included in this list, in one of CORE_LIBRARIES,
# or in one of system libraries.  Any module dynamically depending on external
# libraries through configuration, such as WRF, NCDIAG, etc. should not be
# included.

  set(GSIUTIL_SRC
    ${CMAKE_CURRENT_SOURCE_DIR}/mpeu_util.F90
    ${CMAKE_CURRENT_SOURCE_DIR}/mpimod.F90
    ${CMAKE_CURRENT_SOURCE_DIR}/mpeu_mpif.F90
    ${CMAKE_CURRENT_SOURCE_DIR}/kinds.F90
  )

# GSIFORT_SRC is a list of all Fortran modules for GSI core implementations,
# after all configuration dependent code (some stub and cplr), base level
# utilities, the main are removed from the rest of source files

# Remove CLASS_SRC list related STUB_SRC and CPLR_SRC, as configurable
# grid components
  list( REMOVE_ITEM GSIFORT_SRC
    ${STUB_SRC}
    ${CPLR_SRC}
    ${CMAKE_CURRENT_SOURCE_DIR}/gsi_fixture_REGIONAL.F90
    ${CMAKE_CURRENT_SOURCE_DIR}/gsi_fixture_GFS.F90
    ${CMAKE_CURRENT_SOURCE_DIR}/stub_nstmod.f90
    ${GSIUTIL_SRC}
    ${GSIMAIN_SRC}
  )

# remove NCDIAG, if it is a component built somewhere else.
  if( BUILD_NCDIAG )
    list( REMOVE_ITEM GSIFORT_SRC "${CMAKE_CURRENT_SOURCE_DIR}/nc_diag_read_mod.f90" )
    list( REMOVE_ITEM GSIFORT_SRC "${CMAKE_CURRENT_SOURCE_DIR}/nc_diag_write_mod.f90" )
  endif( BUILD_NCDIAG )

# The specific regional/WRF source files
  if(USE_WRF)
    list( APPEND GSIFORT_SRC
	${CPLR_SRC}
	${CMAKE_CURRENT_SOURCE_DIR}/gsi_fixture_REGIONAL.F90
    )
  endif()

# The specific global source files
  if(BUILD_GLOBAL)
    list( APPEND GSIFORT_SRC
	${STUB_SRC}
	${CMAKE_CURRENT_SOURCE_DIR}/gsi_fixture_GFS.F90
    )
  endif(BUILD_GLOBAL)

  if(BUILD_GSDCLOUD_NMMB)
    list( APPEND GSIFORT_SRC
        ${CMAKE_CURRENT_SOURCE_DIR}/../GSD/gsdcloud4nmmb/adaslib.f90
        ${CMAKE_CURRENT_SOURCE_DIR}/../GSD/gsdcloud4nmmb/ARPS_cldLib.f90
        ${CMAKE_CURRENT_SOURCE_DIR}/../GSD/gsdcloud4nmmb/BackgroundCld.f90
        ${CMAKE_CURRENT_SOURCE_DIR}/../GSD/gsdcloud4nmmb/BckgrndCC.f90
        ${CMAKE_CURRENT_SOURCE_DIR}/../GSD/gsdcloud4nmmb/build_missing_REFcone.f90
        ${CMAKE_CURRENT_SOURCE_DIR}/../GSD/gsdcloud4nmmb/CheckCld.f90
        ${CMAKE_CURRENT_SOURCE_DIR}/../GSD/gsdcloud4nmmb/cloudCover_NESDIS.f90
        ${CMAKE_CURRENT_SOURCE_DIR}/../GSD/gsdcloud4nmmb/cloudCover_radar.f90
        ${CMAKE_CURRENT_SOURCE_DIR}/../GSD/gsdcloud4nmmb/cloudCover_Surface.f90
        ${CMAKE_CURRENT_SOURCE_DIR}/../GSD/gsdcloud4nmmb/cloudLayers.f90
        ${CMAKE_CURRENT_SOURCE_DIR}/../GSD/gsdcloud4nmmb/cloudLWC.f90
        ${CMAKE_CURRENT_SOURCE_DIR}/../GSD/gsdcloud4nmmb/cloud_saturation.f90
        ${CMAKE_CURRENT_SOURCE_DIR}/../GSD/gsdcloud4nmmb/cloudType.f90
        ${CMAKE_CURRENT_SOURCE_DIR}/../GSD/gsdcloud4nmmb/convert_lghtn2ref.f90
        ${CMAKE_CURRENT_SOURCE_DIR}/../GSD/gsdcloud4nmmb/convert_lghtn2ref_nmmb.f90
        ${CMAKE_CURRENT_SOURCE_DIR}/../GSD/gsdcloud4nmmb/get_sfm_1d_gnl.f90
        ${CMAKE_CURRENT_SOURCE_DIR}/../GSD/gsdcloud4nmmb/hydro_mxr_thompson.f90
        ${CMAKE_CURRENT_SOURCE_DIR}/../GSD/gsdcloud4nmmb/map_ctp.f90
        ${CMAKE_CURRENT_SOURCE_DIR}/../GSD/gsdcloud4nmmb/map_ctp_lar.f90
        ${CMAKE_CURRENT_SOURCE_DIR}/../GSD/gsdcloud4nmmb/mthermo.f90
        ${CMAKE_CURRENT_SOURCE_DIR}/../GSD/gsdcloud4nmmb/pbl_height.f90
        ${CMAKE_CURRENT_SOURCE_DIR}/../GSD/gsdcloud4nmmb/pcp_mxr_ARPSlib.f90
        ${CMAKE_CURRENT_SOURCE_DIR}/../GSD/gsdcloud4nmmb/PrecipMxr_radar.f90
        ${CMAKE_CURRENT_SOURCE_DIR}/../GSD/gsdcloud4nmmb/PrecipType.f90
        ${CMAKE_CURRENT_SOURCE_DIR}/../GSD/gsdcloud4nmmb/radar_ref2tten.f90
        ${CMAKE_CURRENT_SOURCE_DIR}/../GSD/gsdcloud4nmmb/read_Lightningbufr_cld.f90
        ${CMAKE_CURRENT_SOURCE_DIR}/../GSD/gsdcloud4nmmb/read_Lightning_cld.f90
        ${CMAKE_CURRENT_SOURCE_DIR}/../GSD/gsdcloud4nmmb/read_nasalarc_cld.f90
        ${CMAKE_CURRENT_SOURCE_DIR}/../GSD/gsdcloud4nmmb/read_NESDIS.f90
        ${CMAKE_CURRENT_SOURCE_DIR}/../GSD/gsdcloud4nmmb/read_radar_ref.f90
        ${CMAKE_CURRENT_SOURCE_DIR}/../GSD/gsdcloud4nmmb/read_Surface.f90
        ${CMAKE_CURRENT_SOURCE_DIR}/../GSD/gsdcloud4nmmb/smooth.f90
        ${CMAKE_CURRENT_SOURCE_DIR}/../GSD/gsdcloud4nmmb/TempAdjust.f90
        ${CMAKE_CURRENT_SOURCE_DIR}/../GSD/gsdcloud4nmmb/vinterp_radar_ref.f90
        )
  endif(BUILD_GSDCLOUD_NMMB)

# set up the compiler flags
  set_source_files_properties( ${GSIMAIN_SRC}	PROPERTIES COMPILE_FLAGS ${GSI_Fortran_FLAGS} )
  set_source_files_properties( ${GSIFORT_SRC}	PROPERTIES COMPILE_FLAGS ${GSI_Fortran_FLAGS} )
  set_source_files_properties( ${GSIUTIL_SRC}	PROPERTIES COMPILE_FLAGS ${GSI_Fortran_FLAGS} )
  set_source_files_properties( ${GSI_C_SRC}	PROPERTIES COMPILE_FLAGS ${GSI_CFLAGS} )

  set( GSICORE_SRC ${GSIFORT_SRC} ${GSI_C_SRC} )

# Add the include paths
  message("MPI include PATH  ${MPI_Fortran_INCLUDE_PATH}")
  include_directories( ${CORE_INCS} ${NETCDF_INCLUDE_DIRS} ${MPI_Fortran_INCLUDE_PATH} ${FV3GFS_NCIO_INCS} "./" )

#define the name used for GSI Shared lib and add it with properties and include dirs
  set(GSISHAREDLIB "gsilib_shrd${debug_suffix}" CACHE INTERNAL "")
  add_library(${GSISHAREDLIB} STATIC ${GSIUTIL_SRC} )
  set_target_properties(${GSISHAREDLIB} PROPERTIES Fortran_MODULE_DIRECTORY "${PROJECT_BINARY_DIR}/include")
  target_include_directories(${GSISHAREDLIB} PUBLIC "${PROJECT_BINARY_DIR}/include")

# Definte the base name of the executable 
  if(BUILD_PRODUCTION)
    set(GSIBASE "global_gsi.x")
  else()
    if(BUILD_GLOBAL)
      set(GSIBASE "gsi_global")
    else()
      set(GSIBASE "gsi")
    endif()
    set(GSISUFFIX ".x" CACHE INTERNAL "Executable suffix")
  endif()

# Set names, libs, and properties depending on if we are building with WRF or not
  if(USE_WRF) 
    set(GSIEXEC "${GSIBASE}${debug_suffix}${GSISUFFIX}" CACHE INTERNAL "GSI Executable Name")
    add_executable(${GSIEXEC} ${CMAKE_CURRENT_SOURCE_DIR}/gsimain.f90 ${CMAKE_CURRENT_SOURCE_DIR}/gsimod.F90 )
    set(GSILIB "gsilib_wrf${debug_suffix}" CACHE INTERNAL "")
    add_library(${GSILIB} STATIC ${GSICORE_SRC} )
    set_target_properties(${GSILIB} PROPERTIES Fortran_MODULE_DIRECTORY "${PROJECT_BINARY_DIR}/include")
    target_include_directories(${GSILIB} PUBLIC "${PROJECT_BINARY_DIR}/include")
    set_target_properties(${GSIEXEC} PROPERTIES Fortran_MODULE_DIRECTORY "${PROJECT_BINARY_DIR}/include")
    target_link_libraries( ${GSILIB} ${GSISHAREDLIB} ${wrflib} )
  endif()

  if(BUILD_GLOBAL)
    set(GSIEXEC "${GSIBASE}${debug_suffix}${GSISUFFIX}" CACHE INTERNAL "GSI Executable Name")
    add_executable( ${GSIEXEC} ${GSIMAIN_SRC} )
    set(GSILIB "gsilib_global${debug_suffix}" CACHE INTERNAL "")
    set(WRF_LIBRARIES "")
    add_library(${GSILIB} STATIC ${GSICORE_SRC} )
    target_link_libraries( ${GSILIB} ${GSISHAREDLIB} )
    add_dependencies(${GSILIB} ${GSISHAREDLIB} )
    target_link_libraries( ${GSISHAREDLIB} ${CORE_LIBRARIES})
    set_target_properties( ${GSILIB} PROPERTIES Fortran_MODULE_DIRECTORY "${PROJECT_BINARY_DIR}/include")
    target_include_directories( ${GSILIB} PUBLIC "${PROJECT_BINARY_DIR}/include")
    set_target_properties(${GSIEXEC} PROPERTIES Fortran_MODULE_DIRECTORY "${PROJECT_BINARY_DIR}/include")
  endif()

  if( BUILD_NCDIAG )
      add_dependencies(${GSILIB} ${NCDIAG_LIBRARIES} )
  endif( BUILD_NCDIAG )
  add_dependencies(${GSILIB} ${GSISHAREDLIB} )

# Add dependencies if we are building the core libs or are just using pre-built libs 
  if(CORE_BUILT)
    add_dependencies(${GSILIB} ${GSISHAREDLIB} ${CORE_BUILT} )
    add_dependencies(${GSISHAREDLIB} ${bacio} ${CORE_BUILT} )
    add_dependencies(${GSIEXEC} ${GSISHAREDLIB} ${GSILIB} ${CORE_BUILT} )
  else()
    add_dependencies(${GSIEXEC} ${GSISHAREDLIB} ${GSILIB} )
  endif()
# Specify all the libraries to be linked into the executable
  target_link_libraries(${GSIEXEC} ${GSISHAREDLIB} ${GSILIB} ${GSISHAREDLIB} ${WRF_LIBRARIES}
         ${MPI_Fortran_LIBRARIES} ${LAPACK_LIBRARIES}
         ${CORE_LIBRARIES} ${CORE_BUILT}
         ${NETCDF_Fortran_LIBRARIES} ${NETCDF_C_LIBRARIES}
         ${GSI_LDFLAGS} ${NCDIAG_LIBRARIES} ${GSDCLOUD_LIBRARY} ${wrflib}
         ${EXTRA_LINKER_FLAGS} ${FV3GFS_NCIO_LIBRARIES})
  install(TARGETS ${GSIEXEC}
        RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/bin
        LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
        ARCHIVE DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/static)
