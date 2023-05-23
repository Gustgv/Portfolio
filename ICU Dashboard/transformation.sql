-- TRANSFORMACION DE DATOS

-- Tabla patients
ALTER TABLE patients DROP COLUMN row_id; -- Eliminamos la columna row_id
ALTER TABLE patients DROP COLUMN dod_ssn; -- Eliminamos la columna row_id
ALTER TABLE patients CHANGE subject_id patient_id INT; -- Cambio de nombre de la columna subject_id a patient_id
ALTER TABLE patients CHANGE expire_flag deceased INT; -- Cambio de nombre de la columna expire_flag a deceased
ALTER TABLE patients CHANGE dob date_birth DATETIME; -- Cambio de nombre de la columna dob a date_birth
ALTER TABLE patients CHANGE dod date_decease DATETIME; -- Cambio de nombre de la columna dod a date_decease
ALTER TABLE patients ADD COLUMN deceased_hosp INT; -- Agregamos columna que nos servira para identificar a los pacientes fallecidos en el hospital.
UPDATE patients SET deceased_hosp = 1 WHERE dod_hosp = '0000-00-00 00:00:00'; -- Ingresamos 1 para los pacientes que fallecieron en el hospital 
UPDATE patients SET deceased_hosp = 0 WHERE deceased_hosp IS NULL; -- Ingresamos 1 para los pacientes que fallecieron fuera del hospital
ALTER TABLE patients DROP COLUMN dod_hosp; -- Eliminamos la columna dod_hosp ya que no tiene utilidad para el trabajo

-- Tabla icustay
ALTER TABLE icustays DROP COLUMN row_id; -- Eliminamos la columna row_id
ALTER TABLE icustays DROP COLUMN dbsource; -- Eliminamos la columna dbsource
ALTER TABLE icustays DROP COLUMN first_careunit; -- Eliminamos la columna dbsource
ALTER TABLE icustays DROP COLUMN first_wardid; -- Eliminamos la columna dbsource
ALTER TABLE icustays DROP COLUMN last_wardid; -- Eliminamos la columna dbsource
ALTER TABLE icustays CHANGE subject_id patient_id INT; -- Cambio de nombre de la columna subject_id a patient_id
ALTER TABLE icustays CHANGE icustay_id icu_id INT; -- Cambio de nombre de la columna icustay_id a icu_id
ALTER TABLE icustays CHANGE icu_id icu_id INT NOT NULL FIRST; -- Cambio de nombre de la columna icustay_id a icu_id
ALTER TABLE icustays CHANGE last_careunit careunit VARCHAR(55); -- Cambio de nombre de la columna icustay_id a icu_id
ALTER TABLE icustays ADD COLUMN date DATE;
UPDATE icustays SET date = DATE(outtime);

-- Tabla callout

ALTER TABLE callout CHANGE row_id call_id INT NOT NULL;
ALTER TABLE callout CHANGE subject_id patient_id INT; -- Cambio de nombre de la columna subject_id a patient_id
ALTER TABLE callout CHANGE curr_careunit careunit VARCHAR(55); -- Cambio de nombre de la columna subject_id a patient_id
ALTER TABLE callout DROP COLUMN sudmit_wardid;
ALTER TABLE callout DROP COLUMN curr_wardid;
ALTER TABLE callout DROP COLUMN callout_wardid;
ALTER TABLE callout DROP COLUMN request_tele;
ALTER TABLE callout DROP COLUMN request_resp;
ALTER TABLE callout DROP COLUMN request_cdiff;
ALTER TABLE callout DROP COLUMN request_mrsa;
ALTER TABLE callout DROP COLUMN request_vre;
ALTER TABLE callout DROP COLUMN callout_status;
ALTER TABLE callout DROP COLUMN callout_outcome;
ALTER TABLE callout DROP COLUMN discharge_wardid;
ALTER TABLE callout DROP COLUMN acknowledge_status;
ALTER TABLE callout DROP COLUMN firstreservationtime;
ALTER TABLE callout DROP COLUMN currentreservationtime;
ALTER TABLE callout DROP COLUMN currentreservationtime;
ALTER TABLE callout DROP COLUMN submit_wardid;
ALTER TABLE callout DROP COLUMN submit_careunit;
ALTER TABLE callout DROP COLUMN callout_service;
ALTER TABLE callout ADD COLUMN los DECIMAL(9, 2);
UPDATE callout SET los = TIMESTAMPDIFF(hour, createtime, outcometime);
ALTER TABLE callout ADD COLUMN date DATE;
UPDATE callout SET date = DATE(outcometime);

-- Tabla admissions

ALTER TABLE admissions CHANGE subject_id patient_id INT;
ALTER TABLE admissions CHANGE  hadm_id hadm_id INT FIRST;

-- A partir de la tabla de admisiones creare una tabla categorica de seguros
CREATE TABLE insurance(
insurance_id INT AUTO_INCREMENT,
insurance VARCHAR(55),
PRIMARY KEY (insurance_id));

INSERT INTO insurance (insurance)
SELECT DISTINCT(insurance)
FROM admissions
ORDER BY 1;

ALTER TABLE admissions ADD COLUMN insurance_id INT AFTER insurance; 

UPDATE admissions a
INNER JOIN insurance i ON a.insurance = i.insurance
SET a.insurance_id = i.insurance_id;

ALTER TABLE admissions DROP COLUMN insurance;

-- Ahora agrego la columna de aseguradoras en icustay

ALTER TABLE icustays ADD COLUMN insurance_id INT AFTER hadm_id; 

UPDATE icustays i
INNER JOIN admissions a ON a.patient_id = i.patient_id
SET i.insurance_id = a.insurance_id;

-- Con la tabla de icustays creo la tabla de unidad de ciudados intensivos
SELECT * FROM proyecto.icustays;

CREATE TABLE careunit(
	careunit_id INT AUTO_INCREMENT,
    careunit VARCHAR(55),
    PRIMARY KEY (careunit_id));

INSERT INTO careunit (careunit)
SELECT DISTINCT(careunit)
FROM icustays
ORDER BY 1;

ALTER TABLE icustays ADD COLUMN careunit_id INT AFTER careunit;

UPDATE icustays a
INNER JOIN careunit i ON a.careunit = i.careunit
SET a.careunit_id = i.careunit_id; 

ALTER TABLE icustays DROP COLUMN careunit;

-- Agrego las columnas de careunit a callout

ALTER TABLE callout ADD COLUMN careunit_id INT AFTER careunit;

UPDATE callout a
INNER JOIN careunit i ON a.careunit = i.careunit
SET a.careunit_id = i.careunit_id; 

ALTER TABLE callout DROP COLUMN careunit;
