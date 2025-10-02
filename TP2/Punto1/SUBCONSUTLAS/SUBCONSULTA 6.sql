USE tp2g4;
	/*6 ¿Qué patrones (nombre y dirección) han llevado un barco cuyo socio vive en 'Barcelona'?*/
				SELECT patron_nombre, patron_direccion, direccion, Socios.nombre, Barcos.matricula FROM Socios,Barcos,Salidas
					WHERE Barcos.id_socio = Socios.id_socio AND Barcos.matricula = Salidas.matricula AND direccion LIKE "%Barcelona%";
            