USE Banco;

/*3) Crea el procedimiento almacenado sin parámetros VerCuentas() que muestre
todas las cuentas con su saldo actual.*/
DELIMITER $$ 
CREATE PROCEDURE VerCuentas()
BEGIN 
	SELECT cuentas.numero_cuenta, numero_cliente, saldo_actual FROM cuentas 
		JOIN historial_movimientos ON historial_movimientos.numero_cuenta = cuentas.numero_cuenta;
END $$
DELIMITER ;
CALL VerCuentas();

/*4) Crea el procedimiento CuentasConSaldoMayorQue(IN limite
DECIMAL(10,2)) que muestra las cuentas con saldo mayor al valor recibido.*/

DELIMITER $$
CREATE PROCEDURE CuentasConSaldoMayorQue(IN limite DECIMAL(10,2))
BEGIN
	SELECT cuentas.numero_cuenta, numero_cliente, saldo_actual FROM cuentas 
		JOIN historial_movimientos ON historial_movimientos.numero_cuenta = cuentas.numero_cuenta
			WHERE saldo_actual > limite;
END $$
DELIMITER ;
CALL CuentasConSaldoMayorQue(2000.0);

/*5) Crea sin utilizar cursores el procedimiento almacenado
TotalMovimientosDelMes(IN cuenta INT, OUT total DECIMAL(10,2))
que recibe una cuenta y devuelve el total de los movimientos de la cuenta en el mesa actual, los créditos suman, y los débitos restan.
La función CURDATE() retorna la fecha actual, y la funcion MONTH(fecha) retorna el mes de la fecha pasada por parámetro.*/

DELIMITER $$

CREATE PROCEDURE TotalMovimientosDelMes(
    IN p_numero_cuenta INT,
    OUT p_total DECIMAL(10,2)
)
BEGIN
    SELECT 
        SUM(
            CASE 
                WHEN tipo = 'CREDITO' THEN importe
                WHEN tipo = 'DEBITO' THEN -importe
                ELSE 0
            END
        )
    INTO p_total
    FROM movimientos
    WHERE numero_cuenta = p_numero_cuenta
      AND MONTH(fecha) = MONTH(CURDATE())
      AND YEAR(fecha) = YEAR(CURDATE());

    IF p_total IS NULL THEN
        SET p_total = 0;
    END IF;
END $$

DELIMITER ;

/*6) Crea un procedimiento almacenado Depositar(IN cuenta, IN monto) que deposita el valor ingresado en la cuenta.*/

DELIMITER $$

CREATE PROCEDURE Depositar(
    IN p_numero_cuenta INT, 
    IN p_importe DECIMAL(10,2)
)
BEGIN
    INSERT INTO movimientos (numero_movimiento, numero_cuenta, fecha, tipo, importe)
    VALUES (NULL, p_numero_cuenta, CURDATE(), 'CREDITO', p_importe);
END $$

DELIMITER ;

/*7)Crea un procedimiento almacenado Extraer(IN cuenta, IN monto) que registra la extracción de dinero de la cuenta, 
si es que cuenta con fondos para cubrir el retiro.*/

DELIMITER $$
DROP PROCEDURE IF EXISTS Extraer;
CREATE PROCEDURE Extraer(IN cuenta INT, IN monto DECIMAL(10,2))
BEGIN
	DECLARE saldoActual DECIMAL(10,2);
    DECLARE idMov INT;
    
    SELECT saldo INTO saldoActual FROM cuentas  -- guardamos el saldo de la cuenta pasada por parametro
		WHERE numero_cuenta = cuenta;  			-- en la variable SALDOACTUAL
        
	IF saldoActual>=monto THEN 				-- si tiene fondos SUFICIENTES 
		UPDATE cuentas SET saldo = saldo - monto WHERE numero_cuenta = cuenta; 	-- hacemos la extraccion -> SALDO = saldo - monto
        
        INSERT INTO movimientos(numero_cuenta, fecha, tipo, importe)			-- INSERTAMOS el movimiento a la tabla MOVIMIENTOS
        VALUES (cuenta, CURDATE(), 'DEBITO', monto);
        
        SET idMov = LAST_INSERT_ID();             -- idMov = numero_movimiento mas recientemente agregado en la tabla MOVIMIENTOS, se puede hacer porque 
												  -- numero_movimiento es AUTO_INCREMENT
        
        INSERT INTO historial_movimientos(numero_cuenta, numero_movimiento, saldo_anterior, saldo_actual)
        VALUES (cuenta, idMov, saldoActual, saldoActual - monto);
	ELSE
		SELECT 'Fondos insuficientes' AS mensaje;
    
	END IF;
