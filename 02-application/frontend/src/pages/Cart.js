import React from 'react';
import { useCart } from '../context/CartContext';
import { useNavigate } from 'react-router-dom';
import './Cart.css';

const Cart = () => {
  const { cart, removeFromCart, updateQuantity, total } = useCart();
  const navigate = useNavigate();

  if (!cart.length) return (
    <div className="cart-empty">
      <h2>Your cart is empty</h2>
      <button onClick={() => navigate('/')}>Continue Shopping</button>
    </div>
  );

  return (
    <div className="cart-page">
      <h2>Shopping Cart</h2>
      <div className="cart-items">
        {cart.map((item) => (
          <div key={item.id} className="cart-item">
            <img src={item.image_url} alt={item.name} />
            <div className="cart-item-info">
              <h4>{item.name}</h4>
              <span className="cart-category">{item.category}</span>
              <p className="cart-price">${parseFloat(item.price).toFixed(2)}</p>
            </div>
            <div className="cart-qty">
              <button onClick={() => updateQuantity(item.id, item.quantity - 1)}>−</button>
              <span>{item.quantity}</span>
              <button onClick={() => updateQuantity(item.id, item.quantity + 1)}>+</button>
            </div>
            <p className="cart-subtotal">${(item.price * item.quantity).toFixed(2)}</p>
            <button className="btn-remove" onClick={() => removeFromCart(item.id)}>✕</button>
          </div>
        ))}
      </div>
      <div className="cart-summary">
        <h3>Total: ${total.toFixed(2)}</h3>
        <button className="btn-checkout" onClick={() => navigate('/payments')}>Proceed to Checkout</button>
      </div>
    </div>
  );
};

export default Cart;
