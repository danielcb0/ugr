-- 1. Eliminación de objetos existentes
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE SUMINISTRO1 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE RESERVA1 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE ASIGNACION1 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE HOTEL1 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE EMPLEADO1 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE CLIENTE1 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE PROVEEDOR1 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE ARTICULO1 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE HISTORICO_EMPLEADO1 CASCADE CONSTRAINTS';

    EXECUTE IMMEDIATE 'DROP SEQUENCE EMPLEADO1_SEQ';
    EXECUTE IMMEDIATE 'DROP SEQUENCE HOTEL1_SEQ';
    EXECUTE IMMEDIATE 'DROP SEQUENCE PROVEEDOR1_SEQ';
    EXECUTE IMMEDIATE 'DROP SEQUENCE ARTICULO1_SEQ';
    EXECUTE IMMEDIATE 'DROP SEQUENCE RESERVA1_SEQ';
    EXECUTE IMMEDIATE 'DROP SEQUENCE ASIGNACION1_SEQ';
    EXECUTE IMMEDIATE 'DROP SEQUENCE SUMINISTRO1_SEQ';
    EXECUTE IMMEDIATE 'DROP SEQUENCE HISTORICO_EMPLEADO1_SEQ';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/


-- Creación de la tabla EMPLEADO para localidad1
CREATE TABLE EMPLEADO1 (
    empleado_id NUMBER PRIMARY KEY,
    dni VARCHAR2(9) UNIQUE NOT NULL,
    nombre VARCHAR2(100) NOT NULL,
    telefono VARCHAR2(15),
    direccion VARCHAR2(200),
    fecha_inicio DATE NOT NULL,
    fecha_contrato DATE NOT NULL,
    salario NUMBER CHECK (salario > 0),
    hotel_id NUMBER NOT NULL,
    CONSTRAINT fk_empleado_EMPLEADO1 FOREIGN KEY (hotel_id) REFERENCES HOTEL1(hotel_id)
);

-- Creación de la tabla PROVEEDOR para localidad1
CREATE TABLE PROVEEDOR1 (
    proveedor_id NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    ciudad VARCHAR2(100)  
);

-- Creación de la tabla ARTICULO para localidad1
CREATE TABLE ARTICULO1 (
    articulo_id NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    tipo CHAR(1) CHECK (tipo IN ('A', 'B', 'C', 'D')),
    proveedor_id NUMBER NOT NULL,
    codigo NUMBER NOT NULL,
    CONSTRAINT fk_articulo_PROVEEDOR1 FOREIGN KEY (proveedor_id) REFERENCES PROVEEDOR1(proveedor_id)
);

-- Creación de la tabla HOTEL para localidad1
CREATE TABLE HOTEL1 (
    hotel_id NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    capacidad_sencillas NUMBER NOT NULL,
    capacidad_dobles NUMBER NOT NULL,
    ciudad VARCHAR2(100) NOT NULL,
    provincia VARCHAR2(100) NOT NULL,
    director_id NUMBER,
    CONSTRAINT fk_hotel_director2 FOREIGN KEY (director_id) REFERENCES EMPLEADO1(empleado_id)
);

-- Creación de la tabla CLIENTE para localidad1
CREATE TABLE CLIENTE1 (
    cliente_id NUMBER PRIMARY KEY,
    dni VARCHAR2(9) UNIQUE NOT NULL,
    nombre VARCHAR2(100) NOT NULL,
    telefono VARCHAR2(15)
);

-- Creación de la tabla RESERVA para localidad1
CREATE TABLE RESERVA1 (
    reserva_id NUMBER PRIMARY KEY,
    cliente_id NUMBER NOT NULL,
    hotel_id NUMBER NOT NULL,
    fecha_entrada DATE NOT NULL,
    fecha_salida DATE NOT NULL,
    tipo_habitacion VARCHAR2(10) CHECK (tipo_habitacion IN ('sencilla', 'doble')),
    precio_noche NUMBER NOT NULL,
    CONSTRAINT fk_CLIENTE1 FOREIGN KEY (cliente_id) REFERENCES CLIENTE1(cliente_id),
    CONSTRAINT fk_HOTEL1 FOREIGN KEY (hotel_id) REFERENCES HOTEL1(hotel_id)
);

-- Creación de la tabla ASIGNACION para localidad1
CREATE TABLE ASIGNACION1 (
    asignacion_id NUMBER PRIMARY KEY,
    empleado_id NUMBER NOT NULL,
    hotel_id NUMBER NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    CONSTRAINT fk_asignacion_EMPLEADO1 FOREIGN KEY (empleado_id) REFERENCES EMPLEADO1(empleado_id),
    CONSTRAINT fk_asignacion_HOTEL1 FOREIGN KEY (hotel_id) REFERENCES HOTEL1(hotel_id)
);

-- Creación de la tabla SUMINISTRO para localidad1
CREATE TABLE SUMINISTRO1 (
    suministro_id NUMBER PRIMARY KEY,
    proveedor_id NUMBER NOT NULL,
    hotel_id NUMBER NOT NULL,
    articulo_id NUMBER NOT NULL,
    fecha_suministro DATE NOT NULL,
    cantidad NUMBER NOT NULL CHECK (cantidad > 0),
    precio_unitario NUMBER NOT NULL CHECK (precio_unitario > 0),
    CONSTRAINT fk_suministro_HOTEL1 FOREIGN KEY (hotel_id) REFERENCES HOTEL1(hotel_id),
    CONSTRAINT fk_suministro_PROVEEDOR1 FOREIGN KEY (proveedor_id) REFERENCES PROVEEDOR1(proveedor_id),
    CONSTRAINT fk_suministro_ARTICULO1 FOREIGN KEY (articulo_id) REFERENCES ARTICULO1(articulo_id)
);

