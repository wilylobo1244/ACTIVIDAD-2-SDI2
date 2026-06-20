# 6. Product Backlog

## 6.1 Objetivo

Este Product Backlog deja SmartSales DSS listo para iniciar un Sprint de 7 días. Las historias están redactadas con formato estándar y criterios de aceptación verificables, siguiendo el criterio INVEST.

---

## 6.2 Épicas

| Código | Épica                            | Descripción                                                         |
| ------ | -------------------------------- | ------------------------------------------------------------------- |
| E01    | Gestión de Catálogo e Inventario | CRUD de categorías, productos y control de stock.                   |
| E02    | Registro de Ventas               | Registro transaccional de ventas y detalle de productos vendidos.   |
| E03    | Dashboard DSS                    | Indicadores de productos estrella, productos hueso y stock crítico. |
| E04    | Reportes y Preparación Ágil      | Exportación de reportes, backlog, DoR y evidencias.                 |

---

## 6.3 Backlog priorizado

| ID   | Épica | Historia de Usuario                                                                                                                | Criterios de Aceptación                                                                                                                                                  | Prioridad | Estimación |
| ---- | ----- | ---------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | --------- | ---------- |
| HU01 | E01   | Como administrador, quiero registrar productos, para mantener actualizado el catálogo de la tienda.                                | 1. Nombre, categoría, precio y stock son obligatorios.<br>2. El precio debe ser mayor a 0.<br>3. El stock inicial no puede ser negativo.                                 | Alta      | 3 pts      |
| HU02 | E01   | Como administrador, quiero editar productos, para corregir información de catálogo e inventario.                                   | 1. Permite actualizar nombre, categoría, precio, costo y stock mínimo.<br>2. No permite precio negativo ni stock negativo.<br>3. Registra fecha de actualización.        | Alta      | 3 pts      |
| HU03 | E01   | Como administrador, quiero desactivar productos, para impedir ventas de artículos que ya no se comercializan sin perder historial. | 1. El producto queda en estado inactivo.<br>2. No aparece disponible para nuevas ventas.<br>3. Sus ventas históricas se conservan.                                       | Media     | 2 pts      |
| HU04 | E02   | Como vendedor, quiero registrar una venta con varios productos, para controlar ingresos y actualizar inventario.                   | 1. Se pueden seleccionar productos activos.<br>2. El sistema valida stock antes de confirmar.<br>3. El total se calcula automáticamente.<br>4. La venta descuenta stock. | Alta      | 5 pts      |
| HU05 | E02   | Como administrador, quiero consultar ventas históricas, para analizar el comportamiento comercial por periodo.                     | 1. Muestra ventas ordenadas por fecha.<br>2. Permite filtrar por rango de fechas.<br>3. Incluye usuario responsable y total.                                             | Media     | 3 pts      |
| HU06 | E03   | Como dueño de tienda, quiero ver productos estrella, para priorizar promociones y reposición.                                      | 1. Muestra Top 5 productos por unidades vendidas.<br>2. Incluye ingresos generados por producto.<br>3. Permite filtrar por periodo.                                      | Alta      | 5 pts      |
| HU07 | E03   | Como dueño de tienda, quiero ver productos hueso, para reducir inventario inmovilizado.                                            | 1. Muestra productos con menor rotación.<br>2. Incluye stock actual e ingresos generados.<br>3. Permite identificar productos candidatos a promoción o liquidación.      | Alta      | 5 pts      |
| HU08 | E03   | Como administrador, quiero recibir alertas de stock crítico, para reabastecer productos antes de perder ventas.                    | 1. Identifica productos con stock menor o igual al mínimo.<br>2. Muestra alertas en el dashboard.<br>3. Evita duplicar alertas abiertas del mismo producto.              | Alta      | 3 pts      |
| HU09 | E04   | Como analista, quiero generar reportes analíticos, para compartir resultados de ventas e inventario.                               | 1. Permite generar reporte por periodo.<br>2. Incluye productos estrella, productos hueso y stock crítico.<br>3. Registra fecha de generación y usuario.                 | Media     | 3 pts      |
| HU10 | E03   | Como dueño de tienda, quiero visualizar ingresos por categoría, para decidir qué líneas de producto fortalecer.                    | 1. Agrupa ingresos por categoría.<br>2. Permite filtrar por periodo.<br>3. Ordena categorías por mayor ingreso.                                                          | Media     | 3 pts      |

---

## 6.4 Revisión INVEST

| Criterio      | Aplicación                                                                      |
| ------------- | ------------------------------------------------------------------------------- |
| Independiente | Cada HU puede implementarse por módulo: catálogo, ventas, dashboard o reportes. |
| Negociable    | Las historias describen valor de negocio, no una solución técnica cerrada.      |
| Valorable     | Cada historia beneficia a administrador, vendedor, analista o dueño.            |
| Estimable     | Todas las historias tienen alcance y estimación.                                |
| Pequeña       | Cada HU puede abordarse dentro de un sprint corto.                              |
| Verificable   | Cada HU tiene criterios de aceptación medibles.                                 |

---

## 6.5 Orden sugerido de ejecución en 7 días

| Día   | Foco                                     | Historias  |
| ----- | ---------------------------------------- | ---------- |
| Día 1 | Base de datos y catálogo                 | HU01, HU02 |
| Día 2 | Productos activos/inactivos e inventario | HU03       |
| Día 3 | Registro de ventas                       | HU04       |
| Día 4 | Historial de ventas                      | HU05       |
| Día 5 | Dashboard productos estrella y hueso     | HU06, HU07 |
| Día 6 | Alertas y categoría                      | HU08, HU10 |
| Día 7 | Reportes, pruebas y cierre               | HU09       |
