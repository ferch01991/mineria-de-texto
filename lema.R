library(hunspell)
library(NLP)
library(tm)
library(SnowballC)

# Se establece el directorio de los archivos a procesar
#planesDir = file.path("C:\\Users\\Herrera\\Documents\\pruebasR", "PlanesDocentes")
planesDir = file.path("//home//ferch01991//Documentos", "PlanesDocentes")
# Se imprime el total de archivos que hay y el nombre
dir(planesDir)

archivos_txt = Corpus(DirSource(planesDir))
summary(archivos_txt)
inspect(archivos_txt[1])

# remover enlaces web 
removeURL <- function(x) gsub("http[[:alnum:][:punct:]]*", "", x) 
archivos_txt = tm_map(archivos_txt, content_transformer(removeURL))
inspect(archivos_txt[1])


#espacio a los signos de puntuacion palabra(palabra)
espacio = content_transformer(function(x, pattern) gsub(pattern, " ", x))
archivos_txt = tm_map(archivos_txt, espacio, "[[:punct:]]+")
#mode(archivos_txt[1])
 

#Removemos los signos de puntuaci?n
archivos_txt = tm_map(archivos_txt, removePunctuation)
#Removemos los numeros
archivos_txt = tm_map(archivos_txt, removeNumbers)
#convertimos las letras a minusculas
archivos_txt = tm_map(archivos_txt, tolower)
inspect(archivos_txt[4])
#removemos los stopwords
archivos_txt = tm_map(archivos_txt, removeWords, stopwords("spanish"))
archivos_txt = tm_map(archivos_txt, removeWords, stopwords("english"))
inspect(archivos_txt[1])
archivos_txt = tm_map(archivos_txt, removeWords, c("i", "ii"))
inspect(archivos_txt[1])

#stemming reduce una palabra a su raiz
archivos_txt = tm_map(archivos_txt, stemDocument, language="spanish")
inspect(archivos_txt[1])

#Elimina espacios dobles 
archivos_txt = tm_map(archivos_txt, stripWhitespace)
inspect(archivos_txt[1])

#Guarda un archivo con la limpieza de datos 
write(archivos_txt[[1]], "C:\\Users\\Herrera\\Documents\\pruebasR\\arqAppLimpio.txt", sep = "\n")


# http://ftp.snt.utwente.nl/pub/software/openoffice/contrib/dictionaries/
esp = dictionary("es_EC")
summary(archivos_txt)



