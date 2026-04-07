import React from 'react';
import './Services.css';

const services = [
  { icon: '🚚', title: 'Free Shipping', desc: 'Free delivery on all orders above $50.' },
  { icon: '↩️', title: 'Easy Returns', desc: '30-day hassle-free return policy.' },
  { icon: '🔒', title: 'Secure Payments', desc: 'Your payment info is always protected.' },
  { icon: '🎧', title: '24/7 Support', desc: 'Round-the-clock customer support.' },
  { icon: '🏷️', title: 'Best Prices', desc: 'Guaranteed lowest prices on all products.' },
  { icon: '⚡', title: 'Fast Delivery', desc: 'Express delivery within 2-3 business days.' },
];

const Services = () => (
  <div className="services-page">
    <div className="services-hero">
      <h1>Our Services</h1>
      <p>Everything we do to make your shopping experience better</p>
    </div>
    <div className="services-grid">
      {services.map((s) => (
        <div key={s.title} className="service-card">
          <div className="service-icon">{s.icon}</div>
          <h3>{s.title}</h3>
          <p>{s.desc}</p>
        </div>
      ))}
    </div>
  </div>
);

export default Services;
