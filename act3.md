# T3
 

# Ejercicio 4: Lecturas/escrituras en paralelo

Tenemos dos hilos/procesos que ejecutan en paralelo este código (inicialmente `x=0`, `y=0`):

```plain
P1:                P2:
(1) x = 1;         (1) y = 1;
(2) x = 2;         (2) y = 2;
(3) print y;       (3) print x;
```

* Las variables `x,y` son **compartidas**.
* `r1,r2` (los resultados de los `print`) son **privados**.

---

## 1. ¿Qué es consistencia secuencial?

> **Consistencia secuencial** = todas las operaciones de cada hilo aparecen en un único listado global que respeta el orden de cada hilo (W→R, R→W, W→W, R→R).

**Implicación**: cada lectura ve sólo escrituras que “ya ocurrieron” en ese listado global.

---

## 2. Caso (a): multiprocesador con **consistencia secuencial**

* **Regla**: dentro de cada hilo, las escrituras (W) → luego la lectura (R) **no se reordenan**.
* Podemos intercalar (mezclar) los pasos de P1 y P2, pero siempre respetando el orden en cada uno.

### Escenarios clave

1. **P1 imprime primero**

   * Antes de su `print y`, P1 ya hizo `x=1; x=2`.
   * P2 podría haber hecho 0, 1 o 2 escrituras de `y`.
   * Por tanto, P1 ve `y ∈ {0,1,2}`.
   * Cuando luego P2 hace su `print x`, seguro que ve `x=2` (P1 ya hizo sus writes).

2. **P2 imprime primero**

   * Simétrico: P2 ve `x ∈ {0,1,2}`, luego P1 ve `y=2`.

### Resultados posibles (sólo estos 5)

| P1 → print y | P2 → print x |
| :----------: | :----------: |
|       0      |       2      |
|       1      |       2      |
|       2      |       2      |
|       2      |       0      |
|       2      |       1      |

---

## 3. ¿Qué es “relajar el orden W→R”?

* **Relax W→R**: las **lecturas** (`print`) pueden adelantarse sobre las escrituras anteriores **del mismo hilo**, porque hay un *write‐buffer*.
* Un hilo puede leer una variable **antes** de que sus propias escrituras al *buffer* se hayan propagado a la memoria.

---

## 4. Caso (b): sólo se garantiza todo **menos** W→R

* Se mantienen R→R, R→W y W→W, pero **no** W→R.
* **Consecuencia**: P1 puede hacer `print y` incluso antes de sus `x=1` o `x=2`; y P2 puede hacer `print x` antes de sus propios writes de `y`.

### Resultados posibles

Ahora **cualquier** par `(P1,P2)` con valores en `{0,1,2}` es posible:

| P1 print y | P2 print x |
| :--------: | :--------: |
|      0     |      0     |
|      0     |      1     |
|      0     |      2     |
|      1     |      0     |
|      1     |      1     |
|      1     |      2     |
|      2     |      0     |
|      2     |      1     |
|      2     |      2     |

> **Resumen “para dummies”**
>
> * **Caso (a)** (SC): las lecturas **no** se adelantan a tus propias escrituras → **5** combinaciones.
> * **Caso (b)** (relax W→R): las lecturas **sí** pueden adelantarse → **todas** las combinaciones 3×3 = **9**.

---

### ¿Cómo “verlo” paso a paso?

1. **Write‐buffer** interno de cada procesador:

   * Cuando haces `x=1; x=2`, se quedan en buffer; aún no son visibles globalmente.
2. Cuando haces `print y`:

   * Con SC, esperas a que el buffer se vacíe (tus writes se publiquen) antes de leer.
   * Con relax W→R, lees **directo** de memoria, sin esperar tu buffer.
3. Ídem para P2 con `y` y luego `print x`.

 
# T4

## Cuestión 1

**¿Qué tienen en común un procesador superescalar y uno VLIW? ¿En qué se diferencian?**

* **En común**

  * Ambos son procesadores segmentados (pipeline)
  * Aprovechan el paralelismo entre instrucciones (ILP)
  * Ejecutan varias instrucciones/operaciones escalares en paralelo

* **Diferencias**

  * **Superescalar**

    * Planificación **dinámica** de instrucciones en hardware
    * El hardware decide en tiempo de ejecución qué instrucciones lanzar según recursos libres
  * **VLIW**

    * Planificación **estática** realizada por el compilador
    * El compilador agrupa instrucciones en palabras muy largas, asumiendo recursos disponibles

---

## Cuestión 2

**¿Qué es un buffer de renombramiento? ¿Qué es un buffer de reordenamiento? ¿Existe relación?**

* **Buffer de renombramiento**

  * Recurso en procesadores superescalares
  * Asigna registros físicos temporales a registros arquitectónicos
  * Elimina riesgos WAW y WAR renombrando registros

* **Buffer de reordenamiento**

  * Permite la **finalización ordenada** de instrucciones tras su ejecución
  * Asegura que, aunque se ejecuten fuera de orden, se retire el resultado en orden programado

* **Relación**

  * El renombramiento de registros puede apoyarse en la estructura del buffer de reordenamiento

---

## Cuestión 3

**¿Qué es una ventana de instrucciones? ¿Y una estación de reserva? ¿Relación?**

* **Ventana de instrucciones**

  * Cola tras la decodificación
  * Emite instrucciones a unidades funcionales cuando:

    * La unidad está libre
    * Sus operandos están disponibles
  * Puede emitir **ordenado** o **desordenado**

* **Estación de reserva**

  * Subdivisión de la ventana en procesadores superescalares
  * Cada instrucción decodificada va a la estación correspondiente a su unidad funcional
  * Emisión → desde decodificación a estación; Envío → desde estación a unidad funcional

* **Relación**

  * Una ventana de instrucciones es un caso particular de estación de reserva con acceso a todas las unidades

---

## Cuestión 4

**¿Qué utilidad tiene la predicación de instrucciones? ¿Es exclusiva de los VLIW?**

* **Utilidad**

  * Elimina saltos condicionales
  * Reduce riesgos de control (branch hazards)
  * Aumenta el tamaño de bloques básicos

* **Exclusividad**

  * No es exclusiva de VLIW
  * Muy importante en VLIW para aumentar bloques básicos
  * También se usa en superescalares (e.g., el ISA ARM permite predicar casi todas las instrucciones)

---

## Cuestión 5

**¿Cuándo se lleva a cabo la predicción estática de saltos? ¿Se puede combinar con predicción dinámica?**

* **Predicción estática**

  * En tiempo de compilación
  * Basada en el sentido más probable del salto (bucles, etc.)

* **Combinación con dinámica**

  * Sí: en procesadores con predicción dinámica se usa estática para el **primer** encuentro de cada salto

---

## Cuestión 6

**¿Qué procesadores dependen más del compilador: superescalar o VLIW?**

* **Superescalar**

  * El compilador ayuda (reordenación, alineado, micro-ops en Intel P6…)
  * El hardware extrae ILP dinámicamente con estaciones de reserva, buffers, etc.

* **VLIW**

  * El compilador es **fundamental**: realiza por completo la planificación estática para ILP

---

## Cuestión 7

**¿Qué microarquitecturas tienen más complejidad hardware: superescalars o VLIW?
Indica un recurso presente en superescalar y no necesario en VLIW.**

* **Mayor complejidad**: **Superescalars**
* **Recurso típico de superescalar (no en VLIW)**

  * Estaciones de reserva
  * Buffers de renombramiento
  * Buffers de reordenamiento

---
