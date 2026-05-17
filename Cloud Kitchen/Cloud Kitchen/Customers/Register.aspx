<%@ Page Title="Register" Language="vb" AutoEventWireup="false" MasterPageFile="~/Customers/Customer.Master" CodeBehind="Register.aspx.vb" Inherits="Cloud_Kitchen.WebForm4" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet" />

    <style>
        :root {
            --primary:      #4F7E76;
            --primary-dk:   #3a5f59;
            --accent:       #ff9f43;
            --success:      #4caf50;
            --success-dk:   #3d8b40;
            --bg:           #f4f7f6;
            --form-bg:      #ffffff;
            --input-border: #dbe0e6;
            --input-focus:  rgba(79,126,118,.22);
            --text:         #333;
            --muted:        #6b7a8d;
        }

        body {
            font-family: 'Poppins', system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            background: var(--bg);
            color: var(--text);
        }

        .ck-reg-wrap {
            min-height: calc(100vh - 72px);
            display: flex;
        }

        .ck-img-panel {
            flex: 1.2;
            position: relative;
            background: linear-gradient(160deg, rgba(0,0,0,.45), rgba(0,0,0,.68)),
                        url('../Images/lb7.jpeg') center/cover no-repeat;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 3rem 2rem;
            overflow: hidden;
        }

        .ck-img-panel::after {
            content: '';
            position: absolute; inset: 0;
            background: linear-gradient(135deg, rgba(79,126,118,.25), transparent);
            pointer-events: none;
        }

        .ck-img-content {
            position: relative; z-index: 2;
            max-width: 480px;
            text-align: center;
            color: #fff;
            background: rgba(0,0,0,.22);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,.12);
            border-radius: 20px;
            padding: 2.5rem 2rem;
            animation: ck-slide-right .8s ease both;
        }

        .ck-img-content .brand-badge { font-size: 2.8rem; display: block; margin-bottom: 1rem; }

        .ck-img-content h2 {
            font-family: 'Poppins', system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            font-size: clamp(1.8rem, 2.2vw, 2.5rem);
            font-weight: 700;
            margin-bottom: .8rem;
            text-shadow: 0 2px 12px rgba(0,0,0,.4);
        }

        .ck-img-content p {
            font-size: clamp(.88rem, 1.4vw, 1.05rem);
            font-weight: 300;
            opacity: .88;
            line-height: 1.75;
            margin: 0;
        }

        .ck-perks {
            list-style: none;
            padding: 0; margin: 1.4rem 0 0;
            text-align: left;
        }
        .ck-perks li {
            display: flex; align-items: center; gap: 10px;
            font-size: .88rem; opacity: .9;
            margin-bottom: 8px;
        }
        .ck-perks li span.perk-icon { font-size: 1rem; }

        .ck-form-panel {
            flex: 1;
            display: flex;
            align-items: flex-start;
            justify-content: center;
            padding: 3rem 1.5rem;
            background: var(--form-bg);
            overflow-y: auto;
        }

        .ck-card {
            width: 100%;
            max-width: 460px;
            padding: 1rem 0;
            animation: ck-fade-up .75s .1s ease both;
        }

        .ck-card-header {
            text-align: center;
            margin-bottom: 1.8rem;
        }

        .ck-card-header h2 {
            font-family: 'Poppins', system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            font-size: 1.9rem;
            color: var(--primary);
            margin: 0 0 .3rem;
        }

        .ck-card-header p {
            font-size: .88rem;
            color: var(--muted);
            margin: 0;
        }

        .ck-divider {
            height: 3px;
            background: linear-gradient(to right, var(--primary), var(--accent));
            border: none;
            border-radius: 2px;
            margin: 1.5rem 0 1.8rem;
        }

        /* ─── Inputs ─── */
        .ck-label {
            display: block;
            font-weight: 500;
            font-size: .88rem;
            color: #3a4a5b;
            margin-bottom: .42rem;
        }

        .ck-input {
            width: 100%;
            padding: .72rem 1rem;
            border: 1.5px solid var(--input-border);
            border-radius: 10px;
            font-family: 'DM Sans', sans-serif;
            font-size: .95rem;
            background: #fafbfc;
            transition: border-color .25s, box-shadow .25s, background .25s;
            outline: none;
            box-sizing: border-box;
        }

        .ck-input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 4px var(--input-focus);
            background: #fff;
        }

        .ck-phone-row {
            display: flex;
            gap: 10px;
        }

        .ck-country-code {
            width: 72px;
            flex-shrink: 0;
            text-align: center;
            background: #f0f2f5;
            color: #455a64;
            font-weight: 600;
            cursor: default;
        }

        .ck-phone-row .ck-input:last-child { flex: 1; }

        .pw-wrap { position: relative; }
        .pw-wrap .ck-input { padding-right: 3rem; }

        .pw-toggle {
            position: absolute;
            right: 12px; top: 50%;
            transform: translateY(-50%);
            background: none; border: none;
            cursor: pointer;
            font-size: 1.05rem;
            color: var(--muted);
            padding: .2rem;
            line-height: 1;
            transition: color .2s;
        }
        .pw-toggle:hover { color: var(--primary); }

        .pw-strength-bar {
            height: 4px;
            border-radius: 2px;
            margin-top: 7px;
            background: #e0e0e0;
            overflow: hidden;
        }
        .pw-strength-fill {
            height: 100%;
            width: 0;
            border-radius: 2px;
            transition: width .4s, background .4s;
        }
        .pw-strength-label {
            font-size: .75rem;
            color: var(--muted);
            margin-top: 3px;
        }

        .field-error {
            display: block;
            font-size: .78rem;
            color: #e35a3c;
            margin-top: .3rem;
        }

        .ck-reg-btn {
            width: 100%;
            padding: .85rem;
            font-family: 'DM Sans', sans-serif;
            font-size: 1rem;
            font-weight: 600;
            color: #fff;
            background: linear-gradient(135deg, var(--primary), var(--primary-dk));
            border: none;
            border-radius: 50px;
            cursor: pointer;
            margin-top: .6rem;
            box-shadow: 0 5px 18px rgba(79,126,118,.35);
            transition: transform .2s, box-shadow .2s;
        }
        .ck-reg-btn:hover { transform: translateY(-2px); box-shadow: 0 8px 24px rgba(79,126,118,.45); }
        .ck-reg-btn:active { transform: translateY(0); }

        .ck-switch {
            text-align: center;
            font-size: .88rem;
            color: var(--muted);
            margin-top: 1.3rem;
        }
        .ck-switch a {
            color: var(--primary);
            font-weight: 600;
            text-decoration: none;
            transition: color .2s;
        }
        .ck-switch a:hover { color: var(--primary-dk); text-decoration: underline; }


        #ck-modal-root {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,.68);
            backdrop-filter: blur(7px);
            -webkit-backdrop-filter: blur(7px);
            z-index: 9999;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1.5rem;
            box-sizing: border-box;
            animation: ck-fade-in .25s ease both;
            margin-top: 0 !important;
        }

