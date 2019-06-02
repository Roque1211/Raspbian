#!/bin/bash 
#***********************************
# borra los contenedores
#***********************************
read -p "¿borrar los contenedores?(s)" borra

if [ "$borra" = "s" ] || [ "$borra" = "S" ]; then
	sudo docker stop blcr
	sudo docker  rm blcr
	sudo docker stop wsrv1
	sudo docker rm wsrv1
        sudo docker stop wsrv2
	sudo docker rm wsrv2
        sudo docker stop dbsrv
	sudo docker rm dbsrv
	docker ps -a 
fi

#***********************************
# crea los contenedores
#***********************************
read -p "¿crear los contenedores?(s)" crea
if [ "$crea" = "s" ] || [ "$crea" = "S" ]; then
	sudo docker run -dti --network rapspinet --ip 192.168.34.11 --name blcr ssh 
	sudo docker run -dti -p 80 --network rapspinet --ip 192.168.34.12 --name wsrv1 ssh 
	sudo docker run -dti -p 80 --network rapspinet --ip 192.168.34.13 --name wsrv2 ssh 
	sudo docker run -dti --volume /media/pi/Disco/pi/mysql:/var/lib/mysql --network rapspinet --ip 192.168.34.14 --name dbsrv ssh
	sudo docker ps -a
fi

#***********************************
# ansible
#***********************************
read -p "¿crear los balanceadores?(s)" creab
if [ "$creab" = "s" ] || [ "$creab" = "S" ]; then
	ansible-playbook -k loadbalancers.yml
	ansible-playbook -k webservers.yml
fi
