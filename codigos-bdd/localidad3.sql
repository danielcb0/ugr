SELECT table_name FROM user_tables;

-- Para habilitar la muestra de mensajes por pantalla
--SET SERVEROUTPUT ON


-- Eliminar objetos existentes si ya existen
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE SUMINISTRO3 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE RESERVA3 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE ASIGNACION3 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE HOTEL3 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE EMPLEADO3 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE CLIENTE3 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE PROVEEDOR3 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE ARTICULO3 CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

-- Creación de la tabla EMPLEADO para localidad3
CREATE TABLE EMPLEADO3 (
    empleado_id NUMBER PRIMARY KEY,
    dni VARCHAR2(9) UNIQUE NOT NULL,
    nombre VARCHAR2(100) NOT NULL,
    telefono VARCHAR2(15),
    direccion VARCHAR2(200),
    fecha_inicio DATE NOT NULL,
    salario NUMBER CHECK (salario > 0)
);

-- Creación de la tabla PROVEEDOR para localidad3
CREATE TABLE PROVEEDOR3 (
    proveedor_id NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    ciudad VARCHAR2(100) CHECK (ciudad IN ('Málaga', 'Almería'))
);

-- Creación de la tabla ARTICULO para localidad3
CREATE TABLE ARTICULO3 (
    articulo_id NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    tipo CHAR(1) CHECK (tipo IN ('A', 'B', 'C', 'D')),
    proveedor_id NUMBER NOT NULL,
    CONSTRAINT fk_articulo_proveedor3 FOREIGN KEY (proveedor_id) REFERENCES PROVEEDOR3(proveedor_id)
);

-- Creación de la tabla HOTEL para localidad3
CREATE TABLE HOTEL3 (
    hotel_id NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    capacidad_sencillas NUMBER NOT NULL,
    capacidad_dobles NUMBER NOT NULL,
    ciudad VARCHAR2(100) NOT NULL,
    provincia VARCHAR2(100) NOT NULL,
    director_id NUMBER,
    CONSTRAINT fk_hotel_director3 FOREIGN KEY (director_id) REFERENCES EMPLEADO3(empleado_id)
);

-- Creación de la tabla CLIENTE para localidad3
CREATE TABLE CLIENTE3 (
    cliente_id NUMBER PRIMARY KEY,
    dni VARCHAR2(9) UNIQUE NOT NULL,
    nombre VARCHAR2(100) NOT NULL,
    telefono VARCHAR2(15)
);

-- Creación de la tabla RESERVA para localidad3
CREATE TABLE RESERVA3 (
    reserva_id NUMBER PRIMARY KEY,
    cliente_id NUMBER NOT NULL,
    hotel_id NUMBER NOT NULL,
    fecha_entrada DATE NOT NULL,
    fecha_salida DATE NOT NULL,
    tipo_habitacion VARCHAR2(10) CHECK (tipo_habitacion IN ('sencilla', 'doble')),
    precio_noche NUMBER NOT NULL,
    CONSTRAINT fk_cliente3 FOREIGN KEY (cliente_id) REFERENCES CLIENTE3(cliente_id),
    CONSTRAINT fk_hotel3 FOREIGN KEY (hotel_id) REFERENCES HOTEL3(hotel_id)
);

-- Creación de la tabla ASIGNACION para localidad3
CREATE TABLE ASIGNACION3 (
    asignacion_id NUMBER PRIMARY KEY,
    empleado_id NUMBER NOT NULL,
    hotel_id NUMBER NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    CONSTRAINT fk_asignacion_empleado3 FOREIGN KEY (empleado_id) REFERENCES EMPLEADO3(empleado_id),
    CONSTRAINT fk_asignacion_hotel3 FOREIGN KEY (hotel_id) REFERENCES HOTEL3(hotel_id)
);

