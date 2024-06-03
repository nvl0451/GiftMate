from . import db


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
