use std/formats *;

let constituencies = open election-2024.db | query db 'select constituency, candidate_listing_page from constituencies'

for constituency in $constituencies {
  # get $constituency.candidate_listing_page
  if ($constituency.candidate_listing_page == "") {
    continue;
  }
  http get $constituency.candidate_listing_page | save $"data/returning_officer_snapshot/($constituency.constituency).html"
  # let candidates = (http get $constituency.candidate_listing_page | poetry run python ./scripts/parsers/returning_officer.py) | from json
  # let result = ($candidates | each {|candidate| ({
  #   constituency: $constituency.constituency,
  #   ...$candidate
  # })} | to json)
  # print $result
  # $result | save -a data/returning_officer_data.nuon
  # for candidate in $candidates {
  #   let parsedcandidateline = ($candidate.2 | str join $candidate.3| str replace '(' '' | split row ', of')
  #   print {
  #     constituency: $constituency.constituency,
  #     surname: $candidate.0,
  #     party: $candidate.1,
  #     candidateline: $candidate.2
  #     name: $parsedcandidateline.0
  #     address: ($parsedcandidateline.1 | str trim)
  #   }
  # }
}
