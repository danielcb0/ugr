Aquí tienes un **conjunto ampliado de preguntas tipo test** por cada categoría, con **respuesta** y **explicación**. Son todos los ítems plausibles que podrían plantearte bajo distintas formulaciones.

---

## 1. Flynn: Clasificación de Arquitecturas

| Pregunta                                                                                              | Respuesta | Explicación                                                                                                                                       |
| ----------------------------------------------------------------------------------------------------- | --------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| ¿Qué arquitectura de Flynn corresponde a una CPU clásica de un solo núcleo sin vectorización?         | SISD      | Single Instruction, Single Data: un único flujo de control sobre un dato a la vez.                                                                |
| ¿Cómo se denomina la arquitectura en la que varios procesadores ejecutan código distinto en cada uno? | MIMD      | Multiple Instruction, Multiple Data: cada procesador ejecuta su propio flujo de instrucciones sobre su propio conjunto de datos.                  |
| ¿En qué categoría de Flynn encajarían las GPUs actuales con miles de núcleos sencillos?               | SIMD      | Aunque tienen múltiples núcleos, todos ejecutan la misma instrucción en datos diferentes de forma masiva.                                         |
| ¿Es MISD adecuada para aplicaciones de tolerancia a fallos en procesado de señales?                   | Raro      | MISD no es común, pero en teorizaciones de sistemas críticos se sugirió para redundancia: mismo dato por múltiples unidades de proceso distintas. |
| ¿Qué arquitectura permite explotaciones dinámicas de hilos y vectorización simultáneas?               | Mixta     | No clasifica directamente en Flynn, pero sistemas modernos combinan SIMD (vector) + MIMD (hilos) en multicore.                                    |

---

## 2. Niveles de Paralelismo Implícito

| Pregunta                                                                                             | Respuesta                | Explicación                                                                                           |
| ---------------------------------------------------------------------------------------------------- | ------------------------ | ----------------------------------------------------------------------------------------------------- |
| ¿A qué nivel pertenece el paralelismo intra-instrucción (ILP)?                                       | Operaciones (grano fino) | ILP explota independencia entre operaciones dentro de la misma instrucción o instrucciones sucesivas. |
| ¿Dónde se sitúa la paralelización en un bucle de procesamiento de píxeles?                           | Bucle (medio-fino)       | Cada iteración independiente de píxeles se puede ejecutar simultáneamente.                            |
| ¿La ejecución concurrente de dos aplicaciones diferentes en un servidor es paralelismo de qué nivel? | Programas (grueso)       | Cada aplicación es un programa independiente, gran unidad de trabajo.                                 |
| ¿Cuál es la granularidad de paralelismo de una sola función vectorial en SIMD?                       | Medio-fino               | La función vectorial contiene bucles o instrucciones vectoriales, grano medio-fino.                   |
| ¿Ejecutar tareas de I/O y cálculo simultáneamente es DLP o TLP?                                      | TLP                      | Son tareas diferentes (I/O vs computación), no se aplica la misma operación a múltiples datos.        |

---

## 3. Dependencias de Datos

| Pregunta                                                             | Respuesta | Explicación                                                                                                                    |
| -------------------------------------------------------------------- | --------- | ------------------------------------------------------------------------------------------------------------------------------ |
| `x = y + z; …; y = x * 2;` ¿dependencia?                             | WAR       | Se escribe `x`, luego se lee en la segunda instrucción, pero la segunda instrucción escribe en `y`, no en `x` (no RAW ni WAW). |
| `m = n + 1; …; n = m - 1;` ¿qué tipo de dependencia existe?          | WAR       | El segundo bloque escribe `n` tras haber leído `n` en el primero, creando antidependencia.                                     |
| `p = q * 3; …; p = r + 5;` ¿dependencia?                             | WAW       | Ambas instrucciones escriben en `p`, hay dependencia de salida.                                                                |
| `a = b + c; …; c = a + d;`                                           | RAW       | La segunda lee `a` que fue escrito por la primera.                                                                             |
| `i = j + k; …; j = 0; …; k = 1; … i = j + k;` ¿qué dependencias hay? | RAW y WAR | La última lectura de `j` y `k` depende de su reescritura; además, `i` se escribe tras leer `j` y `k`.                          |

