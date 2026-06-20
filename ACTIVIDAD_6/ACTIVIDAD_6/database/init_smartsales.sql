-- ============================================================
-- SmartSales DSS - Script SQL inicial para Supabase/PostgreSQL
-- Actividad 6: Pivot & Plan - Arquitectura Ágil desde Cero
-- Squad: Cacatúas
-- ============================================================

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- ============================================================
-- 1. Dominios ENUM
-- ============================================================

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'rol_usuario') THEN
        CREATE TYPE public.rol_usuario AS ENUM ('ADMIN', 'ANALISTA', 'VENDEDOR');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'estado_producto') THEN
        CREATE TYPE public.estado_producto AS ENUM ('ACTIVO', 'INACTIVO');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'tipo_movimiento') THEN
        CREATE TYPE public.tipo_movimiento AS ENUM ('ENTRADA', 'SALIDA', 'AJUSTE', 'VENTA');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'tipo_alerta') THEN
        CREATE TYPE public.tipo_alerta AS ENUM ('STOCK_CRITICO', 'PRODUCTO_HUESO', 'PRODUCTO_ESTRELLA', 'SISTEMA');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'severidad_alerta') THEN
        CREATE TYPE public.severidad_alerta AS ENUM ('BAJA', 'MEDIA', 'ALTA');
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'estado_alerta') THEN
        CREATE TYPE public.estado_alerta AS ENUM ('ABIERTA', 'CERRADA');
    END IF;
END $$;

-- ============================================================
-- 2. Función updated_at
-- ============================================================

CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 3. Usuarios
-- ============================================================

CREATE TABLE IF NOT EXISTS public.usuarios (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre VARCHAR(120) NOT NULL,
    correo VARCHAR(160) NOT NULL UNIQUE,
    contrasena_hash TEXT NOT NULL,
    rol public.rol_usuario NOT NULL DEFAULT 'VENDEDOR',
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT usuarios_correo_formato_chk
        CHECK (correo LIKE '%@%')
);

DROP TRIGGER IF EXISTS trg_usuarios_updated_at ON public.usuarios;
CREATE TRIGGER trg_usuarios_updated_at
BEFORE UPDATE ON public.usuarios
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

-- ============================================================
-- 4. Categorías
-- ============================================================

