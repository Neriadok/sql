/**
 * Creamos la base de datos y sus permisos
 */
CREATE DATABASE FBG
DEFAULT CHARACTER SET utf8
DEFAULT COLLATE utf8_unicode_ci;
USE FBG;

/**
 * 
 */
GRANT USAGE ON FBG.* TO 'fbguser'@'localhost' IDENTIFIED BY '+USERpass1234';
GRANT EXECUTE ON FBG.* TO 'fbguser'@'localhost' IDENTIFIED BY '+USERpass1234';
GRANT SELECT ON mysql.proc TO 'fbguser'@'localhost';