#!/bin/bash
#parmeters for the RIS API
Begut_par='?Applikation=Begut&DokumenteProSeite='

mkdir -p ./data/begut/

#Get and Parse the total number of Datasets
curl -o './data/begut/Begut_data-count.json' 'https://data.bka.gv.at/ris/api/v2.5/bundesgesetzblaetter'$Begut_par'Ten&Seitennummer=1'
sed -i 's/#text/text/' ./data/begut/Begut_data-count.json #jq can't parse "#"
Begut_count="$(cat './data/begut/Begut_data-count.json' | jq '.OgdSearchResult.OgdDocumentResults.Hits.text')"
echo $Begut_count
Begut_count=${Begut_count:1:(-1)} #delete quotation marks (first and last char)
let Begut_count=($Begut_count/100)+1 
echo $Begut_count

#Titleline
echo "Name;Short Name;Date;URL all;URL html" >> ./data/begut/Begut_sample.csv

#Get all Datasets
for ii in $(seq 1 $Begut_count); do

  #RIS API request for 100 Datasets
  curl -o './data/begut/Begut_data-'$ii'.json' 'https://data.bka.gv.at/ris/api/v2.5/bundesgesetzblaetter'$Begut_par'OneHundred&Seitennummer='$ii

  #Parse 1 of 100 Datasets
  for i in $(seq 0 99); do
    echo 'read and write Dataset number '$i' of side '$ii

    #read all the titeles and uris of all the bills in the last legislativ periode
    Begut_name="$(cat './data/begut/Begut_data-'$ii'.json' | jq '.OgdSearchResult.OgdDocumentResults.OgdDocumentReference['$i'].Data.Metadaten.Bundesgesetzblaetter.Titel')"
    echo $Begut_name
    Begut_name_short="$(cat './data/begut/Begut_data-'$ii'.json' | jq '.OgdSearchResult.OgdDocumentResults.OgdDocumentReference['$i'].Data.Metadaten.Bundesgesetzblaetter.Kurztitel')"
    echo $Begut_name_short
    Begut_date="$(cat './data/begut/Begut_data-'$ii'.json' | jq '.OgdSearchResult.OgdDocumentResults.OgdDocumentReference['$i'].Data.Metadaten.Allgemein.Geaendert')"
    Begut_date=${Begut_date:1:(-1)} #delete quotation marks (first and last char)
    echo $Begut_date
    Begut_url_all="$(cat './data/begut/Begut_data-'$ii'.json' | jq '.OgdSearchResult.OgdDocumentResults.OgdDocumentReference['$i'].Data.Metadaten.Allgemein.DokumentUrl')"
    echo $Begut_url_all
    Begut_url_html="$(cat './data/begut/Begut_data-'$ii'.json' | jq '.OgdSearchResult.OgdDocumentResults.OgdDocumentReference['$i'].Data.Dokumentliste.ContentReference[0].Urls.ContentUrl[1].Url')"
    echo $Begut_url_html

    #write csv file
    echo $Begut_name";"$Begut_name_short";"$Begut_date";"$Begut_url_all";"$Begut_url_html >> ./data/begut/Begut_sample.csv

  done

done
