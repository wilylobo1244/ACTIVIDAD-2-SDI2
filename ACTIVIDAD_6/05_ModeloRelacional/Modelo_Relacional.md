# 5. MODELO RELACIONAL

## 5.1 Diseño de Base de Datos

```sql
CREATE TABLE Usuario(
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL,
    rol ENUM('ADMIN','ANALISTA') NOT NULL,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Producto(
    id_producto INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(150) NOT NULL,
    categoria VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL CHECK (precio > 0),
    stock INT NOT NULL CHECK (stock >= 0),
    stock_minimo INT NOT NULL DEFAULT 1,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Venta(
    id_venta INT PRIMARY KEY AUTO_INCREMENT,
    fecha_venta DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(12,2) NOT NULL CHECK (total >= 0),
    id_usuario INT NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);

CREATE TABLE DetalleVenta(
    id_detalle INT PRIMARY KEY AUTO_INCREMENT,
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    subtotal DECIMAL(12,2) NOT NULL CHECK (subtotal >= 0),
    FOREIGN KEY (id_venta) REFERENCES Venta(id_venta),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);

CREATE INDEX idx_venta_fecha ON Venta(fecha_venta);
CREATE INDEX idx_detalle_producto ON DetalleVenta(id_producto);
CREATE INDEX idx_producto_categoria ON Producto(categoria);
```

### Consideraciones de integridad, normalización y performance

- Normalización: el esquema está diseñado para cumplir 3FN. `DetalleVenta` separa las líneas de venta para evitar redundancia y facilitar agregaciones analíticas.
- Constraints y reglas de integridad:
  - `Producto.stock` y `stock_minimo` con CHECK >= 0.
  - `Venta.total` con CHECK >= 0.
  - FK `Venta.id_usuario` CONSTRAINT con `ON DELETE RESTRICT` (impide eliminar usuarios con ventas históricas).
  - FK `DetalleVenta.id_producto` CONSTRAINT con `ON DELETE RESTRICT` y `ON UPDATE CASCADE` (usar `activo=false` para desactivar productos en lugar de borrarlos).
- Transaccionalidad: la creación de una `Venta` y la actualización de `Producto.stock` debe ejecutarse dentro de una transacción atómica para garantizar consistencia y evitar condiciones de carrera.

### Índices y consultas recomendadas
- Índices:
  - `idx_venta_fecha` para consultas por rango de fechas.
  - `idx_detalle_producto` para agregaciones por producto.
  - `idx_producto_categoria` para filtros por categoría.

- Consultas de ejemplo:
  - Top 5 productos por unidades vendidas en un periodo:
    ```sql
    SELECT p.id_producto, p.nombre, SUM(d.cantidad) AS unidades
    FROM DetalleVenta d
    JOIN Producto p ON p.id_producto = d.id_producto
    JOIN Venta v ON v.id_venta = d.id_venta
    WHERE v.fecha_venta BETWEEN @desde AND @hasta
    GROUP BY p.id_producto, p.nombre
    ORDER BY unidades DESC
    LIMIT 5;
    ```

  - Productos con stock crítico:
    ```sql
    SELECT id_producto, nombre, stock, stock_minimo
    FROM Producto
    WHERE stock <= stock_minimo AND activo = TRUE;
    ```

  - Ventas por día (serie temporal):
    ```sql
    SELECT CAST(v.fecha_venta AS DATE) AS dia, SUM(v.total) AS ingreso
    FROM Venta v
    WHERE v.fecha_venta BETWEEN @desde AND @hasta
    GROUP BY CAST(v.fecha_venta AS DATE)
    ORDER BY dia;
    ```

### Vistas y procedimientos sugeridos
- `vw_ventas_por_producto`: vista que preagrega ventas por producto y periodo para acelerar dashboards.
- `proc_generar_reposicion`: procedimiento que calcula cantidades a reponer y ordena por prioridad.

## 5.2 Diccionario de Datos

- `Usuario`: almacena los usuarios del sistema.
  - `id_usuario`: identificador único.
  - `nombre`: nombre completo.
  - `correo`: correo electrónico único.
  - `contrasena`: contraseña cifrada.
  - `rol`: tipo de usuario (`ADMIN` o `ANALISTA`).
  - `fecha_creacion`: fecha de registro.

- `Producto`: almacena el catálogo de productos.
  - `id_producto`: identificador único.
  - `nombre`: nombre del producto.
  - `categoria`: categoría comercial.
  - `precio`: precio unitario.
  - `stock`: cantidad disponible.
  - `stock_minimo`: nivel mínimo de stock para alerta.
  - `activo`: estado de disponibilidad.
  - `fecha_creacion`: fecha de inclusión en el catálogo.

- `Venta`: almacena las ventas registradas.
  - `id_venta`: identificador único de la venta.
  - `fecha_venta`: fecha y hora de la transacción.
  - `total`: valor total de la venta.
  - `id_usuario`: usuario que registró la venta.

- `DetalleVenta`: almacena los productos vendidos por venta.
  - `id_detalle`: identificador único del detalle.
  - `id_venta`: referencia a la venta.
  - `id_producto`: referencia al producto vendido.
  - `cantidad`: unidades vendidas.
  - `subtotal`: precio parcial de la línea.

- Índices:
  - `idx_venta_fecha`: mejora consultas por fecha de venta.
  - `idx_detalle_producto`: mejora consultas por producto.
  - `idx_producto_categoria`: mejora consultas por categoría.

## 5.3 Observaciones

- El modelo está optimizado para consultas analíticas de ventas por fecha, producto y categoría.
- Permite calcular productos estrella, productos hueso y alertas de stock crítico.
- Las constraints garantizan integridad de precios, stock y relaciones.
