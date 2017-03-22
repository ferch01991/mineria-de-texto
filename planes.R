library(DBI)
library(RMySQL)

db = "planesdocentes"
db_host = "localhost"
db_port = 3306
db_user = "root"
db_pass = "root"

# Conexion a la base de datos
conn = dbConnect(MySQL(), user=db_user, password=db_pass, dbname=db, host=db_host)
# Consulta para los periodos academicos
periodos = dbGetQuery(conn, "SELECT nombre FROM PERIODO_ACADEMICO")
# Consulta para las titulaciones
titulaciones = dbGetQuery(conn,"SELECT DISTINCT(qr.nombre) FROM qr_titulacion qr")
# Componenetes educativos
compEducativo = dbGetQuery(conn,"SELECT DISTINCT(qr.nombre) FROM qr_componente_edu qr")

b =0
for(componente in compEducativo$nombre){
  consultaCompAcademico = sprintf("SELECT t.nombre 'Titulacion',qr.nombre 'COMPONENTE', ac.descripcion 'ActividadesClase', pa.nombre 'Periodo' FROM ACTIVIDAD ac, DISTRI_TIEMPO_CONTENIDO dtc, PLAN_ACAD_COMPONENTE pac, PERIODO_ACADEMICO pa, qr_componente_edu qr, TITULACION t WHERE dtc.dtc_id = ac.dtc_id AND dtc.pac_id = pac.pac_id AND pac.sga_periodo_id = pa.guid AND qr.codigo = pac.sga_codigo_com AND qr.id_titulacion = t.titulacion_id AND qr.nombre = '%s' AND pa.nombre = '%s'",componente, periodos$nombre[1])
  actividadClase = dbGetQuery(conn, consultaCompAcademico)
  if(length(actividadClase$ActividadesClase) > 0){
    #archivo = sprintf("//home//%s_%s.txt", componente, gsub("/","",periodo))
    #write(actividadClase$ActividadesClase, archivo)
    b =b+1
    a = sprintf("%s - %s - %s", componente, periodos$nombre[1], b)
    print(a)
  }
}


for(componente in compEducativo$nombre){
  for(periodo in periodos$nombre){
    # script de la consulta a la base de datos
    consultaCompAcademico = sprintf("SELECT qr.nombre 'COMPONENTE', ac.descripcion 'ActividadesClase', pa.nombre 'Periodo' FROM ACTIVIDAD ac, DISTRI_TIEMPO_CONTENIDO dtc, PLAN_ACAD_COMPONENTE pac, PERIODO_ACADEMICO pa, qr_componente_edu qr, TITULACION t WHERE dtc.dtc_id = ac.dtc_id AND dtc.pac_id = pac.pac_id AND pac.sga_periodo_id = pa.guid AND qr.codigo = pac.sga_codigo_com AND qr.id_titulacion = t.titulacion_id AND qr.nombre = '%s' AND pa.nombre = '%s'",componente, periodo)
    # Consulta a la base de datos
    actividadClase = dbGetQuery(conn, consultaCompAcademico)
    if(length(actividadClase$ActividadesClase) > 0){
      #archivo = sprintf("//home//%s_%s.txt", componente, gsub("/","",periodo))
      #write(actividadClase$ActividadesClase, archivo)
      b =b+1
      a = sprintf("%s - %s - %s", componente, periodo, b)
      print(a)
      break()
    }
  }
}

on.exit(dbDisconnect(conn))