-- 1. Eliminación de objetos existentes
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE SUMINISTRO2 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE RESERVA2 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE ASIGNACION2 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE HOTEL2 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE EMPLEADO2 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE CLIENTE2 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE PROVEEDOR2 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE ARTICULO2 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE HISTORICO_EMPLEADO2 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP SEQUENCE EMPLEADO2_SEQ';
    EXECUTE IMMEDIATE 'DROP SEQUENCE HOTEL2_SEQ';
    EXECUTE IMMEDIATE 'DROP SEQUENCE PROVEEDOR2_SEQ';
    EXECUTE IMMEDIATE 'DROP SEQUENCE ARTICULO2_SEQ';
    EXECUTE IMMEDIATE 'DROP SEQUENCE RESERVA2_SEQ';
    EXECUTE IMMEDIATE 'DROP SEQUENCE ASIGNACION2_SEQ';
    EXECUTE IMMEDIATE 'DROP SEQUENCE SUMINISTRO2_SEQ';
    EXECUTE IMMEDIATE 'DROP SEQUENCE HISTORICO_EMPLEADO2_SEQ';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/


-- Creación de la tabla EMPLEADO para localidad2
CREATE TABLE EMPLEADO2 (
    empleado_id NUMBER PRIMARY KEY,
    dni VARCHAR2(9) UNIQUE NOT NULL,
    nombre VARCHAR2(100) NOT NULL,
    telefono VARCHAR2(15),
    direccion VARCHAR2(200),
    fecha_inicio DATE NOT NULL,
    salario NUMBER CHECK (salario > 0)
);

-- Creación de la tabla PROVEEDOR para localidad2
CREATE TABLE PROVEEDOR2 (
    proveedor_id NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    ciudad VARCHAR2(100) CHECK (ciudad IN ('Sevilla', 'Córdoba'))
);

-- Creación de la tabla ARTICULO para localidad2
CREATE TABLE ARTICULO2 (
    articulo_id NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    tipo CHAR(1) CHECK (tipo IN ('A', 'B', 'C', 'D')),
    proveedor_id NUMBER NOT NULL,
    CONSTRAINT fk_articulo_proveedor2 FOREIGN KEY (proveedor_id) REFERENCES PROVEEDOR2(proveedor_id)
);

-- Creación de la tabla HOTEL para localidad2
CREATE TABLE HOTEL2 (
    hotel_id NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    capacidad_sencillas NUMBER NOT NULL,
    capacidad_dobles NUMBER NOT NULL,
    ciudad VARCHAR2(100) NOT NULL,
    provincia VARCHAR2(100) NOT NULL,
    director_id NUMBER,
    CONSTRAINT fk_hotel_director2 FOREIGN KEY (director_id) REFERENCES EMPLEADO2(empleado_id)
);

-- Creación de la tabla CLIENTE para localidad2
CREATE TABLE CLIENTE2 (
    cliente_id NUMBER PRIMARY KEY,
    dni VARCHAR2(9) UNIQUE NOT NULL,
    nombre VARCHAR2(100) NOT NULL,
    telefono VARCHAR2(15)
);

-- Creación de la tabla RESERVA para localidad2
CREATE TABLE RESERVA2 (
    reserva_id NUMBER PRIMARY KEY,
    cliente_id NUMBER NOT NULL,
    hotel_id NUMBER NOT NULL,
    fecha_entrada DATE NOT NULL,
    fecha_salida DATE NOT NULL,
    tipo_habitacion VARCHAR2(10) CHECK (tipo_habitacion IN ('sencilla', 'doble')),
    precio_noche NUMBER NOT NULL,
    CONSTRAINT fk_cliente2 FOREIGN KEY (cliente_id) REFERENCES CLIENTE2(cliente_id),
    CONSTRAINT fk_hotel2 FOREIGN KEY (hotel_id) REFERENCES HOTEL2(hotel_id)
);

