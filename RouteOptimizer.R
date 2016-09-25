
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



RouteOptimizer <- function(distances.df, selected.df, start.lon, start.lat, end.lon, end.lat){
    heritage.list <- c(selected.df$id, "dummy")
    selected.distances <- distances.df[which(distances.df$id_start %in% selected.df$id & distances.df$id_end %in% selected.df$id),]
    
    
    if(!is.null(start.lon)){
        
        heritage.list <- c("-001", heritage.list)
        new.distances <- data.frame(id_start = "-001", id_end = selected.df$id, distance_km = NA, time = NA)
        new.distances2 <- data.frame(id_start = selected.df$id, id_end = "-001", distance_km = NA, time = NA)
        selected.distances <- rbind(selected.distances, new.distances, new.distances2)
        rm(new.distances)
        rm(new.distances2)
        selected.df <- rbind(c("-001", start.lon, start.lat), selected.df)
    }
    
    if(!is.null(end.lon)){
        
        heritage.list <- c(heritage.list, "-007")
        new.distances <- data.frame(id_start = "-007", id_end = selected.df$id, distance_km = NA, time = NA)
        new.distances2 <- data.frame(id_start = selected.df$id, id_end = "-007", distance_km = NA, time = NA)
        selected.distances <- rbind(selected.distances, new.distances, new.distances2)
        
        rm(new.distances)
        rm(new.distances2)
        selected.df <- rbind(selected.df, c("-007", start.lon, start.lat))
    }
    
    
    
    ######dodanie wierszy z odleglosciami miedzy wybranymi zabytkami a miejscem poczatka i konca trasy
    
    if(!is.null(start.lon) | !is.null(end.lon)){
        for(i in (nrow(distances.df[which(distances.df$id_start %in% selected.df$id & distances.df$id_end %in% selected.df$id),]) + 1):nrow(selected.distances)){
            dist <- CalculateDistance(as.numeric(selected.df$latitude[which(selected.df$id == selected.distances$id_start[i])]), as.numeric(selected.df$longitude[which(selected.df$id == selected.distances$id_start[i])]),  as.numeric(selected.df$latitude[which(selected.df$id == selected.distances$id_end[i])]) ,as.numeric(selected.df$longitude[which(selected.df$id == selected.distances$id_end[i])]))
            selected.distances$distance_km[i] <- dist$distance
            selected.distances$time[i] <- dist$traveltime
        } 
    }
    
    
    selected.distances <- rbind(data.frame(id_start = "dummy", id_end = selected.df$id, distance_km = 0, time = 0), selected.distances)
    selected.distances <- rbind(data.frame(id_start = selected.df$id, id_end = "dummy", distance_km = 0, time = 0), selected.distances)
    #selected.distances$distance_km[which(is.na(selected.distances$distance_km))] <- 5   
    
    
    selected.distances$distance_km[which(selected.distances$id_start == "-007" & selected.distances$id_end == "-001")] <- 0
    selected.distances$distance_km[which(selected.distances$id_end == "-007")] <- 10^10
    
    ##############
    
    data <- data.frame(matrix(0, length(heritage.list), length(unique(heritage.list))))
    names(data) <- heritage.list
    row.names(data) <- heritage.list
    
    for(i in heritage.list){
        for(j in heritage.list){
            if(!i == j){
                data[which(row.names(data) == i), which(names(data) == j)] <- selected.distances[which(selected.distances$id_start == i & selected.distances$id_end == j), 3] 
            }else{
                data[which(row.names(data) == i), which(names(data) == j)] <- 0  
            }
        }
    }
    
    data <- as.matrix(data)
    atsp <- ATSP(data)
    
    ## wyznaczanie trasy
    if(any(heritage.list %in% "-001") & any(heritage.list %in% "-007")){
        tour <- solve_TSP(atsp, method = "repetitive_nn", start = 1, end = length(heritage.list), rep = 4)
    }else if(any(heritage.list %in% "-001") & any(!heritage.list %in% "-007")){
        tour <- solve_TSP(atsp, method = "repetitive_nn", start = 1, rep = 4)
    }else{
        tour <- solve_TSP(atsp, method = "repetitive_nn", rep = 4)
    }
    
    tour <- as.matrix(tour)
    tour <- tour[which(!row.names(tour) == "dummy"),]
    tour <- as.data.frame(cbind(tour, seq(1, length(heritage.list)-1)))
    tour <- tour[order(tour[,1]),]
    route.df <- data.frame(id = selected.df[, 1], order = tour[,2])
    route.df$id <- as.character(route.df$id)
    route.df$order <- as.numeric(route.df$order)
    route.df <- data.frame(route.df, path = NA)
  
        route.df$path[which(route.df$id == "-001")] <- as.character(CalculateDistance(as.numeric(selected.df$latitude[which(selected.df$id == "-001")]), as.numeric(selected.df$longitude[which(selected.df$id == "-001")]), as.numeric(selected.df$latitude[which(selected.df$id == route.df$id[route.df$order == 2])]),  as.numeric(selected.df$longitude[which(selected.df$id == route.df$id[route.df$order == 2])]))$coordinates)
       
         route.df$path[which(route.df$id == "-007")] <- as.character(CalculateDistance(as.numeric(selected.df$latitude[which(selected.df$id == route.df$id[route.df$order == nrow(route.df) - 1])]), as.numeric(selected.df$longitude[which(selected.df$id == route.df$id[route.df$order == nrow(route.df) - 1])]), as.numeric(selected.df$latitude[which(selected.df$id == "-007")]),  as.numeric(selected.df$longitude[which(selected.df$id == "-007")]))$coordinates)
    
    return(route.df)
    
 }

  
