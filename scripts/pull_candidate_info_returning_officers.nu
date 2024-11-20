let cache = ls data/returning_officer_snapshot
| get name
| each {|filename| ({
  filename: $filename,
  index: ($filename | path parse | get stem)
})}

let ros = open election-2024.db
| get constituencies
| select constituency returning_officer_url
| each {|it| ({
  ...$it,
  index: $it.constituency
})}
| reject constituency
| merge $cache

$ros | each {|r| (
  open $r.filename
  | poetry run python scripts/parsers/returning_officer.py $r.index $r.returning_officer_url
  | from json
)}
| flatten
| to json