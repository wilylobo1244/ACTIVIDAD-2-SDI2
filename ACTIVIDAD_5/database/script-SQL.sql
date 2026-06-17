-- ============================================================
-- SmartRoute DSS - Script SQL inicial para Supabase
-- Actividad 5: Arquitectura de Persistencia
-- Caso: FlashLogistics - El Caos de la Distribución
-- Squad: Cacatúas
-- ============================================================

-- Este script está diseñado para PostgreSQL / Supabase.
-- Recomendación: ejecutarlo desde el SQL Editor de Supabase.

-- ============================================================
-- 1. Extensiones
-- ============================================================

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- ============================================================
-- 2. Limpieza opcional
-- ============================================================
-- IMPORTANTE:
-- Descomentar este bloque solo si se quiere reiniciar el modelo
-- durante pruebas. En producción NO se recomienda usar DROP.

-- DROP TABLE IF EXISTS public.kpi_operativos CASCADE;
-- DROP TABLE IF EXISTS public.alertas CASCADE;
-- DROP TABLE IF EXISTS public.incidencias CASCADE;
-- DROP TABLE IF EXISTS public.historial_estados CASCADE;
-- DROP TABLE IF EXISTS public.ruta_pedidos CASCADE;
-- DROP TABLE IF EXISTS public.rutas CASCADE;
-- DROP TABLE IF EXISTS public.pedidos CASCADE;
-- DROP TABLE IF EXISTS public.vehiculos CASCADE;
-- DROP TABLE IF EXISTS public.conductores CASCADE;
-- DROP TABLE IF EXISTS public.clientes_empresas CASCADE;
-- DROP TABLE IF EXISTS public.usuarios CASCADE;

-- ============================================================
-- 3. Dominios ENUM
-- ============================================================

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'rol_usuario') THEN
        CREATE TYPE public.rol_usuario AS ENUM (
            'ADMIN',
            'GERENTE',
            'DESPACHADOR',
            'CONDUCTOR'
        );
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'estado_conductor') THEN
        CREATE TYPE public.estado_conductor AS ENUM (
            'ACTIVO',
            'INACTIVO',
            'SUSPENDIDO'
        );
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'estado_vehiculo') THEN
        CREATE TYPE public.estado_vehiculo AS ENUM (
            'DISPONIBLE',
            'EN_RUTA',
            'MANTENIMIENTO',
            'INACTIVO'
        );
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'prioridad_pedido') THEN
        CREATE TYPE public.prioridad_pedido AS ENUM (
            'BAJA',
            'MEDIA',
            'ALTA'
        );
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'estado_pedido') THEN
        CREATE TYPE public.estado_pedido AS ENUM (
            'PENDIENTE',
            'ASIGNADO',
            'EN_RUTA',
            'ENTREGADO',
            'FALLIDO',
            'INCIDENCIA'
        );
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'estado_ruta') THEN
        CREATE TYPE public.estado_ruta AS ENUM (
            'BORRADOR',
            'PLANIFICADA',
            'EN_RUTA',
            'CERRADA',
            'CANCELADA'
        );
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'estado_parada') THEN
        CREATE TYPE public.estado_parada AS ENUM (
            'PENDIENTE',
            'VISITADO',
            'CANCELADO'
        );
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'tipo_incidencia') THEN
        CREATE TYPE public.tipo_incidencia AS ENUM (
            'RETRASO',
            'DIRECCION_INCORRECTA',
            'CLIENTE_AUSENTE',
            'FALLA_VEHICULO',
            'OTRO'
        );
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'estado_incidencia') THEN
        CREATE TYPE public.estado_incidencia AS ENUM (
            'ABIERTA',
            'EN_ATENCION',
            'RESUELTA',
            'CERRADA'
        );
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'tipo_alerta') THEN
        CREATE TYPE public.tipo_alerta AS ENUM (
            'RETRASO',
            'INCIDENCIA',
            'SISTEMA'
        );
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'severidad_alerta') THEN
        CREATE TYPE public.severidad_alerta AS ENUM (
            'BAJA',
            'MEDIA',
            'ALTA'
        );
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'estado_alerta') THEN
        CREATE TYPE public.estado_alerta AS ENUM (
            'ABIERTA',
            'CERRADA'
        );
    END IF;
END $$;

-- ============================================================
-- 4. Función genérica updated_at
-- ============================================================

CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 5. Tabla: usuarios
-- ============================================================

