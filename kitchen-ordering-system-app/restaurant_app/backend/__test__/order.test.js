const request = require('supertest');
const app = require('../server');

describe('POST /api/orders', () => {
  it('should create an order and return 200', async () => {
    const orderData = {
      tableId: '684ae1c7addc65ea1db99718', // ⚠️ geçerli bir _id kullanmalısın!
      items: [
        {  menuItem: '684aea1c8ce8107647e6cb90', name: 'Margherita Pizza', quantity: 2, price: 90 }
      ],
      totalAmount: 180,
      status: 'pending',
      isPaid: false,
      paymentMethod: 'cash'
    };

    const res = await request(app)
      .post('/api/orders')
      .send(orderData);

    console.log('Gelen cevap:', res.body);

    expect(res.statusCode).toBe(201);
    expect(res.body).toHaveProperty('_id');
    expect(res.body).toHaveProperty('tableId');
  });
});
