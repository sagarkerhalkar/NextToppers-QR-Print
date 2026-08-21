# NextToppers QR Print V2.0.0

Commercial LAN self-service printing for Windows with Google Drive document storage, customer/staff printing, host approval, optional Razorpay/manual payment, reports, universal file conversion, Windows service autostart, and an installable EXE build pipeline.

## V2.0 changes

- Admin can **Enable / Disable Customer Name Required** in **Admin → Printer & Drive**.
- When enabled, customers must type their name before submitting a print job. The name is recorded in queue, approvals and reports.
- Staff remains fixed at `http://SERVER-IP:8765/staff`. The Staff QR never rotates.
- Staff printing can still be enabled/disabled by Admin; staff enter their name, see no amount/payment, and auto-print when enabled.
- Customer price is calculated automatically from pages, copies, B/W/Colour and A4/A3 settings.
- Supports PDF, images, Word, Excel, PowerPoint, text and common OpenDocument formats.
- Customer documents are **Google Drive-only** for permanent storage.
- Word/Excel/PowerPoint and images are converted only in temporary working files for printing; temporary files are deleted and stale temp leftovers are cleaned automatically after abnormal shutdowns.
- The Windows installer asks where to store the small local metadata database/settings. If `D:` exists, default is `D:\NextToppersQRPrintData`; otherwise it falls back to `C:\ProgramData\NextToppersQRPrint\data`.
- Windows Service startup is **Automatic** and configured to restart after failures.

## URLs

- Customer: `http://SERVER-IP:8765/`
- Staff: `http://SERVER-IP:8765/staff`
- Admin: `http://SERVER-IP:8765/admin`

## Local storage rule

The selected local data folder contains only:

- `printer.db` — job metadata, settings and user records
- `app_secret.key` — local encryption/session key

Uploaded customer/staff documents are not permanently kept in this folder. They are uploaded to the configured Google Drive folder. Temporary conversion/print files use the operating-system temp folder and are removed automatically.

## Installable EXE

GitHub Actions builds:

`NextToppers-QR-Print-Setup-v2.0.0.exe`

The installer:

1. Installs the standalone application and Windows service.
2. Lets Admin choose the metadata/data folder (D: is preferred automatically when available).
3. Opens local-subnet TCP port `8765` in Windows Firewall.
4. Checks/installs the PDF print engine.
5. Checks/installs LibreOffice for Word/Excel/PowerPoint conversion.
6. Installs `NextToppersQRPrint` as an Automatic Windows service.
7. Configures automatic service restart after failure.

No separate Python installation is required for the packaged EXE.

## Supported files

- PDF: `.pdf`
- Word: `.doc`, `.docx`, `.rtf`, `.odt`
- Excel: `.xls`, `.xlsx`, `.xlsm`, `.ods`, `.csv`
- PowerPoint: `.ppt`, `.pptx`, `.odp`
- Text: `.txt`
- Images: JPG/JPEG/JFIF, PNG, BMP, TIFF, GIF, WebP, HEIC/HEIF, AVIF, ICO
- Vector: SVG, EMF, WMF

## Google Drive

Use Google Desktop OAuth in Admin. Google Drive API must be enabled in the same Google Cloud project used for the OAuth client.

Default configured Drive folder ID:

`1UyFQCt6gBZ9wkeNWPGWmkL4jJj0Kugdu`

## Payment modes

- Approval only
- Payment or approval
- Razorpay payment with server-side verification and automatic printing after confirmed/captured payment
- Manual UPI QR with host verification

## Reports

Admin can filter print jobs by date/type/status and download CSV/PDF reports. Customer names (when enabled) and Staff names are included in reporting.

## Build / CI

- `.github/workflows/ci.yml` runs compile, dependency checks and automated tests on Windows and Ubuntu.
- `.github/workflows/release.yml` builds and smoke-tests the Windows EXE and creates the installer artifact on every push to `main`.
- Tagged `v*` builds can publish the installer to GitHub Releases.

## Security

Do not commit runtime database files, OAuth client secrets, refresh tokens, payment secrets, `.env`, or private keys. `.gitignore` excludes local runtime/secrets.
