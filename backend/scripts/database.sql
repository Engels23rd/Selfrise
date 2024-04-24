create database Proyecto;
use Proyecto;

DROP TABLE IF EXISTS usuario;

CREATE TABLE usuario(
	id int auto_increment PRIMARY KEY,
	nombre varchar(50),
	apellido varchar(50),
	correo varchar(100),
	clave VARCHAR(255),
	imagen blob,
	fecha_nacimiento Date,
	localidad varchar(255),
	esPremium boolean,
	updated_at timestamp NOT NULL DEFAULT now() ON
	UPDATE
		now()
);

DROP TABLE IF EXISTS emociones;
CREATE TABLE emociones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    estado_emocional ENUM('Feliz', 'Triste', 'Enojado', 'Ansioso', 'Calmado') NOT NULL,
    fecha TIMESTAMP,
    updated_at timestamp NOT NULL DEFAULT now() ON
	UPDATE
		now(),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id)
);

DROP TABLE IF EXISTS chat;
CREATE TABLE chat (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    contenido TEXT,
    fecha TIMESTAMP,
    updated_at timestamp NOT NULL DEFAULT now() ON
	UPDATE
		now(),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id)
);

DROP TABLE IF EXISTS habitos;
create table habitos(
	id int auto_increment primary key,
	id_usuario int,
	nombre_habito varchar(200),
	frecuencia enum('Diario', 'Semanal', 'Mensual', 'Quincenal'),
	updated_at timestamp NOT NULL DEFAULT now() ON
	UPDATE
		now(),
	 FOREIGN KEY (id_usuario) REFERENCES usuario(id)
);

create table medalla(
	id int auto_increment primary key,
	id_usuario int,
	nombre varchar(50),
	descripcion text,
	imagen blob,
	updated_at timestamp NOT NULL DEFAULT now() ON
	UPDATE
		now(),
	FOREIGN KEY (id_usuario) REFERENCES usuario(id)
);

DELIMITER $$
CREATE OR REPLACE FUNCTION  autenticar_usuario(correo_ VARCHAR(100), clave_ VARCHAR(255))
	RETURNS BOOLEAN
	READS SQL DATA
BEGIN
    RETURN EXISTS (
    	SELECT *
        FROM usuario
        WHERE correo = correo_ AND clave = clave_
   );
END;
$$

