USE gabinete_abogados;
/*1 ¿Cuál es el nombre y la dirección de los procuradores que han trabajado en un asunto abierto?*/
			SELECT Procuradores.nombre, Procuradores.direccion FROM Asuntos
				JOIN Asuntos_procuradores ON (Asuntos.numero_expediente = Asuntos_procuradores.numero_expediente)
					JOIN Procuradores ON Procuradores.id_procurador = Asuntos_procuradores.id_procurador 
						WHERE Asuntos.estado = "Abierto";
