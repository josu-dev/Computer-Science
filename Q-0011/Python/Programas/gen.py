from distutils.file_util import write_file
from pydoc import pathdirs

import random

N_MIEMBROS = 3
NOMBRE_ARCHIVO = 'Equipos Generados' + '.html'

miembros = []

print('Ingrese los nombres, si esta vacio el mensaje deja de ingresar')

string_leida = input('  - ')
while string_leida != '':
    miembros.append(string_leida.lstrip())
    string_leida = input('  - ')

random.shuffle(miembros)


equipos = []

while len(miembros) > 0:
    i = N_MIEMBROS
    equipo = []
    while (len(miembros) > 0) & (i > 0):
        equipo.append(miembros.pop())
        i = i - 1
    equipos.append(equipo)


txt = [
    '<!DOCTYPE html>',
    '<html lang="es">',
    '<head>',
    '<meta charset="UTF-8">',
    '<title>Equipo generado</title>',
    '</head>',
    '<body style="font-family:monospace; font-size:2rem; background: lightblue">',
]

txt.append('<h1>Equipos aleatorios</h1>')
txt.append('<div style="margin-left:2rem">')

for i in range(len(equipos)):
    txt.append(f'<b>Equipo {i + 1}:</b><ul>')
    for name in equipos[i]:
        txt.append(f'<li>{name}</li>')
    txt.append('</ul>')

txt.append('</div>')
txt.append('</body>')
txt.append('</html>')

dir = pathdirs()[0].replace('\\','/') + f'/{NOMBRE_ARCHIVO}'
write_file(dir, txt)

print(f'Se genero el archivo de equipos en la ruta: {dir}')