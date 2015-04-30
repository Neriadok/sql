/**
*ORDEN 3
*@authors Mardiada y Sallopjo
*/
/*TABLAS DE FOROS*/
/*Categorias de foros*/
CREATE TABLE categorias
	(id INTEGER UNSIGNED AUTO_INCREMENT
	,nombre VARCHAR (100)  CHARSET utf8 COLLATE utf8_unicode_ci NOT NULL
	,permisos INTEGER UNSIGNED NOT NULL
	,PRIMARY KEY (id)
	,UNIQUE (nombre)
	)collate utf8_bin engine=innoDB;

/*Foros*/
CREATE TABLE foros
	(id INTEGER UNSIGNED AUTO_INCREMENT
	,nombre VARCHAR (100)  CHARSET utf8 COLLATE utf8_unicode_ci NOT NULL
	,descripcion VARCHAR (255)  CHARSET utf8 COLLATE utf8_unicode_ci NULL
	,categoria INTEGER UNSIGNED NOT null
	,PRIMARY KEY (id)
	,FOREIGN KEY (categoria) REFERENCES categorias(id) ON DELETE CASCADE
	,UNIQUE (nombre)
	)collate utf8_bin engine=innoDB;

/*Temas de conversacion*/
CREATE TABLE temas
	(id INTEGER UNSIGNED AUTO_INCREMENT
	,nombre VARCHAR (100)  CHARSET utf8 COLLATE utf8_unicode_ci NOT NULL
	,foro INTEGER UNSIGNED NOT NULL
	,creador INTEGER UNSIGNED NOT NULL
	,abierto BOOLEAN NOT NULL
	,noticia BOOLEAN NOT NULL 
	,PRIMARY KEY (id)
	,FOREIGN KEY (creador) REFERENCES users(id) ON DELETE CASCADE
	,FOREIGN KEY (foro) REFERENCES foros(id) ON DELETE CASCADE
	,UNIQUE (nombre,foro)
	)collate utf8_bin engine=innoDB;

/*Posts en los temas*/
CREATE TABLE posts
	(id INTEGER UNSIGNED AUTO_INCREMENT
	,contenido VARCHAR (1023) CHARSET utf8 COLLATE utf8_unicode_ci  NOT NULL
	,tema INTEGER UNSIGNED NOT NULL
	,emisor INTEGER UNSIGNED NOT NULL
	,fechaEmision DATETIME NOT NULL
	,ultimaModificacion DATETIME NULL
	,eliminado BOOLEAN NOT NULL
	,PRIMARY KEY (id)
	,FOREIGN KEY (tema) REFERENCES temas(id) ON DELETE CASCADE
	,FOREIGN KEY (emisor) REFERENCES users(id) ON DELETE CASCADE
	)collate utf8_bin engine=innoDB;

/*TABLAS DE MODERADORES*/
/*Moderadores de categorias*
CREATE TABLE modCategorias
	(id INTEGER UNSIGNED AUTO_INCREMENT
	,moderador INTEGER UNSIGNED NOT NULL
	,categoria INTEGER UNSIGNED NOT NULL
	,PRIMARY KEY (id)
	,FOREIGN KEY (moderador) REFERENCES users(id) ON DELETE CASCADE
	,FOREIGN KEY (categoria) REFERENCES categorias(id) ON DELETE CASCADE
	,UNIQUE (moderador,categoria)
	)collate utf8_bin engine=innoDB;

/*Moderadores de foros*
CREATE TABLE modForos
	(id INTEGER UNSIGNED AUTO_INCREMENT
	,moderador INTEGER UNSIGNED NOT NULL
	,foro INTEGER UNSIGNED NOT NULL
	,PRIMARY KEY (id)
	,FOREIGN KEY (moderador) REFERENCES users(id) ON DELETE CASCADE
	,FOREIGN KEY (foro) REFERENCES foros(id) ON DELETE CASCADE
	,UNIQUE (moderador,foro)
	)collate utf8_bin engine=innoDB;

/*Moderadores de foros*/
CREATE TABLE visitasTemas
	(id INTEGER UNSIGNED AUTO_INCREMENT
	,usuario INTEGER UNSIGNED NOT NULL
	,tema INTEGER UNSIGNED NOT NULL
	,visita DATETIME NOT NULL
	,PRIMARY KEY (id)
	,FOREIGN KEY (usuario) REFERENCES users(id) ON DELETE CASCADE
	,FOREIGN KEY (tema) REFERENCES temas(id) ON DELETE CASCADE
	)collate utf8_bin engine=innoDB;