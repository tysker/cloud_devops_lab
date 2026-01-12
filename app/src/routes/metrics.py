import time

from flask import Blueprint
from prometheus_client import CONTENT_TYPE_LATEST, Gauge, generate_latest

metrics_bp = Blueprint("metrics", __name__)

start_time = time.time()

uptime_gauge = Gauge("app_uptime_seconds", "App uptime in seconds")
random_gauge = Gauge("app_random_value", "Random value")

start_time = time.time()


@metrics_bp.route("/metrics")
def metrics():
    uptime_gauge.set(time.time() - start_time)
    # random_gauge.set(...)
    return generate_latest(), 200, {"Content-Type": CONTENT_TYPE_LATEST}


# @metrics_bp.route("/metrics/custom")
# def metrics_custom():
#     uptime = time.time() - start_time
#     random_value = random.randint(1, 100)
#     return jsonify({"uptime_seconds": uptime, "random_value": random_value}), 200
