# Modelo Relacional - SmartRoute DSS

**Actividad:** Actividad Práctica 5 - Arquitectura de Persistencia  
**Proyecto:** SmartRoute DSS  
**Caso:** FlashLogistics - El Caos de la Distribución  
**Squad:** Cacatúas  
**Integrantes:** Alex Saul Fernández Valdez; Wilber Perez Subelza  
**Repositorio:** https://github.com/Alex-Fernandez-2003/Actividad-2-SDI-II.git  
**GitHub Project / Kanban:** https://github.com/users/Alex-Fernandez-2003/projects/1/views/1

---

## 1. Objetivo del modelo relacional

El objetivo del modelo relacional de **SmartRoute DSS** es transformar el modelo de clases de persistencia en una estructura de base de datos relacional, íntegra y útil para la toma de decisiones logísticas.

El diseño permite almacenar y relacionar información sobre:

- usuarios y roles operativos;
- conductores;
- vehículos;
- clientes empresa;
- pedidos;
- rutas;
- pedidos asignados a rutas;
- historial de estados;
- incidencias;
- alertas operativas;
- KPIs para soporte a decisiones.

Este modelo está alineado con las historias críticas refinadas en la Actividad 4:

| HU   | Historia                                     | Tablas principales                                             |
| ---- | -------------------------------------------- | -------------------------------------------------------------- |
| HU03 | Asignar pedidos a ruta, conductor y vehículo | `pedidos`, `rutas`, `ruta_pedidos`, `conductores`, `vehiculos` |
| HU05 | Actualizar estado de cada pedido             | `pedidos`, `historial_estados`, `incidencias`, `usuarios`      |
| HU08 | Recibir alertas de retrasos e incidencias    | `alertas`, `incidencias`, `pedidos`, `rutas`, `kpi_operativos` |

---

## 2. Vista general del esquema

```txt
usuarios
└── conductores

clientes_empresas
└── pedidos
    ├── ruta_pedidos ── rutas ── conductores
    │                  └── vehiculos
    ├── historial_estados ── usuarios
    ├── incidencias ── usuarios
    └── alertas

rutas
├── ruta_pedidos
├── incidencias
├── alertas
└── kpi_operativos

conductores
└── kpi_operativos
```

---

## 3. Entidades y propósito

| Tabla               | Propósito                                                                                |
| ------------------- | ---------------------------------------------------------------------------------------- |
| `usuarios`          | Almacena usuarios internos del sistema: administrador, gerente, despachador y conductor. |
| `conductores`       | Almacena datos específicos de conductores y su disponibilidad operativa.                 |
| `clientes_empresas` | Almacena empresas clientes que solicitan entregas.                                       |
| `vehiculos`         | Almacena vehículos disponibles para rutas de distribución.                               |
| `pedidos`           | Almacena entregas solicitadas por clientes empresa.                                      |
| `rutas`             | Almacena rutas planificadas con conductor y vehículo asignados.                          |
| `ruta_pedidos`      | Relaciona rutas con pedidos y define el orden de paradas.                                |
| `historial_estados` | Registra auditoría de cambios de estado de pedidos.                                      |
| `incidencias`       | Registra problemas operativos durante la entrega.                                        |
| `alertas`           | Almacena señales DSS para priorizar retrasos, incidencias o eventos críticos.            |
| `kpi_operativos`    | Almacena métricas consolidadas para análisis de desempeño operativo.                     |

---

## 4. Relaciones y cardinalidades

