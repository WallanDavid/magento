#!/usr/bin/env python3
"""
Script para gerar screenshots automáticos do Marketplace Magento 2
"""

import os
import time
import json
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.options import Options

class MarketplaceScreenshotGenerator:
    def __init__(self):
        self.base_url = "http://localhost:8080"
        self.screenshots_dir = "../docs/screenshots"
        self.driver = None
        
        # Criar diretório de screenshots se não existir
        os.makedirs(self.screenshots_dir, exist_ok=True)
        
    def setup_driver(self):
        """Configurar o driver do Chrome"""
        chrome_options = Options()
        chrome_options.add_argument("--headless")  # Executar em background
        chrome_options.add_argument("--no-sandbox")
        chrome_options.add_argument("--disable-dev-shm-usage")
        chrome_options.add_argument("--window-size=1920,1080")
        
        self.driver = webdriver.Chrome(options=chrome_options)
        self.driver.implicitly_wait(10)
        
    def take_screenshot(self, filename, description=""):
        """Tirar screenshot e salvar"""
        try:
            time.sleep(2)  # Aguardar carregamento
            self.driver.save_screenshot(f"{self.screenshots_dir}/{filename}")
            print(f"✅ Screenshot salvo: {filename} - {description}")
        except Exception as e:
            print(f"❌ Erro ao salvar screenshot {filename}: {e}")
    
    def generate_homepage_screenshot(self):
        """Gerar screenshot da homepage"""
        print("📸 Gerando screenshot da Homepage...")
        self.driver.get(f"{self.base_url}")
        self.take_screenshot("01-homepage.png", "Homepage do Marketplace")
    
    def generate_category_screenshot(self):
        """Gerar screenshot de categoria"""
        print("📸 Gerando screenshot de Categoria...")
        self.driver.get(f"{self.base_url}/tecnologia")
        self.take_screenshot("02-categoria-tecnologia.png", "Página de categoria Tecnologia")
    
    def generate_product_screenshot(self):
        """Gerar screenshot de produto"""
        print("📸 Gerando screenshot de Produto...")
        self.driver.get(f"{self.base_url}/smartphone-galaxy-s23")
        self.take_screenshot("03-produto-galaxy-s23.png", "Página do produto Galaxy S23")
    
    def generate_cart_screenshot(self):
        """Gerar screenshot do carrinho"""
        print("📸 Gerando screenshot do Carrinho...")
        self.driver.get(f"{self.base_url}/checkout/cart")
        self.take_screenshot("04-carrinho.png", "Carrinho de compras")
    
    def generate_checkout_screenshot(self):
        """Gerar screenshot do checkout"""
        print("📸 Gerando screenshot do Checkout...")
        self.driver.get(f"{self.base_url}/checkout")
        self.take_screenshot("05-checkout.png", "Página de checkout")
    
    def generate_admin_screenshot(self):
        """Gerar screenshot do painel admin"""
        print("📸 Gerando screenshot do Painel Admin...")
        self.driver.get(f"{self.base_url}/admin")
        
        # Fazer login
        username_field = self.driver.find_element(By.ID, "username")
        password_field = self.driver.find_element(By.ID, "login")
        
        username_field.send_keys("admin")
        password_field.send_keys("admin123")
        
        login_button = self.driver.find_element(By.CLASS_NAME, "action-login")
        login_button.click()
        
        time.sleep(3)
        self.take_screenshot("06-painel-admin.png", "Painel administrativo")
    
    def generate_vendor_screenshot(self):
        """Gerar screenshot do painel do vendedor"""
        print("📸 Gerando screenshot do Painel do Vendedor...")
        self.driver.get(f"{self.base_url}/vendor")
        
        # Fazer login do vendedor
        username_field = self.driver.find_element(By.ID, "username")
        password_field = self.driver.find_element(By.ID, "login")
        
        username_field.send_keys("vendor1")
        password_field.send_keys("vendor123")
        
        login_button = self.driver.find_element(By.CLASS_NAME, "action-login")
        login_button.click()
        
        time.sleep(3)
        self.take_screenshot("07-painel-vendedor.png", "Painel do vendedor")
    
    def generate_search_screenshot(self):
        """Gerar screenshot da busca"""
        print("📸 Gerando screenshot da Busca...")
        self.driver.get(f"{self.base_url}")
        
        # Realizar busca
        search_field = self.driver.find_element(By.ID, "search")
        search_field.send_keys("smartphone")
        
        search_button = self.driver.find_element(By.CLASS_NAME, "action.search")
        search_button.click()
        
        time.sleep(2)
        self.take_screenshot("08-resultado-busca.png", "Resultado da busca por smartphone")
    
    def generate_payment_methods_screenshot(self):
        """Gerar screenshot dos métodos de pagamento"""
        print("📸 Gerando screenshot dos Métodos de Pagamento...")
        self.driver.get(f"{self.base_url}/checkout")
        
        # Aguardar carregamento dos métodos de pagamento
        time.sleep(3)
        self.take_screenshot("09-metodos-pagamento.png", "Métodos de pagamento brasileiros")
    
    def generate_shipping_methods_screenshot(self):
        """Gerar screenshot dos métodos de envio"""
        print("📸 Gerando screenshot dos Métodos de Envio...")
        self.driver.get(f"{self.base_url}/checkout")
        
        # Aguardar carregamento dos métodos de envio
        time.sleep(3)
        self.take_screenshot("10-metodos-envio.png", "Métodos de envio brasileiros")
    
    def generate_all_screenshots(self):
        """Gerar todos os screenshots"""
        print("🚀 Iniciando geração de screenshots do Marketplace...")
        
        try:
            self.setup_driver()
            
            # Screenshots do frontend
            self.generate_homepage_screenshot()
            self.generate_category_screenshot()
            self.generate_product_screenshot()
            self.generate_search_screenshot()
            self.generate_cart_screenshot()
            self.generate_checkout_screenshot()
            self.generate_payment_methods_screenshot()
            self.generate_shipping_methods_screenshot()
            
            # Screenshots dos painéis
            self.generate_admin_screenshot()
            self.generate_vendor_screenshot()
            
            print("✅ Todos os screenshots foram gerados com sucesso!")
            
        except Exception as e:
            print(f"❌ Erro durante a geração de screenshots: {e}")
        
        finally:
            if self.driver:
                self.driver.quit()
    
    def create_screenshot_index(self):
        """Criar arquivo de índice dos screenshots"""
        screenshots = [
            {
                "filename": "01-homepage.png",
                "title": "Homepage do Marketplace",
                "description": "Página inicial com banners, produtos em destaque e navegação"
            },
            {
                "filename": "02-categoria-tecnologia.png",
                "title": "Categoria Tecnologia",
                "description": "Listagem de produtos da categoria tecnologia"
            },
            {
                "filename": "03-produto-galaxy-s23.png",
                "title": "Página do Produto",
                "description": "Detalhes do produto com informações do vendedor"
            },
            {
                "filename": "04-carrinho.png",
                "title": "Carrinho de Compras",
                "description": "Carrinho com produtos de múltiplos vendedores"
            },
            {
                "filename": "05-checkout.png",
                "title": "Checkout",
                "description": "Processo de finalização de compra"
            },
            {
                "filename": "06-painel-admin.png",
                "title": "Painel Administrativo",
                "description": "Interface de administração do marketplace"
            },
            {
                "filename": "07-painel-vendedor.png",
                "title": "Painel do Vendedor",
                "description": "Dashboard personalizado para vendedores"
            },
            {
                "filename": "08-resultado-busca.png",
                "title": "Resultado da Busca",
                "description": "Resultados de busca com filtros"
            },
            {
                "filename": "09-metodos-pagamento.png",
                "title": "Métodos de Pagamento",
                "description": "Integração com meios de pagamento brasileiros"
            },
            {
                "filename": "10-metodos-envio.png",
                "title": "Métodos de Envio",
                "description": "Opções de frete com transportadoras brasileiras"
            }
        ]
        
        with open(f"{self.screenshots_dir}/index.json", "w", encoding="utf-8") as f:
            json.dump(screenshots, f, indent=2, ensure_ascii=False)
        
        print("✅ Índice de screenshots criado!")

if __name__ == "__main__":
    generator = MarketplaceScreenshotGenerator()
    generator.generate_all_screenshots()
    generator.create_screenshot_index() 