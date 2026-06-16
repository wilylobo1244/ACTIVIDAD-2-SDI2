# Actividad Práctica 4: Arquitectura y Refinamiento

## "El Plano del Éxito"

**Materia:** Sistemas de Información II
**Proyecto:** SmartRoute DSS
**Caso:** FlashLogistics - El Caos de la Distribución
**Squad:** Cacatúas
**Integrantes:** Alex Saul Fernández Valdez; Wilber Perez Subelza
**Repositorio GitHub:** https://github.com/Alex-Fernandez-2003/Actividad-2-SDI-II.git
**GitHub Project / Kanban:** https://github.com/users/Alex-Fernandez-2003/projects/1/views/1
**Fecha:** 15 de junio de 2026

---

## 1. Introducción

La Actividad Práctica 4 tiene como objetivo transformar las historias críticas del MVP en modelos técnicos claros, utilizando UML como herramienta de arquitectura y refinamiento. En esta fase, el squad Cacatúas actúa como equipo de arquitectura de software para reducir la ambigüedad antes de programar.

El sistema trabajado es **SmartRoute DSS**, una solución de apoyo a la toma de decisiones para FlashLogistics. El MVP busca digitalizar la planificación de rutas, mejorar la trazabilidad de pedidos, reducir llamadas repetitivas al despacho y entregar información operativa mediante dashboards, alertas y KPIs.

---

## 2. Enlaces solicitados

| Elemento                | Enlace                                                          |
| ----------------------- | --------------------------------------------------------------- |
| Repositorio GitHub      | https://github.com/Alex-Fernandez-2003/Actividad-2-SDI-II.git   |
| GitHub Project / Kanban | https://github.com/users/Alex-Fernandez-2003/projects/1/views/1 |
| Carpeta de modelos UML  | `docs/uml/`                                                     |

---

## 3. Definition of Ready

La **Definition of Ready (DoR)** define los criterios mínimos que debe cumplir una Historia de Usuario antes de ingresar a un Sprint. Su objetivo es asegurar que el equipo no programe sobre ambigüedad.

| Nº  | Criterio DoR                                                                          | Cumple |
| --- | ------------------------------------------------------------------------------------- | ------ |
| 1   | La historia está redactada en formato: Como [rol], quiero [acción], para [beneficio]. | ☐      |
| 2   | La historia pertenece a una épica del MVP.                                            | ☐      |
| 3   | La historia tiene prioridad definida.                                                 | ☐      |
| 4   | La historia tiene estimación en Story Points.                                         | ☐      |
| 5   | La historia tiene criterios de aceptación claros y verificables.                      | ☐      |
| 6   | La historia cumple el criterio INVEST.                                                | ☐      |
| 7   | Los actores principales y secundarios están identificados.                            | ☐      |
| 8   | Los requisitos de datos o tablas necesarias están identificados.                      | ☐      |
| 9   | Las reglas de negocio principales están descritas.                                    | ☐      |
| 10  | Los flujos alternativos o errores esperados están identificados.                      | ☐      |
| 11  | Existe diagrama UML cuando la historia contiene lógica compleja.                      | ☐      |
| 12  | La historia considera seguridad, autorización y exposición mínima de datos.           | ☐      |
| 13  | La historia puede implementarse y probarse dentro de un Sprint.                       | ☐      |
| 14  | El Issue de GitHub contiene descripción, checklist y labels correspondientes.         | ☐      |

---

## 4. Modelo de Contexto del Sistema

El modelo de contexto define los límites de **SmartRoute DSS** y sus interacciones externas.

### Actores externos

- **Gerente de operaciones:** consulta KPIs, retrasos, alertas y estado general de la operación.
- **Despachador:** registra pedidos, planifica rutas, asigna conductor/vehículo y atiende incidencias.
- **Conductor:** consulta su ruta asignada y actualiza el estado de los pedidos.
- **Cliente empresa:** consulta el estado de su pedido mediante un portal o enlace de seguimiento.

### Sistemas o componentes externos

- **Base de datos operativa:** almacena pedidos, rutas, conductores, vehículos, estados, incidencias y alertas.
- **Servicio de mapas:** apoya la visualización o referencia de direcciones y rutas.
- **GitHub Projects:** permite gestionar el backlog, Issues, labels y evidencias del refinamiento.
- **Portal de seguimiento:** canal de consulta para clientes.

