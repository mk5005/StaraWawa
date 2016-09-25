#Calculate distances function using YOORS API

library("XML")
CalculateDistance<-function(flat,flon,tlat,tlon){
  
  CreateRequest<-function(pflat,pflon,ptlat,ptlon){
    
    cbeg<-"http://www.yournavigation.org/api/1.0/gosmore.php?format=kml&"
    cflat<-paste("flat=",as.character(pflat),sep="")
    cflon<-paste("flon=",as.character(pflon),sep="")
    ctlat<-paste("tlat=",as.character(ptlat),sep="")
    ctlon<-paste("tlon=",as.character(ptlon),sep="")
    cfin<-"v=bicycle&fast=0&layer=mapnik"
    request<-paste(cbeg,cflat,"&",cflon,"&",ctlat,"&",ctlon,"&",cfin,sep="")
    return(request)
    
  }
  
  GetDataFromKml<-function(kml){
    
    pdistance<-kml$Document$distance
    ptraveltime<-kml$Document$traveltime
    pcoordinates<-kml$Document$Folder$Placemark$LineString$coordinates
    kmlshort<-list(distance=pdistance,traveltime=ptraveltime, coordinates=pcoordinates)
    return(kmlshort)
  }
  
  
  request<-CreateRequest(flat,flon,tlat,tlon)
  response<-xmlToList(request)
  result<-GetDataFromKml(response)
  
}

