# Marketplace Magento 2 - Demo Brasileiro

## 🚀 Sobre o Projeto

Este é um ambiente de demonstração de um marketplace Magento 2 customizado para o mercado brasileiro, desenvolvido para apresentação a clientes potenciais.

### ✨ Funcionalidades Implementadas

- **Multi-vendedores**: Sistema completo de marketplace com múltiplas lojas
- **Integração Brasileira**: Pagamentos nacionais (Pix, Boleto, Cartões)
- **Transportadoras**: Correios, J&T Express, Mercado Envios
- **Funcionalidades Customizadas**:
  - Split de pedidos por vendedor
  - SAC via WhatsApp
  - E-mail transacional personalizado
  - Etiquetas promocionais (Frete Grátis, Promoção, etc.)
  - Dashboard personalizado para vendedores

### 🛠️ Tecnologias Utilizadas

- **Magento 2.4.6** (Community Edition)
- **PHP 8.1+**
- **MySQL 8.0**
- **Composer**
- **Docker** (opcional)

## 📋 Pré-requisitos

- PHP 8.1 ou superior
- MySQL 8.0 ou superior
- Composer
- Node.js 16+ (para assets)
- Git

## 🚀 Instalação Rápida

### 1. Clone o repositório
```bash
git clone <seu-repositorio>
cd magento-marketplace-demo
```

### 2. Execute o script de instalação
```bash
./install.sh
```

### 3. Acesse o marketplace
- **Frontend**: http://localhost:8080
- **Admin**: http://localhost:8080/admin
- **Vendedor**: http://localhost:8080/vendor

### 4. Credenciais de Acesso

#### Admin Principal
- **URL**: http://localhost:8080/admin
- **Usuário**: admin
- **Senha**: admin123

#### Vendedores Demo
- **Loja TechGadgets**: vendor1 / vendor123
- **Loja ModaBrasil**: vendor2 / vendor123
- **Loja CasaDecor**: vendor3 / vendor123

## 📱 Funcionalidades Demonstradas

### Frontend (Cliente)
- [x] Homepage com banners e produtos em destaque
- [x] Busca e filtros avançados
- [x] Páginas de produto com informações do vendedor
- [x] Carrinho com produtos de múltiplos vendedores
- [x] Checkout com split automático de pedidos
- [x] Integração com meios de pagamento brasileiros

### Painel do Vendedor
- [x] Dashboard com métricas de vendas
- [x] Gestão de produtos e estoque
- [x] Processamento de pedidos
- [x] Relatórios de vendas
- [x] Configurações de frete

### Painel Administrativo
- [x] Gestão de vendedores
- [x] Configurações de marketplace
- [x] Relatórios consolidados
- [x] Gestão de comissões

## 🎯 Diferenciais Customizados

### Integrações Brasileiras
- **Pagamentos**: Pix, Boleto, Cartões (Visa, Mastercard, Elo)
- **Transportadoras**: Correios, J&T Express, Mercado Envios
- **Localização**: CEPs brasileiros, endereços nacionais
- **Moeda**: Real Brasileiro (R$)

### Funcionalidades Especiais
- **Split de Pedidos**: Separação automática por vendedor
- **SAC WhatsApp**: Integração direta com WhatsApp Business
- **E-mail Transacional**: Templates personalizados em português
- **Etiquetas Promocionais**: Frete Grátis, Promoção, Lançamento
- **Dashboard Vendedor**: Interface intuitiva para gestão

## 📸 Screenshots e Demo

Consulte a pasta `docs/screenshots/` para visualizar todas as telas do marketplace.

## 🎥 Vídeo de Demonstração

O vídeo de demonstração está disponível em `docs/demo-video.mp4`

## 📞 Suporte

Para dúvidas sobre a implementação ou personalização para seu projeto:

- **Email**: contato@seudominio.com
- **WhatsApp**: (11) 99999-9999

---

**Nota**: Este é um ambiente de demonstração. Para implementação em produção, todos os recursos podem ser personalizados conforme as necessidades específicas do cliente. 