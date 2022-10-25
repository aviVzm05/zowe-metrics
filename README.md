# zowe-metrics
Repository with details of kubernetes config files to create prometheus and zowe containers
this uses the zowe docker image created from zowe-docker repository with few changes in entry point file and docker file that are copied here for refference

Also, a secret has to be created with details of the mainframe ID and password that can be passed on as environmental variables to the zowe container.