
-- Sistema de Gestión para una Clínica Dental

CREATE DATABASE clinica_dental;
USE clinica_dental;

-- Creación de tablas -----------------

-- 1. ESPECIALIDAD
CREATE TABLE Especialidad (
id_especialidad INT NOT NULL PRIMARY KEY,
nombre VARCHAR(50) NOT NULL UNIQUE,
descripcion VARCHAR(255) DEFAULT NULL
);

-- 2. ODONTOLOGO
CREATE TABLE Odontologo (
id_odontologo INT NOT NULL PRIMARY KEY,
id_especialidad INT NOT NULL,
nombre VARCHAR(50) NOT NULL,
telefono VARCHAR(10) NOT NULL UNIQUE,
correo VARCHAR(30) DEFAULT NULL UNIQUE,

CONSTRAINT fk_odontologo_esp FOREIGN KEY (id_especialidad)
	REFERENCES Especialidad (id_especialidad)
	ON UPDATE CASCADE
);

-- 3. PACIENTE
CREATE TABLE Paciente (
id_paciente INT NOT NULL PRIMARY KEY,
nombre VARCHAR(30) NOT NULL,
apellido_paterno VARCHAR(30) NOT NULL,
apellido_materno VARCHAR(30) NOT NULL,
fecha_nacimiento DATE NOT NULL,
telefono VARCHAR(10) NOT NULL,
correo VARCHAR(30) DEFAULT NULL UNIQUE,
colonia VARCHAR(30) DEFAULT NULL,
calle_y_num VARCHAR(30) DEFAULT NULL,
CP INT DEFAULT NULL
);

-- 4. CONSULTORIO
CREATE TABLE Consultorio (
id_consultorio INT NOT NULL PRIMARY KEY,
numero INT NOT NULL UNIQUE,
piso VARCHAR(15) NOT NULL
);

-- 5. TRATAMIENTO
CREATE TABLE Tratamiento (
id_tratamiento INT NOT NULL PRIMARY KEY,
nombre VARCHAR(50) NOT NULL UNIQUE,
descripcion VARCHAR(50) NOT NULL,
costo_base DECIMAL(10, 2) NOT NULL CHECK (costo_base >= 0)
);

-- 6. CITA
CREATE TABLE Cita (
id_cita INT NOT NULL PRIMARY KEY,
fecha DATE NOT NULL,
hora VARCHAR(5) NOT NULL,
motivo VARCHAR(30) NOT NULL,
estado VARCHAR(15) NOT NULL DEFAULT 'Programada' CHECK (estado IN ('Programada', 'Completada', 'Cancelada')),
id_paciente INT NOT NULL,
id_odontologo INT NOT NULL,
id_consultorio INT NOT NULL,
    
CONSTRAINT fk_cita_paciente FOREIGN KEY (id_paciente)
	REFERENCES Paciente (id_paciente)
	ON UPDATE CASCADE,
        
CONSTRAINT fk_cita_odontologo FOREIGN KEY (id_odontologo)
	REFERENCES Odontologo (id_odontologo)
	ON UPDATE CASCADE,
        
CONSTRAINT fk_cita_consultorio FOREIGN KEY (id_consultorio)
	REFERENCES Consultorio (id_consultorio)
	ON UPDATE CASCADE
);


-- 7. DETALLE_CITA_TRATAMIENTO
CREATE TABLE Detalle_Cita_Tratamiento (
id_cita INT NOT NULL,
id_tratamiento INT NOT NULL,
observaciones VARCHAR(50) NOT NULL,
costo_aplicado DECIMAL(10, 2) NOT NULL CHECK (costo_aplicado >= 0),

CONSTRAINT pk_detalle PRIMARY KEY (id_cita, id_tratamiento),

CONSTRAINT fk_detalle_cita FOREIGN KEY (id_cita)
	REFERENCES Cita (id_cita)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
    
CONSTRAINT fk_detalle_trat FOREIGN KEY (id_tratamiento)
	REFERENCES Tratamiento (id_tratamiento)
	ON UPDATE CASCADE
);

-- 8. PAGO
CREATE TABLE Pago (
id_pago INT NOT NULL PRIMARY KEY,
id_cita INT NOT NULL,
fecha_pago DATE NOT NULL,
monto DECIMAL(10, 2) NOT NULL CHECK (monto > 0),
metodo_pago VARCHAR(15) NOT NULL CHECK (metodo_pago IN ('Efectivo', 'Tarjeta', 'Transferencia')),
estado VARCHAR(15) DEFAULT 'Pendiente' CHECK (estado IN ('Pendiente', 'Pagado')),

CONSTRAINT fk_pago_cita FOREIGN KEY (id_cita)
	REFERENCES Cita (id_cita)
	ON UPDATE CASCADE
);


