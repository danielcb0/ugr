SELECT table_name FROM user_tables;

-- Para habilitar la muestra de mensajes por pantalla
--SET SERVEROUTPUT ON

-- Eliminar objetos existentes si ya existen
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE SUMINISTRO4 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE RESERVA4 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE ASIGNACION4 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE HOTEL4 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE EMPLEADO4 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE CLIENTE4 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE PROVEEDOR4 CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE ARTICULO4 CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

-- Creación de la tabla EMPLEADO para localidad4
CREATE TABLE EMPLEADO4 (
    empleado_id NUMBER PRIMARY KEY,
    dni VARCHAR2(9) UNIQUE NOT NULL,
    nombre VARCHAR2(100) NOT NULL,
    telefono VARCHAR2(15),
    direccion VARCHAR2(200),
    fecha_inicio DATE NOT NULL,
    salario NUMBER CHECK (salario > 0)
);

-- Creación de la tabla PROVEEDOR para localidad4
CREATE TABLE PROVEEDOR4 (
    proveedor_id NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    ciudad VARCHAR2(100) CHECK (ciudad IN ('Huelva', 'Cádiz'))
);

-- Creación de la tabla ARTICULO para localidad4
CREATE TABLE ARTICULO4 (
    articulo_id NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    tipo CHAR(1) CHECK (tipo IN ('A', 'B', 'C', 'D')),
    proveedor_id NUMBER NOT NULL,
    CONSTRAINT fk_articulo_proveedor4 FOREIGN KEY (proveedor_id) REFERENCES PROVEEDOR4(proveedor_id)
);

-- Creación de la tabla HOTEL para localidad4
CREATE TABLE HOTEL4 (
    hotel_id NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    capacidad_sencillas NUMBER NOT NULL,
    capacidad_dobles NUMBER NOT NULL,
    ciudad VARCHAR2(100) NOT NULL,
    provincia VARCHAR2(100) NOT NULL,
    director_id NUMBER,
    CONSTRAINT fk_hotel_director4 FOREIGN KEY (director_id) REFERENCES EMPLEADO4(empleado_id)
);

-- Creación de la tabla CLIENTE para localidad4
CREATE TABLE CLIENTE4 (
    cliente_id NUMBER PRIMARY KEY,
    dni VARCHAR2(9) UNIQUE NOT NULL,
    nombre VARCHAR2(100) NOT NULL,
    telefono VARCHAR2(15)
);

-- Creación de la tabla RESERVA para localidad4
CREATE TABLE RESERVA4 (
    reserva_id NUMBER PRIMARY KEY,
    cliente_id NUMBER NOT NULL,
    hotel_id NUMBER NOT NULL,
    fecha_entrada DATE NOT NULL,
    fecha_salida DATE NOT NULL,
    tipo_habitacion VARCHAR2(10) CHECK (tipo_habitacion IN ('sencilla', 'doble')),
    precio_noche NUMBER NOT NULL,
    CONSTRAINT fk_cliente4 FOREIGN KEY (cliente_id) REFERENCES CLIENTE4(cliente_id),
    CONSTRAINT fk_hotel4 FOREIGN KEY (hotel_id) REFERENCES HOTEL4(hotel_id)
);

-- Creación de la tabla ASIGNACION para localidad4
CREATE TABLE ASIGNACION4 (
    asignacion_id NUMBER PRIMARY KEY,
    empleado_id NUMBER NOT NULL,
    hotel_id NUMBER NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    CONSTRAINT fk_asignacion_empleado4 FOREIGN KEY (empleado_id) REFERENCES EMPLEADO4(empleado_id),
    CONSTRAINT fk_asignacion_hotel4 FOREIGN KEY (hotel_id) REFERENCES HOTEL4(hotel_id)
);

-- Creación de la tabla SUMINISTRO para localidad4
CREATE TABLE SUMINISTRO4 (
    suministro_id NUMBER PRIMARY KEY,
    proveedor_id NUMBER NOT NULL,
    hotel_id NUMBER NOT NULL,
    articulo_id NUMBER NOT NULL,
    fecha_suministro DATE NOT NULL,
    cantidad NUMBER NOT NULL CHECK (cantidad > 0),
    precio_unitario NUMBER NOT NULL CHECK (precio_unitario > 0),
    CONSTRAINT fk_suministro_hotel4 FOREIGN KEY (hotel_id) REFERENCES HOTEL4(hotel_id),
    CONSTRAINT fk_suministro_proveedor4 FOREIGN KEY (proveedor_id) REFERENCES PROVEEDOR4(proveedor_id),
    CONSTRAINT fk_suministro_articulo4 FOREIGN KEY (articulo_id) REFERENCES ARTICULO4(articulo_id)
);

-- Inserts de datos para localidad4
-- Eliminar registros duplicados antes de insertar
DELETE FROM EMPLEADO4 WHERE empleado_id IN (7, 8);
DELETE FROM PROVEEDOR4 WHERE proveedor_id IN (7, 8);
DELETE FROM ARTICULO4 WHERE articulo_id IN (10, 11, 12);
DELETE FROM CLIENTE4 WHERE cliente_id IN (7, 8);

-- Empleados
INSERT INTO EMPLEADO4 (empleado_id, dni, nombre, telefono, direccion, fecha_inicio, salario) 
VALUES (7, '77777777G', 'Javier Moreno', '959123456', 'Calle Castilla, Huelva', TO_DATE('2019-07-01', 'YYYY-MM-DD'), 2300);
INSERT INTO EMPLEADO4 (empleado_id, dni, nombre, telefono, direccion, fecha_inicio, salario) 
VALUES (8, '88888888H', 'Sofía Ramírez', '956654321', 'Avda. Libertad, Cádiz', TO_DATE('2020-01-15', 'YYYY-MM-DD'), 2500);

