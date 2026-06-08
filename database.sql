-- MarketSphere Web - Database Schema
-- Dialect: PostgreSQL (Can be easily adapted to MySQL)

CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone_number VARCHAR(50) UNIQUE,
    password VARCHAR(255), -- Nullable karena login via Google tidak butuh password
    google_id VARCHAR(255) UNIQUE, -- Menyimpan ID dari Google Auth
    avatar_url TEXT,
    email_verified_at TIMESTAMP, -- Standard Laravel untuk verifikasi email manual
    remember_token VARCHAR(100), -- Standard Laravel untuk fitur "Remember Me"
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_roles (
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    role_id INT REFERENCES roles(id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, role_id)
);

CREATE TABLE addresses (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    label VARCHAR(50) NOT NULL, -- e.g., 'Rumah', 'Kantor'
    receiver_name VARCHAR(255) NOT NULL,
    phone_number VARCHAR(50) NOT NULL,
    address_detail TEXT NOT NULL,
    province_id INT NOT NULL,
    regency_id INT NOT NULL,
    district_id INT NOT NULL,
    village_id INT NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    is_primary BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE shops (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    logo TEXT,
    banner TEXT, -- Banner khusus untuk halaman profil toko
    description TEXT,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Fitur: Followers Toko
CREATE TABLE shop_followers (
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    shop_id INT REFERENCES shops(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, shop_id)
);

CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    icon TEXT,

);

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    shop_id INT REFERENCES shops(id) ON DELETE CASCADE,
    category_id INT REFERENCES categories(id) ON DELETE SET NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    is_sponsored BOOLEAN DEFAULT FALSE, -- Untuk fitur sponsor produk
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE product_variants (
    id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL, -- e.g., 'Merah, XL'
    description TEXT,
    sku VARCHAR(100) UNIQUE NOT NULL,
    price DECIMAL(15, 2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    image TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE carts (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    product_variant_id INT REFERENCES product_variants(id) ON DELETE CASCADE,
    quantity INT NOT NULL CHECK (quantity > 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, product_variant_id)
);

CREATE TABLE conversations (
    id SERIAL PRIMARY KEY,
    user_one_id INT REFERENCES users(id) ON DELETE CASCADE,
    user_two_id INT REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE messages (
    id SERIAL PRIMARY KEY,
    conversation_id INT REFERENCES conversations(id) ON DELETE CASCADE,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    body TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    order_number VARCHAR(100) UNIQUE NOT NULL,
    user_id INT REFERENCES users(id) ON DELETE SET NULL,
    shop_id INT REFERENCES shops(id) ON DELETE SET NULL,
    total_amount DECIMAL(15, 2) NOT NULL,
    payment_status VARCHAR(50) NOT NULL, -- e.g., 'PENDING', 'PAID', 'FAILED'
    payment_method VARCHAR(100),
    reference_id VARCHAR(255),
    shipping_status VARCHAR(50) DEFAULT 'PROCESSING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(id) ON DELETE CASCADE,
    product_variant_id INT REFERENCES product_variants(id) ON DELETE SET NULL,
    quantity INT NOT NULL,
    price DECIMAL(15, 2) NOT NULL -- Disimpan saat pembelian agar tidak berubah jika harga master diubah
);

CREATE TABLE payment_logs (
    id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(id) ON DELETE CASCADE,
    payload JSONB NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE notifications (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    type VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    body TEXT NOT NULL,
    click_action VARCHAR(255),
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Fitur Tambahan Sesuai Notes:

-- 1. Banners (Bisa untuk Home App atau Store)
CREATE TABLE banners (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255),
    image_url TEXT NOT NULL,
    button_text VARCHAR(100),
    link_url VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Vouchers (Bisa global atau per-toko)
CREATE TABLE vouchers (
    id SERIAL PRIMARY KEY,
    shop_id INT REFERENCES shops(id) ON DELETE CASCADE, -- NULL jika voucher dari sistem
    code VARCHAR(50) UNIQUE NOT NULL,
    discount_type VARCHAR(50) NOT NULL, -- 'FIXED' atau 'PERCENTAGE'
    discount_amount DECIMAL(15, 2) NOT NULL,
    min_purchase DECIMAL(15, 2) DEFAULT 0,
    valid_from TIMESTAMP,
    valid_until TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Flash Sale 
CREATE TABLE flash_sales (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE flash_sale_items (
    flash_sale_id INT REFERENCES flash_sales(id) ON DELETE CASCADE,
    product_variant_id INT REFERENCES product_variants(id) ON DELETE CASCADE,
    discount_price DECIMAL(15, 2) NOT NULL,
    stock_allocated INT NOT NULL,
    PRIMARY KEY (flash_sale_id, product_variant_id)
);
