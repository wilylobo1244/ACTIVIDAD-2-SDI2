# 08. Sprint 0 - Preparando la Fábrica de Software

## Home Fit AI

**Nombre provisional del proyecto:** Personal Home Exercises With AI  
**Nombre corto del producto:** Home Fit AI  
**Squad:** Cacatúas  
**Integrantes:** Alex Saul Fernandez Valdez, Wilber Perez Subelza  
**Repositorio:** https://github.com/wilylobo1244/ACTIVIDAD-2-SDI2/tree/main/ACTIVIDAD_7
**Materia:** Sistemas de Información II  
**Fase:** Inicio del marco de trabajo Scrum  
**Actividad:** Sprint 0 - Preparando la Fábrica de Software

---

# 1. Propósito del Sprint 0

El Sprint 0 de Home Fit AI tiene como propósito preparar la infraestructura técnica y organizativa necesaria antes de iniciar la construcción funcional del sistema.

En esta actividad no se busca implementar toda la lógica de negocio del producto. El objetivo es validar que la base técnica del proyecto funciona correctamente y que el squad cuenta con reglas claras de trabajo para iniciar el Sprint 1 con menor incertidumbre.

El Sprint 0 permite comprobar que:

- El repositorio está organizado.
- Existen ramas de trabajo claras.
- El tablero Kanban está configurado.
- El frontend puede comunicarse con el backend.
- El backend puede consultar la base de datos.
- El squad cuenta con DoR, DoD y acuerdos de trabajo.
- Existe una base mínima para iniciar el desarrollo del MVP.

---

# 2. Contexto del proyecto

Home Fit AI es un sistema de apoyo a decisiones para personas que desean ejercitarse desde casa sin contar con instructor personal.

El MVP permite que un usuario autenticado registre datos exactos de consulta como edad, sexo, peso, altura, objetivo, nivel de actividad, disponibilidad y restricciones generales. Con esos datos, el sistema solicita una rutina personalizada a una API de IA y guarda únicamente el resumen exacto de la consulta, sin almacenar la rutina completa generada.

El sistema también contempla un límite de **3 generaciones semanales por usuario autenticado**, con el fin de controlar el consumo de la API y mantener trazabilidad mínima.

---

# 3. Infraestructura en GitHub

## 3.1 Repositorio

**Repositorio del proyecto:**  
https://github.com/Alex-Fernandez-2003/Home-Fit-AI.git

## 3.2 Ramas principales

| Rama        | Propósito                 | Regla de uso                                             |
| ----------- | ------------------------- | -------------------------------------------------------- |
| `main`      | Rama estable o de entrega | Solo recibe cambios validados desde `develop`.           |
| `develop`   | Rama de integración       | Recibe funcionalidades terminadas mediante Pull Request. |
| `feature/*` | Ramas de funcionalidad    | Se crean desde `develop` para cada historia o tarea.     |
| `fix/*`     | Ramas de corrección       | Se usan para corregir errores detectados.                |
| `docs/*`    | Ramas de documentación    | Se usan para cambios en documentos, README o evidencias. |

## 3.3 Flujo base de ramas

```txt
main
 └── develop
      ├── feature/auth-login
      ├── feature/profile-form
      ├── feature/smoke-test
      ├── feature/routine-request
      └── docs/sprint-0
```

## 3.4 Comandos para configuración inicial

```bash
git clone https://github.com/Alex-Fernandez-2003/Home-Fit-AI.git
cd Home-Fit-AI

git checkout main
git pull origin main

git checkout -b develop
git push -u origin develop

git checkout -b docs/sprint-0
```

## 3.5 Estructura base del repositorio

