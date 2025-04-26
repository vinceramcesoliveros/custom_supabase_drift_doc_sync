#!/bin/bash

# Check if .env file exists
if [ ! -f ".env" ]; then
  echo "Error: .env file not found!"
  exit 1
fi

# Extract variables from .env file
SUPABASE_URL=$(grep SUPABASE_URL .env | cut -d '=' -f2)
SUPABASE_ANON_KEY=$(grep SUPABASE_ANON_KEY .env | cut -d '=' -f2)
SUPABASE_STORAGE_BUCKET=$(grep SUPABASE_STORAGE_BUCKET .env | cut -d '=' -f2)

# Verify variables were extracted
if [ -z "$SUPABASE_URL" ] || [ -z "$SUPABASE_ANON_KEY" ]; then
  echo "Error: Required variables not found in .env file!"
  exit 1
fi

echo "🏗️ Building Flutter web app..."
flutter build web \
  --dart-define=DEMO_SUPABASE_URL="$SUPABASE_URL" \
  --dart-define=DEMO_SUPABASE_ANON_KEY="$SUPABASE_ANON_KEY" \
  --dart-define=DEMO_SUPABASE_STORAGE_BUCKET="$SUPABASE_STORAGE_BUCKET" \
  --release

echo "📝 Adding required COOP/COEP headers to index.html..."
# Add the headers to the HTML file directly
INDEX_FILE="build/web/index.html"
if [ -f "$INDEX_FILE" ]; then
  # Create a backup of the original file
  cp "$INDEX_FILE" "${INDEX_FILE}.bak"
  
  # Add the headers using sed
  sed -i.tmp '/<head>/a \
  <meta http-equiv="Cross-Origin-Opener-Policy" content="same-origin">\
  <meta http-equiv="Cross-Origin-Embedder-Policy" content="require-corp">' "$INDEX_FILE"
  
  # Remove the temporary file created by sed
  rm "${INDEX_FILE}.tmp" 2>/dev/null || true
  
  echo "✅ Headers added successfully to index.html"
else
  echo "❌ Error: Could not find index.html in build/web directory"
  exit 1
fi

echo "✅ Web build completed with environment variables and security headers!"
echo "  To test locally, run: cd build/web && python3 -m http.server 8000"
echo "  Then open: http://localhost:8000"