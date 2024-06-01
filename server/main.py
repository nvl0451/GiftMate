import datetime
import os

import jwt
import openai
from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from openai import OpenAI
from werkzeug.security import generate_password_hash, check_password_hash

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:2024@localhost:5433/kurs'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SECRET_KEY'] = 'hui'
db = SQLAlchemy(app)

client = OpenAI(
    api_key="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",
)


class User(db.Model):
    __tablename__ = 'users'

    id = db.Column(db.Integer, primary_key=True)
    login = db.Column(db.String(80), unique=True, nullable=False)
    password = db.Column(db.String(500), nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)


class UserProfile(db.Model):
    __tablename__ = 'user_profiles'

    id = db.Column(db.Integer, db.ForeignKey('users.id'), primary_key=True)
    interests = db.Column(db.String(500), nullable=True)
    social_networks = db.Column(db.String(500), nullable=True)
    friends_list = db.Column(db.String(500), nullable=True)
    followers_list = db.Column(db.String(500), nullable=True)
    following_list = db.Column(db.String(500), nullable=True)


@app.route('/register', methods=['POST'])
def register():
    data = request.json
    login = data.get('login')
    email = data.get('email')
    password = data.get('password')

    if not login or not email or not password:
        return jsonify({"error": "Missing data"}), 400

    if User.query.filter_by(login=login).first() is not None:
        return jsonify({"error": "Login already taken"}), 400

    if User.query.filter_by(email=email).first() is not None:
        return jsonify({"error": "Email already registered"}), 400

    hashed_password = generate_password_hash(password)

    new_user = User(login=login, email=email, password=hashed_password)
    db.session.add(new_user)
    db.session.commit()

    return jsonify({"message": "User registered successfully"}), 201


@app.route('/login', methods=['POST'])
def login():
    data = request.json
    user = User.query.filter_by(email=data.get('email')).first()

    if user and check_password_hash(user.password, data.get('password')):
        token = jwt.encode({
            'user_id': user.id,
            'exp': datetime.datetime.utcnow() + datetime.timedelta(minutes=30)
        }, app.config['SECRET_KEY'], algorithm="HS256")

        return jsonify({'token': token})

    return jsonify({'message': 'Invalid credentials'}), 401


@app.route('/get_ideas', methods=['POST'])
def fetch_gift_ideas():
    data = request.json
    interests = data.get('interests')
    print(interests)
    promt = f"Дай список максимально подходящих подарков по этим интересам {interests}. Ответ должен содержать список подарков по одному на каждой строке."
    chat_completion = client.chat.completions.create(
        messages=[
            {
                "role": "user",
                "content": promt,
            }
        ],
        model="gpt-3.5-turbo",
    )
    print(chat_completion.choices[0].message.content)
    return jsonify({"ans": chat_completion.choices[0].message.content})


with app.app_context():
    db.create_all()

if __name__ == '__main__':
    app.run(debug=True)
