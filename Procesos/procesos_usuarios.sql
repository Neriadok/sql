/*Realizar una petición de amistad*/
DROP PROCEDURE IF EXISTS proceso_peticionAmistad;
DELIMITER $$
CREATE PROCEDURE proceso_peticionAmistad(
		IN _emisorId INTEGER UNSIGNED
		,IN _receptorId INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		INSERT 
			INTO correo
				(destinatario,remitente,fechaEmision,tipo)
			VALUES
				(_receptorId,_emisorId,now(),2)
		;
	END;
$$
DELIMITER ;

/*Registrar la actividad de un usuario*/
DROP PROCEDURE IF EXISTS proceso_actividad;
DELIMITER $$
CREATE PROCEDURE proceso_actividad(
		IN _user INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		INSERT 
			INTO actividades
				(userId,hora)
			VALUES
				(_user,now())
		;
	END;
$$
DELIMITER ;

/*Comprobar amistad*/
DROP PROCEDURE IF EXISTS proceso_amistad;
DELIMITER $$
CREATE PROCEDURE proceso_amistad(
		IN _u1 INTEGER UNSIGNED
		,IN _u2 INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		SELECT
			*
			FROM amistades
			WHERE (user1 = _u1 AND user2 = _u2) OR (user1 = _u2 AND user2 = _u1)
			LIMIT 1
		;
	END;
$$
DELIMITER ;

/*Comprobar amistad*/
DROP PROCEDURE IF EXISTS proceso_amigos;
DELIMITER $$
CREATE PROCEDURE proceso_amigos(
		IN _uId INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		SELECT
			IF(u1.id=_uId, u1.id, u2.id) AS usuarioId
			,IF(u1.id=_uId, u2.id, u1.id) AS amigoId
			,IF(u1.id=_uId, u2.nickname, u1.nickname) AS amigoNick
			,IF(u1.id=_uId, u2.renombre, u1.renombre) AS amigoRenombre
			,IF(u1.id=_uId, u2.avatar, u1.avatar) AS amigoAvatar
			,IF(u1.id=_uId, l2.conectado, l1.conectado) AS logged
			FROM ((((
				amistades a LEFT JOIN users u1 ON a.user1=u1.id)
				LEFT JOIN users u2 ON a.user2=u2.id)
				LEFT JOIN (
					SELECT 
						userId
						,if(time_to_sec(now())-time_to_sec(max(hora))>3*60
							,false
							,true
						) AS conectado
						FROM actividades
						GROUP BY userId
						ORDER BY hora
					)
				l1 ON a.user1 = l1.userId)
				LEFT JOIN (
					SELECT 
						userId
						,if(time_to_sec(now())-time_to_sec(max(hora))>3*60
							,false
							,true
						) AS conectado
						FROM actividades
						GROUP BY userId
						ORDER BY hora
					)
				l2 ON a.user2 = l2.userId)
			where u1.id=_uId or u2.id=_uId
		;
	END;
$$
DELIMITER ;

/*Realizar una petición de amistad*/
DROP PROCEDURE IF EXISTS proceso_newAmistad;
DELIMITER $$
CREATE PROCEDURE proceso_newAmistad(
		IN _u1 INTEGER UNSIGNED
		,IN _u2 INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		INSERT 
			INTO amistades
				(user1,user2)
			VALUES
				(_u1,_u2)
		;
		
		UPDATE users
			SET 
				renombre = renombre + 5
			WHERE id = _u1 || id = _u2
		;
	END;
$$
DELIMITER ;

/*Realizar una petición de amistad*/
DROP PROCEDURE IF EXISTS proceso_deleteAmistad;
DELIMITER $$
CREATE PROCEDURE proceso_deleteAmistad(
		IN _u1 INTEGER UNSIGNED
		,IN _u2 INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		DELETE 
			FROM amistades
			WHERE (user1 = _u1 AND user2 = _u2) OR (user1 = _u2 AND user2 = _u1)
		;
		
		UPDATE users
			SET 
				renombre = renombre - 5
			WHERE id = _u1 || id = _u2
		;
	END;
$$
DELIMITER ;

/**Borrar peticiones de amistad*/
DROP PROCEDURE IF EXISTS proceso_deletePeticionesAmistad;
DELIMITER $$
CREATE PROCEDURE proceso_deletePeticionesAmistad(
		IN _remitente INTEGER UNSIGNED
		,IN _destinatario INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		DELETE
			FROM correo
			WHERE remitente = _remitente AND destinatario = _destinatario AND tipo = 2
		;
	END;
$$
DELIMITER ;


/*Añadir una falta a un usuario*/
DROP PROCEDURE IF EXISTS proceso_addFalta;
DELIMITER $$
CREATE PROCEDURE proceso_addFalta(
		IN _uId INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		UPDATE users
			SET 
				faltas = faltas + 1
				,renombre = renombre - 10
			WHERE id = _uId
		;

		IF(
			(SELECT 
				faltas 
				FROM users 
				WHERE id = _uId
				LIMIT 1
			) > 2
		) THEN 
			
			UPDATE users
				SET 
					tipoUser = 0
				WHERE id = _uId
			;
		
		END IF;

		INSERT 
			INTO correo
				(destinatario,tipo,fechaEmision)
			VALUES
				(_uId,4,now())
		;
	END;
$$
DELIMITER ;


/*Banear un usuario*/
DROP PROCEDURE IF EXISTS proceso_banUser;
DELIMITER $$
CREATE PROCEDURE proceso_banUser(
		IN _uId INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		UPDATE users
			SET 
				tipoUser = 0
				,renombre = renombre - 100
			WHERE id = _uId
		;
	END;
$$
DELIMITER ;


/*Hay nuevos mensajes privados*/
DROP PROCEDURE IF EXISTS proceso_logout;
DELIMITER $$
CREATE PROCEDURE proceso_logout(
		IN _uId INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		DECLARE _id INTEGER UNSIGNED;
		SET _id = (
				SELECT
					id
				FROM logins
				WHERE 
					userId = _uId
				ORDER BY datelogin DESC
				LIMIT 1
			);
		UPDATE
			logins
			SET
				datelogout = now()
			WHERE 
				
			id = _id
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