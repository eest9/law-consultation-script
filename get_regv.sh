#!/bin/bash
#parmeters for the RIS API
#Regv_par='?Applikation=Regv&BeschlussdatumVon=2013-10-29&BeschlussdatumBis=2017-11-08&DokumenteProSeite=OneHundred'

#check if parameters are valide ISO 8601 dates
if [[ ! $1 == [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] ]]; then
  echo "parameter 1 must be a date"
  exit 1
elif [[ ! $2 == [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] ]]; then
  echo "parameter 2 must be a date"
  exit 1
fi

Regv_par='?Applikation=Regv&BeschlussdatumVon='$1'&BeschlussdatumBis='$2'&DokumenteProSeite=OneHundred'

mkdir -p ./data/regv/

#Titleline
echo "Name;Short Name;Date;URL all;URL html" >> ./data/regv/Regv_sample.csv

#Get the 5 Datasets includet in the research object
for ii in $(seq 1 5); do

  #RIS API request for all
  curl -o './data/regv/Regv_data-'$ii'.json' 'https://data.bka.gv.at/ris/api/v2.5/bundesgesetzblaetter'$Regv_par'&Seitennummer='$ii

  #Parse 1 of 100 Datasets
  for i in $(seq 0 99); do
    echo 'read and write Dataset number '$i' of side '$ii

    #read all the titeles and uris of all the bills in the last legislativ periode
    Regv_name="$(cat './data/regv/Regv_data-'$ii'.json' | jq '.OgdSearchResult.OgdDocumentResults.OgdDocumentReference['$i'].Data.Metadaten.Bundesgesetzblaetter.Titel')"
    echo $Regv_name
    Regv_name_short="$(cat './data/regv/Regv_data-'$ii'.json' | jq '.OgdSearchResult.OgdDocumentResults.OgdDocumentReference['$i'].Data.Metadaten.Bundesgesetzblaetter.Kurztitel')"
    echo $Regv_name_short
    Regv_date="$(cat './data/regv/Regv_data-'$ii'.json' | jq '.OgdSearchResult.OgdDocumentResults.OgdDocumentReference['$i'].Data.Metadaten.Allgemein.Geaendert')"
    Regv_date=${Regv_date:1:(-1)}
    echo $Regv_date
    Regv_url_all="$(cat './data/regv/Regv_data-'$ii'.json' | jq '.OgdSearchResult.OgdDocumentResults.OgdDocumentReference['$i'].Data.Metadaten.Allgemein.DokumentUrl')"
    echo $Regv_url_all
    Regv_url_html="$(cat './data/regv/Regv_data-'$ii'.json' | jq '.OgdSearchResult.OgdDocumentResults.OgdDocumentReference['$i'].Data.Dokumentliste.ContentReference[0].Urls.ContentUrl[1].Url')"
    echo $Regv_url_html

    #write csv file
    echo $Regv_name";"$Regv_name_short";"$Regv_date";"$Regv_url_all";"$Regv_url_html >> ./data/regv/Regv_sample.csv

  done

done
