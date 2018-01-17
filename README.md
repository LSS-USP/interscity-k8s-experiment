# InterSCity Platform Experiment with K8S

This experiment aims at evaluating the InterSCity Platform perfomance and
scalability in a real smart city enviornment. For this purpose,
this repository has the scripts to run the platform on [GKE](https://cloud.google.com/container-engine)
using [Kubernetes automating tool](https://kubernetes.io/). We also use
the [InterSCSimulator](http://interscity.org/software/interscsimulator/) which
integrates with InterSCity platform to generate the required workload for
assessing the platform scalability. The experiment plan is described
[here (portuguese only)]().

# Setup

You need gcloud and kubectl command-line tools installed and set upto run 
deployment commands. Also make sure your Google Cloud account has
STATIC\_ADDRESSES available for the external access of Kong services.
[Follow the installation and login steps of Google Cloud SDK](https://cloud.google.com/sdk/docs/quickstart-debian-ubuntu)

As long as we use GKE's elastic features, you will need to create a new project
and [enable billing](https://support.google.com/cloud/answer/6293499?hl=pt-br#enable-billing)
for it.

The [Setup](setup) script has some variables that define the machine types and the
number of instances for each node pools we are creating. If you are going to
create a cluster with 86 CPUs, you must increase your quotas on GCloud service
(this action may require additional payments).
You must also increase the quota assigned for your project to create load balacers.
By default, GKE will allocate a number of "In-use IP addresses" equal to the
number of VMs in your cluster. However, you will need to expose the InterSCity
through Kong service for testing and experiments.

* Perform the following steps to install gcloud SDK:
```sh
# Create an environment variable for the correct distribution
export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"

# Add the Cloud SDK distribution URI as a package source
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

# Import the Google Cloud Platform public key
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# Update the package list and install the Cloud SDK
sudo apt-get update && sudo apt-get install google-cloud-sdk
```
* Initialize the SDK and chose a project:
```sh
gcloud init
```

* Test if it is everything ok:
```sh
gcloud compute machine-types list
```

* Installing kubectl:
```sh
sudo apt-get install kubectl
```

* Set the default zone:
```sh
gcloud config set compute/zone us-central1-f
```

* Create the Kubernetes cluster to run the experiment:
```sh
./setup create-all
```
This will take some time.

* Run the experiment:
```sh
./setup run
```
This will instantiate a unique pod of the InterSCSimulator in the simulator-pool
which will, after a while, create the actors, setup, and run the simulation.
I suggest you to follow the simulator's pod logs.

The entire experiment should take about 3:00 hours. However, you can get
partial results with the following command whenever you want:
```sh
./setup copy
```
This command will copy two files from simulator's pod:
* **/tmp/response_time.csv** -> contains the data related to the requests
performed by the simulator to the InterSCity platform
* **/tmp/events.csv** -> contains simulator-specific data related to events
that happened during the simulation.

Right now, we do not copy these files automatically at the end of the experiment.
For doing so, you need to copy the file by yourself running the abovementioned
command. After all, you can also finalize the experiment by running:
```sh
./setup stop
```
This will also copy the two files for your local machine.

## Compile the results

* Dependencies: R, Rscript, ggplot2 R lib

* We created the script [analysis.R](analysis.R) to read the **response_time.csv**
file and generate the graphs related to the experiment. We suggest you to 
create a new directory on the [outputs](outputs) folder (i.e.: 1st_experiment)
and move the **response_time.csv** file to this new directory. By doing so,
you can run the R script with:
```sh
Rscript analysis.R outputs/1st_experiment response_time.csv
```

This script will generate the experiment graphs on the same folder you passed
via the first argument (in this case, outputs/1st_experiment).


## Delete and Create pods

If you want to run the experiment several times, there is no need
to re-create the entire cluster. You can remove the pods and then re-create
them with the following commands:

```sh
./setup delete-pods
./setup create-pods
```

## Delete Everything - READ WITH ATTENTION

I've create an option on **setup** script to remove all my resources
from GCloud to prevent me from being charged for things I was not expecting.
So, if you have other resources in GCloud that have nothing to do with this
experiment, do not run the remove-all command.

Having said that, when you want to remove the cluster and other resources related to the
experiment, run the following command:
```sh
./setup delete-all
```


# References

* RabbitMQ
  * https://wesmorgan.svbtle.com/rabbitmq-cluster-on-kubernetes-with-statefulsets
* MongoDB
  * http://blog.kubernetes.io/2017/01/running-mongodb-on-kubernetes-with-statefulsets.html
  * https://www.mongodb.com/blog/post/running-mongodb-as-a-microservice-with-docker-and-kubernetes
* Postgres
  * https://github.com/sorintlab/stolon/blob/master/examples/kubernetes/README.md
* etcd
  * https://github.com/coreos/etcd/tree/master/hack/kubernetes-deploy
* Rails APP
  * https://engineering.adwerx.com/rails-on-docker-compose-7e2cf235fa0e
  * https://engineering.adwerx.com/rails-on-kubernetes-8cd4940eacbe
* Autoscaling
  * http://blog.kubernetes.io/2016/07/autoscaling-in-kubernetes.html
