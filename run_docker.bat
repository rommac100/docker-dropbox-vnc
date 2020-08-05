set IMAGE=docker-dropbox
set VERSION=1.0
set CONTAINER_NAME=dropbox-1
set BASE_DIR=C:\Users\lab\Desktop\dropbox-1
set CONFIG_DIR=%BASE_DIR%\.config
set DROPBOX_DIR=%BASE_DIR%\Dropbox
set /A PORT_PUBLISH=5905

docker run --publish %PORT_PUBLISH%:5901 --name %CONTAINER_NAME% -v %CONFIG_DIR%:/dbox/.config -v %DROPBOX_DIR%:/dbox/Dropbox %IMAGE%:%VERSION%
pause