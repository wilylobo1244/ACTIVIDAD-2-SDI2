# Actividad 8 - Sprint 1 Review & Reporte de Calidad

**Proyecto:** Home Fit AI  
**Squad:** Cacatúas  
**Repositorio:** https://github.com/wilylobo1244/ACTIVIDAD-2-SDI2/tree/main/ACTIVIDAD_8
**Rama de entrega:** `main`  
**Sprint:** Sprint 1  
**Historias incluidas:** HU05, HU01, HU02

---

## 1. Objetivo del informe

Este documento presenta la revisión del Sprint 1 y el reporte de calidad del incremento desarrollado para Home Fit AI. El sprint se enfocó en completar el flujo inicial del usuario autenticado: iniciar sesión, registrar datos básicos de consulta y seleccionar un objetivo principal.

El informe resume el incremento funcional, las historias completadas, las evidencias de calidad y la relación del trabajo con criterios ISO 25010 y prácticas Scrum.

---

## 2. Incremento funcional del Sprint 1

Durante el Sprint 1 se implementó un incremento simple pero funcional:

1. El usuario puede iniciar sesión.
2. El sistema identifica al usuario autenticado en backend mediante `user_id`.
3. Después del login, el usuario accede a la pantalla de creación de plan.
4. El usuario puede registrar edad, sexo, altura y peso.
5. El usuario puede seleccionar un objetivo principal desde una lista controlada.
6. El frontend conserva el botón de cerrar sesión.
7. El backend valida datos mediante endpoints protegidos.
8. Se generó documentación corta por historia en `docs/historias`.

---

## 3. Historias de Usuario completadas

| HU   | Nombre                              | Estado     | Documentación                                             |
| ---- | ----------------------------------- | ---------- | --------------------------------------------------------- |
| HU05 | Iniciar sesión                      | Completada | `docs/historias/HU05-iniciar-sesion.md`                   |
| HU01 | Registrar datos básicos de consulta | Completada | `docs/historias/HU01-registrar-datos-basicos-consulta.md` |
| HU02 | Registrar objetivo principal        | Completada | `docs/historias/HU02-registrar-objetivo-principal.md`     |

---

## 4. Sprint Review - Demo funcional

La demo en vivo debe mostrar el software real, no diapositivas. Secuencia impuesta:

1. Abrir la app Flutter.
2. Iniciar sesión con usuario de prueba.
3. Validar que se mantiene disponible el cierre de sesión.
4. Mostrar pantalla de creación de plan.
5. Registrar datos básicos: edad, sexo, altura y peso.
6. Validar errores de formulario.
7. Seleccionar objetivo principal.
8. Confirmar que el backend valida la información.
9. Mostrar evidencia de tests backend y frontend.
10. Mostrar documentación breve en `docs/historias`.

---

## 5. Tabla de evidencias de calidad

| Criterio                       | Evidencia en el proyecto                                         | Justificación                                                                       |
| ------------------------------ | ---------------------------------------------------------------- | ----------------------------------------------------------------------------------- |
| Adecuación funcional           | Issues HU05, HU01, HU02 y documentos en `docs/historias`         | Las historias completadas cumplen criterios de aceptación definidos.                |
| Mantenibilidad - Clean Code    | Pull Requests o commits de HU05, HU01 y HU02                     | Se trabajó con separación frontend/backend, repositorios, modelos, routers y tests. |
| Mantenibilidad - Documentación | `docs/historias/HU05...`, `HU01...`, `HU02...` y UML actualizado | Cada historia tiene documentación breve de motivo, alcance, pruebas y cumplimiento. |
| Fiabilidad / Integridad        | Tests backend y validaciones de payload                          | Los endpoints rechazan tokens inválidos y datos fuera de rango.                     |
| Transparencia ágil             | Kanban, issues y capturas de progreso                            | Las historias se gestionan con issues, labels y tablero.                            |
| Usabilidad                     | Capturas de la app Flutter                                       | El flujo posterior al login permite registrar datos y objetivo de forma guiada.     |

---

## 6. Evidencias

