library(DBI)
library(RMySQL)
library(NLP)
library(tm)
library(hunspell)

#db = "pruebaPlanes"
db = "planesdocentes"
db_host = "localhost"
db_port = 3306
db_user = "root"
db_pass = "root"

# Conexion a la base de datos
conn = dbConnect(MySQL(), user=db_user, password=db_pass, dbname=db, host=db_host)
queryPlanes = "SELECT pac.pac_id 'Codigo del Plan', act.descripcion 'Actividades', pac.sga_codigo_com 'Codigo del componente' FROM PLAN_ACAD_COMPONENTE pac, DISTRI_TIEMPO_CONTENIDO dtc, ACTIVIDAD act WHERE pac.pac_id = dtc.pac_id AND dtc.dtc_id = act.dtc_id;"
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

prueba = actividadesPlanes
dictEC = dictionary('es_EC')
prueba = hunspell_stem(prueba, dict = 'es_EC')



# planes que no tienen actividades 
# CONVERGENCIA DE PANTALLAS: DIVERSIDAD DE VISIONES - SEMINARIO INTERNACIONAL ALIMENTOS IBEROAMERICANOS - INGENIERIA DE PROYECTOS Y GESTIÓN DEL CONOCIMIENTO - INGENIERIA DE PROYECTOS Y GESTIÓN DEL CONOCIMIENTO
# CURSO DE INDUCCIÓN UNIVERSITARIA - TECNICAS ESTADISTICAS PARA LA TOMA DE DECISIONES - RUSO I - PORTUGUES - CONJUNTO CORAL - CONSERVACIÓN DE LA NATURALEZA Y DIVERSIDAD ANIMAL
# TRABAJO DE FIN DE CARRERA GP 4.1 - RETÓRICA, TEORÍA DE LA ARGUMENTACIÓN Y ORATORIA - REDACCION PARA RELACIONES PUBLICAS - ARTE INTERPRETATIVO
# VOLEIBOL - ESTADÍSTICA APLICADA - GESTIÓN DE RESIDUOS SÓLIDOS URBANOS - PREPARACIÓN Y CARACTERIZACIÓN DE CATALIZADORES - CAMPILOBACTER, SALUD HUMANA Y ALIMENTOS
# 