#ck-modal-root > div {
    background: #fff;
    border-radius: 22px;
    padding: 2.8rem 2.4rem 2.4rem;
    text-align: center;
    width: 100%;
    max-width: 460px;
    max-height: 90vh;
    overflow-y: auto;
    box-shadow: 0 28px 70px rgba(0,0,0,.32);
    animation: ck-pop-in .48s cubic-bezier(.34,1.56,.64,1) both;
    box-sizing: border-box;

    position: relative;
    transform: none !important;
    margin: auto;
}

        #ck-modal-root .ck-success-icon {
            font-size: 3.8rem;
            display: block;
            margin-bottom: .9rem;
            animation: ck-bounce 1.1s ease infinite alternate;
        }

        #ck-modal-root .ck-success-title {
            font-family: 'Playfair Display', serif;
            color: #4caf50;
            font-size: 1.75rem;
            margin: 0 0 .55rem;
        }

        #ck-modal-root .ck-success-msg {
            font-weight: 600;
            color: #333;
            font-size: 1rem;
            margin-bottom: .45rem;
        }

        #ck-modal-root .ck-success-sub {
            color: #666;
            font-size: .9rem;
            line-height: 1.7;
            margin-bottom: 1.8rem;
        }

        #ck-modal-root .ck-modal-btn {
            display: inline-block;
            padding: .82rem 2.4rem;
            font-family: 'DM Sans', sans-serif;
            font-size: .97rem;
            font-weight: 600;
            color: #fff !important;
            background: linear-gradient(135deg, #4F7E76, #3a5f59);
            border: none;
            border-radius: 50px;
            cursor: pointer;
            text-decoration: none;
            box-shadow: 0 5px 18px rgba(79,126,118,.38);
            transition: transform .2s, box-shadow .2s;
        }
        #ck-modal-root .ck-modal-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 26px rgba(79,126,118,.5);
        }

        /* ─── Animations ─── */
        @keyframes ck-fade-up {
            from { opacity: 0; transform: translateY(24px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        @keyframes ck-slide-right {
            from { opacity: 0; transform: translateX(-30px); }
            to   { opacity: 1; transform: translateX(0); }
        }
        @keyframes ck-fade-in {
            from { opacity: 0; }
            to   { opacity: 1; }
        }
@keyframes ck-pop-in {
    from {
        opacity: 0;
        transform: scale(.85);
    }

    to {
        opacity: 1;
        transform: scale(1);
    }
}
#ContentPlaceHolder1_pnlmsg {
    display: block !important;
    width: 100%;
    max-width: 460px;
}
        @keyframes ck-bounce {
            from { transform: translateY(0); }
            to   { transform: translateY(-10px); }
        }

        @media (max-width: 991px) {
            .ck-reg-wrap { flex-direction: column; }
            .ck-img-panel { flex: none; min-height: 280px; padding: 2.5rem 1.5rem; }
            .ck-form-panel { padding: 2.5rem 1.5rem 3.5rem; align-items: flex-start; }
        }

        @media (max-width: 575px) {
            .ck-img-panel { min-height: 220px; }
            .ck-img-content { padding: 1.4rem 1.1rem; }
            .ck-perks { display: none; }
            .ck-card-header h2 { font-size: 1.55rem; }
            .ck-success-card { padding: 1.8rem 1.4rem; }
        }
    </style>

    <script>
        function togglePassword() {
            var f = document.getElementById('<%= txtPassword.ClientID %>');
            var i = document.getElementById('eyeIcon');
            if (f.type === 'password') { f.type = 'text'; i.textContent = '🙈'; }
            else { f.type = 'password'; i.textContent = '👁️'; }
        }

        document.addEventListener('DOMContentLoaded', function () {
            var pw = document.getElementById('<%= txtPassword.ClientID %>');
            var fill = document.getElementById('pwStrengthFill');
            var lbl = document.getElementById('pwStrengthLabel');
            if (!pw || !fill) return;

            pw.addEventListener('input', function () {
                var v = pw.value;
                var score = 0;
                if (v.length >= 6) score++;
                if (/[A-Z]/.test(v)) score++;
                if (/[a-z]/.test(v)) score++;
                if (/\d/.test(v)) score++;
                if (/[@$!%#*?&]/.test(v)) score++;

                var pct = (score / 5) * 100;
                var colors = ['#e74c3c', '#e67e22', '#f1c40f', '#2ecc71', '#27ae60'];
                var labels = ['Very weak', 'Weak', 'Fair', 'Strong', 'Very strong'];

                fill.style.width = pct + '%';
                fill.style.background = colors[score - 1] || '#e0e0e0';
                lbl.textContent = score > 0 ? labels[score - 1] : '';
            });
        });
    </script>

</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:ScriptManager ID="ScriptManager2" runat="server"></asp:ScriptManager>

    <div id="overlay" runat="server" style="display:none;"></div>

    <asp:Panel ID="pnlmsg" runat="server" Visible="false" style="display:none;">
        <div class="ck-success-card">
            <span class="ck-success-icon">&#127881;</span>
            <h2 class="ck-success-title">Registration Successful!</h2>
            <asp:Label ID="lblmsg1" runat="server" CssClass="ck-success-msg d-block"></asp:Label>
            <p class="ck-success-sub">
                Welcome to the Cloud Kitchen community! Your account is ready &#8212;
                log in now to explore the menu and place your first order.
            </p>
            <a href="Login.aspx" class="ck-modal-btn">
    Sign In Now
</a>
        </div>
    </asp:Panel>

    <div class="ck-reg-wrap">

        <div class="ck-img-panel d-none d-md-flex">
            <div class="ck-img-content">
                <span class="brand-badge">🍽️</span>
                <h2>Join Our Cloud Kitchen</h2>
                <p>Create your account today and discover chef-crafted meals delivered fresh to your door.</p>
                <ul class="ck-perks">
                    <li><span class="perk-icon">✅</span> Free delivery on first order</li>
                    <li><span class="perk-icon">✅</span> Exclusive member discounts</li>
                    <li><span class="perk-icon">✅</span> Real-time order tracking</li>
                    <li><span class="perk-icon">✅</span> New dishes added weekly</li>
                </ul>
            </div>
        </div>

        <div class="ck-form-panel">
            <div class="ck-card">

                <div class="ck-card-header">
                    <div class="d-md-none mb-2" style="font-size:2rem;">🍽️</div>
                    <h2>Create Account</h2>
                    <p>It's free and takes less than a minute!</p>
                </div>

                <hr class="ck-divider" />

                <asp:Label ID="lblmsg" runat="server" Text=""
                    ForeColor="#E35A3C"
                    CssClass="d-block mb-3 fw-semibold text-center"
                    style="font-size:.9rem;"></asp:Label>

                <div class="mb-3">
                    <label class="ck-label">Full Name</label>
                    <asp:TextBox ID="txtFullName" runat="server"
                        placeholder="Enter your full name"
                        CssClass="ck-input"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvFullName" runat="server"
                        ControlToValidate="txtFullName"
                        ErrorMessage="Full name is required."
                        CssClass="field-error" Display="Dynamic" ForeColor="#E35A3C" />
                </div>

                <div class="mb-3">
                    <label class="ck-label">Email Address</label>
                    <asp:TextBox ID="txtEmail" runat="server"
                        placeholder="you@example.com"
                        AutoPostBack="true"
                        CssClass="ck-input"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                        ControlToValidate="txtEmail"
                        ErrorMessage="Email is required."
                        CssClass="field-error" Display="Dynamic" ForeColor="#E35A3C" />
                    <asp:RegularExpressionValidator ID="revEmail" runat="server"
                        ControlToValidate="txtEmail"
                        ErrorMessage="Please enter a valid email address."
                        ValidationExpression="^\S+@\S+\.\S+$"
                        CssClass="field-error" Display="Dynamic" ForeColor="#E35A3C" />
                    <asp:Label ID="lblEmailError" runat="server"
                        ForeColor="#E35A3C" CssClass="field-error"></asp:Label>
                </div>

                <div class="mb-3">
                    <label class="ck-label">Mobile Number</label>
                    <div class="ck-phone-row">
                        <asp:TextBox ID="txtCountryCode" runat="server"
                            Text="+91" ReadOnly="true"
                            CssClass="ck-input ck-country-code"></asp:TextBox>
                        <asp:TextBox ID="txtPhone" runat="server"
                            placeholder="10-digit mobile number"
                            AutoPostBack="true" MaxLength="10" TextMode="Number"
                            CssClass="ck-input"></asp:TextBox>
                    </div>
                    <asp:RequiredFieldValidator ID="rfvPhone" runat="server"
                        ControlToValidate="txtPhone"
                        ErrorMessage="Mobile number is required."
                        CssClass="field-error" Display="Dynamic" ForeColor="#E35A3C" />
                    <asp:Label ID="lblPhoneError" runat="server"
                        ForeColor="#E35A3C" CssClass="field-error"></asp:Label>
                </div>

                <div class="mb-3">
                    <label class="ck-label">Password</label>
                    <div class="pw-wrap">
                        <asp:TextBox ID="txtPassword" runat="server"
                            TextMode="Password"
                            placeholder="Create a strong password"
                            CssClass="ck-input"></asp:TextBox>
                        <button type="button" class="pw-toggle" onclick="togglePassword()" id="eyeIcon"
                            title="Show / hide password">👁️</button>
                    </div>
                    <div class="pw-strength-bar">
                        <div class="pw-strength-fill" id="pwStrengthFill"></div>
                    </div>
                    <div class="pw-strength-label" id="pwStrengthLabel"></div>

                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                        ControlToValidate="txtPassword"
                        ErrorMessage="Password is required."
                        CssClass="field-error" Display="Dynamic" ForeColor="#E35A3C" />
                    <asp:RegularExpressionValidator ID="revPassword" runat="server"
                        ControlToValidate="txtPassword"
                        ErrorMessage="Min 6 chars, include uppercase, lowercase, digit &amp; special character."
                        ValidationExpression="^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%#*?&amp;])[A-Za-z\d@$!%#*?&amp;]{6,}$"
                        CssClass="field-error" Display="Dynamic" ForeColor="#E35A3C" />
                </div>

                <asp:Button ID="btnRegister" runat="server"
                    Text="Create My Account"
                    CssClass="ck-reg-btn"
                    CausesValidation="False"
                    AutoPostBack="true" />

                <p class="ck-switch">
                    Already have an account?
                    <a href="Login.aspx">Sign in here</a>
                </p>

            </div>
        </div>

    </div>

    <script>

       
            (function () {

        var panel = document.getElementById('ContentPlaceHolder1_pnlmsg');
            if (!panel) return;

            panel.style.display = 'block';

            var root = document.createElement('div');
            root.id = 'ck-modal-root';

            root.appendChild(panel);

            document.body.appendChild(root);

    })();
    </script>

</asp:Content>