CREATE TABLE HISTORICO_EMPLEADO1 (
    historico_id NUMBER PRIMARY KEY,
    empleado_id NUMBER NOT NULL,
    hotel_id NUMBER NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    CONSTRAINT fk_historico_empleado FOREIGN KEY (empleado_id) REFERENCES EMPLEADO1(empleado_id),
    CONSTRAINT fk_historico_hotel FOREIGN KEY (hotel_id) REFERENCES HOTEL1(hotel_id)
);
/



-- Creación de secuencias para las tablas de Localidad 1
CREATE SEQUENCE EMPLEADO1_SEQ START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE HOTEL1_SEQ START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE PROVEEDOR1_SEQ START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE ARTICULO1_SEQ START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE RESERVA1_SEQ START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE ASIGNACION1_SEQ START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SUMINISTRO1_SEQ START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE HISTORICO_EMPLEADO1_SEQ START WITH 1 INCREMENT BY 1 NOCACHE;
/

GRANT SELECT, INSERT, UPDATE, DELETE ON HISTORICO_EMPLEADO1 TO betis1;


-- Insertar datos en la tabla EMPLEADO1
INSERT INTO EMPLEADO1 (empleado_id, dni, nombre, telefono, direccion, fecha_inicio, fecha_contrato, salario, hotel_id) 
VALUES (5, '55555555', 'Susana', '555555', 'Mayor 5, Jaén', TO_DATE('2013-06-14', 'YYYY-MM-DD'),TO_DATE('2003-10-01', 'YYYY-MM-DD'), 1800, 5);
INSERT INTO EMPLEADO1 (empleado_id, dni, nombre, telefono, direccion, fecha_inicio,fecha_contrato, salario, hotel_id) 
VALUES (6, '66666666', 'Gonzalo', '666666', 'Ronda 31, Granada', TO_DATE('2009-03-17', 'YYYY-MM-DD'),TO_DATE('1992-01-01', 'YYYY-MM-DD'), 1800, 6);
INSERT INTO EMPLEADO1 (empleado_id, dni, nombre, telefono, direccion, fecha_inicio,fecha_contrato, salario, hotel_id) 
VALUES (13, '13131313', 'Patricia', '666666', 'Ronda 31, Granada', TO_DATE('2009-03-17', 'YYYY-MM-DD'),TO_DATE('1992-01-01', 'YYYY-MM-DD'), 1800, 5);
INSERT INTO EMPLEADO1 (empleado_id, dni, nombre, telefono, direccion, fecha_inicio,fecha_contrato, salario, hotel_id) 
VALUES (14, '14141414', 'Inés', '141414', 'Constitución 4, Granada', TO_DATE('2003-03-07', 'YYYY-MM-DD'),TO_DATE('2003-03-07', 'YYYY-MM-DD'), 1500, 6);
INSERT INTO EMPLEADO1 (empleado_id, dni, nombre, telefono, direccion, fecha_inicio,fecha_contrato, salario, hotel_id) 
VALUES (19, '19191919', 'Gabriel', '141414', 'Colón 11, Granada', TO_DATE('2000-09-19', 'YYYY-MM-DD'),TO_DATE('2000-09-19', 'YYYY-MM-DD'), 1500, 9);


-- Insertar datos en la tabla PROVEEDOR1
INSERT INTO PROVEEDOR1 (proveedor_id, nombre, ciudad) VALUES (3, 'Pescaveja', 'Granada');
INSERT INTO PROVEEDOR1 (proveedor_id, nombre, ciudad) VALUES (4, 'Molinez', 'Granada');

-- Insertar datos en la tabla ARTICULO1
INSERT INTO ARTICULO1 (articulo_id, nombre, tipo, proveedor_id, proveedor, codigo) 
VALUES (1, 'Pollo', 'A', 2, 3);
INSERT INTO ARTICULO1 (articulo_id, nombre, tipo, proveedor_id, proveedor, codigo) 
VALUES (2, 'Pavo', 'A', 2, 3);
INSERT INTO ARTICULO1 (articulo_id, nombre, tipo, proveedor_id, proveedor, codigo) 
VALUES (3, 'Ternera', 'A', 2, 3);
INSERT INTO ARTICULO1 (articulo_id, nombre, tipo, proveedor_id, proveedor, codigo) 
VALUES (4, 'Cordero', 'A', 2, 3);
INSERT INTO ARTICULO1 (articulo_id, nombre, tipo, proveedor_id, proveedor, codigo) 
VALUES (5, 'Cerdo', 'A', 2, 3);
INSERT INTO ARTICULO1 (articulo_id, nombre, tipo, proveedor_id, proveedor, codigo) 
VALUES (6, 'Verdura', 'B', 1, 4);
INSERT INTO ARTICULO1 (articulo_id, nombre, tipo, proveedor_id, proveedor, codigo) 
VALUES (7, 'Fruta', 'B', 1, 4);
INSERT INTO ARTICULO1 (articulo_id, nombre, tipo, proveedor_id, proveedor, codigo) 
VALUES (8, 'Legumbre', 'B', 1, 4);
INSERT INTO ARTICULO1 (articulo_id, nombre, tipo, proveedor_id, proveedor, codigo) 
VALUES (9, 'Leche', 'C', 1, 4);
INSERT INTO ARTICULO1 (articulo_id, nombre, tipo, proveedor_id, proveedor, codigo) 
VALUES (10, 'Queso', 'C', 1, 4);
INSERT INTO ARTICULO1 (articulo_id, nombre, tipo, proveedor_id, proveedor, codigo) 
VALUES (11, 'Mantequilla', 'C', 1, 4);
INSERT INTO ARTICULO1 (articulo_id, nombre, tipo, proveedor_id, proveedor, codigo) 
VALUES (12, 'Bacalao', 'D', 2, 3);
INSERT INTO ARTICULO1 (articulo_id, nombre, tipo, proveedor_id, proveedor, codigo) 
VALUES (13, 'Pulpo', 'D', 2, 3);
INSERT INTO ARTICULO1 (articulo_id, nombre, tipo, proveedor_id, proveedor, codigo) 
VALUES (14, 'Pescadilla', 'D', 2, 3);
INSERT INTO ARTICULO1 (articulo_id, nombre, tipo, proveedor_id, proveedor, codigo) 
VALUES (15, 'Calamar', 'D', 2, 3);

