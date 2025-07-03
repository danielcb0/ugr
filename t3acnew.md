Perfecto, Don Daniel. ¡Vargas Cipollo!

Voy a prepararte unos apuntes en formato Markdown, bien organizados por bloques temáticos (MSI, MESI, NUMA, LL/SC, cerrojos y barreras, SMT), con explicaciones claras, ejemplos de preguntas tipo test y transiciones de estados correctas y completas, orientado a que aprendas de forma eficaz y rápida.

Te aviso en cuanto esté todo listo para que puedas empezar a memorizar.


# Protocolos de coherencia MSI/MESI

Los protocolos MSI y MESI mantienen coherencia de caché con estados por bloque (M=Modificado, E=Exclusivo, S=Compartido, I=Inválido). Se describen a continuación las transiciones de estado según operaciones locales (lectura/escritura del propio núcleo) y remotas (peticiones de otros núcleos):

* **Protocolo MSI (3 estados: M, S, I):**

  * **M:** lectura o escritura local → sigue **M**. Petición remota de lectura (**BusRd**) → pasa a **S**. Petición remota de escritura (**BusRdX**) → invalida la copia local, queda **I**. Reemplazo local (evicción) → invalida, queda **I**.
  * **S:** lectura local → sigue **S**. Escritura local → envía **BusRdX** (petición exclusiva) y pasa a **M**. Petición remota de lectura → sigue **S** (compartido). Petición remota de escritura → invalida la copia local, queda **I**.
  * **I:** lectura local (miss) → envía **BusRd**, pasa a **S** (si ya hay copia en otro núcleo) o **E** (si era única; en MSI siempre se asume que va a S). Escritura local (miss) → envía **BusRdX**, pasa a **M**. Cualquier petición remota (**BusRd**/BusRdX) → permanece **I** (ninguna copia que responder).

* **Protocolo MESI (4 estados: M, E, S, I):**

  * **M:** lectura/escritura local → **M**. Petición remota de lectura → pasa a **S** (envía el bloque actualizado a la memoria). Petición remota de escritura → invalida copia local, queda **I**. Reemplazo local → invalida, queda **I**.
  * **E:** lectura local → sigue **E**. Escritura local → pasa a **M** (actualiza bloque). Petición remota de lectura → pasa a **S** (divide el bloqueo compartido con el otro núcleo). Petición remota de escritura → invalida copia local, queda **I**.
  * **S:** lectura local → sigue **S**. Escritura local → envía **BusRdX** y pasa a **M**. Petición remota de lectura → sigue **S** (ya compartido). Petición remota de escritura → invalida copia local, queda **I**.
  * **I:** lectura local (miss) → envía **BusRd**, pasa a **S** (si hay otras copias) o **E** (si era única; detectado con cable OR). Escritura local (miss) → envía **BusRdX**, pasa a **M**. Peticiones remotas (**BusRd/BusRdX**) → permanece **I**.

* **Casos de test “verdadero” (V):** ejemplos correctos marcados V en las fuentes:

  * *MESI:* Un bloque en estado **E** sólo puede estar en una única caché (de ahí nombre “Exclusivo”); de igual forma, **M** sólo en una caché.
  * *MESI:* Si un bloque está **E** en N1 y otro núcleo N2 lo lee, pasa a **S** en ambas caches. Si estaba **S** en N1 y N2 lee, permanece **S** en ambas.
  * *MSI:* Si un bloque está **M** en N1 y N2 escribe, la copia en N1 se invalida (I) y en N2 queda **M**. (En cambio, si N2 lee, se invalida N1 y N2 pasa a **M**, lo cual es *falso*).
  * *MSI:* Correctamente, si N1 está **M** y N2 lee, ambas caches pasan a **S** (tras actualizar memoria). Estas transiciones coinciden con las especificaciones de MSI/MESI.

# Arquitectura NUMA y directorios

En NUMA cada nodo tiene memoria local y directorios para coherencia. El **número de entradas** de directorio por nodo se calcula como (tamaño memoria del nodo)/(tamaño línea de caché). Ejemplos:

* 16 nodos, 4 GiB/nodo, líneas de 64 B: $4{\times}2^{30}/2^6 = 2^{26}$ entradas.
* 8 nodos, 16 GiB/nodo, 64 B: $2^{34}/2^6 = 2^{28}$ entradas.
* 8 nodos, 8 GiB/nodo, 128 B: $2^{33}/2^7 = 2^{26}$ entradas.
* 64 nodos, 8 GiB/nodo, 128 B: $2^3\cdot2^{30}/2^7 = 2^{26}$ entradas.
* 32 nodos, 16 GiB/nodo, 128 B: $2^4\cdot2^{30}/2^7 = 2^{27}$ entradas.

