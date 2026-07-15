// IMPORTANT: Replace these placeholders with your actual Supabase credentials
// You can find these in your Supabase Dashboard -> Project Settings -> API
const SUPABASE_URL = 'https://gryowwoaacqaqxgwgczn.supabase.co';
const SUPABASE_ANON_KEY = 'sb_publishable_2pBqtfP-7pZy3woSmzLe3w_bHNzlF21';

// Create Supabase client instance (requires supabase-js to be loaded via CDN first)
const supabaseClient = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
