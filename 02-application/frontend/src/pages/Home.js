import React, { useEffect, useState } from 'react';
import api from '../api/axios';
import ProductCard from '../components/ProductCard';
import './Home.css';

const CATEGORIES = ['Men Shoes','Women Shoes','Men Clothes','Women Clothes','Men Accessories','Women Accessories'];

const Home = () => {
  const [products, setProducts] = useState([]);
  const [activeCategory, setActiveCategory] = useState('All');
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    api.get('/api/products')
      .then((res) => setProducts(res.data))
      .catch(console.error)
      .finally(() => setLoading(false));
  }, []);

  const filtered = activeCategory === 'All'
    ? products
    : products.filter((p) => p.category === activeCategory);

  return (
    <div className="home">
      <div className="hero">
        <h1>Welcome to Shopcase</h1>
        <p>Discover the latest trends in fashion & accessories</p>
      </div>

      <div className="category-tabs">
        <button className={activeCategory === 'All' ? 'active' : ''} onClick={() => setActiveCategory('All')}>All</button>
        {CATEGORIES.map((c) => (
          <button key={c} className={activeCategory === c ? 'active' : ''} onClick={() => setActiveCategory(c)}>{c}</button>
        ))}
      </div>

      {loading ? (
        <p className="loading">Loading products...</p>
      ) : (
        <div className="products-grid">
          {filtered.map((p) => <ProductCard key={p.id} product={p} />)}
        </div>
      )}
    </div>
  );
};

export default Home;
