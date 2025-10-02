USE tp2g4;
/*3 ¿Cuántas salidas ha realizado el barco con matrícula 'ABC123'?*/
            SELECT Barcos.matricula, COUNT(id_salida) AS total_salida FROM Barcos
				JOIN Salidas ON Barcos.matricula = Salidas.matricula
					WHERE Barcos.matricula = "ABC123";