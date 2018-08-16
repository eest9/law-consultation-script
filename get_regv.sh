#!/bin/bash
#parmeters for the RIS API
Regv_par='?Applikation=Regv&BeschlussdatumVon=2013-10-29&BeschlussdatumBis=2017-11-08&DokumenteProSeite=OneHundred'
#Begut_par='?Applikation=Begut&DokumenteProSeite=Ten'

#curl -o ./data/Regv_data.json 'https://data.bka.gv.at/ris/api/v2.5/bundesgesetzblaetter'$Regv_par
ii=1
while [  $ii -lt 6 ]; do

  curl -o './data/Regv_data-'$ii'.json' 'https://data.bka.gv.at/ris/api/v2.5/bundesgesetzblaetter'$Regv_par'&Seitennummer='$ii

  i=0
  while [  $i -lt 100 ]; do
    echo 'The counter is '$i

    Regv_name="$(cat './data/Regv_data-'$ii'.json' | jq '.OgdSearchResult.OgdDocumentResults.OgdDocumentReference['$i'].Data.Metadaten.Bundesgesetzblaetter.Titel')"
    echo $Regv_name
    Regv_url_all="$(cat './data/Regv_data-'$ii'.json' | jq '.OgdSearchResult.OgdDocumentResults.OgdDocumentReference['$i'].Data.Metadaten.Allgemein.DokumentUrl')"
    echo $Regv_url_all
    Regv_url_pdf="$(cat './data/Regv_data-'$ii'.json' | jq '.OgdSearchResult.OgdDocumentResults.OgdDocumentReference['$i'].Data.Dokumentliste.ContentReference[0].Urls.ContentUrl[1].Url')"
    echo $Regv_url_pdf

    echo $Regv_name";"$Regv_url_all";"$Regv_url_pdf >> ./data/RegV_sample.csv

    let i=i+1
  done

  let ii=ii+1
done