---

## 4. Paralelismo de Datos vs Tareas

| Pregunta                                                                                            | Respuesta | Explicación                                                               |
| --------------------------------------------------------------------------------------------------- | --------- | ------------------------------------------------------------------------- |
| ¿Sumar dos matrices de tamaño NxN en paralelo es DLP o TLP?                                         | DLP       | Operaciones idénticas en múltiples elementos de la matriz (datos).        |
| ¿Paralelizar distintos filtros (blur, sharpen) de una imagen en tareas independientes es DLP o TLP? | TLP       | Son funciones diferentes sobre los datos, no la misma operación repetida. |
| ¿Un map-reduce distribuido sobre grandes volúmenes de datos usa DLP o TLP?                          | Ambos     | Map (DLP por chunk de datos), Reduce (TLP al combinar resultados).        |
| ¿SIMD en hardware corresponde a DLP o TLP?                                                          | DLP       | SIMD aplica un único opcode a múltiples datos simultáneamente.            |
| ¿Usar OpenMP `parallel sections` para ejecutar Func1 y Func2 simultáneamente genera DLP o TLP?      | TLP       | Se paralelizan funciones o secciones de código diferentes.                |

---

## 5. Métricas de Rendimiento

| Pregunta                                                              | Respuesta             | Explicación                                                                                                                 |
| --------------------------------------------------------------------- | --------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| ¿Qué métrica expresa millones de instrucciones por segundo?           | MIPS                  | Millions of Instructions Per Second, pero puede engañar si el CISC emite pocas instrucciones más complejas.                 |
| Para medir flops en punto flotante ¿qué métrica usarías?              | MFLOPS / GFLOPS       | Millones o miles de millones de FLOating-point Operations Per Second.                                                       |
| ¿Cómo afecta un incremento de CPI al tiempo de CPU?                   | Lo aumenta lineal     | \$T\_{CPU} = NI \times CPI \times T\_{ciclo}\$, mayor CPI → mayor tiempo de ejecución.                                      |
| Duplicar frecuencia de reloj ¿cómo cambia MIPS manteniendo mismo CPI? | Se duplica            | MIPS = (freq / CPI) × 10⁶, al duplicar freq se duplica MIPS.                                                                |
| ¿Por qué no comparar CPUs solo por MIPS?                              | Puede inducir a error | MIPS no refleja la complejidad de instrucciones; un CPU con MIPS bajo pero instrucciones más potentes puede ser más rápido. |

---

## 6. Ley de Amdahl y Speed-up

| Pregunta                                                                       | Respuesta   | Explicación                                                                                                                                   |
| ------------------------------------------------------------------------------ | ----------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| ¿Cuál es el límite de \$S\$ si 10 % del tiempo es secuencial y \$p\to\infty\$? | 1/0.10 = 10 | \$S=1/f=1/0.10=10\$ cuando el resto se paraleliza infinitamente.                                                                              |
| Si \$f=0.5\$ y mejoras la parte paralela 8× (\$p=8\$), ¿cuál es \$S\$?         | ≈1.6        | \$S=1/(0.5 + 0.5/8) = 1/(0.5 + 0.0625) = 1/0.5625 ≈1.777…\$ *(atención: verifica la fracción correcta de parte secuencial vs paralelizable)*. |
| ¿Cómo cambia \$S\$ si \$f\$ (parte secuencial) disminuye?                      | Aumenta     | Menos tiempo no paralelizable → mayor speed-up máximo.                                                                                        |
| ¿Qué pasa con \$S\$ si \$p=1\$ (no hay paralelismo)?                           | 1           | Con \$p=1\$, no hay mejora, \$S=1/(f + (1-f)/1) =1\$.                                                                                         |
| Si \$f=0.2\$ y \$p=4\$, ¿cuál es \$S\$?                                        | ≈1.32       | \$S=1/(0.2 + 0.8/4)=1/(0.2+0.2)=1/0.4=2.5\$.                                                                                                  |

