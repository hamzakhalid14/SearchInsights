# SearchInsights - Déploiement Railway

## 🚄 Guide de déploiement sur Railway

### 1. Push votre code sur GitHub
```bash
git add .
git commit -m "Configure for Railway deployment"
git push origin master
```

### 2. Créer un compte Railway (gratuit)
1. Allez sur [railway.app](https://railway.app)
2. Connectez-vous avec GitHub (pas de carte de crédit requise)
3. Cliquez sur **"Start a New Project"**

### 3. Déployer votre application
1. **Sélectionnez "Deploy from GitHub repo"**
2. **Choisissez** `hamzakhalid14/SearchInsights`
3. **Railway détectera automatiquement** que c'est une app Rails

### 4. Ajouter une base de données PostgreSQL
1. Dans votre projet Railway, cliquez **"+ New"**
2. Sélectionnez **"Database" → "PostgreSQL"**
3. Railway va automatiquement créer la variable `DATABASE_URL`

### 5. Ajouter Redis
1. Cliquez **"+ New"** again
2. Sélectionnez **"Database" → "Redis"**
3. Railway va créer la variable `REDIS_URL`

### 6. Configurer les variables d'environnement
Dans votre service web, allez dans **"Variables"** et ajoutez :

```
RAILS_MASTER_KEY=2b4cf0c4cafd377c39619abc0e07d4a7
RAILS_ENV=production
BUNDLE_WITHOUT=development:test
RAILS_SERVE_STATIC_FILES=true
RAILS_LOG_TO_STDOUT=true
```

### 7. Ajouter un service Sidekiq Worker
1. Cliquez **"+ New" → "GitHub Repo"**
2. Sélectionnez le même repo `SearchInsights`
3. Dans les **"Settings" → "Service"**, changez :
   - **Start Command**: `bundle exec sidekiq`
   - **Root Directory**: `/`

### 8. Variables d'environnement pour Sidekiq
Copiez les mêmes variables d'environnement du service web vers le worker Sidekiq.

## 🎯 Ce qui sera déployé :

- **🌐 Web Service** : Dashboard à `https://[your-app].railway.app`
- **🗄️ PostgreSQL** : Base de données
- **📊 Redis** : Pour Sidekiq
- **⚙️ Sidekiq Worker** : Tâches en arrière-plan

## 💰 Plan gratuit Railway :

- **$5 de crédit gratuit/mois**
- **500 heures d'execution/mois**
- **1GB RAM par service**
- **1GB stockage PostgreSQL**

## 🚀 Votre app sera disponible à :
`https://[nom-genere].railway.app`