```txt
Home-Fit-AI/
├── README.md
├── Docs/
│   ├── 01-contexto-y-diagnostico.md
│   ├── 02-mvp-y-propuesta-valor.md
│   ├── 03-product-backlog.md
│   ├── 04-dor-y-refinamiento.md
│   ├── 05-modelado-uml.md
│   ├── 06-arquitectura-datos.md
│   ├── 07-plan-ready-to-sprint.md
│   ├── 08-sprint-0-fabrica-software.md
|   └── informe-final.md
|   └── puml/
|     ├── arbol-problemas.puml
|     ├── arbol-soluciones.puml
|     ├── modelo-contexto.puml
|     ├── diagrama-clases.puml
|     ├── modelo-relacional.puml
|     ├── diagrama-secuencia.puml
|     ├── arquitectura-smoke-test-ui-api-db.puml
|     ├── casos-uso-historias-criticas.puml
|     ├── flujo-dashboard-dss.puml
|     └── flujo-git-sprint-0.puml
├── backend/
│   ├── README.md
│   └── src/
├── frontend/
│   ├── README.md
│   └── src/
└── database/
   └── script-inicial.sql
```

---

# 4. GitHub Projects - Tablero Kanban

## 4.1 Columnas del tablero

| Columna     | Uso                                                                      |
| ----------- | ------------------------------------------------------------------------ |
| Backlog     | Historias o tareas identificadas pero todavía no listas para desarrollo. |
| Ready       | Historias que cumplen la Definition of Ready.                            |
| In Progress | Historias o tareas actualmente trabajadas.                               |
| In Review   | Cambios terminados y enviados a revisión mediante Pull Request.          |
| Done        | Tareas terminadas que cumplen la Definition of Done.                     |

## 4.2 Labels

| Label                 | Uso                                        |
| --------------------- | ------------------------------------------ |
| `type: user-story`    | Historia de usuario.                       |
| `type: task`          | Tarea técnica u operativa.                 |
| `type: documentation` | Documentación o evidencia.                 |
| `priority: high`      | Prioridad alta.                            |
| `priority: medium`    | Prioridad media.                           |
| `priority: low`       | Prioridad baja.                            |
| `mvp`                 | Forma parte del MVP.                       |
| `sprint-0`            | Pertenece al Sprint 0.                     |
| `smoke-test`          | Relacionado con la prueba UI-API-DB.       |
| `backend`             | Relacionado con servidor/API.              |
| `frontend`            | Relacionado con interfaz.                  |
| `database`            | Relacionado con base de datos.             |
| `dashboard`           | Relacionado con indicadores DSS.           |
| `quality`             | Relacionado con DoD, pruebas o estándares. |

## 4.3 Issues sugeridos para Sprint 0

| Issue | Título                                          | Tipo          | Labels                                             | Columna inicial |
| ----: | ----------------------------------------------- | ------------- | -------------------------------------------------- | --------------- |
|     1 | Configurar ramas `main` y `develop`             | Tarea         | `type: task`, `sprint-0`, `quality`                | Ready           |
|     2 | Configurar tablero Kanban en GitHub Projects    | Tarea         | `type: task`, `sprint-0`, `documentation`          | Ready           |
|     3 | Subir estructura base del repositorio           | Tarea         | `type: task`, `sprint-0`, `documentation`          | Ready           |
|     4 | Ejecutar script inicial de base de datos        | Tarea         | `type: task`, `database`, `sprint-0`               | Ready           |
|     5 | Crear endpoint de Smoke Test en backend         | Tarea         | `type: task`, `backend`, `smoke-test`, `sprint-0`  | Ready           |
|     6 | Crear pantalla simple de Smoke Test en frontend | Tarea         | `type: task`, `frontend`, `smoke-test`, `sprint-0` | Ready           |
|     7 | Validar conexión UI → API → DB                  | Tarea         | `type: task`, `smoke-test`, `sprint-0`             | Ready           |
|     8 | Publicar DoD y DoR en README.md                 | Documentación | `type: documentation`, `quality`, `sprint-0`       | Ready           |
|     9 | Documentar acuerdos de trabajo del Squad        | Documentación | `type: documentation`, `quality`, `sprint-0`       | Ready           |
|    10 | Adjuntar capturas de evidencia Sprint 0         | Documentación | `type: documentation`, `sprint-0`                  | Backlog         |

---

# 5. Validación arquitectónica - Smoke Test

## 5.1 Objetivo del Smoke Test

El Smoke Test tiene como objetivo demostrar que la arquitectura base de Home Fit AI funciona correctamente.

