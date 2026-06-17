# Modelo de Persistencia y Diccionario de Datos

**Proyecto:** SmartRoute DSS  
**Caso:** FlashLogistics - El Caos de la Distribución  
**Squad:** Cacatúas  
**Repositorio:**  https://github.com/wilylobo1244/ACTIVIDAD-2-SDI2/tree/main/ACTIVIDAD_5

---

## 1. Objetivo del modelo de persistencia

El objetivo del modelo de persistencia es definir la estructura de datos que permitirá a SmartRoute DSS almacenar, relacionar y analizar información operativa de FlashLogistics.

El diseño debe soportar:

- Registro de pedidos.
- Planificación de rutas.
- Asignación de conductor y vehículo.
- Actualización de estados.
- Registro de incidencias.
- Generación de alertas.
- Cálculo de KPIs operativos.
- Trazabilidad para auditoría.
- Consultas para toma de decisiones.

---

## 2. Clases de persistencia

## 2.1 Clase `Usuario`

Representa a los usuarios autenticados del sistema.

### Atributos

| Visibilidad | Atributo    | Tipo         | Descripción                      |
| ----------- | ----------- | ------------ | -------------------------------- |
| `-`         | `id`        | `Long`       | Identificador único.             |
| `-`         | `nombre`    | `String`     | Nombre completo del usuario.     |
| `-`         | `email`     | `String`     | Correo único de acceso.          |
| `-`         | `rol`       | `RolUsuario` | Rol dentro del sistema.          |
| `-`         | `activo`    | `Boolean`    | Estado de disponibilidad lógica. |
| `-`         | `createdAt` | `DateTime`   | Fecha de creación.               |

### Métodos

| Visibilidad | Método          | Descripción                    |
| ----------- | --------------- | ------------------------------ |
| `+`         | `activar()`     | Activa el usuario.             |
| `+`         | `desactivar()`  | Desactiva el usuario.          |
| `+`         | `tieneRol(rol)` | Verifica autorización por rol. |

---

## 2.2 Clase `Conductor`

Representa al conductor encargado de ejecutar rutas.

### Atributos

| Visibilidad | Atributo     | Tipo              | Descripción                    |
| ----------- | ------------ | ----------------- | ------------------------------ |
| `-`         | `id`         | `Long`            | Identificador del conductor.   |
| `-`         | `usuarioId`  | `Long`            | Referencia al usuario base.    |
| `-`         | `telefono`   | `String`          | Teléfono de contacto.          |
| `-`         | `licencia`   | `String`          | Número de licencia.            |
| `-`         | `disponible` | `Boolean`         | Indica si puede recibir rutas. |
| `-`         | `estado`     | `EstadoConductor` | Activo, inactivo o suspendido. |

### Métodos

| Visibilidad | Método                 | Descripción                              |
| ----------- | ---------------------- | ---------------------------------------- |
| `+`         | `marcarDisponible()`   | Habilita al conductor para asignaciones. |
| `+`         | `marcarNoDisponible()` | Bloquea temporalmente asignaciones.      |
| `+`         | `puedeRecibirRuta()`   | Valida si está activo y disponible.      |

---

## 2.3 Clase `ClienteEmpresa`

Representa a las empresas clientes que solicitan entregas.

### Atributos

| Visibilidad | Atributo            | Tipo      | Descripción                |
| ----------- | ------------------- | --------- | -------------------------- |
| `-`         | `id`                | `Long`    | Identificador único.       |
| `-`         | `razonSocial`       | `String`  | Nombre legal o comercial.  |
| `-`         | `nit`               | `String`  | Identificación tributaria. |
| `-`         | `telefono`          | `String`  | Teléfono de contacto.      |
| `-`         | `email`             | `String`  | Correo de contacto.        |
| `-`         | `contactoPrincipal` | `String`  | Persona de contacto.       |
| `-`         | `activo`            | `Boolean` | Estado del cliente.        |

### Métodos

