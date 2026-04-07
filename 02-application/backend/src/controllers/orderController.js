const { placeOrder, getOrdersByUser } = require('../models/orderModel');
const { getCartByUser } = require('../models/cartModel');

const createOrder = async (req, res, next) => {
  try {
    const cartItems = await getCartByUser(req.user.id);
    if (!cartItems.length) return res.status(400).json({ error: 'Cart is empty' });

    const totalPrice = cartItems.reduce(
      (sum, item) => sum + parseFloat(item.price) * item.quantity, 0
    );
    const order = await placeOrder(req.user.id, totalPrice.toFixed(2));
    res.status(201).json({ message: 'Order placed successfully', order });
  } catch (err) {
    next(err);
  }
};

const getOrders = async (req, res, next) => {
  try {
    const orders = await getOrdersByUser(req.user.id);
    res.json(orders);
  } catch (err) {
    next(err);
  }
};

module.exports = { createOrder, getOrders };