La prueba debe comprobar el flujo:

```txt
Frontend → Backend/API → Base de datos relacional → Backend/API → Frontend
```

Si este flujo funciona, se valida que el sistema puede iniciar desarrollo funcional sobre una arquitectura conectada.

---

## 5.2 Alcance del Smoke Test

El Smoke Test no implementa todavía la generación real de rutina con IA. Solo valida que:

1. La interfaz puede hacer una petición al servidor.
2. El servidor puede consultar la base de datos.
3. La base de datos devuelve un dato real.
4. El servidor responde a la interfaz.
5. La interfaz muestra el resultado de forma visible.

---

## 5.3 Dato de prueba sugerido

Para que el Smoke Test coincida con el enfoque actual de Home Fit AI, se recomienda validar no solo la lectura de un ejercicio base, sino también la estructura de una restricción específica asociada al contexto de generación.

El objetivo del Smoke Test sigue siendo demostrar la conexión:

```txt
Frontend → Backend/API → Base de datos relacional → Backend/API → Frontend
```

Sin embargo, el dato de prueba debe representar mejor el flujo real del sistema:

1. El backend lee un ejercicio base desde `exercise_catalog`.
2. El backend lee o construye desde la base un contexto de restricción específica.
3. La interfaz muestra que ambos datos llegaron desde la capa de datos mediante el backend.

> Nota: en Sprint 0 no es necesario llamar todavía a la API de IA. El Smoke Test solo debe validar que la arquitectura puede transportar datos reales desde la base de datos hasta la interfaz.

### Ejercicio base de prueba

Se recomienda usar la tabla `exercise_catalog`.

| Campo               | Valor esperado     |
| ------------------- | ------------------ |
| `nombre`            | Flexiones de pared |
| `zona_principal`    | tren_superior      |
| `nivel_sugerido`    | principiante       |
| `objetivo_asociado` | ganar_fuerza       |

### Restricción específica de prueba

Se recomienda usar la tabla `routine_request_restrictions` cuando ya exista una consulta de prueba registrada, o una vista/consulta de Smoke Test preparada en la base de datos.

| Campo          | Valor esperado                                                          |
| -------------- | ----------------------------------------------------------------------- |
| `zona`         | tren_inferior                                                           |
| `detalle`      | Tobillo derecho recuperándose de un esguince                            |
| `precauciones` | Evitar saltos, impactos, apoyo inestable y cambios bruscos de dirección |
| `severidad`    | moderada                                                                |

Esta estructura permite que, más adelante, el prompt enviado a la IA no diga solamente:

```txt
Restricción: tren inferior
```

Sino algo más útil y específico:

```txt
Restricción declarada:
- Zona afectada: tren inferior.
- Detalle: tobillo derecho recuperándose de un esguince.
- Precauciones: evitar saltos, impactos, apoyo inestable y cambios bruscos de dirección.
- Severidad: moderada.

No realices diagnóstico médico. Usa esta información únicamente como criterio preventivo para evitar ejercicios que puedan agravar la restricción.
```

---

## 5.4 Endpoint sugerido

```txt
GET /api/smoke-test
```

Este endpoint no debe generar una rutina todavía. Su responsabilidad es comprobar que el backend puede leer datos reales desde la base de datos y devolverlos a la interfaz.

---

## 5.5 Respuesta esperada del backend

```json
{
  "status": "ok",
  "message": "Conexión UI-API-DB exitosa",
  "source": ["exercise_catalog", "routine_request_restrictions"],
  "data": {
    "exercise_example": {
      "nombre": "Flexiones de pared",
      "zona_principal": "tren_superior",
      "nivel_sugerido": "principiante",
      "objetivo_asociado": "ganar_fuerza"
    },
    "restriction_example": {
      "zona": "tren_inferior",
      "detalle": "Tobillo derecho recuperándose de un esguince",
      "precauciones": "Evitar saltos, impactos, apoyo inestable y cambios bruscos de dirección",
      "severidad": "moderada"
    },
    "prompt_context_preview": "Restricción declarada: zona tren_inferior; detalle: tobillo derecho recuperándose de un esguince; evitar saltos, impactos, apoyo inestable y cambios bruscos de dirección."
  }
}
```