| Visibilidad | Método                  | Descripción                  |
| ----------- | ----------------------- | ---------------------------- |
| `+`         | `activar()`             | Activa al cliente.           |
| `+`         | `desactivar()`          | Desactiva al cliente.        |
| `+`         | `puedeRecibirPedidos()` | Verifica si está habilitado. |

---

## 2.4 Clase `Vehiculo`

Representa los vehículos de distribución.

### Atributos

| Visibilidad | Atributo      | Tipo             | Descripción                                    |
| ----------- | ------------- | ---------------- | ---------------------------------------------- |
| `-`         | `id`          | `Long`           | Identificador único.                           |
| `-`         | `placa`       | `String`         | Placa única del vehículo.                      |
| `-`         | `tipo`        | `String`         | Tipo de vehículo.                              |
| `-`         | `capacidadKg` | `Decimal`        | Capacidad referencial.                         |
| `-`         | `estado`      | `EstadoVehiculo` | Disponible, en ruta, mantenimiento o inactivo. |
| `-`         | `activo`      | `Boolean`        | Estado lógico.                                 |

### Métodos

| Visibilidad | Método                  | Descripción                             |
| ----------- | ----------------------- | --------------------------------------- |
| `+`         | `estaDisponible()`      | Verifica si puede asignarse a una ruta. |
| `+`         | `marcarEnRuta()`        | Cambia estado a en ruta.                |
| `+`         | `marcarMantenimiento()` | Cambia estado a mantenimiento.          |

---

## 2.5 Clase `Pedido`

Representa una solicitud de entrega.

### Atributos

| Visibilidad | Atributo              | Tipo              | Descripción                  |
| ----------- | --------------------- | ----------------- | ---------------------------- |
| `-`         | `id`                  | `Long`            | Identificador único.         |
| `-`         | `codigo`              | `String`          | Código único del pedido.     |
| `-`         | `clienteId`           | `Long`            | Cliente dueño del pedido.    |
| `-`         | `direccionEntrega`    | `String`          | Dirección de entrega.        |
| `-`         | `prioridad`           | `PrioridadPedido` | Baja, media o alta.          |
| `-`         | `ventanaInicio`       | `DateTime`        | Inicio de ventana horaria.   |
| `-`         | `ventanaFin`          | `DateTime`        | Fin de ventana horaria.      |
| `-`         | `estado`              | `EstadoPedido`    | Estado operativo del pedido. |
| `-`         | `horaEstimadaEntrega` | `DateTime`        | ETA planificada.             |
| `-`         | `horaEntregaReal`     | `DateTime`        | Hora real de entrega.        |

### Métodos

| Visibilidad | Método                       | Descripción                                    |
| ----------- | ---------------------------- | ---------------------------------------------- |
| `+`         | `cambiarEstado(nuevoEstado)` | Cambia el estado del pedido.                   |
| `+`         | `estaRetrasado()`            | Verifica retraso comparando ETA y hora actual. |
| `+`         | `requiereObservacion()`      | Determina si el estado exige observación.      |
| `+`         | `puedeAsignarseARuta()`      | Verifica si puede entrar a una ruta.           |

---

## 2.6 Clase `Ruta`

Representa una ruta de despacho planificada.

### Atributos

| Visibilidad | Atributo        | Tipo         | Descripción                                          |
| ----------- | --------------- | ------------ | ---------------------------------------------------- |
| `-`         | `id`            | `Long`       | Identificador único.                                 |
| `-`         | `codigo`        | `String`     | Código único de ruta.                                |
| `-`         | `fecha`         | `Date`       | Fecha de ejecución.                                  |
| `-`         | `conductorId`   | `Long`       | Conductor asignado.                                  |
| `-`         | `vehiculoId`    | `Long`       | Vehículo asignado.                                   |
| `-`         | `estado`        | `EstadoRuta` | Borrador, planificada, en ruta, cerrada o cancelada. |
| `-`         | `distanciaKm`   | `Decimal`    | Distancia planificada.                               |
| `-`         | `costoEstimado` | `Decimal`    | Costo estimado de ejecución.                         |

