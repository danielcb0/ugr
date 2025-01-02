SELECT table_name FROM user_tables;


DROP TABLE PRODUCTOR2;
DROP TABLE EMPLEADO2;
DROP TABLE CLIENTE2;
DROP TABLE SUMINISTRO2;
DROP TABLE PEDIDO2;
DROP TABLE PIDEVINOA;
DROP TABLE VINO2;
DROP TABLE SUCURSAL2;
ALTER TABLE SUCURSAL2 DROP CONSTRAINT CE10;


SELECT * FROM SUCURSAL2;
SELECT * FROM kdekilo3.EMPLEADO3;




CREATE TABLE SUCURSAL2(
    CODSU NUMBER PRIMARY KEY,
    NOMBRE VARCHAR2(30),
    CIUDAD VARCHAR2(30),
    COMAUTONOMA VARCHAR2(30) NOT NULL,
    CODDIRECTOR INT UNIQUE
);

CREATE TABLE PRODUCTOR2(
    CODPR INT PRIMARY KEY,
    DNI VARCHAR(10) NOT NULL UNIQUE,
    NOMBRE VARCHAR2(30),
    DIRECCION VARCHAR(30)
);

CREATE TABLE VINO2(
    CODVIN INT PRIMARY KEY,
    MARCA VARCHAR(20),
    ANIOCOSECHA INT NOT NULL,
    DENOMINACION_ORIGEN VARCHAR(20),
    GRADUACION NUMBER(4,2),
    VINIEDOPROCEDENCIA VARCHAR(20),
    CANTSTOCK INT,
    CANTPRODUCIDA INT,
    COMAUTONOMA VARCHAR(20) NOT NULL,
    CODPR INT,
    CONSTRAINT CE1 FOREIGN KEY (CODPR) REFERENCES PRODUCTOR2(CODPR)
);


CREATE TABLE EMPLEADO2(
    CODEM INT PRIMARY KEY,
    CODSU INT,
    DNI VARCHAR(10) NOT NULL UNIQUE,
    NOMBRE VARCHAR(20),
    FECHACONTRATO DATE NOT NULL,
    SALARIO INT NOT NULL,
    DIRECCION VARCHAR(30),
    CONSTRAINT CE2 FOREIGN KEY (CODSU) REFERENCES SUCURSAL2(CODSU)
);


CREATE TABLE CLIENTE2(
    CODCL INT PRIMARY KEY,
    DNI VARCHAR2(10) NOT NULL UNIQUE,
    NOMBRE VARCHAR2(20),
    DIRECCION VARCHAR2(30),
    TIPO VARCHAR2(20) CHECK (TIPO IN ('A', 'B', 'C')),
    COMAUTONOMA VARCHAR2(20)
);


CREATE TABLE PEDIDO2(
    CODVIN INT,
    CODSU INT,
    CANTIDAD INT,
    CONSTRAINT CE5 FOREIGN KEY (CODVIN) REFERENCES VINO2(CODVIN),
    CONSTRAINT CE6 FOREIGN KEY (CODSU) REFERENCES SUCURSAL2(CODSU)
);

CREATE TABLE SUMINISTRO2(
    CODCL INT,
    CODVIN INT,
    CODSU INT,
    CANTIDAD INT,
    FECHASUMINISTRO DATE,
    CONSTRAINT CE4 FOREIGN KEY (CODCL) REFERENCES CLIENTE2(CODCL),
    CONSTRAINT CE8 FOREIGN KEY (CODSU) REFERENCES SUCURSAL2(CODSU)
);


CREATE TABLE PIDEVINOA (
    CODPED INT PRIMARY KEY,
    CODSU1 INT NOT NULL,
    CODSU2 INT NOT NULL,
    CODVIN INT NOT NULL,
    CANTIDAD INT NOT NULL,
    FECHAPEDIDO DATE
);

ALTER TABLE SUCURSAL2 ADD CONSTRAINT CE10 FOREIGN KEY (CODDIRECTOR) REFERENCES EMPLEADO2(CODEM);



GRANT SELECT, INSERT, DELETE, UPDATE ON SUCURSAL2 TO kdekilo1, kdekilo3, kdekilo4;
GRANT SELECT, INSERT, DELETE, UPDATE ON PRODUCTOR2 TO kdekilo1, kdekilo3, kdekilo4;
GRANT SELECT, INSERT, DELETE, UPDATE ON VINO2 TO kdekilo1, kdekilo3, kdekilo4;
GRANT SELECT, INSERT, DELETE, UPDATE ON EMPLEADO2 TO kdekilo1, kdekilo3, kdekilo4;
GRANT SELECT, INSERT, DELETE, UPDATE ON CLIENTE2 TO kdekilo1, kdekilo3, kdekilo4;
GRANT SELECT, INSERT, DELETE, UPDATE ON PEDIDO2 TO kdekilo1, kdekilo3, kdekilo4;
GRANT SELECT, INSERT, DELETE, UPDATE ON SUMINISTRO2 TO kdekilo1, kdekilo3, kdekilo4;
GRANT SELECT, INSERT, DELETE, UPDATE ON PIDEVINOA TO kdekilo1, kdekilo3, kdekilo4;


DROP VIEW SucursalView;
DROP VIEW ProductorView;
DROP VIEW VinoView;
DROP VIEW EmpleadoView;
DROP VIEW ClienteView;
DROP VIEW PedidoView;
DROP VIEW SuministroView;
DROP VIEW PideVinoAView;



CREATE VIEW SucursalView AS 
SELECT * FROM kdekilo1.SUCURSAL1
UNION
SELECT * FROM SUCURSAL2
UNION
SELECT * FROM kdekilo3.SUCURSAL3
UNION
SELECT * FROM kdekilo4.SUCURSAL4;

CREATE VIEW ProductorView AS 
SELECT * FROM kdekilo1.PRODUCTOR1
UNION
SELECT * FROM PRODUCTOR2
UNION
SELECT * FROM kdekilo3.PRODUCTOR3
UNION
SELECT * FROM kdekilo4.PRODUCTOR4;

CREATE VIEW VinoView AS 
SELECT * FROM kdekilo1.VINO1
UNION
SELECT * FROM VINO2
UNION
SELECT * FROM kdekilo3.VINO3
UNION
SELECT * FROM kdekilo4.VINO4;

CREATE VIEW EmpleadoView AS 
SELECT * FROM kdekilo1.EMPLEADO1
UNION
SELECT * FROM EMPLEADO2
UNION
SELECT * FROM kdekilo3.EMPLEADO3
UNION
SELECT * FROM kdekilo4.EMPLEADO4;

CREATE VIEW ClienteView AS 
SELECT * FROM kdekilo1.CLIENTE1
UNION
SELECT * FROM CLIENTE2
UNION
SELECT * FROM kdekilo3.CLIENTE3
UNION
SELECT * FROM kdekilo4.CLIENTE4;

CREATE VIEW PedidoView AS 
SELECT * FROM kdekilo1.PEDIDO1
UNION
SELECT * FROM PEDIDO2
UNION
SELECT * FROM kdekilo3.PEDIDO3
UNION
SELECT * FROM kdekilo4.PEDIDO4;

CREATE VIEW SuministroView AS 
SELECT * FROM kdekilo1.SUMINISTRO1
UNION
SELECT * FROM SUMINISTRO2
UNION
SELECT * FROM kdekilo3.SUMINISTRO3
UNION
SELECT * FROM kdekilo4.SUMINISTRO4;

CREATE VIEW PideVinoAView AS
SELECT * FROM PIDEVINOA;




-- El director es NULL de momento y lo actualizaremos al insertar los empleados
INSERT INTO SUCURSAL2 VALUES(7, 'Catedral del Mar', 'Barcelona', 'Cataluña', NULL);
INSERT INTO SUCURSAL2 VALUES(8, 'Dama de Elche', 'Alicante', 'País Valenciano', NULL);
INSERT INTO SUCURSAL2 VALUES(9, 'La Cartuja', 'Palma de Mallorca', 'Baleares', NULL);


INSERT INTO EMPLEADO2 VALUES(13, 7, '13131313M', 'Patricia', TO_DATE('04-DIC-2014', 'DD-MON-YYYY'), 2000, 'Diagonal 132, Barcelona');
INSERT INTO EMPLEADO2 VALUES(14, 7, '14141414N', 'Ines', TO_DATE('07-MAR-2014', 'DD-MON-YYYY'), 1800, 'Colon 24, Barcelona');
INSERT INTO EMPLEADO2 VALUES(15, 8, '15151515O', 'Carlos', TO_DATE('16-JUN-2015', 'DD-MON-YYYY'), 2000, 'Palmeras 57, Alicante');
INSERT INTO EMPLEADO2 VALUES(16, 8, '16161616P', 'Dolores', TO_DATE('14-MAY-2012', 'DD-MON-YYYY'), 1800, 'Calatrava 9, Alicante');
INSERT INTO EMPLEADO2 VALUES(17, 9, '17171717Q', 'Elías', TO_DATE('13-JUN-2011', 'DD-MON-YYYY'), 2000, 'Arenal 17, P. Mallorca');
INSERT INTO EMPLEADO2 VALUES(18, 9, '18181818R', 'Concepcion', TO_DATE('18-AGO-2013', 'DD-MON-YYYY'), 1800, 'Campastilla 14, P.Mallorca');

