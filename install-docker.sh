#!/bin/bash

echo "🚀 Instalando Marketplace Magento 2 com Docker"
echo "=============================================="

# Verificar se o Docker está instalado
if ! command -v docker &> /dev/null; then
    echo "❌ Docker não encontrado. Instale o Docker primeiro."
    exit 1
fi

# Verificar se o Docker Compose está instalado
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose não encontrado. Instale o Docker Compose primeiro."
    exit 1
fi

echo "✅ Docker e Docker Compose encontrados"

# Criar estrutura de diretórios
echo "📁 Criando estrutura de diretórios..."
mkdir -p magento2
mkdir -p docs/screenshots
mkdir -p docs/demo-data
mkdir -p scripts
mkdir -p themes/custom/brazilian_marketplace
mkdir -p modules/custom

# Construir e iniciar containers
echo "🐳 Construindo e iniciando containers..."
docker-compose up -d --build

# Aguardar containers estarem prontos
echo "⏳ Aguardando containers estarem prontos..."
sleep 30

# Verificar status dos containers
echo "📊 Status dos containers:"
docker-compose ps

# Gerar screenshots automáticos
echo "📸 Gerando screenshots automáticos..."
cd scripts
pip3 install -r requirements.txt
python3 generate_screenshots.py
cd ..

# Gerar vídeo de demonstração
echo "🎬 Gerando vídeo de demonstração..."
cd scripts
python3 generate_demo_video.py
cd ..

echo ""
echo "🎉 Marketplace Magento 2 instalado com sucesso!"
echo ""
echo "🌐 URLs de acesso:"
echo "   Frontend: http://localhost:8080"
echo "   Admin: http://localhost:8080/admin"
echo "   Vendedor: http://localhost:8080/vendor"
echo "   phpMyAdmin: http://localhost:8081"
echo "   MailHog: http://localhost:8025"
echo ""
echo "🔑 Credenciais:"
echo "   Admin: admin / admin123"
echo "   Vendedores: vendor1, vendor2, vendor3 / vendor123"
echo ""
echo "📸 Screenshots disponíveis em: docs/screenshots/"
echo "🎥 Vídeo demo disponível em: docs/demo-video.mp4"
echo ""
echo "📋 Comandos úteis:"
echo "   Parar containers: docker-compose down"
echo "   Ver logs: docker-compose logs -f"
echo "   Reiniciar: docker-compose restart" 