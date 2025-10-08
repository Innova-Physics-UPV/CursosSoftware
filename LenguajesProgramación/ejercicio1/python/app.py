import flask
import requests

app = flask.Flask(__name__)

@app.route("/")
def home():
    response = requests.get("https://api.github.com")
    return f"Status GitHub API: {response.status_code}"

if __name__ == "__main__":
    app.run()
