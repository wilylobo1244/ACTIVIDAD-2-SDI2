# 6. PRODUCT BACKLOG

## HU-01: Registrar productos
Como administrador quiero registrar productos para tener un catálogo actualizado y control de inventario.

Criterios de aceptación:
- Nombre y categoría son obligatorios.
- Precio mayor a 0.
- Stock inicial mayor o igual a 0.
- El producto queda disponible en el catálogo.

## HU-02: Editar productos
Como administrador quiero editar productos para mantener información correcta.

Criterios de aceptación:
- Permite actualizar nombre, categoría, precio y stock.
- No se permite stock negativo.
- Los cambios se almacenan correctamente.

## HU-03: Eliminar productos
Como administrador quiero eliminar productos para limpiar el catálogo.

Criterios de aceptación:
- El producto se marca inactivo o se elimina.
- No está disponible para nuevas ventas.
- Se preserva el historial de ventas existentes.

## HU-04: Registrar ventas
Como administrador quiero registrar ventas para controlar ingresos y actualizar inventario.

Criterios de aceptación:
- Se seleccionan productos existentes.
- El sistema valida stock antes de confirmar.
- El total se calcula automáticamente.
- Actualiza el stock de productos tras la venta.

## HU-05: Consultar ventas históricas
Como administrador quiero ver el historial de ventas para analizar tendencias.

Criterios de aceptación:
- Muestra ventas ordenadas por fecha.
- Incluye total y usuario responsable.
- Permite filtrar por rango de fechas.

## HU-06: Ver productos estrella
Como administrador quiero visualizar productos estrella para priorizar promociones.

Criterios de aceptación:
- Muestra Top 5 productos por cantidad vendida.
- Incluye métricas de ingresos por producto.
- Indica porcentaje de participación en ventas.

## HU-07: Ver productos hueso
Como administrador quiero visualizar productos de baja rotación para reducir inventario inmovilizado.

Criterios de aceptación:
- Muestra los 5 productos con menor cantidad vendida.
- Indica stock actual y días de inventario.

## HU-08: Alertas de stock crítico
Como administrador quiero recibir alertas de productos con stock bajo para reabastecer a tiempo.

Criterios de aceptación:
- Identifica productos con stock <= stock_minimo.
- Muestra alertas en el dashboard.
- Genera lista de reposición.

## HU-09: Generar reportes analíticos
Como administrador quiero exportar reportes para compartir resultados.

Criterios de aceptación:
- Exporta reportes a PDF y Excel.
- Contiene indicadores clave del dashboard.
- Registra la fecha de creación del reporte.
