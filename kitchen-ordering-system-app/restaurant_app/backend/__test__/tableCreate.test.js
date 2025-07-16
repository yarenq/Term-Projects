const request = require('supertest');
const app = require('../server');

describe('POST /api/tables', () => {
  it('should create a new table and return 201', async () => {
    const tableData = {
      name: `Table ${Math.floor(Math.random() * 1000)}`, // benzersiz isim
      capacity: 4,
      x: 1,
      y: 1
    };

    const res = await request(app)
      .post('/api/tables')
      .send(tableData);

    console.log('Yeni masa cevabı:', res.body);

    expect(res.statusCode).toBe(201);
    expect(res.body).toHaveProperty('_id');
    expect(res.body).toHaveProperty('name', tableData.name);
    expect(res.body).toHaveProperty('capacity', tableData.capacity);
  });
});

