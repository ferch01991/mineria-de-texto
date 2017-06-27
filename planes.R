library(DBI)
library(RMySQL)
library(NLP)
library(tm)
library(hunspell)
library(SnowballC)
library(slam)
library(RWeka)

#db = "pruebaPlanes"
db = "planesdocentesdb"
db_host = "localhost"
db_port = 3306
db_user = "root"
db_pass = ""

conn = dbConnect(MySQL(), user=db_user, password=db_pass, dbname=db, host=db_host)
planDocente = "SELECT * FROM pac_actividades"
consulta = dbGetQuery(conn, planDocente)

setwd("C:\\Users\\FernandoH\\Documents\\corpusPlanes")
consulta[1, ]
periodos =  unique(consulta$periodo_academico)
titulaciones =  unique(consulta$titulacion)
pac = unique(consulta[,2])
# filtrar datos de un periodo
periodo1 = subset(consulta, (periodo_academico == periodos[1]))

p = 0
for(directorio in list.files()){
  p = p+1
  datos = subset(consulta, (periodo_academico == periodos[p]))
  for(titulacion in unique(datos$titulacion)){
    carpeta = paste(directorio, titulacion, sep = "/")
    dir.create(carpeta, showWarnings = TRUE)
  } 
  datos = 0
}

datos = subset(consulta, (periodo_academico == periodos[8]))
for(titulacion in unique(datos$titulacion)){
  carpeta = paste(list.files()[5], titulacion, sep = "/")
  dir.create(carpeta, showWarnings = TRUE)
}


conn = dbConnect(MySQL(), user=db_user, password=db_pass, dbname=db, host=db_host)
queryIdPlanes = "SELECT Distinct pac_id FROM pac_actividades"
consulta = dbGetQuery(conn, queryIdPlanes)
for(i in 1:length(consulta$pac_id)){
  queryActividades = sprintf("SELECT pac_id, nom_componente, act_descripcion, periodo_academico FROM pac_actividades WHERE pac_id = %s", consulta$pac_id[i])
  actividades = dbGetQuery(conn, queryActividades)
  archivo = sprintf("C:\\Users\\FernandoH\\Documents\\planesDocentes2\\%s_%s_%s.txt", actividades$pac_id[1], gsub(":","",actividades$nom_componente[1]) , gsub("/","",actividades$periodo_academico[1]))
  #print(archivo)
  write(actividades$act_descripcion, archivo)
}

on.exit(dbDisconnect(conn))





dir.create("C:\\Users\\FernandoH\\Documents\\planesDocentes2")

planesId = consulta$pac_id
planesId = unique(planesId)

actividades = ""
for(i in 1:3){
  for(j in 1:100){
   if(planesId[i] == consulta$pac_id[j]){
     aux = consulta$act_descripcion[j]
     actividades = paste(actividades, aux, planesId[i], j, "-")
     
   }
  }
  print(actividades)
  actividades = ""
}






archivo = sprintf("C:\\Users\\FernandoH\\Documents\\planesDocentes\\%s_%s.txt", componente, gsub("/","",periodo))
#archivo = sprintf("//home//ferch01991//Documentos//PlanesDocentes//%s_%s.txt", componente, gsub("/","",periodo))
write(actividadClase$ActividadesClase, archivo)





actividadesPlanes = consulta$Actividades

#convertir los datos en un corpus
actividadesPlanes = Corpus(VectorSource(actividadesPlanes))

# remover enlaces web 
removeURL <- function(x) gsub("http[[:alnum:][:punct:]]*", "", x) 
actividadesPlanes = tm_map(actividadesPlanes, content_transformer(removeURL))

#espacio a los signos de puntuacion palabra(palabra)
espacio = content_transformer(function(x, pattern) gsub(pattern, " ", x))
actividadesPlanes = tm_map(actividadesPlanes, espacio, "[[:punct:]]+")

#Removemos los signos de puntuación
actividadesPlanes = tm_map(actividadesPlanes, removePunctuation)
#Removemos los numeros
actividadesPlanes = tm_map(actividadesPlanes, removeNumbers)
#convertimos las letras a minusculas
actividadesPlanes = tm_map(actividadesPlanes, tolower)
#removemos los stopwords
actividadesPlanes = tm_map(actividadesPlanes, removeWords, stopwords("spanish"))
#actividadesPlanes = tm_map(actividadesPlanes, removeWords, stopwords("spanish2"))
#remove de caracteres 
actividadesPlanes = tm_map(actividadesPlanes, removeWords, c("i", "ii"))
#stemming reduce una palabra a su raiz
docs = tm_map(actividadesPlanes, stemDocument, language="spanish")
# remove de espacios dobles
actividadesPlanes = tm_map(actividadesPlanes, stripWhitespace)



# planes que no tienen actividades 
# CONVERGENCIA DE PANTALLAS: DIVERSIDAD DE VISIONES - SEMINARIO INTERNACIONAL ALIMENTOS IBEROAMERICANOS - INGENIERIA DE PROYECTOS Y GESTIÓN DEL CONOCIMIENTO - INGENIERIA DE PROYECTOS Y GESTIÓN DEL CONOCIMIENTO
# CURSO DE INDUCCIÓN UNIVERSITARIA - TECNICAS ESTADISTICAS PARA LA TOMA DE DECISIONES - RUSO I - PORTUGUES - CONJUNTO CORAL - CONSERVACIÓN DE LA NATURALEZA Y DIVERSIDAD ANIMAL
# TRABAJO DE FIN DE CARRERA GP 4.1 - RETÓRICA, TEORÍA DE LA ARGUMENTACIÓN Y ORATORIA - REDACCION PARA RELACIONES PUBLICAS - ARTE INTERPRETATIVO
# VOLEIBOL - ESTADÍSTICA APLICADA - GESTIÓN DE RESIDUOS SÓLIDOS URBANOS - PREPARACIÓN Y CARACTERIZACIÓN DE CATALIZADORES - CAMPILOBACTER, SALUD HUMANA Y ALIMENTOS
# 