#!/bin/bash

SUPABASE_URL="https://ziqpohdxtermunnhlkm.supabase.co"
SUPABASE_KEY="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InppcXBvaGR4dGVtc211bm5obGttIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE3ODQzNDcsImV4cCI6MjA4NzM2MDM0N30.ABAg5YZSrrAtBTWATJ3eRTmo4BuZVyVlrMV1HZjRWs0"

# المنتجات الحقيقية
products='[
  {"name": "آيفون 15 برو ماكس", "price": 450000, "category": "electronics", "images": ["https://images.unsplash.com/photo-1695048133142-1a20484d2569?w=400"], "stock": 10},
  {"name": "سامسونج اس 24 الترا", "price": 380000, "category": "electronics", "images": ["https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=400"], "stock": 15},
  {"name": "ماك بوك برو M3", "price": 1800000, "category": "electronics", "images": ["https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400"], "stock": 5},
  {"name": "تويوتا كامري 2024", "price": 8500000, "category": "cars", "images": ["https://images.unsplash.com/photo-1621007947382-bb3c3994e3fb?w=400"], "stock": 3},
  {"name": "فيلا فاخرة صنعاء", "price": 45000000, "category": "real_estate", "images": ["https://images.unsplash.com/photo-1560518883-ce09059eeffa?w=400"], "stock": 1},
  {"name": "مندي يمني", "price": 3500, "category": "restaurants", "images": ["https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=400"], "stock": 100},
  {"name": "ثوب يمني فاخر", "price": 35000, "category": "fashion", "images": ["https://images.unsplash.com/photo-1583391733956-3750e0ff4e8b?w=400"], "stock": 20},
  {"name": "كنبة زاوية فاخرة", "price": 150000, "category": "furniture", "images": ["https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=400"], "stock": 8},
  {"name": "بلاي ستيشن 5", "price": 250000, "category": "electronics", "images": ["https://images.unsplash.com/photo-1606813907291-d86efa9b94db?w=400"], "stock": 12},
  {"name": "ساعة ابل الترا", "price": 120000, "category": "electronics", "images": ["https://images.unsplash.com/photo-1524592094714-0f0654e20314?w=400"], "stock": 25}
]'

for product in $(echo $products | jq -c '.[]'); do
  curl -X POST "$SUPABASE_URL/rest/v1/products" \
    -H "apikey: $SUPABASE_KEY" \
    -H "Authorization: Bearer $SUPABASE_KEY" \
    -H "Content-Type: application/json" \
    -d "$product"
  echo "✅ تم إضافة منتج"
done
