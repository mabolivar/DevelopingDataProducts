#=========================================================
#Set working directory
#=========================================================
setwd("C:/Users/ma.bolivar643/Dropbox/3. DSS/DevelopingDataProducts")

#=========================================================
# Libraries
#=========================================================
library(readr)
library(dplyr)
library(stringr)
#=========================================================


files <- dir("./data")


d <- tbl_df(data.frame())
for(file in files){
  print(file)
  cols <- read_csv(paste0("./data/",file), col_names = T,
                   n_max = 1,skip = 1,progress = T) %>% ncol
  ty <-paste(rep("c",cols),collapse = "")
  
  d <- read_csv(paste0("./data/",file), col_names = T,
                col_types=ty,skip = 1) %>%
    bind_rows(d)
}

#Remove empty columns
nas <- apply(d,2,function(x) sum(is.na(x)))
v <- names(nas[nas>=1000])
d <- d[,!names(d)%in%v]
d$precio_price <- as.numeric(d$precio_price)
d$campos_values

e <- select(d,contains("campos_values"), 
            contains("precio"),contains("titulooferta"))
names(e) <- sub("/","",names(e))
rows <- is.na(e$campos_values)

e$campos_values[rows] <- e$campos_values_1[rows]
e$campos_values[rows] <- e$campos_values_2[rows]
e$campos_values_numbers[rows] <- e$campos_values_1_numbers[rows]
e$campos_values_numbers[rows] <- e$campos_values_2_numbers[rows]
e$`titulooferta_link_text`[rows] <- e$`titulooferta_link_1_text`[rows]

apply(e,2,function(x) sum(!is.na(x)))

f <- select(e,
            campos_values,
            price = precio_price,
            published = precio_value,
            title = titulooferta_link_text) %>% filter(!is.na(campos_values))
#Published date
f$published <- sub("Publicado: ","",f$published) %>%
  as.Date(format = "%d/%m/%Y")

#Neighborhood
f$title <- toupper(f$title)
f$title <- sub("[:punct:]","",f$title) 


neigh <- sapply(f$title,function(x){str_split(x,pattern = "[[:space:][:punct:]]")[[1]][1:4]})
dput(names(table(neigh)[table(neigh)>10]))
neighlist <- c("CHAPINERO", "ROSALES","TEUSAQUILLO",
               "CAMACHO", "CASTILLO",
               "EMAUS", "GALERIAS","GRANADA",
               "JAVERIANA","MARLY", "PALERMO", "SOLEDAD")
f$neigh <- sapply(f$title,function(x){
  l <- str_split(x,pattern = "[[:space:][:punct:]]")[[1]][1:4]
  l[min(which(l%in%neighlist))]
})
f$neigh <- as.factor(f$neigh)

#Other information

m <- regexec("Área ([0-9]*)",f$campos_values[1])
regmatches(f$campos_values[1], m)[[1]][2]

pattern <- "Área ([0-9]*)"
area <- lapply(regmatches(f$campos_values, gregexpr(pattern, f$campos_values)), 
       function(e) regmatches(e, regexec(pattern, e))) %>%
  sapply(function(x) ifelse(is.null(unlist(x)[2]),NA,unlist(x)[2]))
f$area <- area

pattern <- "Baños ([0-9]*)"
bathr <- lapply(regmatches(f$campos_values, gregexpr(pattern, f$campos_values)), 
               function(e) regmatches(e, regexec(pattern, e))) %>%
  sapply(function(x) ifelse(is.null(unlist(x)[2]),NA,unlist(x)[2]))
f$bathr <- bathr

pattern <- "Hab. ([0-9]*)"
rms <- lapply(regmatches(f$campos_values, gregexpr(pattern, f$campos_values)), 
                function(e) regmatches(e, regexec(pattern, e))) %>%
  sapply(function(x) ifelse(is.null(unlist(x)[2]),NA,unlist(x)[2]))
f$rms <- rms


#Tidy data
t <- select(f, price,
            published,
            neigh,area,
            bathr, rms)

#export tidy data
write_csv(t,"./data/tidy.csv")
