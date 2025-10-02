USE tp2g4;
 /* 2 ¿Cuáles son los nombres de los barcos y cuotas de aquellos barcos cuyo socio se llama 'Juan Pérez'?*/
	SELECT Socios.nombre, cuota FROM Barcos, Socios 
		WHERE Barcos.id_socio = Socios.id_socio AND Socios.nombre = "Juan Pérez";
        