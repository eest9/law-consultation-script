#!/bin/bash
#parmeters for the RIS API
#Begut_par='?Applikation=Begut&BeschlussdatumVon=2013-10-29&BeschlussdatumBis=2017-11-08&DokumenteProSeite=OneHundred'
Begut_par='?Applikation=Begut&DokumenteProSeite='

mkdir -p ./data/begut/

curl -o './data/begut/Begut_data-count.json' 'https://data.bka.gv.at/ris/api/v2.5/bundesgesetzblaetter'$Begut_par'Ten&Seitennummer=1'
sed -i 's/#text/text/' ./data/begut/Begut_data-count.json
Begut_count="$(cat './data/begut/Begut_data-count.json' | jq '.OgdSearchResult.OgdDocumentResults.Hits.text')"
echo $Begut_count
Begut_count=${Begut_count:1:(-1)}
let Begut_count=($Begut_count/100)+1
echo $Begut_count

for ii in $(seq 1 $Begut_count); do

  #RIS API request for all
  curl -o './data/begut/Begut_data-'$ii'.json' 'https://data.bka.gv.at/ris/api/v2.5/bundesgesetzblaetter'$Begut_par'OneHundred&Seitennummer='$ii

  for i in $(seq 0 99); do
    echo 'read and write Dataset number '$i' of side '$ii

    #read all the titeles and uris of all the bills in the last legislativ periode
    Begut_name="$(cat './data/begut/Begut_data-'$ii'.json' | jq '.OgdSearchResult.OgdDocumentResults.OgdDocumentReference['$i'].Data.Metadaten.Bundesgesetzblaetter.Titel')"
    echo $Begut_name
    Begut_date="$(cat './data/begut/Begut_data-'$ii'.json' | jq '.OgdSearchResult.OgdDocumentResults.OgdDocumentReference['$i'].Data.Metadaten.Allgemein.Geaendert')"
    Begut_date=${Begut_date:1:(-1)}
    echo $Begut_date
    Begut_url_all="$(cat './data/begut/Begut_data-'$ii'.json' | jq '.OgdSearchResult.OgdDocumentResults.OgdDocumentReference['$i'].Data.Metadaten.Allgemein.DokumentUrl')"
    echo $Begut_url_all
    Begut_url_pdf="$(cat './data/begut/Begut_data-'$ii'.json' | jq '.OgdSearchResult.OgdDocumentResults.OgdDocumentReference['$i'].Data.Dokumentliste.ContentReference[0].Urls.ContentUrl[1].Url')"
    echo $Begut_url_pdf

    #write csv file
    echo $Begut_name";"$Begut_date";"$Begut_url_all";"$Begut_url_pdf >> ./data/begut/Begut_sample.csv

  done

done
