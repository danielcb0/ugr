
---

## 1. El Cluster de Prácticas (atcgrid)

### a) Componentes físicos y estructura  
- **Nodos y Placa Madre:**  
  - El clúster se compone de un *nodo front-end* (host o master) y varios *nodos de cómputo*.  
  - **Front-end:** Ejemplo: Asus RS300‐E9‐PS4.  
  - **Nodos de cómputo:** Por ejemplo, atcgrid1, atcgrid2, atcgrid3 y atcgrid4.  
  - En los nodos, la placa madre (como la Supermicro X8DTL-i para atcgrid[1-3] y la SYS-6019U-TR4 para atcgrid4) conecta los chips de procesamiento y otros componentes.

- **Procesadores y Arquitectura:**  
  - En atcgrid[1-3] se usan procesadores como el Intel Xeon E5645 (6 cores/12 threads, 12MB L3 Cache, 2.40 GHz).  
  - En atcgrid4 se usa un Intel Xeon Silver 4216 (16 cores/32 threads, 22MB L3 Cache, 2.10 GHz).  
  - Cada nodo tiene, por ejemplo, 24 cores lógicos en atcgrid[1-3] y 64 en atcgrid4.  
  - Se debe tener presente la diferencia entre núcleos físicos y lógicos (para usar cores físicos se utiliza la opción **--hint=nomultithread**).

- **Conexiones y Red:**  
  - Los nodos están conectados mediante un **switch** y se accede a ellos a través del nodo front-end (ej. atcgrid.ugr.es).  
  - Se accede al sistema usando **ssh** para ejecutar comandos y **sftp** para la transferencia de ficheros.

---

## 2. Gestor de Carga de Trabajo (Slurm)

### a) Funciones básicas  
- **srun:**  
  - Ejecuta trabajos de forma interactiva.  
  - Ejemplo: `srun -p ac -A ac ./hello` envía el ejecutable `hello` a la cola **ac**.  
  - Para especificar el número de CPUs se usa la opción **-c** o **--cpus-per-task**.  
  - Al usar **--hint=nomultithread** se fuerza el uso de cores físicos, evitando los lógicos.

- **sbatch:**  
  - Envía scripts para su ejecución en segundo plano.  
  - Ejemplo: `sbatch -p ac script.sh` para enviar un script llamado `script.sh` a la cola **ac**.  
  - Dentro del script se pueden usar comandos **srun** para ejecutar el código real.
  - La opción **--wrap** permite ejecutar comandos simples sin necesidad de crear un script completo.

- **Otros comandos útiles:**  
  - **squeue:** Muestra la lista de trabajos en ejecución y en cola.  
  - **scancel:** Permite eliminar un trabajo en cola usando su identificador.  
  - **sinfo:** Lista la información de las particiones (colas) y de los nodos del clúster. Por ejemplo:  
    - `sinfo -p ac -o"%10D %10G %20b %f"` muestra nodos, recursos, características activas y disponibles.

### b) Particiones (colas)  
- Existen varias colas definidas, como:  
  - **ac:** Cola por defecto para atcgrid[1-3]  
  - **ac4:** Para el nodo atcgrid4  
  - Otras particiones pueden incluir **aapt** y **acap**.  
- Es fundamental saber a cuál cola enviar el trabajo según los recursos y el tiempo de ejecución que se necesiten.

---

## 3. Ejemplo de Script y Uso de OpenMP

### a) Script de ejemplo (script_helloomp.sh)  
- El script contiene órdenes para el gestor de carga de trabajo mediante directivas **#SBATCH** (nombre del trabajo, partición, cuenta, etc.).  
- Imprime información de las variables de entorno que asigna Slurm, lo cual es útil para comprobar la asignación de recursos.  
- Realiza una ejecución interactiva de un programa **HelloOMP** utilizando **srun** y luego lo ejecuta varias veces cambiando el número de threads.  
- Se recomienda **no usar** la instrucción `export OMP_NUM_THREADS` en el script, sino controlar el número de CPUs mediante las opciones de Slurm (por ejemplo, `--cpus-per-task` y `--hint=nomultithread`).

### b) Programa HelloOMP  
- Es un ejemplo simple en OpenMP donde cada thread imprime su identificador usando la función `omp_get_thread_num()`.  
- Permite ver en la práctica cómo se ejecuta código paralelo y cómo se asignan los recursos (threads).

---

## 4. Resumen de Puntos Clave y Preguntas BP0

Aquí tienes un resumen de las respuestas a las preguntas tipo test que se plantean en el documento BP0:

1. **¿Dónde se alojan los vectores dinámicos?**  
   - **Heap.**

2. **¿Comando para hacer que se usen los cores físicos?**  
   - Se utiliza la opción **--hint=nomultithread**.

3. **¿Cuántos nodos de cómputo hay en atcgrid?**  
   - **4 nodos.**

4. **¿Cuántos cores lógicos tiene cada nodo de atcgrid (atcgrid[1-3])?**  
   - **24 cores lógicos.**

5. **¿Cuántos cores lógicos tiene atcgrid4?**  
   - **64 cores lógicos.**

6. **¿En qué unidad de tiempo devuelve la instrucción clock_gettime()?**  
   - **Segundos.**

7. **¿Cuántos sockets tiene atcgrid?**  
   - **8 sockets.**

8. **¿Cuántos microprocesadores tiene cada nodo de cómputo?**  
   - **2 microprocesadores.**

9. **¿Cómo hacer que srun ejecute una tarea con 24 cores físicos?**  
   - Se emplea el comando:  
     `srun -p ac -c24 --hint=nomultithread`  
     (Asegurándose de que se soliciten 24 cores físicos).

10. **¿Comando para listar el estado e información del cluster?**  
    - Por ejemplo: `srun -p ac lscpu`.

11. **¿Comando para cargar ficheros del PC personal al cluster?**  
    - Se usa el comando **put** en un cliente **sftp**:  
      `put "nombreFichero"`

12. **¿Qué es necesario para poder hacer el comando anterior y cómo hacerlo?**  
    - Es necesario estar conectado mediante **sftp**.  
      Se establece la conexión con:  
      `sftp username@atcgrid.ugr.es`  
      y se ingresa la contraseña del usuario.

---

## 5. Estrategias para el Examen Tipo Test

- **Leer con atención cada pregunta:** Identifica las palabras clave (por ejemplo, “--hint=nomultithread”, “cores lógicos”, “heap”) y relaciona la respuesta con el resumen anterior.
- **Relaciona conceptos teóricos y prácticos:** Si la pregunta menciona comandos, piensa en cómo se diferencian **srun** y **sbatch** y recuerda sus opciones principales.
- **Repasa ejemplos de script:** Tener claro el funcionamiento del script de HelloOMP y las directivas **#SBATCH** te ayudará a recordar cómo se gestiona un trabajo en el clúster.
- **Usa el resumen de BP0 como guía:** Este resumen te dará respuestas directas a posibles preguntas de opción múltiple.

---
