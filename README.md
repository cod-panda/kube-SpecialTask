# kube-SpecialTask

Test task to learn kubes

## Preparations:

0. Get Fedora new VM

## Day 1 

1. GitHub:

	1.1 Register on github

	1.2 git clone https://github.com/cod-panda/kube-SpecialTask.git

2. Springboot (Download an example here https://spring.io/projects/spring-boot)

	2.1 Spring Quickstart Guide https://spring.io/quickstart

	2.2 Some small changes in `pom.xml`

		<artifactId>demo</artifactId>
		<packaging>jar</packaging>
		<version>1.0</version>


	2.3 Some small changes in code `src/main/java/com/example/demo/DemoAppName.java`

		@GetMapping("/hello")
		public String hello(@RequestParam(value = "name", defaultValue = "World") String name) {
		return String.format("<h1>Hello %s!</h1> <br><br> Version 1.0", name);	
	
	2.4 Test locally by curl 

	`$ ./mvnw spring-boot:run`

	`$ curl 127.0.0.1:8080/hello?name=WWW`

		<h1>Hello WWW!</h1> <br><br> Version 1.0

	2.5 Use `./mvnw install` to build the jar

## Day 2 

3. Docker

	3.1 Install Docker 

	`$ sudo dnf install docker-compose`

	`$ sudo systemctl start docker`

	`$ sudo systemctl enable docker`

	`$ sudo usermod -aG docker $USER && newgrp docker`

	3.2 Test installation 

	`$ docker run hello-world`

	3.3 Copy generated jar file
	
	`$ cp ../springboot/target/demo-1.0.jar .`
	
	3.4 Create simple Dokerfile and run the container
	
	`$ docker build -t v1 .`
	
	`$ docker run  -p 8080:8080 v1:latest`

	3.7 Test the application

	`$ curl 127.0.0.1:8080/hello?name=WWW`

		<h1>Hello WWW!</h1> <br><br> Version 1.0

## Day 3 

4. Github

	4.1 (1.2) Find out https clone wasn't the best option for console. Change to ssh auth, generate new key, add the key on github.
	
	`$ git clone git@github.com:cod-panda/kube-SpecialTask.git`

5. Git

	5.1 Setup some git settings like, username and e-mail.
	
	5.2 Think of what to add into git and what to keep locally.
	
	5.3 Add Springboot as a first commit.
	
	5.4 Add Docker as a second commit.
	
	5.5 Add this memo to the README to keep everything in git.
	
	5.6 Fix Markdown on the README


## Day 4 

6. DockerHub

	6.1 Create docketHub account.
	
	6.2 Create repo cod4panda/springboot_app
	
## Day 5

7. DockerHub upload exersises

	7.1 Docker upload exersises
	
	`$ docker login`
	
	`$ docker image build -t springboot_app/demo:v1 .`
	
	`$ docker tag springboot_app/demo:v1 cod4panda/springboot_app:demo`
	
	`$ docker push cod4panda/springboot_app:demo`

	`$ docker pull cod4panda/springboot_app:demo`	
	
	`$ docker search  cod4panda/springboot_app`
	
		NAME                       DESCRIPTION                              STARS     OFFICIAL   AUTOMATED
		cod4panda/springboot_app   Springboot simple app based on openjdk   0	

8. VS Code

	8.1 Install VS Code as it seems to be the standard for DevOps helping to cope the numerous yaml creations.

9. k8s

	9.1 Install kube linter from https://www.kubeval.com/installation/

	`$ wget https://github.com/instrumenta/kubeval/releases/latest/download/kubeval-linux-amd64.tar.gz`
		
	`$ tar xf kubeval-linux-amd64.tar.gz`
		
	`$ sudo cp kubeval /usr/local/bin`
		
	9.2 Work with kubernetes
	
	`$ kubectl create deployment springdemo --image=docker.io/cod4panda/springboot_app:demo`
		
	`$ kubectl expose deployment springdemo --type=LoadBalancer --port 8080`
		
	>  Specific for minicube to get the "external IP" one need to use:
		`$ minikube service springdemo --url`
			
	`$ minikube service springdemo --url`
	
		http://192.168.49.2:31162
		

	`$ curl -v http://192.168.49.2:31162/hello?name=KD`

		<h1>Hello KD!</h1> <br><br> Version 1.0
			
	9.3 Fix deployment: use edit to get the template and change some parameters

	`$ kubectl edit deployment springdemo`
	
	`$ kubectl edit service springdemo`
		
	Change:
	
		* Put everything in the same yaml (just because the deployment is small, not a good idea for big projects)
		* replicas: 3 - to have redundant set of replicas (single pod failure will not affect)
		* revisionHistoryLimit: 5 - to be able track 5 last rollouts
		* maxSurge: 1 - we want only one extra pod for the rollout, resources are low on the VM
		* maxUnavailable: 1 - we want only one pod to be deleted same time in rollouts
		* type: RollingUpdate - want to update pods one by one during rollout


		* The ports would be like
		* 	nodePort: 31162		external port
		*	port: 8080		service
		*	targetPort: 8080	pod


	9.4 Use linter
	
	`$ kubeval full_spring_demo.yaml`
	
		PASS - full_spring_demo.yaml contains a valid Deployment (default.springdemo)
		PASS - full_spring_demo.yaml contains a valid Service (default.springdemo)

	9.5 Check deployment results

	`$ kubectl apply -f full_spring_demo.yaml  --record`

	`$ kubectl get pods -o wide`
	
		NAME                          READY   STATUS    RESTARTS   AGE     IP            NODE       NOMINATED NODE   READINESS GATES
		springdemo-6c8bc57f56-2zwc4   1/1     Running   0          8m32s   172.17.0.8    minikube   <none>           <none>
		springdemo-6c8bc57f56-4mflw   1/1     Running   0          8m29s   172.17.0.10   minikube   <none>           <none>
		springdemo-6c8bc57f56-zzxkd   1/1     Running   0          8m32s   172.17.0.6    minikube   <none>           <none>

	`$ kubectl rollout history deployment.apps/springdemo`
	
		deployment.apps/springdemo
		REVISION  CHANGE-CAUSE
		1         <none>
		2         kubectl apply --filename=full_spring_demo.yaml --record=true
			
	`$ kubectl rollout status deployment.apps/springdemo`
	
		deployment "springdemo" successfully rolled out			

## Day 6
	
10. Helm

	10.1 Modify the initial k8s yaml and make it several Helm templates
	
	10.2 Use linter
	
	`$ helm lint spring-kube`
	
		==> Linting spring-kube
		1 chart(s) linted, 0 chart(s) failed

	10.3 Check what would be generated 
	
	`$ helm template spring-kube`
	
	10.4 Deploy test application
	
	`helm install springs spring-kube`

		NAME: springs
		LAST DEPLOYED: Fri Apr 22 18:36:22 2022
		NAMESPACE: default
		STATUS: deployed
		REVISION: 1
		TEST SUITE: None

	10.5 Check on k8s side

	`$ kubectl config set-context --current --namespace=springs`
		
		Context "minikube" modified.
	
	`$ kubectl get all`
		
		NAME                              READY   STATUS    RESTARTS   AGE
		pod/springdemo-7694b9b8b6-glw7l   1/1     Running   0          72s
		pod/springdemo-7694b9b8b6-p6967   1/1     Running   0          72s
		
		NAME                 TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
		service/springdemo   LoadBalancer   10.105.68.46   <pending>     8080:31162/TCP   72s

		NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
		deployment.apps/springdemo   2/2     2            2           72s

		NAME                                    DESIRED   CURRENT   READY   AGE
		replicaset.apps/springdemo-7694b9b8b6   2         2         2       72s
		
	10.6 Some repo tests

	`$ helm repo add banzaicloud-stable https://kubernetes-charts.banzaicloud.com`
	
	`$ helm repo list`

		NAME              	URL
		banzaicloud-stable	https://kubernetes-charts.banzaicloud.com
	
	`$ helm search repo  spring-boot`
	
		NAME                          	CHART VERSION	APP VERSION	DESCRIPTION
		banzaicloud-stable/spring-boot	0.0.5        	           	Run the simple spring-boot application

	`$ helm install my-spring-boot banzaicloud-stable/spring-boot --version 0.0.5`
	
## Day 7
	
11. Terraform solo without the Helm

	11.1 Prepare Terraform file, keeping certificates and keys in the terraform.tfvars (not pushing to git).
	
	11.2 Try
	
	`$ terraform init`
	
	`$ terraform validate`
	
		Success! The configuration is valid.
	
	`$ terraform plan`
	
	`$ terraform apply`
	
## Day 8

12. New App version

	`$ docker build -t "springboot_app/demo:v0.1.2" .`

	`$ docker tag "springboot_app/demo:v0.1.2" "cod4panda/springboot_app:0.1.2"`

	`$ docker push "cod4panda/springboot_app:0.1.2"`



	`$ kubectl apply -f full_spring_demo.yaml`

	`$ kubectl config set-context --current --namespace=springs`

	`$ minikube service springdemo -n springs --url`

	`$ curl http://192.168.49.2:31162/hello?name=w`

	`$ kubectl rollout status  deployment.apps/springdemo`

	`$ kubectl rollout history  deployment.apps/springdemo`

	`$ kubectl delete  deployment.apps/springdemo`

	`$ kubectl delete  service/springdemo`

	`$ kubectl config set-context --current --namespace=default`

	`$ kubectl delete ns springs`



	`$ helm install springs spring-kube`

	`$ helm uninstall springs`


	`$ terraform init`

	`$ terraform validate`
	
	`$ terraform fmt`	

	`$ terraform plan`

	`$ terraform apply`

	`$ terraform destroy`
		
		
13. Added Terraform in the Helm folder with the helm provider to use them together. 

	Wait set to false because of minukube.
	
	`$ terraform init`

	`$ terraform validate`
	
		Success! The configuration is valid.
	
	`$ terraform fmt`	

	`$ terraform plan`
	
		Terraform used the selected providers to generate the following execution plan.
		Resource actions are indicated with the following symbols:
		  + create

		Terraform will perform the following actions:

		  # helm_release.springdemo will be created
		  + resource "helm_release" "springdemo" {
		      + atomic                     = false
		      + chart                      = "./spring-kube"
		      + cleanup_on_fail            = true
		      + create_namespace           = false
		      + dependency_update          = false
		      + disable_crd_hooks          = false
		      + disable_openapi_validation = false
		      + disable_webhooks           = false
		      + force_update               = false
		      + id                         = (known after apply)
		      + lint                       = true
		      + manifest                   = (known after apply)
		      + max_history                = 0
		      + metadata                   = (known after apply)
		      + name                       = "springs"
		      + namespace                  = "default"
		      + recreate_pods              = false
		      + render_subchart_notes      = true
		      + replace                    = false
		      + reset_values               = false
		      + reuse_values               = false
		      + skip_crds                  = false
		      + status                     = "deployed"
		      + timeout                    = 60
		      + verify                     = false
		      + version                    = "0.1.2"
		      + wait                       = false
		      + wait_for_jobs              = false
		    }

		Plan: 1 to add, 0 to change, 0 to destroy.

	`$ terraform apply`
	
		helm_release.springdemo: Creating...
		helm_release.springdemo: Creation complete after 0s [id=springs]

		Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
	
	`$ minikube service springs -n springs --url`
	
		http://192.168.49.2:31162
		
	`$ curl http://192.168.49.2:31162/hello?name=kgdhkf`

		<h1>Hello kgdhkf!</h1> <br><br> Version 0.1.2

	`$ terraform destroy`
	
	
		
## TODO:
	CI/CD (Jenkins?)
