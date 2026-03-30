from flask_sqlalchemy import SQLAlchemy
from datetime import date

db = SQLAlchemy()

class Member(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    phone = db.Column(db.String(15))
    email = db.Column(db.String(100))
    plan = db.Column(db.String(50))
    fees = db.Column(db.Float)
    join_date = db.Column(db.Date)
    expiry_date = db.Column(db.Date)

    def status(self):
        if self.expiry_date and self.expiry_date < date.today():
            return "Expired"
        return "Active"
