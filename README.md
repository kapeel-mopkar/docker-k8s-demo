# docker-k8s-demo
docker images (Before)
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
hello-world         latest              bf756fb1ae65        6 months ago        13.3kB

# make docker environment available to minikube
eval $(minikube docker-env)

docker images (After)
REPOSITORY                                TAG                 IMAGE ID            CREATED             SIZE
kubernetesui/dashboard                    v2.0.1              85d666cddd04        7 weeks ago         223MB
k8s.gcr.io/kube-proxy                     v1.18.3             3439b7546f29        7 weeks ago         117MB
k8s.gcr.io/kube-scheduler                 v1.18.3             76216c34ed0c        7 weeks ago         95.3MB
k8s.gcr.io/kube-apiserver                 v1.18.3             7e28efa976bd        7 weeks ago         173MB
k8s.gcr.io/kube-controller-manager        v1.18.3             da26705ccb4b        7 weeks ago         162MB
kubernetesui/metrics-scraper              v1.0.4              86262685d9ab        3 months ago        36.9MB
k8s.gcr.io/pause                          3.2                 80d28bedfe5d        4 months ago        683kB
k8s.gcr.io/coredns                        1.6.7               67da37a9a360        5 months ago        43.8MB
k8s.gcr.io/etcd                           3.4.3-0             303ce5db0e90        8 months ago        288MB
gcr.io/k8s-minikube/storage-provisioner   v1.8.1              4689081edb10        2 years ago         80.8MB

# creates image 
docker build -t employee-service-k8s:1.0 .

docker images
REPOSITORY                                TAG                 IMAGE ID            CREATED             SIZE
employee-service-k8s                      1.0                 c00e43872070        3 minutes ago       167MB
adoptopenjdk/openjdk8                     alpine-jre          260ee9b59760        5 weeks ago         127MB
kubernetesui/dashboard                    v2.0.1              85d666cddd04        7 weeks ago         223MB
k8s.gcr.io/kube-proxy                     v1.18.3             3439b7546f29        7 weeks ago         117MB
k8s.gcr.io/kube-apiserver                 v1.18.3             7e28efa976bd        7 weeks ago         173MB
k8s.gcr.io/kube-scheduler                 v1.18.3             76216c34ed0c        7 weeks ago         95.3MB
k8s.gcr.io/kube-controller-manager        v1.18.3             da26705ccb4b        7 weeks ago         162MB
kubernetesui/metrics-scraper              v1.0.4              86262685d9ab        3 months ago        36.9MB
k8s.gcr.io/pause                          3.2                 80d28bedfe5d        4 months ago        683kB

Need to create deployment and service objects for our app usinf kubectl (command line tool for kubernetes)

# image pull policy can be IfNotPresent locally download, but here we will specify Never (Did not run)
 -- kubectl run employee-service --image=employee-service-k8s:1.0 --port=8080 --image-pull-policy=Never

This one worked
kubectl create deployment kubernetes-sample --image=employee-service-k8s:1.0

# Create service from deployment and expose service to external client using Nodeport
kubectl expose deployment kubernetes-sample --name=employee-service --type=NodePort --port=8080 --target-port=8080

# Manually scaling deployment, by increasing replicas
kubectl scale --replicas=3 deployments/kubernetes-sample

# To view deployments, services etc and real-time stats
minikube dashboard

# Autoscale pods based on CPU consumption
kubectl autoscale deployment kubernetes-sample-1 --min=1 --max=5 --cpu-percent=75

# get hpa = horizontal pod autoscaler , for details
kubectl get hpa
NAME                REFERENCE                      TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
kubernetes-sample   Deployment/kubernetes-sample   <unknown>/75%   1         5         1          2m58s

# Change docker image in deployment from 1.0 to 2.0 
    # Make sure you have 2.0 image - docker build -t employee-service-k8s:2.0 .
kubectl set image deployment kubernetes-sample employee-service-k8s=employee-service-k8s:2.0

# Details ond eployment
kubectl describe deployments
Name:                   kubernetes-sample
Namespace:              default
CreationTimestamp:      Sun, 12 Jul 2020 15:53:57 +0530
Labels:                 app=kubernetes-sample
Annotations:            deployment.kubernetes.io/revision: 2
Selector:               app=kubernetes-sample
Replicas:               1 desired | 1 updated | 1 total | 1 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=kubernetes-sample
  Containers:
   employee-service-k8s:
    Image:        employee-service-k8s:2.0
    Port:         <none>
    Host Port:    <none>
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   kubernetes-sample-84698bdb9b (1/1 replicas created)
Events:
  Type    Reason             Age    From                   Message
  ----    ------             ----   ----                   -------
  Normal  ScalingReplicaSet  44m    deployment-controller  Scaled up replica set kubernetes-sample-7c54f547bf to 1
  Normal  ScalingReplicaSet  42m    deployment-controller  Scaled up replica set kubernetes-sample-7c54f547bf to 3
  Normal  ScalingReplicaSet  11m    deployment-controller  Scaled down replica set kubernetes-sample-7c54f547bf to 1
  Normal  ScalingReplicaSet  2m36s  deployment-controller  Scaled up replica set kubernetes-sample-84698bdb9b to 1
  Normal  ScalingReplicaSet  2m34s  deployment-controller  Scaled down replica set kubernetes-sample-7c54f547bf to 0
  
  


# Can also do similar steps using yaml files for deployment and services.
# Make sure deployment, service and pods created previously are deleted.

# For creating deployment and service, kubectl apply can be used 
# Deployment creation using yaml
kubectl apply -f ./src/main/resources/deployment.yml 
deployment.apps/docker-k8s-demo created

# Service creation using yaml
kubectl apply -f ./src/main/resources/service.yml 
service/docker-k8s-demo created

usung minikube ip and nodeport, the application can be accessed :
curl --location --request GET 'http://192.168.99.101:30163/docker-demo/employees'
