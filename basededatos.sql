CREATE TABLE IF NOT EXISTS `users` (
	`id` CHAR(36) NOT NULL,
	`correo_electronico` VARCHAR(150) NOT NULL,
	`contrasena` VARCHAR(255) NOT NULL,
	`rol` ENUM('client', 'provider') NOT NULL,
	`estado` ENUM('active', 'blocked') NOT NULL DEFAULT 'active',
	`correo_verificado_en` DATETIME NOT NULL,
	`ultimo_acceso_en` DATETIME NOT NULL,
	`creado_en` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`actualizado_en` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY(`id`)
);


CREATE TABLE IF NOT EXISTS `profiles` (
	`id` UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL PRIMARY KEY,
	`updated_at` TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
	`username` TEXT UNIQUE,
	`full_name` TEXT,
	`avatar_url` TEXT,
	`website` TEXT
);


CREATE TABLE IF NOT EXISTS `perfil_cliente` (
	`id` CHAR(36) NOT NULL,
	`usuario_id` CHAR(36) NOT NULL,
	`nombre_completo` VARCHAR(150) NOT NULL,
	`telefono` VARCHAR(30),
	`avatar_url` VARCHAR(255),
	`creado_en` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`actualizado_en` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY(`id`)
);


CREATE TABLE IF NOT EXISTS `perfil_proveedor` (
	`id` CHAR(36) NOT NULL,
	`usuario_id` CHAR(36) NOT NULL,
	`nombre_negocio` VARCHAR(150) NOT NULL,
	`descripcion` TEXT,
	`telefono` VARCHAR(30),
	`avatar_url` VARCHAR(255),
	`clave_lugar` VARCHAR(100),
	`categoria_principal_id` CHAR(36),
	`creado_en` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`actualizado_en` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY(`id`)
);


CREATE TABLE IF NOT EXISTS `categorias_evento` (
	`id` CHAR(36) NOT NULL,
	`nombre` VARCHAR(100) NOT NULL,
	`descripcion` VARCHAR(255),
	`icono` VARCHAR(100),
	`activa` BOOLEAN NOT NULL DEFAULT true,
	`creado_en` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY(`id`)
);


CREATE TABLE IF NOT EXISTS `categorias_servicio` (
	`id` CHAR(36) NOT NULL,
	`nombre` VARCHAR(100) NOT NULL,
	`descripcion` VARCHAR(255),
	`icono` VARCHAR(100),
	`activa` BOOLEAN NOT NULL DEFAULT true,
	`creado_en` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY(`id`)
);


CREATE TABLE IF NOT EXISTS `eventos` (
	`id` CHAR(36) NOT NULL,
	`cliente_usuario_id` CHAR(36) NOT NULL,
	`titulo` VARCHAR(150) NOT NULL,
	`tipo_evento_id` CHAR(36) NOT NULL,
	`fecha_evento` DATE NOT NULL,
	`hora_evento` TIME,
	`nombre_lugar` VARCHAR(150),
	`direccion` VARCHAR(255),
	`numero_invitados` INTEGER,
	`presupuesto_total` DECIMAL(10,2) DEFAULT 0.00,
	`estado` ENUM('planning', 'confirmed', 'in_progress', 'completed', 'cancelled') NOT NULL DEFAULT 'planning',
	`creado_en` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`actualizado_en` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY(`id`)
);


CREATE TABLE IF NOT EXISTS `paquetes_proveedor` (
	`id` CHAR(36) NOT NULL,
	`proveedor_usuario_id` CHAR(36) NOT NULL,
	`categoria_servicio_id` CHAR(36) NOT NULL,
	`nombre` VARCHAR(150) NOT NULL,
	`descripcion` TEXT,
	`precio_base` DECIMAL(10,2) NOT NULL,
	`estado` ENUM('borrador', 'publicado', 'archivado') NOT NULL DEFAULT 'borrador',
	`creado_en` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`actualizado_en` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY(`id`)
);


