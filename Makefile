.PHONY: build up down install install-swoole add-bundle start logs restart shell clean setup wait-for-container

CONTAINER_NAME = swoole

build:
	docker-compose build $(CONTAINER_NAME)

up:
	docker-compose up -d $(CONTAINER_NAME)

down:
	docker-compose down

wait-for-container:
	@echo "⏳ Attente que $(CONTAINER_NAME) soit prêt..."
	@until docker exec $(CONTAINER_NAME) bash -c "echo Container prêt"; do sleep 1; done
	@echo "✅ $(CONTAINER_NAME) est prêt !"

install:
	make wait-for-container
	# Avant tout install : nettoyer bundles.php et renomme swoole.yaml.dist
	docker exec -it $(CONTAINER_NAME) bash -c "if [ -f config/packages/swoole.yaml ]; then mv config/packages/swoole.yaml config/packages/swoole.yaml.dist; fi"
	docker exec -it $(CONTAINER_NAME) bash -c "if [ -f config/bundles.php ]; then sed -i '/SwooleBundle\\\\\\\\SwooleBundle\\\\\\\\Bridge\\\\\\\\Symfony\\\\\\\\Bundle\\\\\\\\SwooleBundle::class/d' config/bundles.php; fi"
	docker exec -it $(CONTAINER_NAME) composer install --optimize-autoloader --classmap-authoritative

install-swoole:

add-bundle:
	# Nettoyer toute ancienne entrée SwooleBundle
	docker exec -i $(CONTAINER_NAME) bash -c "sed -i '/SwooleBundle\\\\SwooleBundle\\\\Bridge\\\\Symfony\\\\Bundle\\\\SwooleBundle::class/d' config/bundles.php"

	# Ajouter proprement la nouvelle ligne après le 'return [' de bundles.php (avec bons antislashs)
	docker exec -i $(CONTAINER_NAME) bash -c "awk '/return \[/ { print; print \"    SwooleBundle\\\\SwooleBundle\\\\Bridge\\\\Symfony\\\\Bundle\\\\SwooleBundle::class => ['\\''all'\\'' => true],\"; next }1' config/bundles.php > /tmp/bundles.php && mv /tmp/bundles.php config/bundles.php"

	# Restaure la config après les modifs
	docker exec -it $(CONTAINER_NAME) bash -c "if [ -f config/packages/swoole.yaml.dist ]; then mv config/packages/swoole.yaml.dist config/packages/swoole.yaml; fi"

	# Régénérer l'autoload de composer
	docker exec -i $(CONTAINER_NAME) composer dump-autoload

	# Nettoyer et reconstruire le cache
	docker exec -i $(CONTAINER_NAME) bin/console cache:clear


start:
	docker exec -it $(CONTAINER_NAME) php bin/console swoole:server:run

logs:
	docker-compose logs -f $(CONTAINER_NAME)

restart:
	docker-compose restart $(CONTAINER_NAME)

shell:
	docker exec -it $(CONTAINER_NAME) bash

clean:
	docker-compose down -v --remove-orphans
	rm -rf ./symfony_swoole/vendor ./symfony_swoole/var

setup: build up wait-for-container install install-swoole add-bundle restart
	@echo "✅ Symfony avec Swoole est prêt !"
