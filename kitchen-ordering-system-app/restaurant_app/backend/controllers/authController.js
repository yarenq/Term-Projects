const login = (req, res) => {
  const { id, password } = req.body;
  if (id === 'admin123' && password === 'admin123') {
    return res.json({ success: true, role: 'admin' });
  }
  if (id === 'staff123' && password === 'staff123') {
    return res.json({ success: true, role: 'staff' });
  }
  return res.status(401).json({ success: false, message: 'Invalid credentials' });
};

module.exports = { login }; 