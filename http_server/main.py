from flask import (
	Flask,
	jsonify,
)

from opentelemetry.instrumentation.flask import FlaskInstrumentor


def create_app():
	app = Flask("hello_world_http_server")

	@app.route("/")
	def index():
		return jsonify(":D")

	return app


def main() -> None:
	app = create_app()
	FlaskInstrumentor().instrument_app(app)

	app.run(host="0.0.0.0")


if __name__ == "__main__":
	main()
