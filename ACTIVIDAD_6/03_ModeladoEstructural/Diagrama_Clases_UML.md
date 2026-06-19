# 3. MODELADO ESTRUCTURAL (CRITERIO 40%)

## 3.1 Diagrama de Clases UML (Mermaid)

```mermaid
classDiagram

class Usuario{
    -int idUsuario
    -string nombre
    -string correo
    -string contrasena
    -string rol
    +iniciarSesion()
    +cerrarSesion()
}

class Administrador{
    +gestionarProducto()
    +gestionarVenta()
}

class Analista{
    +consultarDashboard()
    +generarReporte()
}

class Producto{
    -int idProducto
    -string nombre
    -string categoria
    -decimal precio
    -int stock
    -int stockMinimo
    +registrarProducto()
    +editarProducto()
    +eliminarProducto()
    +buscarProducto()
    +actualizarStock()
}

class Venta{
    -int idVenta
    -datetime fechaVenta
    -decimal total
    -int idUsuario
    +registrarVenta()
    +calcularTotal()
    +validarStock()
}

class DetalleVenta{
    -int idDetalle
    -int cantidad
    -decimal subtotal
    -int idProducto
    +calcularSubtotal()
}

class Dashboard{
    -int idDashboard
    -datetime fechaGeneracion
    +productosEstrella()
    +productosHueso()
    +alertaStockCritico()
    +generarReporte()
}

class Reporte{
    -int idReporte
    -string tipoReporte
    -datetime fechaCreacion
    +exportarPDF()
    +exportarExcel()
}

Usuario <|-- Administrador
Usuario <|-- Analista

Usuario "1" --> "N" Venta : registra
Venta "1" *-- "N" DetalleVenta : contiene
Producto "1" --> "N" DetalleVenta : pertenece
Dashboard --> "*" Venta : analiza
Dashboard --> "*" Producto : procesa
Reporte --> Dashboard : obtieneDatos
Administrador --> Dashboard : consulta
Analista --> Dashboard : consulta
```

- Herencia: `Administrador` y `Analista` extienden `Usuario`.
- Composición: `Venta` contiene `DetalleVenta`.
- Relaciones: el dashboard consume datos de ventas y productos para análisis.
