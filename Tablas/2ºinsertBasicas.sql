/**
* Inserción en las tablas básicas
*/
/**Tipos de error*/
INSERT 
	INTO errores
		(codigo,tipo,descripcion)
	VALUES
		("01-01-0001","BD-Registro","El nickname ya existe.")
		,("01-01-0002","BD-Registro","El mail ya está asociado a un usuario.")
		,("01-02-0001","BD-Foros","Ese tema ya existe.")
		,("01-02-0002","BD-Foros","No se pueden hacer temas vacíos.")
		,("01-03-0001","BD-Listas","El usuario ya tiene una lista con ese nombre.")
		,("01-03-0002","BD-Listas","Ya existe esa tropa en la lista indicada.")
;

/***/
INSERT 
	INTO tiposCorreo
		(id,valor,contenido)
	VALUES
		(1,"Bienvenido","Bienvenido a Fantasy Battle Games, el juego privado de estrategia online.")
		,(2,"Peticion de Amistad","")
		,(3,"Mensaje Privado","Contenido:")
		,(4,"Falta","Has recibido una Falta. Si recibes un total de 3 faltas serás baneado de forma automática.")
		,(5,"Desafio","Te han desafiado a una batalla. Pierde renombre si lo rechazas o gana para conseguirlo. ¿Aceptas el desafío?")
;

/***/
INSERT 
	INTO razas
		(id,nombre,descripcion)
	VALUES
		(0,"Undefined","")
;

/***/
INSERT 
	INTO tiposFase
		(orden,nombre,descripcion)
	VALUES
		(0,"Despliegue","Fase en que se disponen las tropas para la batalla.")
		,(1,"Cargas","Fase en que las tropas marchan contra el enemigo, con objetivo de combatir.")
		,(2,"Reaccion de cargas","")
		,(3,"Movimiento","")
		,(4,"Combate","")
;

/***/
INSERT 
	INTO tiposTropa
		(id,nombre,marca,descripcion)
	VALUES
		(1,"Infanter&iacute;a","Inf","")
		,(2,"Caballer&iacute;a","Cab","")
		,(3,"Carro","Car","")
		,(4,"Monstruo","Mon","")
		,(5,"Maquinaria","Mac","")
;

/***/
INSERT 
	INTO tiposUnidad
		(id,nombre,descripcion)
	VALUES
		(1,"Soldado","")
		,(2,"Montura","")
		,(3,"Maquinaria","")
;

/***/
INSERT 
	INTO rangosUnidad
		(rango,nombre,descripcion)
	VALUES
		(0,"Objeto","")
		,(1,"Bestia","")
		,(2,"Soldado Raso","")
		,(3,"Musico","")
		,(4,"Portaestandarte","")
		,(5,"Campe&oacute;n","")
		,(6,"Heroe","")
		,(7,"Comandante","")
		,(8,"Portaestandarte de Batalla","")
		,(9,"General","")
;