-- Actualizamos los directores de las sucursales
UPDATE SUCURSAL2 SET CODDIRECTOR=13 WHERE CODSU=7;
UPDATE SUCURSAL2 SET CODDIRECTOR=15 WHERE CODSU=8;
UPDATE SUCURSAL2 SET CODDIRECTOR=17 WHERE CODSU=9;


INSERT INTO VINO2 VALUES(5, 'Rene Barbier', 2018, 'Penedes', 11.5, 'Virgen de Estrella', 200, 200, 'Cataluña', NULL);
INSERT INTO VINO2 VALUES(6, 'Rene Barbier', 2010, 'Penedes', 11, 'Virgen de Estrella', 250, 250, 'Cataluña', NULL);
INSERT INTO VINO2 VALUES(13, 'Vega Murciana', 2018, 'Jumilla', 11.5, 'Vega Verde', 250, 250, 'La Rioja', NULL);
INSERT INTO VINO2 VALUES(16, 'Freixenet', 2019, 'Cava', 7.5, 'Valle Dorado', 250, 250, 'La Rioja', NULL);



INSERT INTO PRODUCTOR2 VALUES(3, '37373737C','Paloma Riquelme', 'Antonio Gaudi 23, Barcelona');
INSERT INTO PRODUCTOR2 VALUES(5, '39393939E','Ramon Esteban', 'Gran Via de Colon 121, Madrid');
INSERT INTO PRODUCTOR2 VALUES(6, '40404040F','Carlota Fuentes', 'Cruz de los Angeles 29, Oviedo');


UPDATE VINO2 SET CODPR=3 WHERE CODVIN=5;
UPDATE VINO2 SET CODPR=3 WHERE CODVIN=6;
UPDATE VINO2 SET CODPR=5 WHERE CODVIN=13;
UPDATE VINO2 SET CODPR=6 WHERE CODVIN=16;



INSERT INTO CLIENTE2 VALUES(5, '30303030E', 'Restaurante El Payes', 'San Lucas 33, Mahón', 'C', 'Baleares');
INSERT INTO CLIENTE2 VALUES(6, '31313131F', 'Mercadona', 'Desamparados 29, Castellon', 'A', 'Pais Valenciano');



INSERT INTO SUMINISTRO2 VALUES(5, 16, 7, 50, TO_DATE('14-AGO-2023', 'DD-MON-YYYY'));
INSERT INTO SUMINISTRO2 VALUES(5, 18, 9, 100, TO_DATE('01-OCT-2023', 'DD-MON-YYYY'));
INSERT INTO SUMINISTRO2 VALUES(6, 15, 8, 100, TO_DATE('13-ENE-2023', 'DD-MON-YYYY'));
INSERT INTO SUMINISTRO2 VALUES(6, 9, 8, 150, TO_DATE('19-FEB-2023', 'DD-MON-YYYY'));
INSERT INTO SUMINISTRO2 VALUES(6, 19, 9, 160, TO_DATE('27-JUN-2023', 'DD-MON-YYYY'));
INSERT INTO SUMINISTRO2 VALUES(6, 21, 7, 200, TO_DATE('17-SEP-2023', 'DD-MON-YYYY'));



INSERT INTO PIDEVINOA VALUES(1, 1, 4, 4, 100, TO_DATE('13-JUN-2023', 'DD-MON-YYYY'));
INSERT INTO PIDEVINOA VALUES(2, 1, 10, 7, 50, TO_DATE('05-MAY-2023', 'DD-MON-YYYY'));
INSERT INTO PIDEVINOA VALUES(3, 2, 7, 5, 150, TO_DATE('12-JUL-2023', 'DD-MON-YYYY'));
INSERT INTO PIDEVINOA VALUES(4, 2, 5, 2, 20, TO_DATE('04-ABR-2023', 'DD-MON-YYYY'));
INSERT INTO PIDEVINOA VALUES(5, 2, 8, 6, 40, TO_DATE('16-SEP-2023', 'DD-MON-YYYY'));
INSERT INTO PIDEVINOA VALUES(6, 3, 6, 14, 200, TO_DATE('15-JUL-2023', 'DD-MON-YYYY'));
INSERT INTO PIDEVINOA VALUES(7, 3, 9, 16, 100, TO_DATE('21-SEP-2023', 'DD-MON-YYYY'));
INSERT INTO PIDEVINOA VALUES(8, 4, 1, 10, 70, TO_DATE('22-JUN-2023', 'DD-MON-YYYY'));
INSERT INTO PIDEVINOA VALUES(9, 4, 7, 6, 70, TO_DATE('22-MAY-2023', 'DD-MON-YYYY'));
INSERT INTO PIDEVINOA VALUES(10, 5, 10, 7, 50, TO_DATE('13-JUN-2023', 'DD-MON-YYYY'));
INSERT INTO PIDEVINOA VALUES(11, 7, 2, 21, 200, TO_DATE('05-MAY-2023', 'DD-MON-YYYY'));
INSERT INTO PIDEVINOA VALUES(12, 8, 11, 15, 100, TO_DATE('12-JUL-2023', 'DD-MON-YYYY'));
INSERT INTO PIDEVINOA VALUES(13, 8, 2, 9, 150, TO_DATE('04-ABR-2023', 'DD-MON-YYYY'));
INSERT INTO PIDEVINOA VALUES(14, 9, 3, 18, 100, TO_DATE('16-SEP-2023', 'DD-MON-YYYY'));
INSERT INTO PIDEVINOA VALUES(15, 9, 12, 19, 160, TO_DATE('15-JUL-2023', 'DD-MON-YYYY'));
INSERT INTO PIDEVINOA VALUES(16, 10, 4, 3, 100, TO_DATE('21-SEP-2023', 'DD-MON-YYYY'));
INSERT INTO PIDEVINOA VALUES(17, 10, 8, 6, 90, TO_DATE('22-JUN-2023', 'DD-MON-YYYY'));
INSERT INTO PIDEVINOA VALUES(18, 11, 9, 13, 200, TO_DATE('22-MAY-2023', 'DD-MON-YYYY'));
INSERT INTO PIDEVINOA VALUES(19, 12, 4, 17, 70, TO_DATE('04-MAY-2023', 'DD-MON-YYYY'));




-- El salario de un empleado no puede disminuir
CREATE OR REPLACE TRIGGER salario_no_disminuye
BEFORE UPDATE OF SALARIO ON EMPLEADO2
FOR EACH ROW
BEGIN
    IF :NEW.SALARIO < :OLD.SALARIO THEN
        RAISE_APPLICATION_ERROR(-20001, 'El salario de un empleado no puede disminuir.');
    END IF;
END;


-- Un cliente solo puede hacer pedidos a través de la sucursal de su comunidad
CREATE OR REPLACE TRIGGER verificar_comunidad_autonoma
BEFORE INSERT OR UPDATE ON SUMINISTRO2
FOR EACH ROW
DECLARE
    comAutonomaCliente VARCHAR2(20);
    comAutonomaSucursal VARCHAR2(20);
BEGIN
    -- Obtener la comunidad autónoma del cliente
    SELECT COMAUTONOMA INTO comAutonomaCliente FROM ClienteView WHERE CODCL = :NEW.CODCL;
    
    -- Obtener la comunidad autónoma de la sucursal
    SELECT COMAUTONOMA INTO comAutonomaSucursal FROM SucursalView WHERE CODSU = :NEW.CODSU;

    -- Verificar si coinciden
    IF comAutonomaCliente != comAutonomaSucursal THEN
        RAISE_APPLICATION_ERROR(-20002, 'La comunidad autónoma de la sucursal debe coincidir con la del cliente.');
    END IF;
END;

-- la fecha de un suministro tendrá que ser siempre igual o posterior a la fecha de su último suministro.
CREATE OR REPLACE TRIGGER verificar_fecha_suministro
BEFORE INSERT ON SUMINISTRO2
FOR EACH ROW
DECLARE
    ultimaFechaSuministro DATE;
