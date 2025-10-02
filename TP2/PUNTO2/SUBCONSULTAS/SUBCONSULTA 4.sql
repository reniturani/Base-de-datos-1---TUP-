USE gabinetes_abogados;
/*4 Lista los números de expediente y fechas de inicio de los asuntos de los clientes que viven en Buenos Aires.*/	
					SELECT Asuntos.numero_expediente, Asuntos.fecha_inicio, Clientes.direccion FROM Clientes
						JOIN Asuntos ON Clientes.dni = Asuntos.dni 
							WHERE Clientes.direccion LIKE "%Buenos Aires%";
				