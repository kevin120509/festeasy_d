-- ============================================================================
-- FESTEASY DATABASE SCHEMA
-- Sistema de Cotizaciones y Pagos para Eventos
-- ============================================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- 1. PROFILES TABLE
-- ============================================================================
CREATE TABLE profiles (
    id UUID PRIMARY KEY REFERENCES auth.users (id) ON DELETE CASCADE,
    email TEXT NOT NULL UNIQUE,
    full_name TEXT NOT NULL,
    role TEXT NOT NULL CHECK (
        role IN ('client', 'provider')
    ),
    phone TEXT,
    avatar_url TEXT,
    business_name TEXT,
    created_at TIMESTAMP
    WITH
        TIME ZONE DEFAULT NOW(),
        updated_at TIMESTAMP
    WITH
        TIME ZONE DEFAULT NOW()
);

-- ============================================================================
-- 2. SERVICE CATEGORIES TABLE
-- ============================================================================
CREATE TABLE service_categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    icon TEXT,
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMP
    WITH
        TIME ZONE DEFAULT NOW()
);

-- ============================================================================
-- 3. EVENTS TABLE
-- ============================================================================
CREATE TABLE events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
    client_id UUID NOT NULL REFERENCES profiles (id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    event_date DATE NOT NULL,
    event_time TIME,
    location TEXT,
    address TEXT,
    guest_count INTEGER,
    total_budget DECIMAL(10, 2) DEFAULT 0,
    status TEXT NOT NULL DEFAULT 'planning' CHECK (
        status IN (
            'planning',
            'confirmed',
            'in_progress',
            'completed',
            'cancelled'
        )
    ),
    created_at TIMESTAMP
    WITH
        TIME ZONE DEFAULT NOW(),
        updated_at TIMESTAMP
    WITH
        TIME ZONE DEFAULT NOW()
);

-- ============================================================================
-- 4. REQUESTS TABLE
-- ============================================================================
CREATE TABLE requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
    client_id UUID NOT NULL REFERENCES profiles (id) ON DELETE CASCADE,
    event_id UUID REFERENCES events (id) ON DELETE SET NULL,
    category_id UUID NOT NULL REFERENCES service_categories (id),
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    specifications JSONB DEFAULT '{}',
    event_date DATE NOT NULL,
    event_time TIME,
    location TEXT,
    address TEXT,
    guest_count INTEGER,
    budget_range TEXT,
    status TEXT NOT NULL DEFAULT 'open' CHECK (
        status IN (
            'open',
            'quoted',
            'hired',
            'expired',
            'cancelled'
        )
    ),
    expires_at TIMESTAMP
    WITH
        TIME ZONE,
        created_at TIMESTAMP
    WITH
        TIME ZONE DEFAULT NOW(),
        updated_at TIMESTAMP
    WITH
        TIME ZONE DEFAULT NOW()
);

-- ============================================================================
-- 5. SERVICES TABLE
-- ============================================================================
CREATE TABLE services (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    provider_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    category_id UUID NOT NULL REFERENCES service_categories(id),
    name TEXT NOT NULL,
    description TEXT,
    base_price DECIMAL(10, 2),
    active BOOLEAN DEFAULT true,
    portfolio_images TEXT[] DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================================================
-- 6. QUOTES TABLE
-- ============================================================================
CREATE TABLE quotes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
    request_id UUID NOT NULL REFERENCES requests (id) ON DELETE CASCADE,
    provider_id UUID NOT NULL REFERENCES profiles (id) ON DELETE CASCADE,
    service_id UUID REFERENCES services (id) ON DELETE SET NULL,
    proposed_price DECIMAL(10, 2) NOT NULL,
    breakdown JSONB DEFAULT '{}',
    notes TEXT,
    valid_until DATE,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (
        status IN (
            'pending',
            'accepted',
            'rejected',
            'expired'
        )
    ),
    created_at TIMESTAMP
    WITH
        TIME ZONE DEFAULT NOW(),
        updated_at TIMESTAMP
    WITH
        TIME ZONE DEFAULT NOW()
);

-- ============================================================================
-- 7. PAYMENTS TABLE
-- ============================================================================
CREATE TABLE payments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
    quote_id UUID NOT NULL REFERENCES quotes (id) ON DELETE CASCADE,
    client_id UUID NOT NULL REFERENCES profiles (id),
    provider_id UUID NOT NULL REFERENCES profiles (id),
    amount DECIMAL(10, 2) NOT NULL,
    payment_method TEXT,
    transaction_id TEXT,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (
        status IN (
            'pending',
            'completed',
            'failed',
            'refunded'
        )
    ),
    paid_at TIMESTAMP
    WITH
        TIME ZONE,
        created_at TIMESTAMP
    WITH
        TIME ZONE DEFAULT NOW()
);