-- Insertar datos en la tabla HOTEL1
INSERT INTO HOTEL1 (hotel_id, nombre, capacidad_sencillas, capacidad_dobles, ciudad, provincia, director_id) 
VALUES (5, 'Santo Reino', 15, 5, 'Jaén', 'Jaén', 5);
INSERT INTO HOTEL1 (hotel_id, nombre, capacidad_sencillas, capacidad_dobles, ciudad, provincia, director_id) 
VALUES (6, 'Alhambra', 6, 0, 'Granada', 'Granada', 6);
INSERT INTO HOTEL1 (hotel_id, nombre, capacidad_sencillas, capacidad_dobles, ciudad, provincia, director_id) 
VALUES (9, 'Santa Paula', 30, 10, 'Granada', 'Granada', 9);

-- Insertar datos en la tabla CLIENTE1
INSERT INTO CLIENTE1 (cliente_id, dni, nombre, telefono) 
VALUES (1, '12345678', 'José', '123456');
INSERT INTO CLIENTE1 (cliente_id, dni, nombre, telefono) 
VALUES (2, '89012345', 'Francisco', '890123');

INSERT INTO CLIENTE1 (cliente_id, dni, nombre, telefono) 
VALUES (3, '56789012', 'María', '567890');

INSERT INTO CLIENTE1 (cliente_id, dni, nombre, telefono) 
VALUES (4, '34567890', 'Cristina', '345678');

INSERT INTO CLIENTE1 (cliente_id, dni, nombre, telefono) 
VALUES (5, '01234567', 'Carmen', '012345');

INSERT INTO CLIENTE1 (cliente_id, dni, nombre, telefono) 
VALUES (6, '78901234', 'Juan', '789012');

-- Insertar datos en la tabla RESERVA1
INSERT INTO RESERVA1 (reserva_id, cliente_id, hotel_id, fecha_entrada, fecha_salida, tipo_habitacion, precio_noche) 
VALUES (1, 1, 6, TO_DATE('2024-07-20', 'YYYY-MM-DD'), TO_DATE('2024-07-31', 'YYYY-MM-DD'), 'doble', 150);
INSERT INTO RESERVA1 (reserva_id, cliente_id, hotel_id, fecha_entrada, fecha_salida, tipo_habitacion, precio_noche) 
VALUES (2, 1, 6, TO_DATE('2024-11-05', 'YYYY-MM-DD'), TO_DATE('2024-11-12', 'YYYY-MM-DD'), 'doble', 100);

INSERT INTO RESERVA1 (reserva_id, cliente_id, hotel_id, fecha_entrada, fecha_salida, tipo_habitacion, precio_noche) 
VALUES (4, 2, 6, TO_DATE('2024-07-20', 'YYYY-MM-DD'), TO_DATE('2024-07-31', 'YYYY-MM-DD'), 'doble', 150);

INSERT INTO RESERVA1 (reserva_id, cliente_id, hotel_id, fecha_entrada, fecha_salida, tipo_habitacion, precio_noche) 
VALUES (5, 3, 6, TO_DATE('2024-07-20', 'YYYY-MM-DD'), TO_DATE('2024-07-31', 'YYYY-MM-DD'), 'doble', 150);
INSERT INTO RESERVA1 (reserva_id, cliente_id, hotel_id, fecha_entrada, fecha_salida, tipo_habitacion, precio_noche) 
VALUES (6, 3, 9, TO_DATE('2024-06-01', 'YYYY-MM-DD'), TO_DATE('2024-06-09', 'YYYY-MM-DD'), 'sencilla', 100);

INSERT INTO RESERVA1 (reserva_id, cliente_id, hotel_id, fecha_entrada, fecha_salida, tipo_habitacion, precio_noche) 
VALUES (7, 4, 6, TO_DATE('2024-07-20', 'YYYY-MM-DD'), TO_DATE('2024-07-31', 'YYYY-MM-DD'), 'doble', 150);
INSERT INTO RESERVA1 (reserva_id, cliente_id, hotel_id, fecha_entrada, fecha_salida, tipo_habitacion, precio_noche) 
VALUES (8, 4, 6, TO_DATE('2024-11-30', 'YYYY-MM-DD'), TO_DATE('2024-12-05', 'YYYY-MM-DD'), 'doble', 100);

INSERT INTO RESERVA1 (reserva_id, cliente_id, hotel_id, fecha_entrada, fecha_salida, tipo_habitacion, precio_noche) 
VALUES (8, 5, 6, TO_DATE('2024-07-20', 'YYYY-MM-DD'), TO_DATE('2024-07-31', 'YYYY-MM-DD'), 'doble', 150);
INSERT INTO RESERVA1 (reserva_id, cliente_id, hotel_id, fecha_entrada, fecha_salida, tipo_habitacion, precio_noche) 
VALUES (9, 6, 6, TO_DATE('2024-07-20', 'YYYY-MM-DD'), TO_DATE('2024-07-31', 'YYYY-MM-DD'), 'doble', 150);

-- Insertar datos en la tabla ASIGNACION1
INSERT INTO ASIGNACION1 (asignacion_id, empleado_id, hotel_id, fecha_inicio, fecha_fin) 
VALUES (1, 1, 1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), NULL);
INSERT INTO ASIGNACION1 (asignacion_id, empleado_id, hotel_id, fecha_inicio, fecha_fin) 
VALUES (2, 2, 2, TO_DATE('2021-06-15', 'YYYY-MM-DD'), NULL);

