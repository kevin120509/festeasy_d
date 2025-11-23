# Guía de Uso: Database Schema FestEasy

## 📋 Resumen

He generado el archivo **`database_schema.sql`** con el esquema completo de base de datos para tu aplicación FestEasy.

## ✅ Lo que incluye el SQL

### Tablas (8 en total)
1. **profiles** - Perfiles de usuarios (clientes y proveedores)
2. **service_categories** - Categorías de servicios (pre-pobladas con 8 categorías)
3. **events** - Eventos de los clientes
4. **requests** - Solicitudes de servicios con especificaciones
5. **services** - Catálogo de servicios de proveedores
6. **quotes** - Cotizaciones enviadas por proveedores
7. **payments** - Registro de pagos
8. **hired_services** - Servicios contratados y apartados

### Seguridad
- ✅ **Row Level Security (RLS)** activado en todas las tablas
- ✅ Políticas específicas para clientes y proveedores
- ✅ Protección de datos sensibles

### Automatizaciones
- ✅ **Trigger**: Crear perfil automáticamente al registrarse
- ✅ **Trigger**: Actualizar status de request cuando recibe cotización
- ✅ **Trigger**: Crear hired_service y payment automáticamente al aceptar cotización
- ✅ **Trigger**: Actualizar presupuesto total del evento
- ✅ **Trigger**: Actualizar campos `updated_at`

### Datos Iniciales
- ✅ 8 categorías de servicios pre-insertadas (Catering, Decoración, Fotografía, etc.)

## 🚀 Cómo Ejecutar

### Paso 1: Abrir Supabase Dashboard
1. Ve a https://supabase.com/dashboard
2. Selecciona tu proyecto: `mwldonzgeruhrsfirfop`
3. En el menú lateral, haz clic en **SQL Editor**

### Paso 2: Ejecutar el Script
1. Haz clic en **"New query"**
2. Abre el archivo `database_schema.sql` que generé
3. Copia **TODO** el contenido
4. Pégalo en el editor SQL
5. Haz clic en **"Run"** (abajo a la derecha)

### Paso 3: Verificar
Después de ejecutar, verifica en la pestaña **Table Editor** que aparezcan estas tablas:
- profiles
- service_categories
- events
- requests
- services
- quotes
- payments
- hired_services

## 🔄 Flujo Automático

Una vez instalado el esquema, estos procesos ocurren automáticamente:

1. **Registro de usuario** → Se crea perfil en `profiles`
2. **Proveedor envía cotización** → Request cambia a status "quoted"
3. **Cliente acepta cotización** → Se crean automáticamente:
   - Registro en `payments` (status: pending)
   - Registro en `hired_services` (status: reserved)
   - Request cambia a status "hired"
4. **Se agrega servicio contratado** → Budget del event se actualiza automáticamente

## 📊 Categorías Pre-instaladas

El script incluye estas categorías listas para usar:
- 🍽️ Catering
- 🎨 Decoración
- 📸 Fotografía
- 🎵 Música
- 🎂 Pastelería
- 💡 Iluminación
- 🌸 Floristería
- 🪑 Mobiliario

## ⚠️ Importante

1. **No modifiques** las políticas RLS si no estás seguro - protegen los datos de los usuarios
2. **Los triggers** son esenciales para el flujo de negocio - no los elimines
3. Las **categorías** pueden editarse desde la tabla `service_categories`

## 🔐 Autenticación

El esquema usa **Supabase Auth** nativo:
- Los usuarios se registran con email/password en Supabase
- El trigger `on_auth_user_created` crea automáticamente el perfil
- El rol (client/provider) se define al registrarse mediante `meta_data`

## 💡 Próximos Pasos

Después de ejecutar el SQL, necesitarás:
1. ✅ Adaptar los modelos de Flutter para coincidir con el esquema
2. ✅ Implementar la lógica de pagos (Stripe/PayPal)
3. ✅ Crear las pantallas de cotizaciones
4. ✅ Remover el código de chat de la app

¿Quieres que genere ahora los modelos de Flutter o el código para integrar el esquema?