-- Creación de la tabla SUMINISTRO para localidad3
CREATE TABLE SUMINISTRO3 (
    suministro_id NUMBER PRIMARY KEY,
    proveedor_id NUMBER NOT NULL,
    hotel_id NUMBER NOT NULL,
    articulo_id NUMBER NOT NULL,
    fecha_suministro DATE NOT NULL,
    cantidad NUMBER NOT NULL CHECK (cantidad > 0),
    precio_unitario NUMBER NOT NULL CHECK (precio_unitario > 0),
    CONSTRAINT fk_suministro_hotel3 FOREIGN KEY (hotel_id) REFERENCES HOTEL3(hotel_id),
    CONSTRAINT fk_suministro_proveedor3 FOREIGN KEY (proveedor_id) REFERENCES PROVEEDOR3(proveedor_id),
    CONSTRAINT fk_suministro_articulo3 FOREIGN KEY (articulo_id) REFERENCES ARTICULO3(articulo_id)
);

-- Inserts de datos para localidad3
-- Eliminar registros duplicados antes de insertar
DELETE FROM EMPLEADO3 WHERE empleado_id IN (5, 6);
DELETE FROM PROVEEDOR3 WHERE proveedor_id IN (5, 6);
DELETE FROM ARTICULO3 WHERE articulo_id IN (7, 8, 9);
DELETE FROM CLIENTE3 WHERE cliente_id IN (5, 6);

-- Empleados
INSERT INTO EMPLEADO3 (empleado_id, dni, nombre, telefono, direccion, fecha_inicio, salario) 
VALUES (5, '55555555E', 'Miguel Torres', '952123456', 'Avda. Mediterráneo, Málaga', TO_DATE('2018-05-01', 'YYYY-MM-DD'), 2600);
INSERT INTO EMPLEADO3 (empleado_id, dni, nombre, telefono, direccion, fecha_inicio, salario) 
VALUES (6, '66666666F', 'Elena Cruz', '950654321', 'Calle Principal, Almería', TO_DATE('2017-06-15', 'YYYY-MM-DD'), 2450);

-- Proveedores
INSERT INTO PROVEEDOR3 (proveedor_id, nombre, ciudad) VALUES (5, 'MalagaPro', 'Málaga');
INSERT INTO PROVEEDOR3 (proveedor_id, nombre, ciudad) VALUES (6, 'AlmeriaDistrib', 'Almería');

-- Artículos
INSERT INTO ARTICULO3 (articulo_id, nombre, tipo, proveedor_id) VALUES (7, 'Huevos', 'A', 5);
INSERT INTO ARTICULO3 (articulo_id, nombre, tipo, proveedor_id) VALUES (8, 'Pan', 'B', 6);
INSERT INTO ARTICULO3 (articulo_id, nombre, tipo, proveedor_id) VALUES (9, 'Aceite', 'C', 5);

-- Hoteles
INSERT INTO HOTEL3 (hotel_id, nombre, capacidad_sencillas, capacidad_dobles, ciudad, provincia, director_id) 
VALUES (5, 'Hotel Costa del Sol', 20, 30, 'Málaga', 'Málaga', 5);
INSERT INTO HOTEL3 (hotel_id, nombre, capacidad_sencillas, capacidad_dobles, ciudad, provincia, director_id) 
VALUES (6, 'Hotel Cabo de Gata', 25, 35, 'Almería', 'Almería', 6);

-- Clientes
INSERT INTO CLIENTE3 (cliente_id, dni, nombre, telefono) 
VALUES (5, '77777777G', 'Alberto López', '601987654');
INSERT INTO CLIENTE3 (cliente_id, dni, nombre, telefono) 
VALUES (6, '88888888H', 'Lucía Márquez', '651654789');

-- Reservas
INSERT INTO RESERVA3 (reserva_id, cliente_id, hotel_id, fecha_entrada, fecha_salida, tipo_habitacion, precio_noche) 
VALUES (5, 5, 5, TO_DATE('2024-07-01', 'YYYY-MM-DD'), TO_DATE('2024-07-05', 'YYYY-MM-DD'), 'sencilla', 110);
INSERT INTO RESERVA3 (reserva_id, cliente_id, hotel_id, fecha_entrada, fecha_salida, tipo_habitacion, precio_noche) 
VALUES (6, 6, 6, TO_DATE('2024-08-01', 'YYYY-MM-DD'), TO_DATE('2024-08-10', 'YYYY-MM-DD'), 'doble', 150);