-- Insertar datos en la tabla SUMINISTRO1
INSERT INTO SUMINISTRO1 (suministro_id, proveedor_id, hotel_id, articulo_id, fecha_suministro, cantidad, precio_unitario) 
VALUES (1, 3, 5, 14, TO_DATE('2024-05-17', 'YYYY-MM-DD'), 150, 20);
INSERT INTO SUMINISTRO1 (suministro_id, proveedor_id, hotel_id, articulo_id, fecha_suministro, cantidad, precio_unitario) 
VALUES (2, 3, 5, 14, TO_DATE('2024-06-15', 'YYYY-MM-DD'), 100, 25);
INSERT INTO SUMINISTRO1 (suministro_id, proveedor_id, hotel_id, articulo_id, fecha_suministro, cantidad, precio_unitario) 
VALUES (3, 3, 6, 4, TO_DATE('2024-05-16', 'YYYY-MM-DD'), 200, 15);
INSERT INTO SUMINISTRO1 (suministro_id, proveedor_id, hotel_id, articulo_id, fecha_suministro, cantidad, precio_unitario) 
VALUES (4, 4, 5, 10, TO_DATE('2024-05-13', 'YYYY-MM-DD'), 200, 20);



-- Insertar historico de empleados
INSERT INTO HISTORICO_EMPLEADO1 (historico_id, empleado_id ,hotel_id ,fecha_inicio ,fecha_fin)
VALUES (1,1,5,TO_DATE('2003-09-22', 'YYYY-MM-DD'),TO_DATE('2012-10-14', 'YYYY-MM-DD'));

INSERT INTO HISTORICO_EMPLEADO1 (historico_id,empleado_id ,hotel_id ,fecha_inicio ,fecha_fin)
VALUES (2,3,6,TO_DATE('1997-01-30', 'YYYY-MM-DD'),TO_DATE('2008-12-20', 'YYYY-MM-DD'));

INSERT INTO HISTORICO_EMPLEADO1 (historico_id,empleado_id ,hotel_id ,fecha_inicio ,fecha_fin)
VALUES (3,6,9,TO_DATE('2005-12-08', 'YYYY-MM-DD'),TO_DATE('2009-03-16', 'YYYY-MM-DD'));



-- Disparador para evitar SYSDATE en restricción CHECK
CREATE OR REPLACE TRIGGER trg_fecha_inicio_valid4
BEFORE INSERT OR UPDATE ON EMPLEADO1
FOR EACH ROW
BEGIN
    IF :NEW.fecha_inicio > SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20007, 'La fecha de inicio no puede ser futura.');
    END IF;
END;
/

-- Disparador para asegurar que el número de reservas no excede la capacidad del hotel
CREATE OR REPLACE TRIGGER trg_check_capacidad4
BEFORE INSERT OR UPDATE ON RESERVA1
FOR EACH ROW
DECLARE
    total_sencillas NUMBER;
    total_dobles NUMBER;
    capacidad_sencillas NUMBER;
    capacidad_dobles NUMBER;
BEGIN
    SELECT capacidad_sencillas, capacidad_dobles
    INTO capacidad_sencillas, capacidad_dobles
    FROM HOTEL1 WHERE hotel_id = :NEW.hotel_id;

    SELECT COUNT(*) INTO total_sencillas
    FROM RESERVA1
    WHERE hotel_id = :NEW.hotel_id AND tipo_habitacion = 'sencilla';

    SELECT COUNT(*) INTO total_dobles
    FROM RESERVA1
    WHERE hotel_id = :NEW.hotel_id AND tipo_habitacion = 'doble';

    IF :NEW.tipo_habitacion = 'sencilla' AND total_sencillas + 1 > capacidad_sencillas THEN
        RAISE_APPLICATION_ERROR(-20001, 'No se pueden exceder las habitaciones sencillas disponibles.');
    ELSIF :NEW.tipo_habitacion = 'doble' AND total_dobles + 1 > capacidad_dobles THEN
        RAISE_APPLICATION_ERROR(-20002, 'No se pueden exceder las habitaciones dobles disponibles.');
    END IF;
END;
/

-- Disparador para evitar disminución del salario
CREATE OR REPLACE TRIGGER trg_check_salario4
BEFORE UPDATE ON EMPLEADO1
FOR EACH ROW
BEGIN
    IF :NEW.salario < :OLD.salario THEN
        RAISE_APPLICATION_ERROR(-20004, 'El salario de un empleado no puede disminuir.');
    END IF;
END;
/

-- Disparador para validar la relación entre PROVEEDOR1 y ciudad de suministros
CREATE OR REPLACE TRIGGER trg_check_proveedor_ciudad4
BEFORE INSERT OR UPDATE ON SUMINISTRO1
FOR EACH ROW
DECLARE
    proveedor_ciudad VARCHAR2(100);
    provincia_hotel VARCHAR2(100);
BEGIN
    SELECT ciudad INTO proveedor_ciudad FROM PROVEEDOR1 WHERE proveedor_id = :NEW.proveedor_id;
    SELECT provincia INTO provincia_hotel FROM HOTEL1 WHERE hotel_id = :NEW.hotel_id;

    IF proveedor_ciudad = 'Sevilla' AND provincia_hotel NOT IN ('Sevilla', 'Córdoba') THEN
        RAISE_APPLICATION_ERROR(-20005, 'Los proveedores de Sevilla solo pueden suministrar a ciertos hoteles.');
    ELSIF proveedor_ciudad = 'Córdoba' AND provincia_hotel NOT IN ('Sevilla', 'Córdoba') THEN
        RAISE_APPLICATION_ERROR(-20006, 'Los proveedores de Córdoba solo pueden suministrar a ciertos hoteles.');
    END IF;
END;
/



-- Procedimientos

-- 1. Dar de alta un nuevo empleado
CREATE OR REPLACE PROCEDURE AltaNuevoEmpleado(
    NEW_EMPLEADO_ID INT, 
    NEW_DNI VARCHAR2,
    NEW_NOMBRE VARCHAR2,
    NEW_DIRECCION VARCHAR2,
    NEW_TELEFONO VARCHAR2,
    NEW_FECHA_CONTRATO DATE,
    NEW_SALARIO INT,
    NEW_HOTEL_ID INT,
    NEW_FECHA_INICIO DATE
)
IS
    empleadoExistente INT;
    hotelExistente INT;
