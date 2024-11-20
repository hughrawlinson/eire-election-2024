open election-2024.db
  | get constituencies.candidate_listing_page
  | where $it != ""
  | each {|page| ({
    page: $page,
    status: (http options -e $page | get status)
  })}
  | save -a candidate_listing_page_statuses.nuon