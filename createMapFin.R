
selectPaths<-function(distances.df, routePlus.df){
  
  selDist.df<-data.frame(id_start=character(), id_end=character(), path=character(), stringsAsFactors = FALSE)
  sId<-toString(routePlus.df[routePlus.df$order==1, 'id'])
  
  for (i in c(2:length(routePlus.df[[1]]))) {
    tId<-toString(routePlus.df[routePlus.df$order==i, 'id'])
    
    selDist.df[i-1,]<-c(sId, tId, toString(distances.df[distances.df$id_start==sId & distances.df$id_end==tId, 'path']))
    sId=tId
    }
  selDist.df
}

selVet<-function(routePlus.df, vet.df){
  selHeritage<-routePlus.df$id
  selVet.df<-vet.df[vet.df$heritage_id %in% selHeritage, c('Lokalizacja', 'lat', 'lon')]
  selVet.df
  
  }

createMap<-function(distance.df, routePlus.df, vet.df){
  require(leaflet)
  require(data.table)
  require(sp)
  
  distance.df<-selectPaths(distance.df, routePlus.df)
  
  mapa<-leaflet()
  mapa<-addTiles(mapa)
  
  for (i in c(1:length(routePlus.df[[1]]))) {
    cPoint<-list(name=routePlus.df$name[i], lat=routePlus.df$latitude[i], lon=routePlus.df$longitude[i], wikiUrl=routePlus.df$link_wikipedia[i])
    
    if (cPoint$wikiUrl!="") {
      popupHtml<-paste0("<b><a href='", cPoint$wikiUrl, "'>", cPoint$name, "</a></b>")
    } else {
      popupHtml<-paste0("<b>", cPoint$name, "</b>")
    }

    mapa<-addMarkers(mapa, lng=cPoint$lon, lat=cPoint$lat, popup=popupHtml)
  }
  
  bikeIcon<-makeIcon(
    iconUrl="http://i.imgur.com/TVcaDoV.png",
    iconWidth=32, iconHeight=32)
  
  vet.df<-selVet(routePlus.df, vet.df)
  
  if (length(vet.df[[1]])!=0) {
    for (i in c(1:length(vet.df[[1]]))) {
      cVetPoint<-list(name=vet.df$Lokalizacja[i], lon=vet.df$lon[i], lat=vet.df$lat[i])
      mapa<-addMarkers(mapa, lng=cVetPoint$lon, lat=cVetPoint$lat,
                       popup=cVetPoint$name, icon=bikeIcon)
    }
  }
  for (i in c(1:length(distance.df[[1]]))) {
    routeRaw<-distance.df$path[i]
    #print(routeRaw)
    route.df<-fread(routeRaw, sep=",", header=FALSE, col.names=c("lon", "lat"))
    route<-Line(route.df)
    
    mapa<-addPolylines(mapa, data=route, color="blue", weight=5) 
  }
  
  mapa
  
}