-- Insertar Datos ---- 

-- Insertar en Especialidades
INSERT INTO Especialidad (id_especialidad, nombre, descripcion) VALUES
(1, 'Ortodoncia', 'Corrección de posición dental y maxilar'),
(2, 'Endodoncia', 'Tratamiento de conductos y pulpa dental'),
(3, 'Odontología general', 'Revisiones de rutina y limpieza');

-- Insertar en Consultorios
INSERT INTO Consultorio (id_consultorio, numero, piso) VALUES
(1, 101, '1'),
(2, 102, '1'),
(3, 201, '2');

-- Insertar en Tratamientos (Precios base)
INSERT INTO Tratamiento (id_tratamiento, nombre, descripcion, costo_base) VALUES
(1, 'Limpieza dental', 'Eliminación de sarro y placa', 500.00),
(2, 'Resina', 'Restauración dental con material resina', 850.00),  
(3, 'Extracción', 'Remoción de una pieza dental', 1200.00),
(4, 'Endodoncia', 'Tratamiento de conducto', 2500.00),
(5, 'Ortodoncia evaluación', 'Revisión y diagnóstico de ortodoncia', 700.00);

-- Insertar en Odontólogos 
INSERT INTO Odontologo (id_odontologo, id_especialidad, nombre, telefono, correo) VALUES 
(1, 1, 'Dra. Laura Sánchez', '2221112233', 'laura.sanchez@clinica.com'),
(2, 2, 'Dr. Miguel Torres', '2221113344', 'miguel.torres@clinica.com'),
(3, 3, 'Dra. Fernanda Gómez', '2221114455', 'fernanda.gomez@clinica.com');

-- Insertar en Pacientes
INSERT INTO Paciente (id_paciente, nombre, apellido_paterno, apellido_materno, fecha_nacimiento, telefono, correo, colonia, calle_y_num, CP) VALUES
(1, 'Ana', 'López', 'García', '2002-03-14', '2223456789', 'ana.lopez@correo.com', 'Centro', 'Calle 1 Sur 102', 72000),
(2, 'Carlos', 'Martínez', 'Ruiz', '2001-08-22', '2224567890', 'carlos.m@correo.com', 'La Paz', 'Av. Reforma 400', 72160),
(3, 'Diana', 'Hernández', 'Soto', '2003-01-10', '2225678901', 'diana.h@correo.com', 'Zavaleta', 'Camino Real 55', 72150),
(4, 'José', 'Ramírez', 'Torres', '2000-11-05', '2226789012', 'jose.ramirez@correo.com', 'Centro', 'Av. Hidalgo 10', 74200),
(5, 'Mariana', 'Pérez', 'Castillo', '2002-06-30', '2227890123', 'mariana.p@correo.com', 'San Juan', 'Calle 5 Norte 22', 72760);

-- Insertar en Citas 
INSERT INTO Cita (id_cita, fecha, hora, motivo, estado, id_paciente, id_odontologo, id_consultorio) VALUES 
(1, '2026-04-02', '09:00', 'Dolor molar', 'Completada', 1, 2, 1),
(2, '2026-04-02', '10:00', 'Limpieza general', 'Completada', 2, 3, 2),
(3, '2026-04-03', '11:30', 'Revisión de brackets', 'Completada', 3, 1, 3),
(4, '2026-04-05', '10:30', 'Valoración general', 'Programada', 1, 3, 3);

-- Insertar en Detalles de Cita 
INSERT INTO Detalle_Cita_Tratamiento (id_cita, id_tratamiento, observaciones, costo_aplicado) VALUES
(1, 4, 'Se realizó tratamiento de conducto', 2500.00),
(2, 1, 'Limpieza completa sin complicaciones', 500.00),
(3, 5, 'Evaluación y ajuste inicial', 700.00),
(4, 1, 'Limpieza sugerida en valoración', 500.00);

-- Insertar en Pagos 
INSERT INTO Pago (id_pago, id_cita, fecha_pago, monto, metodo_pago, estado) VALUES 
(1, 1, '2026-04-02', 2500.00, 'Tarjeta', 'Pagado'),
(2, 2, '2026-04-02', 500.00, 'Efectivo', 'Pagado'),
(3, 3, '2026-04-03', 700.00, 'Tarjeta', 'Pagado'),
(4, 4, '2026-04-05', 500.00, 'Transferencia', 'Pendiente');

-- Consultas 

-- 1. Número de consultorios por piso
SELECT piso, COUNT(*) AS total_consultorios
FROM Consultorio 
GROUP BY piso
ORDER BY piso; 
	
-- 2. Costo más alto de tratamiento 
SELECT MAX(costo_base) AS costo_max FROM Tratamiento; 

