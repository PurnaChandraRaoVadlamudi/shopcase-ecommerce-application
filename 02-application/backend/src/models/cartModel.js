const pool = require('../config/db');

const getCartByUser = async (userId) => {
  const result = await pool.query(
    `SELECT c.id, c.quantity, p.name, p.price, p.image_url, p.category
     FROM cart c JOIN products p ON c.product_id = p.id
     WHERE c.user_id = $1`,
    [userId]
  );
  return result.rows;
};

const addToCart = async (userId, productId, quantity) => {
  // Upsert: if item exists, increment quantity
  const existing = await pool.query(
    'SELECT id, quantity FROM cart WHERE user_id = $1 AND product_id = $2',
    [userId, productId]
  );
  if (existing.rows.length > 0) {
    const result = await pool.query(
      'UPDATE cart SET quantity = quantity + $1 WHERE id = $2 RETURNING *',
      [quantity, existing.rows[0].id]
    );
    return result.rows[0];
  }
  const result = await pool.query(
    'INSERT INTO cart (user_id, product_id, quantity) VALUES ($1, $2, $3) RETURNING *',
    [userId, productId, quantity]
  );
  return result.rows[0];
};

const removeFromCart = async (cartItemId, userId) => {
  const result = await pool.query(
    'DELETE FROM cart WHERE id = $1 AND user_id = $2 RETURNING *',
    [cartItemId, userId]
  );
  return result.rows[0];
};

module.exports = { getCartByUser, addToCart, removeFromCart };
