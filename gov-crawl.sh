#!/bin/bash
#parmeters for the RIS API
Regv_par='?Applikation=Regv&DokumenteProSeite=Ten'

#get the URL of the HTML Gouvermental bill
#curl -o Regv_data.json 'https://data.bka.gv.at/ris/api/v2.5/bundesgesetzblaetter'$Regv_par
#Regv_tempdata="$(./data/Regv_data.json | jq '.OgdSearchResult.OgdDocumentResults.OgdDocumentReference[0].Data.Dokumentliste.ContentReference[0].Urls.ContentUrl[1].Url')"

#parsing the law.html from RIS
function save_law {
  temp_law_filename=$1
  temp_law_url=$2
  temp_law_url=${temp_law_data:1:(-1)}

  echo 'get data from '$temp_law_url

  echo 'save data to '$temp_law_filename".html"
  curl -o $temp_law_filename".html" $temp_law_url

  maxWidth=$(echo "2^(32-1)-1" | bc)
  html2text -width $maxWidth -o $temp_law_filename".txt" $temp_law_filename".html"

  echo -e 'done temp_law_filename'
}

#RegV
Regv_url="\"http://www.ris.bka.gv.at/Dokumente/RegV/REGV_COO_2026_100_2_1516300/REGV_COO_2026_100_2_1516300.html\""
Regv_filename="./data/REGV_COO_2026_100_2_1516300"
save_law $Regv_filename $Regv_url
echo -e 'done RegV'

#Begut
Begut_url="\"http://www.ris.bka.gv.at/Dokumente/Begut/BEGUT_COO_2026_100_2_1516300/BEGUT_COO_2026_100_2_1516300.html\""
Begut_filename="./data/BEGUT_COO_2026_100_2_1516300"
save_law $Begut_filename $Begut_url
echo -e 'done Begut'

diff -w -B $Begut_filename".txt" $Regv_filename".txt" > ./data/test.diff
#diff -w -B $Begut_tempname".html" $Regv_tempname".html" > ./data/test.diff
diffstat ./data/test.diff
