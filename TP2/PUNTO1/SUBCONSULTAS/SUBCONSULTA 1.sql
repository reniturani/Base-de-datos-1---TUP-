USE tp2g4;
/*1 ¿Qué socios tienen barcos amarrados en un número de amarre mayor que 10?*/
   SELECT id_socio, numero_amarre FROM Barcos
		WHERE numero_amarre > 10;
  