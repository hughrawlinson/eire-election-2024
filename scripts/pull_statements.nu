let candidates = open election-2024.db | query db 'select name, party, candidatePage from candidate_details where party like "Sinn F%"'

let result = $candidates | each { |candidate| ({
    ...$candidate,
    statement: (http get $candidate.candidatePage | query web  --query '.et_pb_text_3_tb_body .et_pb_text_inner' | get -i 0.0)
  })
} | flatten

print $result;

$result | save data/sf_statements.json