### UML relacionado

![Modelo de Contexto - SmartRoute DSS](./docs/uml/00-contexto-smartroute.png)

---

## 5. Historias críticas seleccionadas

Se seleccionaron tres historias críticas porque representan el núcleo del MVP y su relación con la toma de decisiones operativas.

| ID   | Historia crítica                             | Épica                         | Motivo de selección                                                       |
| ---- | -------------------------------------------- | ----------------------------- | ------------------------------------------------------------------------- |
| HU03 | Asignar pedidos a ruta, conductor y vehículo | Epic: Planificación de Rutas  | Es el centro de la planificación logística y reemplaza la pizarra manual. |
| HU05 | Actualizar estado de cada pedido             | Epic: Seguimiento y Cliente   | Alimenta la trazabilidad para operaciones y clientes.                     |
| HU08 | Recibir alertas de retrasos e incidencias    | Epic: Dashboard DSS y Alertas | Representa el soporte a la toma de decisiones del DSS.                    |

---

## 6. Refinamiento de historias críticas

## 6.1 HU03 - Asignar pedidos a ruta, conductor y vehículo

**Historia de Usuario:**
Como despachador, quiero asignar pedidos a una ruta, conductor y vehículo, para reemplazar la pizarra manual y preparar el despacho diario con mayor control.

**Actor principal:** Despachador
**Actores secundarios:** Conductor
**Épica:** Epic: Planificación de Rutas
**Prioridad:** Alta

### Lógica técnica

El despachador selecciona pedidos pendientes, define una ruta, asigna conductor y vehículo. El sistema valida que los pedidos no estén en otra ruta activa, que el conductor esté disponible y que el vehículo esté activo. Después registra la ruta, asocia los pedidos y deja la información disponible para el conductor.

### Requisitos de datos

- `pedidos`
- `rutas`
- `ruta_pedidos`
- `conductores`
- `vehiculos`
- `usuarios`
- `historial_estados`

### Criterios de aceptación

- [ ] La ruta contiene pedidos ordenados, conductor, vehículo y fecha de despacho.
- [ ] El sistema impide asignar un pedido que ya se encuentra en una ruta activa.
- [ ] El sistema impide asignar conductores o vehículos inactivos/no disponibles.
- [ ] La ruta queda visible para el conductor asignado desde su vista móvil.

### Flujos alternativos

- Pedido ya asignado a otra ruta activa.
- Conductor no disponible.
- Vehículo inactivo o en uso.
- Pedido sin dirección o ventana horaria.

### Impacto ODS

Aporta al **ODS 9** porque fortalece la infraestructura digital de la operación logística, reemplazando procesos manuales por planificación tecnológica.

### Diagramas UML

![HU03 - Casos de Uso](./docs/uml/HU03-casos-uso.png)

---

![HU03 - Secuencia](./docs/uml/HU03-secuencia.png)

---

## 6.2 HU05 - Actualizar estado de cada pedido

**Historia de Usuario:**
Como conductor, quiero actualizar el estado de cada pedido, para que operaciones y clientes conozcan el avance de la entrega.

**Actor principal:** Conductor
**Actores secundarios:** Despachador, Cliente empresa
**Épica:** Epic: Seguimiento y Cliente
**Prioridad:** Alta

### Lógica técnica

El conductor ingresa a su ruta asignada, selecciona un pedido y actualiza su estado. El sistema valida que el pedido pertenezca a su ruta, verifica que el estado sea permitido y exige observación cuando el estado sea Fallido o Incidencia. Luego registra el cambio, actualiza el pedido y refleja la información en el dashboard y en el portal de seguimiento.

### Requisitos de datos

- `pedidos`
- `rutas`
- `ruta_pedidos`
- `usuarios`
- `historial_estados`
- `incidencias`

### Criterios de aceptación

- [ ] Los estados disponibles son Pendiente, En ruta, Entregado, Fallido e Incidencia.
- [ ] Cada cambio registra fecha, hora y usuario responsable.
- [ ] Si el estado es Fallido o Incidencia, el sistema exige una observación.
- [ ] El cambio de estado se refleja en el dashboard operativo y en el portal de seguimiento.

### Flujos alternativos

