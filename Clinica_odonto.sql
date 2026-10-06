
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