El **número de bits** por entrada del directorio es (número de nodos) + 1. Ej.: 16 nodos → 17 bits, 8 nodos → 9 bits, 64 nodos → 65 bits, 32 nodos → 33 bits (1 bit por cada nodo + 1 bit de validez).

Cada entrada del directorio mantiene un bit por nodo indicando si ese nodo tiene una copia del bloque, más un bit de **V** (válido en memoria). Por ejemplo, un patrón `110…0 V` significa que los nodos 0 y 1 tienen copia (bits 1), otros no (bits 0), y la memoria principal tiene el bloque actualizado. En cambio, un patrón con bit de memoria “I” (inválido) como `110…0 I` no es posible en un protocolo MSI con esas copias (F), pues si varios nodos comparten el dato, la memoria debe ser válida (V).

# Instrucciones LL/SC (Load-Linked/Store-Conditional)

**LL/SC** es un mecanismo de sincronización atómico: se ejecuta un *Load-Linked* (lectura enlazada) de una dirección de memoria, luego un *Store-Conditional* (escritura condicional) a la misma dirección. El SC sólo tiene éxito (realiza la escritura) si ningún otro procesador ha modificado esa dirección entre la LL y el SC. Internamente se usa una marca o flag en hardware que detecta interferencias. Esto permite implementar operaciones atómicas sin bloquear otros accesos: si otro hilo escribió entre LL y SC, el SC falla (por detección de cambio) y se reintenta. **Caso test verdadero:** efectivamente el hardware LL/SC detecta si otro procesador ha accedido a la dirección durante LL–SC, lo que es precisamente su objetivo. LL/SC es usado por arquitecturas como Power/ARM para algoritmos de cerrojos sin espera (spinlocks) eficientes.

# Cerrojos (locks) y barreras

* **Cerrojos simples (spin-locks):** sincronizan acceso a una sección crítica con espera ocupada. Se implementan típicamente con instrucciones atómicas como Test\&Set o Compare\&Swap. Ejemplos de código (en pseudocódigo):

  * *Test\&Set:*

    ```c
    lock(k) { while(test_and_set(&k)==1) { /* esperar */ } }
    ```

    donde `test_and_set` intercambia 1 con la variable `k` y devuelve el valor antiguo. El bucle se repite hasta que la variable pase de 0 (abierto) a 1 (cerrado).
  * *Fetch\&Or:* similar, hace un OR atómico con 1. Por ejemplo:

    ```c
    lock(k) { while(fetch_or(&k,1)==1) { } }
    ```

    Bloquea hasta que el bit `k` esté en 0, luego lo pone en 1.
  * *Ticket-lock:* (no cubierto en fuentes) asigna a cada hilo un “ticket” incremental. El hilo espera hasta que su número (“turn”) coincida con el valor actual del ticket en un contador. Garantiza orden FIFO y evita inanición. Requiere dos contadores atómicos (ticket y turno).
  * *Compare\&Swap:* también usado para locks y otras primitivas atómicas.

* **Implementación de cerrojo (ejemplo):** un semáforo binario `k` puede definirse con `k=0` (abierto) o `k=1` (cerrado). Un hilo hace `while(test_and_set(&k)==1) {}`, siendo `test_and_set` atómico. Al salir, bloqueamos con `k=1`, y para liberar hacemos `k=0`.

* **Barreras (síncronas):** hacen que todos los hilos esperen hasta que todos alcancen un punto (barrera) antes de continuar. Ejemplo sencillo con contadores y bandera:

  * *Barrera básica:* cada hilo ejecuta algo como:

    ```
    barrier(id,N) {
      if (bar[id].count==0) bar[id].flag = 0;
      count_local = ++bar[id].count;
      if (count_local == N) {
        bar[id].count = 0;
        bar[id].flag = 1;    // último hilo libera a todos
      } else {
        while (bar[id].flag == 0) { /* spin */ };
      }
    }
    ```

    Aquí, el último hilo en llegar resetea el contador y pone la bandera `flag=1`, mientras los demás esperan girando hasta que la bandera cambie. Esto sincroniza a los N hilos.

  * *Barrera “sense-reversing”:* evita problemas de reutilización (empezar una barrera nueva antes de terminar la anterior) alternando un valor de bandera local. Pseudocódigo:

    ```
    barrier(id,N) {
      local_sense = !local_sense; 
      lock(bar[id].lock);
      count_local = ++bar[id].count;
      unlock(bar[id].lock);
      if (count_local == N) {
        bar[id].count = 0;
        bar[id].flag = local_sense;  // todos liberados con nuevo sentido
      } else {
        while (bar[id].flag != local_sense) { /* spin */ };
      }
    }
    ```

    Cada uso invierte la bandera local y libera a los hilos esperando de la ronda anterior.

