poetry run datasette publish vercel --project irish-election-2024 \
  election-2024.db \
  --metadata ./metadata.json \
  --template-dir=./templates/ \
  --plugins-dir=./plugins \
  --static=assets:static/ \
  --install datasette-geojson \
  --install datasette-geojson-map \
  --install datasette-template-sql \
  --vercel-json vercel.json