| Relación                         | Cardinalidad | Tipo                   | Regla de negocio                                                                 |
| -------------------------------- | -----------: | ---------------------- | -------------------------------------------------------------------------------- |
| `usuarios` → `conductores`       |     1 : 0..1 | Especialización lógica | Un conductor es también un usuario del sistema.                                  |
| `clientes_empresas` → `pedidos`  |    1 : 0..\* | Asociación             | Un cliente puede tener muchos pedidos; un pedido pertenece a un cliente.         |
| `conductores` → `rutas`          |    1 : 0..\* | Asociación             | Un conductor puede ejecutar muchas rutas a lo largo del tiempo.                  |
| `vehiculos` → `rutas`            |    1 : 0..\* | Asociación             | Un vehículo puede ser usado en muchas rutas históricas.                          |
| `rutas` → `ruta_pedidos`         |    1 : 1..\* | Composición lógica     | Una ruta contiene paradas; las paradas no tienen sentido sin la ruta.            |
| `pedidos` → `ruta_pedidos`       |    1 : 0..\* | Asociación             | Un pedido puede aparecer en detalle de ruta, respetando reglas de rutas activas. |
| `pedidos` → `historial_estados`  |    1 : 0..\* | Composición lógica     | El historial explica la evolución de un pedido.                                  |
| `usuarios` → `historial_estados` |    1 : 0..\* | Asociación             | Todo cambio de estado debe registrar responsable.                                |
| `pedidos` → `incidencias`        |    1 : 0..\* | Asociación             | Un pedido puede generar incidencias.                                             |
| `rutas` → `incidencias`          | 0..1 : 0..\* | Asociación             | Una incidencia puede estar asociada a una ruta.                                  |
| `usuarios` → `incidencias`       |    1 : 0..\* | Asociación             | Toda incidencia debe registrar quién la reportó.                                 |
| `pedidos` → `alertas`            | 0..1 : 0..\* | Asociación             | Un pedido puede disparar alertas.                                                |
| `rutas` → `alertas`              | 0..1 : 0..\* | Asociación             | Una ruta puede tener alertas operativas.                                         |
| `incidencias` → `alertas`        | 0..1 : 0..\* | Asociación             | Una incidencia puede originar alertas.                                           |
| `rutas` → `kpi_operativos`       | 0..1 : 0..\* | Asociación analítica   | Una ruta puede tener KPIs consolidados.                                          |
| `conductores` → `kpi_operativos` | 0..1 : 0..\* | Asociación analítica   | Un conductor puede tener KPIs por fecha/ruta.                                    |

---

## 5. Diccionario relacional detallado

## 5.1 Tabla `usuarios`

| Columna        | Tipo           | Restricciones                          | Descripción                             |
| -------------- | -------------- | -------------------------------------- | --------------------------------------- |
| `id`           | `UUID`         | PK, DEFAULT `gen_random_uuid()`        | Identificador único del usuario.        |
| `auth_user_id` | `UUID`         | UNIQUE, FK `auth.users(id)`, NULL      | Vinculación opcional con Supabase Auth. |
| `nombre`       | `VARCHAR(120)` | NOT NULL                               | Nombre completo.                        |
| `email`        | `VARCHAR(160)` | NOT NULL, UNIQUE, CHECK formato básico | Correo electrónico.                     |
| `rol`          | `rol_usuario`  | NOT NULL                               | Rol interno del sistema.                |
| `activo`       | `BOOLEAN`      | NOT NULL, DEFAULT TRUE                 | Estado lógico del usuario.              |
| `created_at`   | `TIMESTAMPTZ`  | NOT NULL, DEFAULT NOW()                | Fecha de creación.                      |
| `updated_at`   | `TIMESTAMPTZ`  | NOT NULL, DEFAULT NOW()                | Fecha de última actualización.          |

### Dominio `rol_usuario`

```txt
ADMIN, GERENTE, DESPACHADOR, CONDUCTOR
```

---

## 5.2 Tabla `conductores`

| Columna      | Tipo               | Restricciones                       | Descripción                    |
| ------------ | ------------------ | ----------------------------------- | ------------------------------ |
| `id`         | `UUID`             | PK, DEFAULT `gen_random_uuid()`     | Identificador del conductor.   |
| `usuario_id` | `UUID`             | NOT NULL, UNIQUE, FK `usuarios(id)` | Usuario asociado al conductor. |
| `telefono`   | `VARCHAR(30)`      | NULL                                | Teléfono del conductor.        |
| `licencia`   | `VARCHAR(60)`      | NOT NULL, UNIQUE                    | Licencia de conducción.        |
| `disponible` | `BOOLEAN`          | NOT NULL, DEFAULT TRUE              | Indica si puede recibir ruta.  |
| `estado`     | `estado_conductor` | NOT NULL, DEFAULT `ACTIVO`          | Estado operativo.              |
| `created_at` | `TIMESTAMPTZ`      | NOT NULL, DEFAULT NOW()             | Fecha de creación.             |
| `updated_at` | `TIMESTAMPTZ`      | NOT NULL, DEFAULT NOW()             | Fecha de actualización.        |

### Dominio `estado_conductor`

```txt
ACTIVO, INACTIVO, SUSPENDIDO
```

---

## 5.3 Tabla `clientes_empresas`