END $$
DELIMITER ;

-- 1003 = $800
CALL Extraer(1003,800.00);
SELECT numero_cuenta, saldo FROM cuentas;


/*8)Crea un Trigger que actualice el saldo de la cuenta luego de cada nuevo movimiento que se registra en la cuenta. 
Probalo ejecutando algunos depósitos/extracciones.*/

DELIMITER $$ 
DROP TRIGGER IF EXISTS actualizar_saldo_cuenta;
CREATE TRIGGER actualizar_saldo_cuenta AFTER INSERT ON movimientos -- actualiza SUELDO(cuentas) despues de cada INSERT en (movimientos)
	FOR EACH ROW 
		BEGIN
			IF NEW.tipo = "CREDITO" THEN  			-- si es un CREDITO sumamos IMPORTE al SALDO
				UPDATE cuentas
					SET saldo = saldo + NEW.importe
						WHERE numero_cuenta = NEW.numero_cuenta;
			END IF;
            
            IF NEW.tipo = "DEBITO" THEN				-- si es un DEBITO restamos IMPORTE al saldo
				UPDATE cuentas
					SET saldo = saldo - NEW.importe
						WHERE numero_cuenta = NEW.numero_cuenta;
			END IF;
            
        END $$
        DELIMITER ;
        
			-- Saldo actual de la cuenta 1001 = $2100
	SELECT numero_cuenta, saldo FROM cuentas WHERE numero_cuenta = 1001;

	-- Insertamos un depósito
	INSERT INTO movimientos(numero_cuenta, fecha, tipo, importe)
	VALUES (1001, CURDATE(), 'CREDITO', 500.00);

	-- Insertamos una extracción
	INSERT INTO movimientos(numero_cuenta, fecha, tipo, importe)
	VALUES (1001, CURDATE(), 'DEBITO', 200.00);

	-- Revisamos el saldo actualizado
	SELECT numero_cuenta, saldo FROM cuentas WHERE numero_cuenta = 1001;

/*9)Modifica el trigger anterior para que, luego de actualizado el saldo, se encargue de registrar el movimiento en el historial de saldos. 
Para modificar la implementación del trigger primero hay que eliminarlo, y luego volver a crearlo. */

DELIMITER $$ 
DROP TRIGGER IF EXISTS insertar_movimiento_historialMovimientos;
CREATE TRIGGER insertar_movimiento_historialMovimientos AFTER INSERT ON movimientos		-- despues de cada INSERT en (movimientos), actualiza SALDO(cuentas) y 
	FOR EACH ROW 																		-- INSERTA el movimiento en (historial_movimientos)
		BEGIN
        DECLARE saldoAnterior DECIMAL(10,2);										-- Declaramos variables para GUARDAR los SALDOS
        DECLARE saldoActual DECIMAL(10,2);			
        
        SELECT saldo INTO saldoAnterior FROM cuentas WHERE numero_cuenta = NEW.numero_cuenta; 	-- obtenemos saldo antes de APLICAR MOVIMIENTO
        
			IF NEW.tipo = "CREDITO" THEN  			-- si es un CREDITO sumamos IMPORTE al SALDO
            
				SET saldoActual = saldoAnterior + NEW.importe; -- calculamos SALDO ACTUALIZADO sumando IMPORTE(movimientos)
                        
			UPDATE cuentas SET saldo = saldoActual 				-- ACTUALIZAMOS TABLA CUENTAS
				WHERE numero_cuenta = NEW.numero_cuenta;	
                
			 INSERT INTO historial_movimientos(numero_cuenta, numero_movimiento, saldo_anterior, saldo_actual) VALUES 
             (NEW.numero_cuenta, NEW.numero_movimiento, saldoAnterior, saldoActual);
			
            
			END IF;
            
            IF NEW.tipo = "DEBITO" THEN				-- si es un DEBITO restamos IMPORTE al saldo
				SET saldoActual = saldoAnterior - NEW.importe;			-- calculamos SALDO ACTUALIZADO restando IMPORTE(movimientos)
                
                UPDATE cuentas SET saldo = saldoActual
					WHERE numero_cuenta = NEW.numero_cuenta;
                    
				INSERT INTO historial_movimientos(numero_cuenta, numero_movimiento, saldo_anterior, saldo_actual) VALUES 
                (NEW.numero_cuenta, NEW.numero_movimiento, saldoAnterior, saldoActual);
			END IF;
            
        END $$
        DELIMITER ;
        
        -- VERIFICACION ----------------------------------------------------------------
        
		-- Revisamos saldo inicial de la cuenta 1001
		SELECT numero_cuenta, saldo FROM cuentas WHERE numero_cuenta = 1001;

		-- Insertamos un depósito de $500 en la cuenta 1001
		INSERT INTO movimientos(numero_cuenta, fecha, tipo, importe)
		VALUES (1001, CURDATE(), 'CREDITO', 500.00);

		-- Insertamos una extracción de $200 en la cuenta 1001
		INSERT INTO movimientos(numero_cuenta, fecha, tipo, importe)
		VALUES (1001, CURDATE(), 'DEBITO', 200.00);

		-- Revisamos el saldo actualizado
		SELECT numero_cuenta, saldo FROM cuentas WHERE numero_cuenta = 1001;

		-- Revisamos el historial de movimientos para la cuenta 1001
		SELECT * FROM historial_movimientos WHERE numero_cuenta = 1001;


