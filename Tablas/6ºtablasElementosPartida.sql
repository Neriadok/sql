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
	,FOREIGN KEY (desafio) REFERENCES correo(id) ON DELETE CASCADE
	,FOREIGN KEY (desafiado) REFERENCES users(id) ON DELETE CASCADE
	,FOREIGN KEY (desafiador) REFERENCES users(id) ON DELETE CASCADE
	,FOREIGN KEY (vencedor) REFERENCES users(id) ON DELETE CASCADE
	,UNIQUE (desafio)
	)engine=innoDB;

/*Ejercitos en Partida*/
CREATE TABLE ejercitos
	(id INTEGER UNSIGNED AUTO_INCREMENT
	,partida INTEGER UNSIGNED NOT NULL
	,user INTEGER UNSIGNED NOT NULL
	,listaejercito INTEGER UNSIGNED
	,PRIMARY KEY (id)
	,FOREIGN KEY (user) REFERENCES users(id) ON DELETE CASCADE
	,FOREIGN KEY (listaejercito) REFERENCES listasejercito(id) ON DELETE SET NULL
	,FOREIGN KEY (partida) REFERENCES partidas(id) ON DELETE CASCADE
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
	,FOREIGN KEY (ejercito) REFERENCES ejercitos(id) ON DELETE CASCADE
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
	,FOREIGN KEY (turno) REFERENCES turnos(id) ON DELETE CASCADE
	,FOREIGN KEY (tipo) REFERENCES tiposfase(orden) ON DELETE CASCADE
	,UNIQUE (turno,tipo)
	)engine=innoDB;

/*Situacion de una tropa en una fase*/
CREATE TABLE situacionesTropas
	(id INTEGER UNSIGNED AUTO_INCREMENT
	,tropa INTEGER UNSIGNED NOT NULL
	,aliada BOOLEAN NOT NULL
	,fase INTEGER UNSIGNED NOT NULL
	,unidadesFila INTEGER UNSIGNED NULL
	,altitud INTEGER UNSIGNED NULL
	,latitud INTEGER UNSIGNED NULL
	,orientacion INTEGER UNSIGNED NULL
	,heridas INTEGER UNSIGNED NOT NULL
	,tropaAdoptiva INTEGER UNSIGNED NULL
	,tropaBajoAtaque INTEGER UNSIGNED NULL
	,tropaBajoAtaqueFlanco VARCHAR (255) NULL
	,estado VARCHAR (255) NOT NULL
	,PRIMARY KEY (id)
	,FOREIGN KEY (fase) REFERENCES fases(id) ON DELETE CASCADE
	,FOREIGN KEY (tropa) REFERENCES tropas(id) ON DELETE CASCADE
	,UNIQUE (tropa,fase)
	)engine=innoDB;