-- 3. Costo más bajo de tratamiento 
SELECT MIN(costo_base) AS costo_min FROM Tratamiento; 

-- 4. Número de citas por paciente por ID
SELECT id_paciente, COUNT(*) AS total_citas
FROM Cita
GROUP BY id_paciente
ORDER BY total_citas; 

-- 5. Número de citas por odontólogo 
SELECT id_odontologo, COUNT(*) AS total_citas
FROM Cita
GROUP BY id_odontologo
ORDER BY total_citas; 
---------- PROCEDIMEINTOS ALMACENADOS ---------------------
-- 1. Registrar una nueva cita
DELIMITER $$
CREATE PROCEDURE registrar_cita(
    IN p_id_cita INT,
    IN p_fecha DATE,
    IN p_hora VARCHAR(5),
    IN p_motivo VARCHAR(30),
    IN p_id_paciente INT,
    IN p_id_odontologo INT,
    IN p_id_consultorio INT
)
BEGIN
    INSERT INTO Cita (id_cita, fecha, hora, motivo, estado, id_paciente, id_odontologo, id_consultorio)
    VALUES (p_id_cita, p_fecha, p_hora, p_motivo, 'Programada', p_id_paciente, p_id_odontologo, p_id_consultorio);
END $$
-- 2. Registrar pago de una cita
DELIMITER $$

CREATE PROCEDURE registrar_pago(
    IN p_id_pago INT,
    IN p_id_cita INT,
    IN p_fecha_pago DATE,
    IN p_monto DECIMAL(10,2),
    IN p_metodo_pago VARCHAR(15)
)
BEGIN
    INSERT INTO Pago (id_pago, id_cita, fecha_pago, monto, metodo_pago, estado)
    VALUES (p_id_pago, p_id_cita, p_fecha_pago, p_monto, p_metodo_pago, 'Pagado');
END $$
-- 3. cancelar una cita
DELIMITER $$
CREATE PROCEDURE cancelar_cita(IN p_id_cita INT)
BEGIN
    UPDATE Cita SET estado = 'Cancelada' WHERE id_cita = p_id_cita;
END $$
-- 4. agregar tratamiento a una cita
DELIMITER $$
CREATE PROCEDURE agregar_tratamiento(
    IN p_id_cita INT,
    IN p_id_tratamiento INT,
    IN p_observaciones VARCHAR(50),
    IN p_costo_aplicado DECIMAL(10,2)
)
BEGIN
    INSERT INTO Detalle_Cita_Tratamiento (id_cita, id_tratamiento, observaciones, costo_aplicado)
    VALUES (p_id_cita, p_id_tratamiento, p_observaciones, p_costo_aplicado);
END $$
----------- FUNCIONES ------------------------------
--1. Calcular total de una cita
DELIMITER $$ 
CREATE FUNCTION total_cita(p_id_cita INT) RETURNS DECIMAL(10,2) READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(10,2);
    SELECT IFNULL(SUM(costo_aplicado), 0) INTO v_total
    FROM Detalle_Cita_Tratamiento WHERE id_cita = p_id_cita;
    RETURN v_total;
END $$
	
--2. Calcular saldo pendiente de una cita
DELIMITER $$
CREATE FUNCTION saldo_pendiente(p_id_cita INT) RETURNS DECIMAL(10,2) READS SQL DATA
BEGIN
    DECLARE v_total  DECIMAL(10,2);
    DECLARE v_pagado DECIMAL(10,2);
    SET v_total = total_cita(p_id_cita);
    SELECT IFNULL(SUM(monto), 0) INTO v_pagado FROM Pago WHERE id_cita = p_id_cita AND estado = 'Pagado';
    RETURN v_total - v_pagado;
END $$
	
--3. Contar citas activas de un dentista en una fecha 
DELIMITER $$
CREATE FUNCTION citas_activas_dentista(p_id_odontologo INT, p_fecha DATE) RETURNS INT READS SQL DATA
BEGIN
    DECLARE v_count INT;
    SELECT COUNT(*) INTO v_count FROM Cita
    WHERE id_odontologo = p_id_odontologo AND fecha = p_fecha AND estado = 'Programada';
    RETURN v_count;
END $$
	
--4. Obtener la edad de un paciente 
DELIMITER $$
CREATE FUNCTION edad_paciente(p_id_paciente INT) RETURNS INT READS SQL DATA
BEGIN
    DECLARE v_fecha_nac DATE;
    DECLARE v_edad INT;
    SELECT fecha_nacimiento INTO v_fecha_nac FROM Paciente WHERE id_paciente = p_id_paciente;
    SET v_edad = TIMESTAMPDIFF(YEAR, v_fecha_nac, CURDATE());
    RETURN v_edad;
