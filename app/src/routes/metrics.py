import random
import time

from flask import Blueprint, jsonify

metrics_bp = Blueprint("metrics", __name__)

start_time = time.time()


@metrics_bp.route("/metrics/custom")
def metrics():
    uptime = time.time() - start_time
    random_value = random.randint(1, 100)
    return jsonify({"uptime_seconds": uptime, "random_value": random_value}), 200
