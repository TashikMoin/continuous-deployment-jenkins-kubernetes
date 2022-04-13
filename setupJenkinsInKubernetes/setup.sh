# Guide to install jenkins in a Kubernetes cluster,
# https://www.jenkins.io/doc/book/installing/kubernetes/

kubectl create namespace jenkins
helm repo add jenkinsci https://charts.jenkins.io
helm repo update
helm show values jenkinsci/jenkins > ./jenkinsValues.yaml

sed -i 's/# adminPassword: <defaults to random>/adminPassword: "admin"/' jenkinsValues.yaml
# sets default jenkins password to 'admin'

sed -i 's/serviceType: ClusterIP/serviceType: LoadBalancer/' jenkinsValues.yaml
# changes the jenkins service from ClusterIP to LoadBalancer

sed -i 's/installLatestSpecifiedPlugins: false/installLatestSpecifiedPlugins: true/' jenkinsValues.yaml
# to install latest specified plugins


helm install jenkins jenkinsci/jenkins --values ./jenkinsValues.yaml -n jenkins
# applying the values file and installing jenkins


printf "\n\n... wait for 2-3 minutes to install jenkins ...\n\n"
printf "... Once all the installation is done, run 'kubectl get all -n jenkins' ...\n\n"
printf "... Access jenkins on port 8080 with external IP of the LoadBalancer service of jenkins ...\n\n"
printf "... Search and install all the plugins manually that are listed under jenkins warning/notification. ...\n\n"


