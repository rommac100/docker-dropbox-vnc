FROM ubuntu:18.04
MAINTAINER cmccormick@pulselink.net
RUN apt-get update && apt-get upgrade -y
ARG DEBIAN_FRONTEND=noninteractive
# Install Dropbox dependencies
RUN apt-get install libc6 libglapi-mesa libxdamage1 libxfixes3 libxcb-glx0 libxcb-dri2-0 libxcb-dri3-0 libxcb-present0 libxcb-sync1 libxshmfence1 libxxf86vm1 -y

ENV TZ=US/Phoenix

# Install lxde, xorg, nano, vim, Nautilus, dropbox
RUN apt-get install nano xorg lxde-core vim xterm nautilus nautilus-dropbox -y

# Add User
RUN groupadd dropbox
RUN useradd -m -d /dbox -c "Dropbox account" -s /usr/sbin/nologin -g dropbox dropbox
RUN usermod -a -G sudo dropbox

ENV USER dropbox
ENV LANG C.UTF-8

# Dropbox creation stuff
RUN mkdir -p /dbox/.dropbox /dbox/.dropbox-dist
RUN chown -R dropbox /dbox/
RUN mkdir -p /dbox/Dropbox

# Install VNC Server
RUN apt-get install tightvncserver -y
USER dropbox
COPY passwd /dbox/.vnc/passwd
COPY xstartup /dbox/.vnc/
USER root
RUN chmod +x /dbox/.vnc/xstartup
USER dropbox

COPY vnc.sh /dbox/.vnc/
USER root
RUN chmod +x /dbox/.vnc/vnc.sh
RUN chown -R dropbox /dbox/
RUN chown -R dropbox /dbox/Dropbox
VOLUME ["/dbox/.dropbox" , "/dbox/Dropbox"]
USER dropbox


CMD ["/dbox/.vnc/vnc.sh"]
