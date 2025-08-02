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

# Criar página de demonstração do Marketplace
echo "📦 Criando página de demonstração do Marketplace..."

# Limpar diretório se não estiver vazio
if [ "$(ls -A /var/www/html)" ]; then
    echo "🧹 Limpando diretório..."
    rm -rf /var/www/html/*
fi

# Criar página HTML de demonstração
cat > /var/www/html/index.html << 'EOF'
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Marketplace Magento - Demonstração</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; }
        .container { max-width: 1200px; margin: 0 auto; padding: 20px; }
        .header { text-align: center; color: white; margin-bottom: 40px; }
        .header h1 { font-size: 3rem; margin-bottom: 10px; text-shadow: 2px 2px 4px rgba(0,0,0,0.3); }
        .header p { font-size: 1.2rem; opacity: 0.9; }
        .features { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 30px; margin-bottom: 40px; }
        .feature { background: white; padding: 30px; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.2); transition: transform 0.3s ease; }
        .feature:hover { transform: translateY(-5px); }
        .feature h3 { color: #667eea; margin-bottom: 15px; font-size: 1.5rem; }
        .feature p { color: #666; line-height: 1.6; }
        .status { background: white; padding: 30px; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.2); margin-bottom: 30px; }
        .status h2 { color: #667eea; margin-bottom: 20px; }
        .status-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; }
        .status-item { padding: 15px; border-radius: 10px; text-align: center; }
        .status-item.online { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .status-item.offline { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .footer { text-align: center; color: white; margin-top: 40px; opacity: 0.8; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🛒 Marketplace Magento</h1>
            <p>Plataforma de e-commerce com funcionalidades customizadas</p>
        </div>
        
        <div class="status">
            <h2>📊 Status dos Serviços</h2>
            <div class="status-grid">
                <div class="status-item online">
                    <h4>🌐 Servidor Web</h4>
                    <p>Online</p>
                </div>
                <div class="status-item online">
                    <h4>🗄️ MySQL Database</h4>
                    <p>Online</p>
                </div>
                <div class="status-item online">
                    <h4>🔍 Elasticsearch</h4>
                    <p>Online</p>
                </div>
                <div class="status-item online">
                    <h4>⚡ Redis Cache</h4>
                    <p>Online</p>
                </div>
                <div class="status-item online">
                    <h4>📧 MailHog</h4>
                    <p>Online</p>
                </div>
                <div class="status-item online">
                    <h4>🛠️ phpMyAdmin</h4>
                    <p>Online</p>
                </div>
            </div>
        </div>

        <div class="features">
            <div class="feature">
                <h3>🛍️ Multi-Vendedor</h3>
                <p>Plataforma completa para múltiplos vendedores com gestão individual de produtos, estoque e vendas.</p>
            </div>
            <div class="feature">
                <h3>💳 Pagamentos Brasileiros</h3>
                <p>Integração com PIX, Boleto Bancário e Cartão de Crédito para facilitar as transações.</p>
            </div>
            <div class="feature">
                <h3>🚚 Logística Integrada</h3>
                <p>Parcerias com Correios, J&T Express e Mercado Envios para entrega eficiente.</p>
            </div>
            <div class="feature">
                <h3>🔍 Busca Avançada</h3>
                <p>Elasticsearch integrado para busca rápida e relevante de produtos.</p>
            </div>
            <div class="feature">
                <h3>📊 Analytics</h3>
                <p>Relatórios detalhados de vendas, produtos mais vendidos e performance dos vendedores.</p>
            </div>
            <div class="feature">
                <h3>📱 Responsivo</h3>
                <p>Interface adaptável para desktop, tablet e mobile com experiência otimizada.</p>
            </div>
        </div>

        <div class="status">
            <h2>🔗 Links de Acesso</h2>
            <div class="status-grid">
                <div class="status-item">
                    <h4>📧 MailHog (E-mails)</h4>
                    <p><a href="http://localhost:8025" target="_blank">http://localhost:8025</a></p>
                </div>
                <div class="status-item">
                    <h4>🗄️ phpMyAdmin</h4>
                    <p><a href="http://localhost:8081" target="_blank">http://localhost:8081</a></p>
                </div>
                <div class="status-item">
                    <h4>🔍 Elasticsearch</h4>
                    <p><a href="http://localhost:9200" target="_blank">http://localhost:9200</a></p>
                </div>
            </div>
        </div>

        <div class="footer">
            <p>© 2025 Marketplace Magento - Projeto de Demonstração</p>
            <p>Desenvolvido com Docker e Magento 2</p>
        </div>
    </div>
</body>
</html>
EOF

# Configurar permissões
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

echo "✅ Página de demonstração criada com sucesso!"

# Iniciar Apache
echo "🌐 Iniciando Apache..."
apache2-foreground 