CREATE TABLE IF NOT EXISTS public.usuarios (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Campo opcional para integrarse con Supabase Auth.
    -- Puede quedar NULL durante pruebas académicas.
    auth_user_id UUID UNIQUE REFERENCES auth.users(id) ON DELETE SET NULL,

    nombre VARCHAR(120) NOT NULL,
    email VARCHAR(160) NOT NULL UNIQUE,
    rol public.rol_usuario NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT usuarios_email_formato_chk
        CHECK (email LIKE '%@%')
);

CREATE TRIGGER trg_usuarios_updated_at
BEFORE UPDATE ON public.usuarios
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

-- ============================================================
-- 6. Tabla: conductores
-- ============================================================

CREATE TABLE IF NOT EXISTS public.conductores (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    usuario_id UUID NOT NULL UNIQUE
        REFERENCES public.usuarios(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    telefono VARCHAR(30),
    licencia VARCHAR(60) NOT NULL UNIQUE,
    disponible BOOLEAN NOT NULL DEFAULT TRUE,
    estado public.estado_conductor NOT NULL DEFAULT 'ACTIVO',

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TRIGGER trg_conductores_updated_at
BEFORE UPDATE ON public.conductores
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

-- ============================================================
-- 7. Tabla: clientes_empresas
-- ============================================================

CREATE TABLE IF NOT EXISTS public.clientes_empresas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    razon_social VARCHAR(160) NOT NULL,
    nit VARCHAR(40) UNIQUE,
    telefono VARCHAR(30),
    email VARCHAR(160),
    contacto_principal VARCHAR(120),
    activo BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT clientes_email_formato_chk
        CHECK (email IS NULL OR email LIKE '%@%')
);

CREATE TRIGGER trg_clientes_empresas_updated_at
BEFORE UPDATE ON public.clientes_empresas
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

-- ============================================================
-- 8. Tabla: vehiculos
-- ============================================================

CREATE TABLE IF NOT EXISTS public.vehiculos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    placa VARCHAR(20) NOT NULL UNIQUE,
    tipo VARCHAR(60) NOT NULL,
    capacidad_kg NUMERIC(10,2) NOT NULL DEFAULT 0,
    estado public.estado_vehiculo NOT NULL DEFAULT 'DISPONIBLE',
    activo BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT vehiculos_capacidad_chk
        CHECK (capacidad_kg >= 0)
);

CREATE TRIGGER trg_vehiculos_updated_at
BEFORE UPDATE ON public.vehiculos
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

-- ============================================================
-- 9. Tabla: pedidos
-- ============================================================

CREATE TABLE IF NOT EXISTS public.pedidos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    codigo VARCHAR(40) NOT NULL UNIQUE,

    cliente_id UUID NOT NULL
        REFERENCES public.clientes_empresas(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    direccion_entrega VARCHAR(250) NOT NULL,
    latitud NUMERIC(10,7),
    longitud NUMERIC(10,7),

    prioridad public.prioridad_pedido NOT NULL DEFAULT 'MEDIA',
    ventana_inicio TIMESTAMPTZ,
    ventana_fin TIMESTAMPTZ,

    estado public.estado_pedido NOT NULL DEFAULT 'PENDIENTE',

    hora_estimada_entrega TIMESTAMPTZ,
    hora_entrega_real TIMESTAMPTZ,

    observacion TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT pedidos_latitud_chk
        CHECK (latitud IS NULL OR (latitud >= -90 AND latitud <= 90)),

    CONSTRAINT pedidos_longitud_chk
        CHECK (longitud IS NULL OR (longitud >= -180 AND longitud <= 180)),

    CONSTRAINT pedidos_ventana_chk
        CHECK (
            ventana_inicio IS NULL
            OR ventana_fin IS NULL
            OR ventana_fin > ventana_inicio
        ),

    CONSTRAINT pedidos_entrega_real_chk
        CHECK (
            hora_entrega_real IS NULL
            OR estado IN ('ENTREGADO', 'FALLIDO', 'INCIDENCIA')
        )
);

CREATE TRIGGER trg_pedidos_updated_at
BEFORE UPDATE ON public.pedidos
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

-- ============================================================
-- 10. Tabla: rutas
-- ============================================================

