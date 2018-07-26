#!/bin/bash
#parmeters for the RIS API
Regv_par='?Applikation=Regv&DokumenteProSeite=Ten'

#get the URL of the HTML Gouvermental bill
#curl -o Regv_data.json 'https://data.bka.gv.at/ris/api/v2.5/bundesgesetzblaetter'$Regv_par
#Regv_tempdata="$(./data/Regv_data.json | jq '.OgdSearchResult.OgdDocumentResults.OgdDocumentReference[0].Data.Dokumentliste.ContentReference[0].Urls.ContentUrl[1].Url')"

#parsing the law.html from RIS
function save_law {
  temp_law_filename=$1
  temp_law_data=$2
  temp_law_data=${temp_law_data:1:(-1)}

  echo 'get data from '$temp_law_data

  echo 'save data to '$temp_law_filename
  curl -o $temp_law_filename $temp_law_data
  xmlstarlet ed --inplace -N x="http://www.w3.org/1999/xhtml" -d "//x:head" $temp_law_filename
  xmlstarlet ed --inplace -d "//@class" $temp_law_filename

  echo -e 'done temp_law_filename'
}

#RegV
Regv_tempdata="\"http://www.ris.bka.gv.at/Dokumente/RegV/REGV_COO_2026_100_2_1516300/REGV_COO_2026_100_2_1516300.html\""
Regv_tempname="./data/REGV_COO_2026_100_2_1516300"".html"
save_law $Regv_tempname $Regv_tempdata
echo -e 'done RegV'

#Begut
Begut_tempdata="\"http://www.ris.bka.gv.at/Dokumente/Begut/BEGUT_COO_2026_100_2_1516300/BEGUT_COO_2026_100_2_1516300.html\""
Begut_tempname="./data/BEGUT_COO_2026_100_2_1516300"".html"
save_law $Begut_tempname $Begut_tempdata
echo -e 'done Begut'

diff -w -B $Begut_tempname $Regv_tempname > ./data/test.diff
diffstat ./data/test.diff