-- Poblar tabla de usuario
INSERT INTO usuario (nombre, apellido, correo, clave, imagen, fecha_nacimiento, localidad, esPremium) VALUES ('John', 'Doe', 'john.doe@example.com', 'clave123', NULL, '1990-05-15', 'New York', 1);
INSERT INTO usuario (nombre, apellido, correo, clave, imagen, fecha_nacimiento, localidad, esPremium) VALUES ('Alice', 'Smith', 'alice.smith@example.com', 'password456', NULL, '1985-10-20', 'Los Angeles', 0);
INSERT INTO usuario (nombre, apellido, correo, clave, imagen, fecha_nacimiento, localidad, esPremium) VALUES ('Michael', 'Johnson', 'michael.johnson@example.com', 'secure789', NULL, '1992-03-12', 'Chicago', 1);
INSERT INTO usuario (nombre, apellido, correo, clave, imagen, fecha_nacimiento, localidad, esPremium) VALUES ('Emily', 'Brown', 'emily.brown@example.com', 'topsecret321', NULL, '1988-07-04', 'Houston', 0);
INSERT INTO usuario (nombre, apellido, correo, clave, imagen, fecha_nacimiento, localidad, esPremium) VALUES ('David', 'Williams', 'david.williams@example.com', 'pass1234', NULL, '1995-01-30', 'Phoenix', 1);
INSERT INTO usuario (nombre, apellido, correo, clave, imagen, fecha_nacimiento, localidad, esPremium) VALUES ('Sophia', 'Jones', 'sophia.jones@example.com', 'qwerty', NULL, '1983-11-25', 'Philadelphia', 0);
INSERT INTO usuario (nombre, apellido, correo, clave, imagen, fecha_nacimiento, localidad, esPremium) VALUES ('James', 'Davis', 'james.davis@example.com', 'password', NULL, '1979-09-18', 'San Antonio', 1);
INSERT INTO usuario (nombre, apellido, correo, clave, imagen, fecha_nacimiento, localidad, esPremium) VALUES ('Emma', 'Miller', 'emma.miller@example.com', 'p@ssw0rd', NULL, '1972-12-07', 'San Diego', 0);
INSERT INTO usuario (nombre, apellido, correo, clave, imagen, fecha_nacimiento, localidad, esPremium) VALUES ('Daniel', 'Wilson', 'daniel.wilson@example.com', 'password123', NULL, '1980-06-23', 'Dallas', 1);
INSERT INTO usuario (nombre, apellido, correo, clave, imagen, fecha_nacimiento, localidad, esPremium) VALUES ('Olivia', 'Taylor', 'olivia.taylor@example.com', 'securepwd', NULL, '1975-04-11', 'San Jose', 0);
INSERT INTO usuario (nombre, apellido, correo, clave, imagen, fecha_nacimiento, localidad, esPremium) VALUES ('Matthew', 'Anderson', 'matthew.anderson@example.com', 'letmein', NULL, '1998-08-03', 'Austin', 1);
INSERT INTO usuario (nombre, apellido, correo, clave, imagen, fecha_nacimiento, localidad, esPremium) VALUES ('Ava', 'Thomas', 'ava.thomas@example.com', 'password1', NULL, '1986-02-28', 'Jacksonville', 0);
INSERT INTO usuario (nombre, apellido, correo, clave, imagen, fecha_nacimiento, localidad, esPremium) VALUES ('Jackson', 'White', 'jackson.white@example.com', 'test123', NULL, '1993-10-09', 'Indianapolis', 1);
INSERT INTO usuario (nombre, apellido, correo, clave, imagen, fecha_nacimiento, localidad, esPremium) VALUES ('Isabella', 'Martin', 'isabella.martin@example.com', 'password1234', NULL, '1989-05-22', 'San Francisco', 0);
INSERT INTO usuario (nombre, apellido, correo, clave, imagen, fecha_nacimiento, localidad, esPremium) VALUES ('Ethan', 'Thompson', 'ethan.thompson@example.com', '123456', NULL, '1984-07-15', 'Columbus', 1);

-- Poblar tabla de emociones
INSERT INTO emociones (id_usuario, estado_emocional, fecha) VALUES (1, 'Feliz', '2024-02-07 10:00:00');
INSERT INTO emociones (id_usuario, estado_emocional, fecha) VALUES (2, 'Triste', '2024-02-07 11:30:00');
INSERT INTO emociones (id_usuario, estado_emocional, fecha) VALUES (3, 'Enojado', '2024-02-07 12:45:00');
INSERT INTO emociones (id_usuario, estado_emocional, fecha) VALUES (4, 'Ansioso', '2024-02-07 13:15:00');
INSERT INTO emociones (id_usuario, estado_emocional, fecha) VALUES (5, 'Calmado', '2024-02-07 14:20:00');
INSERT INTO emociones (id_usuario, estado_emocional, fecha) VALUES (6, 'Feliz', '2024-02-07 15:10:00');
INSERT INTO emociones (id_usuario, estado_emocional, fecha) VALUES (7, 'Triste', '2024-02-07 16:05:00');
INSERT INTO emociones (id_usuario, estado_emocional, fecha) VALUES (8, 'Enojado', '2024-02-07 17:30:00');
INSERT INTO emociones (id_usuario, estado_emocional, fecha) VALUES (9, 'Ansioso', '2024-02-07 18:40:00');
INSERT INTO emociones (id_usuario, estado_emocional, fecha) VALUES (10, 'Calmado', '2024-02-07 19:55:00');
INSERT INTO emociones (id_usuario, estado_emocional, fecha) VALUES (11, 'Feliz', '2024-02-07 20:20:00');
INSERT INTO emociones (id_usuario, estado_emocional, fecha) VALUES (12, 'Triste', '2024-02-07 21:10:00');
INSERT INTO emociones (id_usuario, estado_emocional, fecha) VALUES (13, 'Enojado', '2024-02-07 22:25:00');
INSERT INTO emociones (id_usuario, estado_emocional, fecha) VALUES (14, 'Ansioso', '2024-02-07 23:45:00');
INSERT INTO emociones (id_usuario, estado_emocional, fecha) VALUES (15, 'Calmado', '2024-02-08 00:30:00');