| Columna              | Tipo           | Restricciones                   | Descripción                        |
| -------------------- | -------------- | ------------------------------- | ---------------------------------- |
| `id`                 | `UUID`         | PK, DEFAULT `gen_random_uuid()` | Identificador del cliente empresa. |
| `razon_social`       | `VARCHAR(160)` | NOT NULL                        | Nombre legal o comercial.          |
| `nit`                | `VARCHAR(40)`  | UNIQUE, NULL                    | Identificación tributaria.         |
| `telefono`           | `VARCHAR(30)`  | NULL                            | Teléfono de contacto.              |
| `email`              | `VARCHAR(160)` | NULL, CHECK formato básico      | Correo de contacto.                |
| `contacto_principal` | `VARCHAR(120)` | NULL                            | Persona de contacto.               |
| `activo`             | `BOOLEAN`      | NOT NULL, DEFAULT TRUE          | Estado lógico.                     |
| `created_at`         | `TIMESTAMPTZ`  | NOT NULL, DEFAULT NOW()         | Fecha de creación.                 |
| `updated_at`         | `TIMESTAMPTZ`  | NOT NULL, DEFAULT NOW()         | Fecha de actualización.            |

---

## 5.4 Tabla `vehiculos`

| Columna        | Tipo              | Restricciones                     | Descripción                 |
| -------------- | ----------------- | --------------------------------- | --------------------------- |
| `id`           | `UUID`            | PK, DEFAULT `gen_random_uuid()`   | Identificador del vehículo. |
| `placa`        | `VARCHAR(20)`     | NOT NULL, UNIQUE                  | Placa del vehículo.         |
| `tipo`         | `VARCHAR(60)`     | NOT NULL                          | Tipo de vehículo.           |
| `capacidad_kg` | `NUMERIC(10,2)`   | NOT NULL, DEFAULT 0, CHECK `>= 0` | Capacidad referencial.      |
| `estado`       | `estado_vehiculo` | NOT NULL, DEFAULT `DISPONIBLE`    | Estado operativo.           |
| `activo`       | `BOOLEAN`         | NOT NULL, DEFAULT TRUE            | Estado lógico.              |
| `created_at`   | `TIMESTAMPTZ`     | NOT NULL, DEFAULT NOW()           | Fecha de creación.          |
| `updated_at`   | `TIMESTAMPTZ`     | NOT NULL, DEFAULT NOW()           | Fecha de actualización.     |

### Dominio `estado_vehiculo`

```txt
DISPONIBLE, EN_RUTA, MANTENIMIENTO, INACTIVO
```

---

## 5.5 Tabla `pedidos`

| Columna                 | Tipo               | Restricciones                        | Descripción                     |
| ----------------------- | ------------------ | ------------------------------------ | ------------------------------- |
| `id`                    | `UUID`             | PK, DEFAULT `gen_random_uuid()`      | Identificador del pedido.       |
| `codigo`                | `VARCHAR(40)`      | NOT NULL, UNIQUE                     | Código único del pedido.        |
| `cliente_id`            | `UUID`             | NOT NULL, FK `clientes_empresas(id)` | Cliente propietario del pedido. |
| `direccion_entrega`     | `VARCHAR(250)`     | NOT NULL                             | Dirección de entrega.           |
| `latitud`               | `NUMERIC(10,7)`    | NULL, CHECK entre -90 y 90           | Coordenada de referencia.       |
| `longitud`              | `NUMERIC(10,7)`    | NULL, CHECK entre -180 y 180         | Coordenada de referencia.       |
| `prioridad`             | `prioridad_pedido` | NOT NULL, DEFAULT `MEDIA`            | Prioridad del pedido.           |
| `ventana_inicio`        | `TIMESTAMPTZ`      | NULL                                 | Inicio de ventana horaria.      |
| `ventana_fin`           | `TIMESTAMPTZ`      | NULL, CHECK mayor a inicio           | Fin de ventana horaria.         |
| `estado`                | `estado_pedido`    | NOT NULL, DEFAULT `PENDIENTE`        | Estado operativo del pedido.    |
| `hora_estimada_entrega` | `TIMESTAMPTZ`      | NULL                                 | Hora estimada de entrega.       |
| `hora_entrega_real`     | `TIMESTAMPTZ`      | NULL                                 | Hora real de entrega.           |
| `observacion`           | `TEXT`             | NULL                                 | Observación general.            |
| `created_at`            | `TIMESTAMPTZ`      | NOT NULL, DEFAULT NOW()              | Fecha de creación.              |
| `updated_at`            | `TIMESTAMPTZ`      | NOT NULL, DEFAULT NOW()              | Fecha de actualización.         |

