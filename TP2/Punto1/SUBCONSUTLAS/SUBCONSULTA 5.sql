USE tp2g4;
	/*5 ¿Qué barcos han salido con destino a 'Mallorca'?*/
			SELECT Barcos.matricula, destino FROM Barcos, Salidas
				WHERE destino = "Mallorca";