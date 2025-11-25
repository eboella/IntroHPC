NVTX_ROOT = /leonardo/prod/spack/06/install/0.22/linux-rhel8-icelake/gcc-8.5.0/nvhpc-24.5-torlmnyzcexnrs6pq4cccabv7ehkv3xy/Linux_x86_64/24.5/cuda
NVTX_INC  = -I$(NVTX_ROOT)/include
NVTX_LIB  = -L$(NVTX_ROOT)/lib64 -lnvToolsExt
NVCC  = nvc -mp -acc -O3 -ta=tesla -Minfo=all -acc=noautopar $(NVTX_INC) $(NVTX_LIB)
NVF90 = nvfortran -mp -acc -O3 -ta=tesla -Minfo=all -acc=noautopar

BIN = laplace2d_parallel_dataClauseStructure.x

help:
	@echo "Load Nvidia module: module load nvhpc"
	@echo "====================================="
	@echo "Please specify the make target"
	@echo "nvc or make nvf"

nvc: *.c
	$(NVCC) -o $(BIN) $<

nvf: *.F90
	$(NVF90) -o $(BIN) $<
clean:
	$(RM) $(BIN)
