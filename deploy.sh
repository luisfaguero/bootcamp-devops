!/bin/bash
#Variable

REPO="bootcamp-devops"



apt-get update 
echo "El servidor esta actualizado"

apt install -y git
echo -e "\n\033[33mGit se ha instalado\033[0m\n"

if dpkg -s mariadb-server > /dev/null 2>&1 ;
then
    echo -e "\n${LBLUE}El Servidor se encuentra Actualizado ...${NC}"
else 
    echo -e "\n${LYELLOW}instalando MARIA DB ...${NC}"
    sudo apt install -y mariadb-server


    sudo systemctl start mariadb
    sudo systemctl enable mariadb

 
    mysql -e "
    CREATE DATABASE devopstravel;
    CREATE USER 'codeuser'@'localhost' IDENTIFIED BY 'codepass';
    GRANT ALL PRIVILEGES ON *.* TO 'codeuser'@'localhost';
    FLUSH PRIVILEGES;"
fi
echo ""
echo " Ingrese contraseña de bases de datos"
        sleep 3
        nano /var/www/html/config.php
        systemctl reload apache2




if dpkg -l | grep -q apache2 ;
then
    echo -e "\n\e[96mApache esta realmente instalado \033[0m\n"
else    
    echo -e "\n\e[92mInstalando Apache2 ...\033[0m\n"
     apt install -y git apache2
     apt install -y php libapache2-mod-php php-mysql php-mbstring php-zip php-gd php-json php-curl
     systemctl start apache2
     systemctl enable apache2
     mv /var/www/html/index.html /var/www/html/index.html.bkp


fi
    
    
if [ -d "$REPO" ] ; 
then 
        echo "la carpeta $REPO Existe"
        cd ${REPO}



else
        git clone  https://github.com/luisfaguero/bootcamp-devops.git 

  

fi
echo "instalando web"
sleep 1
cd ..
cp -r $REPO/app-295devops-travel/* /var/www/html

mysql < $REPO/app-295devops-travel/database/devopstravel.sql


systemctl reload apache2

 

 DISCORD="https://discord.com/api/webhooks/1154865920741752872/au1jkQ7v9LgQJ131qFnFqP-WWehD40poZJXRGEYUDErXHLQJ_BBszUFtVj8g3pu9bm7h"
# Configura el token de acceso de tu bot de Discord

# Verifica si se proporcionó el argumento del directorio del repositorio
#if [ $# -ne 1 ]; then
# echo "Uso: $0 $REPO"
#  exit 1
#fi

# Cambia al directorio del repositorio
#cd "$1"

# Obtiene el nombre del repositorio
REPO_NAME=$(basename $(git rev-parse --show-toplevel))
# Obtiene la URL remota del repositorio
REPO_URL=$(git remote get-url origin)
WEB_URL="localhost"
# Realiza una solicitud HTTP GET a la URL
HTTP_STATUS=$(curl -Is "$WEB_URL" | head -n 1)

# Verifica si la respuesta es 200 OK (puedes ajustar esto según tus necesidades)
if [[ "$HTTP_STATUS" == *"200 OK"* ]]; then
  # Obtén información del repositorio
    DEPLOYMENT_INFO2="Despliegue del repositorio $REPO_NAME: "
    DEPLOYMENT_INFO="La página web $WEB_URL está en línea."
    COMMIT="Commit: $(git rev-parse --short HEAD)"
    AUTHOR="Autor: $(git log -1 --pretty=format:'%an')"
    DESCRIPTION="Descripción: $(git log -1 --pretty=format:'%s')"

else
  DEPLOYMENT_INFO="La página web $WEB_URL no está en línea."
fi

# Obtén información del repositorio


# Construye el mensaje
MESSAGE="$DEPLOYMENT_INFO2\n$DEPLOYMENT_INFO\n$COMMIT\n$AUTHOR\n$REPO_URL\n$DESCRIPTION"

# Envía el mensaje a Discord utilizando la API de Discord
curl -X POST -H "Content-Type: application/json" \
     -d '{
       "content": "'"${MESSAGE}"'"
     }' "$DISCORD"