### Métodos

| Visibilidad | Método                        | Descripción               |
| ----------- | ----------------------------- | ------------------------- |
| `+`         | `asignarConductor(conductor)` | Asigna conductor.         |
| `+`         | `asignarVehiculo(vehiculo)`   | Asigna vehículo.          |
| `+`         | `agregarPedido(pedido)`       | Agrega pedido a la ruta.  |
| `+`         | `calcularCostoEstimado()`     | Calcula costo aproximado. |
| `+`         | `iniciarRuta()`               | Cambia estado a en ruta.  |
| `+`         | `cerrarRuta()`                | Cierra la ruta.           |

---

## 2.7 Clase `RutaPedido`

Representa el detalle ordenado de pedidos dentro de una ruta.

### Atributos

| Visibilidad | Atributo       | Tipo           | Descripción                      |
| ----------- | -------------- | -------------- | -------------------------------- |
| `-`         | `id`           | `Long`         | Identificador único.             |
| `-`         | `rutaId`       | `Long`         | Ruta asociada.                   |
| `-`         | `pedidoId`     | `Long`         | Pedido asociado.                 |
| `-`         | `ordenParada`  | `Integer`      | Orden de visita.                 |
| `-`         | `eta`          | `DateTime`     | Hora estimada por parada.        |
| `-`         | `horaLlegada`  | `DateTime`     | Hora real de llegada.            |
| `-`         | `estadoEnRuta` | `EstadoParada` | Pendiente, visitado o cancelado. |

### Métodos

| Visibilidad | Método                        | Descripción                                 |
| ----------- | ----------------------------- | ------------------------------------------- |
| `+`         | `actualizarOrden(nuevoOrden)` | Reordena la parada.                         |
| `+`         | `registrarLlegada(hora)`      | Registra llegada real.                      |
| `+`         | `estaFueraDeVentana()`        | Verifica incumplimiento de ventana horaria. |

---

## 2.8 Clase `HistorialEstado`

Registra auditoría de cambios de estado.

### Atributos

| Visibilidad | Atributo         | Tipo           | Descripción                    |
| ----------- | ---------------- | -------------- | ------------------------------ |
| `-`         | `id`             | `Long`         | Identificador único.           |
| `-`         | `pedidoId`       | `Long`         | Pedido relacionado.            |
| `-`         | `usuarioId`      | `Long`         | Usuario que ejecutó el cambio. |
| `-`         | `estadoAnterior` | `EstadoPedido` | Estado previo.                 |
| `-`         | `estadoNuevo`    | `EstadoPedido` | Estado actualizado.            |
| `-`         | `observacion`    | `String`       | Detalle del cambio.            |
| `-`         | `createdAt`      | `DateTime`     | Fecha y hora del cambio.       |

### Métodos

| Visibilidad | Método                  | Descripción                       |
| ----------- | ----------------------- | --------------------------------- |
| `+`         | `registrarCambio()`     | Persiste el cambio de estado.     |
| `+`         | `requiereObservacion()` | Verifica observación obligatoria. |

---

## 2.9 Clase `Incidencia`

Representa un problema operativo.

### Atributos

| Visibilidad | Atributo       | Tipo               | Descripción                               |
| ----------- | -------------- | ------------------ | ----------------------------------------- |
| `-`         | `id`           | `Long`             | Identificador único.                      |
| `-`         | `pedidoId`     | `Long`             | Pedido afectado.                          |
| `-`         | `rutaId`       | `Long`             | Ruta relacionada.                         |
| `-`         | `reportadoPor` | `Long`             | Usuario que reporta.                      |
| `-`         | `tipo`         | `TipoIncidencia`   | Tipo de problema.                         |
| `-`         | `descripcion`  | `String`           | Descripción de la incidencia.             |
| `-`         | `estado`       | `EstadoIncidencia` | Abierta, en atención, resuelta o cerrada. |

