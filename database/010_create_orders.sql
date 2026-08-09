CREATE TABLE orders(
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    shipping_address_id INTEGER NOT NULL REFERENCES addresses(id),
    billing_address_id INTEGER NOT NULL REFERENCES addresses(id),
    discount_id INTEGER REFERENCES discounts(id),
    status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN('pending', 'paid', 'shipped', 'delivered', 'cancelled')),
    guest_email VARCHAR(254),
    total DECIMAL(10,2) NOT NULL CHECK(total >= 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CHECK (user_id IS NOT NULL OR guest_email IS NOT NULL)
);