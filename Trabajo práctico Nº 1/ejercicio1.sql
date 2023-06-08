/* Primero armé las tablas con id autoincrementales, luego en el ejercicio 2 vi que habia que popular las tablas con los valores de la 
 tabla accidentes, por lo que use el script autogenerado del primer esquema para crear un segundo esquema (y probar el script)
 en donde no uso los id autoncrementales
 Tambien tuve que modificar el tipo de datos de año, que habia puesto date, y en la tabla accidentes es int, y el id de tipo via habia puesto int pero es un char
*/
CREATE SCHEMA `accidentes2_db` ;
USE accidentes2_db;

CREATE TABLE `accidentes2_db`.`Provincia` (
  `id_provincia` INT NOT NULL, -- AUTO_INCREMENT,
  `provincia` VARCHAR(30) NOT NULL,
  `id_ccaa` INT NOT NULL,
  PRIMARY KEY (`id_provincia`));
  
  
  CREATE TABLE `accidentes2_db`.`ComuinidadAutonoma` (
  `id_ccaa` int NOT NULL, -- AUTO_INCREMENT,
  `ccaa` varchar(30) NOT NULL,
  PRIMARY KEY (`id_ccaa`)
);

CREATE TABLE `accidentes2_db`.`TipoVia` (
  `id_tipo_via` char(1) NOT NULL, -- AUTO_INCREMENT,
  `Tipo_via` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_tipo_via`));


  CREATE TABLE `accidentes2_db`.`InfoAccidente` (
  `id` int NOT NULL AUTO_INCREMENT,
  `anio` int NOT NULL,
  `id_provincia` int NOT NULL,
  `id_tipo_via` char(1) NOT NULL,
  `fallecidos` int DEFAULT NULL,
  `accidentes_con_victimas` int DEFAULT NULL,
  `accidentes_mortales_30_dias` int DEFAULT NULL,
  `heridos_hospitalizados` int DEFAULT NULL,
  `heridos_no_hospitalizados` int DEFAULT NULL,
  PRIMARY KEY (`id`)
)
  
  CREATE TABLE `accidentes2_db`.`anio` (
  `id_anio` INT NOT NULL AUTO_INCREMENT,
  `anio` INT NOT NULL,
  PRIMARY KEY (`id_anio`));
