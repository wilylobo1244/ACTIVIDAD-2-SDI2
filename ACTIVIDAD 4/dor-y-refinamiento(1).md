# DoR y Plantilla de Refinamiento

**Proyecto:** SmartRoute DSS
**Caso:** FlashLogistics - El Caos de la Distribución
**Squad:** Cacatúas
**Integrantes:** Alex Saul Fernández Valdez; Wilber Perez Subelza
**Repositorio:** https://github.com/wilylobo1244/ACTIVIDAD-2-SDI2/edit/main/ACTIVIDAD%204/dor-y-refinamiento(1).md
**GitHub Project / Kanban:** https://github.com/wilylobo1244/ACTIVIDAD-2-SDI2/tree/main/ACTIVIDAD%204

---

## 1. Propósito del documento

Este documento define la **Definition of Ready (DoR)** del squad Cacatúas y presenta la plantilla de refinamiento aplicada a las tres historias críticas seleccionadas para la Actividad 4.

La finalidad es asegurar que cada historia llegue al Sprint con suficiente claridad técnica, criterios verificables, datos identificados, flujos alternativos y modelos UML asociados.

---

## 2. Definition of Ready del Squad

Una Historia de Usuario está lista para entrar al Sprint cuando cumple los siguientes criterios:

| Nº  | Criterio                                                                | Estado |
| --- | ----------------------------------------------------------------------- | ------ |
| 1   | Está escrita en formato: Como [rol], quiero [acción], para [beneficio]. | ☐      |
| 2   | Tiene una épica relacionada.                                            | ☐      |
| 3   | Tiene prioridad definida.                                               | ☐      |
| 4   | Tiene estimación en Story Points.                                       | ☐      |
| 5   | Tiene al menos 2 criterios de aceptación claros y verificables.         | ☐      |
| 6   | Cumple el criterio INVEST.                                              | ☐      |
| 7   | Tiene actor principal identificado.                                     | ☐      |
| 8   | Tiene actores secundarios identificados, si corresponde.                | ☐      |
| 9   | Tiene reglas de negocio principales descritas.                          | ☐      |
| 10  | Tiene requisitos de datos identificados.                                | ☐      |
| 11  | Tiene flujos alternativos o excepciones consideradas.                   | ☐      |
| 12  | Tiene diagrama de casos de uso si involucra interacción con actores.    | ☐      |
| 13  | Tiene diagrama de secuencia si involucra lógica compleja.               | ☐      |
| 14  | Considera autorización según rol.                                       | ☐      |
| 15  | Evita exponer datos sensibles innecesarios.                             | ☐      |
| 16  | Puede probarse dentro de un Sprint.                                     | ☐      |
| 17  | Está cargada como Issue en GitHub.                                      | ☐      |
| 18  | Tiene labels de épica, prioridad, tipo y MVP.                           | ☐      |

---

## 3. Plantilla de refinamiento

| Sección                 | Especificación                                        |
| ----------------------- | ----------------------------------------------------- |
| ID de Historia          | Código de la HU seleccionada                          |
| Épica relacionada       | Label de épica usado en GitHub                        |
| Historia de Usuario     | Formato Como [rol], quiero [acción], para [beneficio] |
| Actor principal         | Actor que inicia la interacción                       |
| Actores secundarios     | Otros actores relacionados                            |
| Valor de negocio        | Beneficio operativo o de decisión                     |
| Criterios de aceptación | Reglas verificables en checklist                      |
| Requisitos de datos     | Tablas, entidades o colecciones necesarias            |
| Lógica del algoritmo    | Explicación técnica del procesamiento                 |
| Flujos alternativos     | Validaciones, errores o excepciones relevantes        |
| Impacto ODS             | Relación con ODS 8 o ODS 9                            |
| UML requerido           | Casos de Uso y Secuencia                              |
| Evidencia GitHub        | Issue actualizado con enlaces o imágenes UML          |

---

## 4. Historias seleccionadas

| ID   | Historia                                     | Épica                         | Justificación                                                   |
| ---- | -------------------------------------------- | ----------------------------- | --------------------------------------------------------------- |
| HU03 | Asignar pedidos a ruta, conductor y vehículo | Epic: Planificación de Rutas  | Es la historia central para reemplazar la planificación manual. |
| HU05 | Actualizar estado de cada pedido             | Epic: Seguimiento y Cliente   | Permite trazabilidad operativa y comunicación con clientes.     |
| HU08 | Recibir alertas de retrasos e incidencias    | Epic: Dashboard DSS y Alertas | Representa la capacidad DSS de apoyar decisiones operativas.    |