---

## 5.6 Resultado esperado en interfaz

La interfaz debe mostrar un mensaje similar:

```txt
Smoke Test exitoso

La interfaz se conectó correctamente con el backend.
El backend leyó datos reales desde la base de datos.

Ejercicio base leído:
Flexiones de pared - tren_superior - principiante

Restricción específica leída:
Tren inferior - Tobillo derecho recuperándose de un esguince

Precauciones:
Evitar saltos, impactos, apoyo inestable y cambios bruscos de dirección.
```

---

## 5.7 Evidencia

| Evidencia                                                                                      | Archivo sugerido                         |
| ---------------------------------------------------------------------------------------------- | ---------------------------------------- |
| Captura de endpoint funcionando                                                                | `capturas/smoke-test-api.png`            |
| Captura de interfaz mostrando datos de DB                                                      | `capturas/smoke-test-ui-api-db.png`      |
| Captura de tabla `exercise_catalog` con dato de prueba                                         | `capturas/smoke-test-db-ejercicio.png`   |
| Captura de tabla `routine_request_restrictions` o vista de contexto con restricción específica | `capturas/smoke-test-db-restriccion.png` |

---

# 6. Arquitectura validada por el Smoke Test

## 6.1 Capas involucradas

| Capa           | Responsabilidad                                                                                            |
| -------------- | ---------------------------------------------------------------------------------------------------------- |
| Frontend       | Mostrar pantalla de prueba y consumir el endpoint `/api/smoke-test`.                                       |
| Backend/API    | Recibir petición, consultar DB, construir respuesta y devolver datos a la interfaz.                        |
| Base de datos  | Almacenar y devolver ejercicios base, consultas registradas y restricciones específicas.                   |
| Supabase Auth  | Permite identificar usuarios cuando el Smoke Test usa una consulta real asociada a un usuario autenticado. |
| Servicio de IA | No se usa en el Smoke Test, pero será parte del flujo real de generación en Sprint 1.                      |
| Dashboard DSS  | Se alimentará desde `routine_requests` y `routine_request_restrictions`.                                   |

## 6.2 Diagrama

El diagrama PUML correspondiente está en:

```txt
./puml/arquitectura-smoke-test-ui-api-db.puml
```

### Imagen

![Diagrama Smoke Test](./images/arquitectura-smoke-test-ui-api-db.png)

---

# 7. Definition of Ready del Squad

Una historia está lista para entrar al sprint cuando cumple:

| Criterio                                                             | Estado requerido           |
| -------------------------------------------------------------------- | -------------------------- |
| Historia redactada con formato correcto                              | Obligatorio                |
| Épica asignada                                                       | Obligatorio                |
| Prioridad definida                                                   | Obligatorio                |
| Estimación definida                                                  | Obligatorio                |
| Criterios de aceptación claros                                       | Obligatorio                |
| Reglas de negocio identificadas                                      | Obligatorio                |
| Datos necesarios identificados                                       | Obligatorio                |
| Actores identificados                                                | Obligatorio                |
| Flujos alternativos definidos                                        | Recomendado                |
| Dependencias identificadas                                           | Obligatorio                |
| Historia alineada al MVP                                             | Obligatorio                |
| Historia verificable                                                 | Obligatorio                |
| Historia suficientemente pequeña                                     | Obligatorio                |
| Sin bloqueos críticos                                                | Obligatorio                |
| Restricciones específicas identificadas si la historia genera rutina | Obligatorio cuando aplique |
| Estructura esperada de respuesta JSON definida si la historia usa IA | Obligatorio cuando aplique |

---

# 8. Definition of Done del Squad

Una historia o tarea se considera terminada cuando cumple:

