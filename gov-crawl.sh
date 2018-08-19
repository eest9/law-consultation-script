#!/bin/bash
#parmeters for the RIS API
Regv_par='?Applikation=Regv&DokumenteProSeite=Ten'
Begut_par='?Applikation=Begut&DokumenteProSeite=Ten'

#parsing the law.html from RIS
function save_law {
  temp_law_filename=$1
  temp_law_url=$2
  temp_law_url=${temp_law_url:1:(-1)}

  echo 'get data from '$temp_law_url
  echo 'save data to '$temp_law_filename".html"
  curl -o $temp_law_filename".html" $temp_law_url

  echo 'convert html to text'
  maxWidth=$(echo "2^(32-1)-1" | bc) #max with of cli for the html2text converter
  html2text -width $maxWidth -o $temp_law_filename".txt" $temp_law_filename".html"

  echo -e 'done temp_law_filename'
}

#RegV
#get the URL of the council bills HTML
#curl -o Regv_data.json 'https://data.bka.gv.at/ris/api/v2.5/bundesgesetzblaetter'$Regv_par
#Regv_url="$(cat ./data/Regv_data.json | jq '.OgdSearchResult.OgdDocumentResults.OgdDocumentReference[0].Data.Dokumentliste.ContentReference[0].Urls.ContentUrl[1].Url')"
Regv_url="\"http://www.ris.bka.gv.at/Dokumente/RegV/REGV_COO_2026_100_2_1516300/REGV_COO_2026_100_2_1516300.html\"" #testdata
Regv_filename="./data/REGV_COO_2026_100_2_1516300"
save_law $Regv_filename $Regv_url
echo -e 'done RegV'

#Begut
#get the URL of the consultation bills HTML
#curl -o Begut_data.json 'https://data.bka.gv.at/ris/api/v2.5/bundesgesetzblaetter'$Begut_par
#Begut_url="$(cat ./data/Regv_data.json | jq '.OgdSearchResult.OgdDocumentResults.OgdDocumentReference[0].Data.Dokumentliste.ContentReference[0].Urls.ContentUrl[1].Url')"
Begut_url="\"http://www.ris.bka.gv.at/Dokumente/Begut/BEGUT_COO_2026_100_2_1516300/BEGUT_COO_2026_100_2_1516300.html\"" #testdata
Begut_filename="./data/BEGUT_COO_2026_100_2_1516300"
save_law $Begut_filename $Begut_url
echo -e 'done Begut'

diff -w -B $Begut_filename".txt" $Regv_filename".txt" > ./data/test.diff
diffstat ./data/test.diff
