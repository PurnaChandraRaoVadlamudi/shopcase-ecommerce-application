import React, { useState } from 'react';
import { useCart } from '../context/CartContext';
import { useAuth } from '../context/AuthContext';
import api from '../api/axios';
import { useNavigate } from 'react-router-dom';
import './Payments.css';

const Payments = () => {
  const { cart, total, clearCart } = useCart();
  const { user } = useAuth();
  const navigate = useNavigate();
  const [card, setCard] = useState({ name: '', number: '', expiry: '', cvv: '' });
  const [success, setSuccess] = useState(false);
  const [loading, setLoading] = useState(false);

  const handleChange = (e) => setCard({ ...card, [e.target.name]: e.target.value });

  const handleCheckout = async (e) => {
    e.preventDefault();
    if (!user) return navigate('/login');
    setLoading(true);
    try {
      await api.post('/api/order', { total_price: total });
      clearCart();
      setSuccess(true);
    } catch (err) {
      alert(err.response?.data?.error || 'Order failed');
    } finally {
      setLoading(false);
    }
  };

  if (success) return (
    <div className="payment-success">
      <div className="success-card">
        <div className="success-icon">✓</div>
        <h2>Order Placed Successfully!</h2>
        <p>Thank you for shopping with Shopcase.</p>
        <button onClick={() => navigate('/')}>Continue Shopping</button>
      </div>
    </div>
  );

  return (
    <div className="payments-page">
      <div className="order-summary">
        <h3>Order Summary</h3>
        {cart.length === 0 ? <p>No items in cart.</p> : cart.map((item) => (
          <div key={item.id} className="summary-item">
            <span>{item.name} × {item.quantity}</span>
            <span>${(item.price * item.quantity).toFixed(2)}</span>
          </div>
        ))}
        <div className="summary-total">
          <strong>Total</strong>
          <strong>${total.toFixed(2)}</strong>
        </div>
      </div>

      <div className="payment-form-card">
        <h3>Payment Details <span className="simulated-badge">Simulated</span></h3>
        <form onSubmit={handleCheckout}>
          <input name="name" placeholder="Cardholder Name" value={card.name} onChange={handleChange} required />
          <input name="number" placeholder="Card Number (16 digits)" maxLength={16} value={card.number} onChange={handleChange} required />
          <div className="card-row">
            <input name="expiry" placeholder="MM/YY" value={card.expiry} onChange={handleChange} required />
            <input name="cvv" placeholder="CVV" maxLength={3} value={card.cvv} onChange={handleChange} required />
          </div>
          <button type="submit" disabled={loading || !cart.length}>
            {loading ? 'Processing...' : `Pay $${total.toFixed(2)}`}
          </button>
        </form>
      </div>
    </div>
  );
};

export default Payments;
