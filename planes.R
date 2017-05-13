library(DBI)
library(RMySQL)
library(NLP)
library(tm)
library(hunspell)
library(SnowballC)

#db = "pruebaPlanes"
db = "planesdocentesdb"
db_host = "localhost"
db_port = 3306
db_user = "root"
db_pass = ""

conn = dbConnect(MySQL(), user=db_user, password=db_pass, dbname=db, host=db_host)
queryTabla1 = "SELECT pac_id, nom_componente, act_descripcion, periodo_academico FROM pac_actividades"
consulta = dbGetQuery(conn, queryTabla1)
on.exit(dbDisconnect(conn))


dir.create("C:\\Users\\FernandoH\\Documents\\planesDocentes")

planesId = consulta$pac_id
planesId = unique(planesId)
i =1
planesId = unique(consulta$pac_id)

i = 1

for(i in 1:length(planesId)){
  for(j in 1:length(consulta$pac_id)){
   if(planesId[i] == consulta$pac_id[j]){
     a = sprintf("%s - %s - %s - %s", consulta$pac_id[j], consulta$nom_componente[j], consulta$act_descripcion[j], consulta$periodo_academico[j])
     print(a)
   }else{
     
   } 
  }
  print("salto")
}

for(i in 2)




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