const { getCartByUser, addToCart, removeFromCart } = require('../models/cartModel');

const getCart = async (req, res, next) => {
  try {
    const items = await getCartByUser(req.user.id);
    res.json(items);
  } catch (err) {
    next(err);
  }
};

const addItem = async (req, res, next) => {
  try {
    const { product_id, quantity = 1 } = req.body;
    if (!product_id) return res.status(400).json({ error: 'product_id is required' });
    const item = await addToCart(req.user.id, product_id, quantity);
    res.status(201).json(item);
  } catch (err) {
    next(err);
  }
};

const removeItem = async (req, res, next) => {
  try {
    const deleted = await removeFromCart(req.params.id, req.user.id);
    if (!deleted) return res.status(404).json({ error: 'Cart item not found' });
    res.json({ message: 'Item removed' });
  } catch (err) {
    next(err);
  }
};

module.exports = { getCart, addItem, removeItem };