-- Poblar tabla de chat
INSERT INTO chat (id_usuario, contenido, fecha) VALUES (1, '¡Hola a todos!', '2024-02-07 10:00:00');
INSERT INTO chat (id_usuario, contenido, fecha) VALUES (2, 'Buenos días, ¿cómo están?', '2024-02-07 11:30:00');
INSERT INTO chat (id_usuario, contenido, fecha) VALUES (3, 'Estoy un poco frustrado hoy.', '2024-02-07 12:45:00');
INSERT INTO chat (id_usuario, contenido, fecha) VALUES (4, '¿Alguien quiere ir al cine esta noche?', '2024-02-07 13:15:00');
INSERT INTO chat (id_usuario, contenido, fecha) VALUES (5, '¡Qué día tan tranquilo!', '2024-02-07 14:20:00');
INSERT INTO chat (id_usuario, contenido, fecha) VALUES (6, '¡Feliz cumpleaños a todos los que cumplen hoy!', '2024-02-07 15:10:00');
INSERT INTO chat (id_usuario, contenido, fecha) VALUES (7, 'Necesito recomendaciones de libros, ¿alguien tiene alguna?', '2024-02-07 16:05:00');
INSERT INTO chat (id_usuario, contenido, fecha) VALUES (8, '¡Vamos equipo, podemos hacerlo!', '2024-02-07 17:30:00');
INSERT INTO chat (id_usuario, contenido, fecha) VALUES (9, '¿Qué piensan de la nueva película?', '2024-02-07 18:40:00');
INSERT INTO chat (id_usuario, contenido, fecha) VALUES (10, 'Hoy me siento muy agradecido por todo lo que tengo.', '2024-02-07 19:55:00');
INSERT INTO chat (id_usuario, contenido, fecha) VALUES (11, '¡Acabo de terminar de leer un libro increíble!', '2024-02-07 20:20:00');
INSERT INTO chat (id_usuario, contenido, fecha) VALUES (12, '¿Alguien más está emocionado por el concierto de mañana?', '2024-02-07 21:10:00');
INSERT INTO chat (id_usuario, contenido, fecha) VALUES (13, '¿Qué opinan sobre el último episodio de la serie?', '2024-02-07 22:25:00');
INSERT INTO chat (id_usuario, contenido, fecha) VALUES (14, '¡Feliz fin de semana a todos!', '2024-02-07 23:45:00');
INSERT INTO chat (id_usuario, contenido, fecha) VALUES (15, 'Hoy fue un día agotador, pero estoy contento de estar aquí.', '2024-02-08 00:30:00');

-- Poblar tabla de habitos
INSERT INTO habitos (id_usuario, nombre_habito, frecuencia) VALUES (1, 'Hacer ejercicio', 'Diario');
INSERT INTO habitos (id_usuario, nombre_habito, frecuencia) VALUES (2, 'Leer un libro', 'Semanal');
INSERT INTO habitos (id_usuario, nombre_habito, frecuencia) VALUES (3, 'Meditar', 'Diario');
INSERT INTO habitos (id_usuario, nombre_habito, frecuencia) VALUES (4, 'Cocinar una nueva receta', 'Semanal');
INSERT INTO habitos (id_usuario, nombre_habito, frecuencia) VALUES (5, 'Pasar tiempo al aire libre', 'Semanal');
INSERT INTO habitos (id_usuario, nombre_habito, frecuencia) VALUES (6, 'Practicar un nuevo idioma', 'Mensual');
INSERT INTO habitos (id_usuario, nombre_habito, frecuencia) VALUES (7, 'Hacer una caminata', 'Semanal');
INSERT INTO habitos (id_usuario, nombre_habito, frecuencia) VALUES (8, 'Aprender a tocar un instrumento', 'Mensual');
INSERT INTO habitos (id_usuario, nombre_habito, frecuencia) VALUES (9, 'Hacer voluntariado', 'Quincenal');
INSERT INTO habitos (id_usuario, nombre_habito, frecuencia) VALUES (10, 'Practicar yoga', 'Diario');
INSERT INTO habitos (id_usuario, nombre_habito, frecuencia) VALUES (11, 'Visitar a la familia', 'Semanal');
INSERT INTO habitos (id_usuario, nombre_habito, frecuencia) VALUES (12, 'Tomar agua suficiente', 'Diario');
INSERT INTO habitos (id_usuario, nombre_habito, frecuencia) VALUES (13, 'Hacer un viaje corto', 'Mensual');
INSERT INTO habitos (id_usuario, nombre_habito, frecuencia) VALUES (14, 'Escuchar música relajante', 'Diario');
INSERT INTO habitos (id_usuario, nombre_habito, frecuencia) VALUES (15, 'Hacer una lista de tareas', 'Diario');