BEGIN
    -- Validar existencia del hotel
    SELECT COUNT(*) INTO hotelExistente FROM HOTEL1 WHERE hotel_id = NEW_HOTEL_ID;
    IF hotelExistente = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El hotel no existe.');
    END IF;

    -- Validar existencia del empleado
    SELECT COUNT(*) INTO empleadoExistente FROM EMPLEADO1 WHERE empleado_id = NEW_EMPLEADO_ID;
    IF empleadoExistente > 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'El empleado ya existe.');
    END IF;

    -- Insertar nuevo empleado
    INSERT INTO EMPLEADO1 (empleado_id, dni, nombre, direccion, telefono, fecha_inicio, salario)
    VALUES (EMPLEADO1_SEQ.NEXTVAL, NEW_DNI, NEW_NOMBRE, NEW_DIRECCION, NEW_TELEFONO, NEW_FECHA_CONTRATO, NEW_SALARIO);

    DBMS_OUTPUT.PUT_LINE('Empleado creado con éxito.');
END;
/



-- 2. Dar de baja un empleado

CREATE OR REPLACE PROCEDURE BajaEMPLEADO1(
    EMPLEADO_ID INT,
    FECHA_BAJA DATE
)
IS
    empleadoExistente INT;
BEGIN
    -- Verificar si el empleado existe
    SELECT COUNT(*) INTO empleadoExistente
    FROM EMPLEADO1
    WHERE empleado_id = EMPLEADO_ID;

    IF empleadoExistente = 0 THEN
        RAISE_APPLICATION_ERROR(-20201, 'ERROR: El empleado con el código proporcionado no existe.');
    END IF;

    -- Eliminar asignaciones y registros del empleado
    DELETE FROM ASIGNACION1 WHERE empleado_id = EMPLEADO_ID;
    DELETE FROM EMPLEADO1 WHERE empleado_id = EMPLEADO_ID;

    DBMS_OUTPUT.PUT_LINE('Empleado dado de baja correctamente en Localidad 1.');
END;
/


-- 3. Modificar el salario de un empleado
CREATE OR REPLACE PROCEDURE ModificarSalarioEmpleado(
    EMPLEADO_ID INT,
    NUEVO_SALARIO NUMBER
)
IS
    empleadoExistente INT;
BEGIN
    -- Verificar si el empleado existe
    SELECT COUNT(*) INTO empleadoExistente
    FROM EMPLEADO1
    WHERE empleado_id = EMPLEADO_ID;

    IF empleadoExistente = 0 THEN
        RAISE_APPLICATION_ERROR(-20301, 'ERROR: El empleado con el código proporcionado no existe.');
    END IF;

    -- Validar que el nuevo salario sea positivo
    IF NUEVO_SALARIO <= 0 THEN
        RAISE_APPLICATION_ERROR(-20302, 'ERROR: El salario debe ser mayor que 0.');
    END IF;

    -- Modificar el salario del empleado
    UPDATE EMPLEADO1
    SET salario = NUEVO_SALARIO
    WHERE empleado_id = EMPLEADO_ID;

    DBMS_OUTPUT.PUT_LINE('Salario del empleado actualizado correctamente en Localidad 1.');
END;
/


-- 4. Trasladar de hotel a un empleado

CREATE OR REPLACE PROCEDURE TrasladarEMPLEADO1(
    EMPLEADO_ID INT,
    FECHA_FIN_ACTUAL DATE,
    NUEVO_HOTEL_ID INT,
    FECHA_INICIO_NUEVO DATE,
    NUEVA_DIRECCION VARCHAR2 DEFAULT NULL,
    NUEVO_TELEFONO VARCHAR2 DEFAULT NULL
)
IS
    empleadoExistente INT;
    hotelExistente INT;
BEGIN
    -- Verificar si el empleado existe
    SELECT COUNT(*) INTO empleadoExistente
    FROM EMPLEADO1
    WHERE empleado_id = EMPLEADO_ID;

    IF empleadoExistente = 0 THEN
        RAISE_APPLICATION_ERROR(-20401, 'ERROR: El empleado con el código proporcionado no existe.');
    END IF;

    -- Verificar si el nuevo hotel existe
    SELECT COUNT(*) INTO hotelExistente
    FROM HOTEL1
    WHERE hotel_id = NUEVO_HOTEL_ID;

    IF hotelExistente = 0 THEN
        RAISE_APPLICATION_ERROR(-20402, 'ERROR: El hotel con el código proporcionado no existe.');
    END IF;

    -- Crear el registro histórico del empleado
    INSERT INTO HISTORICO_EMPLEADO1 (historico_id, empleado_id, hotel_id, fecha_inicio, fecha_fin)
    SELECT HISTORICO_EMPLEADO1_SEQ.NEXTVAL, empleado_id, hotel_id, fecha_inicio, FECHA_FIN_ACTUAL
    FROM ASIGNACION1
    WHERE empleado_id = EMPLEADO_ID;

    -- Eliminar la asignación actual del empleado
    DELETE FROM ASIGNACION1
    WHERE empleado_id = EMPLEADO_ID;

    -- Actualizar dirección y teléfono en la tabla EMPLEADO1
    UPDATE EMPLEADO1
    SET direccion = NUEVA_DIRECCION,
        telefono = NUEVO_TELEFONO
    WHERE empleado_id = EMPLEADO_ID;

    -- Asignar al empleado al nuevo hotel
    INSERT INTO ASIGNACION1 (asignacion_id, empleado_id, hotel_id, fecha_inicio)
    VALUES (ASIGNACION1_SEQ.NEXTVAL, EMPLEADO_ID, NUEVO_HOTEL_ID, FECHA_INICIO_NUEVO);

    DBMS_OUTPUT.PUT_LINE('Empleado trasladado correctamente en Localidad 1.');
END;
/


