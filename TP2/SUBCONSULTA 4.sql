USE tp2g4;
/* 4 Lista los barcos que tienen una cuota mayor a 500 y sus respectivos socios.*/
			SELECT Barcos.id_socio, matricula, cuota FROM Barcos 
				WHERE cuota > 500;
                