* **Puntos clave:** los cerrojos basados en busy-wait consumen CPU mientras esperan. Alternativas pueden suspender el hilo (colas de espera) en vez de girar. Las barreras simples requieren reiniciar las variables al final; la variante sense-reversing los hace seguros para reutilización repetida.

# Simultaneous Multithreading (SMT)

SMT (multihilo simultáneo) es una técnica de microarquitectura **superescalar** que ejecuta instrucciones de varios hilos en paralelo en un mismo core. Permite **emitir instrucciones de diferentes hilos en el mismo ciclo**, aprovechando mejor las unidades funcionales del procesador. Por ejemplo, en un core SMT típico (Intel Hyper-Threading) las instrucciones de dos hilos pueden intercalarse en la tubería de ejecución. Esto incrementa el ILP agregado al permitir que cuando un hilo se queda esperando (por dependencia o memoria), otro hilo utilice el core.

* **Casos correctos (V):** efectivamente, en SMT se pueden procesar instrucciones de hilos distintos en un mismo ciclo. En los tests se confirma: “en un procesador SMT se pueden enviar instrucciones de hilos diferentes en cada ciclo” (V). Esto aprovecha la superescalaridad del core. No debe confundirse con **CMP (chip multi-procesador)**, donde cada hilo es ejecutado en un core diferente; en SMT todos los hilos comparten el mismo core.

* **Resumen:** SMT combina paralelismo a nivel de hilo y a nivel de instrucción. Los hilos comparten recursos (cachés, ALUs, etc.) y el scheduler del núcleo emite desde cualquiera de ellos para maximizar uso. Como dice la fuente: “Pueden emitir instrucciones de varios threads en un ciclo”, lo que mejora el rendimiento global cuando hay suficientes hilos.

**Referencias:** Los conceptos y ejemplos anteriores se basan en las diapositivas y ejercicios del tema, así como en preguntas de test donde los casos verdaderos (marcados “V”) confirman la semántica de los protocolos y mecanismos de sincronización.






---------------------------------------------------------------------------
----------------------------------------------------------------------------
Buenos días Don Daniel. ¡Vargas Cipollo!.

He ampliado y completado cada sección con más detalles, ejemplos y casos para que tengas un panorama exhaustivo.

---

## 1. Protocolos de coherencia MSI y MESI

### 1.1. Protocolo MSI (Snoopy)

Estados posibles en cada línea:

* **M (Modified):** sólo esta caché tiene copia, y está sucia (memoria principal obsoleta).
* **S (Shared):** una o más cachés tienen copia limpia.
* **I (Invalid):** copia inválida o ausente.

| Evento y origen      | Estado inicial N1 | Señal en bus | Transición N1 | Transición N2 (si aplica) | Comentarios                                   |
| -------------------- | ----------------- | ------------ | ------------- | ------------------------- | --------------------------------------------- |
| **Lectura local**    | I                 | BusRd        | I → S         | —                         | Trae línea desde memoria; marca compartida.   |
| **Lectura local**    | S                 | —            | S → S         | —                         | Cache hit; sin bus.                           |
| **Lectura local**    | M                 | —            | M → M         | —                         | Cache hit; sin bus.                           |
| **Escritura local**  | I                 | BusRdX       | I → M         | invalida otras S/I        | Trae línea y se actualiza; anula compartidas. |
| **Escritura local**  | S                 | BusRdX       | S → M         | invalida otras S/I        | Upgrade; no leer memoria.                     |
| **Escritura local**  | M                 | —            | M → M         | —                         | Cache hit; sin bus.                           |
| **Lectura remota**   | M                 | BusRd        | M → S (Flush) | S                         | Difunde dato modificado a la memoria/caches.  |
| **Lectura remota**   | S                 | BusRd        | S → S         | S                         | Sólo comparte.                                |
| **Escritura remota** | M/S/I             | BusRdX       | → I           | M/S → I                   | Invalida línea en N1.                         |

### 1.2. Protocolo MESI (Snoopy)

Añade el estado **E (Exclusive)** (copia única, limpia).