### Dominio `prioridad_pedido`

```txt
BAJA, MEDIA, ALTA
```

### Dominio `estado_pedido`

```txt
PENDIENTE, ASIGNADO, EN_RUTA, ENTREGADO, FALLIDO, INCIDENCIA
```

---

## 5.6 Tabla `rutas`

| Columna                | Tipo            | Restricciones                     | Descripción             |
| ---------------------- | --------------- | --------------------------------- | ----------------------- |
| `id`                   | `UUID`          | PK, DEFAULT `gen_random_uuid()`   | Identificador de ruta.  |
| `codigo`               | `VARCHAR(40)`   | NOT NULL, UNIQUE                  | Código único de ruta.   |
| `fecha`                | `DATE`          | NOT NULL                          | Fecha de ejecución.     |
| `conductor_id`         | `UUID`          | NOT NULL, FK `conductores(id)`    | Conductor asignado.     |
| `vehiculo_id`          | `UUID`          | NOT NULL, FK `vehiculos(id)`      | Vehículo asignado.      |
| `estado`               | `estado_ruta`   | NOT NULL, DEFAULT `BORRADOR`      | Estado de ruta.         |
| `hora_inicio_estimada` | `TIMESTAMPTZ`   | NULL                              | Inicio estimado.        |
| `hora_fin_estimada`    | `TIMESTAMPTZ`   | NULL, CHECK mayor a inicio        | Fin estimado.           |
| `distancia_km`         | `NUMERIC(10,2)` | NOT NULL, DEFAULT 0, CHECK `>= 0` | Distancia planificada.  |
| `costo_estimado`       | `NUMERIC(12,2)` | NOT NULL, DEFAULT 0, CHECK `>= 0` | Costo estimado.         |
| `observacion`          | `TEXT`          | NULL                              | Observación de ruta.    |
| `created_at`           | `TIMESTAMPTZ`   | NOT NULL, DEFAULT NOW()           | Fecha de creación.      |
| `updated_at`           | `TIMESTAMPTZ`   | NOT NULL, DEFAULT NOW()           | Fecha de actualización. |

### Dominio `estado_ruta`

```txt
BORRADOR, PLANIFICADA, EN_RUTA, CERRADA, CANCELADA
```

---

## 5.7 Tabla `ruta_pedidos`

| Columna          | Tipo            | Restricciones                              | Descripción                           |
| ---------------- | --------------- | ------------------------------------------ | ------------------------------------- |
| `id`             | `UUID`          | PK, DEFAULT `gen_random_uuid()`            | Identificador del detalle.            |
| `ruta_id`        | `UUID`          | NOT NULL, FK `rutas(id)` ON DELETE CASCADE | Ruta relacionada.                     |
| `pedido_id`      | `UUID`          | NOT NULL, FK `pedidos(id)`                 | Pedido relacionado.                   |
| `orden_parada`   | `INT`           | NOT NULL, CHECK `> 0`                      | Orden de parada.                      |
| `eta`            | `TIMESTAMPTZ`   | NULL                                       | Hora estimada de llegada a la parada. |
| `hora_llegada`   | `TIMESTAMPTZ`   | NULL                                       | Hora real de llegada.                 |
| `estado_en_ruta` | `estado_parada` | NOT NULL, DEFAULT `PENDIENTE`              | Estado de la parada.                  |
| `created_at`     | `TIMESTAMPTZ`   | NOT NULL, DEFAULT NOW()                    | Fecha de creación.                    |
| `updated_at`     | `TIMESTAMPTZ`   | NOT NULL, DEFAULT NOW()                    | Fecha de actualización.               |

### Restricciones únicas

| Restricción                     | Propósito                                            |
| ------------------------------- | ---------------------------------------------------- |
| `UNIQUE(ruta_id, pedido_id)`    | Evita repetir un mismo pedido dentro de una ruta.    |
| `UNIQUE(ruta_id, orden_parada)` | Evita repetir el orden de parada dentro de una ruta. |

### Dominio `estado_parada`

```txt
PENDIENTE, VISITADO, CANCELADO
```

---

## 5.8 Tabla `historial_estados`