BEGIN
    -- Obtener la fecha del último suministro para este cliente
    SELECT MAX(FECHASUMINISTRO) INTO ultimaFechaSuministro FROM SUMINISTRO2 WHERE CODCL = :NEW.CODCL;

    -- Verificar si la nueva fecha es válida
    IF ultimaFechaSuministro IS NOT NULL AND :NEW.FECHASUMINISTRO < ultimaFechaSuministro THEN
        RAISE_APPLICATION_ERROR(-20003, 'La fecha del suministro debe ser igual o posterior a la del último suministro.');
    END IF;
END;

-- El stock de un vino nunca puede ser negativo ni mayor que la cantidad producida. 
CREATE OR REPLACE TRIGGER verificar_stock_vino
BEFORE INSERT OR UPDATE ON VINO2
FOR EACH ROW
BEGIN
    IF :NEW.CANTSTOCK < 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'El stock de un vino no puede ser negativo.');
    ELSIF :NEW.CANTSTOCK > :NEW.CANTPRODUCIDA THEN
        RAISE_APPLICATION_ERROR(-20006, 'El stock de un vino no puede exceder la cantidad producida.');
    END IF;
END;

-- Solo se puede eliminar un vino si la cantidad total suministrada de ese vino es 0 
CREATE OR REPLACE TRIGGER verificar_suministros_vino
BEFORE DELETE ON VINO2
FOR EACH ROW
DECLARE
    totalSuministrado INT;
BEGIN
    -- Calcular la cantidad total suministrada de este vino
    SELECT SUM(CANTIDAD) INTO totalSuministrado FROM SUMINISTRO2 WHERE CODVIN = :OLD.CODVIN;

    -- Verificar si la cantidad suministrada es mayor que 0
    IF totalSuministrado > 0 THEN
        RAISE_APPLICATION_ERROR(-20007, 'No se puede eliminar un vino que ha sido suministrado.');
    END IF;
END;

--  Solo se puede eliminar un productor si sus vinos no se han vendido nunca
CREATE OR REPLACE TRIGGER verificar_eliminar_prod
BEFORE DELETE ON PRODUCTOR2
FOR EACH ROW
DECLARE
    suministroExistente INT;
BEGIN
    -- Verificar si hay suministros para los vinos producidos por este productor
    SELECT COUNT(*) INTO suministroExistente
    FROM VINO2 V
    JOIN SUMINISTRO2 S ON V.CODVIN = S.CODVIN
    WHERE V.CODPR = :OLD.CODPR
    AND S.CANTIDAD > 0;

    -- Si hay suministros, impedir la eliminación
    IF suministroExistente > 0 THEN
        RAISE_APPLICATION_ERROR(-20008, 'No se puede eliminar un productor con vinos suministrados.');
    END IF;
END;


SELECT * FROM PIDEVINOA;
SELECT * FROM SUMINISTRO2;
-- La fecha del pedido de una sucursal a otra de un vino tiene que ser posterior a la fecha del último pedido similar.
CREATE OR REPLACE TRIGGER verificar_fecha_pedido
BEFORE INSERT ON PIDEVINOA
FOR EACH ROW
DECLARE
    ultima_fecha DATE;
BEGIN
    -- Buscar la fecha del último pedido de S1 a S2 para el mismo vino
    SELECT MAX(FECHAPEDIDO) INTO ultima_fecha
    FROM PIDEVINOA
    WHERE CODSU1 = :NEW.CODSU1 
      AND CODSU2 = :NEW.CODSU2 
      AND CODVIN = :NEW.CODVIN;

    -- Verificar si la fecha del nuevo pedido es posterior a la última fecha de pedido
    IF :NEW.FECHAPEDIDO <= ultima_fecha THEN
        RAISE_APPLICATION_ERROR(-20011, 'La fecha del pedido debe ser posterior a la fecha del último pedido de este vino entre las sucursales.');
    END IF;
END;

-- La fecha de pedido de un vino de una sucursal a otra tiene que ser posterior a la última fecha de solicitud 
-- de suministro de ese mismo vino recibida enS1 por un cliente
CREATE OR REPLACE TRIGGER verificar_fecha_pedido2
BEFORE INSERT ON PIDEVINOA
FOR EACH ROW
DECLARE
    ultima_fecha_suministro DATE;
BEGIN
    -- Buscar la última fecha de solicitud de suministro de ese vino a la sucursal S1
    SELECT MAX(FECHASUMINISTRO) INTO ultima_fecha_suministro
    FROM SuministroView
    WHERE CODVIN = :NEW.CODVIN AND CODSU = :NEW.CODSU1;

    -- Verificar si la fecha del nuevo pedido es posterior a la última fecha de suministro
    IF :NEW.FECHAPEDIDO <= ultima_fecha_suministro THEN
        RAISE_APPLICATION_ERROR(-20013, 'La fecha del pedido debe ser posterior a la última fecha de solicitud de suministro del mismo vino a la sucursal.');
    END IF;
END;








-- PROCEDIMIENTOS




-- 1. Dar de alta un nuevo empleado
CREATE OR REPLACE PROCEDURE AltaNuevoEmpleado
    (NEW_CODEM INT, NEW_DNI IN EMPLEADO2.DNI%TYPE, NEW_NOMBRE IN EMPLEADO2.NOMBRE%TYPE, NEW_FECHACONTRATO DATE, NEW_SALARIO INT,
    NEW_DIRECCION IN EMPLEADO2.DIRECCION%TYPE, NEW_CODSU INT)
IS 
    nSucursales INT;
    nEmpleados INT;
    comAutSucursal SUCURSAL2.COMAUTONOMA%TYPE; 
BEGIN
    SELECT COUNT(*) INTO nSucursales FROM SucursalView WHERE CODSU = new_CODSU;
    SELECT COUNT(*) INTO nEmpleados FROM EmpleadoView WHERE CODEM = new_CODEM;
    
    IF nSucursales = 0 THEN
        raise_application_error(-20101, 'ERROR: No existe una sucursal con ese código');
    ELSIF nEmpleados > 0 THEN
        raise_application_error(-20101, 'ERROR: Ya existe un empleado con ese código');
    ELSE
        SELECT COMAUTONOMA INTO comAutSucursal FROM SucursalView WHERE CODSU = new_CODSU;
        CASE
            WHEN (comAutSucursal = 'Castilla-Leon' OR comAutSucursal = 'Castilla-La Mancha' OR comAutSucursal = 'Aragon' OR comAutSucursal = 'Madrid' OR comAutSucursal = 'La Rioja') THEN
                INSERT INTO kdekilo1.EMPLEADO1 VALUES(NEW_CODEM, NEW_CODSU, NEW_DNI, NEW_NOMBRE, NEW_FECHACONTRATO, NEW_SALARIO, NEW_DIRECCION);
            WHEN (comAutSucursal = 'Cataluña' OR comAutSucursal = 'Baleares' OR comAutSucursal = 'Pais Valenciano' OR comAutSucursal = 'Murcia') THEN
                INSERT INTO EMPLEADO2 VALUES(NEW_CODEM, NEW_CODSU, NEW_DNI, NEW_NOMBRE, NEW_FECHACONTRATO, NEW_SALARIO, NEW_DIRECCION);
            WHEN (comAutSucursal = 'Galicia' OR comAutSucursal = 'Asturias' OR comAutSucursal = 'Cantabria' OR comAutSucursal = 'Pais Vasco' OR comAutSucursal = 'Navarra') THEN
                INSERT INTO kdekilo3.EMPLEADO3 VALUES(NEW_CODEM, NEW_CODSU, NEW_DNI, NEW_NOMBRE, NEW_FECHACONTRATO, NEW_SALARIO, NEW_DIRECCION);
            WHEN (comAutSucursal = 'Andalucia' OR comAutSucursal = 'Extremadura' OR comAutSucursal = 'Canarias' OR comAutSucursal = 'Ceuta' OR comAutSucursal = 'Melilla') THEN
                INSERT INTO kdekilo4.EMPLEADO4 VALUES(NEW_CODEM, NEW_CODSU, NEW_DNI, NEW_NOMBRE, NEW_FECHACONTRATO, NEW_SALARIO, NEW_DIRECCION);
        END CASE;
        DBMS_OUTPUT.PUT_LINE('Empleado introducido correctamente');
    END IF;
END AltaNuevoEmpleado;


BEGIN
    AltaNuevoEmpleado(123, '12345678Z', 'Juan Pérez', TO_DATE('2024-01-15', 'YYYY-MM-DD'), 300, 'Calle Falsa 123', 4);
END;


-- 2. Dar de baja a un empleado.
CREATE OR REPLACE PROCEDURE BajaEmpleado 
    (OLD_CODEM INT) 
IS
    nDirector INT;
    codSucursal INT;
    nEmpleado INT;
    comAutSucursal SUCURSAL2.COMAUTONOMA%TYPE; 
