# kube-SpecialTask
Test task to learn kubes

Preparations:
0. Get Fedora new VM

Day 1 
1. GitHub
	1.1 Register on github
	1.2 git clone https://github.com/cod-panda/kube-SpecialTask.git
2. Springboot (Download an example here https://spring.io/projects/spring-boot)
	2.1 Spring Quickstart Guide https://spring.io/quickstart
	2.2 Some small changes in pom.xml
		<artifactId>demo</artifactId>
		<packaging>jar</packaging>
		<version>1.0</version>
	2.3 Some small changes in code src/main/java/com/example/demo/DemoAppName.java
		@GetMapping("/hello")
        public String hello(@RequestParam(value = "name", defaultValue = "World") String name) {
        return String.format("<h1>Hello %s!</h1> <br><br> Version 1.0", name);	
	2.4 Test locally by curl 
		./mvnw spring-boot:run
		[k@fedora ~]$ curl 127.0.0.1:8080/hello?name=WWW
		<h1>Hello WWW!</h1> <br><br> Version 1[k@fedora ~]$
	2.5 Use `./mvnw install` to build the jar

Day 2 
3. Docker
	3.1 Install Docker `sudo dnf install docker-compose`, `sudo systemctl start docker`, `sudo systemctl enable docker`, `sudo usermod -aG docker $USER && newgrp docker`
	3.2 test `docker run hello-world`
	3.3 cp ../springboot/target/demo-1.0.jar .
	3.4 create simple Dokerfile
	3.5 docker build -t v1 .
	3.6 docker run  -p 8080:8080 v1:latest
	3.7 [k@fedora kube-SpecialTask]$ curl 127.0.0.1:8080/hello?name=WWW
	<h1>Hello WWW!</h1> <br><br> Version 1.0

Day 3 
4. Github
	4.1 (1.2) Find out https clone wan't the best option for console. Change to ssh auth, generate new key, add the key on github.
	git clone git@github.com:cod-panda/kube-SpecialTask.git
5. Git
	5.1 Setup some git settings like, username and e-mail.
	5.2 Think of what to add into git and what to keep locally.
	5.3 Add Springboot as a first commit.
	5.4 Add Docker as a second commit.
	5.4 Add this memo to the README to keep everything in git.

TODO:
	1. Push docker image (to register on the docker hub) 
	2. Create Kube deployment with the docker image
	3. Think of the deployment strategy
