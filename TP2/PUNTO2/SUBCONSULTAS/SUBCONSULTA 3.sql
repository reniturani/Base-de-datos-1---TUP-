USE gabinete_abogados;
/*3 ¿Cuántos asuntos ha gestionado cada procurador?*/
					SELECT 	Procuradores.id_procurador, COUNT(Asuntos.numero_expediente) AS cant_gestionados FROM Asuntos
						JOIN Asuntos_procuradores ON (Asuntos.numero_expediente = Asuntos_procuradores.numero_expediente)
							JOIN Procuradores ON Procuradores.id_procurador = Asuntos_procuradores.id_procurador 
								GROUP BY Procuradores.id_procurador, Procuradores.nombre;
