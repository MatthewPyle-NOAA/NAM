include ../../configure.nps

OBJS = cio.o wrf_debug.o bitarray_module.o constants_module.o datatype_module.o despace.o gridinfo_module.o metgrid.o input_module.o interp_module.o interp_option_module.o list_module.o llxy_module.o met_data_module.o minheap_module.o misc_definitions_module.o module_date_pack.o module_debug.o module_map_utils.o module_mergesort.o output_module.o parallel_module.o process_domain_module.o queue_module.o read_met_module.o rotate_winds_module.o storage_module.o write_met_module.o

all: 
	clear ;
	@echo " "
	@echo "go up two directories and type compile to build NPS"
	@echo " "
	@echo " "

metgrid.exe: $(OBJS)
	$(FC) $(LDFLAGS) -o $@ $(OBJS) $(DIO_LIBS) $(NCIO_LIBS) -L$(NETCDF_LIB) -lnetcdf


bitarray_module.o: module_debug.o

cio.o:

constants_module.o:

datatype_module.o: bitarray_module.o module_debug.o

despace.o:

gridinfo_module.o: misc_definitions_module.o module_debug.o

metgrid.o: gridinfo_module.o interp_option_module.o module_debug.o parallel_module.o process_domain_module.o

input_module.o: gridinfo_module.o misc_definitions_module.o parallel_module.o queue_module.o 

interp_module.o: bitarray_module.o misc_definitions_module.o module_debug.o queue_module.o

interp_option_module.o: list_module.o misc_definitions_module.o module_debug.o

list_module.o: module_debug.o

llxy_module.o: gridinfo_module.o module_map_utils.o module_debug.o misc_definitions_module.o

met_data_module.o:

minheap_module.o: datatype_module.o

misc_definitions_module.o:

module_date_pack.o: module_debug.o

module_debug.o: parallel_module.o

module_map_utils.o: constants_module.o misc_definitions_module.o module_debug.o

module_mergesort.o:

output_module.o: gridinfo_module.o misc_definitions_module.o module_debug.o parallel_module.o storage_module.o

parallel_module.o:

process_domain_module.o: module_date_pack.o bitarray_module.o despace.o gridinfo_module.o input_module.o interp_module.o interp_option_module.o list_module.o llxy_module.o misc_definitions_module.o module_debug.o module_mergesort.o output_module.o parallel_module.o read_met_module.o rotate_winds_module.o storage_module.o

queue_module.o: module_debug.o

read_met_module.o: constants_module.o misc_definitions_module.o module_debug.o met_data_module.o

rotate_winds_module.o: bitarray_module.o constants_module.o llxy_module.o misc_definitions_module.o module_debug.o

storage_module.o: datatype_module.o minheap_module.o misc_definitions_module.o module_debug.o parallel_module.o

wrf_debug.o: cio.o

write_met_module.o: misc_definitions_module.o module_debug.o met_data_module.o

clean:
	$(RM) $(OBJS) *.mod
	$(RM) metgrid.exe

superclean:	clean