| Columna           | Tipo            | Restricciones                                           | Descripción                 |
| ----------------- | --------------- | ------------------------------------------------------- | --------------------------- |
| `id`              | `UUID`          | PK, DEFAULT `gen_random_uuid()`                         | Identificador de historial. |
| `pedido_id`       | `UUID`          | NOT NULL, FK `pedidos(id)` ON DELETE CASCADE            | Pedido relacionado.         |
| `usuario_id`      | `UUID`          | NOT NULL, FK `usuarios(id)`                             | Usuario responsable.        |
| `estado_anterior` | `estado_pedido` | NULL                                                    | Estado previo.              |
| `estado_nuevo`    | `estado_pedido` | NOT NULL                                                | Nuevo estado.               |
| `observacion`     | `TEXT`          | NULL, obligatoria si estado es `FALLIDO` o `INCIDENCIA` | Observación del cambio.     |
| `created_at`      | `TIMESTAMPTZ`   | NOT NULL, DEFAULT NOW()                                 | Fecha del cambio.           |

---

## 5.9 Tabla `incidencias`

| Columna         | Tipo                | Restricciones                                | Descripción                  |
| --------------- | ------------------- | -------------------------------------------- | ---------------------------- |
| `id`            | `UUID`              | PK, DEFAULT `gen_random_uuid()`              | Identificador de incidencia. |
| `pedido_id`     | `UUID`              | NOT NULL, FK `pedidos(id)` ON DELETE CASCADE | Pedido afectado.             |
| `ruta_id`       | `UUID`              | NULL, FK `rutas(id)`                         | Ruta relacionada.            |
| `reportado_por` | `UUID`              | NOT NULL, FK `usuarios(id)`                  | Usuario que reporta.         |
| `tipo`          | `tipo_incidencia`   | NOT NULL                                     | Tipo de incidencia.          |
| `descripcion`   | `TEXT`              | NOT NULL                                     | Descripción del problema.    |
| `estado`        | `estado_incidencia` | NOT NULL, DEFAULT `ABIERTA`                  | Estado de atención.          |
| `solucion`      | `TEXT`              | NULL, obligatoria si se resuelve o cierra    | Solución aplicada.           |
| `created_at`    | `TIMESTAMPTZ`       | NOT NULL, DEFAULT NOW()                      | Fecha de creación.           |
| `updated_at`    | `TIMESTAMPTZ`       | NOT NULL, DEFAULT NOW()                      | Fecha de actualización.      |
| `resuelta_at`   | `TIMESTAMPTZ`       | NULL                                         | Fecha de resolución.         |

### Dominio `tipo_incidencia`

```txt
RETRASO, DIRECCION_INCORRECTA, CLIENTE_AUSENTE, FALLA_VEHICULO, OTRO
```

### Dominio `estado_incidencia`

```txt
ABIERTA, EN_ATENCION, RESUELTA, CERRADA
```

---

## 5.10 Tabla `alertas`

| Columna         | Tipo               | Restricciones                          | Descripción              |
| --------------- | ------------------ | -------------------------------------- | ------------------------ |
| `id`            | `UUID`             | PK, DEFAULT `gen_random_uuid()`        | Identificador de alerta. |
| `pedido_id`     | `UUID`             | NULL, FK `pedidos(id)`                 | Pedido relacionado.      |
| `ruta_id`       | `UUID`             | NULL, FK `rutas(id)`                   | Ruta relacionada.        |
| `incidencia_id` | `UUID`             | NULL, FK `incidencias(id)`             | Incidencia relacionada.  |
| `tipo`          | `tipo_alerta`      | NOT NULL                               | Tipo de alerta.          |
| `severidad`     | `severidad_alerta` | NOT NULL, DEFAULT `MEDIA`              | Nivel de prioridad.      |
| `motivo`        | `TEXT`             | NOT NULL                               | Motivo de la alerta.     |
| `estado`        | `estado_alerta`    | NOT NULL, DEFAULT `ABIERTA`            | Estado de la alerta.     |
| `created_at`    | `TIMESTAMPTZ`      | NOT NULL, DEFAULT NOW()                | Fecha de creación.       |
| `updated_at`    | `TIMESTAMPTZ`      | NOT NULL, DEFAULT NOW()                | Fecha de actualización.  |
| `cerrada_at`    | `TIMESTAMPTZ`      | NULL, requerida si estado es `CERRADA` | Fecha de cierre.         |

