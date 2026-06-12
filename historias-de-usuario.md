# GitHub Issues listos para copiar - SmartRoute DSS

**Repositorio:** https://github.com/wilylobo1244/ACTIVIDAD-2-SDI2  
**Proyecto Kanban:** https://github.com/users/wilylobo1244/projects/1

---

## HU01 - Como despachador, quiero registrar pedidos con cliente, dirección, prioridad y ventana horaria

**Labels sugeridos:** `Epic: Pedidos y Recursos`, `type: user-story`, `mvp`, `priority: high`  
**Épica:** E01 - Gestión de Pedidos y Recursos  
**Prioridad:** Alta  
**Estimación:** 5 puntos

### Historia de Usuario

Como despachador, quiero registrar pedidos con cliente, dirección, prioridad y ventana horaria, para planificar correctamente las entregas del día.

### Criterios de Aceptación

- [ ] El sistema permite crear, editar y listar pedidos con cliente, dirección, prioridad, fecha y ventana horaria.
- [ ] Los campos obligatorios se validan antes de guardar y se muestra un mensaje claro si falta información.
- [ ] Cada pedido queda visible en el tablero operativo con estado inicial Pendiente.

### Checklist INVEST

- [ ] Independiente
- [ ] Negociable
- [ ] Valorable
- [ ] Estimable
- [ ] Pequeña
- [ ] Verificable

### Notas técnicas

- Debe mantenerse dentro del alcance MVP.
- Debe conectarse con el flujo operativo de SmartRoute DSS.
- La validación final se realizará contra los criterios de aceptación definidos.

---

## HU02 - Como administrador, quiero gestionar conductores

**Labels sugeridos:** `Epic: Pedidos y Recursos`, `type: user-story`, `mvp`, `priority: medium`  
**Épica:** E01 - Gestión de Pedidos y Recursos  
**Prioridad:** Media  
**Estimación:** 3 puntos

### Historia de Usuario

Como administrador, quiero gestionar conductores, para mantener actualizada la información operativa del equipo de reparto.

### Criterios de Aceptación

- [ ] El sistema permite crear, editar, desactivar y listar conductores.
- [ ] No se puede asignar una ruta a un conductor inactivo.
- [ ] Cada conductor muestra nombre, contacto, estado y disponibilidad.

### Checklist INVEST

- [ ] Independiente
- [ ] Negociable
- [ ] Valorable
- [ ] Estimable
- [ ] Pequeña
- [ ] Verificable

### Notas técnicas

- Debe mantenerse dentro del alcance MVP.
- Debe conectarse con el flujo operativo de SmartRoute DSS.
- La validación final se realizará contra los criterios de aceptación definidos.

---

## HU03 - Como administrador, quiero gestionar vehículos

**Labels sugeridos:** `Epic: Pedidos y Recursos`, `type: user-story`, `mvp`, `priority: medium`  
**Épica:** E01 - Gestión de Pedidos y Recursos  
**Prioridad:** Media  
**Estimación:** 3 puntos

### Historia de Usuario

Como administrador, quiero gestionar vehículos, para asignar recursos disponibles a las rutas planificadas.

### Criterios de Aceptación

- [ ] El sistema permite crear, editar, desactivar y listar vehículos.
- [ ] No se puede asignar una ruta a un vehículo inactivo o no disponible.
- [ ] Cada vehículo muestra placa, capacidad referencial, estado y observación operativa.

### Checklist INVEST

- [ ] Independiente
- [ ] Negociable
- [ ] Valorable
- [ ] Estimable
- [ ] Pequeña
- [ ] Verificable

### Notas técnicas

- Debe mantenerse dentro del alcance MVP.
- Debe conectarse con el flujo operativo de SmartRoute DSS.
- La validación final se realizará contra los criterios de aceptación definidos.

---

## HU04 - Como despachador, quiero crear rutas digitales agrupando pedidos

**Labels sugeridos:** `Epic: Planificación de Rutas`, `type: user-story`, `mvp`, `priority: high`  
**Épica:** E02 - Planificación y Asignación de Rutas  
**Prioridad:** Alta  
**Estimación:** 8 puntos

### Historia de Usuario

Como despachador, quiero crear rutas digitales agrupando pedidos, para reemplazar la planificación manual en pizarra y Excel.

### Criterios de Aceptación

- [ ] El sistema permite crear una ruta con nombre, fecha, pedidos asociados y orden de paradas.
- [ ] Un pedido no puede estar asignado simultáneamente a dos rutas activas.
- [ ] La ruta muestra cantidad de pedidos, conductor, vehículo y estado general.

### Checklist INVEST

- [ ] Independiente
- [ ] Negociable
- [ ] Valorable
- [ ] Estimable
- [ ] Pequeña
- [ ] Verificable

### Notas técnicas

