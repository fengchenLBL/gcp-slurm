## Deploy an Auto-Scaling HPC Cluster with Slurm on Google Cloud
* Follow this Google tutorial to install the Slurm cluster: [https://codelabs.developers.google.com/codelabs/hpc-slurm-on-gcp/#0](https://codelabs.developers.google.com/codelabs/hpc-slurm-on-gcp/#0)
* To add [preemptible](https://cloud.google.com/preemptible-vms) GPU nodes, modify the slurm file in the tutorial step 3, or use this slurm file [slurm-cluster-gpu.yaml]()

## Use Ray to run distributed Bayesian optimization on Slurm cluster
Log in to the slurm cluster login nodenode
```
gcloud compute ssh g2-login0 --zone=<ZONE>
```

Download [distributed_bayesian_optimization](https://github.com/LucaCappelletti94/distributed_bayesian_optimization.git) repo and install the required packages on the slum login node:
```
git clone https://github.com/LucaCappelletti94/distributed_bayesian_optimization.git
cd distributed_bayesian_optimization

sudo yum install python-devel python3-devel gcc-c++

python3 -m venv my_venv
source my_venv/bin/activate
bash setup.sh
```
Run a test [bayesian_test2.sh]():
```
# In bayesian_test.sh,  add "source my_venv/bin/activate"
sbatch bayesian_test2.sh
```

The results in BO.csv.
