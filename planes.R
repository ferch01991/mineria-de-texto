library(DBI)
library(RMySQL)
library(NLP)
library(tm)
#library(hunspell)
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


################ crear diretorios ########################################
i = 1
periodo = periodos[i]
datos = subset(consulta, (periodo_academico == periodo))
for(titulacion in unique(datos$titulacion)){
  carpeta = paste(gsub("/", "", periodos[i]), titulacion, sep = "/")
  dir.create(carpeta, showWarnings = TRUE)
}

### ####################Organiar datos####################################
i = 5
periodo = list.files()[i]
for(p in 1:length(list.files(periodo))){
  datos = subset(consulta, (periodo_academico==periodos[8]) & (is.na(titulacion)))
  for(id in unique(datos$pac_id)){
    actividades = subset(datos, (pac_id==id))
    archivo = sprintf("%s\\%s\\%s_%s.txt", periodo, list.files(periodo)[p], actividades$pac_id[1], actividades$nom_componente[1])
    write(actividades$act_descripcion, archivo)
  }
}
##Datos que no pertenezcan a una titulacion
datos = subset(consulta, (periodo_academico==periodos[2]) & (is.na(titulacion)))
##########################################################

for(titulacion in unique(datos$titulacion)){
  datos2 = subset(consulta )
  archivo = sprintf("%s\\%s\\%s_%s.txt", gsub("/","",periodos[1]), titulacion )
  write(actividades$act_descripcion, archivo)
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