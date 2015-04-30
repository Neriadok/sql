/**
*ORDEN 1
*@authors Mardiada y Sallopjo
*/

/*TABLAS BÁSICAS*/
/*Create table*/
CREATE TABLE errores
	(codigo VARCHAR (10) CHARSET utf8 COLLATE utf8_unicode_ci NOT NULL
	,tipo VARCHAR (100) CHARSET utf8 COLLATE utf8_unicode_ci NOT NULL
	,descripcion VARCHAR (1000) CHARSET utf8 COLLATE utf8_unicode_ci NOT NULL
	,PRIMARY KEY (codigo)
	)collate utf8_bin engine=innoDB;

/*Razas del juego*/
CREATE TABLE razas
	(id INTEGER UNSIGNED
	,nombre VARCHAR (100) CHARSET utf8 COLLATE utf8_unicode_ci NOT NULL
	,descripcion VARCHAR (255) CHARSET utf8 COLLATE utf8_unicode_ci NULL
	,PRIMARY KEY (id)
	,UNIQUE (nombre)
	)collate utf8_bin engine=innoDB;

/*Tipo de fase*/
CREATE TABLE tiposFase
	(orden INTEGER UNSIGNED
	,nombre VARCHAR (100) CHARSET utf8 COLLATE utf8_unicode_ci NOT NULL
	,descripcion VARCHAR (255) CHARSET utf8 COLLATE utf8_unicode_ci NULL
	,PRIMARY KEY (orden)
	,UNIQUE (nombre)
	)collate utf8_bin engine=innoDB;

/*Tipo de tropa*/
CREATE TABLE tiposCorreo
	(id INTEGER UNSIGNED
	,valor VARCHAR (100) CHARSET utf8 COLLATE utf8_unicode_ci NOT NULL
	,contenido VARCHAR (255) CHARSET utf8 COLLATE utf8_unicode_ci NULL
	,PRIMARY KEY (id)
	,UNIQUE (valor)
	)collate utf8_bin engine=innoDB;

/*Tipo de tropa*/
CREATE TABLE tiposTropa
	(id INTEGER UNSIGNED
	,nombre VARCHAR (100) CHARSET utf8 COLLATE utf8_unicode_ci NOT NULL
	,marca VARCHAR (100) CHARSET utf8 COLLATE utf8_unicode_ci NOT NULL
	,descripcion VARCHAR (255) CHARSET utf8 COLLATE utf8_unicode_ci NULL
	,PRIMARY KEY (id)
	,UNIQUE (nombre)
	)collate utf8_bin engine=innoDB;

/*Tipo de unidad*/
CREATE TABLE tiposUnidad
	(id INTEGER UNSIGNED
	,nombre VARCHAR (100) CHARSET utf8 COLLATE utf8_unicode_ci NOT NULL
	,descripcion VARCHAR (255) CHARSET utf8 COLLATE utf8_unicode_ci NULL
	,PRIMARY KEY (id)
	,UNIQUE (nombre)
	)collate utf8_bin engine=innoDB;

/*Rango de la unidad*/
CREATE TABLE rangosUnidad
	(rango INTEGER UNSIGNED
	,nombre VARCHAR (100) CHARSET utf8 COLLATE utf8_unicode_ci NOT NULL
	,descripcion VARCHAR (255) CHARSET utf8 COLLATE utf8_unicode_ci NULL
	,PRIMARY KEY (rango)
	,UNIQUE (nombre)
	)collate utf8_bin engine=innoDB;

/*Tipo de items*
CREATE TABLE tiposItem
	(id INTEGER UNSIGNED AUTO_INCREMENT
	,nombre VARCHAR (100) NOT NULL
	,descripcion VARCHAR (255) NULL
	,PRIMARY KEY (id)
	,UNIQUE (nombre)
	)engine=innoDB;*/

/*Saberes de la Mágia*
CREATE TABLE saberes
	(id INTEGER UNSIGNED AUTO_INCREMENT
	,nombre VARCHAR (100) NOT NULL
	,descripcion VARCHAR (255) NULL
	,PRIMARY KEY (id)
	,UNIQUE (nombre)
	,UNIQUE (nombre)
	)engine=innoDB;*/