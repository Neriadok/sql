Para reconstruir la base de datos ejecutar los archivos sql en el siguiente orden.
Orden de ejecuci�n:
1� Principal.
2� tablas/1�tablasBasicas.sql
3� tablas/2�insertBasicas.sql
4� tablas/3�tablasUsuarios.sql
5� tablas/4�tablasForos.sql
6� tablas/5�tablasElementosJuego.sql
7� tablas/6�tablasElementosPartida.sql
8� procesos (en cualquier orden, pero asegurarse de ejecutarlos todos).

El primer usuario en registrarse deber� activarse dandole tipo 3 en la propia base de datos.
De ahi en adelante, los dem�s usuarios podr�n ser administrados por dicho usuario
desde el panel de administraci�n.

Los procedures se sobre escriben si los reejecutas,
esto significa que cada vez que se actualice un procedure
se puede implantar en la base de datos solo con volver a ejecutar el archivo sql.