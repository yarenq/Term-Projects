const request = require('supertest');
const app = require('../server');

describe('PATCH /api/orders/:id/payment', () => {
  it('should update the payment status and method of an order and return 200', async () => {
    // 1. Yeni sipariş oluştur
    const orderData = {
      tableId: '684ae1c7addc65ea1db99718', // geçerli masa ID
      items: [
        {
          menuItem: '684aea1c8ce8107647e6cb90', // geçerli menü ID
          name: 'Margherita Pizza',
          quantity: 1,
          price: 90
        }
      ],
      totalAmount: 90,
      status: 'pending',
      isPaid: false,
      paymentMethod: 'cash'
    };

    const createRes = await request(app)
      .post('/api/orders')
      .send(orderData);

    const orderId = createRes.body._id;

    // 2. Ödeme bilgilerini güncelle
    const paymentUpdate = {
      isPaid: true,
      paymentMethod: 'credit_card'
    };

    const updateRes = await request(app)
      .patch(`/api/orders/${orderId}/payment`)
      .send(paymentUpdate);

    console.log('Ödeme güncelleme cevabı:', updateRes.body);

    // 3. Beklenen çıktılar
    expect(updateRes.statusCode).toBe(200);
    expect(updateRes.body).toHaveProperty('isPaid', true);
    expect(updateRes.body).toHaveProperty('paymentMethod', 'credit_card');
  });
});