BEGIN
    SELECT COUNT(*) INTO nDirector FROM SucursalView WHERE CODDIRECTOR = OLD_CODEM;
    SELECT COUNT(*) INTO nEmpleado FROM EmpleadoView WHERE CODEM = OLD_CODEM;
    
    
    IF nEmpleado = 0 THEN
        raise_application_error(-20101, 'ERROR: No existe ningun empleado con ese código');
    ELSE
        SELECT CODSU INTO codSucursal FROM EmpleadoView WHERE CODEM=OLD_CODEM;
        IF nDirector > 0 THEN
            DBMS_OUTPUT.PUT_LINE('La sucursal con codigo ' || codSucursal || ' se queda sin director');
        END IF;
        
        SELECT COMAUTONOMA INTO comAutSucursal FROM SucursalView WHERE CODSU = codSucursal;
        CASE
            WHEN (comAutSucursal = 'Castilla-Leon' OR comAutSucursal = 'Castilla-La Mancha' OR comAutSucursal = 'Aragon' OR comAutSucursal = 'Madrid' OR comAutSucursal = 'La Rioja') THEN
                DELETE FROM kdekilo1.EMPLEADO1 WHERE CODEM=OLD_CODEM;
            WHEN (comAutSucursal = 'Cataluña' OR comAutSucursal = 'Baleares' OR comAutSucursal = 'Pais Valenciano' OR comAutSucursal = 'Murcia') THEN
                DELETE FROM EMPLEADO2 WHERE CODEM=OLD_CODEM;
            WHEN (comAutSucursal = 'Galicia' OR comAutSucursal = 'Asturias' OR comAutSucursal = 'Cantabria' OR comAutSucursal = 'Pais Vasco' OR comAutSucursal = 'Navarra') THEN
                DELETE FROM kdekilo3.EMPLEADO3 WHERE CODEM=OLD_CODEM;
            WHEN (comAutSucursal = 'Andalucia' OR comAutSucursal = 'Extremadura' OR comAutSucursal = 'Canarias' OR comAutSucursal = 'Ceuta' OR comAutSucursal = 'Melilla') THEN
                DELETE FROM kdekilo4.EMPLEADO4 WHERE CODEM=OLD_CODEM;
        END CASE;
    END IF;    
    DBMS_OUTPUT.PUT_LINE('Empleado dado de baja');
END BajaEmpleado;


BEGIN
    BajaEmpleado(123);
END;
SELECT * FROM EmpleadoView;


-- 3. Modificar el salario de un empleado. Argumentos: Código de empleado y nuevo salario.
CREATE OR REPLACE PROCEDURE ModificarSalarioEmpleado
    (NEW_CODEM INT, NEW_SALARIO INT)
IS 
    nEmpleados INT;
    comAutSucursal SUCURSAL2.COMAUTONOMA%TYPE; 
    codSucursal INT;
BEGIN
    SELECT COUNT(*) INTO nEmpleados FROM EmpleadoView WHERE CODEM = NEW_CODEM;
    
    IF nEmpleados = 0 THEN
        raise_application_error(-20101, 'ERROR: No existe ningun empleado con ese código');
    ELSE
        SELECT CODSU INTO codSucursal FROM EmpleadoView WHERE CODEM=NEW_CODEM;
        SELECT COMAUTONOMA INTO comAutSucursal FROM SucursalView WHERE CODSU = codSucursal;
        CASE
            WHEN (comAutSucursal = 'Castilla-Leon' OR comAutSucursal = 'Castilla-La Mancha' OR comAutSucursal = 'Aragon' OR comAutSucursal = 'Madrid' OR comAutSucursal = 'La Rioja') THEN
                UPDATE kdekilo1.EMPLEADO1 SET SALARIO = NEW_SALARIO WHERE CODEM = NEW_CODEM;
            WHEN (comAutSucursal = 'Cataluña' OR comAutSucursal = 'Baleares' OR comAutSucursal = 'País Valenciano' OR comAutSucursal = 'Murcia') THEN
                UPDATE EMPLEADO2 SET SALARIO = NEW_SALARIO WHERE CODEM = NEW_CODEM;
            WHEN (comAutSucursal = 'Galicia' OR comAutSucursal = 'Asturias' OR comAutSucursal = 'Cantabria' OR comAutSucursal = 'Pais Vasco' OR comAutSucursal = 'Navarra') THEN
                UPDATE kdekilo3.EMPLEADO3 SET SALARIO = NEW_SALARIO WHERE CODEM = NEW_CODEM;
            WHEN (comAutSucursal = 'Andalucia' OR comAutSucursal = 'Extremadura' OR comAutSucursal = 'Canarias' OR comAutSucursal = 'Ceuta' OR comAutSucursal = 'Melilla') THEN
                UPDATE kdekilo4.EMPLEADO4 SET SALARIO = NEW_SALARIO WHERE CODEM = NEW_CODEM;
        END CASE;
        DBMS_OUTPUT.PUT_LINE('Salario modificado correctamente');
    END IF;
END ModificarSalarioEmpleado;


INSERT INTO kdekilo2.EMPLEADO2 VALUES(NEW_CODEM, NEW_CODSU, NEW_DNI, NEW_NOMBRE, NEW_FECHACONTRATO, NEW_SALARIO, NEW_DIRECCION);

BEGIN
    ModificarSalarioEmpleado(123, 50001);
END;



-- 4. Trasladar de sucursal a un empleado.
CREATE OR REPLACE PROCEDURE TrasladarEmpleadoSucursal
    (NEW_CODEM INT, NEW_CODSU INT, NEW_DIRECCION IN EMPLEADO2.DIRECCION%TYPE DEFAULT NULL)
IS 
    nEmpleados INT;
    nSucursal INT;
    comAutSucursal SUCURSAL2.COMAUTONOMA%TYPE; 
    FCONTRATO DATE;
    SUELDO INT;
    NEW_DNI EMPLEADO2.DNI%TYPE;
    NEW_NOMBRE EMPLEADO2.NOMBRE%TYPE;
BEGIN
    SELECT COUNT(*) INTO nEmpleados FROM EmpleadoView WHERE CODEM = NEW_CODEM;
    SELECT COUNT(*) INTO nSucursal FROM SucursalView WHERE CODSU = NEW_CODSU;
    IF nEmpleados = 0 THEN
        raise_application_error(-20101, 'ERROR: No existe ningun empleado con ese código');
    ELSIF nSucursal = 0 THEN
        raise_application_error(-20101, 'ERROR: No existe ninguna sucursal con ese código');
    ELSE
        SELECT COMAUTONOMA INTO comAutSucursal FROM SucursalView WHERE CODSU = NEW_CODSU;
        SELECT FECHACONTRATO, SALARIO, DNI, NOMBRE INTO FCONTRATO, SUELDO, NEW_DNI, NEW_NOMBRE FROM EmpleadoView WHERE CODEM = NEW_CODEM;
        -- Elimino el empleado de su sucursal anterior
        BEGIN
            BajaEmpleado(NEW_CODEM);
        END;
        -- Añado el empleado a la sucursal nueva
        BEGIN
            AltaNuevoEmpleado(NEW_CODEM, NEW_DNI, NEW_NOMBRE, FCONTRATO, SUELDO, NEW_DIRECCION, NEW_CODSU);
        END;
        DBMS_OUTPUT.PUT_LINE('Traslado completado');
    END IF;
END TrasladarEmpleadoSucursal;


BEGIN
    TrasladarEmpleadoSucursal(123, 7, 'direccion falsa');
END;




-- 5. Dar de alta una nueva sucursal
CREATE OR REPLACE PROCEDURE AltaNuevaSucursal
    (NEW_CODSU IN SUCURSAL2.CODSU%TYPE, NEW_NOMBRE IN SUCURSAL2.NOMBRE%TYPE, NEW_CIUDAD IN SUCURSAL2.CIUDAD%TYPE, NEW_COMAUTONOMA IN SUCURSAL2.COMAUTONOMA%TYPE,
    NEW_CODDIRECTOR INT DEFAULT NULL)
IS 
    nSucursales INT;
