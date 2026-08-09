CREATE TABLE addresses(
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    address_line_1 VARCHAR(100) NOT NULL,
    address_line_2 VARCHAR(100),
    city VARCHAR(85) NOT NULL,
    region VARCHAR(50),
    country VARCHAR(2) NOT NULL,
    postal_code VARCHAR(20),
    address_type VARCHAR(20) NOT NULL CHECK (address_type IN('shipping', 'billing')),
    is_default BOOLEAN NOT NULL DEFAULT FALSE,
    recipient_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);