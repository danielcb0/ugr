SELECT table_name FROM user_tables;

-- Para habilitar la muestra de mensajes por pantalla
--SET SERVEROUTPUT ON





-- Eliminar objetos existentes si ya existen
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE SUMINISTRO2 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE RESERVA2 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE ASIGNACION2 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE HOTEL2 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE EMPLEADO2 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE CLIENTE2 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE PROVEEDOR2 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE ARTICULO2 CASCADE CONSTRAINTS';
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

-- Inserts de datos para localidad2
-- Eliminar registros duplicados antes de insertar
DELETE FROM EMPLEADO2 WHERE empleado_id IN (3, 4);
DELETE FROM PROVEEDOR2 WHERE proveedor_id IN (3, 4);
DELETE FROM ARTICULO2 WHERE articulo_id IN (4, 5, 6);
DELETE FROM CLIENTE2 WHERE cliente_id IN (3, 4);

-- Empleados
INSERT INTO EMPLEADO2 (empleado_id, dni, nombre, telefono, direccion, fecha_inicio, salario) 
VALUES (3, '33333333C', 'Luis Martínez', '954123456', 'Avda. Constitución, Sevilla', TO_DATE('2018-03-01', 'YYYY-MM-DD'), 2500);
INSERT INTO EMPLEADO2 (empleado_id, dni, nombre, telefono, direccion, fecha_inicio, salario) 
VALUES (4, '44444444D', 'Carmen Ortiz', '957654321', 'Calle Mayor, Córdoba', TO_DATE('2017-04-15', 'YYYY-MM-DD'), 2400);

-- Proveedores
INSERT INTO PROVEEDOR2 (proveedor_id, nombre, ciudad) VALUES (3, 'SevillaPro', 'Sevilla');
INSERT INTO PROVEEDOR2 (proveedor_id, nombre, ciudad) VALUES (4, 'CordobaDistrib', 'Córdoba');

-- Artículos
INSERT INTO ARTICULO2 (articulo_id, nombre, tipo, proveedor_id) VALUES (4, 'Carne', 'A', 3);
INSERT INTO ARTICULO2 (articulo_id, nombre, tipo, proveedor_id) VALUES (5, 'Pescado', 'B', 4);
INSERT INTO ARTICULO2 (articulo_id, nombre, tipo, proveedor_id) VALUES (6, 'Lácteos', 'C', 3);

-- Hoteles
INSERT INTO HOTEL2 (hotel_id, nombre, capacidad_sencillas, capacidad_dobles, ciudad, provincia, director_id) 
VALUES (3, 'Hotel Guadalquivir', 12, 20, 'Sevilla', 'Sevilla', 3);
INSERT INTO HOTEL2 (hotel_id, nombre, capacidad_sencillas, capacidad_dobles, ciudad, provincia, director_id) 
VALUES (4, 'Hotel Mezquita', 15, 25, 'Córdoba', 'Córdoba', 4);

-- Clientes
INSERT INTO CLIENTE2 (cliente_id, dni, nombre, telefono) 
VALUES (3, '55555555E', 'Manuel García', '600987654');
INSERT INTO CLIENTE2 (cliente_id, dni, nombre, telefono) 
VALUES (4, '66666666F', 'Laura Fernández', '650654789');

-- Reservas
INSERT INTO RESERVA2 (reserva_id, cliente_id, hotel_id, fecha_entrada, fecha_salida, tipo_habitacion, precio_noche) 
VALUES (3, 3, 3, TO_DATE('2024-07-01', 'YYYY-MM-DD'), TO_DATE('2024-07-05', 'YYYY-MM-DD'), 'sencilla', 100);
INSERT INTO RESERVA2 (reserva_id, cliente_id, hotel_id, fecha_entrada, fecha_salida, tipo_habitacion, precio_noche) 
VALUES (4, 4, 4, TO_DATE('2024-08-01', 'YYYY-MM-DD'), TO_DATE('2024-08-10', 'YYYY-MM-DD'), 'doble', 140);

-- Asignaciones
INSERT INTO ASIGNACION2 (asignacion_id, empleado_id, hotel_id, fecha_inicio, fecha_fin) 
VALUES (3, 3, 3, TO_DATE('2021-03-01', 'YYYY-MM-DD'), NULL);
INSERT INTO ASIGNACION2 (asignacion_id, empleado_id, hotel_id, fecha_inicio, fecha_fin) 
VALUES (4, 4, 4, TO_DATE('2020-07-15', 'YYYY-MM-DD'), NULL);

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