| Criterio                          | Descripción                                                                                                         |
| --------------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| Cumple criterios de aceptación    | La funcionalidad cumple lo definido en la historia.                                                                 |
| Código integrado en rama correcta | El cambio fue integrado mediante Pull Request hacia `develop`.                                                      |
| Revisión realizada                | Al menos un integrante revisó el cambio antes de integrarlo.                                                        |
| Sin errores evidentes             | No existen errores visibles en el flujo trabajado.                                                                  |
| Validaciones aplicadas            | Se validan campos obligatorios, rangos y reglas de negocio.                                                         |
| Pruebas mínimas ejecutadas        | Se probaron casos principales y alternativos definidos.                                                             |
| Documentación actualizada         | README, docs o diagramas se actualizan si el cambio los afecta.                                                     |
| UML actualizado                   | Si cambia lógica, datos o interacción, se actualizan archivos `.puml`.                                              |
| Base de datos consistente         | Si cambia persistencia, se actualiza script o migración correspondiente.                                            |
| Seguridad considerada             | No se exponen claves, tokens, prompts completos ni credenciales de IA.                                              |
| Cumple enfoque de datos           | Se guarda la consulta, sus restricciones específicas y, si aplica, solo el JSON validado de la rutina generada.     |
| Restricciones respetadas          | Si el usuario declara restricciones específicas, la respuesta debe considerarlas y evitar ejercicios incompatibles. |
| Evidencia agregada                | Si corresponde, se agrega captura o nota de validación.                                                             |
| Issue actualizado                 | El issue se mueve a `Done` y queda trazabilidad del cambio.                                                         |

---

# 9. Acuerdos de trabajo del Squad

## 9.1 Daily Scrum

| Elemento         | Acuerdo                                         |
| ---------------- | ----------------------------------------------- |
| Frecuencia       | Diaria durante el sprint.                       |
| Duración máxima  | 10 a 15 minutos.                                |
| Horario sugerido | 20:00, hora Bolivia.                            |
| Canal            | Discord                                         |
| Preguntas guía   | ¿Qué hice ayer? ¿Qué haré hoy? ¿Tengo bloqueos? |

## 9.2 Roles operativos

| Rol                       | Responsable sugerido       | Responsabilidad                                          |
| ------------------------- | -------------------------- | -------------------------------------------------------- |
| Coordinación del squad    | Alex Saul Fernandez Valdez | Ordenar entregables, tablero y revisión general.         |
| Apoyo técnico/documental  | Wilber Perez Subelza       | Apoyar documentación, validación y revisión de tareas.   |
| Revisor de PR             | Alex Saul Fernandez Valdez | Revisar cambios antes de mezclar a `develop`.            |
| Responsable de evidencias | Alex Saul Fernandez Valdez | Tomar capturas y verificar que coincidan con la entrega. |

## 9.3 Flujo de Git

1. Toda nueva tarea inicia desde `develop`.
2. Se crea una rama específica por historia o tarea.
3. La rama debe usar prefijo claro:
   - `feature/`
   - `fix/`
   - `docs/`
   - `chore/`
4. Se realizan commits pequeños y descriptivos.
5. Se abre Pull Request hacia `develop`.
6. Otro integrante revisa el PR.
7. Si cumple DoD, se aprueba y se mezcla.
8. Al final del sprint, `develop` se integra a `main` si está estable.

## 9.4 Convención de nombres de ramas

| Tipo          | Ejemplo                        |
| ------------- | ------------------------------ |
| Funcionalidad | `feature/auth-login`           |
| Formulario    | `feature/profile-form`         |
| Smoke Test    | `feature/smoke-test-ui-api-db` |
| Documentación | `docs/sprint-0-report`         |
| Corrección    | `fix/weekly-limit-validation`  |

## 9.5 Convención de commits

Formato sugerido:

```txt
tipo: descripción breve
```

Ejemplos:

```txt
docs: agregar DoD y acuerdos del squad
feat: crear endpoint de smoke test
feat: mostrar dato de prueba desde la base de datos
fix: corregir validación de conexión a la base de datos
chore: configurar estructura base del proyecto
```

Tipos permitidos:

| Tipo       | Uso                                        |
| ---------- | ------------------------------------------ |
| `feat`     | Nueva funcionalidad.                       |
| `fix`      | Corrección de error.                       |
| `docs`     | Documentación.                             |
| `chore`    | Configuración o mantenimiento.             |
| `refactor` | Mejora interna sin cambiar comportamiento. |
| `test`     | Pruebas.                                   |

