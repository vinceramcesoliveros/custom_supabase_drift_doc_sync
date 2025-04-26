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

# Build with loaded variables
flutter build web \
  --dart-define=DEMO_SUPABASE_URL="$SUPABASE_URL" \
  --dart-define=DEMO_SUPABASE_ANON_KEY="$SUPABASE_ANON_KEY" \
  --dart-define=DEMO_SUPABASE_STORAGE_BUCKET="$SUPABASE_STORAGE_BUCKET" \
  --release

echo "Web build completed with environment variables from .env file!"