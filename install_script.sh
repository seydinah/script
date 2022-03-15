#!/bin/bash
# -*- ENCODING: UTF-8 -*-

#Mise à jour et installation outils essentiels
sudo apt update
sudo apt install git gdebi wget build-essential

#Installer et configurer git
git config --global user.name "Your full name"
git config --global user.email "xyz@ibel.app"

#Recuperer les sources
cd -
git clone https://github.com/Ibel-technology/ibel.git -b 14.0 --single-branch --depth 1
git clone https://github.com/Ibel-technology/ibel_addons.git -b 14.0 --single-branch --depth 1

#Installer les dépendances
sudo apt install gdebi
cd /tmp/
sudo wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.focal_amd64.deb
sudo gdebi --n wkhtmltox_0.12.5-1.focal_amd64.deb
sudo ln -s /usr/local/bin/wkhtmltopdf /usr/bin
sudo ln -s /usr/local/bin/wkhtmltoimage /usr/bin

#Prise en charge de l'interface de gauche à droite
sudo apt-get install nodejs npm
sudo npm install -g rtlcss

#Installer Postgresql
sudo apt install postgresql postgresql-client

#Créer un nouvel utilisateur PostgreSQL 
sudo -u postgres createuser -s $USER
createdb $USER

#Installer pip3 et les bibliothèques
sudo apt install python3-pip python3-dev python3-venv libxml2-dev libxslt1-dev libldap2-dev libsasl2-dev libssl-dev libpq-dev libjpeg-dev

#Créer des environnements virtuels Python
python3 -m venv ibel-env 

#Activer l'environnement virtuel
source ibel-env/bin/activate
 
#Installer les exigences Ibel dans l'environnement virtuel
pip3 install setuptools wheel
pip3 install -r ibel/requirements.txt

#Générer un fichier de configuration pour votre instance Ibel, exécutez la commande suivante
python3 ibel/odoo-bin --config ibel.conf --addons-path ibel/addons,ibel_addons --save --stop-after-init

#Démarrer le serveur avec les options enregistrée
python3 ibel/odoo-bin --config ibel.conf --database mydb
