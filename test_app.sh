#!/bin/bash

# Script de test pour votre application SearchInsights
# Remplacez YOUR_RAILWAY_URL par l'URL réelle de votre app

if [ -z "$1" ]; then
    echo "Usage: ./test_app.sh <railway_url>"
    echo "Exemple: ./test_app.sh https://searchinsights-production-xxxx.up.railway.app"
    exit 1
fi

URL=$1
echo "=== Test de l'application SearchInsights ==="
echo "URL: $URL"
echo ""

echo "1. Test du health check..."
curl -s "$URL/health" | jq . 2>/dev/null || curl -s "$URL/health"
echo ""

echo "2. Test de la page d'accueil..."
curl -s "$URL/" | jq . 2>/dev/null || curl -s "$URL/"
echo ""

echo "3. Test d'une recherche..."
curl -s -X POST "$URL/api/v1/search" \
  -H "Content-Type: application/json" \
  -d '{"query": "test search", "user_ip": "192.168.1.100"}' | jq . 2>/dev/null || \
curl -s -X POST "$URL/api/v1/search" \
  -H "Content-Type: application/json" \
  -d '{"query": "test search", "user_ip": "192.168.1.100"}'
echo ""

echo "4. Test des analytics..."
curl -s "$URL/api/v1/analytics" | jq . 2>/dev/null || curl -s "$URL/api/v1/analytics"
echo ""

echo "=== Tests terminés ==="