### Restricciones principales

| Restricción                                                    | Propósito                                                      |
| -------------------------------------------------------------- | -------------------------------------------------------------- |
| Debe existir al menos `pedido_id`, `ruta_id` o `incidencia_id` | Evita alertas sin contexto operativo.                          |
| `UNIQUE(pedido_id, tipo) WHERE estado = 'ABIERTA'`             | Evita alertas duplicadas abiertas para el mismo pedido y tipo. |

### Dominios

```txt
TipoAlerta: RETRASO, INCIDENCIA, SISTEMA
SeveridadAlerta: BAJA, MEDIA, ALTA
EstadoAlerta: ABIERTA, CERRADA
```

---

## 5.11 Tabla `kpi_operativos`

| Columna               | Tipo            | Restricciones                            | Descripción                |
| --------------------- | --------------- | ---------------------------------------- | -------------------------- |
| `id`                  | `UUID`          | PK, DEFAULT `gen_random_uuid()`          | Identificador del KPI.     |
| `fecha`               | `DATE`          | NOT NULL                                 | Fecha del indicador.       |
| `ruta_id`             | `UUID`          | NULL, FK `rutas(id)`                     | Ruta analizada.            |
| `conductor_id`        | `UUID`          | NULL, FK `conductores(id)`               | Conductor analizado.       |
| `total_pedidos`       | `INT`           | NOT NULL, DEFAULT 0, CHECK `>= 0`        | Total de pedidos.          |
| `entregados_a_tiempo` | `INT`           | NOT NULL, DEFAULT 0, CHECK `>= 0`        | Entregas puntuales.        |
| `entregados_tarde`    | `INT`           | NOT NULL, DEFAULT 0, CHECK `>= 0`        | Entregas tardías.          |
| `fallidos`            | `INT`           | NOT NULL, DEFAULT 0, CHECK `>= 0`        | Entregas fallidas.         |
| `incidencias`         | `INT`           | NOT NULL, DEFAULT 0, CHECK `>= 0`        | Incidencias registradas.   |
| `puntualidad_pct`     | `NUMERIC(5,2)`  | NOT NULL, DEFAULT 0, CHECK entre 0 y 100 | Porcentaje de puntualidad. |
| `costo_estimado`      | `NUMERIC(12,2)` | NOT NULL, DEFAULT 0, CHECK `>= 0`        | Costo estimado.            |
| `created_at`          | `TIMESTAMPTZ`   | NOT NULL, DEFAULT NOW()                  | Fecha de cálculo.          |

### Restricción lógica

```txt
entregados_a_tiempo + entregados_tarde + fallidos <= total_pedidos
```

---

## 6. Reglas de negocio implementadas

| Código | Regla                                                                      | Implementación                                |
| ------ | -------------------------------------------------------------------------- | --------------------------------------------- |
| RN01   | Una ruta debe tener conductor y vehículo.                                  | FK obligatorias en `rutas`.                   |
| RN02   | El conductor debe estar activo y disponible para recibir rutas.            | Trigger `validar_recursos_ruta()`.            |
| RN03   | El vehículo debe estar activo y disponible para asignarse.                 | Trigger `validar_recursos_ruta()`.            |
| RN04   | Un pedido no debe estar en dos rutas activas.                              | Trigger `validar_pedido_sin_ruta_activa()`.   |
| RN05   | Al asignar un pedido a una ruta, su estado pasa a `ASIGNADO`.              | Trigger `marcar_pedido_asignado()`.           |
| RN06   | Todo cambio de estado debe quedar auditado.                                | Tabla `historial_estados`.                    |
| RN07   | Si un pedido cambia a `FALLIDO` o `INCIDENCIA`, debe tener observación.    | CHECK en `historial_estados`.                 |
| RN08   | Si existe incidencia o fallo, puede generarse incidencia operativa.        | Trigger `crear_incidencia_desde_historial()`. |
| RN09   | Una alerta debe tener contexto operativo.                                  | CHECK en `alertas`.                           |
| RN10   | No debe duplicarse una alerta abierta del mismo tipo para el mismo pedido. | Índice único parcial.                         |
| RN11   | Los KPIs no pueden tener conteos negativos.                                | CHECK en `kpi_operativos`.                    |
| RN12   | La puntualidad debe estar entre 0 y 100.                                   | CHECK en `kpi_operativos`.                    |

---