### Métodos

| Visibilidad | Método               | Descripción                    |
| ----------- | -------------------- | ------------------------------ |
| `+`         | `abrir()`            | Crea una incidencia.           |
| `+`         | `resolver(solucion)` | Registra solución.             |
| `+`         | `estaAbierta()`      | Verifica si requiere atención. |

---

## 2.10 Clase `Alerta`

Representa una señal DSS para priorizar atención.

### Atributos

| Visibilidad | Atributo       | Tipo           | Descripción                    |
| ----------- | -------------- | -------------- | ------------------------------ |
| `-`         | `id`           | `Long`         | Identificador único.           |
| `-`         | `pedidoId`     | `Long`         | Pedido relacionado.            |
| `-`         | `rutaId`       | `Long`         | Ruta relacionada.              |
| `-`         | `incidenciaId` | `Long`         | Incidencia relacionada.        |
| `-`         | `tipo`         | `TipoAlerta`   | Retraso, incidencia o sistema. |
| `-`         | `severidad`    | `Severidad`    | Baja, media o alta.            |
| `-`         | `motivo`       | `String`       | Motivo de la alerta.           |
| `-`         | `estado`       | `EstadoAlerta` | Abierta o cerrada.             |

### Métodos

| Visibilidad | Método                  | Descripción                    |
| ----------- | ----------------------- | ------------------------------ |
| `+`         | `clasificarSeveridad()` | Calcula severidad.             |
| `+`         | `cerrar()`              | Cierra la alerta.              |
| `+`         | `estaAbierta()`         | Verifica si requiere atención. |

---

## 2.11 Clase `KpiOperativo`

Representa métricas consolidadas para análisis.

### Atributos

| Visibilidad | Atributo            | Tipo      | Descripción                |
| ----------- | ------------------- | --------- | -------------------------- |
| `-`         | `id`                | `Long`    | Identificador único.       |
| `-`         | `fecha`             | `Date`    | Fecha del indicador.       |
| `-`         | `rutaId`            | `Long`    | Ruta relacionada.          |
| `-`         | `conductorId`       | `Long`    | Conductor relacionado.     |
| `-`         | `totalPedidos`      | `Integer` | Cantidad total de pedidos. |
| `-`         | `entregadosATiempo` | `Integer` | Pedidos puntuales.         |
| `-`         | `entregadosTarde`   | `Integer` | Pedidos retrasados.        |
| `-`         | `fallidos`          | `Integer` | Pedidos fallidos.          |
| `-`         | `incidencias`       | `Integer` | Total de incidencias.      |
| `-`         | `puntualidadPct`    | `Decimal` | Porcentaje de puntualidad. |

### Métodos

| Visibilidad | Método                  | Descripción                        |
| ----------- | ----------------------- | ---------------------------------- |
| `+`         | `calcularPuntualidad()` | Calcula porcentaje de puntualidad. |
| `+`         | `calcularFallidos()`    | Calcula cantidad de fallidos.      |
| `+`         | `generarResumen()`      | Genera resumen operativo.          |

---

## 3. Modelo relacional

## 3.1 Tabla `usuarios`

| Columna      | Tipo           | Restricciones                       | Descripción          |
| ------------ | -------------- | ----------------------------------- | -------------------- |
| `id`         | `BIGSERIAL`    | PK                                  | Identificador único. |
| `nombre`     | `VARCHAR(120)` | NOT NULL                            | Nombre completo.     |
| `email`      | `VARCHAR(160)` | NOT NULL, UNIQUE                    | Correo del usuario.  |
| `rol`        | `VARCHAR(30)`  | NOT NULL, CHECK                     | Rol del sistema.     |
| `activo`     | `BOOLEAN`      | NOT NULL, DEFAULT TRUE              | Estado lógico.       |
| `created_at` | `TIMESTAMP`    | NOT NULL, DEFAULT CURRENT_TIMESTAMP | Fecha de creación.   |

---

