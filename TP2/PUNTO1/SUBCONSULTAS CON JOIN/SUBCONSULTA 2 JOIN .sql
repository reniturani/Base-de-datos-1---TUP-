USE tp2g4;
 /* 2 ¿Cuáles son los nombres de los barcos y cuotas de aquellos barcos cuyo socio se llama 'Juan Pérez'?*/
                SELECT Socios.nombre, Barcos.nombre, Barcos.cuota FROM Socios 
					JOIN Barcos ON Socios.id_socio = Barcos.id_socio
						WHERE Socios.nombre = "Juan Pérez";