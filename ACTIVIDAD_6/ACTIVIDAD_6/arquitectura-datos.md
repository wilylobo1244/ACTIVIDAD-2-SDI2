# 5. Arquitectura de Datos

## 5.1 Objetivo

La arquitectura de datos de SmartSales DSS debe permitir registrar operaciones comerciales y, al mismo tiempo, soportar consultas analíticas para la toma de decisiones.

El modelo relacional está diseñado para responder preguntas como:

- ¿Cuáles son los productos más vendidos?
- ¿Cuáles son los productos de menor rotación?
- ¿Qué productos están en stock crítico?
- ¿Qué categorías generan más ingresos?
- ¿Qué ventas se registraron por periodo?
- ¿Qué alertas siguen abiertas?

---

## 5.2 Modelo Relacional

### Imagen

![Modelo Relacional](./images/modelo-relacional.png)

### Tablas principales

| Tabla                    | Propósito                                                      |
| ------------------------ | -------------------------------------------------------------- |
| `usuarios`               | Usuarios del sistema: administradores, analistas y vendedores. |
| `categorias`             | Clasificación de productos.                                    |
| `productos`              | Catálogo e inventario.                                         |
| `ventas`                 | Cabecera de transacciones de venta.                            |
| `detalle_ventas`         | Productos vendidos en cada venta.                              |
| `movimientos_inventario` | Historial de entradas, salidas, ajustes y ventas.              |
| `alertas_inventario`     | Alertas DSS de stock crítico y eventos relevantes.             |
| `kpi_productos`          | Indicadores por producto y periodo.                            |
| `reportes_analiticos`    | Reportes generados desde el dashboard.                         |

---

## 5.3 Diccionario de datos

## Tabla `usuarios`

| Columna           | Tipo           | Restricciones          | Descripción                 |
| ----------------- | -------------- | ---------------------- | --------------------------- |
| `id`              | `UUID`         | PK                     | Identificador del usuario.  |
| `nombre`          | `VARCHAR(120)` | NOT NULL               | Nombre completo.            |
| `correo`          | `VARCHAR(160)` | NOT NULL, UNIQUE       | Correo de acceso.           |
| `contrasena_hash` | `TEXT`         | NOT NULL               | Contraseña cifrada o hash.  |
| `rol`             | `rol_usuario`  | NOT NULL               | ADMIN, ANALISTA o VENDEDOR. |
| `activo`          | `BOOLEAN`      | NOT NULL, DEFAULT TRUE | Estado lógico.              |
| `created_at`      | `TIMESTAMPTZ`  | NOT NULL               | Fecha de creación.          |
| `updated_at`      | `TIMESTAMPTZ`  | NOT NULL               | Fecha de actualización.     |

---

## Tabla `categorias`

| Columna       | Tipo           | Restricciones          | Descripción          |
| ------------- | -------------- | ---------------------- | -------------------- |
| `id`          | `UUID`         | PK                     | Identificador.       |
| `nombre`      | `VARCHAR(100)` | NOT NULL, UNIQUE       | Nombre de categoría. |
| `descripcion` | `TEXT`         | NULL                   | Descripción.         |
| `activa`      | `BOOLEAN`      | NOT NULL, DEFAULT TRUE | Estado lógico.       |
| `created_at`  | `TIMESTAMPTZ`  | NOT NULL               | Fecha de creación.   |

---

## Tabla `productos`

| Columna          | Tipo              | Restricciones        | Descripción             |
| ---------------- | ----------------- | -------------------- | ----------------------- |
| `id`             | `UUID`            | PK                   | Identificador.          |
| `categoria_id`   | `UUID`            | FK, NOT NULL         | Categoría del producto. |
| `codigo`         | `VARCHAR(40)`     | NOT NULL, UNIQUE     | Código interno.         |
| `nombre`         | `VARCHAR(150)`    | NOT NULL             | Nombre del producto.    |
| `descripcion`    | `TEXT`            | NULL                 | Descripción.            |
| `precio_venta`   | `NUMERIC(12,2)`   | NOT NULL, CHECK > 0  | Precio de venta.        |
| `costo_unitario` | `NUMERIC(12,2)`   | NOT NULL, CHECK >= 0 | Costo.                  |
| `stock`          | `INT`             | NOT NULL, CHECK >= 0 | Stock actual.           |
| `stock_minimo`   | `INT`             | NOT NULL, CHECK >= 0 | Umbral crítico.         |
| `estado`         | `estado_producto` | NOT NULL             | ACTIVO o INACTIVO.      |
| `created_at`     | `TIMESTAMPTZ`     | NOT NULL             | Fecha de creación.      |
| `updated_at`     | `TIMESTAMPTZ`     | NOT NULL             | Fecha de actualización. |

