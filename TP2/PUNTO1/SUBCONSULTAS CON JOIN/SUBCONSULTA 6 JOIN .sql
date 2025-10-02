USE tp2g4;
           		/*6 ¿Qué patrones (nombre y dirección) han llevado un barco cuyo socio vive en 'Barcelona'?*/
					SELECT patron_nombre, patron_direccion, direccion, Socios.nombre, Barcos.matricula FROM Socios
						JOIN Barcos ON (Socios.id_socio = Barcos.id_socio) JOIN Salidas ON (Barcos.matricula = Salidas.matricula)
							WHERE direccion LIKE "%Barcelona%";