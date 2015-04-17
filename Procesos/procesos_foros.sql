/*Categorías*/
DROP PROCEDURE IF EXISTS proceso_categorias;
DELIMITER $$
CREATE PROCEDURE proceso_categorias(
		IN _tipoUser INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		SELECT nombre, id
			FROM categorias
			WHERE permisos <= _tipoUser
			ORDER BY permisos, nombre
		;
	END;
$$
DELIMITER ;


/*Foros*/
DROP PROCEDURE IF EXISTS proceso_foros;
DELIMITER $$
CREATE PROCEDURE proceso_foros(
		IN _categoria INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		SELECT id, nombre, descripcion
			FROM foros
			WHERE categoria = _categoria
			ORDER BY id
		;
	END;
$$
DELIMITER ;



/*Temas en Foros*/
DROP PROCEDURE IF EXISTS proceso_temasForo;
DELIMITER $$
CREATE PROCEDURE proceso_temasForo(
		IN _foro VARCHAR(100)
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		SELECT 
			t.id
			,t.nombre
			,t.noticia
			,t.abierto
			,max(UNIX_TIMESTAMP(p.fechaEmision)) as ultimoMsg
			,u.nickname as creador
			,count(p.id) as mensajes
			,if(v.cuenta is null,0,v.cuenta) as visitas
			FROM ((temas t LEFT JOIN users u ON t.creador=u.id) JOIN posts p ON t.id = p.tema) LEFT JOIN 
				(SELECT 
					tema
					,count(*) as cuenta
					FROM visitastemas
					GROUP BY tema
				)v ON t.id=v.tema
			WHERE t.foro = (SELECT id FROM foros WHERE nombre=_foro LIMIT 1) AND p.eliminado IS false
			GROUP BY t.id
			ORDER BY t.abierto desc, t.noticia desc, ultimoMsg desc
		;
	END;
$$
DELIMITER ;



/*Nuevo Tema*/
DROP PROCEDURE IF EXISTS proceso_newTopic;
DELIMITER $$
CREATE PROCEDURE proceso_newTopic(
		IN _topic VARCHAR(100) CHARSET utf8 COLLATE utf8_unicode_ci
		,IN _foro VARCHAR(100) CHARSET utf8 COLLATE utf8_unicode_ci
		,IN _creador INTEGER UNSIGNED
		,IN _noticia BOOLEAN
		,IN _contenido VARCHAR(1023) CHARSET utf8 COLLATE utf8_unicode_ci
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		IF(_topic != "" && _contenido !="")THEN
			IF((SELECT id FROM temas WHERE foro = (SELECT id FROM foros WHERE nombre=_foro LIMIT 1) AND nombre=_topic) IS NULL)THEN
				INSERT
					INTO temas
						(nombre,foro,creador,abierto,noticia)
					VALUES
						(_topic
						, (SELECT id FROM foros WHERE nombre=_foro LIMIT 1)
						,_creador
						,true
						,_noticia
						)
				;

				INSERT
					INTO posts
						(contenido,tema,emisor,fechaEmision,eliminado)
					VALUES
						(_contenido
						, (SELECT id FROM temas WHERE foro=(SELECT id FROM foros WHERE nombre=_foro LIMIT 1) AND nombre=_topic LIMIT 1)
						,_creador
						,now()
						,false
						)
				;

			ELSE
				SELECT * FROM errores WHERE codigo="01-02-0001" LIMIT 1;
			END IF;
		ELSE
			SELECT * FROM errores WHERE codigo="01-02-0002" LIMIT 1;
		END IF;
	END;
$$
DELIMITER ;



/*Visitar tema*/
DROP PROCEDURE IF EXISTS proceso_visitarTema;
DELIMITER $$
CREATE PROCEDURE proceso_visitarTema(
		IN _tema INTEGER UNSIGNED
		,IN _user INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		INSERT 
			INTO visitasTemas
				(usuario,tema,visita)
			VALUES 
				(_user,_tema,now())
		;
		

		SELECT
			t.nombre as temaNombre
			,u.nickname as temaCreadorNick
			,f.nombre as temaForoNombre
			,t.noticia as esNoticia
			,t.abierto as estaAbierto
		FROM (temas t LEFT JOIN users u ON t.creador = u.id) LEFT JOIN foros f ON t.foro = f.id
			WHERE t.id = _tema
			LIMIT 1
		;
		
		UPDATE users
			SET 
				renombre = renombre + 1
			WHERE id IN (
				SELECT
					creador
					FROM temas
					WHERE id = _tema
				)
		;
	END;
$$
DELIMITER ;



/*Posts en un tema*/
DROP PROCEDURE IF EXISTS proceso_temaPosts;
DELIMITER $$
CREATE PROCEDURE proceso_temaPosts(
		IN _tema INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN

		SELECT
			u.nickname as emisor
			,u.avatar
			,u.firma
			,UNIX_TIMESTAMP(p.fechaEmision) as fecha
			,UNIX_TIMESTAMP(p.ultimaModificacion) as modificacion
			,p.contenido as contenido
			,p.id as postId
		FROM posts p LEFT JOIN users u ON p.emisor = u.id
			WHERE p.tema = _tema AND p.eliminado is false
		;
	END;
$$
DELIMITER ;



/*Nuevo Post*/
DROP PROCEDURE IF EXISTS proceso_newPost;
DELIMITER $$
CREATE PROCEDURE proceso_newPost(
		IN _topic INTEGER UNSIGNED
		,IN _emisor INTEGER UNSIGNED
		,IN _contenido VARCHAR(1023) CHARSET utf8 COLLATE utf8_unicode_ci
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		IF(_contenido !="")THEN
			INSERT
				INTO posts
					(contenido,tema,emisor,fechaEmision,eliminado)
				VALUES
					(_contenido
					,_topic
					,_emisor
					,now()
					,false
					)
			;
			UPDATE users
				SET 
					renombre = renombre + 1
				WHERE 
					(id IN 
						(SELECT
							creador
							FROM temas
							WHERE id = _topic 
						) 
						&& id != _emisor
					)
					|| id = _emisor
			;
		ELSE
			SELECT * FROM errores WHERE codigo="01-02-0003" LIMIT 1;
		END IF;
	END;
$$
DELIMITER ;



/*Editar Post*/
DROP PROCEDURE IF EXISTS proceso_editPost;
DELIMITER $$
CREATE PROCEDURE proceso_editPost(
		IN _post INTEGER UNSIGNED
		,IN _contenido VARCHAR(1023) CHARSET utf8 COLLATE utf8_unicode_ci
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		IF(_contenido !="")THEN
			
			UPDATE posts
				SET 
					contenido = _contenido
					,ultimaModificacion = now()
				WHERE id = _post
			;
			
		ELSE
			SELECT * FROM errores WHERE codigo="01-02-0003" LIMIT 1;
		END IF;
	END;
$$
DELIMITER ;



/*Eliminar Post*/
DROP PROCEDURE IF EXISTS proceso_deletePost;
DELIMITER $$
CREATE PROCEDURE proceso_deletePost(
		IN _post INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		UPDATE posts
			SET 
				eliminado = true
			WHERE id = _post
		;
	END;
$$
DELIMITER ;



/*Eliminar Tema*/
DROP PROCEDURE IF EXISTS proceso_deleteTopic;
DELIMITER $$
CREATE PROCEDURE proceso_deleteTopic(
		IN _topic VARCHAR(100) CHARSET utf8 COLLATE utf8_unicode_ci
		,IN _foro VARCHAR(100) CHARSET utf8 COLLATE utf8_unicode_ci
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		DELETE 
			FROM temas
			WHERE foro = (SELECT id FROM foros WHERE nombre=_foro LIMIT 1) AND nombre=_topic LIMIT 1
		;
	END;
$$
DELIMITER ;



/*Eliminar Tema*/
DROP PROCEDURE IF EXISTS proceso_closeUncloseTopic;
DELIMITER $$
CREATE PROCEDURE proceso_closeUncloseTopic(
		IN _topic VARCHAR(100) CHARSET utf8 COLLATE utf8_unicode_ci
		,IN _foro VARCHAR(100) CHARSET utf8 COLLATE utf8_unicode_ci
		,IN _closeUnclose BOOLEAN
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		UPDATE temas
			SET 
				abierto = _closeUnclose
			WHERE foro = (SELECT id FROM foros WHERE nombre=_foro LIMIT 1) AND nombre=_topic LIMIT 1
		;
	END;
$$
DELIMITER ;