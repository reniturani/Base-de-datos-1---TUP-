USE tp2g4;
		/*5 ¿Qué barcos han salido con destino a 'Mallorca'?*/
				SELECT Barcos.matricula, destino FROM Barcos
					JOIN Salidas ON Barcos.matricula = Salidas.matricula
						WHERE destino = "Mallorca";
                        
           		