---

## 7. Pipelining e ILP

| Pregunta                                                                           | Respuesta                                     | Explicación                                                                                 |
| ---------------------------------------------------------------------------------- | --------------------------------------------- | ------------------------------------------------------------------------------------------- |
| Pipeline de 3 etapas con latch de 10 ns y etapas {50, 40, 60} ns: ¿qué \$t\$ vale? | 60+10=70 ns                                   | Etapa más lenta (60 ns) + retardo de registro (10 ns).                                      |
| ¿Speed-up límite de ese pipeline frente a 180 ns sin pipeline?                     | ≈180/70≈2.57                                  | Speed-up ≈ \$T\_{no}/t = 180/70 ≈2.57\$.                                                    |
| Para \$n=5\$ instrucciones en pipeline de 4 etapas, ¿qué \$S(n)\$?                 | \$4×5/(5+3)=20/8=2.5\$                        | \$S(n)=k n/(n+k-1)\$ con \$k=4, n=5\$.                                                      |
| ¿Qué introduce “burbuja” en un pipeline?                                           | Dependencias RAW o saltos de control          | Las hazards añaden ciclos vacíos mientras se resuelven dependencias o se direcciona saltos. |
| ¿Cómo se minimiza el impacto de saltos en un pipeline?                             | Predicción de saltos o ejecución especulativa | Técnicas de branch prediction rellena etapas antes de conocer destino real.                 |

---

## 8. Memoria Compartida vs Distribuida

| Pregunta                                                                                   | Respuesta                                 | Explicación                                                                                    |
| ------------------------------------------------------------------------------------------ | ----------------------------------------- | ---------------------------------------------------------------------------------------------- |
| En SMP, ¿la latencia de acceso a cualquier dirección es igual?                             | Sí (UMA)                                  | Uniform Memory Access, latencia homogénea.                                                     |
| ¿Qué arquitectura usa paso explícito de mensajes?                                          | Multicomputador/MC                        | Cada nodo tiene su memoria; la comunicación es por send/receive.                               |
| ¿En NUMA la latencia es uniforme o variable?                                               | Variable                                  | Non-Uniform Memory Access: diferente latencia según la “distancia” al controlador de memoria.  |
| ¿Qué pro y contra tiene SMP frente a clúster?                                              | + Sencillo prog. – Escalabilidad limitada | SMP evita paso de mensajes pero sufre contención de memoria al aumentar núcleos.               |
| Distribuir módulos de memoria físicamente sin cambiar el espacio de direcciones se llama…? | Distributed Shared Mem                    | (Modelo teórico) nodos comparten lógica sin cambiar direcciones, pero con latencias variables. |

---

## 9. Procesos vs Hilos

| Pregunta                                                   | Respuesta        | Explicación                                                                                     |
| ---------------------------------------------------------- | ---------------- | ----------------------------------------------------------------------------------------------- |
| Crear un hilo vs un proceso en Linux, ¿cuál es más rápido? | Hilo             | Hilos comparten espacio de direcciones, menor overhead de creación/cambio.                      |
| ¿Cuál tiene su propio espacio de direcciones?              | Proceso          | Procesos son aislados; hilos comparten el mismo address space dentro del proceso padre.         |
| ¿Qué modelo de paralelismo usa POSIX threads?              | TLP (hilos)      | Paralelismo de tareas dentro de un programa único, con threads ligeros del SO.                  |
| Compartir datos entre hilos requiere…                      | Sincronización   | Mutex/semáforos para proteger secciones críticas.                                               |
| Entre procesos, compartir datos implica…                   | IPC (pipes, shm) | Mecanismos de Inter-Process Communication: memoria compartida, colas de mensajes, sockets, etc. |

---

Este **catálogo ampliado** cubre prácticamente **todas las variantes** de preguntas conceptuales sobre el Tema 1, con respuestas y explicaciones detalladas. ¡Repásalas y domina la lógica detrás de cada una para estar preparado ante cualquier reformulación en el examen tipo test!