---

## 5. Refinamiento HU03

### Datos generales

| Campo            | Detalle                                      |
| ---------------- | -------------------------------------------- |
| ID               | HU03                                         |
| Título           | Asignar pedidos a ruta, conductor y vehículo |
| Épica            | Epic: Planificación de Rutas                 |
| Actor principal  | Despachador                                  |
| Actor secundario | Conductor                                    |
| Prioridad        | Alta                                         |

### Historia de Usuario

Como despachador, quiero asignar pedidos a una ruta, conductor y vehículo, para reemplazar la pizarra manual y preparar el despacho diario con mayor control.

### Valor de negocio

Permite digitalizar la planificación diaria de rutas, reduciendo errores manuales, duplicidad de asignaciones y dependencia de pizarra o Excel.

### Criterios de aceptación

- [ ] La ruta contiene pedidos ordenados, conductor, vehículo y fecha de despacho.
- [ ] El sistema impide asignar un pedido que ya se encuentra en una ruta activa.
- [ ] El sistema impide asignar conductores o vehículos inactivos/no disponibles.
- [ ] La ruta queda visible para el conductor asignado desde su vista móvil.

### Requisitos de datos

- `pedidos`
- `rutas`
- `ruta_pedidos`
- `conductores`
- `vehiculos`
- `usuarios`
- `historial_estados`

### Lógica del algoritmo

1. El despachador selecciona pedidos pendientes.
2. El sistema valida que los pedidos no estén asignados a otra ruta activa.
3. El despachador selecciona conductor y vehículo.
4. El sistema valida disponibilidad de conductor y vehículo.
5. El sistema crea la ruta.
6. El sistema asocia los pedidos a la ruta.
7. El sistema cambia el estado de la ruta a planificada.
8. El conductor puede visualizar la ruta asignada.

### Flujos alternativos

- Si un pedido ya pertenece a una ruta activa, el sistema bloquea la asignación.
- Si el conductor está inactivo o no disponible, el sistema muestra error.
- Si el vehículo está inactivo o en uso, el sistema muestra error.
- Si faltan datos obligatorios, el sistema solicita completar la información.

### Impacto ODS

Aporta al **ODS 9: Industria, Innovación e Infraestructura**, porque fortalece la infraestructura digital del proceso logístico y reemplaza tareas manuales por planificación tecnológica.

### Diagramas UML

![HU03 - Casos de Uso](./docs/uml/HU03-casos-uso.png)

---

![HU03 - Secuencia](./docs/uml/HU03-secuencia.png)

---

## 6. Refinamiento HU05

### Datos generales

| Campo               | Detalle                          |
| ------------------- | -------------------------------- |
| ID                  | HU05                             |
| Título              | Actualizar estado de cada pedido |
| Épica               | Epic: Seguimiento y Cliente      |
| Actor principal     | Conductor                        |
| Actores secundarios | Despachador, Cliente empresa     |
| Prioridad           | Alta                             |

### Historia de Usuario

Como conductor, quiero actualizar el estado de cada pedido, para que operaciones y clientes conozcan el avance de la entrega.

### Valor de negocio

Permite que la operación tenga trazabilidad actualizada y que los clientes puedan consultar el avance sin llamar constantemente al despacho.

### Criterios de aceptación

- [ ] Los estados disponibles son Pendiente, En ruta, Entregado, Fallido e Incidencia.
- [ ] Cada cambio registra fecha, hora y usuario responsable.
- [ ] Si el estado es Fallido o Incidencia, el sistema exige una observación.
- [ ] El cambio de estado se refleja en el dashboard operativo y en el portal de seguimiento.

### Requisitos de datos

- `pedidos`
- `rutas`
- `ruta_pedidos`
- `usuarios`
- `historial_estados`
- `incidencias`

### Lógica del algoritmo