-- 5. Dar de alta un nuevo hotel.
CREATE OR REPLACE PROCEDURE AltaNuevoHotel(
    NUEVO_HOTEL_ID INT,
    NUEVO_NOMBRE VARCHAR2,
    NUEVA_CIUDAD VARCHAR2,
    NUEVA_PROVINCIA VARCHAR2,
    NUM_SENCI NUMBER,
    NUM_DOBLE NUMBER
)
IS
    hotelExistente INT;
BEGIN
    -- Verificar si el hotel ya existe
    SELECT COUNT(*) INTO hotelExistente
    FROM HOTEL1
    WHERE hotel_id = NUEVO_HOTEL_ID;

    IF hotelExistente > 0 THEN
        RAISE_APPLICATION_ERROR(-20501, 'ERROR: Ya existe un hotel con el código proporcionado.');
    END IF;

    -- Insertar el nuevo hotel
    INSERT INTO HOTEL1 (hotel_id, nombre, ciudad, provincia, capacidad_sencillas, capacidad_dobles)
    VALUES (NUEVO_HOTEL_ID, NUEVO_NOMBRE, NUEVA_CIUDAD, NUEVA_PROVINCIA, NUM_SENCI, NUM_DOBLE);

    DBMS_OUTPUT.PUT_LINE('Nuevo hotel dado de alta correctamente en Localidad 1.');
END;
/


-- 6. Cambiar el director de un hotel.
CREATE OR REPLACE PROCEDURE CambiarDirectorHotel(
    HOTEL_ID INT,
    NUEVO_DIRECTOR_ID INT
)
IS
    hotelExistente INT;
    empleadoExistente INT;
BEGIN
    -- Verificar si el hotel existe
    SELECT COUNT(*) INTO hotelExistente
    FROM HOTEL1
    WHERE hotel_id = HOTEL_ID;

    IF hotelExistente = 0 THEN
        RAISE_APPLICATION_ERROR(-20601, 'ERROR: El hotel con el código proporcionado no existe.');
    END IF;

    -- Verificar si el empleado existe
    SELECT COUNT(*) INTO empleadoExistente
    FROM EMPLEADO1
    WHERE empleado_id = NUEVO_DIRECTOR_ID;

    IF empleadoExistente = 0 THEN
        RAISE_APPLICATION_ERROR(-20602, 'ERROR: El empleado con el código proporcionado no existe.');
    END IF;

    -- Actualizar el director del hotel
    UPDATE HOTEL1
    SET director_id = NUEVO_DIRECTOR_ID
    WHERE hotel_id = HOTEL_ID;

    DBMS_OUTPUT.PUT_LINE('Director del hotel actualizado correctamente en Localidad 1.');
END;
/


-- 7. Dar de alta a un nuevo cliente.
CREATE OR REPLACE PROCEDURE AltaNuevoCliente(
    NUEVO_CLIENTE_ID INT,
    NUEVO_DNI VARCHAR2,
    NUEVO_NOMBRE VARCHAR2,
    NUEVO_TELEFONO VARCHAR2
)
IS
    clienteExistente INT;
BEGIN
    -- Verificar si el cliente ya existe
    SELECT COUNT(*) INTO clienteExistente
    FROM CLIENTE1
    WHERE cliente_id = NUEVO_CLIENTE_ID;

    IF clienteExistente > 0 THEN
        RAISE_APPLICATION_ERROR(-20701, 'ERROR: Ya existe un cliente con el código proporcionado.');
    END IF;

    -- Insertar el nuevo cliente
    INSERT INTO CLIENTE1 (cliente_id, dni, nombre, telefono)
    VALUES (NUEVO_CLIENTE_ID, NUEVO_DNI, NUEVO_NOMBRE, NUEVO_TELEFONO);

    DBMS_OUTPUT.PUT_LINE('Nuevo cliente dado de alta correctamente en Localidad 1.');
END;
/


-- 8. Dar de alta o actualizar una reserva.
CREATE OR REPLACE PROCEDURE AltaActualizarReserva(
    CLIENTE_ID INT,
    HOTEL_ID INT,
    TIPO_HABITACION VARCHAR2,
    FECHA_ENTRADA DATE,
    FECHA_SALIDA DATE,
    PRECIO_HABITACION NUMBER
)
IS
    reservaExistente INT;
BEGIN
    -- Verificar si la reserva ya existe
    SELECT COUNT(*) INTO reservaExistente
    FROM RESERVA1
    WHERE cliente_id = CLIENTE_ID
      AND hotel_id = HOTEL_ID
      AND fecha_entrada = FECHA_ENTRADA;

    IF reservaExistente > 0 THEN
        -- Actualizar la reserva existente
        UPDATE RESERVA1
        SET fecha_salida = FECHA_SALIDA,
            tipo_habitacion = TIPO_HABITACION,
            precio_noche = PRECIO_HABITACION
        WHERE cliente_id = CLIENTE_ID
          AND hotel_id = HOTEL_ID
          AND fecha_entrada = FECHA_ENTRADA;

        DBMS_OUTPUT.PUT_LINE('Reserva actualizada correctamente en Localidad 1.');
    ELSE
        -- Insertar una nueva reserva
        INSERT INTO RESERVA1 (reserva_id, cliente_id, hotel_id, fecha_entrada, fecha_salida, tipo_habitacion, precio_noche)
        VALUES (RESERVA1_SEQ.NEXTVAL, CLIENTE_ID, HOTEL_ID, FECHA_ENTRADA, FECHA_SALIDA, TIPO_HABITACION, PRECIO_HABITACION);

        DBMS_OUTPUT.PUT_LINE('Nueva reserva creada correctamente en Localidad 1.');
    END IF;
END;
/

-- 9. Anular una reserva.
CREATE OR REPLACE PROCEDURE AnularReserva(
    CLIENTE_ID INT,
    HOTEL_ID INT,
    FECHA_ENTRADA DATE,
    FECHA_SALIDA DATE
)
IS
    reservaExistente INT;
