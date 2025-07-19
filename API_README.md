# SearchInsights - Backend API

Application Rails API pure pour l'analyse de recherches avec analytics en temps réel.

## 🚀 Démarrage

```bash
# Démarrer le serveur
rails server

# Le serveur sera accessible sur http://localhost:3000
```

## 📡 Endpoints API

### 1. **POST /api/v1/search**
Enregistre une nouvelle recherche.

**Request:**
```bash
curl -X POST http://localhost:3000/api/v1/search \
  -H "Content-Type: application/json" \
  -d '{"query": "votre recherche"}'
```

**Response:**
```json
{
  "status": "success",
  "query": "votre recherche",
  "user_ip": "127.0.0.1"
}
```

### 2. **GET /api/v1/analytics**
Récupère les statistiques globales.

**Request:**
```bash
curl -X GET http://localhost:3000/api/v1/analytics
```

**Response:**
```json
{
  "total_queries": 15,
  "total_users": 8,
  "top_searches": {
    "ruby on rails": 5,
    "postgresql": 3,
    "api rest": 2
  }
}
```

### 3. **GET /api/v1/user_analytics**
Récupère les statistiques pour l'utilisateur actuel (basé sur l'IP).

**Request:**
```bash
curl -X GET http://localhost:3000/api/v1/user_analytics
```

**Response:**
```json
{
  "user_ip": "127.0.0.1",
  "searches": [
    ["ruby on rails", 5],
    ["postgresql", 3]
  ]
}
```

## 🏗️ Architecture Backend

### Modèles de données
- **SearchQuery**: Stocke chaque recherche individuelle
- **UserSearch**: Agrège les recherches par utilisateur/IP

### Contrôleurs
- **Api::V1::SearchesController**: Gère tous les endpoints API

### Base de données
- PostgreSQL avec migrations Rails
- Tables: `search_queries`, `user_searches`

## 🔧 Configuration

### Variables d'environnement
```bash
# Optionnel: Clé API pour authentification
API_KEY=votre_clé_secrète
```

### Gems principales
- Rails 7.1.5.1
- PostgreSQL
- Puma (serveur web)
- Sidekiq + Redis (jobs en arrière-plan)

## 📊 Monitoring

### Sidekiq Web Interface
Accessible sur: `http://localhost:3000/sidekiq`

## 🧪 Tests

### Test manuel avec curl
```bash
# 1. Enregistrer une recherche
curl -X POST http://localhost:3000/api/v1/search \
  -H "Content-Type: application/json" \
  -d '{"query": "test api"}'

# 2. Voir les analytics
curl -X GET http://localhost:3000/api/v1/analytics

# 3. Voir les analytics utilisateur
curl -X GET http://localhost:3000/api/v1/user_analytics
```

### Test avec Postman
Importez les requêtes suivantes :
- POST `http://localhost:3000/api/v1/search`
- GET `http://localhost:3000/api/v1/analytics`
- GET `http://localhost:3000/api/v1/user_analytics`

## 🔒 Sécurité

- Protection CSRF désactivée pour l'API
- Rate limiting avec Rack Attack
- Validation des paramètres d'entrée
- Gestion d'erreurs robuste

## 📝 Logs

Les logs sont disponibles dans `log/development.log` et incluent :
- Requêtes SQL
- Erreurs d'API
- Performance des endpoints

---

**Note**: Cette application est maintenant configurée comme API backend pure, sans interface utilisateur. Toutes les interactions se font via les endpoints REST.
