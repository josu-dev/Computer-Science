## Adivina adivinador....
import random

MAX_RANDOM_NUMBER = 100
MAX_TRYES = 5
RANDOM_NUMBER = random.randrange(MAX_RANDOM_NUMBER + 1)

print("Tenés {} intentos para adivinar un numero entre 0 y {}".format(
  MAX_TRYES,MAX_RANDOM_NUMBER))

gane = False
intento = 0

while intento < MAX_TRYES and not gane:
    intento += 1
    numero_ingresado = int(input('Ingresa tu número: '))
    if numero_ingresado == RANDOM_NUMBER:
        print('Ganaste! y necesitaste {} intentos!!!'.format(intento))
        gane = True
    else:
        print('Mmmm ... No.. ese número no es... Seguí intentando.')

if not gane:
    print('\n Perdiste :(\n El número era: {}'.format(RANDOM_NUMBER))