1. El conductor ingresa a su ruta asignada.
2. El sistema carga los pedidos de esa ruta.
3. El conductor selecciona un pedido.
4. El conductor elige un nuevo estado.
5. El sistema valida que el pedido pertenezca a la ruta del conductor.
6. El sistema valida que el estado sea permitido.
7. Si el estado es Fallido o Incidencia, el sistema exige una observación.
8. El sistema actualiza el estado del pedido.
9. El sistema registra el cambio en el historial.
10. El dashboard y el portal cliente muestran el nuevo estado.

### Flujos alternativos

- Si el pedido no pertenece al conductor, se bloquea el cambio.
- Si el estado no es válido, se muestra error.
- Si el estado requiere observación y no fue registrada, se impide guardar.
- Si hay falla de conexión, el sistema informa que no pudo sincronizar.

### Impacto ODS

Aporta al **ODS 8: Trabajo decente y crecimiento económico**, porque mejora la productividad operativa, reduce llamadas repetitivas y disminuye sobrecarga cognitiva del despacho.

### Diagramas UML

![HU05 - Casos de Uso](./docs/uml/HU05-casos-uso.png)

---

![HU05 - Secuencia](./docs/uml/HU05-secuencia.png)

---

## 7. Refinamiento HU08

### Datos generales

| Campo            | Detalle                                   |
| ---------------- | ----------------------------------------- |
| ID               | HU08                                      |
| Título           | Recibir alertas de retrasos e incidencias |
| Épica            | Epic: Dashboard DSS y Alertas             |
| Actor principal  | Despachador                               |
| Actor secundario | Gerente de operaciones                    |
| Prioridad        | Media                                     |

### Historia de Usuario

Como despachador, quiero recibir alertas de retrasos o incidencias, para priorizar la atención operativa.

### Valor de negocio

Convierte datos operativos en señales de decisión, permitiendo que el despacho actúe antes de que el retraso afecte gravemente al cliente.

### Criterios de aceptación

- [ ] El sistema marca rutas con retraso y lista incidencias abiertas.
- [ ] Las alertas muestran pedido, ruta, conductor, hora y motivo.
- [ ] Las alertas se clasifican por severidad: baja, media y alta.
- [ ] Una alerta se cierra únicamente cuando el pedido cambia a Entregado o se registra una solución.

### Requisitos de datos

- `pedidos`
- `rutas`
- `conductores`
- `alertas`
- `incidencias`
- `historial_estados`

### Lógica del algoritmo

1. El sistema consulta rutas activas.
2. El sistema consulta pedidos pendientes o en ruta.
3. El sistema compara hora estimada con hora actual.
4. El sistema consulta incidencias abiertas.
5. El sistema genera alertas por retraso o incidencia.
6. El sistema clasifica alertas por severidad.
7. El dashboard muestra las alertas al despachador.
8. El despachador revisa y prioriza la atención.
9. La alerta se cierra cuando el pedido se entrega o se registra solución.

### Flujos alternativos

- Si no existen rutas activas, el dashboard muestra estado vacío.
- Si un pedido no tiene hora estimada, no se genera alerta automática de retraso.
- Si ya existe una alerta abierta para el mismo pedido, no se duplica.
- Si ocurre error de consulta, el sistema muestra mensaje de fallo.

### Impacto ODS

Aporta al **ODS 9** porque incorpora monitoreo digital y respuesta temprana. También aporta al **ODS 8** porque mejora la eficiencia operativa y reduce decisiones improvisadas.

### Diagramas UML

![HU08 - Casos de Uso](./docs/uml/HU08-casos-uso.png)

---

![HU08 - Secuencia](./docs/uml/HU08-secuencia.png)

---

## 8. Checklist final de refinamiento

| Elemento                           | HU03 | HU05 | HU08 |
| ---------------------------------- | ---- | ---- | ---- |
| Historia en formato correcto       | ☐    | ☐    | ☐    |
| Criterios de aceptación claros     | ☐    | ☐    | ☐    |
| Actor principal identificado       | ☐    | ☐    | ☐    |
| Requisitos de datos definidos      | ☐    | ☐    | ☐    |
| Flujo principal definido           | ☐    | ☐    | ☐    |
| Flujos alternativos definidos      | ☐    | ☐    | ☐    |
| Diagrama de casos de uso creado    | ☐    | ☐    | ☐    |
| Diagrama de secuencia creado       | ☐    | ☐    | ☐    |
| Diagramas subidos a GitHub         | ☐    | ☐    | ☐    |
| Issue actualizado con imágenes UML | ☐    | ☐    | ☐    |