| Evento y origen      | Estado inicial N1 | Señal en bus                | Transición N1                          | Transición N2 (si aplica) | Comentarios                               |
| -------------------- | ----------------- | --------------------------- | -------------------------------------- | ------------------------- | ----------------------------------------- |
| **Lectura local**    | I                 | BusRd                       | I → E (si no hay S) o I → S (si hay S) | —                         | Si nadie más tiene la línea, se asigna E. |
| **Lectura local**    | E                 | —                           | E → E                                  | —                         | Cache hit; sin bus.                       |
| **Lectura local**    | S                 | —                           | S → S                                  | —                         | Cache hit.                                |
| **Lectura local**    | M                 | —                           | M → M                                  | —                         | Cache hit.                                |
| **Escritura local**  | I                 | BusRdX                      | I → M                                  | invalida S/I              | Carga exclusiva y modifica.               |
| **Escritura local**  | E                 | BusUpgr (BusRdX sin cargar) | E → M                                  | invalida S/I              | Upgrade silencioso; no transfiere datos.  |
| **Escritura local**  | S                 | BusUpgr                     | S → M                                  | invalida otras S          | Upgrade.                                  |
| **Escritura local**  | M                 | —                           | M → M                                  | —                         | Cache hit.                                |
| **Lectura remota**   | M                 | BusRd                       | M → S (Flush)                          | S                         | Difunde dato modificado.                  |
| **Lectura remota**   | E                 | BusRd                       | E → S                                  | S                         | Baja exclusividad a compartido.           |
| **Lectura remota**   | S                 | BusRd                       | S → S                                  | S                         | Comparte limpias.                         |
| **Escritura remota** | M/E/S/I           | BusRdX/BusUpgr              | → I                                    | invalida                  | Invalida copia local.                     |

> **Casos prácticos:**
>
> * **Lectura remota desde E:** N1 en E, N2 emite BusRd → N1 revierte a S y envía dato; N2 en S.
> * **Escritura local desde E:** N1 en E escribe → envía BusUpgr, N1 en M, otras caches pasan a I.
> * **No hay casos de escritura remota marcada como “verdadero” en la prueba recopilada de MESI.**

---

## 2. Arquitectura NUMA con MSI o MESI

### 2.1. Conceptos clave

* **NUMA (Non‐Uniform Memory Access):**

  * Cada **nodo** agrupa uno o varios CPUs y su memoria local.
  * **Acceso local**: baja latencia; **acceso remoto**: mayor latencia.

* **Directorio de coherencia**

  * Evita difusión (broadcast) masivo.
  * Cada línea de caché en memoria tiene una **entrada de directorio**:

    * **Validez** (bit V).
    * **Bitmap** de N bits: indica qué nodos tienen copia.

* **Protocolo basado en directorio MSI/MESI**

  1. **Lectura remota**:

     * Si V=0 → memoria envía dato y actualiza bitmap.
     * Si V=1 → directorio consulta a nodos sharers y posiblemente invalida si es BusRdX.
  2. **Escritura remota**:

     * Se envía solicitud BusRdX al directorio → invalida todas las copias antes de conceder M.

### 2.2. Ejemplo de cálculo de directorio

* **Parámetros**: 8 nodos, 16 GiB/nodo, línea de 64 B →

  * Líneas por nodo = (16 GiB) / (64 B) = 2³⁴ B / 2⁶ B = 2²⁸ líneas.
  * Entradas totales de directorio = 2²⁸ × 8 nodos (memoria central) = 2³¹.
  * Bits por entrada = 1 (V) + 8 (bitmap) = 9 bits.
  * **Tamaño total** ≈ 2³¹ entradas × 9 bits ≈ 9 Gbits (\~1.1 GB).

### 2.3. NUMA + MESI vs. NUMA + MSI

| Característica       | MSI (snoopy)      | MESI (snoopy)  | Directorio-MSI/MESI            |
| -------------------- | ----------------- | -------------- | ------------------------------ |
| Difusión (broadcast) | Alta sobre el bus | Moderada       | Ninguna (punto a punto)        |
| Overhead de bits     | 2 bits/ línea     | 3 bits/ línea  | N+1 bits/ línea                |
| Latencia remota      | Alta              | Alta           | Variable según topología       |
| Escalabilidad        | Limitada (bus)    | Limitada (bus) | Buena (topologías jerárquicas) |

---

## 3. Simultaneous Multithreading (SMT) y Multithreading en CPU

### 3.1. Modelos de hardware multihilo

* **TMT (Temporal Multithreading)**

  * **FGMT (Fine-Grain MT):** cambia cada ciclo (round‐robin).
  * **CGMT (Coarse-Grain MT):** cambia al producirse evento (falla de cache, branch mispredict) o tras quantum.

