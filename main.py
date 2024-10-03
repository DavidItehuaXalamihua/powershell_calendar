import calendar
from datetime import datetime

# Obtener la fecha actual
today = datetime.today()
year = today.year
month = today.month
day = today.day

# Crear el calendario del mes actual
cal = calendar.monthcalendar(year, month)

# Colores de escape ANSI para cambiar el color en la consola
RED = '\033[91m'
RESET = '\033[0m'

print(month)
# Imprimir el encabezado (días de la semana)
print(calendar.month_name[month], year)
print('Mo Tu We Th Fr Sa Su')

# Imprimir el calendario con el día de hoy resaltado
for week in cal:
    for d in week:
        if d == day:
            # Si es el día de hoy, lo imprimimos en rojo
            print(f"{RED}{d:2}{RESET}", end=" ")
        elif d == 0:
            # Días fuera del mes (vacíos) se imprimen como espacios
            print("   ", end=" ")
        else:
            # Los demás días se imprimen normalmente
            print(f"{d:2}", end=" ")
    print()  # Salto de línea al final de cada semana
