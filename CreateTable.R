library("jsonlite")
library("dplyr")
library("tidyr")

#list all files in current folder
files.list<-list.files()

#Load data to Json list
heritage.list<-list()
for (i in 1:length(files.list)){
  temp<-fromJSON(as.character(files.list[i]))
  heritage.list[[i]]<-temp
}

#Loading data to heritage data frame
heritage.df<-data.frame()
k<-1
for (i in 1:length(heritage.list)){
  try({
  if (heritage.list[[i]]["place_name"]=="Warszawa") {
    heritage.df[k,"id"]<-heritage.list[[i]]["nid_id"]
    heritage.df[k,"nid"]<-as.numeric(heritage.list[[i]]["nid_id"])
    heritage.df[k,"name"]<-heritage.list[[i]]["identification"]
    heritage.df[k,"latitude"]<-heritage.list[[i]]["latitude"]
    heritage.df[k,"longitude"]<-heritage.list[[i]]["longitude"]
    heritage.df[k,"place_id"]<-as.numeric(heritage.list[[i]]["place_id"])
    heritage.df[k,"place_name"]<-heritage.list[[i]]["place_name"]
    heritage.df[k,"commune_name"]<-heritage.list[[i]]["commune_name"]
    heritage.df[k,"district_name"]<-heritage.list[[i]]["district_name"]
    heritage.df[k,"common_name"]<-heritage.list[[i]]["common_name"]
    heritage.df[k,"description"]<-heritage.list[[i]]["description"]
    heritage.df[k,"dating_of_obj"]<-heritage.list[[i]]["dating_of_obj"]
    heritage.df[k,"street"]<-heritage.list[[i]]["street"]
    heritage.df[k,"state"]<-heritage.list[[i]]["state"]
    print(heritage.df[k,"nid"])
    k<-k+1
  }
  })
}

#creating categories column
categories.df<-data.frame()
k<-1
for (i in 1:length(heritage.list)){
  try({
    if (heritage.list[[i]]["place_name"]=="Warszawa") {
        len<-length(heritage.list[[i]]["categories"][[1]])
        for (l in 1:len){
           categories.df[k,"id"]<-heritage.list[[i]]["nid_id"]
           categories.df[k,"category"]<-heritage.list[[i]]["categories"][[1]][l]
           k<-k+1
        }
    }
  })
}
#Long to wide data format
categories.df$bool<-TRUE
categories.df2<-unique(categories.df)
categories_spreaded<-spread(categories.df2, category, bool, drop=FALSE, fill = FALSE )
heritage.df<-left_join(heritage.df, categories_spreaded)

#Saving data in current directory
save(heritage.df, file="heritagedf.RData")
write.csv2(heritage.df, "heritage.csv")

