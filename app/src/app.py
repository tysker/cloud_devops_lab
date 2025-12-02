from flask import Flask

from src.routes.health import health_bp
from src.routes.metrics import metrics_bp
from src.routes.root import root_bp


def create_app():
    app = Flask(__name__)
    app.register_blueprint(health_bp)
    app.register_blueprint(metrics_bp)
    app.register_blueprint(root_bp)
    return app


app = create_app()

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
