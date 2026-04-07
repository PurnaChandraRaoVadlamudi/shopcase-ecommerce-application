const router = require('express').Router();
const { getCart, addItem, removeItem } = require('../controllers/cartController');
const auth = require('../middleware/authMiddleware');

router.get('/', auth, getCart);
router.post('/', auth, addItem);
router.delete('/:id', auth, removeItem);

module.exports = router;