CREATE TABLE IF NOT EXISTS `items_paquete` (
	`id` CHAR(36) NOT NULL,
	`paquete_id` CHAR(36) NOT NULL,
	`nombre_item` VARCHAR(150) NOT NULL,
	`cantidad` INTEGER NOT NULL,
	`unidad` VARCHAR(50),
	`nota` VARCHAR(255),
	`creado_en` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY(`id`)
);


CREATE TABLE IF NOT EXISTS `solicitudes` (
	`id` CHAR(36) NOT NULL,
	`cliente_usuario_id` CHAR(36) NOT NULL,
	`evento_id` CHAR(36) NOT NULL,
	`categoria_servicio_id` CHAR(36) NOT NULL,
	`titulo` VARCHAR(150) NOT NULL,
	`descripcion` TEXT NOT NULL,
	`especificaciones` JSON,
	`presupuesto_estimado` DECIMAL(10,2),
	`estado` ENUM('abierta', 'enviada', 'cotizada', 'contratada', 'cancelada', 'expirada') NOT NULL DEFAULT 'abierta',
	`expira_en` DATETIME,
	`creado_en` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`actualizado_en` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY(`id`)
);


CREATE TABLE IF NOT EXISTS `cotizaciones` (
	`id` CHAR(36) NOT NULL,
	`solicitud_id` CHAR(36) NOT NULL,
	`proveedor_usuario_id` CHAR(36) NOT NULL,
	`paquete_id` CHAR(36),
	`precio_propuesto` DECIMAL(10,2) NOT NULL,
	`desglose` JSON,
	`notas` TEXT,
	`valida_hasta` DATE,
	`estado` ENUM('pendiente', 'aceptada', 'rechazada', 'expirada') NOT NULL DEFAULT 'pendiente',
	`creado_en` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`actualizado_en` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY(`id`)
);


CREATE TABLE IF NOT EXISTS `pagos` (
	`id` CHAR(36) NOT NULL,
	`cotizacion_id` CHAR(36) NOT NULL,
	`cliente_usuario_id` CHAR(36) NOT NULL,
	`proveedor_usuario_id` CHAR(36) NOT NULL,
	`monto` DECIMAL(10,2) NOT NULL,
	`metodo_pago` ENUM('paynet', 'tarjeta', 'transferencia') NOT NULL,
	`estado` ENUM('pendiente', 'pagado', 'fallido', 'reembolsado') NOT NULL DEFAULT 'pendiente',
	`pagado_en` DATETIME,
	`creado_en` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY(`id`)
);


CREATE TABLE IF NOT EXISTS `cancelaciones` (
	`id` CHAR(36) NOT NULL,
	`tipo` ENUM('evento', 'solicitud', 'cotizacion', 'servicio') NOT NULL,
	`referencia_id` CHAR(36) NOT NULL,
	`usuario_id` CHAR(36) NOT NULL,
	`motivo` VARCHAR(255) NOT NULL,
	`creado_en` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY(`id`)
);


CREATE TABLE IF NOT EXISTS `reportes` (
	`id` CHAR(36) NOT NULL,
	`tipo` ENUM('usuario', 'proveedor', 'evento', 'pago') NOT NULL,
	`referencia_id` CHAR(36) NOT NULL,
	`descripcion` TEXT NOT NULL,
	`estado` ENUM('abierto', 'en_revision', 'cerrado') NOT NULL DEFAULT 'abierto',
	`creado_en` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY(`id`)
);


