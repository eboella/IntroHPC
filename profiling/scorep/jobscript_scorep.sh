#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=12
#SBATCH --cpus-per-task=6
#SBATCH -A eupadmin
#SBATCH --partition=t-grace-hopper
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH -o out_%j
#SBATCH -e err_%j
#SBATCH --nodelist=ngnode02
#SBATCH --reservation=IntroHPC
#SBATCH --exclusive

#########################################################
cat $0
#########################################################

cores_node=72
mpitask=$SLURM_NTASKS_PER_NODE
omp=$SLURM_CPUS_PER_TASK
export OMP_NUM_THREADS=$omp
export OMP_PLACES=cores
export NPB_MZ_BLOAD=0

echo "--------------------------------------------------"
echo "nodes: $SLURM_NODELIST                            "
echo "total nodes: $SLURM_NNODES                        "
echo "tasks per node: $SLURM_TASKS_PER_NODE             "
echo "cpus per task: $SLURM_CPUS_PER_TASK               "
echo "procid: $SLURM_PROCID                             "
echo "--------------------------------------------------"

module purge
module load nvidia/nvhpc/25.7
#module load scorep

# Measurement configuration
#export SCOREP_EXPERIMENT_DIRECTORY=scorep_bt-mz_sum
#export SCOREP_FILTERING_FILE=../config/scorep.filt
#export SCOREP_METRIC_PAPI=PAPI_TOT_INS,PAPI_TOT_CYC
#export SCOREP_ENABLE_TRACING=true
#export SCOREP_TOTAL_MEMORY=100M


dist=$(($cores_node/$mpitask))

start_time="$(date -u +%s.%N)"
cmd="mpirun -n $mpitask --bind-to core --map-by ppr:$mpitask:node:PE=$dist --report-bindings ./bt-mz_C.8  
eval $cmd
end_time="$(date -u +%s.%N)"
elapsed=`echo $end_time $start_time | awk '{print $1 - $2}'`
echo "Total of $elapsed seconds elapsed for siesta simulation $i on $mpitask cores"

