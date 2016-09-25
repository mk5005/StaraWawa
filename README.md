---
title: "Dokumentacja StaraWawa"
author: "MBS_WAW"
date: "25 września 2016"
output: html_document
---

## Przygotowanie danych

Raz w tygodniu zgodnie z aktualizacją bazy danych [Otwarte Zabytki](http://otwartezabytki.pl/) wymagane jest ponowne uruchomienie następujących skryptów:

1. CreateTable.R
2. MonumentsSelection.R
3. GetDistanceMatrix.R
4. Veturilo.R


Wynikiem uruchomienia tych skryptów są następujące obiekty data.frame:

1. heritage.short.df
2. heritage.df
3. distances.df
4. veturilo.df

Oraz lista:

5. distances.ready


## Aplikacja

Aplikacja składa się z 3 głównych plików (server.R, ui.R, global.R) oraz funkcji pomocniczych. Wszystkie pliki znajdują się w katalogu StaraWawa.

Użytkownik wybiera interesujące go zabytki z listy. Istnieje możliwość filtrowania zabytków wg kryteriów tematycznych. Użytkownikowi jest przedstawiana na mapie  optymalna pod względem odległości trasa rowerowa pomiędzy wybranymi zabytkami. Dodatkowo na mapie pokazywane są najbliższe stacje Veturilo w pobliżu wybranych zabytków.  


