# SSL Certificates

Place your SSL certificates here for production HTTPS support:

- `cert.pem` - SSL certificate
- `key.pem` - SSL private key

For development/testing, you can generate self-signed certificates:

```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout key.pem -out cert.pem \
  -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"
```

**Note:** This directory is excluded from version control for security.

