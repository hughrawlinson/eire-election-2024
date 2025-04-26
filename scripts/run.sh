poetry run datasette election-2024.db \
  --metadata ./metadata.json \
  --template-dir=./templates/ \
  --plugins-dir=./plugins \
  --static=assets:static/ \
  --host 0.0.0.0 \
  --root \
  --setting sql_time_limit_ms 2000 \
  --setting default_cache_ttl 3600
