/*Mostrar el avatar*/
DROP PROCEDURE IF EXISTS proceso_perfilUsuario;
DELIMITER $$
CREATE PROCEDURE proceso_perfilUsuario(
		IN _uId INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		SELECT
			id
			,avatar
			,nickname
			,tipoUser
			,nombre
			,mail
			,edad
			,nacionalidad
			,UNIX_TIMESTAMP(fechaRegistro) as fechaR
			,UNIX_TIMESTAMP(fechaBaja) as fechaB
			,firma
			,grito
			FROM users
			WHERE id = _uId
			LIMIT 1
		;
	END;
$$
DELIMITER ;

/*Actualizar Email*/
DROP PROCEDURE IF EXISTS proceso_updateMail;
DELIMITER $$
CREATE PROCEDURE proceso_updateMail(
		IN _uId INTEGER UNSIGNED
		,IN _mail VARCHAR(255) CHARSET utf8 COLLATE utf8_unicode_ci
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		UPDATE
			users
			SET
				mail = _mail
			WHERE id=_uId
		;
	END;
$$
DELIMITER ;

/*Actualizar password*/
DROP PROCEDURE IF EXISTS proceso_updatePassword;
DELIMITER $$
CREATE PROCEDURE proceso_updatePassword(
		IN _uId INTEGER UNSIGNED
		,IN _pass CHAR(128) CHARSET utf8 COLLATE utf8_unicode_ci
		,IN _salt CHAR(128) CHARSET utf8 COLLATE utf8_unicode_ci
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		UPDATE
			users
			SET
				pwd = _pass
				,salt = _salt
			WHERE id=_uId
		;
	END;
$$
DELIMITER ;

/*Actualizar Avatar*/
DROP PROCEDURE IF EXISTS proceso_updateAvatar;
DELIMITER $$
CREATE PROCEDURE proceso_updateAvatar(
		IN _uId INTEGER UNSIGNED
		,IN _avatar VARCHAR(255) CHARSET utf8 COLLATE utf8_unicode_ci
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		UPDATE
			users
			SET
				avatar = _avatar
			WHERE id=_uId
		;
	END;
$$
DELIMITER ;

/*Actualizar nombre*/
DROP PROCEDURE IF EXISTS proceso_updateNombre;
DELIMITER $$
CREATE PROCEDURE proceso_updateNombre(
		IN _uId INTEGER UNSIGNED
		,IN _nom VARCHAR(255) CHARSET utf8 COLLATE utf8_unicode_ci
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		UPDATE
			users
			SET
				nombre = _nom
			WHERE id=_uId
		;
	END;
$$
DELIMITER ;

/*Actualizar Edad*/
DROP PROCEDURE IF EXISTS proceso_updateAge;
DELIMITER $$
CREATE PROCEDURE proceso_updateAge(
		IN _uId INTEGER UNSIGNED
		,IN _age INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		UPDATE
			users
			SET
				edad = _age
			WHERE id=_uId
		;
	END;
$$
DELIMITER ;

/*Actualizar nacionalidad*/
DROP PROCEDURE IF EXISTS proceso_updateNacion;
DELIMITER $$
CREATE PROCEDURE proceso_updateNacion(
		IN _uId INTEGER UNSIGNED
		,IN _nacion VARCHAR(255) CHARSET utf8 COLLATE utf8_unicode_ci
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		UPDATE
			users
			SET
				nacionalidad = _nacion
			WHERE id=_uId
		;
	END;
$$
DELIMITER ;

/*Actualizar firma*/
DROP PROCEDURE IF EXISTS proceso_updateFirma;
DELIMITER $$
CREATE PROCEDURE proceso_updateFirma(
		IN _uId INTEGER UNSIGNED
		,IN _firma VARCHAR(255) CHARSET utf8 COLLATE utf8_unicode_ci
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		UPDATE
			users
			SET
				firma = _firma
			WHERE id=_uId
		;
	END;
$$
DELIMITER ;


/*Actualizar grito*/
DROP PROCEDURE IF EXISTS proceso_updateGrito;
DELIMITER $$
CREATE PROCEDURE proceso_updateGrito(
		IN _uId INTEGER UNSIGNED
		,IN _grito VARCHAR(255) CHARSET utf8 COLLATE utf8_unicode_ci
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		UPDATE
			users
			SET
				grito = _grito
			WHERE id=_uId
		;
	END;
$$
DELIMITER ;