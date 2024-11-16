poetry run datasette election-2024.db \
  --metadata ./metadata.json \
  --template-dir=./templates/ \
  --plugins-dir=./plugins \
  --static=assets:static/ \
  --host 0.0.0.0 \
  --root
