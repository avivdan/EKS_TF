from flask import Blueprint, jsonify

main_bp = Blueprint('main', __name__)

@main_bp.route("/", methods=["GET"])
def index():
    return "Hello, Dockerized Flask!"

@main_bp.route("/health", methods=["GET"])
def health():
    return jsonify({"status": "healthy"}), 200 