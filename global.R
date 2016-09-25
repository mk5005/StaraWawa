library(shinydashboard)
library(leaflet)
library(RJSONIO)
library(TSP)
library(XML)

source('additional_functions.R')
source('RouteOptimizer.R')
source('createMapFin.R')
load("distances.df.RData")
load("heritage_short_final.Rda")
load("veturilo_final.RData")

#options(shiny.error = browser)

heritage.short.df$inny <- FALSE   
for (row in 1:nrow(heritage.short.df)) {
    sum.significant.categories <- 0
    for (col in c(18:21, 23:31, 33:34)) {
        sum.significant.categories <- sum.significant.categories + as.numeric(heritage.short.df[row, col])
    }
    if (sum.significant.categories == 0) {
        heritage.short.df$inny <- TRUE
    }
}

heritage.short.df$active_link <- enc2utf8(paste0('<a href="', heritage.short.df$link, '">', heritage.short.df$name, '</a>'))

# heritage.short.df <- heritage.short.df[1:20, ]
categories.list <- colnames(heritage.short.df[, c(18:21, 23:31, 33:34, 37)])
names(categories.list) <- c("Budynek gospodarczy", "Cmentarz", "Dwór/Pałac/Zamek", "Katolicki",
                            "Budynek mieszkalny", "Militarny", "Muzułmański", "Park/Ogród", 
                            "Prawosławny", "Protestancki", "Budynek przemysłowy", "Sakralny", 
                            "Sportowy/Kulturalny/Edukacyjny", "Budynek uzyteczności publicznej",
                            "Żydowski", "Inny")

categories.list <- sort(categories.list)



# commune.list <- factor(heritage.short.df$place_id, levels = unique(heritage.short.df$place_id), labels = unique(heritage.short.df$commune_name))
# 
# commune.list <- unique(commune.list)
# 
