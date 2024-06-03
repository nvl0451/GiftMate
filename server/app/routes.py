from flask import request, jsonify, current_app as app
from .models import User, db
from werkzeug.security import generate_password_hash, check_password_hash
import jwt
import datetime
from .services import openai_service


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
    try:
        gift_ideas = openai_service.get_gift_ideas(interests)
        return jsonify({"ans": gift_ideas})
    except Exception as e:
        return jsonify({"error": str(e)}), 500
