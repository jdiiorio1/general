/* 
Populo las tablas creadas con los datos de la tabla general
*/
USE accidentes2_db;

INSERT INTO ComunidadAutonoma (id_ccaa, ccaa)
SELECT DISTINCT id_ccaa, ccaa FROM accidentes; 

INSERT INTO Provincia (id_provincia, provincia, id_ccaa)
SELECT DISTINCT id_provincia, provincia, id_ccaa FROM accidentes; 

INSERT INTO TipoVia (id_tipo_via, Tipo_via)
SELECT DISTINCT id_tipo_via, Tipo_via FROM accidentes; 

INSERT INTO anio (anio)
SELECT DISTINCT ano FROM accidentes; 

INSERT INTO InfoAccidente (anio, id_provincia, id_tipo_via, fallecidos, accidentes_con_victimas, accidentes_mortales_30_dias, heridos_hospitalizados, heridos_no_hospitalizados)
SELECT ano, id_provincia, id_tipo_via, fallecidos, accidentes_con_victimas, accidentes_mortales_30_dias, heridos_hospitalizados, heridos_no_hospitalizados FROM accidentes;
