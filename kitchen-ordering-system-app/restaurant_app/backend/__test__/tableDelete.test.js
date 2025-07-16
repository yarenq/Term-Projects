const request = require('supertest');
const app = require('../server');

describe('DELETE /api/tables/:id', () => {
  it('should delete the specified table and return 200', async () => {
    // 1. Önce yeni bir masa oluştur
    const newTable = {
      name: `Table ${Math.floor(Math.random() * 1000)}`,
      capacity: 2,
      x: 0,
      y: 0
    };

    const createRes = await request(app)
      .post('/api/tables')
      .send(newTable);

    const tableId = createRes.body._id;

    // 2. Şimdi o masayı sil
    const deleteRes = await request(app)
      .delete(`/api/tables/${tableId}`);

    console.log('Silme cevabı:', deleteRes.body);

    expect(deleteRes.statusCode).toBe(200);
    expect(deleteRes.body).toHaveProperty('message');
  });
});

