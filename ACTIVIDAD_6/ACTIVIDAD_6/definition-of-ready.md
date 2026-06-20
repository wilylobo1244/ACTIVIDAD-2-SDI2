# 7. Definition of Ready

## 7.1 Propósito

La Definition of Ready define el estándar mínimo para que una historia de usuario pueda entrar al Sprint sin ambigüedad.

SmartSales DSS debe quedar en estado **Ready to Sprint**, por lo que cada historia debe tener suficiente claridad funcional, técnica y de negocio.

---

## 7.2 Checklist DoR

| Nº  | Criterio                                                                        | Estado |
| --- | ------------------------------------------------------------------------------- | ------ |
| 1   | La historia está redactada como: Como [rol], quiero [acción], para [beneficio]. | ☐      |
| 2   | La historia pertenece a una épica definida.                                     | ☐      |
| 3   | La historia tiene prioridad.                                                    | ☐      |
| 4   | La historia tiene estimación en Story Points.                                   | ☐      |
| 5   | La historia tiene criterios de aceptación claros y verificables.                | ☐      |
| 6   | La historia cumple INVEST.                                                      | ☐      |
| 7   | Los actores involucrados están identificados.                                   | ☐      |
| 8   | Las tablas o entidades necesarias están identificadas.                          | ☐      |
| 9   | Las reglas de negocio principales están definidas.                              | ☐      |
| 10  | Los flujos alternativos o errores esperados están identificados.                | ☐      |
| 11  | La historia está alineada con el MVP.                                           | ☐      |
| 12  | La historia aporta valor DSS o valor operativo directo.                         | ☐      |
| 13  | El diseño UML relacionado está disponible como imagen.                          | ☐      |
| 14  | El modelo relacional soporta la historia.                                       | ☐      |
| 15  | El Issue en GitHub contiene checklist de criterios de aceptación.               | ☐      |
| 16  | El Issue tiene labels de épica y prioridad.                                     | ☐      |
| 17  | La historia puede completarse dentro del sprint de 7 días.                      | ☐      |
| 18  | No existen bloqueos críticos para iniciar desarrollo.                           | ☐      |

---

## 7.3 Ready to Sprint

El proyecto se considera **Ready to Sprint** cuando:

- El contexto estratégico está documentado.
- El MVP está definido y acotado.
- El diagrama de clases de persistencia está generado como PNG.
- El diagrama de secuencia del dashboard está generado como PNG.
- El modelo relacional y diccionario de datos están completos.
- El script SQL inicial está disponible.
- El Product Backlog está priorizado.
- Las historias tienen criterios de aceptación.
- El tablero Kanban está preparado en GitHub Projects.
- El equipo sabe qué construir durante los 7 días.

---

## 7.4 Labels de GitHub

| Label                         | Uso                        |
| ----------------------------- | -------------------------- |
| `Epic: Catálogo e Inventario` | HU01, HU02, HU03           |
| `Epic: Ventas`                | HU04, HU05                 |
| `Epic: Dashboard DSS`         | HU06, HU07, HU08, HU10     |
| `Epic: Reportes`              | HU09                       |
| `type: user-story`            | Todas las HU               |
| `priority: high`              | Historias críticas         |
| `priority: medium`            | Historias importantes      |
| `mvp`                         | Alcance incluido en el MVP |

---

## 7.5 Columnas del Kanban

| Columna     | Descripción                         |
| ----------- | ----------------------------------- |
| Backlog     | Historias identificadas.            |
| Ready       | Historias que cumplen DoR.          |
| In Progress | Historias en desarrollo.            |
| Review / QA | Historias terminadas y en revisión. |
| Done        | Historias aceptadas.                |
