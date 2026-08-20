# NextToppers QR Print

Local-network QR self-service printing for Windows with Google Drive document storage, host approval, optional payment, and admin-controlled printer routing.

## V1.5 Global UI

- One permanent LAN QR and shareable customer link.
- Customer cannot choose the printer; only an administrator selects the Windows printer.
- PDF/JPG/PNG upload with copies, page range, B/W or colour, A4/A3, duplex and orientation.
- Google Drive OAuth storage. Print documents are not permanently stored on the host PC.
- Host approval/manual UPI/cash workflow.
- Razorpay payment verification can trigger automatic printing after a captured payment.
- Compact admin dashboard with 10 jobs per page, filters and responsive job table.
- Uploadable logo, tagline and optional hero background in **Admin → Branding**.
- Lightweight 3D customer experience using CSS only; no external CDN is required on the LAN.
- Responsive layouts for desktop, tablet and mobile with `prefers-reduced-motion` accessibility support.
- GitHub Actions CI on Windows and Ubuntu, plus release packaging/CD for version tags.

## Start on Windows

1. Extract the project to a permanent folder such as `D:\nexttoppers_printer_app_v1`.
2. Run `start_windows.bat`.
3. Open the LAN Admin URL shown by the launcher.
4. Initial credentials are `admin` / `ChangeMe123!`. Change the password immediately.
5. Go to **Printer & Drive**, choose the actual Windows printer and run **Print 1 test page**.
6. Configure Google Drive OAuth and verify the Drive folder.
7. Go to **Branding** to upload your logo/background and preview the customer page.

## Google Drive

Use a Google **Desktop OAuth client**, not a service-account key. The app stores OAuth secrets/tokens encrypted in the local settings database. Enable the Google Drive API in the same Google Cloud project used by the OAuth client.

The configured default folder ID is:

`1UyFQCt6gBZ9wkeNWPGWmkL4jJj0Kugdu`

## Document storage rule

Customer documents are uploaded to Google Drive. At print time the host downloads only a temporary PDF, sends it to the Windows print engine/spooler, then removes the temporary file. The local SQLite database stores job metadata, not permanent document copies.

## Payment

- **Manual payment QR**: customer pays using the uploaded UPI QR, clicks “I have paid”, then the host verifies and approves printing.
- **Razorpay**: the backend creates the order, verifies the signature/payment status and starts printing only after the payment is captured.

## CI/CD

`.github/workflows/ci.yml` runs Python compile + smoke tests on Windows and Ubuntu for every push/PR to `main`.

`.github/workflows/release.yml` is continuous delivery: every `v*` tag runs tests, builds `NextToppers-QR-Print-Windows.zip`, uploads the artifact and publishes it to GitHub Releases. Local LAN deployment is intentionally not pushed from GitHub because the printer host is inside the private network; automatic host deployment requires a GitHub self-hosted Windows runner.

## Security

Do not commit runtime secrets or credentials. `.gitignore` excludes `.env`, OAuth JSON, database files, keys, tokens, logs and ZIP archives.
