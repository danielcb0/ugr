SELECT table_name FROM user_tables;

-- Para habilitar la muestra de mensajes por pantalla
SET SERVEROUTPUT ON


-- Eliminar objetos existentes si ya existen
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE SUMINISTRO1 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE RESERVA1 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE ASIGNACION1 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE HOTEL1 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE EMPLEADO1 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE CLIENTE1 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE PROVEEDOR1 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE ARTICULO1 CASCADE CONSTRAINTS';
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
    salario NUMBER CHECK (salario > 0)
);

-- Creación de la tabla PROVEEDOR para localidad1
CREATE TABLE PROVEEDOR1 (
    proveedor_id NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    ciudad VARCHAR2(100) CHECK (ciudad IN ('Granada', 'Jaén'))
);

-- Creación de la tabla ARTICULO para localidad1
CREATE TABLE ARTICULO1 (
    articulo_id NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    tipo CHAR(1) CHECK (tipo IN ('A', 'B', 'C', 'D')),
    proveedor_id NUMBER NOT NULL,
    CONSTRAINT fk_articulo_proveedor FOREIGN KEY (proveedor_id) REFERENCES PROVEEDOR1(proveedor_id)
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
    CONSTRAINT fk_hotel_director FOREIGN KEY (director_id) REFERENCES EMPLEADO1(empleado_id)
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
    CONSTRAINT fk_cliente1 FOREIGN KEY (cliente_id) REFERENCES CLIENTE1(cliente_id),
    CONSTRAINT fk_hotel1 FOREIGN KEY (hotel_id) REFERENCES HOTEL1(hotel_id)
);

-- Creación de la tabla ASIGNACION para localidad1
CREATE TABLE ASIGNACION1 (
    asignacion_id NUMBER PRIMARY KEY,
    empleado_id NUMBER NOT NULL,
    hotel_id NUMBER NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    CONSTRAINT fk_asignacion_empleado1 FOREIGN KEY (empleado_id) REFERENCES EMPLEADO1(empleado_id),
    CONSTRAINT fk_asignacion_hotel1 FOREIGN KEY (hotel_id) REFERENCES HOTEL1(hotel_id)
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
    CONSTRAINT fk_suministro_hotel1 FOREIGN KEY (hotel_id) REFERENCES HOTEL1(hotel_id),
    CONSTRAINT fk_suministro_proveedor FOREIGN KEY (proveedor_id) REFERENCES PROVEEDOR1(proveedor_id),
    CONSTRAINT fk_suministro_articulo FOREIGN KEY (articulo_id) REFERENCES ARTICULO1(articulo_id)
);

-- Inserts de datos para localidad1
-- Eliminar registros duplicados antes de insertar
DELETE FROM EMPLEADO1 WHERE empleado_id IN (1, 2);
DELETE FROM PROVEEDOR1 WHERE proveedor_id IN (1, 2);
DELETE FROM ARTICULO1 WHERE articulo_id IN (1, 2, 3);
DELETE FROM CLIENTE1 WHERE cliente_id IN (1, 2);

-- Empleados
INSERT INTO EMPLEADO1 (empleado_id, dni, nombre, telefono, direccion, fecha_inicio, salario) 
VALUES (1, '11111111A', 'Carlos López', '958123456', 'Calle Sierra Nevada, Granada', TO_DATE('2020-01-01', 'YYYY-MM-DD'), 2000);
INSERT INTO EMPLEADO1 (empleado_id, dni, nombre, telefono, direccion, fecha_inicio, salario) 
VALUES (2, '22222222B', 'María Perez', '953987654', 'Avda. Andalucía, Jaén', TO_DATE('2019-02-15', 'YYYY-MM-DD'), 2200);

-- Proveedores
INSERT INTO PROVEEDOR1 (proveedor_id, nombre, ciudad) VALUES (1, 'Gravilla', 'Granada');
INSERT INTO PROVEEDOR1 (proveedor_id, nombre, ciudad) VALUES (2, 'LocalSup', 'Jaén');

-- Artículos
INSERT INTO ARTICULO1 (articulo_id, nombre, tipo, proveedor_id) VALUES (1, 'Pollo', 'A', 1);
INSERT INTO ARTICULO1 (articulo_id, nombre, tipo, proveedor_id) VALUES (2, 'Verduras', 'B', 2);
INSERT INTO ARTICULO1 (articulo_id, nombre, tipo, proveedor_id) VALUES (3, 'Frutas', 'B', 1);

