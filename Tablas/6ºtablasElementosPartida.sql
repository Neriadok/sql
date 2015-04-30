/**
*ORDEN 5
*@authors Mardiada y Sallopjo
*/
/*ELMENTOS DE LAS PARTIDAS*/
/*Partidas*/
CREATE TABLE partidas
	(id INTEGER UNSIGNED AUTO_INCREMENT
	,desafiado INTEGER UNSIGNED NOT NULL
	,desafiador INTEGER UNSIGNED NOT NULL 
	,fechaInicio DATETIME NOT NULL
	,fechaFin DATETIME NULL
	,desafio INTEGER UNSIGNED NOT NULL
	,vencedor INTEGER UNSIGNED NULL
	,PRIMARY KEY (id)
	,FOREIGN KEY (desafio) REFERENCES correo(id)
	,FOREIGN KEY (desafiado) REFERENCES users(id)
	,FOREIGN KEY (desafiador) REFERENCES users(id)
	,FOREIGN KEY (vencedor) REFERENCES users(id)
	,UNIQUE (desafio)
	)engine=innoDB;

/*Ejercitos en Partida*/
CREATE TABLE ejercitos
	(id INTEGER UNSIGNED AUTO_INCREMENT
	,partida INTEGER UNSIGNED NOT NULL
	,user INTEGER UNSIGNED NOT NULL
	,listaejercito INTEGER UNSIGNED
	,PRIMARY KEY (id)
	,FOREIGN KEY (user) REFERENCES users(id)
	,FOREIGN KEY (listaejercito) REFERENCES listasejercito(id)
	,FOREIGN KEY (partida) REFERENCES partidas(id)
	,UNIQUE (listaejercito,partida)
	)engine=innoDB;

/*Turnos de  las partidas*/
CREATE TABLE turnos
	(id INTEGER UNSIGNED AUTO_INCREMENT
	,turno INTEGER UNSIGNED NOT NULL
	,ejercito INTEGER UNSIGNED NOT NULL
	,fechaInicio DATETIME NOT NULL
	,fechaFin DATETIME NULL
	,PRIMARY KEY (id)
	,FOREIGN KEY (ejercito) REFERENCES ejercitos(id)
	,UNIQUE (turno,ejercito)
	)engine=innoDB;

/*Fases de los turnos*/
CREATE TABLE fases
	(id INTEGER UNSIGNED AUTO_INCREMENT
	,turno INTEGER UNSIGNED NOT NULL
	,tipo INTEGER UNSIGNED NOT NULL
	,fechaInicio DATETIME NOT NULL
	,fechaFin DATETIME NULL
	,PRIMARY KEY (id)
	,FOREIGN KEY (turno) REFERENCES turnos(id)
	,FOREIGN KEY (tipo) REFERENCES tiposfase(orden)
	,UNIQUE (turno,tipo)
	)engine=innoDB;

/*Situacion de una tropa en una fase*/
CREATE TABLE situacionesTropas
	(id INTEGER UNSIGNED AUTO_INCREMENT
	,tropa INTEGER UNSIGNED NOT NULL
	,fase INTEGER UNSIGNED NOT NULL
	,unidadesFila INTEGER UNSIGNED NULL
	,altitud1 INTEGER UNSIGNED NULL
	,latitud1 INTEGER UNSIGNED NULL
	,orientacion1 INTEGER UNSIGNED NULL
	,enJuego BOOLEAN NOT NULL
	,heridas INTEGER UNSIGNED
	,tropaAdoptiva INTEGER UNSIGNED NULL
	,cargando BOOLEAN NULL
	,huyendo BOOLEAN NULL
	,combateV BOOLEAN NULL
	,combateS BOOLEAN NULL
	,combateD BOOLEAN NULL
	,combateR BOOLEAN NULL
	,PRIMARY KEY (id)
	,FOREIGN KEY (fase) REFERENCES fases(id)
	,FOREIGN KEY (tropa) REFERENCES tropas(id)
	,FOREIGN KEY (tropaAdoptiva) REFERENCES situacionesTropas(id)
	,UNIQUE (tropa,fase)
	,UNIQUE (altitud1,latitud1,orientacion1,fase)
	)engine=innoDB;