BEGIN
    -- Verificar si la reserva existe
    SELECT COUNT(*) INTO reservaExistente
    FROM RESERVA1
    WHERE cliente_id = CLIENTE_ID
      AND hotel_id = HOTEL_ID
      AND fecha_entrada = FECHA_ENTRADA
      AND fecha_salida = FECHA_SALIDA;

    IF reservaExistente = 0 THEN
        RAISE_APPLICATION_ERROR(-20901, 'ERROR: No existe ninguna reserva con las características proporcionadas.');
    END IF;

    -- Eliminar la reserva
    DELETE FROM RESERVA1
    WHERE cliente_id = CLIENTE_ID
      AND hotel_id = HOTEL_ID
      AND fecha_entrada = FECHA_ENTRADA
      AND fecha_salida = FECHA_SALIDA;

    DBMS_OUTPUT.PUT_LINE('Reserva anulada correctamente en Localidad 1.');
END;
/


-- 10. Dar de alta a un nuevo proveedor.
CREATE OR REPLACE PROCEDURE AltaNuevoProveedor(
    NUEVO_PROVEEDOR_ID INT,
    NUEVO_NOMBRE VARCHAR2,
    NUEVA_CIUDAD VARCHAR2
)
IS
    proveedorExistente INT;
BEGIN
    -- Verificar si el proveedor ya existe
    SELECT COUNT(*) INTO proveedorExistente
    FROM PROVEEDOR1
    WHERE proveedor_id = NUEVO_PROVEEDOR_ID;

    IF proveedorExistente > 0 THEN
        RAISE_APPLICATION_ERROR(-21001, 'ERROR: Ya existe un proveedor con el código proporcionado.');
    END IF;

    -- Insertar el nuevo proveedor
    INSERT INTO PROVEEDOR1 (proveedor_id, nombre, ciudad)
    VALUES (NUEVO_PROVEEDOR_ID, NUEVO_NOMBRE, NUEVA_CIUDAD);

    DBMS_OUTPUT.PUT_LINE('Nuevo proveedor dado de alta correctamente en Localidad 1.');
END;
/


-- 11. Dar de baja a un proveedor. 
CREATE OR REPLACE PROCEDURE BajaProveedor(
    PROVEEDOR_ID INT
)
IS
    proveedorExistente INT;
BEGIN
    -- Verificar si el proveedor existe
    SELECT COUNT(*) INTO proveedorExistente
    FROM PROVEEDOR1
    WHERE proveedor_id = PROVEEDOR_ID;

    IF proveedorExistente = 0 THEN
        RAISE_APPLICATION_ERROR(-21101, 'ERROR: No existe un proveedor con el código proporcionado.');
    END IF;

    -- Eliminar el proveedor
    DELETE FROM PROVEEDOR1
    WHERE proveedor_id = PROVEEDOR_ID;

    DBMS_OUTPUT.PUT_LINE('Proveedor eliminado correctamente en Localidad 1.');
END;
/


-- 12. Dar de alta o actualizar un suministro.
CREATE OR REPLACE PROCEDURE AltaActualizarSuministro(
    ARTICULO_ID INT,
    PROVEEDOR_ID INT,
    HOTEL_ID INT,
    FECHA_SUMINISTRO DATE,
    CANTIDAD_SUMINISTRAR NUMBER,
    PRECIO_UNITARIO NUMBER
)
IS
    suministroExistente INT;
BEGIN
    -- Verificar si el suministro ya existe
    SELECT COUNT(*) INTO suministroExistente
    FROM SUMINISTRO1
    WHERE articulo_id = ARTICULO_ID
      AND proveedor_id = PROVEEDOR_ID
      AND hotel_id = HOTEL_ID
      AND fecha_suministro = FECHA_SUMINISTRO;

    IF suministroExistente > 0 THEN
        -- Actualizar el suministro existente
        UPDATE SUMINISTRO1
        SET cantidad = cantidad + CANTIDAD_SUMINISTRAR,
            precio_unitario = PRECIO_UNITARIO
        WHERE articulo_id = ARTICULO_ID
          AND proveedor_id = PROVEEDOR_ID
          AND hotel_id = HOTEL_ID
          AND fecha_suministro = FECHA_SUMINISTRO;

        DBMS_OUTPUT.PUT_LINE('Suministro actualizado correctamente en Localidad 1.');
    ELSE
        -- Insertar un nuevo suministro
        INSERT INTO SUMINISTRO1 (suministro_id, articulo_id, proveedor_id, hotel_id, fecha_suministro, cantidad, precio_unitario)
        VALUES (SUMINISTRO1_SEQ.NEXTVAL, ARTICULO_ID, PROVEEDOR_ID, HOTEL_ID, FECHA_SUMINISTRO, CANTIDAD_SUMINISTRAR, PRECIO_UNITARIO);

        DBMS_OUTPUT.PUT_LINE('Nuevo suministro creado correctamente en Localidad 1.');
    END IF;
END;
/


-- 13. Dar de baja suministros
CREATE OR REPLACE PROCEDURE BajaSuministros(
    HOTEL_ID INT,
    ARTICULO_ID INT,
    FECHA_SUMINISTRO DATE DEFAULT NULL
)
IS
    suministroExistente INT;
BEGIN
    -- Verificar si existe el suministro
    SELECT COUNT(*) INTO suministroExistente
    FROM SUMINISTRO1
    WHERE hotel_id = HOTEL_ID
      AND articulo_id = ARTICULO_ID
      AND (FECHA_SUMINISTRO IS NULL OR fecha_suministro = FECHA_SUMINISTRO);

    IF suministroExistente = 0 THEN
        RAISE_APPLICATION_ERROR(-21301, 'ERROR: No existe ningún suministro con las características proporcionadas.');
    END IF;

    -- Eliminar el suministro
    DELETE FROM SUMINISTRO1
    WHERE hotel_id = HOTEL_ID
      AND articulo_id = ARTICULO_ID
      AND (FECHA_SUMINISTRO IS NULL OR fecha_suministro = FECHA_SUMINISTRO);

    DBMS_OUTPUT.PUT_LINE('Suministros eliminados correctamente en Localidad 1.');
END;
/


