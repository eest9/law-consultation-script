#!/bin/bash
#parmeters for the RIS API
Regv_par='?Applikation=Regv&DokumenteProSeite=Ten'
Begut_par='?Applikation=Begut&BeschlussdatumVon=2013-10-29&BeschlussdatumBis=2017-11-08' #&DokumenteProSeite=Ten'

#curl -o ./data/Regv_data.json 'https://data.bka.gv.at/ris/api/v2.5/bundesgesetzblaetter'$Regv_par
Regv_name="$(cat ./data/Regv_data.json | jq '.OgdSearchResult.OgdDocumentResults.OgdDocumentReference[0].Data.Metadaten.Bundesgesetzblaetter.Titel')"
Regv_url_all="$(cat ./data/Regv_data.json | jq '.OgdSearchResult.OgdDocumentResults.OgdDocumentReference[0].Data.Metadaten.Allgemein.DokumentUrl')"
Regv_url_pdf="$(cat ./data/Regv_data.json | jq '.OgdSearchResult.OgdDocumentResults.OgdDocumentReference[0].Data.Dokumentliste.ContentReference[0].Urls.ContentUrl[1].Url')"
