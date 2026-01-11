
const https = require('https');

const supabaseUrl = 'https://ljvuzypqigsxcpzuojmy.supabase.co';
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxqdnV6eXBxaWdzeGNwenVvam15Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM5Mjc2MTIsImV4cCI6MjA3OTUwMzYxMn0.oygsRxv_Mmxr0TZqWFewDKhNyyd5fkn2kJvLzaC9JWE';

function makeRequest(path) {
  const url = new URL(`${supabaseUrl}/rest/v1/${path}`);
  const options = {
    hostname: url.hostname,
    path: `${url.pathname}${url.search}`,
    method: 'GET',
    headers: {
      'apikey': supabaseKey,
      'Authorization': `Bearer ${supabaseKey}`,
      'Content-Type': 'application/json'
    }
  };

  const req = https.request(options, (res) => {
    let data = '';

    res.on('data', (chunk) => {
      data += chunk;
    });

    res.on('end', () => {
      console.log(`Status Code: ${res.statusCode}`);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        console.log('Response:', data);
        console.log('SUCCESS: Connection to Supabase is working.');
      } else {
        console.error('Error Response:', data);
        console.error('FAILURE: Could not fetch data.');
      }
    });
  });

  req.on('error', (e) => {
    console.error(`Problem with request: ${e.message}`);
  });

  req.end();
}

console.log('Testing connection to service_categories...');
makeRequest('service_categories?select=count');
