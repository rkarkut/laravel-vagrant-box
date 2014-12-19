#!/usr/bin/env bash


function createDatabase() {
    echo "==> Creating database file..."

     sh -c "echo 'CREATE DATABASE IF NOT EXISTS $1' > puppets/modules/mysql/files/create_database.sql"
}

function createHosts() {
    echo "==> Create hosts file..."

    sh -c "echo '<VirtualHost *:80>
    ServerAdmin webmaster@localhost.com
    ServerName $1
    DocumentRoot  \"/var/www/project/public\"
    <Directory \"/var/www/project/public\">
        Options Indexes FollowSymLinks
        
    </Directory>

    SetEnv MY_LARAVEL_ENV local
    
</VirtualHost>' > puppets/modules/apache/files/hosts"
}

function createLocalHost() {
    sh -c "echo '$1 $2' >> /etc/hosts"
}


function getLaravelProject() {
    echo "==> composer global require laravel/installer=~1.1"

    rm -rf project

    composer global require "laravel/installer=~1.1"

    composer create-project laravel/laravel project --prefer-dist

    chmod -R 777 project

}

echo "==> Updating dependencies..."
source config.cfg

createDatabase $db_name
createHosts $host
createLocalHost $ip $host
getLaravelProject

vagrant up || exit 1
