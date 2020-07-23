## 1. Deploy an Auto-Scaling HPC Cluster with Slurm on Google Cloud
* Follow this Google tutorial to install the Slurm cluster: [https://codelabs.developers.google.com/codelabs/hpc-slurm-on-gcp/#0](https://codelabs.developers.google.com/codelabs/hpc-slurm-on-gcp/#0)
* To add [preemptible](https://cloud.google.com/preemptible-vms) GPU nodes (for [users that are outside of your organization](https://cloud.google.com/compute/docs/instances/managing-instance-access#configure_users) to access your VMs): 
  * modify the slurm config file in [the tutorial step 3](https://codelabs.developers.google.com/codelabs/hpc-slurm-on-gcp/#2), 
  * or use this slurm config file [slurm-cluster-gpu.yaml](slurm/slurm-cluster-gpu.yaml) and [slurm.jinja](slurm/slurm.jinja) when you [deploy the configuration](https://codelabs.developers.google.com/codelabs/hpc-slurm-on-gcp/#3), and run:
    ```
    git clone https://github.com/SchedMD/slurm-gcp.git
    cd slurm-gcp
    
    wget https://raw.githubusercontent.com/fengchenLBL/gcp-slurm/master/slurm/slurm-cluster-gpu.yaml
    wget https://raw.githubusercontent.com/fengchenLBL/gcp-slurm/master/slurm/slurm.jinja
    
    gcloud deployment-manager deployments create google2 --config slurm-cluster-gpu.yaml
    ```
## 2. Use Ray to run [Distributed Bayesian Optimization](https://github.com/LucaCappelletti94/distributed_bayesian_optimization.git) on Slurm cluster
* Log in to the slurm cluster login node
```
# g2-login0 is the name of slurm login node
gcloud compute ssh g2-login0 --zone=<ZONE>
```

* Download [distributed_bayesian_optimization](https://github.com/LucaCappelletti94/distributed_bayesian_optimization.git) repo and install the required packages on the slurm login node:
```
git clone https://github.com/LucaCappelletti94/distributed_bayesian_optimization.git
cd distributed_bayesian_optimization

sudo yum install python-devel python3-devel gcc-c++

python3 -m venv my_venv
source my_venv/bin/activate
bash setup.sh
```
* Submit a slurm testing job [bayesian_test2.sh](distributed_bayesian_optimization/bayesian_test2.sh):
```
wget https://raw.githubusercontent.com/fengchenLBL/gcp-slurm/master/distributed_bayesian_optimization/bayesian_test2.sh
sbatch bayesian_test2.sh
```

* Output:
  * [BO.csv](distributed_bayesian_optimization/BO.csv)
  * [slurm logfile](distributed_bayesian_optimization/slurm-7.out)
  
## References:
* https://github.com/LucaCappelletti94/distributed_bayesian_optimization
