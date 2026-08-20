"""NextToppers QR Print V1.5 runtime loader.

The connected GitHub transport stores the tested V1.5 application core and stylesheet
as compressed text parts. This loader materializes the stylesheet and executes the
verified application source without storing customer documents locally.
"""
from __future__ import annotations

import base64
import gzip
from pathlib import Path

APP_DIR = Path(__file__).resolve().parent
RUNTIME_DIR = APP_DIR / "runtime"
STATIC_DIR = APP_DIR / "static"
STATIC_DIR.mkdir(parents=True, exist_ok=True)


def _read_parts(prefix: str) -> bytes:
    parts = sorted(RUNTIME_DIR.glob(prefix + ".*"))
    if not parts:
        raise RuntimeError(f"Missing runtime bundle: {prefix}")
    packed = "".join(p.read_text(encoding="ascii").strip() for p in parts)
    return gzip.decompress(base64.b64decode(packed))


# Materialize the local CSS before the FastAPI core mounts /static.
(STATIC_DIR / "app.css").write_bytes(_read_parts("app.css.gz.b64"))

# Execute the tested V1.5 FastAPI application in this module namespace so
# `uvicorn app.main:app` works normally on Windows and in CI.
_core_source = _read_parts("core.py.gz.b64").decode("utf-8")
exec(compile(_core_source, str(APP_DIR / "main.source.py"), "exec"), globals(), globals())
