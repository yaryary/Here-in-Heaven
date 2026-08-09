CREATE TABLE discounts(
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    discount_percent DECIMAL(5, 2) NOT NULL CHECK (discount_percent > 0 AND discount_percent <= 100),
    is_active BOOLEAN NOT NULL DEFAULT FALSE,
    code VARCHAR(20) NOT NULL UNIQUE,
    usage_count INTEGER NOT NULL DEFAULT 0 CHECK (usage_count >= 0),
    usage_limit INTEGER CHECK(usage_limit > 0),
    start_date TIMESTAMPTZ NOT NULL,
    end_date TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CHECK (end_date > start_date)
);