## 7. Índices recomendados

| Índice                      | Tabla                            | Propósito                                                   |
| --------------------------- | -------------------------------- | ----------------------------------------------------------- |
| `idx_pedidos_cliente`       | `pedidos(cliente_id)`            | Consultar pedidos por cliente.                              |
| `idx_pedidos_estado`        | `pedidos(estado)`                | Filtrar pedidos pendientes, en ruta, entregados o fallidos. |
| `idx_pedidos_prioridad`     | `pedidos(prioridad)`             | Priorizar pedidos críticos.                                 |
| `idx_pedidos_hora_estimada` | `pedidos(hora_estimada_entrega)` | Detectar retrasos.                                          |
| `idx_rutas_fecha`           | `rutas(fecha)`                   | Filtrar rutas por día operativo.                            |
| `idx_rutas_estado`          | `rutas(estado)`                  | Consultar rutas activas o cerradas.                         |
| `idx_rutas_conductor`       | `rutas(conductor_id)`            | Analizar desempeño del conductor.                           |
| `idx_ruta_pedidos_ruta`     | `ruta_pedidos(ruta_id)`          | Cargar paradas por ruta.                                    |
| `idx_historial_pedido`      | `historial_estados(pedido_id)`   | Consultar trazabilidad del pedido.                          |
| `idx_incidencias_estado`    | `incidencias(estado)`            | Listar incidencias abiertas.                                |
| `idx_alertas_estado`        | `alertas(estado)`                | Listar alertas abiertas.                                    |
| `idx_alertas_severidad`     | `alertas(severidad)`             | Priorizar atención operativa.                               |
| `idx_kpi_fecha`             | `kpi_operativos(fecha)`          | Analizar indicadores por fecha.                             |

---

## 8. Vistas propuestas para soporte a decisiones

## 8.1 Vista `v_dashboard_operativo`

Esta vista resume rutas, conductor, vehículo, total de pedidos, pedidos entregados, fallidos, con incidencia, retrasados y alertas abiertas.

### Uso DSS

Permite al despachador y al gerente observar el estado global de la operación en un dashboard.

### Preguntas que responde

- ¿Qué rutas están activas?
- ¿Qué rutas tienen pedidos retrasados?
- ¿Qué rutas tienen alertas abiertas?
- ¿Qué conductor está asociado a cada ruta?

---

## 8.2 Vista `v_pedidos_trazabilidad`

Esta vista consolida la trazabilidad del pedido: cliente, dirección, estado, ruta, conductor, vehículo, retraso, incidencias y alertas abiertas.

### Uso DSS

Permite responder consultas de clientes y detectar pedidos críticos sin revisar tablas separadas manualmente.

### Preguntas que responde

- ¿Dónde está el pedido?
- ¿Está retrasado?
- ¿Tiene incidencias?
- ¿Qué ruta, conductor y vehículo están asociados?

---

## 9. Consultas analíticas que soporta el modelo

| Pregunta de decisión                           | Tablas / vistas utilizadas                                   |
| ---------------------------------------------- | ------------------------------------------------------------ |
| ¿Qué pedidos están retrasados actualmente?     | `pedidos`, `ruta_pedidos`, `rutas`, `v_pedidos_trazabilidad` |
| ¿Qué rutas tienen más alertas abiertas?        | `alertas`, `rutas`, `v_dashboard_operativo`                  |
| ¿Qué conductor tiene más entregas fallidas?    | `conductores`, `rutas`, `ruta_pedidos`, `pedidos`            |
| ¿Qué cliente tiene más pedidos con incidencia? | `clientes_empresas`, `pedidos`, `incidencias`                |
| ¿Cuál es la puntualidad por conductor?         | `kpi_operativos`, `conductores`                              |
| ¿Qué rutas presentan mayor costo estimado?     | `rutas`, `kpi_operativos`                                    |
| ¿Qué pedidos deben priorizarse?                | `alertas`, `pedidos`, `ruta_pedidos`, `rutas`                |

---

## 10. Normalización aplicada

| Forma normal | Aplicación en el modelo                                                                           |
| ------------ | ------------------------------------------------------------------------------------------------- |
| 1FN          | Cada columna almacena valores atómicos; no hay listas dentro de campos.                           |
| 2FN          | Las tablas intermedias como `ruta_pedidos` separan relaciones y atributos propios de la relación. |
| 3FN          | Datos de clientes, vehículos, conductores y pedidos están separados para evitar redundancia.      |