---

## Tabla `ventas`

| Columna       | Tipo            | Restricciones        | Descripción           |
| ------------- | --------------- | -------------------- | --------------------- |
| `id`          | `UUID`          | PK                   | Identificador.        |
| `codigo`      | `VARCHAR(40)`   | NOT NULL, UNIQUE     | Código de venta.      |
| `usuario_id`  | `UUID`          | FK, NOT NULL         | Usuario que registra. |
| `fecha_venta` | `TIMESTAMPTZ`   | NOT NULL             | Fecha de venta.       |
| `subtotal`    | `NUMERIC(12,2)` | NOT NULL, CHECK >= 0 | Subtotal.             |
| `descuento`   | `NUMERIC(12,2)` | NOT NULL, CHECK >= 0 | Descuento.            |
| `total`       | `NUMERIC(12,2)` | NOT NULL, CHECK >= 0 | Total.                |
| `observacion` | `TEXT`          | NULL                 | Observaciones.        |
| `created_at`  | `TIMESTAMPTZ`   | NOT NULL             | Fecha de creación.    |

---

## Tabla `detalle_ventas`

| Columna           | Tipo            | Restricciones        | Descripción                 |
| ----------------- | --------------- | -------------------- | --------------------------- |
| `id`              | `UUID`          | PK                   | Identificador.              |
| `venta_id`        | `UUID`          | FK, NOT NULL         | Venta asociada.             |
| `producto_id`     | `UUID`          | FK, NOT NULL         | Producto vendido.           |
| `cantidad`        | `INT`           | NOT NULL, CHECK > 0  | Cantidad.                   |
| `precio_unitario` | `NUMERIC(12,2)` | NOT NULL, CHECK >= 0 | Precio capturado al vender. |
| `subtotal`        | `NUMERIC(12,2)` | NOT NULL, CHECK >= 0 | Subtotal de línea.          |

---

## Tabla `movimientos_inventario`

| Columna          | Tipo              | Restricciones        | Descripción                      |
| ---------------- | ----------------- | -------------------- | -------------------------------- |
| `id`             | `UUID`            | PK                   | Identificador.                   |
| `producto_id`    | `UUID`            | FK, NOT NULL         | Producto afectado.               |
| `usuario_id`     | `UUID`            | FK, NOT NULL         | Usuario responsable.             |
| `venta_id`       | `UUID`            | FK, NULL             | Venta que originó movimiento.    |
| `tipo`           | `tipo_movimiento` | NOT NULL             | ENTRADA, SALIDA, AJUSTE o VENTA. |
| `cantidad`       | `INT`             | NOT NULL, CHECK > 0  | Cantidad movida.                 |
| `stock_anterior` | `INT`             | NOT NULL, CHECK >= 0 | Stock previo.                    |
| `stock_nuevo`    | `INT`             | NOT NULL, CHECK >= 0 | Stock posterior.                 |
| `motivo`         | `TEXT`            | NULL                 | Motivo del movimiento.           |
| `created_at`     | `TIMESTAMPTZ`     | NOT NULL             | Fecha del movimiento.            |

---

## Tabla `alertas_inventario`

| Columna       | Tipo               | Restricciones | Descripción           |
| ------------- | ------------------ | ------------- | --------------------- |
| `id`          | `UUID`             | PK            | Identificador.        |
| `producto_id` | `UUID`             | FK, NOT NULL  | Producto relacionado. |
| `tipo`        | `tipo_alerta`      | NOT NULL      | Tipo de alerta.       |
| `severidad`   | `severidad_alerta` | NOT NULL      | BAJA, MEDIA o ALTA.   |
| `mensaje`     | `TEXT`             | NOT NULL      | Mensaje de alerta.    |
| `estado`      | `estado_alerta`    | NOT NULL      | ABIERTA o CERRADA.    |
| `created_at`  | `TIMESTAMPTZ`      | NOT NULL      | Fecha de creación.    |
| `cerrada_at`  | `TIMESTAMPTZ`      | NULL          | Fecha de cierre.      |