- Debe mantenerse dentro del alcance MVP.
- Debe conectarse con el flujo operativo de SmartRoute DSS.
- La validación final se realizará contra los criterios de aceptación definidos.

---

## HU05 - Como despachador, quiero asignar conductor y vehículo a una ruta

**Labels sugeridos:** `Epic: Planificación de Rutas`, `type: user-story`, `mvp`, `priority: high`  
**Épica:** E02 - Planificación y Asignación de Rutas  
**Prioridad:** Alta  
**Estimación:** 5 puntos

### Historia de Usuario

Como despachador, quiero asignar conductor y vehículo a una ruta, para dejar preparado el despacho diario.

### Criterios de Aceptación

- [ ] El sistema solo permite seleccionar conductores y vehículos activos.
- [ ] Al guardar la asignación, la ruta cambia a estado Planificada.
- [ ] El conductor asignado puede visualizar la ruta desde su vista móvil.

### Checklist INVEST

- [ ] Independiente
- [ ] Negociable
- [ ] Valorable
- [ ] Estimable
- [ ] Pequeña
- [ ] Verificable

### Notas técnicas

- Debe mantenerse dentro del alcance MVP.
- Debe conectarse con el flujo operativo de SmartRoute DSS.
- La validación final se realizará contra los criterios de aceptación definidos.

---

## HU06 - Como despachador, quiero ordenar las paradas de una ruta según prioridad y ventana horaria

**Labels sugeridos:** `Epic: Planificación de Rutas`, `type: user-story`, `mvp`, `priority: medium`  
**Épica:** E02 - Planificación y Asignación de Rutas  
**Prioridad:** Media  
**Estimación:** 5 puntos

### Historia de Usuario

Como despachador, quiero ordenar las paradas de una ruta según prioridad y ventana horaria, para reducir retrasos en entregas críticas.

### Criterios de Aceptación

- [ ] El sistema permite reordenar paradas antes de iniciar la ruta.
- [ ] Los pedidos con prioridad alta se destacan visualmente en la planificación.
- [ ] Si una parada queda fuera de su ventana horaria, el sistema muestra una advertencia.

### Checklist INVEST

- [ ] Independiente
- [ ] Negociable
- [ ] Valorable
- [ ] Estimable
- [ ] Pequeña
- [ ] Verificable

### Notas técnicas

- Debe mantenerse dentro del alcance MVP.
- Debe conectarse con el flujo operativo de SmartRoute DSS.
- La validación final se realizará contra los criterios de aceptación definidos.

---

## HU07 - Como conductor, quiero ver mi ruta asignada desde el celular

**Labels sugeridos:** `Epic: Seguimiento y Cliente`, `type: user-story`, `mvp`, `priority: high`  
**Épica:** E03 - Seguimiento Operativo y Portal Cliente  
**Prioridad:** Alta  
**Estimación:** 5 puntos

### Historia de Usuario

Como conductor, quiero ver mi ruta asignada desde el celular, para ejecutar las entregas con instrucciones claras.

### Criterios de Aceptación

- [ ] La vista móvil muestra lista de paradas, cliente, dirección y observaciones del pedido.
- [ ] El conductor solo visualiza las rutas que le fueron asignadas.
- [ ] La pantalla debe ser usable en móvil y cargar la ruta en menos de 3 segundos en condiciones normales.

### Checklist INVEST

- [ ] Independiente
- [ ] Negociable
- [ ] Valorable
- [ ] Estimable
- [ ] Pequeña
- [ ] Verificable

### Notas técnicas

- Debe mantenerse dentro del alcance MVP.
- Debe conectarse con el flujo operativo de SmartRoute DSS.
- La validación final se realizará contra los criterios de aceptación definidos.

---

## HU08 - Como conductor, quiero actualizar el estado de cada pedido

**Labels sugeridos:** `Epic: Seguimiento y Cliente`, `type: user-story`, `mvp`, `priority: high`  
**Épica:** E03 - Seguimiento Operativo y Portal Cliente  
**Prioridad:** Alta  
**Estimación:** 5 puntos

### Historia de Usuario

Como conductor, quiero actualizar el estado de cada pedido, para que operaciones y clientes conozcan el avance de la entrega.

### Criterios de Aceptación

- [ ] Los estados disponibles son Pendiente, En ruta, Entregado, Fallido e Incidencia.
- [ ] Cada cambio de estado registra fecha, hora y usuario responsable.
- [ ] Cuando se marca Fallido o Incidencia, el sistema exige una observación.

### Checklist INVEST

- [ ] Independiente
- [ ] Negociable
- [ ] Valorable
- [ ] Estimable
- [ ] Pequeña
- [ ] Verificable

### Notas técnicas

- Debe mantenerse dentro del alcance MVP.
- Debe conectarse con el flujo operativo de SmartRoute DSS.
- La validación final se realizará contra los criterios de aceptación definidos.

---

## HU09 - Como cliente empresa, quiero consultar el estado de mi pedido mediante un enlace