END $$
	
--5. Evitar pagos mayores al adeudo 
DELIMITER $$
CREATE TRIGGER evitar_pago_excesivo BEFORE INSERT ON Pago FOR EACH ROW
BEGIN
    DECLARE v_saldo DECIMAL(10,2);
    SET v_saldo = saldo_pendiente(NEW.id_cita);
    IF NEW.monto > v_saldo THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El monto del pago excede el saldo pendiente de la cita.';
    END IF;
END $$

--6. Actualizar automáticamente el subtotal de un tratamiento aplicado 
DELIMITER $$
CREATE TRIGGER actualizar_costo_aplicado BEFORE INSERT ON Detalle_Cita_Tratamiento FOR EACH ROW
BEGIN
    DECLARE v_costo DECIMAL(10,2);
    IF NEW.costo_aplicado = 0 OR NEW.costo_aplicado IS NULL THEN
        SELECT costo_base INTO v_costo FROM Tratamiento WHERE id_tratamiento = NEW.id_tratamiento;
        SET NEW.costo_aplicado = v_costo;
    END IF;
END $$

--7. Validar horario correcto de una cita 
DELIMITER $$
CREATE TRIGGER validar_horario_cita BEFORE INSERT ON Cita FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM Cita WHERE id_consultorio = NEW.id_consultorio 
               AND fecha = NEW.fecha AND hora = NEW.hora AND estado != 'Cancelada') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El consultorio ya está ocupado en ese horario';
    END IF;
END $$

--8. Cambiar el estado de la cita a “liquidada(Completada)”
DELIMITER $$
CREATE TRIGGER cambiar_estado_completada AFTER INSERT ON Pago FOR EACH ROW
BEGIN
    IF saldo_pendiente(NEW.id_cita) <= 0 THEN
        UPDATE Cita SET estado = 'Completada' WHERE id_cita = NEW.id_cita;
    END IF;
END $$

-- PRUEBAS DE TRIGGERS, PROCEDIMIENTOS Y FUNCIONES
-- PRUEBAS EN PROCEDIMIENTOS
-- 1. Registramos una nueva cita
CALL registrar_cita(10, '2026-05-10', '10:00', 'Revisión y limpieza', 1, 1, 1);

-- 2. Le agregamos un tratamiento 
CALL agregar_tratamiento(10, 1, 'Limpieza completa', 500.00); -- Agregamos otro tratamiento a la cita creada 

SELECT * FROM Cita WHERE id_cita = 10; -- Vemos información de la nueva cita 
SELECT * FROM Detalle_Cita_Tratamiento WHERE id_cita = 10; -- Vemos información de nuevo tratamiento 

-- 3. Procedimiento para cancelar cita 
CALL cancelar_cita(10); -- Cancelamos cita 
SELECT id_cita, estado FROM Cita WHERE id_cita = 10; -- Observamos cambios 

-- PRUEBAS EN FUNCIONES
-- 1. Ver el total y saldo de la cita 
SELECT 
    id_cita, 
    total_cita(10) AS Total_A_Pagar, -- Total de la cita 
    saldo_pendiente(10) AS Saldo_Deudor 
FROM Cita 
WHERE id_cita = 10;

-- 2. 	Función de edad calculada
SELECT 
    nombre, 
    apellido_paterno, 
    fecha_nacimiento, 
    edad_paciente(id_paciente) AS Edad_Actual 
FROM Paciente;

-- 3. Función de cantidad de citas que tiene un odontólogo?
SELECT citas_activas_dentista(1, '2026-05-10') AS agenda_del_dia;

-- PRUEBAS EN TRIGGERS

-- 1. Trigger validación de horario 
CALL registrar_cita(11, '2026-05-10', '10:00', 'Consulta duplicada', 2, 2, 1); -- Se intenta agendar una cita en un horario ocupado

-- 2. Trigger de actualizar costo aplicado 
CALL agregar_tratamiento(10, 2, 'Aplicación de resina', 0); -- Sin saber cuanto cuesta el tratamiento, la base le asigna costo

SELECT * FROM Detalle_Cita_Tratamiento WHERE id_cita = 10;

-- 3. Trigger para evitar pago excesivo 
CALL registrar_pago(500, 10, '2026-05-10', 2000.00, 'Tarjeta'); -- Se intenta pagar más de lo que se debe 

-- 4. Trigger para cambiar el estado a una cita liquidada 
CALL registrar_pago(501, 10, '2026-05-10', 1350.00, 'Tarjeta'); -- Se paga por completo 

SELECT id_cita, estado FROM Cita WHERE id_cita = 10; -- Se verifica el estado de la cita 