BEGIN
    SELECT COUNT(*) INTO nSucursales FROM SucursalView WHERE CODSU = new_CODSU;
    
    IF nSucursales > 0 THEN
        raise_application_error(-20101, 'ERROR: Ya existe una sucursal con ese código');

    ELSE
        CASE
            WHEN (NEW_COMAUTONOMA = 'Castilla-Leon' OR NEW_COMAUTONOMA = 'Castilla-La Mancha' OR NEW_COMAUTONOMA = 'Aragon' OR NEW_COMAUTONOMA = 'Madrid' OR NEW_COMAUTONOMA = 'La Rioja') THEN
                INSERT INTO kdekilo1.SUCURSAL1 VALUES(NEW_CODSU, NEW_NOMBRE, NEW_CIUDAD, NEW_COMAUTONOMA, NEW_CODDIRECTOR);
            WHEN (NEW_COMAUTONOMA = 'Cataluña' OR NEW_COMAUTONOMA = 'Baleares' OR NEW_COMAUTONOMA = 'Pais Valenciano' OR NEW_COMAUTONOMA = 'Murcia') THEN
                INSERT INTO SUCURSAL2 VALUES(NEW_CODSU, NEW_NOMBRE, NEW_CIUDAD, NEW_COMAUTONOMA, NEW_CODDIRECTOR);
            WHEN (NEW_COMAUTONOMA = 'Galicia' OR NEW_COMAUTONOMA = 'Asturias' OR NEW_COMAUTONOMA = 'Cantabria' OR NEW_COMAUTONOMA = 'Pais Vasco' OR NEW_COMAUTONOMA = 'Navarra') THEN
                INSERT INTO kdekilo3.SUCURSAL3 VALUES(NEW_CODSU, NEW_NOMBRE, NEW_CIUDAD, NEW_COMAUTONOMA, NEW_CODDIRECTOR);
            WHEN (NEW_COMAUTONOMA = 'Andalucia' OR NEW_COMAUTONOMA = 'Extremadura' OR NEW_COMAUTONOMA = 'Canarias' OR NEW_COMAUTONOMA = 'Ceuta' OR NEW_COMAUTONOMA = 'Melilla') THEN
                INSERT INTO kdekilo4.SUCURSAL4 VALUES(NEW_CODSU, NEW_NOMBRE, NEW_CIUDAD, NEW_COMAUTONOMA, NEW_CODDIRECTOR);
        END CASE;
        DBMS_OUTPUT.PUT_LINE('Empleado introducido correctamente');
    END IF;
END AltaNuevaSucursal;


BEGIN
    AltaNuevaSucursal(123, 'sucursal', 'ciudad', 'Andalucia');
END;



SELECT * FROM SucursalView;

DELETE FROM kdekilo4.SUCURSAL4 WHERE CODSU=123;

-- 6. Cambiar el director de una sucursal. 
CREATE OR REPLACE PROCEDURE CambiarDirectorSucursal 
    (NEW_CODSU INT, NEW_CODDIRECTOR INT) 
IS
    nSucursal INT;
    comAutSucursal SUCURSAL2.COMAUTONOMA%TYPE; 
BEGIN
    SELECT COUNT(*) INTO nSucursal FROM SucursalView WHERE CODSU = NEW_CODSU;    
    
    IF nSucursal = 0 THEN
        raise_application_error(-20101, 'ERROR: No existe ninguna sucursal con ese código');
    ELSE        
        SELECT COMAUTONOMA INTO comAutSucursal FROM SucursalView WHERE CODSU = NEW_CODSU;
        CASE
            WHEN (comAutSucursal = 'Castilla-Leon' OR comAutSucursal = 'Castilla-La Mancha' OR comAutSucursal = 'Aragon' OR comAutSucursal = 'Madrid' OR comAutSucursal = 'La Rioja') THEN
                UPDATE kdekilo1.SUCURSAL1 SET CODDIRECTOR = NEW_CODDIRECTOR WHERE CODSU = NEW_CODSU;
            WHEN (comAutSucursal = 'Cataluña' OR comAutSucursal = 'Baleares' OR comAutSucursal = 'Pais Valenciano' OR comAutSucursal = 'Murcia') THEN
                UPDATE SUCURSAL2 SET CODDIRECTOR = NEW_CODDIRECTOR WHERE CODSU = NEW_CODSU;
            WHEN (comAutSucursal = 'Galicia' OR comAutSucursal = 'Asturias' OR comAutSucursal = 'Cantabria' OR comAutSucursal = 'Pais Vasco' OR comAutSucursal = 'Navarra') THEN
                UPDATE kdekilo3.SUCURSAL3 SET CODDIRECTOR = NEW_CODDIRECTOR WHERE CODSU = NEW_CODSU;
            WHEN (comAutSucursal = 'Andalucia' OR comAutSucursal = 'Extremadura' OR comAutSucursal = 'Canarias' OR comAutSucursal = 'Ceuta' OR comAutSucursal = 'Melilla') THEN
                UPDATE kdekilo4.SUCURSAL4 SET CODDIRECTOR = NEW_CODDIRECTOR WHERE CODSU = NEW_CODSU;
        END CASE;
    END IF;    
    DBMS_OUTPUT.PUT_LINE('Director cambiado');
END CambiarDirectorSucursal;


BEGIN
    CambiarDirectorSucursal(1, 1);
END;
SELECT * FROM SucursalView;



SELECT * FROM ClienteView;

-- 7. Dar de alta a un nuevo cliente
CREATE OR REPLACE PROCEDURE AltaNuevoCliente
    (NEW_CODCL INT, NEW_DNI IN CLIENTE2.DNI%TYPE, NEW_NOMBRE IN CLIENTE2.NOMBRE%TYPE, NEW_DIRECCION IN CLIENTE2.DIRECCION%TYPE,
    NEW_TIPO IN CLIENTE2.TIPO%TYPE, NEW_COMAUTONOMA IN CLIENTE2.COMAUTONOMA%TYPE)
IS 
    nCliente INT;
BEGIN
    SELECT COUNT(*) INTO nCliente FROM ClienteView WHERE CODCL = NEW_CODCL;
    
    IF nCliente > 0 THEN
        raise_application_error(-20101, 'ERROR: Ya existe un cliente con ese código');
    ELSE
        CASE
            WHEN (NEW_COMAUTONOMA = 'Castilla-Leon' OR NEW_COMAUTONOMA = 'Castilla-La Mancha' OR NEW_COMAUTONOMA = 'Aragon' OR NEW_COMAUTONOMA = 'Madrid' OR NEW_COMAUTONOMA = 'La Rioja') THEN
                INSERT INTO kdekilo1.CLIENTE1 VALUES(NEW_CODCL, NEW_DNI, NEW_NOMBRE, NEW_DIRECCION, NEW_TIPO, NEW_COMAUTONOMA);
            WHEN (NEW_COMAUTONOMA = 'Cataluña' OR NEW_COMAUTONOMA = 'Baleares' OR NEW_COMAUTONOMA = 'Pais Valenciano' OR NEW_COMAUTONOMA = 'Murcia') THEN
                INSERT INTO CLIENTE2 VALUES(NEW_CODCL, NEW_DNI, NEW_NOMBRE, NEW_DIRECCION, NEW_TIPO, NEW_COMAUTONOMA);
            WHEN (NEW_COMAUTONOMA = 'Galicia' OR NEW_COMAUTONOMA = 'Asturias' OR NEW_COMAUTONOMA = 'Cantabria' OR NEW_COMAUTONOMA = 'Pais Vasco' OR NEW_COMAUTONOMA = 'Navarra') THEN
                INSERT INTO kdekilo3.CLIENTE3 VALUES(NEW_CODCL, NEW_DNI, NEW_NOMBRE, NEW_DIRECCION, NEW_TIPO, NEW_COMAUTONOMA);
            WHEN (NEW_COMAUTONOMA = 'Andalucia' OR NEW_COMAUTONOMA = 'Extremadura' OR NEW_COMAUTONOMA = 'Canarias' OR NEW_COMAUTONOMA = 'Ceuta' OR NEW_COMAUTONOMA = 'Melilla') THEN
                INSERT INTO kdekilo4.CLIENTE4 VALUES(NEW_CODCL, NEW_DNI, NEW_NOMBRE, NEW_DIRECCION, NEW_TIPO, NEW_COMAUTONOMA);
        END CASE;
        DBMS_OUTPUT.PUT_LINE('Empleado introducido correctamente');
    END IF;
END AltaNuevoCliente;


BEGIN
    AltaNuevoCliente(123, '87083278A', 'ClientePrueba', 'direccion falsa', 'A', 'Madrid');
END;

SELECT * FROM ClienteView;
DELETE FROM kdekilo1.CLIENTE1 WHERE CODCL=123;



SELECT * FROM SuministroView;
-- 8. Dar de alta o actualizar un suministro. 
CREATE OR REPLACE PROCEDURE ActualizarSuministro
    (NEW_CODCL INT, NEW_CODSU INT, NEW_CODVIN INT, NEW_FECHA DATE, NEW_CANTIDAD INT)
IS 
    nSuministros INT;
    comAutSucursal SUCURSAL2.COMAUTONOMA%TYPE; 
