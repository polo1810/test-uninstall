# Test détection désinstallation

Endpoint Netlify qui reçoit les pings de désinstallation depuis un client lourd Windows.

## Déploiement
1. Push ce repo sur GitHub
2. Sur Netlify : Add new site → Import from GitHub → Deploy
3. L'endpoint sera dispo sur : `https://VOTRE-SITE.netlify.app/.netlify/functions/uninstalled?userId=XXX`

## Voir les pings
Netlify → Functions → uninstalled → Logs
