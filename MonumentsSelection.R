
# Copyright 2016 Joanna Mąkosa, Anna Skrzydło, Aleksandra Magiełda, Michał Kot, Mateusz Kiryła, Bartosz Kowalski, Klaudia Stano
# Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file
# except in compliance with the License. You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software distributed under the
# License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS
# OF ANY KIND, either express or implied. See the License for the specific language governing
# permissions and limitations under the License. 
# 
# Copyright 2016 Joanna Mąkosa, Anna Skrzydło, Aleksandra Magiełda, Michał Kot, Mateusz Kiryła, Bartosz Kowalski, Klaudia Stano
# Licensed under the CC BY-SA 3.0 (the "License"); you may not use this file except in
# compliance with the License. You may obtain a copy of the License at
# https://creativecommons.org/licenses/by-sa/3.0/pl/legalcode
# Unless required by applicable law or agreed to in wri ng, so ware distributed under the
# License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS
# OF ANY KIND, either express or implied. See the License for the specific language
# governing permissions and limitations under the License." WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.



#### Data reading ####
# raw<- read.csv2("C:/Users/klaudia.stano/Downloads/heritage_final.csv")
load("heritagedf.Rdata")
raw <- heritage.df

#### Data selection ####
# for the prototype version of the application we excluded those monuments in Warsaw that could not be easily located on the map (e.g. house estates, districts, statues etc.) or were not very distinctive (private houses, villas etc.)

raw <- raw[-grep("Założenie urbanistyczne", raw$name),]
raw <- raw[-grep("Układ urbanistyczny", raw$name),]
raw <- raw[-grep("układ urbanistyczny", raw$name),]
raw <- raw[-grep("zespół urbanistyczny", raw$name),]
raw <- raw[-grep("Osiedle", raw$name),]
raw <- raw[-grep("Osielde", raw$name),]
raw <- raw[-grep("Kolonia", raw$name),]
raw <- raw[-grep("Saska Kępa", raw$name),]
raw <- raw[-grep("Żoliborz historyczny", raw$name),]

raw <- subset(raw, !(raw$name == "Dom"))
raw <- subset(raw, !(raw$name == "Dom wielorodzinny"))
raw <- subset(raw, !(raw$name == "Dom (segment)"))
raw <- subset(raw, !(raw$name == "Dom (oficyna)"))
raw <- subset(raw, !(raw$name == "Zespół‚ 2 domów"))
raw <- subset(raw, !(raw$name == "Zespół‚ domów"))
raw <- subset(raw, !(raw$name == "Zespół‚ domu"))
raw <- subset(raw, !(raw$name == "Zespół‚ domu (bliźniak)"))
raw <- subset(raw, !(raw$name == "Zespół‚ domu (segment)"))
raw <- subset(raw, !(raw$name == "Kamienica"))
raw <- subset(raw, !(raw$name == "Zespół‚ kamienicy"))
raw <- subset(raw, !(raw$name == "Kamienica (z oficynami)"))
raw <- subset(raw, !(raw$name == "Kamienica frontowa"))
raw <- subset(raw, !(raw$name == "Kamienica z oficyną"))
raw <- subset(raw, !(raw$name == "Kamienica z oficynami"))
raw <- subset(raw, !(raw$name == "Kamienica ze skrzydłami"))
raw <- subset(raw, !(raw$name == "Kamienica, ob. biura"))
raw <- subset(raw, !(raw$name == "Kamienica, ob. biblioteka"))
raw <- subset(raw, !(raw$name == "Willa"))
raw <- subset(raw, !(raw$name == "Zespół‚ willi"))
raw <- subset(raw, !(raw$name == "Zespoł‚ willi (segment)"))
raw <- subset(raw, !(raw$name == "Willa letniskowa"))
raw <- subset(raw, !(raw$name == "Willa bliźniacza"))
raw <- subset(raw, !(raw$name == "Willa (segment)"))
raw <- subset(raw, !(raw$name == "Willa (elewacje)"))
raw <- subset(raw, !(raw$name == "Willa (elewacje)"))
raw <- subset(raw, !(raw$name == "Dom mieszkalny"))
raw <- subset(raw, !(raw$name == "Zespół‚ Twierdzy Warszawa"))
raw <- subset(raw, !(raw$name == "Budynek"))
raw <- subset(raw, !(raw$name == "Zabudowa"))
raw <- subset(raw, !(raw$name == "Dworek"))
raw <- subset(raw, !(raw$name == "Dom, część Kolonii Łaskiego"))
raw <- subset(raw, !(raw$id == "626279" & raw$name == "Zespół‚ dworski"))
raw <- subset(raw, !(raw$id == "625246" & raw$name == "Zespół‚ dworski"))
raw <- subset(raw, !(raw$id == "625738" & raw$name == "Zespół‚ dworski"))
raw <- subset(raw, !(raw$name == "Zespół‚ dworski Wyczółki (I)"))
raw <- subset(raw, !(raw$name == "Zabudowa parzystej strony"))
raw <- subset(raw, !(raw$name == "Dom Jana Toeplitza"))
raw <- subset(raw, !(raw$name == "Mostek"))
raw <- subset(raw, !(raw$name == "Figura Matki Boskiej Passawskiej"))
raw <- subset(raw, !(raw$name == "Dom rodziny Avenariusów"))
raw <- subset(raw, !(raw$street == ""))
raw <- subset(raw, !(raw$id == "625308" & raw$name == "Szkoła"))
raw <- subset(raw, !(raw$id == "625419" & raw$name == "Zespół‚ szkoły"))
raw <- subset(raw, !(raw$name == "3 mogiły na cmentarzu"))
raw <- raw[-grep("Pomnik", raw$name),]
# raw <- raw[-grep("pomnik", raw$name),]


