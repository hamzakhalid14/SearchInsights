# SearchInsights - Déploiement Render

## 🚀 Déploiement automatique avec render.yaml

### 1. Push votre code sur GitHub
```bash
git add .
git commit -m "Configure for Render deployment"
git push origin master
```

### 2. Créer un compte Render (gratuit)
1. Allez sur [render.com](https://render.com)
2. Créez un compte (pas de carte de crédit requise)
3. Connectez votre compte GitHub

### 3. Déployer avec Blueprint
1. Cliquez sur "New +" → "Blueprint"
2. Connectez votre repository `hamzakhalid14/SearchInsights`
3. Render détectera automatiquement le fichier `render.yaml`
4. Cliquez "Apply" pour déployer

### 4. Configuration automatique
Render va créer automatiquement :
- ✅ **Web Service** (application Rails)
- ✅ **PostgreSQL Database** (gratuit)
- ✅ **Redis** (pour Sidekiq)
- ✅ **Sidekiq Worker** (jobs en arrière-plan)

### 5. Variable d'environnement requise
Après le déploiement, ajoutez dans le service web :
- **RAILS_MASTER_KEY** = `2b4cf0c4cafd377c39619abc0e07d4a7`

### 🎯 Votre application sera accessible à :
`https://searchinsights.onrender.com`

## 💰 Plan gratuit Render inclut :
- ✅ 750 heures/mois
- ✅ 512 MB RAM
- ✅ PostgreSQL (1GB)
- ✅ Redis (25MB)
- ✅ SSL automatique