-- 14. Dar de alta un nuevo artículo. 
CREATE OR REPLACE PROCEDURE AltaNuevoArticulo(
    NUEVO_ARTICULO_ID INT,
    NUEVO_NOMBRE VARCHAR2,
    NUEVO_TIPO CHAR,
    PROVEEDOR_ID INT
)
IS
    articuloExistente INT;
BEGIN
    -- Verificar si el artículo ya existe
    SELECT COUNT(*) INTO articuloExistente
    FROM ARTICULO1
    WHERE articulo_id = NUEVO_ARTICULO_ID;

    IF articuloExistente > 0 THEN
        RAISE_APPLICATION_ERROR(-21401, 'ERROR: Ya existe un artículo con el código proporcionado.');
    END IF;

    -- Insertar el nuevo artículo
    INSERT INTO ARTICULO1 (articulo_id, nombre, tipo, proveedor_id)
    VALUES (NUEVO_ARTICULO_ID, NUEVO_NOMBRE, NUEVO_TIPO, PROVEEDOR_ID);

    DBMS_OUTPUT.PUT_LINE('Nuevo artículo dado de alta correctamente en Localidad 1.');
END;
/

-- 15. Dar de baja un artículo.

CREATE OR REPLACE PROCEDURE BajaArticulo(
    ARTICULO_ID INT
)
IS
    articuloExistente INT;
BEGIN
    -- Verificar si el artículo existe
    SELECT COUNT(*) INTO articuloExistente
    FROM ARTICULO1
    WHERE articulo_id = ARTICULO_ID;

    IF articuloExistente = 0 THEN
        RAISE_APPLICATION_ERROR(-21501, 'ERROR: No existe ningún artículo con el código proporcionado.');
    END IF;

    -- Eliminar los suministros asociados al artículo
    DELETE FROM SUMINISTRO1
    WHERE articulo_id = ARTICULO_ID;

    -- Eliminar el artículo
    DELETE FROM ARTICULO1
    WHERE articulo_id = ARTICULO_ID;

    DBMS_OUTPUT.PUT_LINE('Artículo y suministros asociados eliminados correctamente en Localidad 1.');
END;
/


-- Consultas

--Listar los hoteles (nombre y ciudad) de las provincias de Granada, Huelva o Almería, y los proveedores (nombre y ciudad), 
-- a los que se les ha suministrado “Queso” o “Mantequilla” entre el 12 de mayo de 2024 y el 28 de mayo de 2024.

SET SERVEROUTPUT ON;
SELECT 
    DISTINCT h.NOMBRE AS "Nombre Hotel",
    h.CIUDAD AS "Ciudad Hotel",
    p.NOMBRE AS "Nombre Proveedor",
    p.CIUDAD AS "Ciudad Proveedor"
FROM 
    HotelView h
JOIN 
    SuministroView sm ON h.CODHOTEL = sm.CODHOTEL
JOIN 
    ArticuloView a ON sm.CODART = a.CODART
JOIN 
    ProveedorView p ON sm.CODPROV = p.CODPROV
WHERE 
    h.PROVINCIA IN ('Granada', 'Huelva', 'Almería')
    AND a.NOMBRE IN ('Queso', 'Mantequilla')
    AND sm.FECHASUMINISTRO BETWEEN TO_DATE('2024-05-12', 'YYYY-MM-DD') 
                                AND TO_DATE('2024-05-28', 'YYYY-MM-DD');




-- Consulta 2
-- Dado por teclado el código de un productor, listar los productos (nombre), los hoteles (nombre y ciudad) y la cantidad total de cada producto, 
-- suministrados por dicho productor a hoteles de las provincias de Jaén o Almería.

SET SERVEROUTPUT ON;
DECLARE
    codigo_productor_input INT;
BEGIN
    -- Solicitar el código del productor
    DBMS_OUTPUT.PUT_LINE('Introduce el código de un productor: ');
    codigo_productor_input := &codigo_productor_input;

    -- Realizar la consulta
    FOR producto_info IN (
        SELECT 
            a.NOMBRE AS "Nombre Producto",
            h.NOMBRE AS "Nombre Hotel",
            h.CIUDAD AS "Ciudad Hotel",
            SUM(sm.CANTIDAD) AS "Cantidad Total"
        FROM 
            SuministroView sm
        JOIN 
            ArticuloView a ON sm.CODART = a.CODART
        JOIN 
            HotelView h ON sm.CODHOTEL = h.CODHOTEL
        WHERE 
            a.CODPROV = codigo_productor_input
            AND h.PROVINCIA IN ('Jaén', 'Almería')
        GROUP BY 
            a.NOMBRE, h.NOMBRE, h.CIUDAD
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Producto: ' || producto_info."Nombre Producto" || ', Hotel: ' || producto_info."Nombre Hotel" || ', Ciudad: ' || producto_info."Ciudad Hotel" || ', Cantidad Total: ' || producto_info."Cantidad Total");
    END LOOP;
END;


-- Consulta 3
-- Dado por teclado el código de un hotel, listar los clientes (nombre y teléfono) que tengan registrada más de una reserva en dicho hotel.

SET SERVEROUTPUT ON;
DECLARE
    codigo_hotel_input INT;
BEGIN
    -- Solicitar el código del hotel
    DBMS_OUTPUT.PUT_LINE('Introduce el código de un hotel: ');
    codigo_hotel_input := &codigo_hotel_input;

    -- Realizar la consulta
    FOR cliente_info IN (
        SELECT 
            c.NOMBRE AS "Nombre Cliente",
            c.TELEFONO AS "Teléfono Cliente"
        FROM 
            ClienteView c
        JOIN 
            ReservaView r ON c.CODCL = r.CODCL
        WHERE 
            r.CODHOTEL = codigo_hotel_input
        GROUP BY 
            c.NOMBRE, c.TELEFONO
        HAVING 
            COUNT(r.CODRESERVA) > 1
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Cliente: ' || cliente_info."Nombre Cliente" || ', Teléfono: ' || cliente_info."Teléfono Cliente");
    END LOOP;
END;