## 3.2 Tabla `conductores`

| Columna      | Tipo          | Restricciones                       | Descripción                  |
| ------------ | ------------- | ----------------------------------- | ---------------------------- |
| `id`         | `BIGSERIAL`   | PK                                  | Identificador del conductor. |
| `usuario_id` | `BIGINT`      | NOT NULL, UNIQUE, FK `usuarios(id)` | Usuario relacionado.         |
| `telefono`   | `VARCHAR(30)` | NULL                                | Teléfono.                    |
| `licencia`   | `VARCHAR(60)` | NOT NULL, UNIQUE                    | Licencia de conducir.        |
| `disponible` | `BOOLEAN`     | NOT NULL, DEFAULT TRUE              | Disponibilidad.              |
| `estado`     | `VARCHAR(30)` | NOT NULL, CHECK                     | Estado operativo.            |

---

## 3.3 Tabla `clientes_empresas`

| Columna              | Tipo           | Restricciones          | Descripción                |
| -------------------- | -------------- | ---------------------- | -------------------------- |
| `id`                 | `BIGSERIAL`    | PK                     | Identificador del cliente. |
| `razon_social`       | `VARCHAR(160)` | NOT NULL               | Nombre de empresa.         |
| `nit`                | `VARCHAR(40)`  | UNIQUE                 | Identificación tributaria. |
| `telefono`           | `VARCHAR(30)`  | NULL                   | Teléfono.                  |
| `email`              | `VARCHAR(160)` | NULL                   | Correo.                    |
| `contacto_principal` | `VARCHAR(120)` | NULL                   | Persona de contacto.       |
| `activo`             | `BOOLEAN`      | NOT NULL, DEFAULT TRUE | Estado lógico.             |

---

## 3.4 Tabla `vehiculos`

| Columna        | Tipo            | Restricciones             | Descripción                 |
| -------------- | --------------- | ------------------------- | --------------------------- |
| `id`           | `BIGSERIAL`     | PK                        | Identificador del vehículo. |
| `placa`        | `VARCHAR(20)`   | NOT NULL, UNIQUE          | Placa del vehículo.         |
| `tipo`         | `VARCHAR(60)`   | NOT NULL                  | Tipo de vehículo.           |
| `capacidad_kg` | `DECIMAL(10,2)` | CHECK `capacidad_kg >= 0` | Capacidad.                  |
| `estado`       | `VARCHAR(30)`   | NOT NULL, CHECK           | Estado operativo.           |
| `activo`       | `BOOLEAN`       | NOT NULL, DEFAULT TRUE    | Estado lógico.              |

---

## 3.5 Tabla `pedidos`

| Columna                 | Tipo            | Restricciones                        | Descripción                |
| ----------------------- | --------------- | ------------------------------------ | -------------------------- |
| `id`                    | `BIGSERIAL`     | PK                                   | Identificador del pedido.  |
| `codigo`                | `VARCHAR(40)`   | NOT NULL, UNIQUE                     | Código del pedido.         |
| `cliente_id`            | `BIGINT`        | NOT NULL, FK `clientes_empresas(id)` | Cliente dueño del pedido.  |
| `direccion_entrega`     | `VARCHAR(250)`  | NOT NULL                             | Dirección de entrega.      |
| `latitud`               | `DECIMAL(10,7)` | NULL                                 | Latitud referencial.       |
| `longitud`              | `DECIMAL(10,7)` | NULL                                 | Longitud referencial.      |
| `prioridad`             | `VARCHAR(20)`   | NOT NULL, CHECK                      | Baja, media o alta.        |
| `ventana_inicio`        | `TIMESTAMP`     | NULL                                 | Inicio de ventana horaria. |
| `ventana_fin`           | `TIMESTAMP`     | NULL                                 | Fin de ventana horaria.    |
| `estado`                | `VARCHAR(30)`   | NOT NULL, CHECK                      | Estado operativo.          |
| `hora_estimada_entrega` | `TIMESTAMP`     | NULL                                 | ETA.                       |
| `hora_entrega_real`     | `TIMESTAMP`     | NULL                                 | Hora real.                 |
| `observacion`           | `TEXT`          | NULL                                 | Observación general.       |
| `created_at`            | `TIMESTAMP`     | NOT NULL, DEFAULT CURRENT_TIMESTAMP  | Fecha de creación.         |