/*--------------------------------------------------------------------------------------------------------------------------------------------------------*/

/* Resolvé utilizando cursores: */


/*10) Crea el procedimiento almacenado TotalMovimientosDelMes(IN cuenta INT, OUT total DECIMAL(10,2)) que recibe una cuenta y devuelve el total de
los movimientos de la cuenta en el mesa actual, los créditos suman, y los débitos restan.
La función CURDATE() retorna la fecha actual, y la funcion MONTH(fecha) retorna el mes de la fecha pasada por parámetro.
*/

DELIMITER $$

CREATE PROCEDURE TotalMovimientosDelMes(
    IN num_cuenta INT,  ((aca en el tp dice cuenta nomas, pero despues no me cuadra con otras cosas))
    OUT total DECIMAL(10,2)
)
BEGIN
    DECLARE v_tipo VARCHAR(10);
    DECLARE v_importe DECIMAL(10,2);
    DECLARE fin INT DEFAULT 0;
    SET p_total = 0;

    DECLARE cursorMov CURSOR FOR
        SELECT tipo, importe
        FROM movimientos
        WHERE numero_cuenta = num_cuenta
          AND MONTH(fecha) = MONTH(CURDATE())
          AND YEAR(fecha) = YEAR(CURDATE());


    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = 1;  (esto no recuerdo verlo en teoria, pero por lo que busque es bastante importante)

    OPEN cursorMov;

    leer: LOOP
        FETCH cursorMov INTO v_tipo, v_importe;

        IF fin = 1 THEN
            LEAVE leer;
        END IF;

        IF v_tipo = 'CREDITO' THEN
            SET total = total + v_importe;
        ELSEIF v_tipo = 'DEBITO' THEN
            SET total = total - v_importe;
        END IF;

    END LOOP leer;

    CLOSE cursorMov;

END $$

DELIMITER ;


/*11) El banco implementó un beneficio para sus clientes dándoles por única vez un 2% de interés a las cuentas que posean saldo mayor a $100.000. 
Creá un procedimiento almacenado que se encargue de aplicar un porcentaje de interés recibido por parámetro a todas las cuentas 
con saldo mayor a un valor recibido por parámetro. */

DELIMITER $$

CREATE PROCEDURE AplicarInteres(
    IN porcentaje DECIMAL(5,2),
    IN saldo_min DECIMAL(15,2)
)
BEGIN
    DECLARE v_numero_cuenta INT;
    DECLARE v_saldo DECIMAL(15,2);
    DECLARE fin INT DEFAULT 0;


    DECLARE cursorInteres CURSOR FOR
        SELECT numero_cuenta, saldo
        FROM cuentas
        WHERE saldo > saldo_min;

 
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = 1;

    OPEN cursorInteres;

    recorrer: LOOP
        FETCH cursorInteres INTO v_numero_cuenta, v_saldo;

        IF fin = 1 THEN
            LEAVE recorrer;
        END IF;

        -- Actualizamos el saldo aplicando el interés
        UPDATE cuentas
        SET saldo = v_saldo + (v_saldo * porcentaje / 100)
        WHERE numero_cuenta = v_numero_cuenta;

    END LOOP recorrer;

    CLOSE cursorInteres;

END $$

DELIMITER ;