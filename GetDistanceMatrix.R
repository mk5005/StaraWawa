# Library to calculate routing distances betweeen heritage all heritage points

library("XML")
library("jsonlite")

#transforming kml data format to pleasant list
GetDataFromKml<-function(pidfrom,pidto,pnamefrom, pnameto,pfromlat,pfromlon, ptolat,ptolon ,kml){
  pdistance<-kml$Document$distance
  ptraveltime<-kml$Document$traveltime
  pcoordinates<-kml$Document$Folder$Placemark$LineString$coordinates
  kmlshort<-list(idfrom=pidfrom,idto=pidto,namefrom=pnamefrom, nameto=pnameto , fromlat=pfromlat, fromlon=pfromlon, tolat=ptolat, tolon=ptolon ,distance=pdistance,traveltime=ptraveltime, coordinates=pcoordinates)
  return(kmlshort)
}

#Create requesto  to YOURS API  routing service 
CreateRequest<-function(flat,flon,tlat,tlon){
  cbeg<-"http://www.yournavigation.org/api/1.0/gosmore.php?format=kml&"
  cflat<-paste("flat=",as.character(flat),sep="")
  cflon<-paste("flon=",as.character(flon),sep="")
  ctlat<-paste("tlat=",as.character(tlat),sep="")
  ctlon<-paste("tlon=",as.character(tlon),sep="")
  cfin<-"v=bicycle&fast=0&layer=mapnik"
  request<-paste(cbeg,cflat,"&",cflon,"&",ctlat,"&",ctlon,"&",cfin,sep="")
  return(request)
  
}




#Calculating optimal routing betweeen all  heritage points
raw<-chosen_100copy
distances.list<-list()
l<-1
for (i in 1:nrow(raw)){
  for (k in (1:nrow(raw))){
    request<-CreateRequest(raw[i,"latitude"],raw[i,"longitude"],raw[k,"latitude"],raw[k,"longitude"])
    print(paste(as.character(i), as.character(k), sep=" "))
    response<-xmlToList(request)
    distances.list[[l]]<-response
    distances.list[[l]]$fromid<-raw[i,"id"]
    distances.list[[l]]$toid<-raw[k,"id"]
    distances.list[[l]]$fromname<-raw[i,"name"]
    distances.list[[l]]$toname<-raw[k,"name"]
    distances.list[[l]]$fromlat<-raw[i,"latitude"]
    distances.list[[l]]$fromlon<-raw[i,"longitude"]
    distances.list[[l]]$tolat<-raw[k,"latitude"]
    distances.list[[l]]$tolon<-raw[k,"longitude"]
    
    l<-l+1
  }
}

#Creating output list
distances.ready<-list()
for (i in 1:length(distances.list)){
  
  distances.ready[[i]]<-GetDataFromKml(distances.list[[i]]$fromid, distances.list[[i]]$toid, distances.list[[i]]$fromname, distances.list[[i]]$toname, distances.list[[i]]$fromlat,distances.list[[i]]$fromlon, distances.list[[i]]$tolat,distances.list[[i]]$tolon, distances.list[[i]] )
 
}

#Creating same output, but in data frame format
distances.df<-data.frame()
for (i in 1:length(distances.ready)){
  distances.df[i,"id_start"]<-as.character(distances.ready[[i]]["idfrom"])
  distances.df[i,"id_end"]<-as.character(distances.ready[[i]]["idto"])
  distances.df[i,"distance_km"]<-distances.ready[[i]]["distance"]
  distances.df[i,"time"]<-distances.ready[[i]]["traveltime"]
  distances.df[i,"path"]<-distances.ready[[i]]["coordinates"]
  
}

#Saving result in current working directory
save(distances.df, file="distances.df1000.RData" )
save(distances.ready, file="distances100copy.RData")


