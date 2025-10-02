USE tp2g4;

create TABLE Socios (
  id_socio INT PRIMARY KEY,
  nombre VARCHAR(255),
  direccion VARCHAR(255)
);

create TABLE Barcos(
  matricula VARCHAR(255) PRIMARY KEY,
  nombre VARCHAR(255),
  numero_amarre INT,
  cuota DECIMAL(10, 2),
  id_socio INT,
  foreign key (id_socio) references Socios(id_socio)
);

create TABLE Salidas(
  id_salida INT PRIMARY KEY,
  matricula VARCHAR(255),
  fecha_salida DATE,
  hora_salida TIME,
  destino VARCHAR(255),
  patron_nombre VARCHAR(255),
  patron_direccion VARCHAR(255),
  FOREIGN KEY (matricula) REFERENCES Barcos(matricula)
);