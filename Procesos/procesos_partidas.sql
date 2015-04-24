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
			ORDER BY fechaFin, fechaInicio DESC
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
			,if(e.user = de.id, "desafiador", "desafiado") AS orden
			,l.nombre as ejercitoNombre
			,l.id as listaId
			,c.pts
			,t.turnos
			,f.nombre as fase
			,f.fechaInicio
			,if(f.fechaFin is null, false, true) as finalizada
			
			FROM (((((((
				ejercitos e
					LEFT JOIN partidas p ON e.partida = p.id)
					LEFT JOIN listasejercito l ON e.listaejercito = l.id)
					LEFT JOIN users de ON p.desafiador = de.id)
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
								,fa.fechaInicio
								,fa.fechaFin
								FROM (fases fa LEFT JOIN tiposfase tf ON fa.tipo = tf.orden) 
									LEFT JOIN turnos tu ON fa.turno = tu.id
								ORDER BY fa.fechaInicio DESC
								LIMIT 1
							) f
						ON f.ejercito = e.id)
					LEFT JOIN correo c ON p.desafio = c.id)
			WHERE e.id = _eId
			ORDER BY fechaInicio DESC
		;
	END;
$$
DELIMITER ;


/**PENDIENTE**
/*Hay nuevos mensajes privados*
DROP PROCEDURE IF EXISTS proceso_;
DELIMITER $$
CREATE PROCEDURE proceso_(
		IN _uId INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		
	END;
$$
DELIMITER ;
*/