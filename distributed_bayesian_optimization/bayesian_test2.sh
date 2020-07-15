#!/bin/bash

#SBATCH --job-name=test
#SBATCH --cpus-per-task=1
#SBATCH --nodes=2
#SBATCH --tasks-per-node 1
#SBATCH --mem=1GB
## #SBATCH --time 0:10:00
#SBATCH --job-name=testing_distributed_BO

worker_num=1 # Must be one less that the total number of nodes

####################################
# CUSTOMIZE THE FOLLOWING LINES!!! #
####################################

#BASEDIR="/gpfs/work/ELIX4_valentin/cineca_tests"
#VENVPYTHONDIR="/gpfs/work/ELIX4_valentin/cineca_tests_venv"
#cd $BASEDIR
#module load python/3.6.4
#source $VENVPYTHONDIR/bin/activate
source my_venv/bin/activate

nodes=$(scontrol show hostnames $SLURM_JOB_NODELIST) # Getting the node names
nodes_array=($nodes)

node1=${nodes_array[0]}

ip_prefix=$(srun --nodes=1 --ntasks=1 -w $node1 hostname --ip-address) # Making address
suffix=':6379'
ip_head=$ip_prefix$suffix
redis_password=$(uuidgen)

export ip_head # Exporting for latter access by trainer.py

srun --nodes=1 --ntasks=1 -w $node1 ray start --block --head --redis-port=6379 --redis-password=$redis_password &# Starting the head
sleep 20
# Make sure the head successfully starts before any worker does, otherwise
# the worker will not be able to connect to redis. In case of longer delay,
# adjust the sleeptime above to ensure proper order.

for ((i = 0; i < $worker_num; i++)); do
  node2=${nodes_array[$i]}
  srun --nodes=1 --ntasks=1 -w $node2 ray start --block --address=$ip_head --redis-password=$redis_password &# Starting the workers
  # Flag --block will keep ray process alive on each compute node.
  sleep 10
done

python -u bayesian_opt.py $redis_password
