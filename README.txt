Para reconstruir la base de datos ejecutar los archivos sql en el siguiente orden.
Orden de ejecución:
1º Principal.
2º tablas/1ºtablasBasicas.sql
3º tablas/2ºinsertBasicas.sql
4º tablas/3ºtablasUsuarios.sql
5º tablas/4ºtablasForos.sql
6º tablas/5ºtablasElementosJuego.sql
7º tablas/6ºtablasElementosPartida.sql
8º procesos (en cualquier orden, pero asegurarse de ejecutarlos todos).

El primer usuario en registrarse deberá activarse dandole tipo 3 en la propia base de datos.
De ahi en adelante, los demás usuarios podrán ser administrados por dicho usuario
desde el panel de administración.

Los procedures se sobre escriben si los reejecutas,
esto significa que cada vez que se actualice un procedure
se puede implantar en la base de datos solo con volver a ejecutar el archivo sql.