BEGIN
    SELECT COUNT(*) INTO nSuministros FROM SuministroView WHERE CODCL = NEW_CODCL AND CODVIN = NEW_CODVIN AND CODSU = NEW_CODSU AND FECHASUMINISTRO = NEW_FECHA;
    SELECT COMAUTONOMA INTO comAutSucursal FROM SucursalView WHERE CODSU = NEW_CODSU;
    
    IF nSuministros > 0 THEN -- hay que actualizar el suministro
         CASE
            WHEN (comAutSucursal = 'Castilla-Leon' OR comAutSucursal = 'Castilla-La Mancha' OR comAutSucursal = 'Aragon' OR comAutSucursal = 'Madrid' OR comAutSucursal = 'La Rioja') THEN
                UPDATE kdekilo1.SUMINISTRO1 SET CANTIDAD = CANTIDAD + NEW_CANTIDAD WHERE CODCL = NEW_CODCL AND CODVIN = NEW_CODVIN AND CODSU = NEW_CODSU AND FECHASUMINISTRO = NEW_FECHA;
            WHEN (comAutSucursal = 'Cataluña' OR comAutSucursal = 'Baleares' OR comAutSucursal = 'Pais Valenciano' OR comAutSucursal = 'Murcia') THEN
                UPDATE SUMINISTRO2 SET CANTIDAD = CANTIDAD + NEW_CANTIDAD WHERE CODCL = NEW_CODCL AND CODVIN = NEW_CODVIN AND CODSU = NEW_CODSU AND FECHASUMINISTRO = NEW_FECHA;
            WHEN (comAutSucursal = 'Galicia' OR comAutSucursal = 'Asturias' OR comAutSucursal = 'Cantabria' OR comAutSucursal = 'Pais Vasco' OR comAutSucursal = 'Navarra') THEN
                UPDATE kdekilo3.SUMINISTRO3 SET CANTIDAD = CANTIDAD + NEW_CANTIDAD WHERE CODCL = NEW_CODCL AND CODVIN = NEW_CODVIN AND CODSU = NEW_CODSU AND FECHASUMINISTRO = NEW_FECHA;
            WHEN (comAutSucursal = 'Andalucia' OR comAutSucursal = 'Extremadura' OR comAutSucursal = 'Canarias' OR comAutSucursal = 'Ceuta' OR comAutSucursal = 'Melilla') THEN
                UPDATE kdekilo4.SUMINISTRO4 SET CANTIDAD = CANTIDAD + NEW_CANTIDAD WHERE CODCL = NEW_CODCL AND CODVIN = NEW_CODVIN AND CODSU = NEW_CODSU AND FECHASUMINISTRO = NEW_FECHA;
        END CASE;
        DBMS_OUTPUT.PUT_LINE('Suministro modificado correctamente');
    ELSE -- hay que crear el suministro
        CASE
            WHEN (comAutSucursal = 'Castilla-Leon' OR comAutSucursal = 'Castilla-La Mancha' OR comAutSucursal = 'Aragon' OR comAutSucursal = 'Madrid' OR comAutSucursal = 'La Rioja') THEN
                INSERT INTO kdekilo1.SUMINISTRO1 VALUES(NEW_CODCL, NEW_CODVIN, NEW_CODSU, NEW_CANTIDAD, NEW_FECHA);
            WHEN (comAutSucursal = 'Cataluña' OR comAutSucursal = 'Baleares' OR comAutSucursal = 'Pais Valenciano' OR comAutSucursal = 'Murcia') THEN
                INSERT INTO SUMINISTRO2 VALUES(NEW_CODCL, NEW_CODVIN, NEW_CODSU, NEW_CANTIDAD, NEW_FECHA);
            WHEN (comAutSucursal = 'Galicia' OR comAutSucursal = 'Asturias' OR comAutSucursal = 'Cantabria' OR comAutSucursal = 'Pais Vasco' OR comAutSucursal = 'Navarra') THEN
                INSERT INTO kdekilo3.SUMINISTRO3 VALUES(NEW_CODCL, NEW_CODVIN, NEW_CODSU, NEW_CANTIDAD, NEW_FECHA);
            WHEN (comAutSucursal = 'Andalucia' OR comAutSucursal = 'Extremadura' OR comAutSucursal = 'Canarias' OR comAutSucursal = 'Ceuta' OR comAutSucursal = 'Melilla') THEN
                INSERT INTO kdekilo4.SUMINISTRO4 VALUES(NEW_CODCL, NEW_CODVIN, NEW_CODSU, NEW_CANTIDAD, NEW_FECHA);
        END CASE;
        DBMS_OUTPUT.PUT_LINE('Suministro creado correctamente');
    END IF;
END ActualizarSuministro;


BEGIN
    ActualizarSuministro(1, 1, 4, TO_DATE('01-ENE-2020', 'DD-MON-YYYY'), 33);
END;


SELECT * FROM SuministroView;
DELETE FROM kdekilo4.SUMINISTRO4 WHERE FECHASUMINISTRO = TO_DATE('01-ENE-2020', 'DD-MON-YYYY');


-- 9. Dar de baja suministros.
CREATE OR REPLACE PROCEDURE BajaSuministro
    (NEW_CODCL INT, NEW_CODSU INT, NEW_CODVIN INT, NEW_FECHA DATE DEFAULT NULL)
IS 
    nSuministros INT;
    comAutSucursal SUCURSAL2.COMAUTONOMA%TYPE; 
BEGIN
    SELECT COUNT(*) INTO nSuministros FROM SuministroView WHERE CODCL = NEW_CODCL AND CODVIN = NEW_CODVIN AND CODSU = NEW_CODSU;
    SELECT COMAUTONOMA INTO comAutSucursal FROM SucursalView WHERE CODSU = NEW_CODSU;
    
    IF nSuministros = 0 THEN 
         raise_application_error(-20101, 'ERROR: No existe ningun suministro con esas características');
    ELSE 
        CASE
            WHEN (comAutSucursal = 'Castilla-Leon' OR comAutSucursal = 'Castilla-La Mancha' OR comAutSucursal = 'Aragon' OR comAutSucursal = 'Madrid' OR comAutSucursal = 'La Rioja') THEN
                DELETE FROM kdekilo1.SUMINISTRO1 WHERE CODCL = NEW_CODCL AND CODVIN = NEW_CODVIN AND CODSU = NEW_CODSU AND (NEW_FECHA IS NULL OR FECHASUMINISTRO = NEW_FECHA);
            WHEN (comAutSucursal = 'Cataluña' OR comAutSucursal = 'Baleares' OR comAutSucursal = 'Pais Valenciano' OR comAutSucursal = 'Murcia') THEN
                DELETE FROM SUMINISTRO2 WHERE CODCL = NEW_CODCL AND CODVIN = NEW_CODVIN AND CODSU = NEW_CODSU AND (NEW_FECHA IS NULL OR FECHASUMINISTRO = NEW_FECHA);
            WHEN (comAutSucursal = 'Galicia' OR comAutSucursal = 'Asturias' OR comAutSucursal = 'Cantabria' OR comAutSucursal = 'Pais Vasco' OR comAutSucursal = 'Navarra') THEN
                DELETE FROM kdekilo3.SUMINISTRO3 WHERE CODCL = NEW_CODCL AND CODVIN = NEW_CODVIN AND CODSU = NEW_CODSU AND (NEW_FECHA IS NULL OR FECHASUMINISTRO = NEW_FECHA);
            WHEN (comAutSucursal = 'Andalucia' OR comAutSucursal = 'Extremadura' OR comAutSucursal = 'Canarias' OR comAutSucursal = 'Ceuta' OR comAutSucursal = 'Melilla') THEN
                DELETE FROM kdekilo4.SUMINISTRO4 WHERE CODCL = NEW_CODCL AND CODVIN = NEW_CODVIN AND CODSU = NEW_CODSU AND (NEW_FECHA IS NULL OR FECHASUMINISTRO = NEW_FECHA);
        END CASE;
        DBMS_OUTPUT.PUT_LINE('Suministro eliminado correctamente');
    END IF;
END BajaSuministro;

BEGIN
    BajaSuministro(1, 1, 2);
END;





-- 10. Dar de alta un pedido de una sucursal.
CREATE OR REPLACE PROCEDURE CrearPedidoSucursal
    (NEW_CODSU1 INT, NEW_CODSU2 INT, NEW_CODVIN INT, NEW_FECHA DATE, NEW_CANTIDAD INT)
IS 
    nPedidos INT;
    NEW_CODPED INT;
