from flask import Flask, jsonify
import os
from .routes import main_bp

class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY', 'dev')
    ENV = 'production'
    DEBUG = False

class DevelopmentConfig(Config):
    ENV = 'development'
    DEBUG = True

class ProductionConfig(Config):
    pass

def create_app():
    app = Flask(__name__)
    env = os.environ.get('FLASK_ENV', 'production')
    if env == 'development':
        app.config.from_object(DevelopmentConfig)
    else:
        app.config.from_object(ProductionConfig)

    app.register_blueprint(main_bp)

    @app.errorhandler(404)
    def not_found(error):
        return jsonify({'error': 'Not found'}), 404

    @app.errorhandler(500)
    def internal_error(error):
        return jsonify({'error': 'Internal server error'}), 500

    return app 