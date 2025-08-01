#!/bin/bash

echo "🚀 Iniciando Marketplace Magento 2..."

# Aguardar banco de dados estar pronto
echo "⏳ Aguardando banco de dados..."
while ! mysqladmin ping -h"$MAGENTO_DB_HOST" --silent; do
    sleep 1
done

# Aguardar Elasticsearch estar pronto
echo "⏳ Aguardando Elasticsearch..."
while ! curl -s http://elasticsearch:9200 > /dev/null; do
    sleep 1
done

# Verificar se o Magento já está instalado
if [ ! -f "/var/www/html/app/etc/env.php" ]; then
    echo "📦 Instalando Magento 2..."
    
    # Baixar Magento via Composer
    composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition . 2.4.6
    
    # Configurar permissões
    chown -R www-data:www-data /var/www/html
    chmod -R 755 /var/www/html
    chmod -R 777 var/
    chmod -R 777 pub/static/
    chmod -R 777 pub/media/
    chmod -R 777 generated/
    
    # Instalar Magento
    php bin/magento setup:install \
        --base-url="$MAGENTO_BASE_URL/" \
        --db-host="$MAGENTO_DB_HOST" \
        --db-name="$MAGENTO_DB_NAME" \
        --db-user="$MAGENTO_DB_USER" \
        --db-password="$MAGENTO_DB_PASSWORD" \
        --admin-firstname="$MAGENTO_ADMIN_FIRSTNAME" \
        --admin-lastname="$MAGENTO_ADMIN_LASTNAME" \
        --admin-email="$MAGENTO_ADMIN_EMAIL" \
        --admin-user="$MAGENTO_ADMIN_USER" \
        --admin-password="$MAGENTO_ADMIN_PASSWORD" \
        --language=pt_BR \
        --currency=BRL \
        --timezone=America/Sao_Paulo \
        --use-rewrites=1 \
        --search-engine=elasticsearch7 \
        --elasticsearch-host=elasticsearch \
        --elasticsearch-port=9200
    
    # Configurar modo de desenvolvimento
    php bin/magento deploy:mode:set developer
    
    # Limpar cache
    php bin/magento cache:clean
    php bin/magento cache:flush
    
    # Configurar meios de pagamento brasileiros
    php bin/magento config:set payment/pix/active 1
    php bin/magento config:set payment/boleto/active 1
    php bin/magento config:set payment/creditcard/active 1
    
    # Configurar transportadoras
    php bin/magento config:set carriers/correios/active 1
    php bin/magento config:set carriers/jtexpress/active 1
    php bin/magento config:set carriers/mercadoenvios/active 1
    
    echo "✅ Magento 2 instalado com sucesso!"
else
    echo "✅ Magento 2 já está instalado"
fi

# Iniciar Apache
echo "🌐 Iniciando Apache..."
apache2-foreground 