-- Creación de la tabla ASIGNACION para localidad2
CREATE TABLE ASIGNACION2 (
    asignacion_id NUMBER PRIMARY KEY,
    empleado_id NUMBER NOT NULL,
    hotel_id NUMBER NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    CONSTRAINT fk_asignacion_empleado2 FOREIGN KEY (empleado_id) REFERENCES EMPLEADO2(empleado_id),
    CONSTRAINT fk_asignacion_hotel2 FOREIGN KEY (hotel_id) REFERENCES HOTEL2(hotel_id)
);

-- Creación de la tabla SUMINISTRO para localidad2
CREATE TABLE SUMINISTRO2 (
    suministro_id NUMBER PRIMARY KEY,
    proveedor_id NUMBER NOT NULL,
    hotel_id NUMBER NOT NULL,
    articulo_id NUMBER NOT NULL,
    fecha_suministro DATE NOT NULL,
    cantidad NUMBER NOT NULL CHECK (cantidad > 0),
    precio_unitario NUMBER NOT NULL CHECK (precio_unitario > 0),
    CONSTRAINT fk_suministro_hotel2 FOREIGN KEY (hotel_id) REFERENCES HOTEL2(hotel_id),
    CONSTRAINT fk_suministro_proveedor2 FOREIGN KEY (proveedor_id) REFERENCES PROVEEDOR2(proveedor_id),
    CONSTRAINT fk_suministro_articulo2 FOREIGN KEY (articulo_id) REFERENCES ARTICULO2(articulo_id)
);

CREATE TABLE HISTORICO_EMPLEADO2 (
    historico_id NUMBER PRIMARY KEY,
    empleado_id NUMBER NOT NULL,
    hotel_id NUMBER NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    CONSTRAINT fk_historico_empleado FOREIGN KEY (empleado_id) REFERENCES EMPLEADO2(empleado_id),
    CONSTRAINT fk_historico_hotel FOREIGN KEY (hotel_id) REFERENCES HOTEL2(hotel_id)
);
/



-- Creación de secuencias para las tablas de Localidad 2
CREATE SEQUENCE EMPLEADO2_SEQ START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE HOTEL2_SEQ START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE PROVEEDOR2_SEQ START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE ARTICULO2_SEQ START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE RESERVA2_SEQ START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE ASIGNACION2_SEQ START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SUMINISTRO2_SEQ START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE HISTORICO_EMPLEADO2_SEQ START WITH 1 INCREMENT BY 1 NOCACHE;
/

GRANT SELECT, INSERT, UPDATE, DELETE ON HISTORICO_EMPLEADO2 TO betis1;


-- Insertar datos en la tabla EMPLEADO2
INSERT INTO EMPLEADO2 (empleado_id, dni, nombre, telefono, direccion, fecha_inicio, salario) 
VALUES (1, '11111111A', 'María López', '954123456', 'Calle Sevilla, Sevilla', TO_DATE('2022-01-01', 'YYYY-MM-DD'), 1800);
INSERT INTO EMPLEADO2 (empleado_id, dni, nombre, telefono, direccion, fecha_inicio, salario) 
VALUES (2, '22222222B', 'Juan Pérez', '955654321', 'Calle Córdoba, Córdoba', TO_DATE('2021-06-15', 'YYYY-MM-DD'), 2000);

-- Insertar datos en la tabla PROVEEDOR2
INSERT INTO PROVEEDOR2 (proveedor_id, nombre, ciudad) VALUES (1, 'SevillaPro', 'Sevilla');
INSERT INTO PROVEEDOR2 (proveedor_id, nombre, ciudad) VALUES (2, 'CordobaDistrib', 'Córdoba');

-- Insertar datos en la tabla ARTICULO2
INSERT INTO ARTICULO2 (articulo_id, nombre, tipo, proveedor_id) VALUES (1, 'Carne', 'A', 1);
INSERT INTO ARTICULO2 (articulo_id, nombre, tipo, proveedor_id) VALUES (2, 'Lácteos', 'B', 2);

