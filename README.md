## 1. Deploy an Auto-Scaling HPC Cluster with Slurm on Google Cloud
* Follow this Google tutorial to install the Slurm cluster: [https://codelabs.developers.google.com/codelabs/hpc-slurm-on-gcp/#0](https://codelabs.developers.google.com/codelabs/hpc-slurm-on-gcp/#0)
* To add [preemptible](https://cloud.google.com/preemptible-vms) GPU nodes (for [users that are outside of your organization](https://cloud.google.com/compute/docs/instances/managing-instance-access#configure_users) to access your VMs): 
  * modify the slurm config file in [the tutorial step 3](https://codelabs.developers.google.com/codelabs/hpc-slurm-on-gcp/#2), 
  * or use this slurm config file [slurm-cluster-gpu.yaml](slurm/slurm-cluster-gpu.yaml) and [slurm.jinja](slurm/slurm.jinja) when you [deploy the configuration](https://codelabs.developers.google.com/codelabs/hpc-slurm-on-gcp/#3) from the GCP Console Cloud Shell:
    ```
    git clone https://github.com/SchedMD/slurm-gcp.git
    cd slurm-gcp
    
    wget https://raw.githubusercontent.com/fengchenLBL/gcp-slurm/master/slurm/slurm-cluster-gpu.yaml
    wget https://raw.githubusercontent.com/fengchenLBL/gcp-slurm/master/slurm/slurm.jinja -O slurm.jinja
    
    gcloud deployment-manager deployments create google2 --config slurm-cluster-gpu.yaml
    ```
    
## 2. Generate a new SSH key and add it to the Slurm login node
### This SSH login works for any users that are outside or inside of your organization. 
* From your local terminal, generate an SSH key-pair for a new user, e.g. `newuser01`
```
 ssh-keygen -t rsa -b 4096 -f ./newuser01 -C "newuser01"
```
* A public SSH key `./newuser01.pub` and a private SSH key `./newuser01` are generated: 
```
cat ./newuser01.pub
```
* From the GCP Console, click the slurm login node (in this example `g2-login0`): __EDIT__ -> __SSH Kyes__ -> __Add item__
  * Paste the the public SSH key above
  * Click __Save__
* Log in to the slurm cluster login node from your local terminal via the private SSH key you just created for user `newuser01`
  * From the GCP Console, copy the __External IP__ of the slurm login node `g2-login0`
  * From your local terminal:
  ```
  ssh -i ./newuser01 newuser01@External_IP
  ```
    
## 3. Use Ray to run [Distributed Bayesian Optimization](https://github.com/LucaCappelletti94/distributed_bayesian_optimization.git) on Slurm cluster
* Log in to the slurm cluster login node 
  * From the GCP Console Cloud Shell (for users inside of your organization):
  ```
  # g2-login0 is the name of slurm login node
  gcloud compute ssh g2-login0 --zone=<ZONE>
  ```
  * From the local terminal (for users outside of your organization):
  ```
  # you can find the External_IP of the slurm login node `g2-login0` from GCP Console
  ssh -i ./newuser01 newuser01@External_IP
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