#### Changing ambiguous names (in order not to have duplicates) ####

raw$name <- as.character(raw$name)

raw[which(raw$id == "625680"),]$name <- "Hotel Bristol"
raw[which(raw$id == "625648"),]$name <- "Hotel Europejski"
raw[which(raw$id == "625050"),]$name <- "Zdrójj Królewski"
raw[which(raw$id == "625271"),]$name <- "Szkoła Pod Mądrą Sową"
raw[which(raw$id == "626588"),]$name <- "Liceum i Gimnazjum im. Prusa"
raw[which(raw$id == "625050"),]$name <- "Zdrój Królewski"
raw[which(raw$id == "625814"),]$name <- "Wyższe Seminarium Duchowne Diecezji Warszawsko-Praskiej"
raw[which(raw$id == "625762"),]$name <- "Pałacyk ks. Wasyla Dołgorukowa (ob. Ambasada SĹ‚owacji)"
raw[which(raw$id == "625772"),]$name <- "Pałacyk StanisĹ‚awa Ursyna-Rusieckiego"
raw[which(raw$id == "625891"),]$name <- "Pałacyk Branickich-Lubomirskich"

raw[which(raw$id == "626089"),]$name <- "Dawny szpital Św. Ducha"
raw[which(raw$id == "626429"),]$name <- "Figura św. Jana Nepomucena (1756)"
raw[which(raw$id == "626272"),]$name <- "Figura św. Jana Nepomucena (1731)"
raw[which(raw$id == "625623"),]$name <- "Zespół‚ koszar (ul. Kozielska)"
raw[which(raw$id == "625754"),]$name <- "Zespół‚ koszar (11 listopada)"
raw[which(raw$id == "730748"),]$name <- "Piwnice willi Jasny Dom"
raw[which(raw$id == "625227"),]$name <- "Liceum LXXV im. Jana III Sobieskiego"
raw[which(raw$id == "624832"),]$name <- "Zespół‚ klasztorny bernardynów (Parafia św. Bonifacego)"
raw[which(raw$id == "625140"),]$name <- "Dawny Gmach Towarzystwa Kredytowego Miejskiego"
raw[which(raw$id == "625642"),]$name <- "Wydział Dziennikarstwa i Nauk Politycznych (d. Teologicum)"
raw[which(raw$id == "626171"),]$name <- "Dwór drewniany (poĹ‚. XIX wieku)"
raw[which(raw$id == "624910"),]$name <- "Cmentarz Wilanowski"
raw[which(raw$id == "718434"),]$name <- "Garaż Zakładu Oczyszczania Miasta, ob. Teatr Nowy"
raw[which(raw$id == "626289"),]$name <- "Dawny pawilon szpitala Czerwonego Krzyża"
raw[which(raw$id == "741226"),]$name <- "Kino Ochota, ob. Och-Teatr"
raw[which(raw$id == "625226"),]$name <- "Dawny Dom Pracowników Stacji Pomp Rzecznych"
raw[which(raw$id == "741264"),]$name <- "SOHO Factory"
raw[which(raw$id == "626424"),]$name <- "Dawny Zespół Budynków Mieszkalnych PKP"
raw[which(raw$id == "738728"),]$name <- "Dawna remiza tramwajowa"
raw[which(raw$id == "726457"),]$name <- "Dawny Zespół Miejskich Zakładów Sanitarnych"
raw[which(raw$id == "625933"),]$name <- "Kamienica Mirosławska, ob. Muzeum Historyczne XVII"
raw[which(raw$id == "626236"),]$name <- "Kamienica Falkiewiczowska, Muzeum Historyczne XV"
raw <- subset(raw, !(raw$name == "Kamienica, ob. Muzeum Historyczne"))


#### Adding Wikipedia links ####
wikipedia_dictionary <- read.csv2("C:/Users/klaudia.stano/Desktop/wikipedia_dictionary.csv")
wikipedia_dictionary$link <- ifelse(wikipedia_dictionary$Haslo == "", "", paste0("https://pl.wikipedia.org/wiki/", gsub(" ", "_", wikipedia_dictionary$Haslo)))

set.seed(1992)
chosen_100 <- heritage.short.df[sample(nrow(heritage.short.df), 100), ]

chosen_100_wiki <- merge(chosen_100, wikipedia_dictionary, by = "id")
chosen_100_wiki_ordered <- chosen_100_wiki[,c(2,1,3:36)]

#### Adding photo dictionary ####
photo_dictionary <- read.csv2("C:/Users/klaudia.stano/Desktop/photo_dictionary.csv")
photo_dictionary$photo_link <- as.character(photo_dictionary$photo_link)

chosen_100_wiki_photo <- merge(chosen_100_wiki, photo_dictionary, by = "id", all.x = T)
chosen_100_wiki_photo_ordered <- chosen_100_wiki_photo[,c(2,1,3:37)]
heritage.short.df$photo_link <- as.character(heritage.short.df$photo_link)

chosen_100_wiki_photo_ordered$final_link <- ifelse(chosen_100_wiki_photo_ordered$link == "", chosen_100_wiki_photo_ordered$photo_link, chosen_100_wiki_photo_ordered$link)

heritage.short.df <- chosen_100_wiki_photo_ordered
heritage.short.df$final_link <- as.character(heritage.short.df$final_link)
heritage.short.df$link <- NULL
heritage.short.df$photo_link <- NULL

save(heritage.short.df, file = "heritage_short_final.Rda")
write.csv2(heritage.short.df, file = "heritage_short_final.csv", row.names = F)

