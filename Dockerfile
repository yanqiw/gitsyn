FROM ubuntu:14.04
MAINTAINER Frank Wang <wangyanqi@outlook.com>

#install git, ioen ssh server
RUN apt-get update
RUN apt-get install -y git
RUN apt-get install -y openssh-server

#create ssh folder
RUN mkdir /var/run/sshd

#add git user
RUN useradd -ms /bin/bash git

#create workspace
RUN mkdir /repo
RUN echo "Create git repo folder"

#go to repo
WORKDIR /repo

#create runtime repo
RUN mkdir runtime.git
WORKDIR /repo/runtime.git

#Init bare repo
RUN git init --bare

#copy auto pull hooks to git repo
COPY ./githooks/ /repo/runtime.git/hooks/
#change the hooks mod to executable
WORKDIR /repo/runtime.git/hooks

#remove \r which may added by win
RUN sed -i -e 's/\r$//' post-receive

RUN chmod a+x post-receive
RUN chown -R git:git /repo

#create workspace
WORKDIR /
RUN mkdir workspace
WORKDIR /workspace
RUN chown -R git:git /workspace

#copy authorized_keys
WORKDIR /home/git/
RUN mkdir .ssh
COPY ./sshkeys/authorized_keys /home/git/.ssh/authorized_keys
WORKDIR /home/git/.ssh
RUN chmod 600 authorized_keys
RUN chown -R git:git /home/git

#config root ssh
#RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config


#start ssh service
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