-- Asignaciones
INSERT INTO ASIGNACION3 (asignacion_id, empleado_id, hotel_id, fecha_inicio, fecha_fin) 
VALUES (5, 5, 5, TO_DATE('2021-03-01', 'YYYY-MM-DD'), NULL);
INSERT INTO ASIGNACION3 (asignacion_id, empleado_id, hotel_id, fecha_inicio, fecha_fin) 
VALUES (6, 6, 6, TO_DATE('2020-07-15', 'YYYY-MM-DD'), NULL);

-- Disparador para evitar SYSDATE en restricción CHECK
CREATE OR REPLACE TRIGGER trg_fecha_inicio_valid3
BEFORE INSERT OR UPDATE ON EMPLEADO3
FOR EACH ROW
BEGIN
    IF :NEW.fecha_inicio > SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20007, 'La fecha de inicio no puede ser futura.');
    END IF;
END;
/

-- Disparador para asegurar que el número de reservas no excede la capacidad del hotel
CREATE OR REPLACE TRIGGER trg_check_capacidad3
BEFORE INSERT OR UPDATE ON RESERVA3
FOR EACH ROW
DECLARE
    total_sencillas NUMBER;
    total_dobles NUMBER;
    capacidad_sencillas NUMBER;
    capacidad_dobles NUMBER;
BEGIN
    SELECT capacidad_sencillas, capacidad_dobles
    INTO capacidad_sencillas, capacidad_dobles
    FROM HOTEL3 WHERE hotel_id = :NEW.hotel_id;

    SELECT COUNT(*) INTO total_sencillas
    FROM RESERVA3
    WHERE hotel_id = :NEW.hotel_id AND tipo_habitacion = 'sencilla';

    SELECT COUNT(*) INTO total_dobles
    FROM RESERVA3
    WHERE hotel_id = :NEW.hotel_id AND tipo_habitacion = 'doble';

    IF :NEW.tipo_habitacion = 'sencilla' AND total_sencillas + 1 > capacidad_sencillas THEN
        RAISE_APPLICATION_ERROR(-20001, 'No se pueden exceder las habitaciones sencillas disponibles.');
    ELSIF :NEW.tipo_habitacion = 'doble' AND total_dobles + 1 > capacidad_dobles THEN
        RAISE_APPLICATION_ERROR(-20002, 'No se pueden exceder las habitaciones dobles disponibles.');
    END IF;
END;
/

-- Disparador para evitar disminución del salario
CREATE OR REPLACE TRIGGER trg_check_salario3
BEFORE UPDATE ON EMPLEADO3
FOR EACH ROW
BEGIN
    IF :NEW.salario < :OLD.salario THEN
        RAISE_APPLICATION_ERROR(-20004, 'El salario de un empleado no puede disminuir.');
    END IF;
END;
/

-- Disparador para validar la relación entre PROVEEDOR3 y ciudad de suministros
CREATE OR REPLACE TRIGGER trg_check_proveedor_ciudad3
BEFORE INSERT OR UPDATE ON SUMINISTRO3
FOR EACH ROW
DECLARE
    proveedor_ciudad VARCHAR2(100);
    provincia_hotel VARCHAR2(100);
BEGIN
    SELECT ciudad INTO proveedor_ciudad FROM PROVEEDOR3 WHERE proveedor_id = :NEW.proveedor_id;
    SELECT provincia INTO provincia_hotel FROM HOTEL3 WHERE hotel_id = :NEW.hotel_id;

    IF proveedor_ciudad = 'Málaga' AND provincia_hotel NOT IN ('Málaga', 'Almería') THEN
        RAISE_APPLICATION_ERROR(-20005, 'Los proveedores de Málaga solo pueden suministrar a ciertos hoteles.');
    ELSIF proveedor_ciudad = 'Almería' AND provincia_hotel NOT IN ('Málaga', 'Almería') THEN
        RAISE_APPLICATION_ERROR(-20006, 'Los proveedores de Almería solo pueden suministrar a ciertos hoteles.');
    END IF;
END;
/
