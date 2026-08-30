<%@ Page Title="Driver Partner Login" Language="vb" AutoEventWireup="false" CodeBehind="DriverLogin.aspx.vb" Inherits="Cloud_Kitchen.DriverLogin" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Driver Partner Login - Cloud Kitchen</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet" />

    <style type="text/css">
        :root {
            --ck-primary: #4F7E76;
            --ck-primary-dark: #31544e;
            --ck-accent: #ff9f43;
            --ck-ink: #0f172a;
            --ck-muted: #64748b;
            --ck-radius: 24px;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Poppins', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
        }

        html, body {
            height: 100%;
            width: 100%;
            overflow: hidden;
            background: #0f172a;
            color: #ffffff;
        }

        #form1 {
            height: 100vh;
            width: 100%;
            position: relative;
        }

        /* ── FULL COVER BACKGROUND WITH OVERLAY ──────────────────────── */
        .full-bg-wrap {
            position: absolute;
            inset: 0;
            background: linear-gradient(135deg, rgba(15, 25, 35, 0.65) 0%, rgba(15, 25, 35, 0.85) 100%),
                        url('../Images/lb6.jpeg') center/cover no-repeat;
            z-index: 1;
        }

        /* ── MAIN 2-COLUMN GRID ───────────────────────────────────────── */
        .hero-layout {
            position: relative;
            z-index: 2;
            height: 100vh;
            width: 100%;
            display: grid;
            grid-template-columns: minmax(0, 1.1fr) minmax(380px, 460px);
            padding: clamp(24px, 5vw, 64px);
            align-items: center;
            gap: 32px;
        }

        /* ── LEFT SIDE: DELIVER FAST. EARN DAILY. ────────────────────── */
        .left-hero-content {
            color: #ffffff;
            max-width: 580px;
        }

        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 16px;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.12);
            border: 1px solid rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(12px);
            font-size: 0.78rem;
            font-weight: 800;
            letter-spacing: 1.2px;
            text-transform: uppercase;
            color: var(--ck-accent);
            margin-bottom: 20px;
        }

        .hero-title {
            font-size: clamp(2.4rem, 5vw, 3.8rem);
            font-weight: 800;
            line-height: 1.1;
            margin-bottom: 16px;
            letter-spacing: -0.8px;
            text-shadow: 0 4px 20px rgba(0, 0, 0, 0.4);
        }

        .hero-title span {
            color: var(--ck-accent);
        }

        .hero-desc {
            font-size: clamp(0.95rem, 1.5vw, 1.1rem);
            color: rgba(255, 255, 255, 0.88);
            line-height: 1.7;
            margin-bottom: 28px;
            font-weight: 400;
        }

        .hero-features {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        .feature-pill {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 16px;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.12);
            border: 1px solid rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(12px);
            color: #ffffff;
            font-size: 0.88rem;
            font-weight: 700;
        }

        .feature-pill i {
            color: var(--ck-accent);
        }

        /* ── RIGHT SIDE: FLOATING LOGIN CARD ABOVE IMAGE ──────────────── */
        .right-card-wrapper {
            display: flex;
            justify-content: center;
            width: 100%;
        }

        .login-card {
            width: 100%;
            background: #ffffff;
            border-radius: var(--ck-radius);
            padding: clamp(28px, 4vw, 38px);
            box-shadow: 0 30px 70px rgba(0, 0, 0, 0.45);
            border: 1px solid #ffffff;
            color: var(--ck-ink);
        }

        .brand-row {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 22px;
        }

        .brand-badge {
            width: 44px;
            height: 44px;
            background: linear-gradient(135deg, var(--ck-primary), var(--ck-primary-dark));
            color: #ffffff;
            border-radius: 13px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.3rem;
            box-shadow: 0 8px 18px rgba(79, 126, 118, 0.28);
        }

        .brand-text {
            font-size: 1.15rem;
            font-weight: 800;
            color: var(--ck-ink);
            letter-spacing: -0.3px;
        }

        .brand-tag {
            font-size: 0.7rem;
            font-weight: 700;
            color: var(--ck-primary);
            background: rgba(79, 126, 118, 0.12);
            padding: 3px 8px;
            border-radius: 6px;
            margin-left: auto;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .card-title {
            font-size: 1.6rem;
            font-weight: 800;
            color: var(--ck-ink);
            margin-bottom: 4px;
            letter-spacing: -0.3px;
        }

        .card-subtitle {
            font-size: 0.86rem;
            color: var(--ck-muted);
            margin-bottom: 22px;
            line-height: 1.5;
            font-weight: 500;
        }

        .alert-box {
            display: block;
            margin-bottom: 18px;
            font-size: 0.83rem;
            font-weight: 700;
            border-radius: 10px;
            padding: 10px 14px;
            background: rgba(227, 90, 60, 0.12);
            color: #d9381e;
            border: 1px solid rgba(227, 90, 60, 0.22);
            text-align: center;
        }

        .form-group {
            margin-bottom: 18px;
        }

        .field-label {
            display: block;
            font-size: 0.82rem;
            font-weight: 700;
            color: #334155;
            margin-bottom: 6px;
        }

        .input-wrapper {
            position: relative;
            display: flex;
            align-items: center;
        }

        .input-wrapper i {
            position: absolute;
            left: 14px;
            color: var(--ck-muted);
            font-size: 1rem;
            pointer-events: none;
            transition: color 0.2s;
        }

        .custom-input {
            width: 100% !important;
            height: 48px;
            padding: 0 14px 0 42px;
            border-radius: 12px;
            border: 1.5px solid rgba(15, 25, 35, 0.14);
            font-size: 0.92rem;
            font-family: inherit;
            color: var(--ck-ink);
            background: #ffffff;
            outline: none;
            transition: all 0.25s ease;
        }

        .custom-input:focus {
            border-color: var(--ck-primary);
            box-shadow: 0 0 0 4px rgba(79, 126, 118, 0.18);
        }

        .custom-input:focus + i {
            color: var(--ck-primary);
        }

        .submit-btn {
            width: 100%;
            height: 50px;
            background: linear-gradient(135deg, var(--ck-primary), var(--ck-primary-dark));
            color: #ffffff;
            font-size: 0.95rem;
            font-weight: 800;
            border: none;
            border-radius: 999px;
            cursor: pointer;
            box-shadow: 0 10px 24px rgba(79, 126, 118, 0.35);
            transition: transform 0.2s, box-shadow 0.2s;
            margin-top: 6px;
        }

        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 14px 30px rgba(79, 126, 118, 0.45);
        }

        .submit-btn:active {
            transform: translateY(0);
        }

        .trust-bar {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 6px;
            margin-top: 20px;
            padding-top: 16px;
            border-top: 1px solid rgba(15, 25, 35, 0.08);
            text-align: center;
        }

        .trust-cell {
            font-size: 0.72rem;
            font-weight: 700;
            color: var(--ck-muted);
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 3px;
        }

        .trust-cell i {
            font-size: 1.05rem;
            color: var(--ck-primary);
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 0.82rem;
            font-weight: 700;
            color: var(--ck-muted);
            text-decoration: none;
            margin-top: 18px;
            justify-content: center;
            width: 100%;
            transition: color 0.2s;
        }

        .back-link:hover {
            color: var(--ck-primary);
        }

        /* ── RESPONSIVE MEDIA QUERIES ───────────────────────────────── */
        @media (max-width: 991.98px) {
            html, body {
                overflow-y: auto;
            }
            #form1 {
                height: auto;
                min-height: 100vh;
            }
            .hero-layout {
                grid-template-columns: 1fr;
                height: auto;
                min-height: 100vh;
                padding: 32px 16px;
            }
            .left-hero-content {
                max-width: 100%;
                text-align: center;
            }
            .hero-badge, .hero-features {
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- FULL COVER BACKGROUND -->
        <div class="full-bg-wrap"></div>

        <!-- 2-COLUMN HERO LAYOUT ABOVE BACKGROUND -->
        <div class="hero-layout">

            <!-- LEFT SIDE: DELIVER FAST. EARN DAILY. -->
            <div class="left-hero-content">
                <div class="hero-badge">
                    <i class="bi bi-patch-check-fill"></i> Partner Network
                </div>
                <h1 class="hero-title">
                    Deliver Fast.<br />
                    <span>Earn Daily.</span>
                </h1>
                <p class="hero-desc">
                    Your dedicated Cloud Kitchen delivery companion. Accept dispatches, navigate with 1-tap Google Maps, and complete doorstep handoffs with OTP verification.
                </p>
                <div class="hero-features">
                    <div class="feature-pill"><i class="bi bi-compass"></i> GPS Routes</div>
                    <div class="feature-pill"><i class="bi bi-shield-lock"></i> Secure OTP</div>
                    <div class="feature-pill"><i class="bi bi-cash-stack"></i> Real-Time COD</div>
                </div>
            </div>

            <!-- RIGHT SIDE: FLOATING LOGIN CARD -->
            <div class="right-card-wrapper">
                <div class="login-card">
                    <div class="brand-row">
                        <div class="brand-badge"><i class="bi bi-scooter"></i></div>
                        <span class="brand-text">Cloud Kitchen</span>
                        <span class="brand-tag">Partner</span>
                    </div>

                    <h2 class="card-title">Partner Sign In</h2>
                    <p class="card-subtitle">Enter your credentials to access your delivery workspace.</p>

                    <asp:Label ID="lblMsg" runat="server" CssClass="alert-box" Visible="false"></asp:Label>

                    <div class="form-group">
                        <label class="field-label" for="txtPhone">Phone Number</label>
                        <div class="input-wrapper">
                            <asp:TextBox ID="txtPhone" runat="server" CssClass="custom-input" Placeholder="Enter 10-digit phone number" TextMode="Phone" MaxLength="10"></asp:TextBox>
                            <i class="bi bi-telephone"></i>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="field-label" for="txtPassword">Password</label>
                        <div class="input-wrapper">
                            <asp:TextBox ID="txtPassword" runat="server" CssClass="custom-input" TextMode="Password" Placeholder="Enter password"></asp:TextBox>
                            <i class="bi bi-lock"></i>
                        </div>
                    </div>

                    <asp:Button ID="btnLogin" runat="server" Text="Sign In to Dashboard" CssClass="submit-btn" OnClick="btnLogin_Click" />

                    <div class="trust-bar">
                        <div class="trust-cell">
                            <i class="bi bi-geo-alt"></i>
                            <span>1-Tap Maps</span>
                        </div>
                        <div class="trust-cell">
                            <i class="bi bi-shield-check"></i>
                            <span>OTP Verified</span>
                        </div>
                        <div class="trust-cell">
                            <i class="bi bi-cash-stack"></i>
                            <span>Live COD</span>
                        </div>
                    </div>

                    <a href="../Customers/Login.aspx" class="back-link">
                        <i class="bi bi-arrow-left"></i> Back to Customer Login
                    </a>
                </div>
            </div>

        </div>
    </form>
</body>
</html>