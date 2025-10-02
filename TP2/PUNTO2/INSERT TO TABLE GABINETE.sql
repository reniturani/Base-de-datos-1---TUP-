USE gabinete_abogados;

INSERT INTO Clientes (dni, nombre, direccion)
VALUES
(123456789, 'Juan Pérez', 'Calle Pueyrredón 3498, Buenos Aires'),
(987654321, 'Ana García', 'Calle 5 323, La Plata'),
(456123789, 'Luis Fernández', 'Avenida de Gral. Paz 1056, Bahía Blanca');

INSERT INTO Asuntos (numero_expediente, dni, fecha_inicio, fecha_fin, estado)
VALUES
(1, 123456789, '2023-01-15', '2023-07-20', 'Cerrado'),
(2, 987654321, '2023-05-10', NULL, 'Abierto'),
(3, 456123789, '2023-06-01', '2023-09-10', 'Cerrado');

INSERT INTO Procuradores (id_procurador, nombre, direccion)
VALUES
(1, 'Laura Sánchez', 'Calle Soler 3765, Buenos Aires'),
(2, 'Carlos López', 'Calle Estrellas 8, Mar del Plata'),
(3, 'Marta Díaz', 'Calle Estación 12, Olavarría');

INSERT INTO Asuntos_procuradores (numero_expediente, id_procurador)
VALUES
(1, 1),
(2, 2),
(3, 3),
(2, 1);  -- Un asunto puede tener varios procuradores
