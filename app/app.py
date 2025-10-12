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