-- Proveedores
INSERT INTO PROVEEDOR4 (proveedor_id, nombre, ciudad) VALUES (7, 'HuelvaPro', 'Huelva');
INSERT INTO PROVEEDOR4 (proveedor_id, nombre, ciudad) VALUES (8, 'CadizDistrib', 'Cádiz');

-- Artículos
INSERT INTO ARTICULO4 (articulo_id, nombre, tipo, proveedor_id) VALUES (10, 'Mariscos', 'A', 7);
INSERT INTO ARTICULO4 (articulo_id, nombre, tipo, proveedor_id) VALUES (11, 'Vinos', 'B', 8);
INSERT INTO ARTICULO4 (articulo_id, nombre, tipo, proveedor_id) VALUES (12, 'Quesos', 'C', 7);

-- Hoteles
INSERT INTO HOTEL4 (hotel_id, nombre, capacidad_sencillas, capacidad_dobles, ciudad, provincia, director_id) 
VALUES (7, 'Hotel Atlántico', 10, 15, 'Huelva', 'Huelva', 7);
INSERT INTO HOTEL4 (hotel_id, nombre, capacidad_sencillas, capacidad_dobles, ciudad, provincia, director_id) 
VALUES (8, 'Hotel Bahía', 12, 18, 'Cádiz', 'Cádiz', 8);

-- Clientes
INSERT INTO CLIENTE4 (cliente_id, dni, nombre, telefono) 
VALUES (7, '99999999I', 'Carlos García', '602987654');
INSERT INTO CLIENTE4 (cliente_id, dni, nombre, telefono) 
VALUES (8, '10101010J', 'Marta Fernández', '652654789');

-- Reservas
INSERT INTO RESERVA4 (reserva_id, cliente_id, hotel_id, fecha_entrada, fecha_salida, tipo_habitacion, precio_noche) 
VALUES (7, 7, 7, TO_DATE('2024-07-01', 'YYYY-MM-DD'), TO_DATE('2024-07-05', 'YYYY-MM-DD'), 'sencilla', 120);
INSERT INTO RESERVA4 (reserva_id, cliente_id, hotel_id, fecha_entrada, fecha_salida, tipo_habitacion, precio_noche) 
VALUES (8, 8, 8, TO_DATE('2024-08-01', 'YYYY-MM-DD'), TO_DATE('2024-08-10', 'YYYY-MM-DD'), 'doble', 160);

-- Asignaciones
INSERT INTO ASIGNACION4 (asignacion_id, empleado_id, hotel_id, fecha_inicio, fecha_fin) 
VALUES (7, 7, 7, TO_DATE('2021-03-01', 'YYYY-MM-DD'), NULL);
INSERT INTO ASIGNACION4 (asignacion_id, empleado_id, hotel_id, fecha_inicio, fecha_fin) 
VALUES (8, 8, 8, TO_DATE('2020-07-15', 'YYYY-MM-DD'), NULL);

-- Disparador para evitar SYSDATE en restricción CHECK
CREATE OR REPLACE TRIGGER trg_fecha_inicio_valid4
BEFORE INSERT OR UPDATE ON EMPLEADO4
FOR EACH ROW
BEGIN
    IF :NEW.fecha_inicio > SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20007, 'La fecha de inicio no puede ser futura.');
    END IF;
END;
/

-- Disparador para asegurar que el número de reservas no excede la capacidad del hotel
CREATE OR REPLACE TRIGGER trg_check_capacidad4
BEFORE INSERT OR UPDATE ON RESERVA4
FOR EACH ROW
DECLARE
    total_sencillas NUMBER;
    total_dobles NUMBER;
    capacidad_sencillas NUMBER;
    capacidad_dobles NUMBER;
BEGIN
    SELECT capacidad_sencillas, capacidad_dobles
    INTO capacidad_sencillas, capacidad_dobles
    FROM HOTEL4 WHERE hotel_id = :NEW.hotel_id;

    SELECT COUNT(*) INTO total_sencillas
    FROM RESERVA4
    WHERE hotel_id = :NEW.hotel_id AND tipo_habitacion = 'sencilla';

    SELECT COUNT(*) INTO total_dobles
    FROM RESERVA4
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
BEFORE UPDATE ON EMPLEADO4
FOR EACH ROW
BEGIN
    IF :NEW.salario < :OLD.salario THEN
        RAISE_APPLICATION_ERROR(-20004, 'El salario de un empleado no puede disminuir.');
    END IF;
END;
/

-- Disparador para validar la relación entre PROVEEDOR4 y ciudad de suministros
CREATE OR REPLACE TRIGGER trg_check_proveedor_ciudad4
BEFORE INSERT OR UPDATE ON SUMINISTRO4
FOR EACH ROW
DECLARE
    proveedor_ciudad VARCHAR2(100);
    provincia_hotel VARCHAR2(100);
BEGIN
    SELECT ciudad INTO proveedor_ciudad FROM PROVEEDOR4 WHERE proveedor_id = :NEW.proveedor_id;
    SELECT provincia INTO provincia_hotel FROM HOTEL4 WHERE hotel_id = :NEW.hotel_id;

    IF proveedor_ciudad = 'Huelva' AND provincia_hotel NOT IN ('Huelva', 'Cádiz') THEN
        RAISE_APPLICATION_ERROR(-20005, 'Los proveedores de Huelva solo pueden suministrar a ciertos hoteles.');
    ELSIF proveedor_ciudad = 'Cádiz' AND provincia_hotel NOT IN ('Huelva', 'Cádiz') THEN
        RAISE_APPLICATION_ERROR(-20006, 'Los proveedores de Cádiz solo pueden suministrar a ciertos hoteles.');
    END IF;
END;
/