-- ============================================================================
-- 8. HIRED SERVICES TABLE
-- ============================================================================
CREATE TABLE hired_services (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4 (),
    event_id UUID NOT NULL REFERENCES events (id) ON DELETE CASCADE,
    quote_id UUID NOT NULL REFERENCES quotes (id),
    payment_id UUID REFERENCES payments (id),
    client_id UUID NOT NULL REFERENCES profiles (id),
    provider_id UUID NOT NULL REFERENCES profiles (id),
    service_name TEXT NOT NULL,
    service_date DATE NOT NULL,
    service_time TIME,
    price_paid DECIMAL(10, 2) NOT NULL,
    status TEXT NOT NULL DEFAULT 'reserved' CHECK (
        status IN (
            'reserved',
            'confirmed',
            'in_progress',
            'completed',
            'cancelled'
        )
    ),
    created_at TIMESTAMP
    WITH
        TIME ZONE DEFAULT NOW(),
        updated_at TIMESTAMP
    WITH
        TIME ZONE DEFAULT NOW()
);

-- ============================================================================
-- INDEXES FOR PERFORMANCE
-- ============================================================================
CREATE INDEX idx_profiles_email ON profiles (email);

CREATE INDEX idx_profiles_role ON profiles (role);

CREATE INDEX idx_events_client_id ON events (client_id);

CREATE INDEX idx_events_date ON events (event_date);

CREATE INDEX idx_events_status ON events (status);

CREATE INDEX idx_requests_client_id ON requests (client_id);

CREATE INDEX idx_requests_event_id ON requests (event_id);

CREATE INDEX idx_requests_category_id ON requests (category_id);

CREATE INDEX idx_requests_category_status ON requests (category_id, status);

CREATE INDEX idx_requests_status ON requests (status);

CREATE INDEX idx_requests_expires_at ON requests (expires_at);

CREATE INDEX idx_services_provider_id ON services (provider_id);

CREATE INDEX idx_services_category_id ON services (category_id);

CREATE INDEX idx_services_active ON services (active);

CREATE INDEX idx_quotes_request_id ON quotes (request_id);

CREATE INDEX idx_quotes_provider_id ON quotes (provider_id);

CREATE INDEX idx_quotes_status ON quotes (status);

CREATE INDEX idx_quotes_request_status ON quotes (request_id, status);

CREATE INDEX idx_payments_quote_id ON payments (quote_id);

CREATE INDEX idx_payments_client_id ON payments (client_id);

CREATE INDEX idx_payments_provider_id ON payments (provider_id);

CREATE INDEX idx_payments_status ON payments (status);

CREATE INDEX idx_hired_services_event_id ON hired_services (event_id);

CREATE INDEX idx_hired_services_client_id ON hired_services (client_id);

CREATE INDEX idx_hired_services_provider_id ON hired_services (provider_id);

CREATE INDEX idx_hired_services_status ON hired_services (status);

-- ============================================================================
-- ROW LEVEL SECURITY POLICIES
-- ============================================================================

-- Enable RLS on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

ALTER TABLE service_categories ENABLE ROW LEVEL SECURITY;

ALTER TABLE events ENABLE ROW LEVEL SECURITY;

ALTER TABLE requests ENABLE ROW LEVEL SECURITY;

ALTER TABLE services ENABLE ROW LEVEL SECURITY;

ALTER TABLE quotes ENABLE ROW LEVEL SECURITY;

ALTER TABLE payments ENABLE ROW LEVEL SECURITY;

ALTER TABLE hired_services ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- PROFILES POLICIES
-- ============================================================================
CREATE POLICY "Public profiles are viewable by everyone" ON profiles FOR
SELECT USING (true);

CREATE POLICY "Users can insert their own profile" ON profiles FOR
INSERT
WITH
    CHECK (auth.uid () = id);

CREATE POLICY "Users can update their own profile" ON profiles FOR
UPDATE USING (auth.uid () = id);

-- ============================================================================
-- SERVICE CATEGORIES POLICIES
-- ============================================================================
CREATE POLICY "Categories are viewable by everyone" ON service_categories FOR
SELECT USING (true);

-- ============================================================================
-- EVENTS POLICIES
-- ============================================================================
CREATE POLICY "Clients can view their own events" ON events FOR
SELECT USING (auth.uid () = client_id);

