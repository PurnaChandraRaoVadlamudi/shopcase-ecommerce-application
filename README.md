# Shopcase E-Commerce Application

A production-ready 3-tier e-commerce web application.

## Repo Structure

```
01-infrastructure/   # Terraform / IaC (reserved)
02-application/
  ├── frontend/      # React.js app
  ├── backend/       # Node.js + Express API
  ├── database/      # PostgreSQL schema & seed
  └── docker-compose.yml
03-kubernetes/       # K8s manifests (reserved)
04-monitoring/       # Prometheus / Grafana (reserved)
05-scripts/
  └── install-tools.sh
```

## Quick Start (Docker)

```bash
cd 02-application
cp backend/.env.example backend/.env
docker-compose up --build
```

- Frontend: http://localhost:3000
- Backend API: http://localhost:5000
- Health check: http://localhost:5000/health

## Local Development

### Backend
```bash
cd 02-application/backend
cp .env.example .env   # fill in your DB credentials
npm install
npm run dev
```

### Frontend
```bash
cd 02-application/frontend
cp .env.example .env
npm install
npm start
```

## API Reference

| Method | Endpoint            | Auth | Description          |
|--------|---------------------|------|----------------------|
| POST   | /api/auth/register  | No   | Register user        |
| POST   | /api/auth/login     | No   | Login, returns JWT   |
| GET    | /api/products       | No   | List all products    |
| GET    | /api/cart           | JWT  | Get user cart        |
| POST   | /api/cart           | JWT  | Add item to cart     |
| DELETE | /api/cart/:id       | JWT  | Remove cart item     |
| POST   | /api/order          | JWT  | Place order          |
| GET    | /api/orders         | JWT  | Order history        |

## Install DevOps Tools

```bash
bash 05-scripts/install-tools.sh
```
Installs: Terraform, Docker, kubectl, Helm, AWS CLI
