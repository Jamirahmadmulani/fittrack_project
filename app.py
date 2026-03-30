from flask import Flask, render_template, request, redirect, url_for, flash
from config import Config
from models import db, Member
from datetime import datetime

app = Flask(__name__)
app.config.from_object(Config)

db.init_app(app)

with app.app_context():
    db.create_all()

@app.route("/")
def dashboard():
    members = Member.query.all()
    total_members = len(members)
    active_members = len([m for m in members if m.status() == "Active"])
    expired_members = len([m for m in members if m.status() == "Expired"])
    total_revenue = sum([m.fees or 0 for m in members])

    return render_template("dashboard.html",
                           total_members=total_members,
                           active_members=active_members,
                           expired_members=expired_members,
                           total_revenue=total_revenue)

@app.route("/members")
def view_members():
    members = Member.query.all()
    return render_template("view_members.html", members=members)

@app.route("/add", methods=["GET", "POST"])
def add_member():
    if request.method == "POST":
        member = Member(
            name=request.form["name"],
            phone=request.form["phone"],
            email=request.form["email"],
            plan=request.form["plan"],
            fees=float(request.form["fees"]),
            join_date=datetime.strptime(request.form["join_date"], "%Y-%m-%d"),
            expiry_date=datetime.strptime(request.form["expiry_date"], "%Y-%m-%d")
        )
        db.session.add(member)
        db.session.commit()
        flash("Member Added Successfully!")
        return redirect(url_for("view_members"))
    return render_template("add_member.html")

@app.route("/edit/<int:id>", methods=["GET", "POST"])
def edit_member(id):
    member = Member.query.get_or_404(id)

    if request.method == "POST":
        member.name = request.form["name"]
        member.phone = request.form["phone"]
        member.email = request.form["email"]
        member.plan = request.form["plan"]
        member.fees = float(request.form["fees"])
        member.join_date = datetime.strptime(request.form["join_date"], "%Y-%m-%d")
        member.expiry_date = datetime.strptime(request.form["expiry_date"], "%Y-%m-%d")

        db.session.commit()
        flash("Member Updated Successfully!")
        return redirect(url_for("view_members"))

    return render_template("edit_member.html", member=member)

@app.route("/delete/<int:id>")
def delete_member(id):
    member = Member.query.get_or_404(id)
    db.session.delete(member)
    db.session.commit()
    flash("Member Deleted Successfully!")
    return redirect(url_for("view_members"))

if __name__ == "__main__":
    app.run(debug=True)
