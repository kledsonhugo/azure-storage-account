# Guia Azure for Students

Este guia descreve como estudantes podem obter acesso gratuito ao Azure, configurar autenticação para GitHub Actions e fazer deploy de um site estático usando Terraform.

## Índice

1. [Inscrição no Azure for Students](#1-inscrição-no-azure-for-students)
2. [Primeiro Acesso ao Portal Azure](#2-primeiro-acesso-ao-portal-azure)
3. [Criação de Service Principal](#3-criação-de-service-principal)
4. [Configuração do GitHub Actions](#4-configuração-do-github-actions)
5. [Fork e Configuração do Projeto](#5-fork-e-configuração-do-projeto)
6. [Executando o Terraform](#6-executando-o-terraform)
7. [Solução de Problemas](#7-solução-de-problemas)

---

## 1. Inscrição no Azure for Students

### 1.1 Requisitos

- **E-mail institucional**: Você deve ter um e-mail de uma instituição educacional reconhecida
- **Verificação acadêmica**: Documento que comprove que você é estudante (carteirinha, declaração de matrícula, etc.). Esse documento poderá ser solicitado durante a inscrição.

### 1.2 Passo a Passo para Inscrição

1. **Acesse o portal Azure for Students**:
   ```
   https://azure.microsoft.com/pt-br/free/students/
   ```

2. **Clique em "Experimente gratuitamente"**

3. **Entre com sua conta Microsoft**:
   - Se você não tem uma conta Microsoft, crie uma usando seu e-mail institucional
   - Se já tem, faça login

4. **Verificação de elegibilidade**:
   - O Azure tentará verificar automaticamente seu status de estudante
   - Se não conseguir verificar automaticamente, você precisará enviar documentos

5. **Documentos aceitos para verificação manual**:
   - Carteirinha estudantil válida
   - Declaração de matrícula
   - Histórico escolar recente
   - Comprovante de pagamento de mensalidade

6. **Aguarde a aprovação**:
   - Verificação automática: Imediata
   - Verificação manual: 1-3 dias úteis

### 1.3 Benefícios do Azure for Students

- **$100 USD em créditos**: Válidos por 12 meses
- **Serviços gratuitos**: Muitos serviços Azure gratuitos durante 12 meses
- **Sem cartão de crédito**: Não é necessário fornecer cartão de crédito
- **Renovação**: Pode ser renovado anualmente enquanto for estudante

---

## 2. Primeiro Acesso ao Portal Azure

### 2.1 Acessando o Portal

1. **Acesse o portal Azure**:
   ```
   https://portal.azure.com
   ```

2. **Faça login** com a mesma conta Microsoft usada na inscrição

3. **Verifique sua subscription**:
   - No menu superior direito, clique no ícone de configurações
   - Selecione "Directories + subscriptions"
   - Confirme que você vê "Azure for Students" listada

### 2.2 Explorando o Portal

1. **Dashboard inicial**: Familiarize-se com a interface
2. **Barra de pesquisa**: Use para encontrar serviços rapidamente
3. **Menu lateral**: Acesse "Todos os serviços" para ver opções disponíveis
4. **Cloud Shell**: Ícone `>_` na barra superior (terminal baseado na web)

### 2.3 Verificando Créditos e Uso

1. **Acesse "Cost Management + Billing"**
2. **Clique em "Subscriptions"**
3. **Selecione "Azure for Students"**
4. **Visualize** seu saldo atual e uso de créditos

---

## 3. Criação de Service Principal

Um Service Principal é necessário para que o GitHub Actions possa se autenticar no Azure automaticamente.

### 3.1 Usando Azure CLI (Recomendado)

1. **Abra o Cloud Shell** no portal Azure (ícone `>_`)

2. **Escolha Bash** quando solicitado

3. **Execute os comandos a seguir**:

```bash

4. **Copie e guarde o output JSON** (será usado no GitHub):

```json
{
  "clientId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "clientSecret": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
  "subscriptionId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "tenantId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
  "resourceManagerEndpointUrl": "https://management.azure.com/",
  "activeDirectoryGraphResourceId": "https://graph.windows.net/",
  "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
  "galleryEndpointUrl": "https://gallery.azure.com/",
  "managementEndpointUrl": "https://management.core.windows.net/"
}
```

**⚠️ Importante**: Você precisará dos seguintes valores para criar os GitHub Secrets:
- `clientId` → será usado em `ARM_CLIENT_ID`
- `clientSecret` → será usado em `ARM_CLIENT_SECRET`
- `subscriptionId` → será usado em `ARM_SUBSCRIPTION_ID`
- `tenantId` → será usado em `ARM_TENANT_ID`

---

## 4. Configuração do GitHub Actions

### 4.1 Criando GitHub Secrets Individuais

Para melhor flexibilidade e segurança, vamos configurar as credenciais como secrets separados:

1. **Vá para seu repositório** no GitHub

2. **Clique em "Settings"** (aba do repositório)

3. **No menu lateral**, clique em "Secrets and variables" > "Actions"

4. **Crie os seguintes secrets** (clique em "New repository secret" para cada um):

   - **Name**: `ARM_CLIENT_ID`  
     **Secret**: O valor de `clientId` do JSON do Service Principal
   
   - **Name**: `ARM_CLIENT_SECRET`  
     **Secret**: O valor de `clientSecret` do JSON do Service Principal
   
   - **Name**: `ARM_SUBSCRIPTION_ID`  
     **Secret**: O valor de `subscriptionId` do JSON do Service Principal
   
   - **Name**: `ARM_TENANT_ID`  
     **Secret**: O valor de `tenantId` do JSON do Service Principal

### 4.2 Vantagens desta Abordagem

- **Flexibilidade**: Permite atualizar credenciais individuais sem recriar todo o JSON
- **Reutilização**: As mesmas variáveis são usadas tanto para autenticação quanto para o Terraform
- **Manutenibilidade**: Mais fácil de gerenciar e debugar
- **Segurança**: Isolamento de cada credencial

---

## 5. Fork e Configuração do Projeto

### 5.1 Fork do Repositório

1. **Vá para o repositório original**:
   ```
   https://github.com/kledsonhugo/azure-storage-account
   ```

2. **Clique em "Fork"** no canto superior direito

3. **Configure o fork**:
   - Owner: Sua conta GitHub
   - Repository name: `azure-storage-account` (ou um nome de sua escolha)
   - Description: Opcional
   - **Marque** "Copy the main branch only"

4. **Clique em "Create fork"**

### 5.2 Clone Local

```bash
# Clone seu fork
git clone https://github.com/SEU_USERNAME/azure-storage-account.git
cd azure-storage-account
```

### 5.3 Configurações Necessárias

#### 5.3.1 Configurar Backend do Terraform

O arquivo `terraform/provider.tf` contém uma configuração de exemplo do backend.

Ajuste o valor do parâmetro `storage_account_name` com o nome do Storage Account que você criou para armazenar o estado da execução do Terraform.

```terraform
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.47.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-staticsitetf"
    storage_account_name = "staticsitetfkb002"     # Use sua data ou adicione números aleatórios
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  resource_provider_registrations = "none"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
```

#### 5.3.2 Ajustar Nome da Storage Account

Edite o arquivo `terraform/vars.tf`:

```terraform
variable "storage_account_name" {
    type    = string
    default = "staticsitekb002"      # Use sua data ou adicione números aleatórios
}
```

**⚠️ Importante**: 
- Apenas letras minúsculas e números
- Entre 3 e 24 caracteres
- Globalmente único no Azure

---

## 6. Executando o Terraform

### 6.1 Execução via GitHub Actions

O workflow será executado automaticamente a cada push na branch `main`.

### 6.2 Monitoramento do Deploy

#### 6.2.1 GitHub Actions Logs

1. **Acesse a aba "Actions"**

2. **Clique no run** mais recente

3. **Expand cada step** para ver logs detalhados

#### 6.2.2 Azure Portal

1. **Acesse o portal Azure**

2. **Procure por "Resource groups"**

3. **Clique em "rg-staticsite"**

4. **Verifique** se os recursos foram criados:
   - Storage Account
   - Static Website

### 6.3 Acessando seu Site

1. **No Azure Portal**, vá para sua Storage Account

2. **No menu lateral**, clique em "Static website"

3. **Copie** a URL do "Primary endpoint"

4. **Acesse** a URL no navegador

Exemplo de URL: `https://staticsitestudent20241011.z13.web.core.windows.net/`

---

## 7. Solução de Problemas

### 7.1 Problemas Comuns de Subscription

#### Erro: "Subscription not found"

```bash
# Liste suas subscriptions
az account list --output table

# Defina a subscription correta
az account set --subscription "Azure for Students"
```

#### Erro: "Insufficient credits"

```bash
# Verifique seus créditos restantes
az consumption usage list --output table
```

### 7.2 Problemas de Service Principal

#### Erro: "Invalid client secret"

- **Recrie o client secret** no Azure Portal
- **Atualize** o GitHub Secret `ARM_CLIENT_SECRET`

#### Erro: "Insufficient privileges"

```bash
# Verifique as roles do Service Principal
az role assignment list --assignee CLIENT_ID --output table

# Se necessário, adicione a role Contributor
az role assignment create \
  --assignee CLIENT_ID \
  --role "Contributor" \
  --scope "/subscriptions/SUBSCRIPTION_ID"
```

### 7.3 Problemas de Storage Account

#### Erro: "Storage account name already exists"

- **Altere** o nome da storage account em `vars.tf`
- **Use** uma combinação única (ex: `staticsitestudent` + timestamp)

#### Erro: "Invalid storage account name"

- **Apenas** letras minúsculas e números
- **Entre** 3 e 24 caracteres
- **Sem** caracteres especiais ou espaços

### 7.4 Problemas de GitHub Actions

#### Erro: "Secret not found"

- **Confirme** que os secrets `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_SUBSCRIPTION_ID` e `ARM_TENANT_ID` existem
- **Verifique** se os valores estão corretos e correspondem ao Service Principal criado

#### Erro: "Subscription ID could not be determined"

- **Verifique** se `ARM_SUBSCRIPTION_ID` está configurado corretamente
- **Confirme** que o Service Principal tem acesso à subscription

## 📚 Recursos Adicionais

- [Documentação Azure for Students](https://docs.microsoft.com/pt-br/azure/education/)
- [Azure Static Web Apps](https://docs.microsoft.com/pt-br/azure/static-web-apps/)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [GitHub Actions para Azure](https://github.com/Azure/actions)
- [Microsoft Learn - Azure Fundamentals](https://docs.microsoft.com/pt-br/learn/paths/azure-fundamentals/)

---

**💡 Dica**: Mantenha sempre um controle dos seus créditos Azure for Students e monitore o uso dos recursos para evitar surpresas!

**🔐 Segurança**: Nunca commit credentials ou secrets no código. Sempre use GitHub Secrets ou Azure Key Vault para informações sensíveis.