---

## 3.6 Tabla `rutas`

| Columna                | Tipo            | Restricciones                       | Descripción               |
| ---------------------- | --------------- | ----------------------------------- | ------------------------- |
| `id`                   | `BIGSERIAL`     | PK                                  | Identificador de la ruta. |
| `codigo`               | `VARCHAR(40)`   | NOT NULL, UNIQUE                    | Código de ruta.           |
| `fecha`                | `DATE`          | NOT NULL                            | Fecha de ejecución.       |
| `conductor_id`         | `BIGINT`        | NOT NULL, FK `conductores(id)`      | Conductor asignado.       |
| `vehiculo_id`          | `BIGINT`        | NOT NULL, FK `vehiculos(id)`        | Vehículo asignado.        |
| `estado`               | `VARCHAR(30)`   | NOT NULL, CHECK                     | Estado de ruta.           |
| `hora_inicio_estimada` | `TIMESTAMP`     | NULL                                | Inicio estimado.          |
| `hora_fin_estimada`    | `TIMESTAMP`     | NULL                                | Fin estimado.             |
| `distancia_km`         | `DECIMAL(10,2)` | CHECK `distancia_km >= 0`           | Distancia planificada.    |
| `costo_estimado`       | `DECIMAL(12,2)` | CHECK `costo_estimado >= 0`         | Costo estimado.           |
| `created_at`           | `TIMESTAMP`     | NOT NULL, DEFAULT CURRENT_TIMESTAMP | Fecha de creación.        |

---

## 3.7 Tabla `ruta_pedidos`

| Columna          | Tipo          | Restricciones                      | Descripción                |
| ---------------- | ------------- | ---------------------------------- | -------------------------- |
| `id`             | `BIGSERIAL`   | PK                                 | Identificador del detalle. |
| `ruta_id`        | `BIGINT`      | NOT NULL, FK `rutas(id)`           | Ruta asociada.             |
| `pedido_id`      | `BIGINT`      | NOT NULL, FK `pedidos(id)`         | Pedido asociado.           |
| `orden_parada`   | `INT`         | NOT NULL, CHECK `orden_parada > 0` | Orden de parada.           |
| `eta`            | `TIMESTAMP`   | NULL                               | Hora estimada de llegada.  |
| `hora_llegada`   | `TIMESTAMP`   | NULL                               | Hora real de llegada.      |
| `estado_en_ruta` | `VARCHAR(30)` | NOT NULL, CHECK                    | Estado de la parada.       |

### Restricciones adicionales

| Restricción                     | Descripción                                        |
| ------------------------------- | -------------------------------------------------- |
| `UNIQUE(ruta_id, pedido_id)`    | Evita duplicar el mismo pedido dentro de una ruta. |
| `UNIQUE(ruta_id, orden_parada)` | Evita repetir el mismo orden en una ruta.          |

---

## 3.8 Tabla `historial_estados`

| Columna           | Tipo          | Restricciones                       | Descripción                  |
| ----------------- | ------------- | ----------------------------------- | ---------------------------- |
| `id`              | `BIGSERIAL`   | PK                                  | Identificador del historial. |
| `pedido_id`       | `BIGINT`      | NOT NULL, FK `pedidos(id)`          | Pedido relacionado.          |
| `usuario_id`      | `BIGINT`      | NOT NULL, FK `usuarios(id)`         | Usuario responsable.         |
| `estado_anterior` | `VARCHAR(30)` | NULL                                | Estado previo.               |
| `estado_nuevo`    | `VARCHAR(30)` | NOT NULL, CHECK                     | Estado nuevo.                |
| `observacion`     | `TEXT`        | NULL                                | Observación del cambio.      |
| `created_at`      | `TIMESTAMP`   | NOT NULL, DEFAULT CURRENT_TIMESTAMP | Fecha del cambio.            |

