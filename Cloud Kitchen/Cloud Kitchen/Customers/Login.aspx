<%@ Page Title="Login" Language="vb" AutoEventWireup="false" MasterPageFile="~/Customers/Customer.Master" CodeBehind="Login.aspx.vb" Inherits="Cloud_Kitchen.WebForm3" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@600;700&family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet" />

    <style>
        :root {
            --login-primary: #4F7E76;
            --login-primary-dark: #31544e;
            --login-accent: #ff9f43;
            --login-bg: #fffaf3;
            --login-card: rgba(255, 255, 255, 0.86);
            --login-line: rgba(15, 25, 35, 0.1);
            --login-input: #f8fafc;
            --login-focus: rgba(79, 126, 118, 0.2);
            --login-ink: #101923;
            --login-muted: #687382;
            --login-danger: #e35a3c;
            --login-shadow: 0 24px 70px rgba(15, 25, 35, 0.14);
            --login-radius: 26px;
        }

        body {
            font-family: 'Poppins', system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
        }

        .ck-login-wrap {
            min-height: calc(100vh - var(--ck-nav-h, 78px));
            display: grid;
            grid-template-columns: minmax(0, 1.08fr) minmax(420px, 0.92fr);
            background:
                radial-gradient(circle at 12% 10%, rgba(255, 159, 67, 0.22), transparent 24rem),
                radial-gradient(circle at 80% 12%, rgba(79, 126, 118, 0.18), transparent 28rem),
                linear-gradient(135deg, #fffaf3 0%, #f7fbf8 54%, #ffffff 100%);
        }

        .ck-image-panel {
            position: relative;
            min-height: 720px;
            display: flex;
            align-items: stretch;
            padding: clamp(24px, 4vw, 48px);
            overflow: hidden;
        }

        .ck-hero-media {
            position: absolute;
            inset: 0;
            background:
                linear-gradient(135deg, rgba(15, 25, 35, 0.34), rgba(15, 25, 35, 0.72)),
                url('../Images/lb5.jpeg') center/cover no-repeat;
            transform: scale(1.02);
        }

        .ck-hero-media::after {
            content: '';
            position: absolute;
            inset: 0;
            background:
                linear-gradient(90deg, rgba(15, 25, 35, 0.18), transparent 55%),
                radial-gradient(circle at 22% 22%, rgba(255, 159, 67, 0.32), transparent 18rem);
        }

        .ck-image-content {
            position: relative;
            z-index: 2;
            width: min(100%, 560px);
            margin-top: auto;
            margin-bottom: clamp(42px, 8vh, 92px);
            color: #ffffff;
            animation: ck-slide-right 0.75s ease both;
        }

        .eyebrow {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 12px;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.13);
            border: 1px solid rgba(255, 255, 255, 0.18);
            backdrop-filter: blur(12px);
            font-size: 0.78rem;
            font-weight: 800;
            letter-spacing: 1px;
            text-transform: uppercase;
            margin-bottom: 18px;
        }

        .ck-image-content h2 {
            font-family: 'Poppins', system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            font-size: clamp(2.6rem, 6vw, 5.4rem);
            font-weight: 700;
            line-height: 0.96;
            margin: 0 0 20px;
            text-shadow: 0 16px 42px rgba(0, 0, 0, 0.38);
            max-width: 9ch;
        }

        .ck-image-content p {
            font-size: clamp(1rem, 1.8vw, 1.16rem);
            font-weight: 500;
            opacity: 0.9;
            line-height: 1.7;
            margin: 0;
            max-width: 34rem;
        }

        .hero-chips {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            margin-top: 28px;
        }

        .hero-chip {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 14px;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.14);
            border: 1px solid rgba(255, 255, 255, 0.18);
            backdrop-filter: blur(12px);
            color: rgba(255, 255, 255, 0.92);
            font-size: 0.9rem;
            font-weight: 700;
        }

        .ck-form-panel {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: clamp(24px, 5vw, 64px);
            position: relative;
        }

        .ck-form-panel::before {
            content: '';
            position: absolute;
            width: min(38vw, 360px);
            aspect-ratio: 1;
            border-radius: 50%;
            background: rgba(79, 126, 118, 0.12);
            top: 10%;
            right: 8%;
            filter: blur(10px);
        }

        .ck-card {
            position: relative;
            z-index: 1;
            width: min(100%, 470px);
            padding: clamp(24px, 4vw, 38px);
            border-radius: var(--login-radius);
            background: var(--login-card);
            border: 1px solid rgba(255, 255, 255, 0.72);
            box-shadow: var(--login-shadow);
            backdrop-filter: blur(20px);
            animation: ck-fade-up 0.75s 0.08s ease both;
        }

        .mobile-brand {
            display: none;
            width: 54px;
            height: 54px;
            margin: 0 auto 14px;
            align-items: center;
            justify-content: center;
            border-radius: 18px;
            color: #ffffff;
            background: linear-gradient(135deg, var(--login-primary), var(--login-accent));
            box-shadow: 0 12px 28px rgba(255, 159, 67, 0.24);
            font-size: 1.45rem;
        }

        .ck-card-header {
            text-align: center;
            margin-bottom: 22px;
        }

        .ck-card-header h2 {
            font-family: 'Poppins', system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
/*            font-family: 'Cormorant Garamond', Georgia, serif;*/
            font-size: clamp(1.9rem, 5vw, 2.45rem);
            color: var(--login-ink);
/*            margin: 0 0 3px;*/
/*            line-height: 1.08;*/
        }

        .ck-card-header p {
            font-size: 0.95rem;
            color: var(--login-muted);
            margin: 0;
        }

        .ck-divider {
            height: 1px;
            background: linear-gradient(to right, transparent, rgba(79, 126, 118, 0.34), transparent);
            border: none;
            margin: 22px 0;
        }

        .ck-label {
            display: block;
            font-weight: 800;
            font-size: 0.84rem;
            color: #334155;
            margin-bottom: 8px;
        }

        .input-shell {
            position: relative;
        }

        .input-shell > i {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--login-muted);
            font-size: 1rem;
            pointer-events: none;
        }

        .ck-input {
            width: 100% !important;
            min-height: 50px;
            padding: 0.82rem 1rem 0.82rem 2.75rem;
            border: 1.5px solid var(--login-line);
            border-radius: 15px;
            font-family: 'Poppins', sans-serif;
            font-size: 0.96rem;
            background: var(--login-input);
            transition: border-color 0.25s, box-shadow 0.25s, background 0.25s;
            outline: none;
            box-sizing: border-box;
            color: var(--login-ink);
        }

        .ck-input:focus {
            border-color: var(--login-primary);
            box-shadow: 0 0 0 5px var(--login-focus);
            background: #ffffff;
        }

        .pw-wrap .ck-input {
            padding-right: 3.25rem;
        }

        .pw-toggle {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            width: 38px;
            height: 38px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: transparent;
            border: none;
            border-radius: 12px;
            cursor: pointer;
            font-size: 1.05rem;
            color: var(--login-muted);
            transition: color 0.2s, background 0.2s;
        }

        .pw-toggle:hover {
            color: var(--login-primary);
            background: rgba(79, 126, 118, 0.1);
        }

        .field-error {
            display: block;
            font-size: 0.78rem;
            color: var(--login-danger);
            margin-top: 6px;
            font-weight: 700;
        }

        .login-message {
            min-height: 22px;
            display: block;
            margin-bottom: 14px;
            color: var(--login-danger);
            font-size: 0.9rem;
            font-weight: 800;
            text-align: center;
            overflow-wrap: anywhere;
        }

        .ck-remember-row {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 8px 0 4px;
            flex-wrap: wrap;
        }

        .ck-remember {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 0.9rem;
            color: var(--login-muted);
            margin: 0;
        }

        .ck-remember input[type="checkbox"] {
            accent-color: var(--login-primary);
            width: 16px;
            height: 16px;
            cursor: pointer;
        }

        .ck-login-btn {
            width: 100%;
            min-height: 52px;
            padding: 0.9rem;
            font-family: 'Poppins', sans-serif;
            font-size: 1rem;
            font-weight: 900;
            color: #ffffff;
            background: linear-gradient(135deg, var(--login-primary), var(--login-primary-dark));
            border: none;
            border-radius: 999px;
            cursor: pointer;
            margin-top: 18px;
            box-shadow: 0 14px 30px rgba(79, 126, 118, 0.32);
            transition: transform 0.2s, box-shadow 0.2s, background 0.2s;
        }

        .ck-login-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 18px 38px rgba(79, 126, 118, 0.42);
        }

        .ck-login-btn:active {
            transform: translateY(0);
        }

        .ck-switch {
            text-align: center;
            font-size: 0.92rem;
            color: var(--login-muted);
            margin: 20px 0 0;
        }

        .ck-switch a {
            color: var(--login-primary);
            font-weight: 900;
            text-decoration: none;
        }

        .ck-switch a:hover {
            color: var(--login-primary-dark);
            text-decoration: underline;
        }

        .trust-row {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 10px;
            margin-top: 22px;
            padding-top: 18px;
            border-top: 1px solid var(--login-line);
        }

        .trust-item {
            text-align: center;
            color: var(--login-muted);
            font-size: 0.75rem;
            font-weight: 800;
            line-height: 1.3;
        }

        .trust-item i {
            display: block;
            color: var(--login-primary);
            font-size: 1.05rem;
            margin-bottom: 4px;
        }

        @keyframes ck-fade-up {
            from { opacity: 0; transform: translateY(24px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes ck-slide-right {
            from { opacity: 0; transform: translateX(-30px); }
            to { opacity: 1; transform: translateX(0); }
        }

        @media (max-width: 991.98px) {
            .ck-login-wrap {
                grid-template-columns: 1fr;
            }

            .ck-image-panel {
                min-height: 420px;
            }

            .ck-image-content {
                width: min(100%, 620px);
            }

            .ck-image-content h2 {
                max-width: 14ch;
            }

            .ck-form-panel {
                padding-top: 42px;
            }
        }

        @media (max-width: 767.98px) {
            .ck-login-wrap {
                min-height: calc(100vh - var(--ck-nav-h, 70px));
                background:
                    radial-gradient(circle at top, rgba(255, 159, 67, 0.2), transparent 20rem),
                    linear-gradient(180deg, #fffaf3, #ffffff);
            }

            .ck-image-panel {
                display: none;
            }

            .ck-form-panel {
                min-height: calc(100vh - var(--ck-nav-h, 70px));
                padding: 28px 16px;
                align-items: flex-start;
            }

            .mobile-brand {
                display: inline-flex;
            }

            .ck-card {
                margin: 0 auto;
            }
        }

        @media (max-width: 480px) {
            .ck-card {
                padding: 22px 16px;
                border-radius: 20px;
            }

            .ck-remember-row {
                align-items: flex-start;
                flex-direction: column;
            }

            .trust-row {
                grid-template-columns: 1fr;
            }
        }

        @media (prefers-reduced-motion: reduce) {
            *,
            *::before,
            *::after {
                animation-duration: 0.01ms !important;
                animation-iteration-count: 1 !important;
                scroll-behavior: auto !important;
                transition-duration: 0.01ms !important;
            }
        }
    </style>

    <script>
        function togglePassword() {
            var field = document.getElementById('<%= txtLoginPass.ClientID %>');
            var icon = document.getElementById('eyeIcon');
            if (!field || !icon) return;

            if (field.type === 'password') {
                field.type = 'text';
                icon.className = 'bi bi-eye-slash';
            } else {
                field.type = 'password';
                icon.className = 'bi bi-eye';
            }
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="ck-login-wrap">
        <section class="ck-image-panel" aria-label="Cloud Kitchen welcome">
            <div class="ck-hero-media"></div>
            <div class="ck-image-content">
                <div class="eyebrow"><i class="bi bi-stars"></i> Fresh from our kitchen</div>
                <h2>Welcome back.</h2>
                <p>Sign in to continue ordering freshly prepared meals, track your cart, and revisit your favorite dishes anytime.</p>
                <div class="hero-chips">
                    <span class="hero-chip"><i class="bi bi-shield-check"></i> Secure login</span>
                    <span class="hero-chip"><i class="bi bi-truck"></i> Fast delivery</span>
                    <span class="hero-chip"><i class="bi bi-heart"></i> Made with care</span>
                </div>
            </div>
        </section>

        <section class="ck-form-panel">
            <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

            <asp:UpdatePanel ID="upnlLogin" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <div class="ck-card">
                        <div class="ck-card-header">
                            <div class="mobile-brand"><i class="bi bi-egg-fried"></i></div>
                            <h2>Account Login</h2>
                            <p>Good to see you again. Let’s get you back to your meal.</p>
                        </div>

                        <hr class="ck-divider" />

                        <asp:Label ID="lblmsg" runat="server" ForeColor="#E35A3C"
                            CssClass="login-message"></asp:Label>

                        <div class="mb-3">
                            <label class="ck-label" for="<%= txtLoginEmail.ClientID %>">Email Address</label>
                            <div class="input-shell">
                                <i class="bi bi-envelope"></i>
                                <asp:TextBox ID="txtLoginEmail" runat="server"
                                    placeholder="you@example.com"
                                    autocomplete="email"
                                    CssClass="ck-input"></asp:TextBox>
                            </div>
                            <asp:RequiredFieldValidator ID="rfvLoginEmail" runat="server"
                                ControlToValidate="txtLoginEmail"
                                ErrorMessage="Email is required."
                                CssClass="field-error" Display="Dynamic" ForeColor="#E35A3C" />
                            <asp:RegularExpressionValidator ID="revLoginEmail" runat="server"
                                ControlToValidate="txtLoginEmail"
                                ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                                ErrorMessage="Please enter a valid email."
                                CssClass="field-error" Display="Dynamic" ForeColor="#E35A3C" />
                        </div>

                        <div class="mb-3">
                            <label class="ck-label" for="<%= txtLoginPass.ClientID %>">Password</label>
                            <div class="input-shell pw-wrap">
                                <i class="bi bi-lock"></i>
                                <asp:TextBox ID="txtLoginPass" runat="server"
                                    TextMode="Password"
                                    placeholder="Enter your password"
                                    autocomplete="current-password"
                                    CssClass="ck-input"></asp:TextBox>
                                <button type="button" class="pw-toggle" onclick="togglePassword()" title="Show or hide password" aria-label="Show or hide password">
                                    <i id="eyeIcon" class="bi bi-eye"></i>
                                </button>
                            </div>
                            <asp:RequiredFieldValidator ID="rfvLoginPass" runat="server"
                                ControlToValidate="txtLoginPass"
                                ErrorMessage="Password is required."
                                CssClass="field-error" Display="Dynamic" ForeColor="#E35A3C" />
                        </div>

                        <div class="ck-remember-row">
                            <div class="ck-remember">
                                <asp:CheckBox ID="chkRememberMe" runat="server" />
                                <label for="<%= chkRememberMe.ClientID %>">Remember me</label>
                            </div>
                        </div>

                        <asp:Button ID="btnLogin" runat="server" Text="Sign In"
                            CssClass="ck-login-btn" OnClick="btnLogin_Click" />

                        <p class="ck-switch">
                            Don't have an account?
                            <a href="Register.aspx">Create one now</a>
                        </p>

                        <div class="trust-row">
                            <div class="trust-item"><i class="bi bi-shield-lock"></i>Protected</div>
                            <div class="trust-item"><i class="bi bi-clock-history"></i>Quick access</div>
                            <div class="trust-item"><i class="bi bi-bag-heart"></i>Easy ordering</div>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </section>
    </div>
</asp:Content>
