/*Crear un usuario*/
DROP PROCEDURE IF EXISTS proceso_newUser;
DELIMITER $$
CREATE PROCEDURE proceso_newUser(
		IN _nickname VARCHAR(50) CHARSET utf8 COLLATE utf8_unicode_ci
		, IN _mail VARCHAR(255) CHARSET utf8 COLLATE utf8_unicode_ci
		, IN _pwd CHAR(128) CHARSET utf8 COLLATE utf8_unicode_ci
		, IN _salt CHAR(128) CHARSET utf8 COLLATE utf8_unicode_ci
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		IF((SELECT (nickname) FROM users WHERE nickname = _nickname) IS NULL)THEN
			IF((SELECT (mail) FROM users WHERE mail = _mail) IS NULL)THEN
				
				INSERT
					INTO users
						(nickname,mail,pwd,salt,tipoUser,fechaRegistro,faltas,renombre)
					VALUES
						(_nickname,_mail,_pwd,_salt,0,now(),0,1)
				;

				INSERT 
					INTO correo
						(destinatario,fechaEmision,tipo)
					VALUES
						((SELECT id FROM users WHERE nickname=_nickname LIMIT 1),now(),1)
				;
			ELSE
				SELECT * FROM errores WHERE codigo="01-01-0002";
			END IF;
		ELSE
			SELECT * FROM errores WHERE codigo="01-01-0001";
		END IF;
	END;
$$
DELIMITER ;

/*getUserLogData*/
DROP PROCEDURE IF EXISTS proceso_getUserLogData;
DELIMITER $$
CREATE PROCEDURE proceso_getUserLogData(
		IN _nickname VARCHAR(50) CHARSET utf8 COLLATE utf8_unicode_ci
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		SELECT id, nickname, pwd, salt, tipoUser
			FROM users
			WHERE nickname = _nickname
			LIMIT 1;
	END;
$$
DELIMITER ;

/*newLog*/
DROP PROCEDURE IF EXISTS proceso_newLog;
DELIMITER $$
CREATE PROCEDURE proceso_newLog(
		IN _userId INTEGER
		,IN _datelogin TIMESTAMP
		,IN _exitoso BOOLEAN
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		INSERT 
			INTO logins
				(userId, datelogin, exitoso)
			VALUES 
				(_userId,_datelogin,_exitoso)
		;
	END;
$$
DELIMITER ;

/*intentosLog*/
DROP PROCEDURE IF EXISTS proceso_intentosLog;
DELIMITER $$
CREATE PROCEDURE proceso_intentosLog(
		IN _id INTEGER
		, IN _hace2horas TIMESTAMP
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		SELECT count(id)
			FROM logins
			WHERE userId = _id
			AND datelogin > _hace2horas
			AND exitoso IS false
		;
	END;
$$
DELIMITER ;

/*checkNick*/
DROP PROCEDURE IF EXISTS proceso_checkNick;
DELIMITER $$
CREATE PROCEDURE proceso_checkNick(
		IN _nickname VARCHAR(50) CHARSET utf8 COLLATE utf8_unicode_ci
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		SELECT nickname
			FROM users
			WHERE nickname = _nickname
			LIMIT 1
		;
	END;
$$
DELIMITER ;

/*checkPwd*/
DROP PROCEDURE IF EXISTS proceso_checkPwd;
DELIMITER $$
CREATE PROCEDURE proceso_checkPwd(
		IN _userId INTEGER
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		SELECT pwd
			FROM users
			WHERE id = _userId
			LIMIT 1
		;
	END;
$$
DELIMITER ;

/*checkNick*/
DROP PROCEDURE IF EXISTS proceso_checkMail;
DELIMITER $$
CREATE PROCEDURE proceso_checkMail(
		IN _mail VARCHAR(255) CHARSET utf8 COLLATE utf8_unicode_ci
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		SELECT mail
			FROM users
			WHERE mail = _mail
			LIMIT 1
		;
	END;
$$
DELIMITER ;

/*Mostrar el avatar*/
DROP PROCEDURE IF EXISTS proceso_getAvatar;
DELIMITER $$
CREATE PROCEDURE proceso_getAvatar(
		IN _uId INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		SELECT avatar
			FROM users
			WHERE id = _uId
			LIMIT 1
		;
	END;
$$
DELIMITER ;

