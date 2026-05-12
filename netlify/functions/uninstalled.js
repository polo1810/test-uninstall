// netlify/functions/uninstalled.js
// Endpoint qui reçoit les pings de désinstallation

exports.handler = async (event) => {
  // Récupère les params depuis l'URL (GET) ou le body (POST)
  const params = event.queryStringParameters || {};
  const userId = params.userId || 'inconnu';
  const timestamp = new Date().toISOString();
  
  // Log dans la console Netlify (visible dans le dashboard)
  console.log('🔴 DÉSINSTALLATION DÉTECTÉE');
  console.log('userId:', userId);
  console.log('timestamp:', timestamp);
  console.log('user-agent:', event.headers['user-agent']);
  
  // Retourne une page HTML simple (pour le cas où l'installer ouvre un navigateur)
  return {
    statusCode: 200,
    headers: { 'Content-Type': 'text/html; charset=utf-8' },
    body: `
      <!DOCTYPE html>
      <html>
      <head>
        <title>Désinstallation enregistrée</title>
        <style>
          body { font-family: Arial; max-width: 600px; margin: 50px auto; padding: 20px; }
          .ok { color: green; font-size: 24px; }
          .info { background: #f0f0f0; padding: 15px; border-radius: 8px; }
        </style>
      </head>
      <body>
        <div class="ok">✅ Ping reçu !</div>
        <p>La désinstallation a bien été enregistrée côté serveur.</p>
        <div class="info">
          <strong>userId :</strong> ${userId}<br>
          <strong>timestamp :</strong> ${timestamp}
        </div>
        <p><a href="/">Voir le dashboard</a></p>
      </body>
      </html>
    `
  };
};
