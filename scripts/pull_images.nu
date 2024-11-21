
let candidatedetails = open election-2024.db | query db "select * from returning_officer_data where imageUrl not null";

for $candidate in $candidatedetails {
  let destination = ($candidate.imageUrl | url encode --all)
  let destination_filename = './static/ro_images/' ++ $'($candidate.full_name | url encode --all)($candidate.party | url encode --all)'

  print $destination
  if $candidate.imageUrl == "" {
    continue;
  }

  if $destination != "" and not ($destination_filename | path exists) {
    print $candidate.imageUrl, $destination_filename
    # http get $candidate.imageURL | save $destination_filename
  }
}
