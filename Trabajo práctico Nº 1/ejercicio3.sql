
USE accidentes2_db;
-- 1. ¿Qué provincias y tipos de vías no tienen accidentes mortales a 30 días en 2015?
/* realizo un join utilizando producto cartesiano */

SELECT prov.provincia, tv.tipo_via
FROM Provincia as prov, TipoVia as tv, InfoAccidente as info
WHERE info.accidentes_mortales_30_dias = 0 AND 
info.anio = 2015 AND 
info.id_provincia = prov.id_provincia AND
info.id_tipo_via = tv.id_tipo_via;

-- 2. ¿Qué provincias de “Andalucía” tienen más de 25 fallecidos en vías interurbanas en 2014?
/* suponinendo que uno no conoce id id de la comunidad autonoma de Andalucia y el id del tipo de via interurbana, realizo la consulta solo con los datos que se obtienen de la pregunta */

SELECT DISTINCT prov.provincia
FROM Provincia as prov, TipoVia as tv, InfoAccidente as info, ComunidadAutonoma as ca 
WHERE info.id_provincia = prov.id_provincia AND 
prov.id_ccaa = ca.id_ccaa AND
info.id_tipo_via = tv.id_tipo_via AND
ca.ccaa = 'Andalucía' AND
info.fallecidos > 25 AND
tv.tipo_via = 'Interurbana' AND
info.anio = 2014;

-- 3. ¿Cuál es la Comunidad Autónoma con más accidentes con víctimas en 2015?
/* Agrupo la busqueda por comunidad autonoma, haciendo un producto cartesiano entre las tablas de comunidad, provincia e info accidentes
para poder agrupotar las provincias por id de comunidad y luego sumar los accidentes con victimas, luego filtro por año*/

SELECT ca.ccaa, SUM(info.accidentes_con_victimas) as totales
FROM InfoAccidente as info, ComunidadAutonoma as ca, Provincia as prov
WHERE info.id_provincia = prov.id_provincia AND 
prov.id_ccaa = ca.id_ccaa AND
info.anio = 2015
group by ca.ccaa
order by totales desc 
LIMIT 1; 

-- 4. ¿Cuál es el número medio de heridos no hospitalizados por año? Redondea el resultado sin decimales.
/* como en la consulta anterior, agrupo por año y obtengo el promedio con AVG del campo heridos_hospitalizados, luego redondeo el campo AVG */

SELECT anio, round(AVG(heridos_hospitalizados),0) 
FROM InfoAccidente
group by anio;

-- 5. ¿Cuál es la combinación de año, provincia y tipo de vía con más heridos hospitalizados?
/* realizo la consulta por provincia, año y tipo de via, la ordeno por heridos en forma descendente y me quedo con la primer fila */

SELECT prov.provincia, info.anio, tv.tipo_via -- , info.heridos_hospitalizados 
FROM InfoAccidente as info, Provincia as prov, TipoVia as tv
WHERE info.id_provincia = prov.id_provincia AND
info.id_tipo_via = tv.id_tipo_via
order by info.heridos_hospitalizados desc 
LIMIT 1;

-- 6. ¿Qué Comunidades Autónomas tienen menos de 100 fallecidos en 2014?
/* Primero realizo la consulta agrupando las provincias por comunidades y sumando los fallecidos, luego necesito utilizar el campo de la suma de fallecidos por comunidad dentro de la clausula where,
esto no se puede hacer ya que el orden de ejecucion de la instruccion no lo permite, primero se ejecuta la clausula where en donde se realizan los filtros, y luego el select para seleccionar las columnas a mostrar.
por esta razon para poder utilizar la columna se suma de fallecidos en el where, tengo que crear una tabla temporal para cargarla con el resultado de la siguiente consulta:

select ca.ccaa, SUM(info.fallecidos)  from InfoAccidente as info, ComunidadAutonoma as ca, Provincia as prov
where info.id_provincia = prov.id_provincia AND 
prov.id_ccaa = ca.id_ccaa AND
info.anio = 2014
group by ca.ccaa;

y luego de guardar el resultado del select en una tabla temporal, puedo filtrar por cantidad de fallecidos.
Finalmente borro la tabla temporal
*/
CREATE TEMPORARY TABLE comuna
SELECT ca.ccaa, SUM(info.fallecidos) as fatales
FROM InfoAccidente as info, ComunidadAutonoma as ca, Provincia as prov
WHERE info.id_provincia = prov.id_provincia AND 
prov.id_ccaa = ca.id_ccaa AND
info.anio = 2014
group by ca.ccaa; 

SELECT * FROM comuna WHERE fatales < 100;

DROP TEMPORARY TABLE comuna;

-- 7. ¿Cuál es la provincia que tiene más accidentes con víctimas en vías urbanas en 2015?
/* realizo el producto cartesiano entre tablas, ya que asumo que no conozco los ids de provincia y tipo de vias y utilizo solo los datos suministrados en la consulta*/

SELECT prov.provincia
FROM Provincia as prov, InfoAccidente as info, TipoVia as tv
WHERE 
info.id_provincia = prov.id_provincia AND
info.id_tipo_via = tv.id_tipo_via AND
info.anio = 2015 AND
tv.tipo_via = 'Urbana'
order by info.accidentes_con_victimas desc
LIMIT 1;

-- 8. Obtén un listado de las provincias que empiezan por la letra “C” y ordena las descripciones de forma descendente.

SELECT * FROM Provincia 
WHERE provincia LIKE 'C%'
order by provincia desc;

-- 9. Haz un ranking con las tres provincias que tienen el mayor número de heridos totales (heridos hospitalizados + heridos no hospitalizados) en vías interurbanas en 2015.

SELECT prov.provincia, (info.heridos_hospitalizados + info.heridos_no_hospitalizados) as heridos
FROM Provincia as prov, InfoAccidente as info, TipoVia as tv
WHERE 
info.id_provincia = prov.id_provincia AND
info.id_tipo_via = tv.id_tipo_via AND
info.anio = 2015 AND
tv.tipo_via = 'Interurbana'
order by heridos desc
LIMIT 3;

-- 10. Calcula la diferencia entre 2014 y 2015 de la proporción de heridos hospitalizados y no hospitalizados de la Comunidad Autónoma de "Asturias" en vías interurbanas.
/* Entiendo como proporcion, al porcentaje de heridos hospitalizados sobre los heridos totales (hospitalizados + no hospitalizados). Teniendo en cuenta que los taltales serian el 100%, 
el porcentaje de hospitalizados estaria dado por: (heridos hospitalizados * 100) /  heridos totales 
por otro lado, como para realizar la resta entre años tengo que utilizar la columna creada con el calculo de proporcion, voy a crear una tabla temporal con los datos de esa columna para poder restarlos y mostrar el resultado de esa operacion
*/

select prov.provincia, info.heridos_hospitalizados, info.heridos_no_hospitalizados, info.anio, (info.heridos_hospitalizados * 100 /(info.heridos_hospitalizados + info.heridos_no_hospitalizados)) as proporcion
from Provincia as prov, TipoVia as tv, InfoAccidente as info, ComunidadAutonoma as ca 
where info.id_provincia = prov.id_provincia AND 
prov.id_ccaa = ca.id_ccaa AND
info.id_tipo_via = tv.id_tipo_via AND
ca.ccaa LIKE '%Asturias%' AND
tv.tipo_via = 'Interurbana';
