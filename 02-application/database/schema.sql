-- Users
CREATE TABLE IF NOT EXISTS users (
  id       SERIAL PRIMARY KEY,
  name     VARCHAR(100) NOT NULL,
  email    VARCHAR(150) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL
);

-- Products
CREATE TABLE IF NOT EXISTS products (
  id        SERIAL PRIMARY KEY,
  name      VARCHAR(150) NOT NULL,
  category  VARCHAR(100) NOT NULL,
  price     DECIMAL(10,2) NOT NULL,
  image_url TEXT NOT NULL
);

-- Cart
CREATE TABLE IF NOT EXISTS cart (
  id         SERIAL PRIMARY KEY,
  user_id    INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  product_id INT NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  quantity   INT NOT NULL DEFAULT 1
);

-- Orders
CREATE TABLE IF NOT EXISTS orders (
  id          SERIAL PRIMARY KEY,
  user_id     INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  total_price DECIMAL(10,2) NOT NULL,
  status      VARCHAR(50) NOT NULL DEFAULT 'pending',
  created_at  TIMESTAMP DEFAULT NOW()
);