**Labels sugeridos:** `Epic: Seguimiento y Cliente`, `type: user-story`, `mvp`, `priority: high`  
**Épica:** E03 - Seguimiento Operativo y Portal Cliente  
**Prioridad:** Alta  
**Estimación:** 5 puntos

### Historia de Usuario

Como cliente empresa, quiero consultar el estado de mi pedido mediante un enlace, para evitar llamar repetidamente al despacho.

### Criterios de Aceptación

- [ ] El portal muestra código de pedido, estado actual, fecha de entrega y ETA aproximada cuando exista.
- [ ] El enlace de consulta no permite modificar datos del pedido.
- [ ] El portal muestra un contacto de soporte si el pedido está retrasado o con incidencia.

### Checklist INVEST

- [ ] Independiente
- [ ] Negociable
- [ ] Valorable
- [ ] Estimable
- [ ] Pequeña
- [ ] Verificable

### Notas técnicas

- Debe mantenerse dentro del alcance MVP.
- Debe conectarse con el flujo operativo de SmartRoute DSS.
- La validación final se realizará contra los criterios de aceptación definidos.

---

## HU10 - Como gerente de operaciones, quiero visualizar los pedidos y rutas por estado

**Labels sugeridos:** `Epic: Dashboard DSS y Alertas`, `type: user-story`, `mvp`, `priority: high`  
**Épica:** E04 - Dashboard DSS, KPIs y Alertas  
**Prioridad:** Alta  
**Estimación:** 8 puntos

### Historia de Usuario

Como gerente de operaciones, quiero visualizar los pedidos y rutas por estado, para detectar retrasos y cuellos de botella durante el día.

### Criterios de Aceptación

- [ ] El dashboard muestra pedidos Pendientes, En ruta, Entregados, Retrasados, Fallidos e Incidencias.
- [ ] La información puede filtrarse por fecha, ruta, conductor y estado.
- [ ] El dashboard debe actualizarse al cambiar el estado de un pedido sin recargar manualmente la página.

### Checklist INVEST

- [ ] Independiente
- [ ] Negociable
- [ ] Valorable
- [ ] Estimable
- [ ] Pequeña
- [ ] Verificable

### Notas técnicas

- Debe mantenerse dentro del alcance MVP.
- Debe conectarse con el flujo operativo de SmartRoute DSS.
- La validación final se realizará contra los criterios de aceptación definidos.

---

## HU11 - Como gerente de operaciones, quiero ver KPIs de puntualidad por ruta, conductor y zona

**Labels sugeridos:** `Epic: Dashboard DSS y Alertas`, `type: user-story`, `mvp`, `priority: medium`  
**Épica:** E04 - Dashboard DSS, KPIs y Alertas  
**Prioridad:** Media  
**Estimación:** 8 puntos

### Historia de Usuario

Como gerente de operaciones, quiero ver KPIs de puntualidad por ruta, conductor y zona, para tomar decisiones de mejora basadas en datos.

### Criterios de Aceptación

- [ ] El reporte calcula porcentaje de puntualidad, entregas retrasadas, entregas fallidas e incidencias.
- [ ] Los KPIs pueden filtrarse por rango de fechas y conductor.
- [ ] El sistema identifica las rutas con mayor cantidad de retrasos para priorizar acciones.

### Checklist INVEST

- [ ] Independiente
- [ ] Negociable
- [ ] Valorable
- [ ] Estimable
- [ ] Pequeña
- [ ] Verificable

### Notas técnicas

- Debe mantenerse dentro del alcance MVP.
- Debe conectarse con el flujo operativo de SmartRoute DSS.
- La validación final se realizará contra los criterios de aceptación definidos.

---

## HU12 - Como despachador, quiero recibir alertas de retrasos e incidencias

**Labels sugeridos:** `Epic: Dashboard DSS y Alertas`, `type: user-story`, `mvp`, `priority: high`  
**Épica:** E04 - Dashboard DSS, KPIs y Alertas  
**Prioridad:** Alta  
**Estimación:** 5 puntos

### Historia de Usuario

Como despachador, quiero recibir alertas de retrasos e incidencias, para priorizar la atención operativa.

### Criterios de Aceptación

- [ ] El sistema marca visualmente las rutas con retraso o incidencia abierta.
- [ ] Las alertas muestran pedido, ruta, conductor, hora y motivo registrado.
- [ ] Una alerta puede cerrarse únicamente cuando el pedido cambia a Entregado o se registra una solución.

### Checklist INVEST

- [ ] Independiente
- [ ] Negociable
- [ ] Valorable
- [ ] Estimable
- [ ] Pequeña
- [ ] Verificable

### Notas técnicas

- Debe mantenerse dentro del alcance MVP.
- Debe conectarse con el flujo operativo de SmartRoute DSS.
- La validación final se realizará contra los criterios de aceptación definidos.

---
