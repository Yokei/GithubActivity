#/bin/bash

function killitif {
    docker ps -a  > /tmp/yy_xx$$
    if grep --quiet $1 /tmp/yy_xx$$
     then
     echo "killing older version of $1"
     docker rm -f `docker ps -a | grep $1  | sed -e 's: .*$::'`
   fi
}



docker ps -a  > /tmp/swp$$

if grep --quiet "web1" /tmp/swp$$
 then
 docker run --network="ecs189_default" --name web2 -d $1
 docker exec ecs189_proxy_1 /bin/bash /bin/swap2.sh
 killitif web1
fi


if grep --quiet "web2" /tmp/swp$$
 then
 docker run --network="ecs189_default" --name web1 -d $1
 docker exec ecs189_proxy_1 /bin/bash /bin/swap1.sh
 killitif web2
fi
