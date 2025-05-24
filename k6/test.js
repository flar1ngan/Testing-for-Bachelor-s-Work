import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '10m', target: 350 },
    { duration: '5m', target: 350 },
    { duration: '10m', target: 900 },
    { duration: '5m', target: 900 },
    { duration: '2m', target: 0 },
  ],
};

export default function () {
  const res = http.post('http://35.228.148.163/data', JSON.stringify({ msg: 'test' }), {
    headers: { 'Content-Type': 'application/json' },
  });
  check(res, {
    'status is 200': (r) => r.status === 200,
  });
  sleep(0.1);
}
