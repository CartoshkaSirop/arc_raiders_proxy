import { connect } from '@vercel/node';

const userID = '4e7b8c2d-9a1f-4b3c-8d5e-6f7a8b9c0d1e';

export default async function handler(req, res) {
  if (req.headers.upgrade !== 'websocket') {
    return res.status(200).send('Server is running');
  }

  const { socket: clientSocket } = req;
  clientSocket.accept();

  // Базовая обработка трафика без использования Docker
  clientSocket.on('data', async (chunk) => {
    const clientUUID = Array.from(chunk.slice(1, 17)).map(b => b.toString(16).padStart(2, '0')).join('');
    if (clientUUID !== userID.replace(/-/g, '')) {
      clientSocket.destroy();
      return;
    }
    // Проксирование игрового потока
  });
}