## 9.6 Estándares de codificación

| Elemento                    | Estándar                                                                                        |
| --------------------------- | ----------------------------------------------------------------------------------------------- |
| Variables y funciones       | `camelCase`                                                                                     |
| Clases, componentes o tipos | `PascalCase`                                                                                    |
| Tablas y columnas SQL       | `snake_case`                                                                                    |
| Ramas Git                   | `kebab-case` con prefijo                                                                        |
| Archivos Markdown           | `kebab-case.md`                                                                                 |
| Archivos PUML               | `kebab-case.puml`                                                                               |
| Mensajes al usuario         | Claros, breves y no técnicos                                                                    |
| Datos sensibles             | No exponer tokens, claves, prompts completos ni credenciales                                    |
| Persistencia                | Guardar datos exactos de consulta, restricciones específicas y JSON validado cuando corresponda |
| Restricciones físicas       | Guardar zona, detalle, precauciones y severidad; no diagnosticar condiciones médicas            |

---

# 10. Evidencias

| Evidencia                                           | Estado     | Archivo                                  |
| --------------------------------------------------- | ---------- | ---------------------------------------- |
| Enlace al repositorio                               | Disponible | Incluido en este documento               |
| Captura de ramas `main` y `develop`                 | Disponible | `capturas/ramas.png`                     |
| Captura del tablero Kanban                          | Disponible | `capturas/tablero-kanban.png`            |
| Captura de estructura base del proyecto             | Disponible | `capturas/estructura-base.png`           |
| Captura de issues creados                           | Disponible | `capturas/issues.png`                    |
| Captura de endpoint Smoke Test                      | Disponible | `capturas/smoke-test-api.png`            |
| Captura de UI mostrando dato de DB                  | Disponible | `capturas/smoke-test-ui-api-db.png`      |
| Captura de tabla con ejercicio base                 | Disponible | `capturas/smoke-test-db-ejercicio.png`   |
| Captura de tabla o vista con restricción específica | Disponible | `capturas/smoke-test-db-restriccion.png` |
| Captura de DoD/DoR en README                        | Disponible | `capturas/readme-dod-dor.png`            |

---

## 10.1 Capturas

### Captura de ramas `main` y `develop`

![Captura de ramas](./capturas/ramas.png)

---

### Captura del tablero Kanban

![Captura del tablero Kanban](./capturas/tablero-kanban.png)

---

### Captura de estructura base del proyecto

![Captura de estructura base del proyecto](./capturas/estructura-base.png)

---

### Captura de issues creados

![Captura de issues creados](./capturas/issues.png)

---

### Captura de endpoint Smoke Test

![Captura de endpoint Smoke Test](./capturas/smoke-test-api.png)

---

### Captura de UI mostrando dato de DB

![Captura de UI mostrando dato de DB](./capturas/smoke-test-ui-api-db.png)

---

### Captura de tabla con ejercicio base

![Captura de tabla con ejercicio base](./capturas/smoke-test-db-ejercicio.png)

---

### Captura de tabla o vista con restricción específica

![Captura de vista con restricción específica](./capturas/smoke-test-db-restriccion.png)

---

### Captura de DoD/DoR en README

![Captura de DoD/DoR en README de Github](./capturas/readme-dod-dor.png)

---

# 11. Conclusión

El Sprint 0 de Home Fit AI define la base operativa y técnica necesaria para iniciar la construcción del MVP. La preparación incluye infraestructura de GitHub, tablero Kanban, reglas de trabajo, Definition of Ready, Definition of Done y una validación arquitectónica mediante Smoke Test.

El Smoke Test propuesto permitirá demostrar que la interfaz puede leer datos desde el backend y que esos datos provienen realmente de la base de datos relacional. Además, el Smoke Test queda alineado con el flujo real del producto, ya que contempla ejercicios base y restricciones específicas que luego serán usadas para construir un prompt más seguro y personalizado.

Con esta validación, el squad podrá iniciar el Sprint 1 con menor incertidumbre técnica y con una fábrica de software básica preparada para el desarrollo.
