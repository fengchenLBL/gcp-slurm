## Deploy an Auto-Scaling HPC Cluster with Slurm on Google Cloud
* Follow this Google tutorial to install the Slurm cluster: [https://codelabs.developers.google.com/codelabs/hpc-slurm-on-gcp/#0](https://codelabs.developers.google.com/codelabs/hpc-slurm-on-gcp/#0)
* To add [preemptible](https://cloud.google.com/preemptible-vms) GPU nodes, modify the slurm config file in [the tutorial step 3](https://codelabs.developers.google.com/codelabs/hpc-slurm-on-gcp/#2), or use this slurm config file [slurm-cluster-gpu.yaml](slurm/slurm-cluster-gpu.yaml) when you [deploy the configuration](https://codelabs.developers.google.com/codelabs/hpc-slurm-on-gcp/#3)

## Use Ray to run [Distributed Bayesian optimization](https://github.com/LucaCappelletti94/distributed_bayesian_optimization.git) on Slurm cluster
* Log in to the slurm cluster login node
```
# g2-login0 is the name of slurm login node
gcloud compute ssh g2-login0 --zone=<ZONE>
```

* Download [distributed_bayesian_optimization](https://github.com/LucaCappelletti94/distributed_bayesian_optimization.git) repo and install the required packages on the slum login node:
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
sbatch bayesian_test2.sh
```

* Output:
  * [BO.csv](distributed_bayesian_optimization/BO.csv)
  * [slurm logfile](distributed_bayesian_optimization/slurm-7.out)
