DROP DATABASE IF EXISTS Banco;
CREATE DATABASE Banco;
USE Banco;

CREATE TABLE clientes (
	numero_cliente INT PRIMARY KEY NOT NULL,
    dni INT NOT NULL,
    apellido VARCHAR (60),
    nombre VARCHAR (60) 
);

CREATE TABLE cuentas (
	numero_cuenta INT PRIMARY KEY NOT NULL,
    saldo DECIMAL (10,2),
    numero_cliente INT NOT NULL,
    FOREIGN KEY (numero_cliente) REFERENCES clientes (numero_cliente)
);

CREATE TABLE movimientos (
	numero_movimiento INT PRIMARY KEY NOT NULL,
    numero_cuenta INT NOT NULL,
    fecha DATE ,
    tipo ENUM ("CREDITO", "DEBITO") NOT NULL,
    importe DECIMAL (10,2),
    FOREIGN KEY (numero_cuenta) REFERENCES cuentas (numero_cuenta)
);

CREATE TABLE historial_movimientos(
	id INT PRIMARY KEY NOT NULL,
    saldo_anterior DECIMAL (10,2),
    saldo_actual DECIMAL (10,2),
    numero_cuenta INT,
    numero_movimiento INT,
    FOREIGN KEY (numero_cuenta) REFERENCES cuentas (numero_cuenta),
    FOREIGN KEY (numero_movimiento) REFERENCES movimientos (numero_movimiento)
);