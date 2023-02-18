![assign-arch drawio](https://user-images.githubusercontent.com/25542518/219869497-088f9a5d-2786-4b4f-afcb-5621b70c359f.png)


# TASK_1:

### Subtask 1
* install terraform and awscli
```
sudo apt install curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt update
sudo apt-get install terraform
sudo apt  install awscli
```
	
* create bucket in s3 from UI used in provider.tf


### Subtask 2
* create vpc.tf
```
terraform init
terraform apply
```



### Subtask 3
* use http://ipv4.icanhazip.com/ as data and use the same
```
vi sg.tf
terraform init
terraform apply
```
 
* Since using terraform-vm is in aws, ssh to bastion VM from terraform-vm (with ip taken dynamically from use http://ipv4.icanhazip.com/ as data )


### Subtask 4
* create ec2s
```
vi ec2.tf
terraform init
terraform apply
```
 
* Only bastionVM has public ip and jenkins vm and app vm are private ip
* To configure proxy jumping, temperorily copy pem configured in terraform-vm to bastion VM and now able ssh to app and jenkins VM.(ssh -i task1pem.pem ubuntu@54.234.113.145 # bastion VM
)

* On terraform-vm (as selfvm) : ssh-keygen
* copy public key(.ssh/id_rsa.pub) to authorized keys(.ssh/authorized_keys) of jenkins and app and bastion 
* On terraform-vm(considered as selfVM)
```
vi .ssh/config
Host bastion
User ubuntu
Hostname 10.96.229.59

Host jenkins
User ubuntu
Hostname 10.96.229.28
Port 22
ProxyCommand ssh -q -W %h:%p bastion

Host app
User ubuntu
Hostname 10.96.229.16
Port 22
ProxyCommand ssh -q -W %h:%p bastion
```


```
ssh jenkins
ssh app
ssh bastion
```
* proxyjump completed


### Subtask Bonus:
* Architcture



# TASK_2

### Subtask 1
* Ansible on Bastion host
```
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py --user
python3 -m pip install --user ansible
#exit and relogin
ansible --version
```


```
mkdir inventory
inventory > hosts
vi inventory/hosts
```
   
* ping check
`ansible all -m ping -i inventory`

* roles
```
ansible-galaxy role init docker-ins
vi docker-ins/files/docker-ins.sh 
vi docker-ins/tasks/maimn.yaml
vi docker-playbook.yaml
```

* install docker on jenkins and app vm
`ansible-playbook docker-playbook.yaml -e curr_host=all -i inventory
`

   
### Subtask 2

* Create ALB
* * edit listeners > manage rules > insert rule as below
* * targetgroup 1 > ALB forwards /jenkins, /jenkins/* to a Target Group having Jenkins host (port 8080) as backend
* * targetgroup 2 > ALB forwards /app, /app/* to a Target Group having app host (port 8080) as backend

> Browser > http://lb3-307729333.us-east-1.elb.amazonaws.com



### Subtask 3
* Install jenkins
from terraform VM
```
ssh jenkins # proxy jumper bastion to jenkins
sudo apt update
sudo apt install openjdk-11-jre
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins
#prefix url
sudo vi /lib/systemd/system/jenkins.service > Environment="JENKINS_OPTS=--prefix=/jenkins"
sudo systemctl daemon-reload
```
#For error: Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Post "http://%2Fvar%2Frun%2Fdocker.sock/v1.24/build?buildargs=%7B%7D&cachefrom=%5B%5D&cgroupparent=&cpuperiod=0&cpuquota=0&cpusetcpus=&cpusetmems=&cpushares=0&dockerfile=Dockerfile&labels=%7B%7D&memory=0&memswap=0&networkmode=default&rm=1&shmsize=0&t=demoapp1&target=&ulimits=null&version=1": dial unix /var/run/docker.sock: connect: permission denied
`sudo usermod -a -G docker jenkins`
#restart jenkins
`sudo systemctl restart jenkins`

> Browser > http://lb3-307729333.us-east-1.elb.amazonaws.com/jenkins/manage/

* ssh by Jumper vm
From terraform VM
`ssh jenkins`# proxy jumper bastion to jenkins
ubuntu@ip-10-0-1-109:~$ `sudo cat /var/lib/jenkins/secrets/initialAdminPassword`
368d99c531cf4d5abf7ff2890ed5debb


### Subtask 4
* create ecr repo 
go to view push command and copy login commad
#no basic auth credentials while ecr push
#create/provide ecr full role to jenkins and app VM
* on jenkins server
```
sudo su jenkins
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 532984066635.dkr.ecr.us-east-1.amazonaws.com
```

#create/provide ecr full role to VM
* on app server
`aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 532984066635.dkr.ecr.us-east-1.amazonaws.com`


* on jenkins vm
```
ssh jenkins
sudo su jenkins
ssh-keygen -t rsa -C "jenkins" -m PEM -P "" -f /var/lib/jenkins/.ssh/id_rsa ### Failed to add SSH key. Message [invalid privatekey
```
copy /var/lib/jenkins/.ssh/id_rsa.pub content to appservers .ssh/authorized_keys


* on app server
```
ssh app
sudo vi /etc/ssh/sshd_config  #and add PubkeyAcceptedAlgorithms=+ssh-rsa
vi .ssh/authorized_keys
sudo systemctl restart sshd
```

> jenkins is able to ssh to appserver


# TASK_3

### Subtask 1
* create private repo
https://github.com/NiranjanV12/assignment-repo1/blob/main/Dockerfile

* build image
`docker build -t demoapp1 .
`
* run image
```
sudo docker run -p 8080:8081 demoapp1:latest
curl localhost:8080
```

### Subtask 2
* pipeline in jenkinsfile
https://github.com/NiranjanV12/assignment-repo1/blob/main/jenkinsfile

* install plugin Publish Over SSH
#configure ssh for app server in jenkins settings
* * http://lb3-307729333.us-east-1.elb.amazonaws.com/jenkins/manage/configure 
* * give key path to /var/lib/jenkins/.ssh/id_rsa
* * and fill other details( check SS)
* * test configuration

* new Item > pipeline > pipeline script from SCM
#check Screenshot
* * add github creds (user and PAT) in jenkins cred and use the same
* * branch : */main
* * script: jenkinsfile

* Parameter IMG_VER used for docker tag with latest as default

* Build Now # 1st build might fail as its parameterized, will automically appear the 2nd time in jenkins ui


### Subtask 3
In deploy stage, shell script check if older image container is running and stop it, run new image version container

> http://lb3-307729333.us-east-1.elb.amazonaws.com/app return Hello World





