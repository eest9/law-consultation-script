#!/bin/bash
#parmeters for the RIS API
Regv_par='?Applikation=Regv&DokumenteProSeite=Ten'

#get the URL of the HTML Gouvermental bill
#curl -o Regv_data.json 'https://data.bka.gv.at/ris/api/v2.5/bundesgesetzblaetter'$Regv_par
#Regv_tempdata="$(./data/Regv_data.json | jq '.OgdSearchResult.OgdDocumentResults.OgdDocumentReference[0].Data.Dokumentliste.ContentReference[0].Urls.ContentUrl[1].Url')"

##parsing the URL
Regv_tempdata="\"http://www.ris.bka.gv.at/Dokumente/RegV/REGV_COO_2026_100_2_1516300/REGV_COO_2026_100_2_1516300.html\""
Regv_tempdata=${Regv_tempdata:1:(-1)}

echo 'get data from '$Regv_tempdata
Regv_tempname="./data/REGV_COO_2026_100_2_1516300"".html"

echo 'save data to '$Regv_tempname
curl -o $Regv_tempname $Regv_tempdata
xmlstarlet ed --inplace -N x="http://www.w3.org/1999/xhtml" -d "//x:head" $Regv_tempname
xmlstarlet ed --inplace -d "//@class" $Regv_tempname

echo -e 'done RegV'

#Begut
Begut_tempdata="\"http://www.ris.bka.gv.at/Dokumente/Begut/BEGUT_COO_2026_100_2_1516300/BEGUT_COO_2026_100_2_1516300.html\""
Begut_tempdata=${Begut_tempdata:1:(-1)}

echo 'get data from '$Begut_tempdata
Begut_tempname="./data/BEGUT_COO_2026_100_2_1516300"".html"

echo 'save data to '$Begut_tempname
curl -o $Begut_tempname $Begut_tempdata
xmlstarlet ed --inplace -N x="http://www.w3.org/1999/xhtml" -d "//x:head" $Begut_tempname
xmlstarlet ed --inplace -d "//@class" $Begut_tempname

echo -e 'done Begut'

diff -w -B $Begut_tempname $Regv_tempname > ./data/test.diff
diffstat ./data/test.diff
