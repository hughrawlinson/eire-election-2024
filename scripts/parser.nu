open wikitable2json.com_candidates.json | get 0 | reject 0 | each {|record| ($record | reject Constituency | transpose | each {|bop| {constituency: $record.Constituency.text, bop: $bop})})}