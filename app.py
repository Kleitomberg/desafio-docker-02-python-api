from flask import Flask
import os

app = Flask(__name__)


@app.get("/")
def home():
    return {
        "application": "python-api",
        "environment": os.getenv("ENVIRONMENT", "development")
    }