---

## 3.9 Tabla `incidencias`

| Columna         | Tipo          | Restricciones                       | Descripción                  |
| --------------- | ------------- | ----------------------------------- | ---------------------------- |
| `id`            | `BIGSERIAL`   | PK                                  | Identificador de incidencia. |
| `pedido_id`     | `BIGINT`      | NOT NULL, FK `pedidos(id)`          | Pedido afectado.             |
| `ruta_id`       | `BIGINT`      | NULL, FK `rutas(id)`                | Ruta relacionada.            |
| `reportado_por` | `BIGINT`      | NOT NULL, FK `usuarios(id)`         | Usuario que reporta.         |
| `tipo`          | `VARCHAR(50)` | NOT NULL, CHECK                     | Tipo de incidencia.          |
| `descripcion`   | `TEXT`        | NOT NULL                            | Detalle del problema.        |
| `estado`        | `VARCHAR(30)` | NOT NULL, CHECK                     | Estado de atención.          |
| `created_at`    | `TIMESTAMP`   | NOT NULL, DEFAULT CURRENT_TIMESTAMP | Fecha de registro.           |
| `resuelta_at`   | `TIMESTAMP`   | NULL                                | Fecha de resolución.         |

---

## 3.10 Tabla `alertas`

| Columna         | Tipo          | Restricciones                       | Descripción                    |
| --------------- | ------------- | ----------------------------------- | ------------------------------ |
| `id`            | `BIGSERIAL`   | PK                                  | Identificador de alerta.       |
| `pedido_id`     | `BIGINT`      | NULL, FK `pedidos(id)`              | Pedido relacionado.            |
| `ruta_id`       | `BIGINT`      | NULL, FK `rutas(id)`                | Ruta relacionada.              |
| `incidencia_id` | `BIGINT`      | NULL, FK `incidencias(id)`          | Incidencia relacionada.        |
| `tipo`          | `VARCHAR(30)` | NOT NULL, CHECK                     | Retraso, incidencia o sistema. |
| `severidad`     | `VARCHAR(20)` | NOT NULL, CHECK                     | Baja, media o alta.            |
| `motivo`        | `TEXT`        | NOT NULL                            | Motivo de alerta.              |
| `estado`        | `VARCHAR(30)` | NOT NULL, CHECK                     | Abierta o cerrada.             |
| `created_at`    | `TIMESTAMP`   | NOT NULL, DEFAULT CURRENT_TIMESTAMP | Fecha de creación.             |
| `cerrada_at`    | `TIMESTAMP`   | NULL                                | Fecha de cierre.               |

---

## 3.11 Tabla `kpi_operativos`

| Columna               | Tipo            | Restricciones                       | Descripción                |
| --------------------- | --------------- | ----------------------------------- | -------------------------- |
| `id`                  | `BIGSERIAL`     | PK                                  | Identificador del KPI.     |
| `fecha`               | `DATE`          | NOT NULL                            | Fecha del indicador.       |
| `ruta_id`             | `BIGINT`        | NULL, FK `rutas(id)`                | Ruta relacionada.          |
| `conductor_id`        | `BIGINT`        | NULL, FK `conductores(id)`          | Conductor relacionado.     |
| `total_pedidos`       | `INT`           | NOT NULL, CHECK `>= 0`              | Pedidos totales.           |
| `entregados_a_tiempo` | `INT`           | NOT NULL, CHECK `>= 0`              | Pedidos puntuales.         |
| `entregados_tarde`    | `INT`           | NOT NULL, CHECK `>= 0`              | Pedidos retrasados.        |
| `fallidos`            | `INT`           | NOT NULL, CHECK `>= 0`              | Pedidos fallidos.          |
| `incidencias`         | `INT`           | NOT NULL, CHECK `>= 0`              | Incidencias totales.       |
| `puntualidad_pct`     | `DECIMAL(5,2)`  | CHECK `0 <= puntualidad_pct <= 100` | Porcentaje de puntualidad. |
| `costo_estimado`      | `DECIMAL(12,2)` | CHECK `>= 0`                        | Costo estimado.            |
| `created_at`          | `TIMESTAMP`     | NOT NULL, DEFAULT CURRENT_TIMESTAMP | Fecha de cálculo.          |

