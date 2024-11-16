
let candidatedetails = open election-2024.db | query db "select * from candidate_details where imageURL not null";

for $candidate in $candidatedetails {
  let destination = ($candidate.imageURL | url encode --all)
  let destination_filename = './static/candidate_images/' ++ $'($candidate.name | url encode --all)($candidate.party | url encode --all)'

  if $destination != "" and not ($destination_filename | path exists) {
    http get $candidate.imageURL | save $destination_filename
  }
}
