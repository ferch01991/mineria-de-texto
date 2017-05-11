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
queryTabla1 = "SELECT DISTINCT sga_codigo_com, nombre
               FROM pac_actividades LEFT JOIN qr_componente_edu ON sga_codigo_com = codigo
               WHERE nom_componente IS NULL;"
consulta = dbGetQuery(conn, queryTabla1)

for(i in 1:length(consulta$sga_codigo_com)){
  actDatos = sprintf("UPDATE pac_actividades SET nom_componente = '%s' WHERE sga_codigo_com = '%s'", consulta$nombre[i], consulta$sga_codigo_com[i])
  print(actDatos)
  dbGetQuery(conn,actDatos)
}


# Conexion a la base de datos
conn = dbConnect(MySQL(), user=db_user, password=db_pass, dbname=db, host=db_host)
queryPlanes = "SELECT qr.nombre, pac.sga_codigo_com, act.descripcion, pac.pac_id
               FROM distri_tiempo_contenido dtc, actividad act, plan_acad_componente pac LEFT JOIN qr_componente_edu qr ON pac.sga_componente_id = qr.guid
               WHERE pac.pac_id = dtc.pac_id
               AND dtc.dtc_id = act.dtc_id;"
consulta = dbGetQuery(conn, queryPlanes)


on.exit(dbDisconnect(conn))

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