-- Insertar datos en la tabla HOTEL2
INSERT INTO HOTEL2 (hotel_id, nombre, capacidad_sencillas, capacidad_dobles, ciudad, provincia, director_id) 
VALUES (1, 'Hotel Guadalquivir', 10, 20, 'Sevilla', 'Sevilla', 1);
INSERT INTO HOTEL2 (hotel_id, nombre, capacidad_sencillas, capacidad_dobles, ciudad, provincia, director_id) 
VALUES (2, 'Hotel Mezquita', 15, 25, 'Córdoba', 'Córdoba', 2);

-- Insertar datos en la tabla CLIENTE2
INSERT INTO CLIENTE2 (cliente_id, dni, nombre, telefono) VALUES (1, '33333333C', 'Pedro García', '600987654');
INSERT INTO CLIENTE2 (cliente_id, dni, nombre, telefono) VALUES (2, '44444444D', 'Ana Gómez', '650654321');

-- Insertar datos en la tabla RESERVA2
INSERT INTO RESERVA2 (reserva_id, cliente_id, hotel_id, fecha_entrada, fecha_salida, tipo_habitacion, precio_noche) 
VALUES (1, 1, 1, TO_DATE('2024-07-01', 'YYYY-MM-DD'), TO_DATE('2024-07-05', 'YYYY-MM-DD'), 'sencilla', 100);
INSERT INTO RESERVA2 (reserva_id, cliente_id, hotel_id, fecha_entrada, fecha_salida, tipo_habitacion, precio_noche) 
VALUES (2, 2, 2, TO_DATE('2024-08-01', 'YYYY-MM-DD'), TO_DATE('2024-08-10', 'YYYY-MM-DD'), 'doble', 150);

-- Insertar datos en la tabla ASIGNACION2
INSERT INTO ASIGNACION2 (asignacion_id, empleado_id, hotel_id, fecha_inicio, fecha_fin) 
VALUES (1, 1, 1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), NULL);
INSERT INTO ASIGNACION2 (asignacion_id, empleado_id, hotel_id, fecha_inicio, fecha_fin) 
VALUES (2, 2, 2, TO_DATE('2021-06-15', 'YYYY-MM-DD'), NULL);

-- Insertar datos en la tabla SUMINISTRO2
INSERT INTO SUMINISTRO2 (suministro_id, proveedor_id, hotel_id, articulo_id, fecha_suministro, cantidad, precio_unitario) 
VALUES (1, 1, 1, 1, TO_DATE('2024-06-01', 'YYYY-MM-DD'), 50, 20);
INSERT INTO SUMINISTRO2 (suministro_id, proveedor_id, hotel_id, articulo_id, fecha_suministro, cantidad, precio_unitario) 
VALUES (2, 2, 2, 2, TO_DATE('2024-06-10', 'YYYY-MM-DD'), 30, 15);


-- Disparador para evitar SYSDATE en restricción CHECK
CREATE OR REPLACE TRIGGER trg_fecha_inicio_valid2
BEFORE INSERT OR UPDATE ON EMPLEADO2
FOR EACH ROW
BEGIN
    IF :NEW.fecha_inicio > SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20007, 'La fecha de inicio no puede ser futura.');
    END IF;
END;
/

-- Disparador para asegurar que el número de reservas no excede la capacidad del hotel
CREATE OR REPLACE TRIGGER trg_check_capacidad2
BEFORE INSERT OR UPDATE ON RESERVA2
FOR EACH ROW
DECLARE
    total_sencillas NUMBER;
    total_dobles NUMBER;
    capacidad_sencillas NUMBER;
    capacidad_dobles NUMBER;