-- Poblar tabla de medalla
INSERT INTO medalla (id_usuario, nombre, descripcion, imagen) VALUES (1, 'Medalla de Oro', 'Premio por lograr el primer lugar en la competición.', NULL);
INSERT INTO medalla (id_usuario, nombre, descripcion, imagen) VALUES (2, 'Medalla de Plata', 'Reconocimiento por obtener el segundo lugar en el evento deportivo.', NULL);
INSERT INTO medalla (id_usuario, nombre, descripcion, imagen) VALUES (3, 'Medalla de Bronce', 'Distinción por alcanzar el tercer puesto en el concurso de arte.', NULL);
INSERT INTO medalla (id_usuario, nombre, descripcion, imagen) VALUES (4, 'Medalla de Excelencia', 'Reconocimiento por destacarse en el ámbito académico.', NULL);
INSERT INTO medalla (id_usuario, nombre, descripcion, imagen) VALUES (5, 'Medalla de Honor', 'Premio por servicio destacado a la comunidad.', NULL);
INSERT INTO medalla (id_usuario, nombre, descripcion, imagen) VALUES (6, 'Medalla del Coraje', 'Distinción por mostrar valentía en situaciones difíciles.', NULL);
INSERT INTO medalla (id_usuario, nombre, descripcion, imagen) VALUES (7, 'Medalla de Servicio', 'Reconocimiento por contribuir al bienestar de otros.', NULL);
INSERT INTO medalla (id_usuario, nombre, descripcion, imagen) VALUES (8, 'Medalla de Liderazgo', 'Premio por mostrar habilidades de liderazgo excepcionales.', NULL);
INSERT INTO medalla (id_usuario, nombre, descripcion, imagen) VALUES (9, 'Medalla de Creatividad', 'Reconocimiento por pensamiento innovador y creativo.', NULL);
INSERT INTO medalla (id_usuario, nombre, descripcion, imagen) VALUES (10, 'Medalla de Superación', 'Distinción por sobrepasar obstáculos y alcanzar metas difíciles.', NULL);
INSERT INTO medalla (id_usuario, nombre, descripcion, imagen) VALUES (11, 'Medalla de Reconocimiento', 'Premio por contribuciones sobresalientes en el lugar de trabajo.', NULL);
INSERT INTO medalla (id_usuario, nombre, descripcion, imagen) VALUES (12, 'Medalla de Éxito', 'Reconocimiento por logros significativos en la carrera profesional.', NULL);
INSERT INTO medalla (id_usuario, nombre, descripcion, imagen) VALUES (13, 'Medalla de Inspiración', 'Premio por motivar y inspirar a otros con acciones ejemplares.', NULL);
INSERT INTO medalla (id_usuario, nombre, descripcion, imagen) VALUES (14, 'Medalla de Solidaridad', 'Reconocimiento por apoyar causas humanitarias y solidarias.', NULL);
INSERT INTO medalla (id_usuario, nombre, descripcion, imagen) VALUES (15, 'Medalla de Persistencia', 'Distinción por mantenerse firme y perseverar frente a desafíos.', NULL);




