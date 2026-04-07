import React from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { useCart } from '../context/CartContext';
import './Navbar.css';

const Navbar = () => {
  const { user, logout } = useAuth();
  const { cart } = useCart();
  const navigate = useNavigate();

  const handleLogout = () => { logout(); navigate('/login'); };

  return (
    <header className="navbar">
      <div className="navbar-brand">Shopcase E-Commerce Application</div>
      <nav className="navbar-links">
        <Link to="/">Home</Link>
        <Link to="/payments">Payments</Link>
        <Link to="/cart">Cart {cart.length > 0 && <span className="badge">{cart.length}</span>}</Link>
        <Link to="/services">Services</Link>
        {user ? (
          <>
            <span className="nav-user">Hi, {user.name}</span>
            <button className="btn-logout" onClick={handleLogout}>Logout</button>
          </>
        ) : (
          <>
            <Link to="/login">Login</Link>
            <Link to="/register">Register</Link>
          </>
        )}
      </nav>
    </header>
  );
};

export default Navbar;
