USE tp2g4;
	/* 4 Lista los barcos que tienen una cuota mayor a 500 y sus respectivos socios.*/
			SELECT Barcos.matricula, Barcos.cuota, Socios.id_socio FROM Socios
				JOIN Barcos ON Socios.id_socio = Barcos.id_socio
					WHERE cuota > 500;
			