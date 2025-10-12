CREATE DATABASE IF NOT EXISTS mi_base;
USE mi_base;

-- Tabla de usuarios con la nueva estructura
CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    usuario VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    rol ENUM('redactor','supervisor','admin') DEFAULT 'redactor',
    estatus ENUM('activo','inactivo') DEFAULT 'activo',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insertar datos de ejemplo
INSERT INTO usuario (nombre, email, usuario, password, rol, estatus) VALUES
('Andrea', 'andrea@example.com', 'andrea_user', '1234', 'admin', 'activo'),
('Carlos', 'carlos@example.com', 'carlos_user', '1234', 'supervisor', 'activo');