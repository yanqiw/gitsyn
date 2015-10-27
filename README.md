#Overview
This repo is used to create a automatic synchronization git repo. It is a key component in online devleopment runtime project. You can run build this the image with your puhlic SSH key.

#Guide
##Clone this repo
```bash
cd /to/your/workspace
git clone https://github.com/yanqiw/gitsyn
```

##Add your public ssh key
```bash
cd gitsyn
mv sshkeys/authorized_keys.sample sshkeys/authorized_keys 
echo path/your/sshpubilckey > sshkeys/authorized_keys
```
##Build Image
```bash
docker build -t project-name-git-repo .
```

##Run the image
If you build the image in your laptop, you need push the image to your cloud, and run the image in cloud
In your could server, run command
```bash
docker run --name project-name-git -v your/host/workdir:/workspace -p YOUR_HOST_PORT:22 project-name-git-repo
```
YOUR_HOST_PORT is the port on your host which you want to expose.

##Init your local git remote
You need to add the git remote to your local git
```bash
git remote add runtime YOUR_PROJECT_GIT_REPO
```
YOUR_PROJECT_GIT_REPO is the git repo on your cloud. 

##Test
In your local workspace, run:
```bash
git push runtime master
```
If the push is successful, open your cloud server to check the code in your host workdir which is used in the container 

#Auto push to cloud
##Add hooks in your local git
Go to your project folder.
```bash
touch .git/hooks/post-commit
echo "#/bin/bash" > .git/hooks/post-commit
echo "git push runtime master" >> .git/hooks/post-commit
```
After add the hooks you the push is automatic run about commit

##Run some file monitor script
If you want to auto-push after file save, you need to run some file monitor script or task.
###In python
TO-DO


#Runtime image
##Nginx
This is a quick demo to running runtime container on cloud. In cloud server, go to the work folder run below command:
'''sh
docker run --name nginx_runtime -v "$PWD":/usr/share/nginx/html:ro -p 8080:80 -d nginx
'''
###Test
Open yourdomian.com:8080