---

## Tabla `kpi_productos`

| Columna             | Tipo            | Restricciones        | Descripción               |
| ------------------- | --------------- | -------------------- | ------------------------- |
| `id`                | `UUID`          | PK                   | Identificador.            |
| `producto_id`       | `UUID`          | FK, NOT NULL         | Producto analizado.       |
| `periodo_inicio`    | `DATE`          | NOT NULL             | Inicio del periodo.       |
| `periodo_fin`       | `DATE`          | NOT NULL             | Fin del periodo.          |
| `unidades_vendidas` | `INT`           | NOT NULL, CHECK >= 0 | Unidades vendidas.        |
| `ingreso_total`     | `NUMERIC(12,2)` | NOT NULL, CHECK >= 0 | Ingreso generado.         |
| `margen_estimado`   | `NUMERIC(12,2)` | NOT NULL             | Margen estimado.          |
| `rotacion`          | `NUMERIC(10,2)` | NOT NULL, CHECK >= 0 | Indicador de rotación.    |
| `ranking_ventas`    | `INT`           | NULL                 | Ranking del producto.     |
| `clasificacion`     | `VARCHAR(30)`   | NOT NULL             | ESTRELLA, HUESO o NORMAL. |
| `created_at`        | `TIMESTAMPTZ`   | NOT NULL             | Fecha de cálculo.         |

---

## Tabla `reportes_analiticos`

| Columna                    | Tipo            | Restricciones        | Descripción                 |
| -------------------------- | --------------- | -------------------- | --------------------------- |
| `id`                       | `UUID`          | PK                   | Identificador.              |
| `usuario_id`               | `UUID`          | FK, NOT NULL         | Usuario que genera.         |
| `titulo`                   | `VARCHAR(160)`  | NOT NULL             | Título del reporte.         |
| `periodo_inicio`           | `DATE`          | NOT NULL             | Inicio del periodo.         |
| `periodo_fin`              | `DATE`          | NOT NULL             | Fin del periodo.            |
| `filtros_aplicados`        | `JSONB`         | NULL                 | Filtros utilizados.         |
| `total_ventas`             | `NUMERIC(12,2)` | NOT NULL, CHECK >= 0 | Total del periodo.          |
| `total_productos_vendidos` | `INT`           | NOT NULL, CHECK >= 0 | Total de unidades vendidas. |
| `created_at`               | `TIMESTAMPTZ`   | NOT NULL             | Fecha de generación.        |

---

## 5.4 Reglas de negocio en datos

| Regla                                                      | Implementación                                       |
| ---------------------------------------------------------- | ---------------------------------------------------- |
| El stock no puede ser negativo.                            | `CHECK(stock >= 0)` y validación transaccional.      |
| El precio de venta debe ser mayor a cero.                  | `CHECK(precio_venta > 0)`.                           |
| Una venta debe tener al menos un detalle.                  | Regla de aplicación + transacción.                   |
| Cada venta descuenta stock.                                | Trigger sobre `detalle_ventas`.                      |
| Cada descuento de stock genera movimiento.                 | Tabla `movimientos_inventario`.                      |
| Producto en stock crítico genera alerta.                   | Trigger o función `generar_alertas_stock_critico()`. |
| No se duplican alertas abiertas del mismo producto y tipo. | Índice único parcial.                                |
| Los KPIs se calculan por producto y periodo.               | `UNIQUE(producto_id, periodo_inicio, periodo_fin)`.  |

---

## 5.5 Consultas DSS soportadas

| Pregunta de negocio                       | Tablas utilizadas                                         |
| ----------------------------------------- | --------------------------------------------------------- |
| ¿Cuáles son los productos estrella?       | `ventas`, `detalle_ventas`, `productos`, `kpi_productos`. |
| ¿Cuáles son los productos hueso?          | `productos`, `detalle_ventas`, `kpi_productos`.           |
| ¿Qué productos están en stock crítico?    | `productos`, `alertas_inventario`.                        |
| ¿Qué categoría genera más ingresos?       | `categorias`, `productos`, `detalle_ventas`, `ventas`.    |
| ¿Cómo evolucionan las ventas por periodo? | `ventas`, `detalle_ventas`.                               |
| ¿Qué productos requieren reposición?      | `productos`, `alertas_inventario`.                        |