BEGIN
    SELECT MAX(CODPED) INTO nPedidos FROM PIDEVINOA;
    NEW_CODPED := nPedidos+1;
    
    INSERT INTO kdekilo1.PIDEVINOA VALUES(NEW_CODPED, NEW_CODSU1, NEW_CODSU2, NEW_CODVIN, NEW_CANTIDAD, NEW_FECHA);
    INSERT INTO PIDEVINOA VALUES(NEW_CODPED, NEW_CODSU1, NEW_CODSU2, NEW_CODVIN, NEW_CANTIDAD, NEW_FECHA);
    INSERT INTO kdekilo3.PIDEVINOA VALUES(NEW_CODPED, NEW_CODSU1, NEW_CODSU2, NEW_CODVIN, NEW_CANTIDAD, NEW_FECHA);
    INSERT INTO kdekilo4.PIDEVINOA VALUES(NEW_CODPED, NEW_CODSU1, NEW_CODSU2, NEW_CODVIN, NEW_CANTIDAD, NEW_FECHA);
    
    DBMS_OUTPUT.PUT_LINE('Pedido creado correctamente');
   
END CrearPedidoSucursal;


SELECT MAX(CODPED) FROM PIDEVINOA;

SELECT * FROM PIDEVINOA;
SELECT * FROM kdekilo2.PIDEVINOA;

BEGIN
    CrearPedidoSucursal(1, 4, 4, TO_DATE('01-ENE-2024', 'DD-MON-YYYY'), 33);
END;






-- 11. Dar de baja un pedido de una sucursal.
CREATE OR REPLACE PROCEDURE BorrarPedidoSucursal
    (NEW_CODSU1 INT, NEW_CODSU2 INT, NEW_CODVIN INT, NEW_FECHA DATE DEFAULT NULL)
IS 
    nPedidos INT;
BEGIN
    SELECT COUNT(*) INTO nPedidos FROM PIDEVINOA WHERE CODSU1 = NEW_CODSU1 AND CODSU2 = NEW_CODSU2 AND CODVIN = NEW_CODVIN AND (NEW_FECHA IS NULL OR FECHAPEDIDO = NEW_FECHA);
    
    IF nPedidos = 0 THEN 
         raise_application_error(-20101, 'ERROR: No existe ningun pedido con esas características');
    ELSE 
        DELETE FROM kdekilo1.PIDEVINOA WHERE CODSU1 = NEW_CODSU1 AND CODSU2 = NEW_CODSU2 AND CODVIN = NEW_CODVIN AND (NEW_FECHA IS NULL OR FECHAPEDIDO = NEW_FECHA);
        DELETE FROM PIDEVINOA WHERE CODSU1 = NEW_CODSU1 AND CODSU2 = NEW_CODSU2 AND CODVIN = NEW_CODVIN AND (NEW_FECHA IS NULL OR FECHAPEDIDO = NEW_FECHA);
        DELETE FROM kdekilo3.PIDEVINOA WHERE CODSU1 = NEW_CODSU1 AND CODSU2 = NEW_CODSU2 AND CODVIN = NEW_CODVIN AND (NEW_FECHA IS NULL OR FECHAPEDIDO = NEW_FECHA);
        DELETE FROM kdekilo4.PIDEVINOA WHERE CODSU1 = NEW_CODSU1 AND CODSU2 = NEW_CODSU2 AND CODVIN = NEW_CODVIN AND (NEW_FECHA IS NULL OR FECHAPEDIDO = NEW_FECHA);
    
        DBMS_OUTPUT.PUT_LINE('Pedido borrado correctamente');
   END IF;
END BorrarPedidoSucursal;

BEGIN
    BorrarPedidoSucursal(1, 4, 4, TO_DATE('01-ENE-2024', 'DD-MON-YYYY'));
END;



-- 12. Dar de alta un nuevo vino.
CREATE OR REPLACE PROCEDURE AltaNuevoVino
    (NEW_CODVIN INT, NEW_MARCA IN VINO2.MARCA%TYPE, NEW_ANIOCOSECHA INT, NEW_DENOMINACION IN VINO2.DENOMINACION_ORIGEN%TYPE, NEW_GRADUACION IN VINO2.GRADUACION%TYPE,
    NEW_VINIEDO IN VINO2.VINIEDOPROCEDENCIA%TYPE, NEW_COMAUTONOMA IN VINO2.COMAUTONOMA%TYPE, NEW_CANTPRODUCIDA INT, NEW_CODPR INT)
IS 
    nVino INT;
BEGIN
    SELECT COUNT(*) INTO nVino FROM VinoView WHERE CODVIN = NEW_CODVIN;
    
    IF nVino > 0 THEN
        raise_application_error(-20101, 'ERROR: Ya existe un vino con ese código');
    ELSE
        CASE
            WHEN (NEW_COMAUTONOMA = 'Castilla-Leon' OR NEW_COMAUTONOMA = 'Castilla-La Mancha' OR NEW_COMAUTONOMA = 'Aragon' OR NEW_COMAUTONOMA = 'Madrid' OR NEW_COMAUTONOMA = 'La Rioja') THEN
                INSERT INTO kdekilo1.VINO1 VALUES(NEW_CODVIN, NEW_MARCA, NEW_ANIOCOSECHA, NEW_DENOMINACION, NEW_GRADUACION, NEW_VINIEDO, NEW_CANTPRODUCIDA, NEW_CANTPRODUCIDA, 
                NEW_COMAUTONOMA, NEW_CODPR);
            WHEN (NEW_COMAUTONOMA = 'Cataluña' OR NEW_COMAUTONOMA = 'Baleares' OR NEW_COMAUTONOMA = 'Pais Valenciano' OR NEW_COMAUTONOMA = 'Murcia') THEN
                INSERT INTO VINO2 VALUES(NEW_CODVIN, NEW_MARCA, NEW_ANIOCOSECHA, NEW_DENOMINACION, NEW_GRADUACION, NEW_VINIEDO, NEW_CANTPRODUCIDA, 
                NEW_CANTPRODUCIDA, NEW_COMAUTONOMA, NEW_CODPR);
            WHEN (NEW_COMAUTONOMA = 'Galicia' OR NEW_COMAUTONOMA = 'Asturias' OR NEW_COMAUTONOMA = 'Cantabria' OR NEW_COMAUTONOMA = 'Pais Vasco' OR NEW_COMAUTONOMA = 'Navarra') THEN
                INSERT INTO kdekilo3.VINO3 VALUES(NEW_CODVIN, NEW_MARCA, NEW_ANIOCOSECHA, NEW_DENOMINACION, NEW_GRADUACION, NEW_VINIEDO, NEW_CANTPRODUCIDA, 
                NEW_CANTPRODUCIDA, NEW_COMAUTONOMA, NEW_CODPR);
            WHEN (NEW_COMAUTONOMA = 'Andalucia' OR NEW_COMAUTONOMA = 'Extremadura' OR NEW_COMAUTONOMA = 'Canarias' OR NEW_COMAUTONOMA = 'Ceuta' OR NEW_COMAUTONOMA = 'Melilla') THEN
                INSERT INTO kdekilo4.VINO4 VALUES(NEW_CODVIN, NEW_MARCA, NEW_ANIOCOSECHA, NEW_DENOMINACION, NEW_GRADUACION, NEW_VINIEDO, NEW_CANTPRODUCIDA, 
                NEW_CANTPRODUCIDA, NEW_COMAUTONOMA, NEW_CODPR);
        END CASE;
        DBMS_OUTPUT.PUT_LINE('Vino introducido correctamente');
    END IF;
END AltaNuevoVino;


BEGIN
    AltaNuevoVino(123, 'Rene Barbier', 2015, 'Penedes', 9, 'Virgen de Estrella', 'Cataluña', 200, NULL);
END;



DELETE FROM kdekilo2.VINO2 WHERE CODVIN=123;
SELECT * FROM VinoView;


-- 13. Dar de baja un vino.
CREATE OR REPLACE PROCEDURE BajaNuevoVino
    (NEW_CODVIN INT)
IS 
    nVino INT;
    comAutonomaVino VINO2.COMAUTONOMA%TYPE;
BEGIN
    SELECT COUNT(*) INTO nVino FROM VinoView WHERE CODVIN = NEW_CODVIN;
    SELECT COMAUTONOMA INTO comAutonomaVino FROM VinoView WHERE CODVIN = NEW_CODVIN;
    
    IF nVino = 0 THEN
        raise_application_error(-20101, 'ERROR: No existe ningun vino con ese código');
    ELSE
        CASE
            WHEN (comAutonomaVino = 'Castilla-Leon' OR comAutonomaVino = 'Castilla-La Mancha' OR comAutonomaVino = 'Aragon' OR comAutonomaVino = 'Madrid' OR comAutonomaVino = 'La Rioja') THEN
                DELETE FROM kdekilo1.VINO1 WHERE CODVIN = NEW_CODVIN;
            WHEN (comAutonomaVino = 'Cataluña' OR comAutonomaVino = 'Baleares' OR comAutonomaVino = 'Pais Valenciano' OR comAutonomaVino = 'Murcia') THEN
                DELETE FROM VINO2 WHERE CODVIN = NEW_CODVIN;
            WHEN (comAutonomaVino = 'Galicia' OR comAutonomaVino = 'Asturias' OR comAutonomaVino = 'Cantabria' OR comAutonomaVino = 'Pais Vasco' OR comAutonomaVino = 'Navarra') THEN
                DELETE FROM kdekilo3.VINO3 WHERE CODVIN = NEW_CODVIN;
            WHEN (comAutonomaVino = 'Andalucia' OR comAutonomaVino = 'Extremadura' OR comAutonomaVino = 'Canarias' OR comAutonomaVino = 'Ceuta' OR comAutonomaVino = 'Melilla') THEN
                DELETE FROM kdekilo4.VINO4 WHERE CODVIN = NEW_CODVIN;
        END CASE;
        DBMS_OUTPUT.PUT_LINE('Vino borrado correctamente');
    END IF;
