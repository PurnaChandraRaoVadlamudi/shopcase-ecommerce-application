const pool = require('../config/db');

const placeOrder = async (userId, totalPrice) => {
  const result = await pool.query(
    'INSERT INTO orders (user_id, total_price, status) VALUES ($1, $2, $3) RETURNING *',
    [userId, totalPrice, 'pending']
  );
  // Clear cart after order
  await pool.query('DELETE FROM cart WHERE user_id = $1', [userId]);
  return result.rows[0];
};

const getOrdersByUser = async (userId) => {
  const result = await pool.query(
    'SELECT * FROM orders WHERE user_id = $1 ORDER BY created_at DESC',
    [userId]
  );
  return result.rows;
};

module.exports = { placeOrder, getOrdersByUser };
