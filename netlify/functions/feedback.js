// netlify/functions/feedback.js
// Endpoint qui recoit les reponses du questionnaire de desinstallation

exports.handler = async (event) => {
  // CORS basique (au cas ou la page soit ouverte depuis un autre domaine)
  const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type'
  };

  if (event.httpMethod === 'OPTIONS') {
    return { statusCode: 204, headers: corsHeaders, body: '' };
  }

  let payload = {};
  try {
    payload = JSON.parse(event.body || '{}');
  } catch (_) {
    payload = {};
  }

  const userId = payload.userId || 'unknown';
  const reason = payload.reason || '';
  const comment = (payload.comment || '').slice(0, 1000); // borne la taille
  const timestamp = new Date().toISOString();

  // Logs visibles dans le dashboard Netlify (Functions > feedback > Logs)
  console.log('📝 FEEDBACK DESINSTALLATION');
  console.log('userId:', userId);
  console.log('reason:', reason);
  console.log('comment:', comment);
  console.log('timestamp:', timestamp);
  console.log('user-agent:', event.headers['user-agent']);

  return {
    statusCode: 200,
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    body: JSON.stringify({ ok: true, timestamp })
  };
};
