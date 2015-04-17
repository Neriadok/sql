/*Añadir una visita a un foro.*/
DROP PROCEDURE IF EXISTS proceso_visitarBuzon;
DELIMITER $$
CREATE PROCEDURE proceso_visitarBuzon(
		IN _uId INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		INSERT 
			INTO visitasbuzon
				(user,fecha)
			VALUES
				(_uId,now())
		;
	END;
$$
DELIMITER ;

/*Notificaciones de un usuario.*/
DROP PROCEDURE IF EXISTS proceso_correoUsuario;
DELIMITER $$
CREATE PROCEDURE proceso_correoUsuario(
		IN _uId INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		SELECT
			c.id
			,c.tipo
			,c.fechaEmision
			,r.nickname as remitenteNick
			,r.id as remitenteId
			,tc.valor as tipoCorreo
			,tc.contenido AS contenidoDefecto
			,c.pts
			,c.tema
			,c.contenido as contenidoReal
			FROM 
				(correo c 
					LEFT JOIN users r ON c.remitente = r.id)
					LEFT JOIN tiposcorreo tc ON c.tipo = tc.id
			WHERE c.destinatario = _uId AND (c.eliminado IS null OR c.eliminado IS false) AND (c.aceptado IS null OR c.aceptado IS false)
			ORDER BY c.fechaEmision DESC
		;
	END;
$$
DELIMITER ;

/*Notificaciones de un usuario.*/
DROP PROCEDURE IF EXISTS proceso_ultimaVisitaBuzonUsuario;
DELIMITER $$
CREATE PROCEDURE proceso_ultimaVisitaBuzonUsuario(
		IN _uId INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		SELECT
			max(fecha)
			FROM visitasbuzon
			WHERE user = _uId
			GROUP BY user
			LIMIT 1
		;
	END;
$$
DELIMITER ;

/*Enviar un correo*/
DROP PROCEDURE IF EXISTS proceso_newMsg;
DELIMITER $$
CREATE PROCEDURE proceso_newMsg(
		IN _remitente INTEGER UNSIGNED
		, IN _destinatario INTEGER UNSIGNED 
		, IN _topic VARCHAR(100) CHARSET utf8 COLLATE utf8_unicode_ci
		, IN _content VARCHAR(255) CHARSET utf8 COLLATE utf8_unicode_ci
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		INSERT 
			INTO correo
				(remitente,destinatario,tipo,tema,contenido,fechaEmision)
			VALUES
				(_remitente,_destinatario,3,_topic,_content,now())
		;
	END;
$$
DELIMITER ;

/*Eliminar un correo*/
DROP PROCEDURE IF EXISTS deleteCorreo;
DELIMITER $$
CREATE PROCEDURE proceso_deleteCorreo(
		IN _correo INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		
		DELETE
			FROM correo
			WHERE id = _correo
		;

	END;
$$
DELIMITER ;

/* *
DROP PROCEDURE IF EXISTS ;
DELIMITER $$
CREATE PROCEDURE proceso_(
		
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		
	END;
$$
DELIMITER ;

/* *
DROP PROCEDURE IF EXISTS ;
DELIMITER $$
CREATE PROCEDURE proceso_(
		
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		
	END;
$$
DELIMITER ;