ALTER TABLE `perfil_cliente`
ADD FOREIGN KEY(`usuario_id`) REFERENCES `users`(`id`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `eventos`
ADD FOREIGN KEY(`cliente_usuario_id`) REFERENCES `users`(`id`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `eventos`
ADD FOREIGN KEY(`tipo_evento_id`) REFERENCES `categorias_evento`(`id`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `paquetes_proveedor`
ADD FOREIGN KEY(`proveedor_usuario_id`) REFERENCES `users`(`id`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `paquetes_proveedor`
ADD FOREIGN KEY(`categoria_servicio_id`) REFERENCES `categorias_servicio`(`id`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `items_paquete`
ADD FOREIGN KEY(`paquete_id`) REFERENCES `paquetes_proveedor`(`id`)
ON UPDATE NO ACTION ON DELETE CASCADE;
ALTER TABLE `solicitudes`
ADD FOREIGN KEY(`cliente_usuario_id`) REFERENCES `users`(`id`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `solicitudes`
ADD FOREIGN KEY(`evento_id`) REFERENCES `eventos`(`id`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `solicitudes`
ADD FOREIGN KEY(`categoria_servicio_id`) REFERENCES `categorias_servicio`(`id`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `cotizaciones`
ADD FOREIGN KEY(`solicitud_id`) REFERENCES `solicitudes`(`id`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `cotizaciones`
ADD FOREIGN KEY(`proveedor_usuario_id`) REFERENCES `users`(`id`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `cotizaciones`
ADD FOREIGN KEY(`paquete_id`) REFERENCES `paquetes_proveedor`(`id`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `pagos`
ADD FOREIGN KEY(`cotizacion_id`) REFERENCES `cotizaciones`(`id`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `pagos`
ADD FOREIGN KEY(`cliente_usuario_id`) REFERENCES `users`(`id`)
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE `pagos`
ADD FOREIGN KEY(`proveedor_usuario_id`) REFERENCES `users`(`id`)
ON UPDATE NO ACTION ON DELETE NO ACTION;


-- Habilitar RLS en la tabla profiles
ALTER TABLE `profiles` ENABLE ROW LEVEL SECURITY;

-- Políticas RLS para profiles
CREATE POLICY "Users can view own profile" ON `profiles`
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON `profiles`
  FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON `profiles`
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Habilitar RLS en perfil_cliente
ALTER TABLE `perfil_cliente` ENABLE ROW LEVEL SECURITY;

-- Políticas RLS para perfil_cliente
CREATE POLICY "Users can view own client profile" ON `perfil_cliente`
  FOR SELECT USING (auth.uid() = usuario_id::uuid);

CREATE POLICY "Users can update own client profile" ON `perfil_cliente`
  FOR UPDATE USING (auth.uid() = usuario_id::uuid);

CREATE POLICY "Users can insert own client profile" ON `perfil_cliente`
  FOR INSERT WITH CHECK (auth.uid() = usuario_id::uuid);

-- Habilitar RLS en perfil_proveedor
ALTER TABLE `perfil_proveedor` ENABLE ROW LEVEL SECURITY;

-- Políticas RLS para perfil_proveedor
CREATE POLICY "Users can view own provider profile" ON `perfil_proveedor`
  FOR SELECT USING (auth.uid() = usuario_id::uuid);

CREATE POLICY "Users can update own provider profile" ON `perfil_proveedor`
  FOR UPDATE USING (auth.uid() = usuario_id::uuid);

CREATE POLICY "Users can insert own provider profile" ON `perfil_proveedor`
  FOR INSERT WITH CHECK (auth.uid() = usuario_id::uuid);

-- Habilitar RLS en users
ALTER TABLE `users` ENABLE ROW LEVEL SECURITY;

-- Políticas RLS para users
CREATE POLICY "Users can view own user data" ON `users`
  FOR SELECT USING (auth.uid() = id::uuid);

CREATE POLICY "Users can update own user data" ON `users`
  FOR UPDATE USING (auth.uid() = id::uuid);

CREATE POLICY "Users can insert own user data" ON `users`
  FOR INSERT WITH CHECK (auth.uid() = id::uuid);

-- Otorgar permisos al rol anon para acceder a las tablas
GRANT USAGE ON SCHEMA public TO anon;
GRANT ALL ON public.profiles TO anon;
GRANT ALL ON public.users TO anon;
GRANT ALL ON public.perfil_cliente TO anon;
GRANT ALL ON public.perfil_proveedor TO anon;
GRANT ALL ON public.categorias_evento TO anon;
GRANT ALL ON public.categorias_servicio TO anon;
GRANT ALL ON public.eventos TO anon;
GRANT ALL ON public.paquetes_proveedor TO anon;
GRANT ALL ON public.items_paquete TO anon;
GRANT ALL ON public.solicitudes TO anon;
GRANT ALL ON public.cotizaciones TO anon;
GRANT ALL ON public.pagos TO anon;
GRANT ALL ON public.cancelaciones TO anon;
GRANT ALL ON public.reportes TO anon;

-- Otorgar permisos al rol authenticated
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT ALL ON public.profiles TO authenticated;
GRANT ALL ON public.users TO authenticated;
GRANT ALL ON public.perfil_cliente TO authenticated;
GRANT ALL ON public.perfil_proveedor TO authenticated;
GRANT ALL ON public.categorias_evento TO authenticated;
GRANT ALL ON public.categorias_servicio TO authenticated;
GRANT ALL ON public.eventos TO authenticated;
GRANT ALL ON public.paquetes_proveedor TO authenticated;
GRANT ALL ON public.items_paquete TO authenticated;
GRANT ALL ON public.solicitudes TO authenticated;
GRANT ALL ON public.cotizaciones TO authenticated;
GRANT ALL ON public.pagos TO authenticated;
GRANT ALL ON public.cancelaciones TO authenticated;
GRANT ALL ON public.reportes TO authenticated;

-- Insertar categorías de servicio de ejemplo
INSERT INTO categorias_servicio (id, nombre, descripcion, icono, activa) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'Catering', 'Servicio de comida y bebidas', 'restaurant', true),
('550e8400-e29b-41d4-a716-446655440002', 'Música', 'DJ, banda musical, sonido', 'music_note', true),
('550e8400-e29b-41d4-a716-446655440003', 'Fotografía', 'Fotógrafo profesional', 'camera', true),
('550e8400-e29b-41d4-a716-446655440004', 'Decoración', 'Decoración de eventos', 'celebration', true),
('550e8400-e29b-41d4-a716-446655440005', 'Lugar', 'Alquiler de espacios', 'location_on', true),
('550e8400-e29b-41d4-a716-446655440006', 'Transporte', 'Transporte de invitados', 'directions_car', true)
ON CONFLICT (id) DO NOTHING;

-- Insertar categorías de evento de ejemplo
INSERT INTO categorias_evento (id, nombre, descripcion, icono, activa) VALUES
('550e8400-e29b-41d4-a716-446655440011', 'Boda', 'Ceremonia de matrimonio', 'favorite', true),
('550e8400-e29b-41d4-a716-446655440012', 'XV Años', 'Fiesta de quince años', 'cake', true),
('550e8400-e29b-41d4-a716-446655440013', 'Cumpleaños', 'Fiesta de cumpleaños', 'celebration', true),
('550e8400-e29b-41d4-a716-446655440014', 'Bautizo', 'Ceremonia de bautizo', 'child_friendly', true),
('550e8400-e29b-41d4-a716-446655440015', 'Graduación', 'Ceremonia de graduación', 'school', true),
('550e8400-e29b-41d4-a716-446655440016', 'Corporativo', 'Evento corporativo', 'business', true)
ON CONFLICT (id) DO NOTHING;

-- Verificar que las categorías se insertaron correctamente
-- Verificar que las categorías existen
-- Ejecuta estas consultas en Supabase SQL Editor para verificar:

-- SELECT id, nombre FROM categorias_evento ORDER BY nombre;
-- SELECT id, nombre FROM categorias_servicio ORDER BY nombre;

-- Si no aparecen resultados, ejecuta las inserciones de arriba nuevamente