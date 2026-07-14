# Medical Store Management System (MSMS)
**MCA Major Project — Saurabh B. Navatre | Python Flask + MySQL**

## Quick Setup

```bash
# 1. Install Python packages
pip install -r requirements.txt

# 2. Install system dependencies
sudo apt install tesseract-ocr libpango-1.0-0 libpangoft2-1.0-0

# 3. Create MySQL database
mysql -u root -p -e "CREATE DATABASE msms_dev CHARACTER SET utf8mb4;"

# 4. Setup environment
cp .env.example .env
# Edit .env: set DEV_DATABASE_URL with your MySQL password

# 5. Run migrations
flask db init
flask db migrate -m "Initial"
flask db upgrade

# 6. Seed sample data
python scripts/seed_data.py

# 7. Start server
flask run
```

## Login
- URL: http://localhost:5000/auth/login
- Username: `admin` | Password: `Admin@123`
- Other users: `pharmacist1/Pharma@123`, `cashier1/Cash@123`, `manager1/Manager@123`

## Modules
| # | Module | URL |
|---|--------|-----|
| 1 | Business Setup | /business/setup |
| 2 | User Management | /users/ |
| 3 | Medicine Master | /medicines/ |
| 4 | Inventory | /inventory/stock |
| 5 | Suppliers | /suppliers/ |
| 6 | Purchase + OCR | /purchase/ |
| 7 | Billing (POS) | /sales/billing |
| 8 | Prescriptions | /prescriptions/ |
| 9 | Patients | /patients/ |
| 10 | Doctors | /doctors/ |
| 11 | GST Reports | /gst/ |
| 12 | Accounting | /accounting/ |
| 13 | Returns | /returns/ |
| 14 | Compliance (H/H1) | /compliance/ |
| 15 | Reports (30+) | /reports/ |
| 16 | Dashboard | / |
| 17 | Notifications | /notifications/ |
| 18 | Branches | /branches/ |
| 19 | AI Reorder | /ai/smart-reorder |
| 20 | Loyalty | /loyalty/ |

## Tech Stack
- Python 3.11 + Flask 3.0
- MySQL 8.0 + SQLAlchemy
- Bootstrap 5 + Jinja2
- WeasyPrint (PDF) + openpyxl (Excel)
