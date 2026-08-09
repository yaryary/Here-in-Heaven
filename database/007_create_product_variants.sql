CREATE TABLE product_variants(
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_id INTEGER NOT NULL REFERENCES products(id),
    inventory_id INTEGER NOT NULL UNIQUE REFERENCES inventory(id),
    sku VARCHAR(50) NOT NULL UNIQUE,
    size VARCHAR(20) NOT NULL DEFAULT 'One Size',
    color VARCHAR(30),
    price_override DECIMAL(10, 2) CHECK (price_override > 0),
    is_active BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);