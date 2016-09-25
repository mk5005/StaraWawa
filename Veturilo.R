#Veturillo
library("geosphere")
library("dplyr")
veturilo<-read.csv2("lokalizacje_veturilo.csv", as.is = TRUE)
veturilo$lat<-as.numeric(veturilo$Szer..geograficzna)
veturilo$lon<-as.numeric(veturilo$Dł..geograficzna)
veturilo.df<-data.frame()
l<-1
#preparing veturillo data
for (i in 1:nrow(chosen_100)){
  for (k in 1:nrow(veturilo)){
    distance<-distHaversine(c(chosen_100[i,"longitude"],chosen_100[i,"latitude"]),c(veturilo[k, "lon"],veturilo[k, "lat"]))#calculate geographical distance using haversine formula
    veturilo.df[l, "heritage_id"]<-chosen_100[i,"id"]
    veturilo.df[l, "veturilo_id"]<-veturilo[k,"Numer.stacji"]
    veturilo.df[l,"distance"]<-distance
    l<-l+1
  }
}

#filtering and preparing data
veturilo.df.grouped<-group_by(veturilo.df, heritage_id)
vet<-mutate(veturilo.df.grouped, m=dense_rank(distance))
vet<-arrange(vet,heritage_id, desc(distance))
vet_filtered<-filter(vet, m==1 | m==2 |m==3, distance<1000 | m==1)
vet_filtered$Numer.stacji<-vet_filtered$veturilo_id
Vet_joined<-left_join(vet_filtered,veturilo)
vet_final<-select(Vet_joined, heritage_id, veturilo_id, distance, Lokalizacja, Dzielnica, lat, lon)

#save
save(vet_final, file="veturilo_final.RData" )

  
  

