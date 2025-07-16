const request = require('supertest');
const app = require('../server');

describe('PATCH /api/orders/:id/status', () => {
  it('should update the status of an order and return 200', async () => {
    // 1. Yeni bir sipariş oluştur
    const orderData = {
      tableId: '684ae1c7addc65ea1db99718', // geçerli bir ID
      items: [
        {
          menuItem: '684aebb4edfec4641decec1e', // geçerli bir menü ID'si
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
    const itemId = createRes.body.items[0]._id; // İlk öğenin ID'si

    // 2. Siparişin durumunu güncelle
    const updateRes = await request(app)
      .patch(`/api/orders/${orderId}/status`)
      .send({ status: 'served', itemId });

    console.log('Durum güncelleme cevabı:', updateRes.body);

    expect(updateRes.statusCode).toBe(200);
    expect(updateRes.body.items[0]).toHaveProperty('status', 'served');
  });
});