CREATE POLICY "Providers can view events they participate in" ON events FOR
SELECT USING (
        EXISTS (
            SELECT 1
            FROM hired_services
            WHERE
                hired_services.event_id = events.id
                AND hired_services.provider_id = auth.uid ()
        )
    );

CREATE POLICY "Clients can create events" ON events FOR
INSERT
WITH
    CHECK (auth.uid () = client_id);

CREATE POLICY "Clients can update their own events" ON events FOR
UPDATE USING (auth.uid () = client_id);

CREATE POLICY "Clients can delete their own events" ON events FOR DELETE USING (auth.uid () = client_id);

-- ============================================================================
-- REQUESTS POLICIES
-- ============================================================================
CREATE POLICY "Clients can view their own requests" ON requests FOR
SELECT USING (auth.uid () = client_id);

CREATE POLICY "Providers can view open/quoted requests in their categories" ON requests FOR
SELECT USING (
        status IN ('open', 'quoted')
        AND category_id IN (
            SELECT category_id
            FROM services
            WHERE
                provider_id = auth.uid ()
                AND active = true
        )
    );

CREATE POLICY "Clients can create requests" ON requests FOR
INSERT
WITH
    CHECK (auth.uid () = client_id);

CREATE POLICY "Clients can update their own requests" ON requests FOR
UPDATE USING (auth.uid () = client_id);

CREATE POLICY "Clients can delete their own requests" ON requests FOR DELETE USING (auth.uid () = client_id);

-- ============================================================================
-- SERVICES POLICIES
-- ============================================================================
CREATE POLICY "Everyone can view active services" ON services FOR
SELECT USING (active = true);

CREATE POLICY "Providers can view their own services" ON services FOR
SELECT USING (auth.uid () = provider_id);

CREATE POLICY "Providers can create services" ON services FOR
INSERT
WITH
    CHECK (auth.uid () = provider_id);

CREATE POLICY "Providers can update their own services" ON services FOR
UPDATE USING (auth.uid () = provider_id);

CREATE POLICY "Providers can delete their own services" ON services FOR DELETE USING (auth.uid () = provider_id);

-- ============================================================================
-- QUOTES POLICIES
-- ============================================================================
CREATE POLICY "Providers can view their own quotes" ON quotes FOR
SELECT USING (auth.uid () = provider_id);

CREATE POLICY "Clients can view quotes for their requests" ON quotes FOR
SELECT USING (
        EXISTS (
            SELECT 1
            FROM requests
            WHERE
                requests.id = quotes.request_id
                AND requests.client_id = auth.uid ()
        )
    );

CREATE POLICY "Providers can create quotes" ON quotes FOR
INSERT
WITH
    CHECK (auth.uid () = provider_id);

CREATE POLICY "Providers can update their own pending quotes" ON quotes FOR
UPDATE USING (
    auth.uid () = provider_id
    AND status = 'pending'
);

CREATE POLICY "Clients can update quote status (accept/reject)" ON quotes FOR
UPDATE USING (
    EXISTS (
        SELECT 1
        FROM requests
        WHERE
            requests.id = quotes.request_id
            AND requests.client_id = auth.uid ()
    )
);

-- ============================================================================
-- PAYMENTS POLICIES
-- ============================================================================
CREATE POLICY "Clients can view their own payments" ON payments FOR
SELECT USING (auth.uid () = client_id);

CREATE POLICY "Providers can view their received payments" ON payments FOR
SELECT USING (auth.uid () = provider_id);

CREATE POLICY "Clients can create payments" ON payments FOR
INSERT
WITH
    CHECK (auth.uid () = client_id);

-- ============================================================================
-- HIRED SERVICES POLICIES
-- ============================================================================
CREATE POLICY "Clients can view their hired services" ON hired_services FOR
SELECT USING (auth.uid () = client_id);

CREATE POLICY "Providers can view services they provide" ON hired_services FOR
SELECT USING (auth.uid () = provider_id);

CREATE POLICY "System can create hired services" ON hired_services FOR
INSERT
WITH
    CHECK (auth.uid () = client_id);

CREATE POLICY "Providers can update status of their services" ON hired_services FOR
UPDATE USING (auth.uid () = provider_id);