### Ejemplos de normalización

- Los datos del cliente no se repiten en cada ruta; se relacionan mediante `pedidos.cliente_id`.
- Los datos del conductor no se copian en `rutas`; se referencian mediante `conductor_id`.
- Los cambios de estado no sobrescriben historial; se almacenan en `historial_estados`.
- Las alertas se separan de pedidos e incidencias para priorización operativa.
- Los KPIs se separan de tablas transaccionales para análisis y reportes.

---

## 11. Integridad referencial

| FK                             | Relación                         | Acción de integridad |
| ------------------------------ | -------------------------------- | -------------------- |
| `conductores.usuario_id`       | `conductores` → `usuarios`       | `ON DELETE RESTRICT` |
| `pedidos.cliente_id`           | `pedidos` → `clientes_empresas`  | `ON DELETE RESTRICT` |
| `rutas.conductor_id`           | `rutas` → `conductores`          | `ON DELETE RESTRICT` |
| `rutas.vehiculo_id`            | `rutas` → `vehiculos`            | `ON DELETE RESTRICT` |
| `ruta_pedidos.ruta_id`         | `ruta_pedidos` → `rutas`         | `ON DELETE CASCADE`  |
| `ruta_pedidos.pedido_id`       | `ruta_pedidos` → `pedidos`       | `ON DELETE RESTRICT` |
| `historial_estados.pedido_id`  | `historial_estados` → `pedidos`  | `ON DELETE CASCADE`  |
| `historial_estados.usuario_id` | `historial_estados` → `usuarios` | `ON DELETE RESTRICT` |
| `incidencias.pedido_id`        | `incidencias` → `pedidos`        | `ON DELETE CASCADE`  |
| `incidencias.ruta_id`          | `incidencias` → `rutas`          | `ON DELETE SET NULL` |
| `alertas.pedido_id`            | `alertas` → `pedidos`            | `ON DELETE CASCADE`  |
| `alertas.ruta_id`              | `alertas` → `rutas`              | `ON DELETE CASCADE`  |
| `alertas.incidencia_id`        | `alertas` → `incidencias`        | `ON DELETE SET NULL` |
| `kpi_operativos.ruta_id`       | `kpi_operativos` → `rutas`       | `ON DELETE SET NULL` |
| `kpi_operativos.conductor_id`  | `kpi_operativos` → `conductores` | `ON DELETE SET NULL` |

---

## 12. Validación de soporte a decisiones

El modelo no se limita a almacenar datos transaccionales. También permite generar información para el soporte a decisiones en FlashLogistics.

### 12.1 Planificación de rutas

Las tablas `rutas`, `ruta_pedidos`, `conductores`, `vehiculos` y `pedidos` permiten planificar rutas, validar recursos y ordenar paradas.

### 12.2 Trazabilidad de pedidos

Las tablas `pedidos` e `historial_estados` permiten conocer la evolución completa de un pedido desde su creación hasta su entrega, fallo o incidencia.

### 12.3 Gestión de incidencias

La tabla `incidencias` permite registrar problemas operativos, responsables, estado de atención y solución aplicada.

### 12.4 Priorización mediante alertas

La tabla `alertas` permite identificar eventos críticos, clasificarlos por severidad y mostrar al despachador qué casos requieren atención inmediata.

### 12.5 Análisis mediante KPIs

La tabla `kpi_operativos` permite analizar puntualidad, retrasos, fallos, incidencias, costos y desempeño por ruta o conductor.

---

## 13. Correspondencia con el script SQL

| Artefacto                          | Archivo                                     |
| ---------------------------------- | ------------------------------------------- |
| Modelo relacional documentado      | `modelo-relacional.md`                      |
| Script SQL inicial                 | `database/script-SQL.sql`                   |
| Diagrama de clases de persistencia | `capturas/diagrama-clases-persistencia.png` |

---

## 14. Conclusión

El modelo relacional de SmartRoute DSS proporciona una base persistente normalizada, íntegra y alineada con el problema de FlashLogistics. Su estructura permite registrar la operación diaria, mantener trazabilidad, generar alertas, consolidar KPIs y apoyar decisiones tácticas.

Al separar entidades, aplicar claves primarias y foráneas, definir restricciones y preparar vistas analíticas, el diseño reduce deuda técnica y crea una base sólida para el desarrollo posterior del MVP.
