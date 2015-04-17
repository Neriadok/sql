/*Categorías*/
DROP PROCEDURE IF EXISTS proceso_admincategorias;
DELIMITER $$
CREATE PROCEDURE proceso_admincategorias()
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		SELECT nombre, id, permisos
			FROM categorias
			ORDER BY permisos, id
		;
	END;
$$
DELIMITER ;


/*Administrar usuarios*/
DROP PROCEDURE IF EXISTS proceso_datosUsersAdmin;
DELIMITER $$
CREATE PROCEDURE proceso_datosUsersAdmin()
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		SELECT 
			u.id
			,u.nickname
			,u.avatar
			,u.mail
			,u.tipoUser
			,u.renombre
			,u.fechaRegistro
			,u.fechaBaja
			,u.faltas
			,u.firma
			,if(p.mensajes IS NULL , 0 , p.mensajes) as mensajes
			,if(t.temas IS NULL , 0 , t.temas )as temas
			,u.grito
			,(100) as Partidas
			,(100) as Victorias
			FROM (users u 
				LEFT JOIN 
					(SELECT 
						emisor AS user
						,count(*) AS mensajes
						FROM posts
						GROUP BY user
					) p ON p.user = u.id
				) LEFT JOIN
					(SELECT
						creador AS user
						,count(*) AS temas
						FROM temas
						GROUP BY user
					) t ON t.user = u.id
			GROUP BY nickname
			ORDER BY tipoUser desc, nickname
		;
	END;
$$
DELIMITER ;


/*Administrar usuarios*/
DROP PROCEDURE IF EXISTS proceso_datosUsers;
DELIMITER $$
CREATE PROCEDURE proceso_datosUsers()
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		SELECT 
			u.id
			,u.nickname
			,u.avatar
			,u.mail
			,u.tipoUser
			,u.renombre
			,u.fechaRegistro
			,u.fechaBaja
			,u.faltas
			,u.firma
			,if(p.mensajes IS NULL , 0 , p.mensajes) as mensajes
			,if(t.temas IS NULL , 0 , t.temas )as temas
			,u.grito
			,(100) as Partidas
			,(100) as Victorias
			FROM (users u 
				LEFT JOIN 
					(SELECT 
						emisor AS user
						,count(*) AS mensajes
						FROM posts
						GROUP BY user
					) p ON p.user = u.id
				) LEFT JOIN
					(SELECT
						creador AS user
						,count(*) AS temas
						FROM temas
						GROUP BY user
					) t ON t.user = u.id
			GROUP BY nickname
			ORDER BY renombre desc, u.fechaRegistro, u.nickname
		;
	END;
$$
DELIMITER ;


/*Administrar usuarios*/
DROP PROCEDURE IF EXISTS datosUser;
DELIMITER $$
CREATE PROCEDURE proceso_datosUser(
		IN _uId INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		SELECT 
			u.id
			,u.nickname
			,u.avatar
			,u.mail
			,u.tipoUser
			,u.renombre
			,u.fechaRegistro
			,u.fechaBaja
			,u.faltas
			,u.firma
			,if(p.mensajes IS NULL , 0 , p.mensajes) as mensajes
			,if(t.temas IS NULL , 0 , t.temas )as temas
			,u.grito
			,(100) as Partidas
			,(100) as Victorias
			FROM (users u 
				LEFT JOIN 
					(SELECT 
						emisor AS user
						,count(*) AS mensajes
						FROM posts
						GROUP BY user
					) p ON p.user = u.id
				) LEFT JOIN
					(SELECT
						creador AS user
						,count(*) AS temas
						FROM temas
						GROUP BY user
					) t ON t.user = u.id
			WHERE u.id = _uId
			LIMIT 1
		;
	END;
$$
DELIMITER ;


/*Actualizar un usuario*/
DROP PROCEDURE IF EXISTS proceso_actualizarUser;
DELIMITER $$
CREATE PROCEDURE proceso_actualizarUser(
		IN _uid INTEGER UNSIGNED 
		, IN _tipo INTEGER UNSIGNED
		,IN _faltas INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		IF(_faltas > 2) THEN
			UPDATE users
				SET 
					tipoUser = 0
					,faltas = _faltas
				WHERE id = _uid
			;

		ELSE
			UPDATE users
				SET 
					tipoUser = _tipo
					,faltas = _faltas
				WHERE id = _uid
			;
		END IF;
	END;
$$
DELIMITER ;


/*Actualizar una categoria*/
DROP PROCEDURE IF EXISTS proceso_actualizarCat;
DELIMITER $$
CREATE PROCEDURE proceso_actualizarCat(
		IN _cid INTEGER UNSIGNED
		,IN _nombre VARCHAR (100) CHARSET utf8 COLLATE utf8_unicode_ci
		,IN _permisos INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		
			UPDATE categorias
				SET 
					nombre = _nombre
					,permisos = _permisos
				WHERE id = _cid
			;
	END;
$$
DELIMITER ;


/*Actualizar un foro*/
DROP PROCEDURE IF EXISTS proceso_actualizarForo;
DELIMITER $$
CREATE PROCEDURE proceso_actualizarForo(
		IN _fid INTEGER UNSIGNED
		,IN _nombre VARCHAR (100) CHARSET utf8 COLLATE utf8_unicode_ci
		,IN _desc VARCHAR (255) CHARSET utf8 COLLATE utf8_unicode_ci
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		
			UPDATE foros
				SET 
					nombre = _nombre
					,descripcion = _desc
				WHERE id = _fid
			;
	END;
$$
DELIMITER ;



/*Eliminar Usuario*/
DROP PROCEDURE IF EXISTS proceso_deleteUser;
DELIMITER $$
CREATE PROCEDURE proceso_deleteUser(
		IN _uid INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN

		DELETE
			FROM users
			WHERE id = _uid
		;
	END;
$$
DELIMITER ;


/*Eliminar Categoria*/
DROP PROCEDURE IF EXISTS proceso_deleteCat;
DELIMITER $$
CREATE PROCEDURE proceso_deleteCat(
		IN _cid INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN

		DELETE 
			FROM categorias
			WHERE id = _cid
		;
	END;
$$
DELIMITER ;



/*Eliminar Foro*/
DROP PROCEDURE IF EXISTS proceso_deleteForo;
DELIMITER $$
CREATE PROCEDURE proceso_deleteForo(
		IN _fid INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		DELETE 
			FROM foros
			WHERE id = _fid
		;
	END;
$$
DELIMITER ;



/*Nuevo Post*/
DROP PROCEDURE IF EXISTS proceso_newCat;
DELIMITER $$
CREATE PROCEDURE proceso_newCat(
		IN _nombre VARCHAR(100) CHARSET utf8 COLLATE utf8_unicode_ci
		,IN _permisos INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		IF(_nombre !="")THEN
			INSERT
				INTO categorias
					(nombre,permisos)
				VALUES
					(_nombre
					,_permisos
					)
			;
		END IF;
	END;
$$
DELIMITER ;



/*Nuevo Post*/
DROP PROCEDURE IF EXISTS proceso_newForo;
DELIMITER $$
CREATE PROCEDURE proceso_newForo(
		IN _nombre VARCHAR(100) CHARSET utf8 COLLATE utf8_unicode_ci
		,IN _categoria INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		IF(_nombre !="")THEN
			INSERT
				INTO foros
					(nombre,categoria)
				VALUES
					(_nombre
					,_categoria
					)
			;
		END IF;
	END;
$$
DELIMITER ;