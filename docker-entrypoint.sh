#!/bin/bash

cd /var/www/html/my-project
#exec tail -f /dev/null


# Vérifier que le projet Symfony est en place
if [ ! -f "bin/console" ]; then
  echo "📦 Aucun bin/console trouvé. Symfony n'est pas encore installé."
  tail -f /dev/null
fi

# Vérifier que les vendors existent
if [ ! -d "vendor" ]; then
  echo "📦 Le dossier vendor/ est manquant. Exécutez 'composer install'."
  tail -f /dev/null
fi

# Vérifier que swoole-bundle est installé
if [ ! -d "vendor/swoole-bundle" ]; then
  echo "🛠 Le bundle swoole-bundle est manquant. Exécutez 'make install-swoole' et 'make add-bundle'."
  tail -f /dev/null
fi

echo "🚀 Démarrage du serveur Swoole..."
php bin/console swoole:server:run