-- ============================================================================
-- TRIGGERS AND FUNCTIONS
-- ============================================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply updated_at trigger to relevant tables
CREATE TRIGGER update_profiles_updated_at
    BEFORE UPDATE ON profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_events_updated_at
    BEFORE UPDATE ON events
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_requests_updated_at
    BEFORE UPDATE ON requests
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_services_updated_at
    BEFORE UPDATE ON services
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_quotes_updated_at
    BEFORE UPDATE ON quotes
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_hired_services_updated_at
    BEFORE UPDATE ON hired_services
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to auto-create profile on signup
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, email, full_name, role)
    VALUES (
        NEW.id,
        NEW.email,
        COALESCE(NEW.raw_user_meta_data->>'full_name', 'Usuario'),
        COALESCE(NEW.raw_user_meta_data->>'role', 'client')
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to create profile on user signup
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- Function to update request status when quote is created
CREATE OR REPLACE FUNCTION update_request_status_on_quote()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE requests
    SET status = 'quoted', updated_at = NOW()
    WHERE id = NEW.request_id AND status = 'open';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to update request status when quote is created
CREATE TRIGGER on_quote_created
    AFTER INSERT ON quotes
    FOR EACH ROW EXECUTE FUNCTION update_request_status_on_quote();

-- Function to create hired_service when quote is accepted
CREATE OR REPLACE FUNCTION create_hired_service_on_acceptance()
RETURNS TRIGGER AS $$
DECLARE
    v_request requests%ROWTYPE;
    v_payment_id UUID;
BEGIN
    -- Only proceed if quote was just accepted
    IF NEW.status = 'accepted' AND OLD.status != 'accepted' THEN
        -- Get request details
        SELECT * INTO v_request FROM requests WHERE id = NEW.request_id;
        
        -- Create payment record
        INSERT INTO payments (quote_id, client_id, provider_id, amount, status)
        VALUES (NEW.id, v_request.client_id, NEW.provider_id, NEW.proposed_price, 'pending')
        RETURNING id INTO v_payment_id;
        
        -- Create hired service
        INSERT INTO hired_services (
            event_id, quote_id, payment_id, client_id, provider_id,
            service_name, service_date, service_time, price_paid, status
        )
        VALUES (
            v_request.event_id, NEW.id, v_payment_id, v_request.client_id, NEW.provider_id,
            v_request.title, v_request.event_date, v_request.event_time, NEW.proposed_price, 'reserved'
        );
        
        -- Update request status
        UPDATE requests SET status = 'hired', updated_at = NOW() WHERE id = NEW.request_id;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to create hired service on quote acceptance
CREATE TRIGGER on_quote_accepted
    AFTER UPDATE ON quotes
    FOR EACH ROW EXECUTE FUNCTION create_hired_service_on_acceptance();

-- Function to update event total budget
CREATE OR REPLACE FUNCTION update_event_total_budget()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE events
    SET total_budget = (
        SELECT COALESCE(SUM(price_paid), 0)
        FROM hired_services
        WHERE event_id = NEW.event_id
    ),
    updated_at = NOW()
    WHERE id = NEW.event_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to update event budget when hired service is added
CREATE TRIGGER on_hired_service_added
    AFTER INSERT ON hired_services
    FOR EACH ROW EXECUTE FUNCTION update_event_total_budget();

-- ============================================================================
-- INITIAL DATA - SERVICE CATEGORIES
-- ============================================================================
INSERT INTO
    service_categories (
        name,
        description,
        icon,
        active
    )
VALUES (
        'Catering',
        'Servicios de comida y bebida',
        'restaurant',
        true
    ),
    (
        'Decoración',
        'Decoración y ambientación',
        'palette',
        true
    ),
    (
        'Fotografía',
        'Fotografía y video profesional',
        'camera',
        true
    ),
    (
        'Música',
        'DJ, bandas y entretenimiento musical',
        'music_note',
        true
    ),
    (
        'Pastelería',
        'Pasteles y postres personalizados',
        'cake',
        true
    ),
    (
        'Iluminación',
        'Iluminación profesional y efectos',
        'lightbulb',
        true
    ),
    (
        'Floristería',
        'Arreglos florales y decoración natural',
        'local_florist',
        true
    ),
    (
        'Mobiliario',
        'Renta de mesas, sillas y mobiliario',
        'chair',
        true
    ) ON CONFLICT (name) DO NOTHING;

-- ============================================================================
-- SCRIPT COMPLETION
-- ============================================================================
-- Este script crea todas las tablas, índices, políticas RLS y triggers
-- necesarios para el funcionamiento de FestEasy.
--
-- Para ejecutar:
-- 1. Abre tu dashboard de Supabase
-- 2. Ve a SQL Editor
-- 3. Copia y pega este script completo
-- 4. Ejecuta
-- ============================================================================