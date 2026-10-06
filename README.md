# 🦷 Sistema de Gestión para una Clínica Dental (Base de Datos MySQL)

Sistema de base de datos relacional diseñado para administrar las operaciones clave de una clínica dental, abarcando el control de pacientes, odontólogos, consultorios, agenda de citas, tratamientos aplicados, control de pagos y automatización mediante lógica programada (Stored Procedures, Functions y Triggers).

---

## 🚀 Características Principales

* **Estructura Relacional Normalizada:** Tablas interconectadas para mantener la integridad de los datos (`Especialidad`, `Odontólogo`, `Paciente`, `Consultorio`, `Tratamiento`, `Cita`, `Detalle_Cita_Tratamiento`, `Pago`).
* **Lógica de Negocio Automatizada (Triggers):**
  * Validación de horarios para evitar que un consultorio sea reservado en un horario ocupado.
  * Autocompletado del costo base de los tratamientos si no se especifica de manera manual.
  * Restricción para evitar pagos que excedan el saldo pendiente de una cita.
  * Actualización automática del estado de las citas a completadas/liquidadas al cubrir el saldo total.
* **Procedimientos Almacenados:** Funciones encapsuladas para registrar citas, agregar tratamientos, procesar pagos y cancelar citas de forma segura.
* **Funciones Personalizadas:** Cálculo de totales, saldos pendientes, agenda activa por dentista y cálculo dinámico de la edad de los pacientes a partir de su fecha de nacimiento.

---

## 🛠️ Tecnologías y Herramientas
* **MySQL** (Gestor de base de datos relacional)
* **SQL** (DDL, DML, Procedimientos Almacenados, Funciones y Triggers)

---

## 📋 Estructura de la Base de Datos

El script principal crea la base de datos `clinica_dental` con las siguientes entidades principales:
1. **Especialidad:** Ramas médicas (Ortodoncia, Endodoncia, etc.).
2. **Odontólogo:** Profesionales vinculados a una especialidad.
3. **Paciente:** Información demográfica y de contacto.
4. **Consultorio:** Espacios físicos distribuidos por piso.
5. **Tratamiento:** Catálogo de servicios con costos base.
6. **Cita:** Agenda central que relaciona pacientes, odontólogos y consultorios.
7. **Detalle_Cita_Tratamiento:** Relación de los procedimientos realizados por cada cita.
8. **Pago:** Registro de transacciones financieras y métodos de pago.

---

## 💻 Instrucciones de Uso

1. Clona este repositorio o descarga el archivo `.sql`.
2. Abre tu cliente de MySQL preferido (como MySQL Workbench, DBeaver o la terminal).
3. Ejecuta el script completo para crear la base de datos, las tablas, los procedimientos, las funciones y los datos de prueba iniciales:
   ```sql
   source Clinica_odonto.sql;
