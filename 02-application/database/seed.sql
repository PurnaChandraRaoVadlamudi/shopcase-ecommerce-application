INSERT INTO products (name, category, price, image_url) VALUES
-- Men Shoes (5)
('Nike Air Max 270',        'Men Shoes',        89.99,  'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400'),
('Adidas Ultraboost 22',    'Men Shoes',        119.99, 'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=400'),
('Puma RS-X Runner',        'Men Shoes',        74.99,  'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=400'),
('Reebok Classic Leather',  'Men Shoes',        64.99,  'https://images.unsplash.com/photo-1539185441755-769473a23570?w=400'),
('New Balance 574',         'Men Shoes',        79.99,  'https://images.unsplash.com/photo-1556906781-9a412961a28c?w=400'),

-- Women Shoes (5)
('Nike Air Force 1 Women',  'Women Shoes',      84.99,  'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=400'),
('Adidas Stan Smith Women', 'Women Shoes',      74.99,  'https://images.unsplash.com/photo-1600185365483-26d7a4cc7519?w=400'),
('Vans Old Skool Women',    'Women Shoes',      59.99,  'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=400'),
('Converse Chuck Taylor',   'Women Shoes',      54.99,  'https://images.unsplash.com/photo-1494496195158-c3bc5b7b5d6e?w=400'),
('Steve Madden Heels',      'Women Shoes',      94.99,  'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?w=400'),

-- Men Clothes (4)
('Levi''s 501 Jeans',       'Men Clothes',      59.99,  'https://images.unsplash.com/photo-1542272604-787c3835535d?w=400'),
('Ralph Lauren Polo Shirt', 'Men Clothes',      49.99,  'https://images.unsplash.com/photo-1586790170083-2f9ceadc732d?w=400'),
('H&M Slim Fit Chinos',     'Men Clothes',      34.99,  'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=400'),
('Zara Casual Blazer',      'Men Clothes',      89.99,  'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=400'),

-- Women Clothes (4)
('Zara Floral Dress',       'Women Clothes',    49.99,  'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=400'),
('H&M Denim Jacket',        'Women Clothes',    44.99,  'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=400'),
('Mango Midi Skirt',        'Women Clothes',    39.99,  'https://images.unsplash.com/photo-1583496661160-fb5886a0aaaa?w=400'),
('Forever 21 Crop Top',     'Women Clothes',    19.99,  'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?w=400'),

-- Men Accessories (4)
('Casio G-Shock Watch',     'Men Accessories',  129.99, 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400'),
('Ray-Ban Aviator Sunglasses','Men Accessories',149.99, 'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=400'),
('Leather Bifold Wallet',   'Men Accessories',  29.99,  'https://images.unsplash.com/photo-1627123424574-724758594e93?w=400'),
('Silver Chain Necklace',   'Men Accessories',  39.99,  'https://images.unsplash.com/photo-1611591437281-460bfbe1220a?w=400'),

-- Women Accessories (4)
('Michael Kors Handbag',    'Women Accessories',199.99, 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=400'),
('Gold Hoop Earrings',      'Women Accessories',24.99,  'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?w=400'),
('Fossil Rose Gold Watch',  'Women Accessories',119.99, 'https://images.unsplash.com/photo-1508057198894-247b23fe5ade?w=400'),
('Pearl Bracelet Set',      'Women Accessories',34.99,  'https://images.unsplash.com/photo-1611591437281-460bfbe1220a?w=400')

ON CONFLICT DO NOTHING;
