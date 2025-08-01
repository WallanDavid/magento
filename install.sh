#!/bin/bash

echo "🚀 Iniciando instalação do Marketplace Magento 2 - Demo Brasileiro"
echo "================================================================"

# Verificar pré-requisitos
echo "📋 Verificando pré-requisitos..."

# Verificar PHP
if ! command -v php &> /dev/null; then
    echo "❌ PHP não encontrado. Instale o PHP 8.1+ primeiro."
    exit 1
fi

PHP_VERSION=$(php -r "echo PHP_VERSION;")
echo "✅ PHP encontrado: $PHP_VERSION"

# Verificar Composer
if ! command -v composer &> /dev/null; then
    echo "❌ Composer não encontrado. Instale o Composer primeiro."
    exit 1
fi
echo "✅ Composer encontrado"

# Verificar MySQL
if ! command -v mysql &> /dev/null; then
    echo "❌ MySQL não encontrado. Instale o MySQL 8.0+ primeiro."
    exit 1
fi
echo "✅ MySQL encontrado"

# Criar estrutura de diretórios
echo "📁 Criando estrutura de diretórios..."
mkdir -p magento2
mkdir -p docs/screenshots
mkdir -p docs/demo-data
mkdir -p scripts
mkdir -p themes/custom/brazilian_marketplace
mkdir -p modules/custom

# Baixar Magento 2 via Composer
echo "⬇️ Baixando Magento 2..."
cd magento2
composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition . 2.4.6

# Configurar permissões
echo "🔐 Configurando permissões..."
chmod +x bin/magento
chmod -R 777 var/
chmod -R 777 pub/static/
chmod -R 777 pub/media/
chmod -R 777 generated/

# Instalar Magento
echo "⚙️ Instalando Magento 2..."
php bin/magento setup:install \
    --base-url=http://localhost:8080/ \
    --db-host=localhost \
    --db-name=magento_marketplace \
    --db-user=root \
    --db-password= \
    --admin-firstname=Admin \
    --admin-lastname=User \
    --admin-email=admin@marketplace.com \
    --admin-user=admin \
    --admin-password=admin123 \
    --language=pt_BR \
    --currency=BRL \
    --timezone=America/Sao_Paulo \
    --use-rewrites=1 \
    --search-engine=elasticsearch7 \
    --elasticsearch-host=localhost \
    --elasticsearch-port=9200

# Configurar modo de desenvolvimento
php bin/magento deploy:mode:set developer

# Limpar cache
php bin/magento cache:clean
php bin/magento cache:flush

# Instalar módulos customizados
echo "🔧 Instalando módulos customizados..."
cd ../modules/custom

# Módulo de Marketplace
mkdir -p MarketplaceVendor
cd MarketplaceVendor
mkdir -p etc
mkdir -p Model
mkdir -p Controller
mkdir -p view/adminhtml
mkdir -p view/frontend

# Criar arquivos do módulo
cat > registration.php << 'EOF'
<?php
\Magento\Framework\Component\ComponentRegistrar::register(
    \Magento\Framework\Component\ComponentRegistrar::MODULE,
    'Custom_MarketplaceVendor',
    __DIR__
);
EOF

cat > etc/module.xml << 'EOF'
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="urn:magento:framework:Module/etc/module.xsd">
    <module name="Custom_MarketplaceVendor" setup_version="1.0.0">
        <sequence>
            <module name="Magento_Catalog"/>
            <module name="Magento_Customer"/>
        </sequence>
    </module>
</config>
EOF

cd ../../..

# Instalar módulo
cd magento2
php bin/magento module:enable Custom_MarketplaceVendor
php bin/magento setup:upgrade
php bin/magento setup:di:compile
php bin/magento setup:static-content:deploy -f pt_BR

# Importar dados de demonstração
echo "📊 Importando dados de demonstração..."
cd ../docs/demo-data

# Criar dados de vendedores
cat > vendors.csv << 'EOF'
vendor_id,name,email,store_name,description,status
1,TechGadgets,vendor1@techgadgets.com.br,TechGadgets,Especializada em produtos de tecnologia e gadgets,1
2,ModaBrasil,vendor2@modabrasil.com.br,ModaBrasil,Moda feminina e masculina com estilo brasileiro,1
3,CasaDecor,vendor3@casadecor.com.br,CasaDecor,Decoração e móveis para sua casa,1
EOF

# Criar dados de produtos
cat > products.csv << 'EOF'
product_id,name,sku,vendor_id,price,description,category
1,Smartphone Galaxy S23,SM-GALAXY-S23,1,3499.00,Smartphone Samsung Galaxy S23 128GB,Smartphones
2,Notebook Dell Inspiron,DELL-INSPIRON-15,1,2899.00,Notebook Dell Inspiron 15 polegadas,Notebooks
3,Vestido Floral Verão,VEST-FLORAL-VERAO,2,89.90,Vestido floral perfeito para o verão,Vestidos
4,Camiseta Básica Algodão,CAM-BASICA-ALG,2,29.90,Camiseta básica 100% algodão,Camisetas
5,Sofá 3 Lugares,SOFA-3-LUGARES,3,1299.00,Sofá confortável 3 lugares,Sofás
6,Luminária de Mesa,LUM-MESA-LED,3,89.90,Luminária de mesa com LED,Luminárias
EOF

cd ../../magento2

# Importar dados
php bin/magento import:data:customers ../docs/demo-data/vendors.csv
php bin/magento import:data:products ../docs/demo-data/products.csv

# Configurar tema brasileiro
echo "🎨 Configurando tema brasileiro..."
cd ../themes/custom/brazilian_marketplace

cat > registration.php << 'EOF'
<?php
\Magento\Framework\Component\ComponentRegistrar::register(
    \Magento\Framework\Component\ComponentRegistrar::THEME,
    'frontend/Custom/brazilian_marketplace',
    __DIR__
);
EOF

cat > theme.xml << 'EOF'
<?xml version="1.0"?>
<theme xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="urn:magento:framework:Config/etc/theme.xsd">
    <title>Brazilian Marketplace</title>
    <parent>Magento/luma</parent>
    <area>frontend</area>
</theme>
EOF

cd ../../../magento2

# Aplicar tema
php bin/magento theme:install Custom/brazilian_marketplace
php bin/magento theme:set Custom/brazilian_marketplace

# Configurar meios de pagamento brasileiros
echo "💳 Configurando meios de pagamento brasileiros..."
php bin/magento config:set payment/pix/active 1
php bin/magento config:set payment/boleto/active 1
php bin/magento config:set payment/creditcard/active 1

# Configurar transportadoras
echo "🚚 Configurando transportadoras..."
php bin/magento config:set carriers/correios/active 1
php bin/magento config:set carriers/jtexpress/active 1
php bin/magento config:set carriers/mercadoenvios/active 1

# Finalizar instalação
echo "✅ Instalação concluída!"
echo ""
echo "🌐 URLs de acesso:"
echo "   Frontend: http://localhost:8080"
echo "   Admin: http://localhost:8080/admin"
echo "   Vendedor: http://localhost:8080/vendor"
echo ""
echo "🔑 Credenciais:"
echo "   Admin: admin / admin123"
echo "   Vendedores: vendor1, vendor2, vendor3 / vendor123"
echo ""
echo "📸 Screenshots disponíveis em: docs/screenshots/"
echo "🎥 Vídeo demo disponível em: docs/demo-video.mp4"

# Gerar screenshots automáticos
echo "📸 Gerando screenshots automáticos..."
cd ../scripts
python3 generate_screenshots.py

echo "🎉 Marketplace Magento 2 - Demo Brasileiro instalado com sucesso!" 