BEGIN
    SELECT capacidad_sencillas, capacidad_dobles
    INTO capacidad_sencillas, capacidad_dobles
    FROM HOTEL2 WHERE hotel_id = :NEW.hotel_id;

    SELECT COUNT(*) INTO total_sencillas
    FROM RESERVA2
    WHERE hotel_id = :NEW.hotel_id AND tipo_habitacion = 'sencilla';

    SELECT COUNT(*) INTO total_dobles
    FROM RESERVA2
    WHERE hotel_id = :NEW.hotel_id AND tipo_habitacion = 'doble';

    IF :NEW.tipo_habitacion = 'sencilla' AND total_sencillas + 1 > capacidad_sencillas THEN
        RAISE_APPLICATION_ERROR(-20001, 'No se pueden exceder las habitaciones sencillas disponibles.');
    ELSIF :NEW.tipo_habitacion = 'doble' AND total_dobles + 1 > capacidad_dobles THEN
        RAISE_APPLICATION_ERROR(-20002, 'No se pueden exceder las habitaciones dobles disponibles.');
    END IF;
END;
/

-- Disparador para evitar disminución del salario
CREATE OR REPLACE TRIGGER trg_check_salario2
BEFORE UPDATE ON EMPLEADO2
FOR EACH ROW
BEGIN
    IF :NEW.salario < :OLD.salario THEN
        RAISE_APPLICATION_ERROR(-20004, 'El salario de un empleado no puede disminuir.');
    END IF;
END;
/

-- Disparador para validar la relación entre PROVEEDOR2 y ciudad de suministros
CREATE OR REPLACE TRIGGER trg_check_proveedor_ciudad2
BEFORE INSERT OR UPDATE ON SUMINISTRO2
FOR EACH ROW
DECLARE
    proveedor_ciudad VARCHAR2(100);
    provincia_hotel VARCHAR2(100);
BEGIN
    SELECT ciudad INTO proveedor_ciudad FROM PROVEEDOR2 WHERE proveedor_id = :NEW.proveedor_id;
    SELECT provincia INTO provincia_hotel FROM HOTEL2 WHERE hotel_id = :NEW.hotel_id;

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
    SELECT COUNT(*) INTO hotelExistente FROM HOTEL2 WHERE hotel_id = NEW_HOTEL_ID;
    IF hotelExistente = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El hotel no existe.');
    END IF;

    -- Validar existencia del empleado
    SELECT COUNT(*) INTO empleadoExistente FROM EMPLEADO2 WHERE empleado_id = NEW_EMPLEADO_ID;
    IF empleadoExistente > 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'El empleado ya existe.');
    END IF;

    -- Insertar nuevo empleado
    INSERT INTO EMPLEADO2 (empleado_id, dni, nombre, direccion, telefono, fecha_inicio, salario)
    VALUES (EMPLEADO2_SEQ.NEXTVAL, NEW_DNI, NEW_NOMBRE, NEW_DIRECCION, NEW_TELEFONO, NEW_FECHA_CONTRATO, NEW_SALARIO);

    DBMS_OUTPUT.PUT_LINE('Empleado creado con éxito.');
END;
/



-- 2. Dar de baja un empleado

CREATE OR REPLACE PROCEDURE BajaEmpleado2(
    EMPLEADO_ID INT,
    FECHA_BAJA DATE
)
IS
    empleadoExistente INT;
BEGIN
    -- Verificar si el empleado existe
    SELECT COUNT(*) INTO empleadoExistente
    FROM EMPLEADO2
    WHERE empleado_id = EMPLEADO_ID;

    IF empleadoExistente = 0 THEN
        RAISE_APPLICATION_ERROR(-20201, 'ERROR: El empleado con el código proporcionado no existe.');
    END IF;

    -- Eliminar asignaciones y registros del empleado
    DELETE FROM ASIGNACION2 WHERE empleado_id = EMPLEADO_ID;
    DELETE FROM EMPLEADO2 WHERE empleado_id = EMPLEADO_ID;

    DBMS_OUTPUT.PUT_LINE('Empleado dado de baja correctamente en Localidad 2.');
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
    FROM EMPLEADO2
    WHERE empleado_id = EMPLEADO_ID;

    IF empleadoExistente = 0 THEN
        RAISE_APPLICATION_ERROR(-20301, 'ERROR: El empleado con el código proporcionado no existe.');
    END IF;

    -- Validar que el nuevo salario sea positivo
    IF NUEVO_SALARIO <= 0 THEN
        RAISE_APPLICATION_ERROR(-20302, 'ERROR: El salario debe ser mayor que 0.');
    END IF;

    -- Modificar el salario del empleado
    UPDATE EMPLEADO2
    SET salario = NUEVO_SALARIO
    WHERE empleado_id = EMPLEADO_ID;

    DBMS_OUTPUT.PUT_LINE('Salario del empleado actualizado correctamente en Localidad 2.');
