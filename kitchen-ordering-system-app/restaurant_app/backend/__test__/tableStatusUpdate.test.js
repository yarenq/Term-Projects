const request = require('supertest');
const app = require('../server');

describe('PATCH /api/tables/:id/status', () => {
  it('should update the status of a table and return 200', async () => {
    // 1. Yeni bir masa oluştur
    const newTable = {
      name: `Table ${Math.floor(Math.random() * 1000)}`,
      capacity: 4,
      x: 2,
      y: 2
    };

    const createRes = await request(app)
      .post('/api/tables')
      .send(newTable);

    const tableId = createRes.body._id;

    // 2. Durumu güncelle
    const updateRes = await request(app)
      .patch(`/api/tables/${tableId}/status`)
      .send({ status: 'occupied' });

    console.log('Güncelleme cevabı:', updateRes.body);

    expect(updateRes.statusCode).toBe(200);
    expect(updateRes.body).toHaveProperty('status', 'occupied');
  });
});

