# Guía Completa: Docker Para Sitio Web Python + MySQL (Windows)

---

## 📘 Introducción

Esta guía está diseñada **para principiantes** que nunca han usado Docker. Te explicará desde cero qué es Docker, cómo instalarlo en **Windows**, cómo crear un **sitio web con Python**, una **base de datos MySQL**, y cómo hacer que ambos trabajen juntos dentro de contenedores.

---

## 🧩 ¿Qué es Docker?

Docker es una herramienta que permite **crear, desplegar y ejecutar aplicaciones dentro de contenedores**. Un contenedor es como una mini computadora que tiene todo lo necesario para ejecutar una aplicación: su sistema, librerías y configuraciones, pero sin ocupar tanto espacio como una máquina virtual.

En pocas palabras: **Docker hace que tus proyectos sean portables y fáciles de reproducir** en cualquier computadora.

---

## ⚙️ Instalación en Windows

### 1. Requisitos previos

* Windows 10 o 11 (64 bits)
* Mínimo 8 GB de RAM
* Virtualización habilitada (revisa en BIOS que esté activada la opción *Intel VT-x* o *AMD-V*)

### 2. Instalar Docker Desktop

1. Visita la página oficial: [https://www.docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)
2. Descarga **Docker Desktop para Windows**.
3. Ejecuta el instalador y sigue las instrucciones.
4. Acepta el uso de **WSL 2** (Subsistema de Linux para Windows) cuando te lo pida.
5. Reinicia tu computadora si es necesario.

### 3. Verificar instalación

Abre **PowerShell** y escribe:

```bash
docker --version
```

Deberías ver algo como:

```
Docker version 27.0.1, build 1234567
```

---

## 🧱 Conceptos básicos de Docker

| Concepto           | Descripción                                                                                             |
| ------------------ | ------------------------------------------------------------------------------------------------------- |
| **Imagen**         | Es una plantilla o modelo que define qué contiene un contenedor. Ejemplo: una imagen de MySQL o Python. |
| **Contenedor**     | Es una instancia en ejecución de una imagen. Ejemplo: tu base de datos o tu aplicación web.             |
| **Dockerfile**     | Archivo que define cómo crear una imagen personalizada.                                                 |
| **Docker Compose** | Herramienta que permite ejecutar varios contenedores juntos con un solo comando.                        |

---

## 🧰 Estructura del Proyecto

Vamos a crear una carpeta con la siguiente estructura:

```
mi_proyecto_docker/
│
├── app/
│   ├── app.py
│   ├── requirements.txt
│   └── Dockerfile
│
├── db/
│   └── init.sql
│
└── docker-compose.yml
```

---

## 🐍 Crear la aplicación Python (Flask)

### 1. Crear el archivo `app.py`

```python
from flask import Flask, jsonify
import mysql.connector

app = Flask(__name__)

@app.route('/')
def home():
    return '¡Hola desde Docker!'

@app.route('/usuarios')
def usuarios():
    conexion = mysql.connector.connect(
        host='db',
        user='root',
        password='1234',
        database='mi_base'
    )
    cursor = conexion.cursor()
    cursor.execute('SELECT * FROM usuarios;')
    datos = cursor.fetchall()
    conexion.close()
    return jsonify(datos)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

### 2. Crear el archivo `requirements.txt`

```
flask
mysql-connector-python
```

### 3. Crear el archivo `Dockerfile` dentro de `app/`

```Dockerfile
FROM python:3.10
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
CMD ["python", "app.py"]
```

---

## 🗃️ Crear la base de datos MySQL

### 1. Crear el archivo `db/init.sql`

```sql
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
```

---

## ⚙️ Configurar `docker-compose.yml`

Crea este archivo en la raíz del proyecto:

```yaml
version: '3.8'

services:
  db:
    image: mysql:8.0
    container_name: contenedor_mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: 1234
      MYSQL_DATABASE: mi_base
    ports:
      - "3306:3306"
    volumes:
      - ./db/init.sql:/docker-entrypoint-initdb.d/init.sql

  web:
    build: ./app
    container_name: contenedor_flask
    restart: always
    ports:
      - "5000:5000"
    depends_on:
      - db
```

---

## 🚀 Levantar los contenedores

Desde la carpeta raíz del proyecto, abre PowerShell y ejecuta:

```bash
docker-compose up --build
```

Esto descargará las imágenes necesarias y creará dos contenedores:

* **contenedor_mysql** → Base de datos MySQL
* **contenedor_flask** → Aplicación web Python Flask

Una vez completado, abre tu navegador y visita:

```
http://localhost:5000
```

Verás el mensaje “¡Hola desde Docker!”

Y para ver los datos de la base de datos:

```
http://localhost:5000/usuarios
```

---

## 🧹 Comandos útiles de Docker

| Comando                          | Descripción                                      |
| -------------------------------- | ------------------------------------------------ |
| `docker ps`                      | Ver contenedores activos                         |
| `docker ps -a`                   | Ver todos los contenedores (activos e inactivos) |
| `docker stop nombre_contenedor`  | Detiene un contenedor                            |
| `docker start nombre_contenedor` | Inicia un contenedor detenido                    |
| `docker-compose down`            | Apaga y elimina todos los contenedores           |
| `docker-compose up -d`           | Inicia en segundo plano                          |

---

## 🧠 Consejos para entender Docker

1. **Cada servicio es independiente**: Flask y MySQL viven en sus propios contenedores.
2. **Comunicación interna**: Flask se conecta a MySQL usando el nombre del servicio (`db`), no `localhost`.
3. **Persistencia de datos**: Los datos se guardan en los volúmenes (aunque se reinicie Docker, no se pierden).
4. **Portabilidad**: Puedes copiar tu carpeta a otra PC y funcionará igual.

---

