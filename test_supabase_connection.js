
const { createClient } = require('@supabase/supabase-js');

// Configuration from lib/core/config/supabase_config.dart
const supabaseUrl = 'https://ljvuzypqigsxcpzuojmy.supabase.co';
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxqdnV6eXBxaWdzeGNwenVvam15Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM5Mjc2MTIsImV4cCI6MjA3OTUwMzYxMn0.oygsRxv_Mmxr0TZqWFewDKhNyyd5fkn2kJvLzaC9JWE';

const supabase = createClient(supabaseUrl, supabaseKey);

async function checkConnection() {
  console.log('Testing Supabase connection...');
  
  try {
    // Try to fetch service categories as they are usually public read
    const { data, error } = await supabase
      .from('service_categories')
      .select('count')
      .limit(1);

    if (error) {
      console.error('Error connecting to Supabase:', error.message);
      if (error.code) console.error('Error code:', error.code);
    } else {
      console.log('Connection successful!');
      console.log('Data received:', data);
    }
    
    // Check if we can sign in (dummy check)
    // We won't actually sign in, but checking if the auth endpoint is reachable
    const { data: authData, error: authError } = await supabase.auth.getSession();
    if (authError) {
       console.error('Auth Service Error:', authError.message);
    } else {
       console.log('Auth Service is reachable.');
    }

  } catch (e) {
    console.error('Unexpected error:', e);
  }
}

checkConnection();
