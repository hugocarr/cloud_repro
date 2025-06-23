from flask import (
	Flask,
	jsonify,
)


def create_app():
	app = Flask("hello_world_http_server")

	@app.route("/")
	def index():
		return jsonify(":D")

	return app


def main() -> None:
	app = create_app()

	app.run(host="0.0.0.0", port=5001)


if __name__ == "__main__":
	main()