| Evidencia                           | Ruta                                         | Archivo                                              |
| ----------------------------------- | -------------------------------------------- | ---------------------------------------------------- |
| Login Flutter funcionando           | `capturas/HU-05-login.png`                   | `historias/HU05-iniciar-sesion.md`                   |
| Endpoint autenticado `/api/auth/me` | `capturas/HU-05-api-auth.png`                | `historias/HU05-iniciar-sesion.md`                   |
| Tests backend HU05                  | `capturas/HU-05-test-backend.png`            | `historias/HU05-iniciar-sesion.md`                   |
| Tests frontend HU05                 | `capturas/hu05-frontend-test.png`            | `historias/HU05-iniciar-sesion.md`                   |
| Formulario de datos básicos         | `capturas/hu01-formulario-datos-basicos.png` | `historias/HU01-registrar-datos-basicos-consulta.md` |
| Validación frontend HU01            | `capturas/hu01-validacion-frontend.png`      | `historias/HU01-registrar-datos-basicos-consulta.md` |
| Validación backend HU01             | `capturas/hu01-backend-validacion-ok.png`    | `historias/HU01-registrar-datos-basicos-consulta.md` |
| Selector de objetivo HU02           | `capturas/hu02-selector-objetivo.png`        | `historias/HU02-registrar-objetivo-principal.md`     |
| Validación objetivo HU02            | `capturas/hu02-validacion-objetivo.png`      | `historias/HU02-registrar-objetivo-principal.md`     |
| Tests HU02                          | `capturas/hu02-tests-frontend.png`           | `historias/HU02-registrar-objetivo-principal.md`     |

### 6.1 Imagenes sprint

#### Tablero Kanban

![Tablero en sprint 1 finalizado](./capturas/sprint1-kanban.png)

---

#### Pull Request

![](./capturas/sprint1-peer-review.png)

---

## 7. Cumplimiento de Definition of Done

| Criterio DoD                      | Cumplimiento                                                                                             |
| --------------------------------- | -------------------------------------------------------------------------------------------------------- |
| Historia implementada             | HU05, HU01 y HU02 completadas.                                                                           |
| Criterios de aceptación validados | Se validaron mediante tests y prueba manual.                                                             |
| Tests ejecutados                  | Backend con `pytest`; frontend con `flutter test`.                                                       |
| Documentación actualizada         | Documentos en `docs/historias`.                                                                          |
| Sin exposición de secretos        | Frontend usa `SUPABASE_URL` y `SUPABASE_ANON_KEY`; backend mantiene claves sensibles fuera del frontend. |
| Evidencia generada                | Capturas por historia y gestión ágil.                                                                    |

---

## 8. Reporte bajo ISO 25010

### 8.1 Adecuación funcional

El incremento cumple las funciones esperadas para el Sprint 1: login, identificación de usuario, registro de datos básicos y selección de objetivo principal. Las historias HU05, HU01 y HU02 cuentan con criterios de aceptación verificables y documentación individual.

### 8.2 Mantenibilidad

El desarrollo se organizó con separación de responsabilidades entre frontend Flutter y backend FastAPI. Cada HU cuenta con documentación corta y pruebas. Además, los diagramas UML y documentos del proyecto fueron actualizados para mantener congruencia con la implementación.

### 8.3 Fiabilidad

La fiabilidad se trabajó mediante validaciones en backend y frontend. El backend rechaza accesos no autenticados, tokens inválidos, datos fuera de rango y objetivos fuera de la lista controlada.

### 8.4 Seguridad

El frontend no recibe credenciales sensibles de base de datos. Solo utiliza la URL pública del proyecto y la anon/publishable key de Supabase para autenticación. Las claves privadas permanecen en el backend.

### 8.5 Usabilidad

La interfaz permite un flujo claro: iniciar sesión, registrar datos y seleccionar un objetivo. El formulario guiado reduce errores y prepara el camino para la generación de rutina personalizada.

### 8.6 Transparencia ágil

El trabajo se gestionó mediante issues, labels, tablero Kanban y evidencias por historia. Esto permite rastrear el avance y demostrar cumplimiento de la DoD.

---

## 9. Reflexión de impacto - ODS 8 y ODS 9

El incremento desarrollado aporta al ODS 8 porque mejora la productividad personal del usuario al ofrecer una herramienta que le ayuda a organizar su entrenamiento desde casa de forma más clara y guiada. También aporta al ODS 9 porque promueve innovación mediante una solución digital que combina frontend móvil, backend API, autenticación, validaciones y preparación para análisis DSS. Aunque el incremento aún es inicial, establece una base tecnológica para un sistema que puede apoyar decisiones personalizadas y reducir la dependencia de rutinas genéricas.

---

## 10. Conclusión

El Sprint 1 completó el primer flujo funcional posterior al Sprint 0. Home Fit AI ya permite autenticar usuarios, validar identidad en backend, registrar datos básicos de consulta y seleccionar un objetivo principal. El incremento es simple, pero suficiente para demostrar avance funcional, calidad técnica y trazabilidad documental.

Las siguientes historias podrán continuar con disponibilidad, restricciones específicas, límite semanal, generación con IA y persistencia definitiva en `routine_requests`.
