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
			

## TODO:
