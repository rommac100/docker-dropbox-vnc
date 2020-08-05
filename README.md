# This repo contains the Dockerfile for Dropbox container that has a Desktop environment present in it. 
The main reason for this container is that Dropbox headless's exclusion function is somewhat broken at the moment for Business accounts with large numbers of files.
Specifically, it is not possible to do a blanket exclude all files & folders and manually select a few of the base team folders. So this container with the gui version of Dropbox allows multiple instances
of the Dropbox gui application to run to bypass some performance issues with large quantities of synced files and allows for this exclusion issue to be mitigated.

# Setup
For Linux, I created a Makefile that would work decently enough to both build the Dockerfile and create a container using the image. Note that there are some variables that should be configured in the Makefile.
Specifically, the PORT_PUBLISH should be configured so that it doesn't overlap with other Docker containers. The Container name variable should be changed as needed, and the Base dir should be configured differently depending on where you want your Dropbox files to be located on your Docker host. Or you can also change the USER variable to the correct user that is on your Docker host and it will just create a new container based name folder in that user's based home directory.
Once the variables have been configured. Use `make build` to create the image and `make run` to create the container and run it.

For the windows .bat script the variables to change are similar but the there are two different bat files: one for building the image, and one for running and creating the container. Most of the important variables will be present in the run script.
Specifically run theses commands in the order present:
`build.bat`
`run_docker.bat`
Also note that there are some additional hoops that need to be jumped through for the windows version since mounting volumes through docker doesn't always give the container the proper permissions.
If you bring up a bash in the docker image with the root user specified:
`docker exec -it --user root (container_name) /bin/bash`
You should be able to apply the updated ownership to the desired folder (most likely /dbox/.config and /dbox/Dropbox will need ownerships change but a `chown -R /dbox`) will work just fine instead of individually changing the ownership
# Post container creation
You will need to create a vncpasswd before the lxde desktop is accessable. Use the following command to get a bash connection to the container
`docker exec -it (container_name) /bin/bash`
Here you should be able to execute `vncpasswd` and that command will allow the vncserver to act properly. You should restart the container though before attempting to connect `docker restart (container_name)`

Once you are able to connect to the vnc output (probably using a vncviewer on the Docker host with addresses like "localhost:(insert port_publish port)"), you should run the follow commands:
<a> </a>
`dropbox start -i` This should show url that you have to paste into a browser on your Docker host in order to link the Dropbox client with your account.
`dropbox stop` stops the dropbox application
`dropbox start -i` starts the dropbox application and the 'taskbar' icon for Dropbox should appear. 

You should be able to access the preferences on Dropbox and change the selective sync settings.

# Solutions to bugs that occur with the Dropbox application.
Sometimes the selective sync request won't come through right away (especially if you have large sync queue already occuring).
In cases like this, I have found it helpful to clear the hidden dropbox folders in /dbox/Dropbox. *Note Dropbox will to be closed in order for this to work*
Also when you do try to close dropbox while a large sync queue is present, dropbox will usually not close correctly. Not additional action is required to close Dropbox when this occurs but it will spout a warning in the console. I haven't found this cause any problems but it should be noted.