END BajaNuevoVino;


BEGIN
    BajaNuevoVino(123);
END;

SELECT * FROM PRODUCTOR2;

-- 14. Dar de alta un productor.
CREATE OR REPLACE PROCEDURE AltaNuevoProductor
    (NEW_CODPR INT, NEW_DNI IN PRODUCTOR2.DNI%TYPE, NEW_NOMBRE IN PRODUCTOR2.NOMBRE%TYPE, NEW_DIRECCION IN PRODUCTOR2.DIRECCION%TYPE)
IS 
    nProductor INT;
BEGIN
    SELECT COUNT(*) INTO nProductor FROM PRODUCTOR2 WHERE CODPR = NEW_CODPR;
    
    IF nProductor > 0 THEN
        raise_application_error(-20101, 'ERROR: Ya existe un productor con ese código');
    ELSE
        -- Como no tiene ningun vino asociado, no sabemos en que localidad guardar el productor, por lo que lo guardaremos en la misma
        -- desde la que se le da de alta
        INSERT INTO PRODUCTOR2 VALUES(NEW_CODPR, NEW_DNI, NEW_NOMBRE, NEW_DIRECCION);
        DBMS_OUTPUT.PUT_LINE('Productor introducido correctamente');
    END IF;
END AltaNuevoProductor;

BEGIN
    AltaNuevoProductor(123, '32545478C','productor', 'direccion falsa');
END;




-- 15. Dar de baja un productor
-- Como un productor puede estar en más de una localidad, lo eliminamos de todas en las que se encuentre
CREATE OR REPLACE PROCEDURE BajaNuevoProductor
    (NEW_CODPR INT)
IS 
    localidad1 INT;
    localidad2 INT;
    localidad3 INT;
    localidad4 INT;
BEGIN
    SELECT COUNT(*) INTO localidad1 FROM kdekilo1.PRODUCTOR1 WHERE CODPR = NEW_CODPR;
    SELECT COUNT(*) INTO localidad2 FROM PRODUCTOR2 WHERE CODPR = NEW_CODPR;
    SELECT COUNT(*) INTO localidad3 FROM kdekilo3.PRODUCTOR3 WHERE CODPR = NEW_CODPR;
    SELECT COUNT(*) INTO localidad4 FROM kdekilo4.PRODUCTOR4 WHERE CODPR = NEW_CODPR;
    
    IF localidad1 > 0 THEN
        DELETE FROM kdekilo1.PRODUCTOR1 WHERE CODPR = NEW_CODPR;
    ELSIF localidad2 > 0 THEN
        DELETE FROM PRODUCTOR2 WHERE CODPR = NEW_CODPR;
    ELSIF localidad3 > 0 THEN
        DELETE FROM kdekilo3.PRODUCTOR3 WHERE CODPR = NEW_CODPR;
    ELSIF localidad4 > 0 THEN
        DELETE FROM kdekilo4.PRODUCTOR4 WHERE CODPR = NEW_CODPR;
    ELSE
        raise_application_error(-20101, 'ERROR: No existe nigun productor con ese código');
    END IF;
    DBMS_OUTPUT.PUT_LINE('Productor borrado correctamente');
END BajaNuevoProductor;

BEGIN
    BajaNuevoProductor(123);
END;




-- CONSULTAS:

-- 1. “Listar los clientes (nombre y dirección) de Andalucía o Castilla-La Mancha y las
-- sucursales (nombre y ciudad), a los que se le ha suministrado vino de marca “Tablas
-- de Daimiel” entre el 1 de Enero de 2023 y el 1 de septiembre de 2023.
SET SERVEROUTPUT ON;
SELECT 
    DISTINCT c.NOMBRE AS "Nombre Cliente",
    c.DIRECCION AS "Dirección Cliente",
    s.NOMBRE AS "Nombre Sucursal",
    s.CIUDAD AS "Ciudad Sucursal"
FROM 
    ClienteView c
JOIN 
    SuministroView sm ON c.CODCL = sm.CODCL
JOIN 
    SucursalView s ON sm.CODSU = s.CODSU
JOIN 
    VinoView v ON sm.CODVIN = v.CODVIN
WHERE 
    (c.COMAUTONOMA = 'Andalucia' OR c.COMAUTONOMA = 'Castilla-La Mancha')
    AND v.MARCA = 'Tablas de Daimiel'
    AND sm.FECHASUMINISTRO BETWEEN TO_DATE('2023-01-01', 'YYYY-MM-DD') AND TO_DATE('2023-09-01', 'YYYY-MM-DD');


-- 2. Dado por teclado el código de un productor: “Listar la marca, el año de cosecha de
-- cada uno de los vinos producidos por él y la cantidad total suministrada de cada uno
-- de ellos a clientes de las comunidades autónomas de Baleares, Extremadura o País
-- Valenciano.
SET SERVEROUTPUT ON;
DECLARE
    codigo_productor_input INT;
BEGIN
    -- Solicitar el código de un productor por teclado
    DBMS_OUTPUT.PUT_LINE('Introduce el código de un productor: ');
    codigo_productor_input := &codigo_productor_input;

    -- Consulta SQL para listar la marca, el año de cosecha y la cantidad total suministrada
    FOR vino_info IN (
        SELECT 
            v.MARCA AS Marca,
            v.ANIOCOSECHA AS AnioCosecha,
            SUM(s.CANTIDAD) AS CantidadTotalSuministrada
        FROM 
            VinoView v
        JOIN 
            SuministroView s ON v.CODVIN = s.CODVIN
        JOIN 
            ClienteView c ON s.CODCL = c.CODCL
        WHERE 
            v.CODPR = codigo_productor_input AND
            (c.COMAUTONOMA IN ('Baleares', 'Extremadura', 'País Valenciano') OR c.COMAUTONOMA IS NULL)
        GROUP BY 
            v.MARCA, v.ANIOCOSECHA
    ) LOOP
    DBMS_OUTPUT.PUT_LINE('Marca: ' || vino_info.Marca || ', Año de Cosecha: ' || vino_info.AnioCosecha || ', Cantidad Total Suministrada: ' || vino_info.CantidadTotalSuministrada);
    END LOOP;
END;






-- 3. Dado por teclado el código de una sucursal: “Listar el nombre de cada uno de sus
-- clientes, su tipo y la cantidad total vino de Rioja o Albariño que se le ha suministrado
-- a cada uno de ellos (solamente deberán aparecer aquellos clientes a los que se les ha
-- suministrado vinos con esta denominación de origen).
SET SERVEROUTPUT ON;
DECLARE
    codigo_sucursal_input INT;
BEGIN
    -- Solicitar el código de una sucursal por teclado
    DBMS_OUTPUT.PUT_LINE('Introduce el código de una sucursal: ');
    codigo_sucursal_input := &codigo_sucursal_input;

    -- Consulta SQL para listar clientes, su tipo y la cantidad total de vino suministrado
    FOR cliente_info IN (
        SELECT 
            c.NOMBRE AS "Nombre del Cliente",
            c.TIPO AS "Tipo de Cliente",
            SUM(s.CANTIDAD) AS "Cantidad Total Suministrada"
        FROM 
            ClienteView c
        JOIN 
            SuministroView s ON c.CODCL = s.CODCL
        JOIN 
            VinoView v ON s.CODVIN = v.CODVIN
        WHERE 
            s.CODSU = codigo_sucursal_input
            AND (v.DENOMINACION_ORIGEN = 'Rioja' OR v.DENOMINACION_ORIGEN = 'Albariño')
        GROUP BY 
            c.NOMBRE, c.TIPO
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Nombre del Cliente: ' || cliente_info."Nombre del Cliente" || ', Tipo de Cliente: ' || cliente_info."Tipo de Cliente" || ', Cantidad Total Suministrada: ' || cliente_info."Cantidad Total Suministrada");
    END LOOP;
END;