-- Hoteles
INSERT INTO HOTEL1 (hotel_id, nombre, capacidad_sencillas, capacidad_dobles, ciudad, provincia, director_id) 
VALUES (1, 'Hotel Sierra', 10, 20, 'Granada', 'Granada', 1);
INSERT INTO HOTEL1 (hotel_id, nombre, capacidad_sencillas, capacidad_dobles, ciudad, provincia, director_id) 
VALUES (2, 'Hotel Maravillas', 15, 25, 'Jaén', 'Jaén', 2);

-- Clientes
INSERT INTO CLIENTE1 (cliente_id, dni, nombre, telefono) 
VALUES (1, '33333333C', 'Pedro Sánchez', '600123456');
INSERT INTO CLIENTE1 (cliente_id, dni, nombre, telefono) 
VALUES (2, '44444444D', 'Ana Gómez', '650654321');

-- Reservas
INSERT INTO RESERVA1 (reserva_id, cliente_id, hotel_id, fecha_entrada, fecha_salida, tipo_habitacion, precio_noche) 
VALUES (1, 1, 1, TO_DATE('2024-07-01', 'YYYY-MM-DD'), TO_DATE('2024-07-05', 'YYYY-MM-DD'), 'sencilla', 80);
INSERT INTO RESERVA1 (reserva_id, cliente_id, hotel_id, fecha_entrada, fecha_salida, tipo_habitacion, precio_noche) 
VALUES (2, 2, 2, TO_DATE('2024-08-01', 'YYYY-MM-DD'), TO_DATE('2024-08-10', 'YYYY-MM-DD'), 'doble', 120);

-- Asignaciones
INSERT INTO ASIGNACION1 (asignacion_id, empleado_id, hotel_id, fecha_inicio, fecha_fin) 
VALUES (1, 1, 1, TO_DATE('2021-03-01', 'YYYY-MM-DD'), NULL);
INSERT INTO ASIGNACION1 (asignacion_id, empleado_id, hotel_id, fecha_inicio, fecha_fin) 
VALUES (2, 2, 2, TO_DATE('2020-07-15', 'YYYY-MM-DD'), NULL);

-- Disparador para evitar SYSDATE en restricción CHECK
CREATE OR REPLACE TRIGGER trg_fecha_inicio_valid
BEFORE INSERT OR UPDATE ON EMPLEADO1
FOR EACH ROW
BEGIN
    IF :NEW.fecha_inicio > SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20007, 'La fecha de inicio no puede ser futura.');
    END IF;
END;
/

-- Disparador para asegurar que el número de reservas no excede la capacidad del hotel
CREATE OR REPLACE TRIGGER trg_check_capacidad1
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
CREATE OR REPLACE TRIGGER trg_check_salario1
BEFORE UPDATE ON EMPLEADO1
FOR EACH ROW
BEGIN
    IF :NEW.salario < :OLD.salario THEN
        RAISE_APPLICATION_ERROR(-20004, 'El salario de un empleado no puede disminuir.');
    END IF;
END;
/

-- Disparador para validar la relación entre PROVEEDOR1 y ciudad de suministros
CREATE OR REPLACE TRIGGER trg_check_proveedor_ciudad1
BEFORE INSERT OR UPDATE ON SUMINISTRO1
FOR EACH ROW
DECLARE
    proveedor_ciudad VARCHAR2(100);
    provincia_hotel VARCHAR2(100);
BEGIN
    SELECT ciudad INTO proveedor_ciudad FROM PROVEEDOR1 WHERE proveedor_id = :NEW.proveedor_id;
    SELECT provincia INTO provincia_hotel FROM HOTEL1 WHERE hotel_id = :NEW.hotel_id;

    IF proveedor_ciudad = 'Granada' AND provincia_hotel NOT IN ('Granada', 'Jaén', 'Málaga', 'Almería') THEN
        RAISE_APPLICATION_ERROR(-20005, 'Los proveedores de Granada solo pueden suministrar a ciertos hoteles.');
    ELSIF proveedor_ciudad = 'Jaén' AND provincia_hotel NOT IN ('Granada', 'Jaén', 'Málaga', 'Almería') THEN
        RAISE_APPLICATION_ERROR(-20006, 'Los proveedores de Jaén solo pueden suministrar a ciertos hoteles.');
    END IF;
END;
/