CREATE TABLE IF NOT EXISTS public.categorias (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT,
    activa BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================
-- 5. Productos
-- ============================================================

CREATE TABLE IF NOT EXISTS public.productos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    categoria_id UUID NOT NULL
        REFERENCES public.categorias(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    codigo VARCHAR(40) NOT NULL UNIQUE,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,

    precio_venta NUMERIC(12,2) NOT NULL,
    costo_unitario NUMERIC(12,2) NOT NULL DEFAULT 0,

    stock INT NOT NULL DEFAULT 0,
    stock_minimo INT NOT NULL DEFAULT 1,

    estado public.estado_producto NOT NULL DEFAULT 'ACTIVO',

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT productos_precio_chk CHECK (precio_venta > 0),
    CONSTRAINT productos_costo_chk CHECK (costo_unitario >= 0),
    CONSTRAINT productos_stock_chk CHECK (stock >= 0),
    CONSTRAINT productos_stock_minimo_chk CHECK (stock_minimo >= 0)
);

DROP TRIGGER IF EXISTS trg_productos_updated_at ON public.productos;
CREATE TRIGGER trg_productos_updated_at
BEFORE UPDATE ON public.productos
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

-- ============================================================
-- 6. Ventas
-- ============================================================

CREATE TABLE IF NOT EXISTS public.ventas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    codigo VARCHAR(40) NOT NULL UNIQUE,

    usuario_id UUID NOT NULL
        REFERENCES public.usuarios(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    fecha_venta TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    subtotal NUMERIC(12,2) NOT NULL DEFAULT 0,
    descuento NUMERIC(12,2) NOT NULL DEFAULT 0,
    total NUMERIC(12,2) NOT NULL DEFAULT 0,

    observacion TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT ventas_subtotal_chk CHECK (subtotal >= 0),
    CONSTRAINT ventas_descuento_chk CHECK (descuento >= 0),
    CONSTRAINT ventas_total_chk CHECK (total >= 0),
    CONSTRAINT ventas_total_logico_chk CHECK (total = subtotal - descuento OR total >= 0)
);

-- ============================================================
-- 7. Detalle de ventas
-- ============================================================

CREATE TABLE IF NOT EXISTS public.detalle_ventas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    venta_id UUID NOT NULL
        REFERENCES public.ventas(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    producto_id UUID NOT NULL
        REFERENCES public.productos(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    cantidad INT NOT NULL,
    precio_unitario NUMERIC(12,2) NOT NULL,
    subtotal NUMERIC(12,2) NOT NULL,

    CONSTRAINT detalle_cantidad_chk CHECK (cantidad > 0),
    CONSTRAINT detalle_precio_chk CHECK (precio_unitario >= 0),
    CONSTRAINT detalle_subtotal_chk CHECK (subtotal >= 0),
    CONSTRAINT detalle_subtotal_logico_chk CHECK (subtotal = cantidad * precio_unitario)
);

-- ============================================================
-- 8. Movimientos de inventario
-- ============================================================

CREATE TABLE IF NOT EXISTS public.movimientos_inventario (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    producto_id UUID NOT NULL
        REFERENCES public.productos(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    usuario_id UUID NOT NULL
        REFERENCES public.usuarios(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    venta_id UUID
        REFERENCES public.ventas(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    tipo public.tipo_movimiento NOT NULL,
    cantidad INT NOT NULL,
    stock_anterior INT NOT NULL,
    stock_nuevo INT NOT NULL,
    motivo TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT movimientos_cantidad_chk CHECK (cantidad > 0),
    CONSTRAINT movimientos_stock_anterior_chk CHECK (stock_anterior >= 0),
    CONSTRAINT movimientos_stock_nuevo_chk CHECK (stock_nuevo >= 0)
);

-- ============================================================
-- 9. Alertas de inventario
-- ============================================================

CREATE TABLE IF NOT EXISTS public.alertas_inventario (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    producto_id UUID NOT NULL
        REFERENCES public.productos(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    tipo public.tipo_alerta NOT NULL,
    severidad public.severidad_alerta NOT NULL DEFAULT 'MEDIA',
    mensaje TEXT NOT NULL,
    estado public.estado_alerta NOT NULL DEFAULT 'ABIERTA',

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    cerrada_at TIMESTAMPTZ,

    CONSTRAINT alerta_cierre_chk CHECK (
        estado = 'ABIERTA'
        OR cerrada_at IS NOT NULL
    )
);

DROP TRIGGER IF EXISTS trg_alertas_updated_at ON public.alertas_inventario;
CREATE TRIGGER trg_alertas_updated_at
BEFORE UPDATE ON public.alertas_inventario
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

CREATE UNIQUE INDEX IF NOT EXISTS idx_alerta_abierta_producto_tipo
ON public.alertas_inventario (producto_id, tipo)
WHERE estado = 'ABIERTA';

-- ============================================================
-- 10. KPIs por producto
-- ============================================================

CREATE TABLE IF NOT EXISTS public.kpi_productos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    producto_id UUID NOT NULL
        REFERENCES public.productos(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    periodo_inicio DATE NOT NULL,
    periodo_fin DATE NOT NULL,

    unidades_vendidas INT NOT NULL DEFAULT 0,
    ingreso_total NUMERIC(12,2) NOT NULL DEFAULT 0,
    margen_estimado NUMERIC(12,2) NOT NULL DEFAULT 0,
    rotacion NUMERIC(10,2) NOT NULL DEFAULT 0,
    ranking_ventas INT,
    clasificacion VARCHAR(30) NOT NULL DEFAULT 'NORMAL',

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT kpi_periodo_chk CHECK (periodo_fin >= periodo_inicio),
    CONSTRAINT kpi_unidades_chk CHECK (unidades_vendidas >= 0),
    CONSTRAINT kpi_ingreso_chk CHECK (ingreso_total >= 0),
    CONSTRAINT kpi_rotacion_chk CHECK (rotacion >= 0),
    CONSTRAINT kpi_clasificacion_chk CHECK (clasificacion IN ('ESTRELLA', 'HUESO', 'NORMAL')),

    CONSTRAINT kpi_unico_producto_periodo UNIQUE (producto_id, periodo_inicio, periodo_fin)
);

-- ============================================================
-- 11. Reportes analíticos
-- ============================================================

CREATE TABLE IF NOT EXISTS public.reportes_analiticos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    usuario_id UUID NOT NULL
        REFERENCES public.usuarios(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    titulo VARCHAR(160) NOT NULL,
    periodo_inicio DATE NOT NULL,
    periodo_fin DATE NOT NULL,
    filtros_aplicados JSONB,

    total_ventas NUMERIC(12,2) NOT NULL DEFAULT 0,
    total_productos_vendidos INT NOT NULL DEFAULT 0,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT reporte_periodo_chk CHECK (periodo_fin >= periodo_inicio),
    CONSTRAINT reporte_total_ventas_chk CHECK (total_ventas >= 0),
    CONSTRAINT reporte_total_productos_chk CHECK (total_productos_vendidos >= 0)
);

-- ============================================================
-- 12. Trigger: descontar stock al insertar detalle de venta
-- ============================================================

CREATE OR REPLACE FUNCTION public.descontar_stock_por_venta()
RETURNS TRIGGER AS $$
DECLARE
    v_stock_actual INT;
    v_usuario_id UUID;
BEGIN
    SELECT stock INTO v_stock_actual
    FROM public.productos
    WHERE id = NEW.producto_id
    FOR UPDATE;

    IF v_stock_actual IS NULL THEN
        RAISE EXCEPTION 'Producto no encontrado.';
    END IF;

    IF v_stock_actual < NEW.cantidad THEN
        RAISE EXCEPTION 'Stock insuficiente para el producto seleccionado.';
    END IF;

    SELECT usuario_id INTO v_usuario_id
    FROM public.ventas
    WHERE id = NEW.venta_id;

    UPDATE public.productos
    SET stock = stock - NEW.cantidad,
        updated_at = NOW()
    WHERE id = NEW.producto_id;

    INSERT INTO public.movimientos_inventario (
        producto_id,
        usuario_id,
        venta_id,
        tipo,
        cantidad,
        stock_anterior,
        stock_nuevo,
        motivo
    )
    VALUES (
        NEW.producto_id,
        v_usuario_id,
        NEW.venta_id,
        'VENTA',
        NEW.cantidad,
        v_stock_actual,
        v_stock_actual - NEW.cantidad,
        'Descuento automático por venta'
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_descontar_stock_por_venta ON public.detalle_ventas;
CREATE TRIGGER trg_descontar_stock_por_venta
BEFORE INSERT ON public.detalle_ventas
FOR EACH ROW
EXECUTE FUNCTION public.descontar_stock_por_venta();

-- ============================================================
-- 13. Función: generar alertas de stock crítico
-- ============================================================

CREATE OR REPLACE FUNCTION public.generar_alertas_stock_critico()
RETURNS INT AS $$
DECLARE
    v_insertadas INT := 0;
BEGIN
    INSERT INTO public.alertas_inventario (
        producto_id,
        tipo,
        severidad,
        mensaje,
        estado
    )
    SELECT
        p.id,
        'STOCK_CRITICO'::public.tipo_alerta,
        CASE
            WHEN p.stock = 0 THEN 'ALTA'::public.severidad_alerta
            WHEN p.stock <= p.stock_minimo THEN 'MEDIA'::public.severidad_alerta
            ELSE 'BAJA'::public.severidad_alerta
        END,
        'Producto con stock crítico. Revisar reposición.',
        'ABIERTA'::public.estado_alerta
    FROM public.productos p
    WHERE p.estado = 'ACTIVO'
      AND p.stock <= p.stock_minimo
      AND NOT EXISTS (
          SELECT 1
          FROM public.alertas_inventario a
          WHERE a.producto_id = p.id
            AND a.tipo = 'STOCK_CRITICO'
            AND a.estado = 'ABIERTA'
      );

    GET DIAGNOSTICS v_insertadas = ROW_COUNT;
    RETURN v_insertadas;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 14. Función DSS: calcular KPIs por periodo
-- ============================================================

CREATE OR REPLACE FUNCTION public.calcular_kpi_productos(
    p_inicio DATE,
    p_fin DATE
)
RETURNS INT AS $$
DECLARE
    v_insertadas INT := 0;
BEGIN
    INSERT INTO public.kpi_productos (
        producto_id,
        periodo_inicio,
        periodo_fin,
        unidades_vendidas,
        ingreso_total,
        margen_estimado,
        rotacion,
        ranking_ventas,
        clasificacion
    )
    WITH ventas_producto AS (
        SELECT
            p.id AS producto_id,
            COALESCE(SUM(dv.cantidad), 0) AS unidades_vendidas,
            COALESCE(SUM(dv.subtotal), 0) AS ingreso_total,
            COALESCE(SUM((dv.precio_unitario - p.costo_unitario) * dv.cantidad), 0) AS margen_estimado,
            p.stock
        FROM public.productos p
        LEFT JOIN public.detalle_ventas dv ON dv.producto_id = p.id
        LEFT JOIN public.ventas v ON v.id = dv.venta_id
            AND v.fecha_venta::DATE BETWEEN p_inicio AND p_fin
        GROUP BY p.id, p.stock
    ),
    ranking AS (
        SELECT
            producto_id,
            unidades_vendidas,
            ingreso_total,
            margen_estimado,
            CASE
                WHEN stock + unidades_vendidas > 0
                THEN ROUND(unidades_vendidas::NUMERIC / (stock + unidades_vendidas)::NUMERIC, 2)
                ELSE 0
            END AS rotacion,
            RANK() OVER (ORDER BY unidades_vendidas DESC, ingreso_total DESC) AS ranking_ventas
        FROM ventas_producto
    )
    SELECT
        producto_id,
        p_inicio,
        p_fin,
        unidades_vendidas,
        ingreso_total,
        margen_estimado,
        rotacion,
        ranking_ventas,
        CASE
            WHEN ranking_ventas <= 5 AND unidades_vendidas > 0 THEN 'ESTRELLA'
            WHEN unidades_vendidas = 0 THEN 'HUESO'
            ELSE 'NORMAL'
        END AS clasificacion
    FROM ranking
    ON CONFLICT (producto_id, periodo_inicio, periodo_fin)
    DO UPDATE SET
        unidades_vendidas = EXCLUDED.unidades_vendidas,
        ingreso_total = EXCLUDED.ingreso_total,
        margen_estimado = EXCLUDED.margen_estimado,
        rotacion = EXCLUDED.rotacion,
        ranking_ventas = EXCLUDED.ranking_ventas,
        clasificacion = EXCLUDED.clasificacion;

    GET DIAGNOSTICS v_insertadas = ROW_COUNT;
    RETURN v_insertadas;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 15. Vistas DSS
-- ============================================================

CREATE OR REPLACE VIEW public.v_productos_stock_critico AS
SELECT
    p.id,
    p.codigo,
    p.nombre,
    c.nombre AS categoria,
    p.stock,
    p.stock_minimo,
    p.precio_venta,
    p.estado
FROM public.productos p
INNER JOIN public.categorias c ON c.id = p.categoria_id
WHERE p.estado = 'ACTIVO'
  AND p.stock <= p.stock_minimo;

CREATE OR REPLACE VIEW public.v_ventas_por_producto AS
SELECT
    p.id AS producto_id,
    p.codigo,
    p.nombre,
    c.nombre AS categoria,
    COALESCE(SUM(dv.cantidad), 0) AS unidades_vendidas,
    COALESCE(SUM(dv.subtotal), 0) AS ingreso_total
FROM public.productos p
INNER JOIN public.categorias c ON c.id = p.categoria_id
LEFT JOIN public.detalle_ventas dv ON dv.producto_id = p.id
LEFT JOIN public.ventas v ON v.id = dv.venta_id
GROUP BY p.id, p.codigo, p.nombre, c.nombre;

CREATE OR REPLACE VIEW public.v_dashboard_smartsales AS
SELECT
    (SELECT COUNT(*) FROM public.productos WHERE estado = 'ACTIVO') AS productos_activos,
    (SELECT COUNT(*) FROM public.v_productos_stock_critico) AS productos_stock_critico,
    (SELECT COALESCE(SUM(total), 0) FROM public.ventas) AS ingresos_totales,
    (SELECT COUNT(*) FROM public.ventas) AS total_ventas,
    (SELECT COUNT(*) FROM public.alertas_inventario WHERE estado = 'ABIERTA') AS alertas_abiertas;

-- ============================================================
-- 16. Índices
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_productos_categoria ON public.productos (categoria_id);
CREATE INDEX IF NOT EXISTS idx_productos_estado ON public.productos (estado);
CREATE INDEX IF NOT EXISTS idx_productos_stock ON public.productos (stock);
CREATE INDEX IF NOT EXISTS idx_ventas_fecha ON public.ventas (fecha_venta);
CREATE INDEX IF NOT EXISTS idx_ventas_usuario ON public.ventas (usuario_id);
CREATE INDEX IF NOT EXISTS idx_detalle_producto ON public.detalle_ventas (producto_id);
CREATE INDEX IF NOT EXISTS idx_detalle_venta ON public.detalle_ventas (venta_id);
CREATE INDEX IF NOT EXISTS idx_movimientos_producto ON public.movimientos_inventario (producto_id);
CREATE INDEX IF NOT EXISTS idx_alertas_estado ON public.alertas_inventario (estado);
CREATE INDEX IF NOT EXISTS idx_alertas_tipo ON public.alertas_inventario (tipo);
CREATE INDEX IF NOT EXISTS idx_kpi_periodo ON public.kpi_productos (periodo_inicio, periodo_fin);
CREATE INDEX IF NOT EXISTS idx_kpi_clasificacion ON public.kpi_productos (clasificacion);

-- ============================================================
-- 17. Comentarios
-- ============================================================

COMMENT ON TABLE public.productos IS 'Catálogo e inventario de productos de la tienda minorista.';
COMMENT ON TABLE public.ventas IS 'Cabecera de ventas registradas en SmartSales DSS.';
COMMENT ON TABLE public.detalle_ventas IS 'Detalle de productos vendidos por transacción.';
COMMENT ON TABLE public.movimientos_inventario IS 'Auditoría de cambios de stock.';
COMMENT ON TABLE public.alertas_inventario IS 'Alertas DSS para stock crítico y eventos comerciales.';
COMMENT ON TABLE public.kpi_productos IS 'Indicadores de productos estrella, hueso y rotación.';
COMMENT ON VIEW public.v_dashboard_smartsales IS 'Resumen general para dashboard analítico del DSS.';

-- ============================================================
-- Fin del script
-- ============================================================
