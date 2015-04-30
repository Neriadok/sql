/**
*ORDEN 2
*@authors Mardiada y Sallopjo
*/
/*TABLAS DE USUARIO Y NOTIFICACIONES*/
/*Usuarios*/
CREATE TABLE users
	(id INTEGER UNSIGNED AUTO_INCREMENT
	,nickname VARCHAR (50)  CHARSET utf8 COLLATE utf8_unicode_ci NOT NULL
	,mail VARCHAR (255)  CHARSET utf8 COLLATE utf8_unicode_ci NOT NULL
	,pwd CHAR (128)  CHARSET utf8 COLLATE utf8_unicode_ci NOT NULL
	,salt CHAR (128)  CHARSET utf8 COLLATE utf8_unicode_ci NOT NULL
	,tipoUser INTEGER NOT NULL
	,nombre VARCHAR (255) CHARSET utf8 COLLATE utf8_unicode_ci  NULL
	,avatar VARCHAR (255) CHARSET utf8 COLLATE utf8_unicode_ci  NULL
	,firma VARCHAR (255) CHARSET utf8 COLLATE utf8_unicode_ci  NULL
	,grito VARCHAR (255) CHARSET utf8 COLLATE utf8_unicode_ci  NULL
	,nacionalidad VARCHAR (255) CHARSET utf8 COLLATE utf8_unicode_ci 
	,edad INTEGER UNSIGNED
	,fechaRegistro DATETIME NOT NULL
	,fechaBaja DATETIME NULL
	,faltas INTEGER UNSIGNED NOT NULL
	,renombre INTEGER NOT NULL
	,PRIMARY KEY (id)
	,UNIQUE (nickname)
	,UNIQUE (mail)
	,UNIQUE (salt)
	)collate utf8_bin engine=innoDB;

/*Logins*/
CREATE TABLE logins
	(id INTEGER UNSIGNED AUTO_INCREMENT
	,userId INTEGER UNSIGNED NOT NULL
	,exitoso BOOLEAN NOT NULL
	,datelogin DATETIME NOT NULL
	,datelogout DATETIME NULL
	,PRIMARY KEY (id)
	,FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
	)collate utf8_bin engine=innoDB;

/*Logins*/
CREATE TABLE actividades
	(id INTEGER UNSIGNED AUTO_INCREMENT
	,userId INTEGER UNSIGNED NOT NULL
	,hora DATETIME NOT NULL
	,PRIMARY KEY (id)
	,FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
	)collate utf8_bin engine=innoDB;

/*Correo*/
CREATE TABLE correo
	(id INTEGER UNSIGNED AUTO_INCREMENT
	,remitente INTEGER UNSIGNED NULL
	,destinatario INTEGER UNSIGNED NOT NULL
	,fechaEmision DATETIME NOT NULL
	,tipo INTEGER UNSIGNED NOT NULL
	,pts INTEGER UNSIGNED NULL
	,aceptado BOOLEAN NULL
	,tema VARCHAR (100)  CHARSET utf8 COLLATE utf8_unicode_ci NULL
	,contenido VARCHAR (255)  CHARSET utf8 COLLATE utf8_unicode_ci NULL
	,eliminado BOOLEAN NOT NULL DEFAULT false
	,PRIMARY KEY (id)
	,FOREIGN KEY (remitente) REFERENCES users(id) ON DELETE CASCADE
	,FOREIGN KEY (destinatario) REFERENCES users(id) ON DELETE CASCADE
	,FOREIGN KEY (tipo) REFERENCES tiposCorreo(id) ON DELETE CASCADE
	)collate utf8_bin engine=innoDB;

/*Visitas Buzón*/
CREATE TABLE visitasbuzon
	(id INTEGER UNSIGNED AUTO_INCREMENT
	,fecha DATETIME NOT NULL
	,user INTEGER UNSIGNED NOT NULL
	,PRIMARY KEY (id)
	,FOREIGN KEY (user) REFERENCES users(id) ON DELETE CASCADE
	)collate utf8_bin engine=innoDB;

/*Relaciones de amistad*/
CREATE TABLE amistades
	(id INTEGER UNSIGNED AUTO_INCREMENT
	,user1 INTEGER UNSIGNED
	,user2 INTEGER UNSIGNED
	,PRIMARY KEY (id)
	,FOREIGN KEY (user1) REFERENCES users(id) ON DELETE CASCADE
	,FOREIGN KEY (user2) REFERENCES users(id) ON DELETE CASCADE
	,UNIQUE (user1,user2)
	)collate utf8_bin engine=innoDB;