CREATE TABLE IF NOT EXISTS public.rutas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    codigo VARCHAR(40) NOT NULL UNIQUE,
    fecha DATE NOT NULL,

    conductor_id UUID NOT NULL
        REFERENCES public.conductores(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    vehiculo_id UUID NOT NULL
        REFERENCES public.vehiculos(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    estado public.estado_ruta NOT NULL DEFAULT 'BORRADOR',

    hora_inicio_estimada TIMESTAMPTZ,
    hora_fin_estimada TIMESTAMPTZ,

    distancia_km NUMERIC(10,2) NOT NULL DEFAULT 0,
    costo_estimado NUMERIC(12,2) NOT NULL DEFAULT 0,

    observacion TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT rutas_horas_chk
        CHECK (
            hora_inicio_estimada IS NULL
            OR hora_fin_estimada IS NULL
            OR hora_fin_estimada > hora_inicio_estimada
        ),

    CONSTRAINT rutas_distancia_chk
        CHECK (distancia_km >= 0),

    CONSTRAINT rutas_costo_chk
        CHECK (costo_estimado >= 0)
);

CREATE TRIGGER trg_rutas_updated_at
BEFORE UPDATE ON public.rutas
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

-- ============================================================
-- 11. Tabla: ruta_pedidos
-- ============================================================

CREATE TABLE IF NOT EXISTS public.ruta_pedidos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    ruta_id UUID NOT NULL
        REFERENCES public.rutas(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    pedido_id UUID NOT NULL
        REFERENCES public.pedidos(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    orden_parada INT NOT NULL,
    eta TIMESTAMPTZ,
    hora_llegada TIMESTAMPTZ,

    estado_en_ruta public.estado_parada NOT NULL DEFAULT 'PENDIENTE',

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT ruta_pedidos_orden_chk
        CHECK (orden_parada > 0),

    CONSTRAINT ruta_pedidos_unico_pedido_por_ruta
        UNIQUE (ruta_id, pedido_id),

    CONSTRAINT ruta_pedidos_unico_orden_por_ruta
        UNIQUE (ruta_id, orden_parada)
);

CREATE TRIGGER trg_ruta_pedidos_updated_at
BEFORE UPDATE ON public.ruta_pedidos
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

-- ============================================================
-- 12. Tabla: historial_estados
-- ============================================================

CREATE TABLE IF NOT EXISTS public.historial_estados (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    pedido_id UUID NOT NULL
        REFERENCES public.pedidos(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    usuario_id UUID NOT NULL
        REFERENCES public.usuarios(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    estado_anterior public.estado_pedido,
    estado_nuevo public.estado_pedido NOT NULL,
    observacion TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT historial_observacion_obligatoria_chk
        CHECK (
            estado_nuevo NOT IN ('FALLIDO', 'INCIDENCIA')
            OR observacion IS NOT NULL
        )
);

-- ============================================================
-- 13. Tabla: incidencias
-- ============================================================

CREATE TABLE IF NOT EXISTS public.incidencias (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    pedido_id UUID NOT NULL
        REFERENCES public.pedidos(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    ruta_id UUID
        REFERENCES public.rutas(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    reportado_por UUID NOT NULL
        REFERENCES public.usuarios(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    tipo public.tipo_incidencia NOT NULL,
    descripcion TEXT NOT NULL,
    estado public.estado_incidencia NOT NULL DEFAULT 'ABIERTA',

    solucion TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    resuelta_at TIMESTAMPTZ,

    CONSTRAINT incidencias_resolucion_chk
        CHECK (
            estado NOT IN ('RESUELTA', 'CERRADA')
            OR solucion IS NOT NULL
        )
);

CREATE TRIGGER trg_incidencias_updated_at
BEFORE UPDATE ON public.incidencias
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

-- ============================================================
-- 14. Tabla: alertas
-- ============================================================

CREATE TABLE IF NOT EXISTS public.alertas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    pedido_id UUID
        REFERENCES public.pedidos(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    ruta_id UUID
        REFERENCES public.rutas(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    incidencia_id UUID
        REFERENCES public.incidencias(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    tipo public.tipo_alerta NOT NULL,
    severidad public.severidad_alerta NOT NULL DEFAULT 'MEDIA',
    motivo TEXT NOT NULL,
    estado public.estado_alerta NOT NULL DEFAULT 'ABIERTA',

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    cerrada_at TIMESTAMPTZ,

    CONSTRAINT alertas_referencia_minima_chk
        CHECK (
            pedido_id IS NOT NULL
            OR ruta_id IS NOT NULL
            OR incidencia_id IS NOT NULL
        ),

    CONSTRAINT alertas_cierre_chk
        CHECK (
            estado = 'ABIERTA'
            OR cerrada_at IS NOT NULL
        )
);

CREATE TRIGGER trg_alertas_updated_at
BEFORE UPDATE ON public.alertas
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

-- Evita duplicar alertas abiertas del mismo tipo para el mismo pedido.
CREATE UNIQUE INDEX IF NOT EXISTS idx_alertas_unica_abierta_por_pedido_tipo
ON public.alertas (pedido_id, tipo)
WHERE estado = 'ABIERTA' AND pedido_id IS NOT NULL;

-- ============================================================
-- 15. Tabla: kpi_operativos
-- ============================================================

CREATE TABLE IF NOT EXISTS public.kpi_operativos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    fecha DATE NOT NULL,

    ruta_id UUID
        REFERENCES public.rutas(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    conductor_id UUID
        REFERENCES public.conductores(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    total_pedidos INT NOT NULL DEFAULT 0,
    entregados_a_tiempo INT NOT NULL DEFAULT 0,
    entregados_tarde INT NOT NULL DEFAULT 0,
    fallidos INT NOT NULL DEFAULT 0,
    incidencias INT NOT NULL DEFAULT 0,

    puntualidad_pct NUMERIC(5,2) NOT NULL DEFAULT 0,
    costo_estimado NUMERIC(12,2) NOT NULL DEFAULT 0,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT kpi_total_pedidos_chk
        CHECK (total_pedidos >= 0),

    CONSTRAINT kpi_entregados_a_tiempo_chk
        CHECK (entregados_a_tiempo >= 0),

    CONSTRAINT kpi_entregados_tarde_chk
        CHECK (entregados_tarde >= 0),

    CONSTRAINT kpi_fallidos_chk
        CHECK (fallidos >= 0),

    CONSTRAINT kpi_incidencias_chk
        CHECK (incidencias >= 0),

    CONSTRAINT kpi_puntualidad_chk
        CHECK (puntualidad_pct >= 0 AND puntualidad_pct <= 100),

    CONSTRAINT kpi_costo_chk
        CHECK (costo_estimado >= 0),

    CONSTRAINT kpi_conteo_logico_chk
        CHECK (
            entregados_a_tiempo + entregados_tarde + fallidos <= total_pedidos
        )
);

-- Evita duplicar KPI de una misma fecha para la misma ruta y conductor.
CREATE UNIQUE INDEX IF NOT EXISTS idx_kpi_fecha_ruta_conductor
ON public.kpi_operativos (fecha, ruta_id, conductor_id);

-- ============================================================
-- 16. Triggers de reglas de negocio
-- ============================================================

-- ------------------------------------------------------------
-- RN01: Validar que una ruta use conductor activo/disponible
-- y vehículo activo/disponible.
-- ------------------------------------------------------------

CREATE OR REPLACE FUNCTION public.validar_recursos_ruta()
RETURNS TRIGGER AS $$
DECLARE
    v_conductor_estado public.estado_conductor;
    v_conductor_disponible BOOLEAN;
    v_vehiculo_estado public.estado_vehiculo;
    v_vehiculo_activo BOOLEAN;
BEGIN
    SELECT estado, disponible
    INTO v_conductor_estado, v_conductor_disponible
    FROM public.conductores
    WHERE id = NEW.conductor_id;

    IF v_conductor_estado IS DISTINCT FROM 'ACTIVO'
       OR v_conductor_disponible IS DISTINCT FROM TRUE THEN
        RAISE EXCEPTION 'El conductor no está activo o disponible para recibir rutas.';
    END IF;

    SELECT estado, activo
    INTO v_vehiculo_estado, v_vehiculo_activo
    FROM public.vehiculos
    WHERE id = NEW.vehiculo_id;

    IF v_vehiculo_estado IS DISTINCT FROM 'DISPONIBLE'
       OR v_vehiculo_activo IS DISTINCT FROM TRUE THEN
        RAISE EXCEPTION 'El vehículo no está disponible para ser asignado a una ruta.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_validar_recursos_ruta ON public.rutas;

CREATE TRIGGER trg_validar_recursos_ruta
BEFORE INSERT OR UPDATE OF conductor_id, vehiculo_id
ON public.rutas
FOR EACH ROW
EXECUTE FUNCTION public.validar_recursos_ruta();

-- ------------------------------------------------------------
-- RN02: Evitar que un pedido esté en dos rutas activas.
-- Rutas activas: BORRADOR, PLANIFICADA, EN_RUTA.
-- ------------------------------------------------------------

CREATE OR REPLACE FUNCTION public.validar_pedido_sin_ruta_activa()
RETURNS TRIGGER AS $$
DECLARE
    v_existe BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT 1
        FROM public.ruta_pedidos rp
        INNER JOIN public.rutas r ON r.id = rp.ruta_id
        WHERE rp.pedido_id = NEW.pedido_id
          AND rp.id <> COALESCE(NEW.id, gen_random_uuid())
          AND r.estado IN ('BORRADOR', 'PLANIFICADA', 'EN_RUTA')
    )
    INTO v_existe;

    IF v_existe THEN
        RAISE EXCEPTION 'El pedido ya está asignado a una ruta activa.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_validar_pedido_sin_ruta_activa ON public.ruta_pedidos;

CREATE TRIGGER trg_validar_pedido_sin_ruta_activa
BEFORE INSERT OR UPDATE OF pedido_id
ON public.ruta_pedidos
FOR EACH ROW
EXECUTE FUNCTION public.validar_pedido_sin_ruta_activa();

-- ------------------------------------------------------------
-- RN03: Al asignar un pedido a una ruta, actualizar estado.
-- ------------------------------------------------------------

CREATE OR REPLACE FUNCTION public.marcar_pedido_asignado()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE public.pedidos
    SET estado = 'ASIGNADO',
        updated_at = NOW()
    WHERE id = NEW.pedido_id
      AND estado = 'PENDIENTE';

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_marcar_pedido_asignado ON public.ruta_pedidos;

CREATE TRIGGER trg_marcar_pedido_asignado
AFTER INSERT ON public.ruta_pedidos
FOR EACH ROW
EXECUTE FUNCTION public.marcar_pedido_asignado();

-- ------------------------------------------------------------
-- RN04: Al registrar historial de estado, actualizar pedido.
-- ------------------------------------------------------------

CREATE OR REPLACE FUNCTION public.sincronizar_estado_pedido()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE public.pedidos
    SET estado = NEW.estado_nuevo,
        updated_at = NOW(),
        hora_entrega_real = CASE
            WHEN NEW.estado_nuevo IN ('ENTREGADO', 'FALLIDO')
            THEN NOW()
            ELSE hora_entrega_real
        END
    WHERE id = NEW.pedido_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_sincronizar_estado_pedido ON public.historial_estados;

CREATE TRIGGER trg_sincronizar_estado_pedido
AFTER INSERT ON public.historial_estados
FOR EACH ROW
EXECUTE FUNCTION public.sincronizar_estado_pedido();

-- ------------------------------------------------------------
-- RN05: Si el estado nuevo es INCIDENCIA o FALLIDO,
-- crear incidencia automáticamente si no existe una abierta.
-- ------------------------------------------------------------

CREATE OR REPLACE FUNCTION public.crear_incidencia_desde_historial()
RETURNS TRIGGER AS $$
DECLARE
    v_ruta_id UUID;
BEGIN
    IF NEW.estado_nuevo IN ('INCIDENCIA', 'FALLIDO') THEN

        SELECT rp.ruta_id
        INTO v_ruta_id
        FROM public.ruta_pedidos rp
        INNER JOIN public.rutas r ON r.id = rp.ruta_id
        WHERE rp.pedido_id = NEW.pedido_id
          AND r.estado IN ('PLANIFICADA', 'EN_RUTA')
        ORDER BY rp.created_at DESC
        LIMIT 1;

        IF NOT EXISTS (
            SELECT 1
            FROM public.incidencias
            WHERE pedido_id = NEW.pedido_id
              AND estado IN ('ABIERTA', 'EN_ATENCION')
        ) THEN
            INSERT INTO public.incidencias (
                pedido_id,
                ruta_id,
                reportado_por,
                tipo,
                descripcion,
                estado
            )
            VALUES (
                NEW.pedido_id,
                v_ruta_id,
                NEW.usuario_id,
                CASE
                    WHEN NEW.estado_nuevo = 'FALLIDO' THEN 'OTRO'::public.tipo_incidencia
                    ELSE 'RETRASO'::public.tipo_incidencia
                END,
                COALESCE(NEW.observacion, 'Incidencia generada desde cambio de estado.'),
                'ABIERTA'
            );
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_crear_incidencia_desde_historial ON public.historial_estados;

CREATE TRIGGER trg_crear_incidencia_desde_historial
AFTER INSERT ON public.historial_estados
FOR EACH ROW
EXECUTE FUNCTION public.crear_incidencia_desde_historial();

-- ============================================================
-- 17. Función DSS: generar alertas de retraso
-- ============================================================

CREATE OR REPLACE FUNCTION public.generar_alertas_retraso()
RETURNS INT AS $$
DECLARE
    v_insertadas INT := 0;
BEGIN
    INSERT INTO public.alertas (
        pedido_id,
        ruta_id,
        tipo,
        severidad,
        motivo,
        estado
    )
    SELECT
        p.id AS pedido_id,
        rp.ruta_id,
        'RETRASO'::public.tipo_alerta,
        CASE
            WHEN NOW() - p.hora_estimada_entrega > INTERVAL '2 hours'
                THEN 'ALTA'::public.severidad_alerta
            WHEN NOW() - p.hora_estimada_entrega > INTERVAL '1 hour'
                THEN 'MEDIA'::public.severidad_alerta
            ELSE 'BAJA'::public.severidad_alerta
        END AS severidad,
        'Pedido retrasado respecto a la hora estimada de entrega.' AS motivo,
        'ABIERTA'::public.estado_alerta
    FROM public.pedidos p
    INNER JOIN public.ruta_pedidos rp ON rp.pedido_id = p.id
    INNER JOIN public.rutas r ON r.id = rp.ruta_id
    WHERE p.estado IN ('ASIGNADO', 'EN_RUTA')
      AND p.hora_estimada_entrega IS NOT NULL
      AND p.hora_estimada_entrega < NOW()
      AND r.estado IN ('PLANIFICADA', 'EN_RUTA')
      AND NOT EXISTS (
          SELECT 1
          FROM public.alertas a
          WHERE a.pedido_id = p.id
            AND a.tipo = 'RETRASO'
            AND a.estado = 'ABIERTA'
      );

    GET DIAGNOSTICS v_insertadas = ROW_COUNT;

    RETURN v_insertadas;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 18. Función DSS: calcular KPI por ruta
-- ============================================================

CREATE OR REPLACE FUNCTION public.calcular_kpi_ruta(p_ruta_id UUID)
RETURNS UUID AS $$
DECLARE
    v_kpi_id UUID;
    v_fecha DATE;
    v_conductor_id UUID;
    v_total INT;
    v_a_tiempo INT;
    v_tarde INT;
    v_fallidos INT;
    v_incidencias INT;
    v_puntualidad NUMERIC(5,2);
    v_costo NUMERIC(12,2);
BEGIN
    SELECT fecha, conductor_id, costo_estimado
    INTO v_fecha, v_conductor_id, v_costo
    FROM public.rutas
    WHERE id = p_ruta_id;

    SELECT COUNT(*)
    INTO v_total
    FROM public.ruta_pedidos
    WHERE ruta_id = p_ruta_id;

    SELECT COUNT(*)
    INTO v_a_tiempo
    FROM public.ruta_pedidos rp
    INNER JOIN public.pedidos p ON p.id = rp.pedido_id
    WHERE rp.ruta_id = p_ruta_id
      AND p.estado = 'ENTREGADO'
      AND p.hora_entrega_real IS NOT NULL
      AND p.hora_estimada_entrega IS NOT NULL
      AND p.hora_entrega_real <= p.hora_estimada_entrega;

    SELECT COUNT(*)
    INTO v_tarde
    FROM public.ruta_pedidos rp
    INNER JOIN public.pedidos p ON p.id = rp.pedido_id
    WHERE rp.ruta_id = p_ruta_id
      AND p.estado = 'ENTREGADO'
      AND p.hora_entrega_real IS NOT NULL
      AND p.hora_estimada_entrega IS NOT NULL
      AND p.hora_entrega_real > p.hora_estimada_entrega;

    SELECT COUNT(*)
    INTO v_fallidos
    FROM public.ruta_pedidos rp
    INNER JOIN public.pedidos p ON p.id = rp.pedido_id
    WHERE rp.ruta_id = p_ruta_id
      AND p.estado = 'FALLIDO';

    SELECT COUNT(*)
    INTO v_incidencias
    FROM public.incidencias
    WHERE ruta_id = p_ruta_id;

    IF v_total > 0 THEN
        v_puntualidad := ROUND((v_a_tiempo::NUMERIC / v_total::NUMERIC) * 100, 2);
    ELSE
        v_puntualidad := 0;
    END IF;

    INSERT INTO public.kpi_operativos (
        fecha,
        ruta_id,
        conductor_id,
        total_pedidos,
        entregados_a_tiempo,
        entregados_tarde,
        fallidos,
        incidencias,
        puntualidad_pct,
        costo_estimado
    )
    VALUES (
        v_fecha,
        p_ruta_id,
        v_conductor_id,
        v_total,
        v_a_tiempo,
        v_tarde,
        v_fallidos,
        v_incidencias,
        v_puntualidad,
        COALESCE(v_costo, 0)
    )
    ON CONFLICT (fecha, ruta_id, conductor_id)
    DO UPDATE SET
        total_pedidos = EXCLUDED.total_pedidos,
        entregados_a_tiempo = EXCLUDED.entregados_a_tiempo,
        entregados_tarde = EXCLUDED.entregados_tarde,
        fallidos = EXCLUDED.fallidos,
        incidencias = EXCLUDED.incidencias,
        puntualidad_pct = EXCLUDED.puntualidad_pct,
        costo_estimado = EXCLUDED.costo_estimado
    RETURNING id INTO v_kpi_id;

    RETURN v_kpi_id;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- 19. Índices recomendados para consultas DSS
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_pedidos_cliente
ON public.pedidos (cliente_id);

CREATE INDEX IF NOT EXISTS idx_pedidos_estado
ON public.pedidos (estado);

CREATE INDEX IF NOT EXISTS idx_pedidos_prioridad
ON public.pedidos (prioridad);

CREATE INDEX IF NOT EXISTS idx_pedidos_hora_estimada
ON public.pedidos (hora_estimada_entrega);

CREATE INDEX IF NOT EXISTS idx_rutas_fecha
ON public.rutas (fecha);

CREATE INDEX IF NOT EXISTS idx_rutas_estado
ON public.rutas (estado);

CREATE INDEX IF NOT EXISTS idx_rutas_conductor
ON public.rutas (conductor_id);

CREATE INDEX IF NOT EXISTS idx_rutas_vehiculo
ON public.rutas (vehiculo_id);

CREATE INDEX IF NOT EXISTS idx_ruta_pedidos_ruta
ON public.ruta_pedidos (ruta_id);

CREATE INDEX IF NOT EXISTS idx_ruta_pedidos_pedido
ON public.ruta_pedidos (pedido_id);

CREATE INDEX IF NOT EXISTS idx_historial_pedido
ON public.historial_estados (pedido_id);

CREATE INDEX IF NOT EXISTS idx_historial_created_at
ON public.historial_estados (created_at);

CREATE INDEX IF NOT EXISTS idx_incidencias_estado
ON public.incidencias (estado);

CREATE INDEX IF NOT EXISTS idx_incidencias_pedido
ON public.incidencias (pedido_id);

CREATE INDEX IF NOT EXISTS idx_alertas_estado
ON public.alertas (estado);

CREATE INDEX IF NOT EXISTS idx_alertas_severidad
ON public.alertas (severidad);

CREATE INDEX IF NOT EXISTS idx_alertas_tipo
ON public.alertas (tipo);

CREATE INDEX IF NOT EXISTS idx_kpi_fecha
ON public.kpi_operativos (fecha);

CREATE INDEX IF NOT EXISTS idx_kpi_conductor
ON public.kpi_operativos (conductor_id);

-- ============================================================
-- 20. Vista DSS: dashboard operativo
-- ============================================================

CREATE OR REPLACE VIEW public.v_dashboard_operativo AS
SELECT
    r.id AS ruta_id,
    r.codigo AS ruta_codigo,
    r.fecha,
    r.estado AS estado_ruta,

    c.id AS conductor_id,
    u.nombre AS conductor_nombre,

    v.id AS vehiculo_id,
    v.placa AS vehiculo_placa,

    COUNT(rp.id) AS total_pedidos,

    COUNT(*) FILTER (
        WHERE p.estado = 'ENTREGADO'
    ) AS pedidos_entregados,

    COUNT(*) FILTER (
        WHERE p.estado = 'FALLIDO'
    ) AS pedidos_fallidos,

    COUNT(*) FILTER (
        WHERE p.estado = 'INCIDENCIA'
    ) AS pedidos_con_incidencia,

    COUNT(*) FILTER (
        WHERE p.estado IN ('ASIGNADO', 'EN_RUTA')
          AND p.hora_estimada_entrega IS NOT NULL
          AND p.hora_estimada_entrega < NOW()
    ) AS pedidos_retrasados,

    COUNT(a.id) FILTER (
        WHERE a.estado = 'ABIERTA'
    ) AS alertas_abiertas

FROM public.rutas r
INNER JOIN public.conductores c ON c.id = r.conductor_id
INNER JOIN public.usuarios u ON u.id = c.usuario_id
INNER JOIN public.vehiculos v ON v.id = r.vehiculo_id
LEFT JOIN public.ruta_pedidos rp ON rp.ruta_id = r.id
LEFT JOIN public.pedidos p ON p.id = rp.pedido_id
LEFT JOIN public.alertas a ON a.ruta_id = r.id
GROUP BY
    r.id,
    r.codigo,
    r.fecha,
    r.estado,
    c.id,
    u.nombre,
    v.id,
    v.placa;

-- ============================================================
-- 21. Vista DSS: pedidos con trazabilidad
-- ============================================================

CREATE OR REPLACE VIEW public.v_pedidos_trazabilidad AS
SELECT
    p.id AS pedido_id,
    p.codigo AS pedido_codigo,
    ce.razon_social AS cliente,
    p.direccion_entrega,
    p.prioridad,
    p.estado,
    p.hora_estimada_entrega,
    p.hora_entrega_real,

    r.id AS ruta_id,
    r.codigo AS ruta_codigo,
    r.fecha AS ruta_fecha,

    u.nombre AS conductor_nombre,
    v.placa AS vehiculo_placa,

    CASE
        WHEN p.estado IN ('ASIGNADO', 'EN_RUTA')
             AND p.hora_estimada_entrega IS NOT NULL
             AND p.hora_estimada_entrega < NOW()
        THEN TRUE
        ELSE FALSE
    END AS esta_retrasado,

    (
        SELECT COUNT(*)
        FROM public.incidencias i
        WHERE i.pedido_id = p.id
    ) AS total_incidencias,

    (
        SELECT COUNT(*)
        FROM public.alertas a
        WHERE a.pedido_id = p.id
          AND a.estado = 'ABIERTA'
    ) AS alertas_abiertas

FROM public.pedidos p
INNER JOIN public.clientes_empresas ce ON ce.id = p.cliente_id
LEFT JOIN public.ruta_pedidos rp ON rp.pedido_id = p.id
LEFT JOIN public.rutas r ON r.id = rp.ruta_id
LEFT JOIN public.conductores c ON c.id = r.conductor_id
LEFT JOIN public.usuarios u ON u.id = c.usuario_id
LEFT JOIN public.vehiculos v ON v.id = r.vehiculo_id;

-- ============================================================
-- 22. Row Level Security - Supabase
-- ============================================================
-- Para la actividad académica, las tablas quedan sin políticas RLS
-- para facilitar pruebas desde el SQL Editor.
--
-- En una implementación real se recomienda:
-- 1. Activar RLS.
-- 2. Crear políticas por rol.
-- 3. Restringir al conductor para que solo vea sus rutas.
-- 4. Restringir al cliente para que solo consulte sus pedidos.
--
-- Ejemplo:
-- ALTER TABLE public.pedidos ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- 23. Comentarios descriptivos
-- ============================================================

COMMENT ON TABLE public.usuarios IS
'Usuarios internos de SmartRoute DSS: administradores, gerentes, despachadores y conductores.';

COMMENT ON TABLE public.conductores IS
'Conductores habilitados para ejecutar rutas logísticas.';

COMMENT ON TABLE public.clientes_empresas IS
'Clientes empresa que solicitan entregas a FlashLogistics.';

COMMENT ON TABLE public.vehiculos IS
'Vehículos disponibles para planificación y ejecución de rutas.';

COMMENT ON TABLE public.pedidos IS
'Pedidos o entregas solicitadas por clientes empresa.';

COMMENT ON TABLE public.rutas IS
'Rutas planificadas con conductor, vehículo, fecha y costo estimado.';

COMMENT ON TABLE public.ruta_pedidos IS
'Detalle ordenado de pedidos dentro de una ruta.';

COMMENT ON TABLE public.historial_estados IS
'Auditoría de cambios de estado de pedidos.';

COMMENT ON TABLE public.incidencias IS
'Problemas operativos reportados durante la ejecución de entregas.';

COMMENT ON TABLE public.alertas IS
'Alertas DSS para priorizar retrasos, incidencias o eventos críticos.';

COMMENT ON TABLE public.kpi_operativos IS
'Métricas consolidadas para análisis de desempeño operativo.';

-- ============================================================
-- Fin del script
-- ============================================================