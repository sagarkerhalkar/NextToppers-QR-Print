import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
import os

os.environ.setdefault("LAN_REQUIRED", "0")
os.environ.setdefault("PRINT_BACKEND", "mock")
os.environ.setdefault("APP_SECRET", "ci-smoke-test-secret")

from fastapi.testclient import TestClient
from app.main import app


def test_public_page_loads():
    client = TestClient(app)
    response = client.get("/")
    assert response.status_code == 200
    assert "Print from your phone" in response.text
    assert "viewport" in response.text


def test_admin_login_loads():
    client = TestClient(app)
    response = client.get("/admin/login")
    assert response.status_code == 200


def test_health_endpoint():
    client = TestClient(app)
    response = client.get("/health")
    assert response.status_code == 200
    payload = response.json()
    assert payload["ok"] is True
    assert payload["version"].startswith("1.5.0")