* **SMT (Simultaneous MT)**

  * Varios hilos emiten instrucciones **simultáneamente** en un pipeline superescalar.

* **CMP (Chip Multi‐Processor)**

  * Múltiples núcleos físicos; cada uno con sus recursos (o compartiendo parte).

### 3.2. Recursos replicados vs. compartidos

| Recurso              | FGMT/CGMT          | SMT               | CMP                  |
| -------------------- | ------------------ | ----------------- | -------------------- |
| Registros            | Replicados         | Replicados        | Replicados           |
| Ejecución (ALUs, FP) | Multiplexadas      | Compartidas       | Dedicadas por núcleo |
| L1 I/D cache, TLB    | Multiplexados      | Compartidos parc. | Dedicados por núcleo |
| Política scheduling  | Round‐robin/evento | Dinámico (issue)  | N/A                  |

### 3.3. Ventajas e inconvenientes

* **FGMT/CGMT**

  * * Simple, evita que un hilo monopolice.
  * – Baja ILP aprovechable, overhead de context‐switch.
* **SMT**

  * * Mejor aprovechamiento de unidades funcionales.
  * – Contención de caché/L1, TLB, registros.
* **CMP**

  * * Escalabilidad, aislación.
  * – Área y consumo mayores.

---

## 4. LL/SC (Load-Linked / Store-Conditional)

### 4.1. Mecanismo y uso

1. **LL(addr):** lee valor de `addr`, vincula la “watch‐list” de la CPU.
2. **SC(addr, val):** intenta escribir `val` en `addr` **sólo si** no hubo otra escritura en `addr` desde el LL; devuelve éxito/fallo.

```c
// Incremento atómico con LL/SC
int atomic_inc(int *ptr) {
  int old, new;
  do {
    old = LL(ptr);
    new = old + 1;
  } while (!SC(ptr, new));
  return new;
}
```

### 4.2. Ventajas vs. CAS

| Característica | LL/SC                          | CAS (Compare-And-Swap)         |
| -------------- | ------------------------------ | ------------------------------ |
| ABA problem    | Evitado (SC falla si cambia)   | Puede ocurrir                  |
| Flexibilidad   | Permite operaciones compuestas | Sólo 1 palabra y 1 comparación |
| Overhead       | Watch‐list en hardware         | Instrucción única              |

### 4.3. Posibles preguntas de examen

1. **¿Qué pasa si entre LL y SC otro hilo escribe la misma dirección?**

   * SC detecta conflicto y falla → se repite LL/SC.
2. **¿Cómo construyes un spinlock con LL/SC?**

   ```c
   void lock(int *l) {
     while (1) {
       LL(l);
       if (SC(l, 1)) break;
     }
   }
   void unlock(int *l) { *l = 0; }
   ```
3. **¿Por qué SC puede fallar “espuriamente”?**

   * Interrupciones, eventos internos pueden invalidar la watch‐list.

---

## 5. Cerrojos (Locks) y Barreras

### 5.1. Tipos de locks

* **Spinlocks**

  * Busy‐wait hasta adquisición.
  * Ejemplo: Test-and-Set, TAS, TATAS.
* **Mutexes**

  * Blocking; el hilo se pone a dormir si no puede adquirir.
* **Adaptive locks**

  * Empiezan spin, luego bloquean si tardan mucho.
* **MCS lock** (cola enlazada)

  * Evita contención mediante cola FIFO.

### 5.2. Implementación básica con atomics

```c
// spinlock simple (TAS)
void lock(volatile int *l) {
  while (__atomic_exchange_n(l, 1, __ATOMIC_ACQUIRE)) { /* spin */ }
}
void unlock(volatile int *l) {
  __atomic_store_n(l, 0, __ATOMIC_RELEASE);
}
```

### 5.3. Barreras de sincronización

* **Centralizada**

  * Un contador y un mutex en el punto de encuentro.
* **Tree-based (distribuida)**

  * Reduce contención en barreras de gran escala.

```c
// Pseudocódigo barrera centralizada
barrier(int N) {
  atomic_inc(&count);
  if (count == N) {
    count = 0;
    wake_all();
  } else {
    wait();
  }
}
```

### 5.4. Preguntas de examen sobre barreras

1. **¿Cuál es la diferencia entre barrera centralizada y tree-based?**
2. **¿Cómo evitas el “thundering herd” en barreras?**
3. **Implementa una barrera reusable en C con atomics y CV.**

---

Con este material **detallado**, con tablas completas de transiciones, métricas de NUMA, casos de SMT, LL/SC y sincronización, estarás listo para afrontar cualquier pregunta del tema. ¡Éxito en tu estudio!
