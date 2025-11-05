# Leer el archivo con los valores (uno por línea)
with open("xd.txt", "r") as f:
    lines = [line.strip() for line in f if line.strip()]

# Agrupar de 4 en 4 y concatenar
grouped = ["".join(lines[i:i+4]) for i in range(0, len(lines), 4)]

# Guardar en otro archivo
with open("output.txt", "w") as f:
    for group in grouped:
        f.write(group + "\n")

print("Conversión completada. Resultado en 'output.txt'")