- El pedido no pertenece a la ruta del conductor.
- El estado seleccionado no es válido.
- El conductor intenta registrar una incidencia sin observación.
- Existe falla de conexión y el cambio no puede sincronizarse.

### Impacto ODS

Aporta al **ODS 8** porque mejora la productividad operativa, reduce llamadas repetitivas y disminuye la sobrecarga del despacho.

### Diagramas UML

![HU05 - Casos de Uso](./docs/uml/HU05-casos-uso.png)

---

![HU05 - Secuencia](./docs/uml/HU05-secuencia.png)

---

## 6.3 HU08 - Recibir alertas de retrasos e incidencias

**Historia de Usuario:**
Como despachador, quiero recibir alertas de retrasos o incidencias, para priorizar la atención operativa.

**Actor principal:** Despachador
**Actores secundarios:** Gerente de operaciones
**Épica:** Epic: Dashboard DSS y Alertas
**Prioridad:** Media

### Lógica técnica

El sistema monitorea rutas y pedidos activos. Compara la hora estimada con la hora actual, identifica incidencias abiertas y genera alertas clasificadas por severidad. El despachador visualiza las alertas en el dashboard y puede priorizar la atención de los casos más críticos.

### Requisitos de datos

- `pedidos`
- `rutas`
- `conductores`
- `alertas`
- `incidencias`
- `historial_estados`

### Criterios de aceptación

- [ ] El sistema marca rutas con retraso y lista incidencias abiertas.
- [ ] Las alertas muestran pedido, ruta, conductor, hora y motivo.
- [ ] Las alertas se clasifican por severidad: baja, media y alta.
- [ ] Una alerta se cierra únicamente cuando el pedido cambia a Entregado o se registra una solución.

### Flujos alternativos

- No existen rutas activas para monitorear.
- Pedido sin hora estimada configurada.
- Incidencia duplicada para el mismo pedido.
- Error al consultar datos del dashboard.

### Impacto ODS

Aporta al **ODS 9** porque incorpora monitoreo digital y respuesta temprana. También aporta al **ODS 8** porque mejora la productividad del despacho y reduce decisiones reactivas.

### Diagramas UML

![HU08 - Casos de Uso](./docs/uml/HU08-casos-uso.png)

---

![HU08 - Secuencia](./docs/uml/HU08-secuencia.png)

---

## 7. Evidencia de integración en GitHub

Para cumplir con el entregable, se deben subir los archivos `.puml` y `.png` a la carpeta:

```txt
docs/uml/
```

Luego, en los Issues correspondientes, se deben insertar las imágenes o enlaces de los diagramas:

- Issue HU03: casos de uso y secuencia.
- Issue HU05: casos de uso y secuencia.
- Issue HU08: casos de uso y secuencia.

### Capturas requeridas

| Captura                 | Descripción                                   |
| ----------------------- | --------------------------------------------- |
| Captura del repositorio | Carpeta `docs/uml` con los diagramas subidos. |
| Captura del Issue HU03  | Issue con imágenes UML vinculadas.            |
| Captura del Issue HU05  | Issue con imágenes UML vinculadas.            |
| Captura del Issue HU08  | Issue con imágenes UML vinculadas.            |
| Captura del Kanban      | Tablero con las historias y labels de épica.  |

---

## 8. Reflexión técnica

El refinamiento mediante UML permite reducir la ambigüedad antes de programar. Al construir casos de uso y diagramas de secuencia, el equipo visualiza actores, responsabilidades, validaciones, objetos y mensajes antes de escribir código. Esto disminuye la carga cognitiva del desarrollador, evita supuestos ocultos y facilita que cada historia llegue al Sprint con una lógica verificable.

En SmartRoute DSS, esta práctica es especialmente importante porque el sistema apoya decisiones operativas reales: asignar rutas, actualizar estados y generar alertas requiere precisión, trazabilidad y coherencia entre datos, interfaz y reglas de negocio.

---

## 9. Conclusión

La Actividad 4 fortalece el MVP SmartRoute DSS al convertir historias críticas en modelos técnicos claros. La DoR asegura que las historias estén preparadas antes del desarrollo, el modelo de contexto delimita el sistema y los diagramas UML permiten anticipar la lógica central. Con esta base, el squad Cacatúas puede avanzar hacia una implementación más robusta, ética y eficiente.
