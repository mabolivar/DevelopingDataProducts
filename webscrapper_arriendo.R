library(rvest)
library(magrittr)

arriendos_elt <- html("http://clasificados.eltiempo.com/avisos/vivienda/arriendo/bogota/centro?query=Arriendo&rp=200&order=date_desc")

texto <- arriendos_elt %>% 
  html_nodes(".texto p") %>%
  html_text() 
texto


numero <- arriendos_elt %>% 
  html_nodes(".paso1 li") %>%
  html_text() 
numero

fecha <- arriendos_elt %>% 
  html_nodes(".ofertas h6") %>%
  html_text() 
fecha

#Chapinero
arriendos_elt <- html("http://clasificados.eltiempo.com/avisos/vivienda/apartamento/arriendo/bogota/chapinero?page=1&query=Arriendo&rp=200&order=date_desc")

#Titulo
titulo <- arriendos_elt %>% 
  html_nodes(".Titulo-Oferta") %>%
  html_text() 
titulo

#Texto
texto <- arriendos_elt %>% 
  html_nodes(".texto p") %>%
  html_text() 
texto

#Fecha
fecha <- arriendos_elt %>% 
  html_nodes(".ofertas h6") %>%
  html_text() 
fecha

#Precio
precio <- arriendos_elt %>% 
  html_nodes(".precio h3") %>%
  html_text() 
precio <- precio[!(precio == "Contacte al anunciante")]
precio <- sub("\\$","",precio)
precio <- gsub(",","",precio,fixed=T)
precio <- as.numeric(precio)

#Tipo de contacto
tcontacto <- arriendos_elt %>% 
  html_nodes(".clasificado .contactar")%>%
  html_text() 


caract <- arriendos_elt %>% 
  html_nodes(".ofertas .clasificado .campos")
m <- gregexpr("<li>(.*?)</li>",as.character(caract))
caract <- as.character(regmatches(as.character(caract), m))

#Hipervinculo
hlink <- arriendos_elt %>% 
  html_nodes(".clasificado .Titulo-Oferta a")
hlinks <- html_attr(hlink,"href")

hlink


#Número de telefono
numero <- arriendos_elt %>% 
  html_nodes(".clasificado .paso1 li") %>%
  html_text()

mtmp <- matrix(numero,nrow = length(numero)/2,ncol = 2,byrow = T)
numero <- paste(mtmp[,1],mtmp[,2],sep="-")

#Data frame
clas <- data.frame(titulo,texto,fecha,precio,numero=NA, caract, hlinks)
clas$numero[tcontacto=="Contactar"] <- numero
clas$fecha <- as.Date(sub("Publicado: ","",fecha),format ="%d/%m/%Y")

#Barrio
clas$titulo <- as.character(clas$titulo)
m<-regexpr("(.+) A[?:rR|P]",text = clas$titulo)
clas$barrio <- sub(" Ar","",regmatches(clas$titulo, m),ignore.case = T)
clas$barrio <- sub(" Venta y","",clas$barrio,ignore.case = T)
clas$barrio <- sub("  APARTAMENTO","",clas$barrio,ignore.case = T)
clas$barrio <- toupper(clas$barrio)
clas$barrio <- gsub(" ","",clas$barrio)


sort(table(clas$barrio))

library(ggplot2)

dput(names(table(clas$barrio))[table(clas$barrio)>=3])
mysearch <- subset(clas, barrio %in% c("CHAPINEROJAVERIANA", "CHAPINERO", "CHAPINEROALTO", 
                                       "CHAPINEROCENTRAL", "CHAPINERONORTE", "JAVERIANA", 
                                       "MARLY", "PARQUENACIONAL", "QUINTACAMACHO", 
                                       "TEUSAQUILLO"))
mysearch$barrio <- as.factor(mysearch$barrio)

mysearch <- subset(mysearch,precio <= 1000000 | is.na(precio))

write.table(mysearch,"clipboard",sep="|",row.names = F)
                                       
means <- sort(with(mysearch,tapply(precio, barrio, mean, na.rm=T))        )
means <- data.frame(means)
ggplot(data = mysearch ) + geom_boxplot(aes(barrio,precio)) +coord_flip()                   

barplot(barrio,data=mysearch)





