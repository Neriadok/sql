/*Desafiar a un usuario*/
DROP PROCEDURE IF EXISTS proceso_desafiarUser;
DELIMITER $$
CREATE PROCEDURE proceso_desafiarUser(
		IN _destinatario INTEGER UNSIGNED
		,IN _remitente INTEGER UNSIGNED
		,IN _pts INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		INSERT 
			INTO correo
				(remitente,destinatario,tipo,tema,contenido,fechaEmision,pts)
			VALUES
				(_remitente
				,_destinatario
				,5
				,(SELECT nombre FROM users WHERE id = _remitente LIMIT 1)
				,(SELECT grito FROM users WHERE id = _remitente LIMIT 1)
				,now()
				,_pts
				)
		;

		UPDATE users
			SET 
				renombre = renombre + 1
			WHERE id = _remitente
		;
	END;
$$
DELIMITER ;

/*Aceptar un desafío*/
DROP PROCEDURE IF EXISTS proceso_nuevaPartida;
DELIMITER $$
CREATE PROCEDURE proceso_nuevaPartida(
		IN _desafiado INTEGER UNSIGNED
		,IN _desafio INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN

		DECLARE _desafiador INTEGER UNSIGNED;
		DECLARE _partida INTEGER UNSIGNED;

		UPDATE correo
			SET 
				aceptado = true
			WHERE id = _desafio
		;

		SET _desafiador = (
				SELECT 
					remitente
				FROM correo
				WHERE 
				id=_desafio 
				LIMIT 1
			);

		INSERT
			INTO partidas
				(desafiado, desafiador, fechaInicio, desafio)
			VALUES
				(_desafiado,_desafiador, now(), _desafio)
		;

		SET _partida = (
				SELECT
					id
				FROM partidas
				WHERE 
					desafio = _desafio
				LIMIT 1
			);
		
		INSERT
			INTO ejercitos
				(partida, user)
			VALUES
				(_partida, _desafiado)
				,(_partida, _desafiador)
		;

		UPDATE users
			SET 
				renombre = renombre + 1
			WHERE id = (SELECT destinatario FROM correo WHERE id = _desafio) 
		;
	END;
$$
DELIMITER ;

/*Rechazar un desafío*/
DROP PROCEDURE IF EXISTS proceso_denegarDesafio;
DELIMITER $$
CREATE PROCEDURE proceso_denegarDesafio(
		IN _desafio INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		UPDATE correo
			SET 
				aceptado = false
				, eliminado = true
			WHERE id = _desafio
		;

		UPDATE users
			SET 
				renombre = renombre - 1
			WHERE id = (SELECT destinatario FROM correo WHERE id = _desafio) 
		;
	END;
$$
DELIMITER ;

/*Listado de Partidas*/
DROP PROCEDURE IF EXISTS proceso_listadoPartidas;
DELIMITER $$
CREATE PROCEDURE proceso_listadoPartidas(
		IN _uId INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		SELECT
			e.id
			,p.id as partida
			,e.user
			,u1.nickname as desafiadorNick	
			,u2.nickname as desafiadoNick
			,l.nombre as ejercitoNombre
			,c.pts
			,t.turnos
			,f.nombre as fase
			,UNIX_TIMESTAMP(p.fechaInicio)
			,UNIX_TIMESTAMP(p.fechaFin)
			,v.nickname
			
			FROM (((((((
				ejercitos e
					LEFT JOIN partidas p ON e.partida = p.id)
					LEFT JOIN listasejercito l ON e.listaejercito = l.id)
					LEFT JOIN users u1 ON p.desafiador = u1.id)
					LEFT JOIN users u2 ON p.desafiado = u2.id)
					LEFT JOIN users v ON p.vencedor = v.id)
					LEFT JOIN (SELECT
									ejercito
									,max(turno) as turnos
									FROM turnos
									GROUP BY ejercito
							) t
						ON t.ejercito = e.id)
					LEFT JOIN (SELECT
								tf.nombre
								,tu.ejercito
								FROM (fases fa LEFT JOIN tiposfase tf ON fa.tipo = tf.orden) 
									LEFT JOIN turnos tu ON fa.turno = tu.id
								ORDER BY fa.fechaInicio DESC
								LIMIT 1
							) f
						ON f.ejercito = e.id)
					LEFT JOIN correo c ON p.desafio = c.id
			WHERE e.user = _uId
			ORDER BY fechaFin, fechaInicio
		;
	END;
$$
DELIMITER ;

/*Listado de Partidas*/
DROP PROCEDURE IF EXISTS proceso_datosPartida;
DELIMITER $$
CREATE PROCEDURE proceso_datosPartida(
		IN _eId INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		SELECT
			e.id
			,e.user
			,p.id as partida
			,if(e.user = de.id, "Desafiador", "Desafiado") AS orden
			,if(e.user = u1.id, u2.nickname, u1.nickname) AS nickEnemigo
			,en.id AS ejercitoEnemigoId
			,l.nombre as ejercitoNombre
			,l.id as listaId
			,c.pts
			,t.turnos
			,f.id as faseId
			,f.nombre as fase
			,f.ordenFase as ordenFase
			,f.fechaInicio
			,if(f.fechaFin is null, false, true) as finalizada
			
			FROM (((((((((
				ejercitos e
					LEFT JOIN partidas p ON e.partida = p.id)
					LEFT JOIN listasejercito l ON e.listaejercito = l.id)
					LEFT JOIN users u1 ON p.desafiador = u1.id)
					LEFT JOIN users u2 ON p.desafiado = u2.id)
					LEFT JOIN users de ON p.desafiador = de.id)
					LEFT JOIN (SELECT
									ejercito
									,max(turno) as turnos
									FROM turnos
									GROUP BY ejercito
							) t
						ON t.ejercito = e.id)
					LEFT JOIN (SELECT
								tf.nombre as nombre
								,fa.tipo as ordenFase
								,tu.ejercito
								,fa.id
								,fa.fechaInicio
								,fa.fechaFin
								FROM (fases fa LEFT JOIN tiposfase tf ON fa.tipo = tf.orden) 
									LEFT JOIN turnos tu ON fa.turno = tu.id
								ORDER BY fa.fechaInicio DESC
							) f
						ON f.ejercito = e.id)
					LEFT JOIN (SELECT
								id
								,partida
								FROM ejercitos
								WHERE id != _eId
							) en
						ON en.partida = e.partida)
					LEFT JOIN correo c ON p.desafio = c.id)
			WHERE e.id = _eId
			ORDER BY fechaInicio DESC
			LIMIT 1
		;
	END;
$$
DELIMITER ;

/*Elegir una lista para un ejercito*/
DROP PROCEDURE IF EXISTS proceso_seleccionarLista;
DELIMITER $$
CREATE PROCEDURE proceso_seleccionarLista(
		IN _ejercito INTEGER UNSIGNED
		,IN _lista INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		UPDATE
			ejercitos
			SET
				listaejercito = _lista
			WHERE
				id = _ejercito
		;
	END;
$$
DELIMITER ;

/*Comprobar cuantas listas de ejercito se han elegido para una partida*/
DROP PROCEDURE IF EXISTS proceso_checkEjercitosPartida;
DELIMITER $$
CREATE PROCEDURE proceso_checkEjercitosPartida(
		IN _partida INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		SELECT
			listaejercito
			FROM ejercitos
			WHERE partida = _partida AND listaejercito IS NOT NULL
		;
	END;
$$
DELIMITER ;


/*Rendir una partida*/
DROP PROCEDURE IF EXISTS proceso_rendirse;
DELIMITER $$
CREATE PROCEDURE proceso_rendirse(
		IN _ejercito INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN

		DECLARE _partida INTEGER UNSIGNED;
		DECLARE _rendido INTEGER UNSIGNED;
		DECLARE _vencedor INTEGER UNSIGNED;

		SET _rendido = (
				SELECT user FROM ejercitos WHERE id = _ejercito LIMIT 1
			);

		SET _partida = (
				SELECT partida FROM ejercitos WHERE id = _ejercito LIMIT 1
			);

		SET _vencedor = (
				SELECT user FROM ejercitos WHERE partida = _partida AND id != _rendido LIMIT 1
			);

		

		UPDATE users
			SET 
				renombre = renombre - 1
			WHERE id = _rendido 
		;

		UPDATE users
			SET 
				renombre = renombre + 5
			WHERE id = _vencedor
		;

		UPDATE partidas
			SET
				fechaFin = now()
				, vencedor = _vencedor
			WHERE id = _partida
		;
	END;
$$
DELIMITER ;


/*Empezar a jugar una partida*/
DROP PROCEDURE IF EXISTS proceso_empezarPartida;
DELIMITER $$
CREATE PROCEDURE proceso_empezarPartida(
		IN _partida INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		DECLARE _primerEjercito INTEGER UNSIGNED;
		
		SET _primerEjercito = (
				SELECT id FROM ejercitos WHERE partida = _partida AND user = (SELECT desafiador FROM partidas WHERE id = _partida LIMIT 1) LIMIT 1
			);
		
		INSERT
			INTO turnos
				(turno,ejercito,fechaInicio)
			VALUES
				(1,_primerEjercito,now())
		;

		INSERT
			INTO fases
				(turno,tipo,fechaInicio)
			VALUES
				(
					(SELECT id FROM turnos WHERE ejercito = _primerEjercito AND turno = 1 LIMIT 1)
					, 0
					, now()
				)
		;
	END;
$$
DELIMITER ;


/*Tropas en una partida diferenciadas por ejercito*/
DROP PROCEDURE IF EXISTS proceso_tropasEjercito;
DELIMITER $$
CREATE PROCEDURE proceso_tropasEjercito(
		IN _partida INTEGER UNSIGNED
		,IN _ejercito INTEGER UNSIGNED
		,IN _fase INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		DECLARE _despliegue BOOLEAN;
		IF (
			(SELECT 
				count(*) AS situaciones
				FROM situacionestropas 
				WHERE 
					fase IN (
						SELECT 
							id 
							FROM fases 
							WHERE
								turno IN (
									SELECT
										id
										FROM turnos
										WHERE ejercito = _ejercito
								)
					)
			) = 0
		) THEN SET _despliegue = true;
		ELSE SET _despliegue = false;
		END IF;
		
		IF(_despliegue) THEN
			SELECT
				t.id
				, t.nombre
				, t.pts
				, t.esGeneral
				, t.estandarteBatalla
				, t.campeon
				, t.musico
				, t.estandarte
				, ur.maxRango
				, t.miembros
				, (0) as heridas
				, (true) as ejercito
				, "Sin desplegar" as estado
				, (null) as latitud
				, (null) as altitud
				, (null) as orientacion
				, (null) as unidadesFila
				, (null) as tropaAdoptivaId
				, (null) as tropaBajoAtaqueId
				, (null) as tropaBajoAtaqueFlanco
				FROM 
					(tropas t LEFT JOIN
						(SELECT
							max(rango) as maxRango
							,tropa
							FROM unidades
							GROUP BY tropa
						)
					ur ON t.id = ur.tropa)
				WHERE 
					t.lista = (SELECT listaejercito FROM ejercitos WHERE id = _ejercito LIMIT 1)
				GROUP BY t.id
				ORDER BY ejercito DESC, ur.maxRango DESC, t.nombre
			;
		ELSE
			SELECT
				t.id
				, t.nombre
				, t.pts
				, t.esGeneral
				, t.estandarteBatalla
				, t.campeon
				, t.musico
				, t.estandarte
				, ur.maxRango
				, t.miembros
				, s.heridas as heridas
				, s.aliada as ejercito
				, s.estado
				, s.latitud
				, s.altitud
				, s.orientacion
				, s.unidadesFila
				, s.tropaAdoptiva
				, s.tropaBajoAtaque
				, s.tropaBajoAtaqueFlanco
				FROM (((
					situacionestropas s
					LEFT JOIN tropas t ON s.tropa = t.id)
					LEFT JOIN
						(SELECT
							max(rango) as maxRango
							,tropa
							FROM unidades
							GROUP BY tropa
						) ur 
						ON t.id = ur.tropa)
					LEFT JOIN
						(SELECT
							f.id AS fase
							,e.id AS ejercito
							FROM (
								fases f
								LEFT JOIN turnos t
								ON f.turno = t.id)
								LEFT JOIN ejercitos e
								ON t.ejercito = e.id
						) f
						ON s.fase = f.fase)
				WHERE f.ejercito = _ejercito
				GROUP BY t.id
				ORDER BY ejercito DESC, ur.maxRango DESC, t.nombre
			;
		END IF;
	END;
$$
DELIMITER ;


/*Tropas en una partida diferenciadas por ejercito*/
DROP PROCEDURE IF EXISTS proceso_unidadesTropaEjercito;
DELIMITER $$
CREATE PROCEDURE proceso_unidadesTropaEjercito(
		IN _tropaId INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		
		SELECT
			if(u.rango=0
				,"Maquinaria-Carro"
				,if(u.rango=1
					,"Montura-Tiro"
					,if(u.rango=2
						,"Soldado"
						,if(u.rango=6
							,"Heroe"
							,if(u.rango=7
								,"Comandante"
								,if(u.rango=8
									,"Porta estandarte de batalla"
									,"General del ejercito"
								)
							)
						)
					)
				)
			) as tipoRango
			,u.rango
			,u.representada
			,u.montura
			,u.dotacion
			,u.maquinaria
			,u.movimiento
			,u.ha
			,u.hp
			,u.f
			,u.r
			,u.ps
			,u.i
			,u.a
			,u.l
			FROM 
				tropas t
			LEFT JOIN
				(SELECT 
					*
					FROM unidades
					WHERE tropa=_tropaId AND (rango < 3 OR rango > 5)
					GROUP BY rango
					ORDER BY rango DESC
				) u ON t.id=u.tropa
			WHERE t.id=_tropaId
		;
	END;
$$
DELIMITER ;


/**Proceso para registrar nuevas situaciones de tropas*/
DROP PROCEDURE IF EXISTS proceso_addSituacion;
DELIMITER $$
CREATE PROCEDURE proceso_addSituacion(
		IN _aliada BOOLEAN
		,IN _tropa INTEGER UNSIGNED
		,IN _ejercito INTEGER UNSIGNED
		,IN _unidadesFila INTEGER UNSIGNED
		,IN _altitud INTEGER UNSIGNED
		,IN _latitud INTEGER UNSIGNED
		,IN _orientacion INTEGER UNSIGNED
		,IN _heridas INTEGER UNSIGNED
		,IN _tropaAdoptiva INTEGER UNSIGNED
		,IN _tropaBajoAtaque INTEGER UNSIGNED
		,IN _tropaBajoAtaqueFlanco VARCHAR (255)
		,IN _estado VARCHAR (255)
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		DECLARE _fase INTEGER UNSIGNED;
		DECLARE _tropaId INTEGER UNSIGNED;

		SET _fase = (
				SELECT 
						id
						FROM fases 
						WHERE 
							turno IN (
									SELECT
										id 
										FROM turnos 
										WHERE
											ejercito = _ejercito
								)
						ORDER BY fechaInicio DESC
						LIMIT 1
				);

		SET _tropaId = (
				SELECT 
						id 
						FROM situacionestropas 
						WHERE tropa = _tropa 
						AND fase = _fase
						LIMIT 1
				);


		IF(_tropaId IS NULL) THEN
			INSERT
				INTO situacionestropas
					( tropa
					, aliada
					, fase
					, unidadesFila
					, altitud
					, latitud
					, orientacion
					, heridas
					, tropaAdoptiva
					, tropaBajoAtaque
					, tropaBajoAtaqueFlanco
					, estado
					)
				VALUES
					( _tropa
					, _aliada
					, _fase
					, _unidadesFila
					, _altitud
					, _latitud
					, _orientacion
					, _heridas
					, _tropaAdoptiva
					, _tropaBajoAtaque
					, _tropaBajoAtaqueFlanco
					, _estado
					)
			;
		ELSE
			UPDATE situacionesTropas
				SET
					unidadesFila = _unidadesFila
					, altitud = _altitud
					, latitud = _latitud
					, orientacion = _orientacion
					, heridas = _heridas
					, tropaAdoptiva = _tropaAdoptiva
					, tropaBajoAtaque = _tropaBajoAtaque
					, tropaBajoAtaqueFlanco = _tropaBajoAtaqueFlanco
					, estado = _estado
				WHERE id = _tropaId;
		END IF;
	END;
$$
DELIMITER ;


/** Proceso para añadir un nuevo turno */
DROP PROCEDURE IF EXISTS proceso_nuevoTurno;
DELIMITER $$
CREATE PROCEDURE proceso_nuevoTurno(
		IN _turno INTEGER UNSIGNED
		,IN _ejercito INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		IF(_turno > 1) THEN
			UPDATE turnos
				SET
					fechaFin = now()
				WHERE
					ejercito = _ejercito
			;
		END IF;

		INSERT 
			INTO turnos
				(turno,ejercito,fechaInicio)
			VALUES
				(_turno,_ejercito,now())
		;
	END;
$$
DELIMITER ;


/** Proceso para finalizar una fase */
DROP PROCEDURE IF EXISTS proceso_finalizarFase;
DELIMITER $$
CREATE PROCEDURE proceso_finalizarFase(
		IN _turno INTEGER UNSIGNED
		,IN _ejercito INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		UPDATE
			fases
			SET
				fechaFin = now()
			WHERE
				turno IN 
					(SELECT 
						id 
						FROM turnos 
						WHERE turno = _turno AND ejercito = _ejercito
					)
		;
	END;
$$
DELIMITER ;


/** Proceso para añadir una nueva fase */
DROP PROCEDURE IF EXISTS proceso_nuevaFase;
DELIMITER $$
CREATE PROCEDURE proceso_nuevaFase(
		IN _orden INTEGER UNSIGNED
		,IN _ejercito INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		INSERT 
			INTO fases
				(turno,tipo,fechaInicio)
			VALUES
				((SELECT id FROM turnos WHERE ejercito = _ejercito AND fechaFin IS NULL LIMIT 1),_orden,now())
		;
	END;
$$
DELIMITER ;



/**PENDIENTE**/


/**
DROP PROCEDURE IF EXISTS proceso_;
DELIMITER $$
CREATE PROCEDURE proceso_(
		IN  INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		
	END;
$$
DELIMITER ;
*/