END;
/


-- 4. Trasladar de hotel a un empleado

CREATE OR REPLACE PROCEDURE TrasladarEmpleado2(
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
    FROM EMPLEADO2
    WHERE empleado_id = EMPLEADO_ID;

    IF empleadoExistente = 0 THEN
        RAISE_APPLICATION_ERROR(-20401, 'ERROR: El empleado con el código proporcionado no existe.');
    END IF;

    -- Verificar si el nuevo hotel existe
    SELECT COUNT(*) INTO hotelExistente
    FROM HOTEL2
    WHERE hotel_id = NUEVO_HOTEL_ID;

    IF hotelExistente = 0 THEN
        RAISE_APPLICATION_ERROR(-20402, 'ERROR: El hotel con el código proporcionado no existe.');
    END IF;

    -- Crear el registro histórico del empleado
    INSERT INTO HISTORICO_EMPLEADO2 (historico_id, empleado_id, hotel_id, fecha_inicio, fecha_fin)
    SELECT HISTORICO_EMPLEADO2_SEQ.NEXTVAL, empleado_id, hotel_id, fecha_inicio, FECHA_FIN_ACTUAL
    FROM ASIGNACION2
    WHERE empleado_id = EMPLEADO_ID;

    -- Eliminar la asignación actual del empleado
    DELETE FROM ASIGNACION2
    WHERE empleado_id = EMPLEADO_ID;

    -- Actualizar dirección y teléfono en la tabla EMPLEADO2
    UPDATE EMPLEADO2
    SET direccion = NUEVA_DIRECCION,
        telefono = NUEVO_TELEFONO
    WHERE empleado_id = EMPLEADO_ID;

    -- Asignar al empleado al nuevo hotel
    INSERT INTO ASIGNACION2 (asignacion_id, empleado_id, hotel_id, fecha_inicio)
    VALUES (ASIGNACION2_SEQ.NEXTVAL, EMPLEADO_ID, NUEVO_HOTEL_ID, FECHA_INICIO_NUEVO);

    DBMS_OUTPUT.PUT_LINE('Empleado trasladado correctamente en Localidad 2.');
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
    FROM HOTEL2
    WHERE hotel_id = NUEVO_HOTEL_ID;

    IF hotelExistente > 0 THEN
        RAISE_APPLICATION_ERROR(-20501, 'ERROR: Ya existe un hotel con el código proporcionado.');
    END IF;

    -- Insertar el nuevo hotel
    INSERT INTO HOTEL2 (hotel_id, nombre, ciudad, provincia, capacidad_sencillas, capacidad_dobles)
    VALUES (NUEVO_HOTEL_ID, NUEVO_NOMBRE, NUEVA_CIUDAD, NUEVA_PROVINCIA, NUM_SENCI, NUM_DOBLE);

    DBMS_OUTPUT.PUT_LINE('Nuevo hotel dado de alta correctamente en Localidad 2.');
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
    FROM HOTEL2
    WHERE hotel_id = HOTEL_ID;

    IF hotelExistente = 0 THEN
        RAISE_APPLICATION_ERROR(-20601, 'ERROR: El hotel con el código proporcionado no existe.');
    END IF;

    -- Verificar si el empleado existe
    SELECT COUNT(*) INTO empleadoExistente
    FROM EMPLEADO2
    WHERE empleado_id = NUEVO_DIRECTOR_ID;

    IF empleadoExistente = 0 THEN
        RAISE_APPLICATION_ERROR(-20602, 'ERROR: El empleado con el código proporcionado no existe.');
    END IF;

    -- Actualizar el director del hotel
    UPDATE HOTEL2
    SET director_id = NUEVO_DIRECTOR_ID
    WHERE hotel_id = HOTEL_ID;

    DBMS_OUTPUT.PUT_LINE('Director del hotel actualizado correctamente en Localidad 2.');
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
    FROM CLIENTE2
    WHERE cliente_id = NUEVO_CLIENTE_ID;

    IF clienteExistente > 0 THEN
        RAISE_APPLICATION_ERROR(-20701, 'ERROR: Ya existe un cliente con el código proporcionado.');
    END IF;

    -- Insertar el nuevo cliente
    INSERT INTO CLIENTE2 (cliente_id, dni, nombre, telefono)
    VALUES (NUEVO_CLIENTE_ID, NUEVO_DNI, NUEVO_NOMBRE, NUEVO_TELEFONO);

    DBMS_OUTPUT.PUT_LINE('Nuevo cliente dado de alta correctamente en Localidad 2.');
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
    FROM RESERVA2
    WHERE cliente_id = CLIENTE_ID
      AND hotel_id = HOTEL_ID
      AND fecha_entrada = FECHA_ENTRADA;

    IF reservaExistente > 0 THEN
        -- Actualizar la reserva existente
        UPDATE RESERVA2
        SET fecha_salida = FECHA_SALIDA,
            tipo_habitacion = TIPO_HABITACION,
            precio_noche = PRECIO_HABITACION
        WHERE cliente_id = CLIENTE_ID
          AND hotel_id = HOTEL_ID
          AND fecha_entrada = FECHA_ENTRADA;

        DBMS_OUTPUT.PUT_LINE('Reserva actualizada correctamente en Localidad 2.');
    ELSE
        -- Insertar una nueva reserva
        INSERT INTO RESERVA2 (reserva_id, cliente_id, hotel_id, fecha_entrada, fecha_salida, tipo_habitacion, precio_noche)
        VALUES (RESERVA2_SEQ.NEXTVAL, CLIENTE_ID, HOTEL_ID, FECHA_ENTRADA, FECHA_SALIDA, TIPO_HABITACION, PRECIO_HABITACION);

        DBMS_OUTPUT.PUT_LINE('Nueva reserva creada correctamente en Localidad 2.');
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
    FROM RESERVA2
    WHERE cliente_id = CLIENTE_ID
      AND hotel_id = HOTEL_ID
      AND fecha_entrada = FECHA_ENTRADA
      AND fecha_salida = FECHA_SALIDA;

    IF reservaExistente = 0 THEN
        RAISE_APPLICATION_ERROR(-20901, 'ERROR: No existe ninguna reserva con las características proporcionadas.');
    END IF;

    -- Eliminar la reserva
    DELETE FROM RESERVA2
    WHERE cliente_id = CLIENTE_ID
      AND hotel_id = HOTEL_ID
      AND fecha_entrada = FECHA_ENTRADA
      AND fecha_salida = FECHA_SALIDA;

    DBMS_OUTPUT.PUT_LINE('Reserva anulada correctamente en Localidad 2.');
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
    FROM PROVEEDOR2
    WHERE proveedor_id = NUEVO_PROVEEDOR_ID;

    IF proveedorExistente > 0 THEN
        RAISE_APPLICATION_ERROR(-21001, 'ERROR: Ya existe un proveedor con el código proporcionado.');
    END IF;

    -- Insertar el nuevo proveedor
    INSERT INTO PROVEEDOR2 (proveedor_id, nombre, ciudad)
    VALUES (NUEVO_PROVEEDOR_ID, NUEVO_NOMBRE, NUEVA_CIUDAD);

    DBMS_OUTPUT.PUT_LINE('Nuevo proveedor dado de alta correctamente en Localidad 2.');
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
    FROM PROVEEDOR2
    WHERE proveedor_id = PROVEEDOR_ID;

    IF proveedorExistente = 0 THEN
        RAISE_APPLICATION_ERROR(-21101, 'ERROR: No existe un proveedor con el código proporcionado.');
    END IF;

    -- Eliminar el proveedor
    DELETE FROM PROVEEDOR2
    WHERE proveedor_id = PROVEEDOR_ID;

    DBMS_OUTPUT.PUT_LINE('Proveedor eliminado correctamente en Localidad 2.');
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
    FROM SUMINISTRO2
    WHERE articulo_id = ARTICULO_ID
      AND proveedor_id = PROVEEDOR_ID
      AND hotel_id = HOTEL_ID
      AND fecha_suministro = FECHA_SUMINISTRO;

    IF suministroExistente > 0 THEN
        -- Actualizar el suministro existente
        UPDATE SUMINISTRO2
        SET cantidad = cantidad + CANTIDAD_SUMINISTRAR,
            precio_unitario = PRECIO_UNITARIO
        WHERE articulo_id = ARTICULO_ID
          AND proveedor_id = PROVEEDOR_ID
          AND hotel_id = HOTEL_ID
          AND fecha_suministro = FECHA_SUMINISTRO;

        DBMS_OUTPUT.PUT_LINE('Suministro actualizado correctamente en Localidad 2.');
    ELSE
        -- Insertar un nuevo suministro
        INSERT INTO SUMINISTRO2 (suministro_id, articulo_id, proveedor_id, hotel_id, fecha_suministro, cantidad, precio_unitario)
        VALUES (SUMINISTRO2_SEQ.NEXTVAL, ARTICULO_ID, PROVEEDOR_ID, HOTEL_ID, FECHA_SUMINISTRO, CANTIDAD_SUMINISTRAR, PRECIO_UNITARIO);

        DBMS_OUTPUT.PUT_LINE('Nuevo suministro creado correctamente en Localidad 2.');
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
    FROM SUMINISTRO2
    WHERE hotel_id = HOTEL_ID
      AND articulo_id = ARTICULO_ID
      AND (FECHA_SUMINISTRO IS NULL OR fecha_suministro = FECHA_SUMINISTRO);

    IF suministroExistente = 0 THEN
        RAISE_APPLICATION_ERROR(-21301, 'ERROR: No existe ningún suministro con las características proporcionadas.');
    END IF;

    -- Eliminar el suministro
    DELETE FROM SUMINISTRO2
    WHERE hotel_id = HOTEL_ID
      AND articulo_id = ARTICULO_ID
      AND (FECHA_SUMINISTRO IS NULL OR fecha_suministro = FECHA_SUMINISTRO);

    DBMS_OUTPUT.PUT_LINE('Suministros eliminados correctamente en Localidad 2.');
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
    FROM ARTICULO2
    WHERE articulo_id = NUEVO_ARTICULO_ID;

    IF articuloExistente > 0 THEN
        RAISE_APPLICATION_ERROR(-21401, 'ERROR: Ya existe un artículo con el código proporcionado.');
    END IF;

    -- Insertar el nuevo artículo
    INSERT INTO ARTICULO2 (articulo_id, nombre, tipo, proveedor_id)
    VALUES (NUEVO_ARTICULO_ID, NUEVO_NOMBRE, NUEVO_TIPO, PROVEEDOR_ID);

    DBMS_OUTPUT.PUT_LINE('Nuevo artículo dado de alta correctamente en Localidad 2.');
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
    FROM ARTICULO2
    WHERE articulo_id = ARTICULO_ID;

    IF articuloExistente = 0 THEN
        RAISE_APPLICATION_ERROR(-21501, 'ERROR: No existe ningún artículo con el código proporcionado.');
    END IF;

    -- Eliminar los suministros asociados al artículo
    DELETE FROM SUMINISTRO2
    WHERE articulo_id = ARTICULO_ID;

    -- Eliminar el artículo
    DELETE FROM ARTICULO2
    WHERE articulo_id = ARTICULO_ID;

    DBMS_OUTPUT.PUT_LINE('Artículo y suministros asociados eliminados correctamente en Localidad 2.');
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







