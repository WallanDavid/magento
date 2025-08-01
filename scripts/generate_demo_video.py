#!/usr/bin/env python3
"""
Script para gerar vídeo de demonstração do Marketplace Magento 2
"""

import os
import time
import json
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.action_chains import ActionChains
import cv2
import numpy as np
from PIL import Image, ImageDraw, ImageFont

class MarketplaceVideoGenerator:
    def __init__(self):
        self.base_url = "http://localhost:8080"
        self.video_dir = "../docs"
        self.screenshots_dir = "../docs/screenshots"
        self.driver = None
        
        # Criar diretórios se não existirem
        os.makedirs(self.video_dir, exist_ok=True)
        os.makedirs(self.screenshots_dir, exist_ok=True)
        
    def setup_driver(self):
        """Configurar o driver do Chrome"""
        chrome_options = Options()
        chrome_options.add_argument("--headless")
        chrome_options.add_argument("--no-sandbox")
        chrome_options.add_argument("--disable-dev-shm-usage")
        chrome_options.add_argument("--window-size=1920,1080")
        
        self.driver = webdriver.Chrome(options=chrome_options)
        self.driver.implicitly_wait(10)
        
    def capture_screenshot(self, filename):
        """Capturar screenshot"""
        try:
            time.sleep(2)
            self.driver.save_screenshot(f"{self.screenshots_dir}/{filename}")
            return f"{self.screenshots_dir}/{filename}"
        except Exception as e:
            print(f"❌ Erro ao capturar screenshot {filename}: {e}")
            return None
    
    def add_text_overlay(self, image_path, text, position=(50, 50), font_size=40):
        """Adicionar texto sobre a imagem"""
        try:
            img = Image.open(image_path)
            draw = ImageDraw.Draw(img)
            
            # Tentar usar fonte personalizada, senão usar padrão
            try:
                font = ImageFont.truetype("arial.ttf", font_size)
            except:
                font = ImageFont.load_default()
            
            # Adicionar fundo semi-transparente para o texto
            bbox = draw.textbbox(position, text, font=font)
            draw.rectangle(bbox, fill=(0, 0, 0, 128))
            
            # Adicionar texto
            draw.text(position, text, fill=(255, 255, 255), font=font)
            img.save(image_path)
            
        except Exception as e:
            print(f"❌ Erro ao adicionar texto: {e}")
    
    def create_video_from_screenshots(self, screenshots, output_path, duration_per_screenshot=3):
        """Criar vídeo a partir dos screenshots"""
        try:
            # Ler primeiro screenshot para obter dimensões
            first_img = cv2.imread(screenshots[0])
            height, width, layers = first_img.shape
            
            # Configurar codec de vídeo
            fourcc = cv2.VideoWriter_fourcc(*'mp4v')
            out = cv2.VideoWriter(output_path, fourcc, 1, (width, height))
            
            # Adicionar cada screenshot ao vídeo
            for screenshot in screenshots:
                if os.path.exists(screenshot):
                    img = cv2.imread(screenshot)
                    # Adicionar frame por 3 segundos (3 frames por segundo)
                    for _ in range(duration_per_screenshot * 3):
                        out.write(img)
            
            out.release()
            print(f"✅ Vídeo criado: {output_path}")
            
        except Exception as e:
            print(f"❌ Erro ao criar vídeo: {e}")
    
    def generate_demo_flow(self):
        """Gerar fluxo de demonstração completo"""
        print("🎬 Iniciando geração do vídeo de demonstração...")
        
        screenshots = []
        
        try:
            self.setup_driver()
            
            # 1. Homepage
            print("📸 Capturando Homepage...")
            self.driver.get(f"{self.base_url}")
            screenshot_path = self.capture_screenshot("video_01_homepage.png")
            if screenshot_path:
                self.add_text_overlay(screenshot_path, "🏠 Homepage do Marketplace", (50, 50))
                screenshots.append(screenshot_path)
            
            # 2. Busca de produto
            print("📸 Capturando Busca...")
            search_field = self.driver.find_element(By.ID, "search")
            search_field.send_keys("smartphone")
            search_button = self.driver.find_element(By.CLASS_NAME, "action.search")
            search_button.click()
            time.sleep(2)
            
            screenshot_path = self.capture_screenshot("video_02_busca.png")
            if screenshot_path:
                self.add_text_overlay(screenshot_path, "🔍 Resultado da Busca", (50, 50))
                screenshots.append(screenshot_path)
            
            # 3. Página do produto
            print("📸 Capturando Página do Produto...")
            self.driver.get(f"{self.base_url}/smartphone-galaxy-s23")
            screenshot_path = self.capture_screenshot("video_03_produto.png")
            if screenshot_path:
                self.add_text_overlay(screenshot_path, "📱 Página do Produto", (50, 50))
                screenshots.append(screenshot_path)
            
            # 4. Adicionar ao carrinho
            print("📸 Capturando Adição ao Carrinho...")
            add_to_cart_button = self.driver.find_element(By.ID, "product-addtocart-button")
            add_to_cart_button.click()
            time.sleep(2)
            
            screenshot_path = self.capture_screenshot("video_04_carrinho.png")
            if screenshot_path:
                self.add_text_overlay(screenshot_path, "🛒 Produto Adicionado ao Carrinho", (50, 50))
                screenshots.append(screenshot_path)
            
            # 5. Carrinho
            print("📸 Capturando Carrinho...")
            self.driver.get(f"{self.base_url}/checkout/cart")
            screenshot_path = self.capture_screenshot("video_05_carrinho_completo.png")
            if screenshot_path:
                self.add_text_overlay(screenshot_path, "🛒 Carrinho de Compras", (50, 50))
                screenshots.append(screenshot_path)
            
            # 6. Checkout
            print("📸 Capturando Checkout...")
            self.driver.get(f"{self.base_url}/checkout")
            screenshot_path = self.capture_screenshot("video_06_checkout.png")
            if screenshot_path:
                self.add_text_overlay(screenshot_path, "💳 Página de Checkout", (50, 50))
                screenshots.append(screenshot_path)
            
            # 7. Métodos de pagamento
            print("📸 Capturando Métodos de Pagamento...")
            time.sleep(3)
            screenshot_path = self.capture_screenshot("video_07_pagamento.png")
            if screenshot_path:
                self.add_text_overlay(screenshot_path, "💳 Métodos de Pagamento Brasileiros", (50, 50))
                screenshots.append(screenshot_path)
            
            # 8. Painel Admin
            print("📸 Capturando Painel Admin...")
            self.driver.get(f"{self.base_url}/admin")
            
            # Login admin
            username_field = self.driver.find_element(By.ID, "username")
            password_field = self.driver.find_element(By.ID, "login")
            
            username_field.send_keys("admin")
            password_field.send_keys("admin123")
            
            login_button = self.driver.find_element(By.CLASS_NAME, "action-login")
            login_button.click()
            
            time.sleep(3)
            screenshot_path = self.capture_screenshot("video_08_admin.png")
            if screenshot_path:
                self.add_text_overlay(screenshot_path, "⚙️ Painel Administrativo", (50, 50))
                screenshots.append(screenshot_path)
            
            # 9. Painel Vendedor
            print("📸 Capturando Painel Vendedor...")
            self.driver.get(f"{self.base_url}/vendor")
            
            # Login vendedor
            username_field = self.driver.find_element(By.ID, "username")
            password_field = self.driver.find_element(By.ID, "login")
            
            username_field.send_keys("vendor1")
            password_field.send_keys("vendor123")
            
            login_button = self.driver.find_element(By.CLASS_NAME, "action-login")
            login_button.click()
            
            time.sleep(3)
            screenshot_path = self.capture_screenshot("video_09_vendedor.png")
            if screenshot_path:
                self.add_text_overlay(screenshot_path, "🏪 Painel do Vendedor", (50, 50))
                screenshots.append(screenshot_path)
            
            # Criar vídeo
            print("🎬 Criando vídeo de demonstração...")
            video_path = f"{self.video_dir}/demo-video.mp4"
            self.create_video_from_screenshots(screenshots, video_path, duration_per_screenshot=4)
            
            print("✅ Vídeo de demonstração criado com sucesso!")
            
        except Exception as e:
            print(f"❌ Erro durante a geração do vídeo: {e}")
        
        finally:
            if self.driver:
                self.driver.quit()
    
    def create_video_description(self):
        """Criar descrição do vídeo"""
        description = {
            "title": "Marketplace Magento 2 - Demo Brasileiro",
            "duration": "60 segundos",
            "sections": [
                {
                    "time": "0:00-0:08",
                    "title": "Homepage",
                    "description": "Apresentação da página inicial com banners e produtos em destaque"
                },
                {
                    "time": "0:08-0:16",
                    "title": "Busca de Produtos",
                    "description": "Demonstração da funcionalidade de busca e filtros"
                },
                {
                    "time": "0:16-0:24",
                    "title": "Página do Produto",
                    "description": "Visualização detalhada de um produto com informações do vendedor"
                },
                {
                    "time": "0:24-0:32",
                    "title": "Carrinho de Compras",
                    "description": "Adição de produtos ao carrinho e gestão de múltiplos vendedores"
                },
                {
                    "time": "0:32-0:40",
                    "title": "Checkout",
                    "description": "Processo de finalização de compra com métodos de pagamento brasileiros"
                },
                {
                    "time": "0:40-0:48",
                    "title": "Painel Administrativo",
                    "description": "Interface de administração do marketplace"
                },
                {
                    "time": "0:48-0:56",
                    "title": "Painel do Vendedor",
                    "description": "Dashboard personalizado para gestão de produtos e vendas"
                },
                {
                    "time": "0:56-1:00",
                    "title": "Encerramento",
                    "description": "Informações de contato e próximos passos"
                }
            ]
        }
        
        with open(f"{self.video_dir}/video-description.json", "w", encoding="utf-8") as f:
            json.dump(description, f, indent=2, ensure_ascii=False)
        
        print("✅ Descrição do vídeo criada!")

if __name__ == "__main__":
    generator = MarketplaceVideoGenerator()
    generator.generate_demo_flow()
    generator.create_video_description() 