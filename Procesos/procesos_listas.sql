/*Nueva lista de ejército*/
DROP PROCEDURE IF EXISTS proceso_newList;
DELIMITER $$
CREATE PROCEDURE proceso_newList(
		IN _user INTEGER UNSIGNED
		,IN _nombre VARCHAR(100) CHARSET utf8 COLLATE utf8_unicode_ci
		,IN _pts INTEGER UNSIGNED
		,IN _raza INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		
		IF((SELECT id FROM listasejercito WHERE nombre=_nombre AND user=_user) IS NULL)THEN
			INSERT 
				INTO listasejercito
					(user,nombre,pts,raza)
				VALUES
					(_user,_nombre,_pts,_raza)
			;
		ELSE
			SELECT codigo, tipo, descripcion FROM errores WHERE codigo="01-03-0001";
		END IF;
	END;
$$
DELIMITER ;

/*Nueva tropa*/
DROP PROCEDURE IF EXISTS proceso_newTroop;
DELIMITER $$
CREATE PROCEDURE proceso_newTroop(
		IN _user INTEGER UNSIGNED
		, IN _nombreLista VARCHAR(100) CHARSET utf8 COLLATE utf8_unicode_ci
		, IN _nombre VARCHAR(50) CHARSET utf8 COLLATE utf8_unicode_ci
		, IN _tipo INTEGER UNSIGNED
		, IN _unidades INTEGER UNSIGNED
		, IN _pts INTEGER UNSIGNED
		, IN _general BOOLEAN
		, IN _battleEst BOOLEAN
		, IN _champ BOOLEAN
		, IN _est BOOLEAN
		, IN _music BOOLEAN
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		
		IF((SELECT id FROM tropas WHERE nombre=_nombre AND 
			lista=(SELECT id FROM listasejercito WHERE user=_user AND nombre=_nombreLista)) IS NULL)THEN
			INSERT 
				INTO tropas
					(lista
					,nombre
					,tipo
					,miembros
					,pts
					,esGeneral
					,estandarteBatalla
					,campeon
					,estandarte
					,musico
					)
				VALUES
					((SELECT id FROM listasejercito WHERE user=_user AND nombre=_nombreLista LIMIT 1)
					,_nombre
					,_tipo
					,_unidades
					,_pts
					,_general
					,_battleEst
					,_champ
					,_est
					,_music
					)
			;
		ELSE
			SELECT codigo, tipo, descripcion FROM errores WHERE codigo="01-03-0002";
		END IF;
	END;
$$
DELIMITER ;

/*Nueva tropa*/
DROP PROCEDURE IF EXISTS proceso_newUnit;
DELIMITER $$
CREATE PROCEDURE proceso_newUnit(
		IN _user INTEGER UNSIGNED
		, IN _nombreLista VARCHAR(100) CHARSET utf8 COLLATE utf8_unicode_ci
		, IN _nombreTropa VARCHAR(50) CHARSET utf8 COLLATE utf8_unicode_ci
		, IN _tipo INTEGER UNSIGNED
		, IN _rango INTEGER UNSIGNED
		, IN _representada BOOLEAN
		, IN _mov INTEGER UNSIGNED
		, IN _ha INTEGER UNSIGNED
		, IN _hp INTEGER UNSIGNED
		, IN _f INTEGER UNSIGNED
		, IN _r INTEGER UNSIGNED
		, IN _ps INTEGER UNSIGNED
		, IN _i INTEGER UNSIGNED
		, IN _a INTEGER UNSIGNED
		, IN _l INTEGER UNSIGNED
		, IN _montura BOOLEAN
		, IN _maquinaria BOOLEAN
		, IN _dotacion BOOLEAN
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN

		INSERT 
			INTO unidades
				(tropa
				,tipo
				,rango
				,representada
				,movimiento
				,ha ,hp ,f ,r ,ps ,i ,a ,l
				,montura
				,maquinaria
				,dotacion
				)
			VALUES
				((SELECT id FROM tropas WHERE nombre=_nombreTropa AND lista=(SELECT id FROM listasejercito WHERE user=_user AND nombre=_nombreLista) LIMIT 1)
				,_tipo
				,_rango
				,_representada
				,_mov ,_ha ,_hp ,_f ,_r ,_ps ,_i ,_a ,_l
				,_montura
				,_maquinaria
				,_dotacion
				)
		;
	END;
$$
DELIMITER ;

/*Nueva lista de ejército*/
DROP PROCEDURE IF EXISTS proceso_listasUsuario;
DELIMITER $$
CREATE PROCEDURE proceso_listasUsuario(
		IN _user INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		SELECT
			l.id
			,l.nombre
			,l.pts
			, count(t.id) AS numTropas
			FROM listasejercito l LEFT JOIN tropas t ON l.id = t.lista
			WHERE l.user=_user
			GROUP BY l.id
		;
	END;
$$
DELIMITER ;

/*Datos básicos de una lista de ejercito*/
DROP PROCEDURE IF EXISTS proceso_lista;
DELIMITER $$
CREATE PROCEDURE proceso_lista(
		IN _lId INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		SELECT
			l.nombre
			,l.user
			,l.pts
			,r.nombre
			, count(t.id) AS numTropas
			,sum(t.miembros) AS numUnidades
			FROM 
				(listasejercito l LEFT JOIN tropas t ON l.id = t.lista)
				LEFT JOIN razas r ON l.raza = r.id
			WHERE l.id=_lId
			GROUP BY l.id
		;
	END;
$$
DELIMITER ;

/*Todos los componentes de una lista de ejército*/
DROP PROCEDURE IF EXISTS proceso_componentesLista;
DELIMITER $$
CREATE PROCEDURE proceso_componentesLista(
		IN _lId INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		SELECT
			t.id
			,t.nombre
			,t.pts
			,t.esGeneral
			,t.estandarteBatalla
			,t.campeon
			,t.musico
			,t.estandarte
			,tt.nombre as tipoTropa
			,ur.maxRango
			,t.miembros
			FROM 
				(tropas t LEFT JOIN
					(SELECT
						max(rango) as maxRango
						,tropa
						FROM unidades
						GROUP BY tropa
					)
				ur ON t.id = ur.tropa) LEFT JOIN 
				tipostropa tt ON t.tipo = tt.id
			WHERE t.lista=_lId
			GROUP BY t.id
			ORDER BY ur.maxRango DESC, t.nombre
		;
	END;
$$
DELIMITER ;

/*Tropas de una lista de ejército*/
DROP PROCEDURE IF EXISTS proceso_tropasLista;
DELIMITER $$
CREATE PROCEDURE proceso_tropasLista(
		IN _lId INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		SELECT
			t.id
			,t.nombre
			,t.miembros
			,t.pts
			,t.campeon
			,t.musico
			,t.estandarte
			,tt.id as tipoTropa
			,tt.nombre as tipoTropaNombre
			,ur.maxRango
			FROM 
				(tropas t LEFT JOIN
					(SELECT
						max(rango) as maxRango
						,tropa
						FROM unidades
						GROUP BY tropa
					)
				ur ON t.id = ur.tropa) LEFT JOIN 
				tipostropa tt ON t.tipo = tt.id
			WHERE t.lista=_lId AND ur.maxRango<6
			GROUP BY t.id
			ORDER BY ur.maxRango DESC, t.nombre
		;
	END;
$$
DELIMITER ;

/*Personajes de una lista de ejército*/
DROP PROCEDURE IF EXISTS proceso_personajesLista;
DELIMITER $$
CREATE PROCEDURE proceso_personajesLista(
		IN _lId INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		SELECT
			t.id
			,t.nombre
			,t.pts
			,t.esGeneral
			,t.estandarteBatalla
			,tt.id as tipoTropa
			,tt.nombre as tipoTropaNombre
			,ur.maxRango
			FROM 
				(tropas t LEFT JOIN
					(SELECT
						max(rango) as maxRango
						,tropa
						FROM unidades
						GROUP BY tropa
					)
				ur ON t.id = ur.tropa) LEFT JOIN 
				tipostropa tt ON t.tipo = tt.id
			WHERE t.lista=_lId AND ur.maxRango>5
			GROUP BY t.id
			ORDER BY ur.maxRango DESC, t.nombre
		;
	END;
$$
DELIMITER ;

/*Perfil de una tropa o personaje*/
DROP PROCEDURE IF EXISTS proceso_perfilTropa;
DELIMITER $$
CREATE PROCEDURE proceso_perfilTropa(
		IN _tId INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		SELECT
			u.tipoRango
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
					if(rango=0
						,"Maquinaria-Carro"
						,if(rango=1
							,"Montura-Bestia tiro"
							,if(rango=2
								,"Soldado-Dotacion"
								,"Personaje"
							)
						)
					) as tipoRango
					,movimiento
					,ha
					,hp
					,f
					,r
					,ps
					,i
					,a
					,l
					,tropa
					FROM unidades
					WHERE tropa=_tId AND (rango < 3 OR rango > 5)
					GROUP BY rango
					ORDER BY rango DESC
				) u ON t.id=u.tropa
			WHERE id=_tId
		;
	END;
$$
DELIMITER ;

/*Perfil de los componentes de una tropa en funcion de su rango*/
DROP PROCEDURE IF EXISTS proceso_perfilComponente;
DELIMITER $$
CREATE PROCEDURE proceso_perfilComponente(
		IN _tId INTEGER UNSIGNED
		,IN _rango INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		SELECT
			u.tipoRango
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
					if(rango=0
						,"Maquinaria-Carro"
						,if(rango=1
							,"Montura-Bestia tiro"
							,if(rango=2
								,"Soldado-Dotacion"
								,"Personaje"
							)
						)
					) as tipoRango
					,rango
					,movimiento
					,ha
					,hp
					,f
					,r
					,ps
					,i
					,a
					,l
					,tropa
					FROM unidades
					WHERE tropa=_tId AND rango = _rango
					LIMIT 1
				) u ON t.id=u.tropa
			WHERE id=_tId AND u.rango = _rango
		;
	END;
$$
DELIMITER ;

/*Eliminar una lista*/
DROP PROCEDURE IF EXISTS proceso_deleteList;
DELIMITER $$
CREATE PROCEDURE proceso_deleteList(
		IN _lId INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		DELETE
			FROM unidades
			WHERE tropa IN 
				(SELECT id  FROM tropas WHERE lista = _lId)
		;

		DELETE
			FROM tropas
			WHERE lista = _lId
		;
		
		DELETE
			FROM listasejercito
			WHERE id = _lId
		;
	END;
$$
DELIMITER ;

/*Modificar una lista*/
DROP PROCEDURE IF EXISTS proceso_updateList;
DELIMITER $$
CREATE PROCEDURE proceso_updateList(
		IN _lId INTEGER UNSIGNED
		, IN _pts INTEGER UNSIGNED
		, IN _raza INTEGER UNSIGNED
	)
	LANGUAGE SQL
	CONTAINS SQL
	MODIFIES SQL DATA
	BEGIN
		
		UPDATE
				listasejercito
			SET
				pts = _pts
				,raza = _raza
			WHERE id = _lId
		;

		DELETE
			FROM unidades
			WHERE tropa IN 
				(SELECT id  FROM tropas WHERE lista = _lId)
		;

		DELETE
			FROM tropas
			WHERE lista = _lId
		;

		SELECT nombre FROM listasejercito WHERE id = _lId;
	END;
$$
DELIMITER ;