---

## 4. Reglas de integridad referencial

| Regla                                                        | Aplicación                                    |
| ------------------------------------------------------------ | --------------------------------------------- |
| Todo pedido pertenece a un cliente.                          | `pedidos.cliente_id` FK obligatoria.          |
| Toda ruta tiene conductor.                                   | `rutas.conductor_id` FK obligatoria.          |
| Toda ruta tiene vehículo.                                    | `rutas.vehiculo_id` FK obligatoria.           |
| Todo cambio de estado pertenece a un pedido.                 | `historial_estados.pedido_id` FK obligatoria. |
| Toda incidencia pertenece a un pedido.                       | `incidencias.pedido_id` FK obligatoria.       |
| Una alerta puede relacionarse con pedido, ruta o incidencia. | FKs opcionales en `alertas`.                  |
| Los KPIs pueden analizarse por ruta o conductor.             | FKs opcionales en `kpi_operativos`.           |

---

## 5. Dominios sugeridos

### `rol`

```txt
ADMIN, GERENTE, DESPACHADOR, CONDUCTOR
```

### `estado_pedido`

```txt
PENDIENTE, ASIGNADO, EN_RUTA, ENTREGADO, FALLIDO, INCIDENCIA
```

### `prioridad_pedido`

```txt
BAJA, MEDIA, ALTA
```

### `estado_ruta`

```txt
BORRADOR, PLANIFICADA, EN_RUTA, CERRADA, CANCELADA
```

### `estado_vehiculo`

```txt
DISPONIBLE, EN_RUTA, MANTENIMIENTO, INACTIVO
```

### `estado_conductor`

```txt
ACTIVO, INACTIVO, SUSPENDIDO
```

### `tipo_incidencia`

```txt
RETRASO, DIRECCION_INCORRECTA, CLIENTE_AUSENTE, FALLA_VEHICULO, OTRO
```

### `severidad_alerta`

```txt
BAJA, MEDIA, ALTA
```

### `estado_alerta`

```txt
ABIERTA, CERRADA
```

---

## 6. Consultas DSS que soporta el modelo

| Pregunta de decisión                                 | Tablas utilizadas                                 |
| ---------------------------------------------------- | ------------------------------------------------- |
| ¿Qué pedidos están retrasados?                       | `pedidos`, `ruta_pedidos`, `alertas`              |
| ¿Qué conductor tiene más entregas fallidas?          | `conductores`, `rutas`, `ruta_pedidos`, `pedidos` |
| ¿Qué rutas tienen más incidencias?                   | `rutas`, `incidencias`, `alertas`                 |
| ¿Qué cliente presenta más reclamos o retrasos?       | `clientes_empresas`, `pedidos`, `incidencias`     |
| ¿Qué alertas están abiertas y son de severidad alta? | `alertas`, `pedidos`, `rutas`                     |
| ¿Cuál es la puntualidad por conductor?               | `kpi_operativos`, `conductores`                   |
| ¿Qué rutas tienen mayor costo estimado?              | `rutas`, `kpi_operativos`                         |

---

## 7. Archivos derivados de este diseño

| Archivo                            | Propósito                                      |
| ---------------------------------- | ---------------------------------------------- |
| `diagrama-clases-persistencia.png` | Imagen renderizada del diagrama de clases.     |
| `modelo-relacional.md`             | Documentación del modelo relacional.           |
| `script-SQL.sql`                   | Script SQL inicial con tablas y restricciones. |
