<%@ Page Title="Driver Partner App" Language="vb" AutoEventWireup="false" CodeBehind="DriverPortal.aspx.vb" Inherits="Cloud_Kitchen.DriverPortal" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Driver Delivery Partner - Cloud Kitchen</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <!-- Google Fonts & FontAwesome 6 Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

    <style type="text/css">
        :root {
            --primary: #4F7E76;
            --primary-dk: #31544e;
            --accent: #ff9f43;
            --accent-dk: #e8872a;
            --success: #16a34a;
            --danger: #dc2626;
            --bg: #f8fafc;
            --card-bg: #ffffff;
            --text: #0f172a;
            --muted: #64748b;
            --border: #e2e8f0;
            --nav-h: 62px;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Poppins', system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            background: var(--bg);
            color: var(--text);
            min-height: 100vh;
            padding-top: var(--nav-h);
            padding-bottom: 50px;
        }

        /* ── LIGHTWEIGHT MOBILE NAVBAR ──────────────────────────────────────── */
        .ck-navbar {
            position: fixed;
            top: 0; left: 0; right: 0;
            z-index: 1050;
            height: var(--nav-h);
            background: #0f172a;
            color: #ffffff;
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
            box-shadow: 0 4px 16px rgba(15, 23, 42, 0.15);
        }

        .ck-nav-inner {
            width: min(100% - 24px, 1200px);
            height: 100%;
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .ck-brand {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            color: #ffffff;
            text-decoration: none;
            font-weight: 800;
            font-size: 1.1rem;
            white-space: nowrap;
        }

        .ck-brand-mark {
            width: 34px; height: 34px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 10px;
            background: linear-gradient(135deg, var(--primary), var(--accent));
            color: #ffffff;
            font-size: 1rem;
        }

        .ck-brand-text {
            display: inline-flex;
            flex-direction: column;
            line-height: 1.1;
        }

        .ck-brand-kicker {
            color: rgba(255, 255, 255, 0.55);
            font-size: 0.62rem;
            font-weight: 700;
            letter-spacing: 0.8px;
            text-transform: uppercase;
        }

        .nav-right {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .nav-driver-info {
            text-align: right;
            margin-right: 4px;
        }

        .nav-driver-name {
            font-size: 0.82rem;
            font-weight: 700;
            color: rgba(255, 255, 255, 0.95);
        }

        .nav-vehicle {
            font-size: 0.7rem;
            color: rgba(255, 255, 255, 0.6);
            font-weight: 600;
        }

        .status-badge {
            font-size: 10px;
            font-weight: 800;
            padding: 4px 10px;
            border-radius: 20px;
            letter-spacing: 0.3px;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            text-transform: uppercase;
        }

        .status-available { background: rgba(22, 163, 74, 0.2); color: #4ade80; border: 1px solid rgba(22, 163, 74, 0.4); }
        .status-ondelivery { background: rgba(255, 159, 67, 0.2); color: #ffb86c; border: 1px solid rgba(255, 159, 67, 0.4); }
        .status-offline   { background: rgba(239, 68, 68, 0.2);  color: #fca5a5; border: 1px solid rgba(239, 68, 68, 0.4); }

        .btn-duty-toggle {
            padding: 5px 11px;
            font-size: 11px;
            font-weight: 700;
            border-radius: 16px;
            border: none;
            cursor: pointer;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .btn-duty-online { background: #2563eb; color: #ffffff; }
        .btn-duty-online:hover { background: #1d4ed8; }

        .btn-duty-offline { background: #dc2626; color: #ffffff; }
        .btn-duty-offline:hover { background: #b91c1c; }

        .btn-logout {
            font-size: 0.78rem;
            font-weight: 700;
            color: rgba(255, 255, 255, 0.85);
            background: rgba(255, 255, 255, 0.1);
            padding: 5px 10px;
            border-radius: 16px;
            text-decoration: none;
            border: 1px solid rgba(255, 255, 255, 0.15);
            cursor: pointer;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .btn-logout:hover {
            background: rgba(239, 68, 68, 0.25);
            color: #fca5a5;
        }

        /* ── MAIN CONTAINER ─────────────────────────────────────────────────── */
        .ck-container {
            width: min(100% - 24px, 1200px);
            margin: 0 auto;
            padding-top: 14px;
        }

        /* ── COMPACT MOBILE STRIP HEADER ────────────────────────────────────── */
        .driver-mobile-welcome {
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: #ffffff;
            border-radius: 12px;
            padding: 10px 14px;
            margin-bottom: 14px;
            border: 1px solid var(--border);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.03);
            flex-wrap: wrap;
            gap: 8px;
        }

        .driver-mobile-welcome .welcome-text {
            font-size: 0.9rem;
            font-weight: 700;
            color: var(--text);
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .btn-support-pill {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            background: #eff6ff;
            color: #2563eb;
            border: 1px solid #bfdbfe;
            font-size: 0.76rem;
            font-weight: 700;
            padding: 5px 12px;
            border-radius: 20px;
            text-decoration: none;
        }

        /* ── LIGHTWEIGHT 2X2 COMPACT MICRO STAT PILLS ────────────────────── */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 12px;
            margin-bottom: 18px;
        }

        .stat-card {
            background: #ffffff;
            border-radius: 12px;
            padding: 10px 12px;
            border: 1px solid var(--border);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.02);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .stat-icon-box {
            width: 36px; height: 36px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.05rem;
            flex-shrink: 0;
        }

        .stat-icon-active { background: rgba(79, 126, 118, 0.12); color: var(--primary); }
        .stat-icon-done   { background: rgba(22, 163, 74, 0.12);  color: var(--success); }
        .stat-icon-cash   { background: rgba(255, 159, 67, 0.14); color: var(--accent-dk); }
        .stat-icon-pay    { background: rgba(37, 99, 235, 0.12);  color: #2563eb; }

        .stat-content { flex: 1; min-width: 0; }

        .stat-label {
            font-size: 0.65rem;
            font-weight: 800;
            color: var(--muted);
            text-transform: uppercase;
            letter-spacing: 0.4px;
            line-height: 1.1;
        }

        .stat-value {
            font-size: 1.15rem;
            font-weight: 800;
            line-height: 1.1;
            color: var(--text);
            margin-top: 2px;
        }

        /* ── SYSTEM MESSAGE ─────────────────────────────────────────────────── */
        .sys-msg {
            display: block;
            margin-bottom: 14px;
            font-weight: 700;
            border-radius: 10px;
            padding: 10px 14px;
            font-size: 0.84rem;
            text-align: center;
        }

        /* ── SECTION HEADERS & TABS ─────────────────────────────────────────── */
        .section-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 14px;
            flex-wrap: wrap;
            gap: 8px;
        }

        .section-title {
            font-size: 1.02rem;
            font-weight: 800;
            color: var(--text);
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .btn-refresh {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            font-family: inherit;
            font-size: 0.78rem;
            font-weight: 700;
            color: var(--primary-dk);
            background: rgba(79, 126, 118, 0.1);
            border: 1px solid rgba(79, 126, 118, 0.22);
            padding: 6px 12px;
            border-radius: 16px;
            cursor: pointer;
        }

        /* ── LIGHTWEIGHT HISTORY FILTER CARD ────────────────────────────────── */
        .history-filter-card {
            background: #ffffff;
            border-radius: 12px;
            padding: 12px 14px;
            margin-bottom: 16px;
            border: 1px solid var(--border);
            border-top: 3px solid var(--primary);
            box-shadow: 0 2px 8px rgba(0,0,0,0.02);
        }

        .filter-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
            gap: 10px;
            align-items: end;
        }

        .filter-group {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .filter-group label {
            font-size: 11px;
            font-weight: 700;
            color: #475569;
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .styled-dropdown,
        .styled-input {
            padding: 7px 10px;
            font-size: 12px;
            font-family: inherit;
            border: 1px solid var(--border);
            border-radius: 6px;
            background: #f8fafc;
            color: var(--text);
            outline: none;
            width: 100%;
            box-sizing: border-box;
        }

        .btn-filter-apply {
            padding: 8px 14px;
            font-size: 12px;
            font-weight: 700;
            color: #ffffff;
            background: linear-gradient(135deg, var(--primary), var(--primary-dk));
            border: none;
            border-radius: 6px;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 5px;
            min-height: 32px;
        }

        /* ── SLIM DELIVERY CARDS GRID ───────────────────────────────────────── */
        .deliveries-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
            gap: 16px;
            margin-bottom: 20px;
        }

        .delivery-card {
            background: #ffffff;
            border-radius: 14px;
            padding: 16px;
            box-shadow: 0 3px 12px rgba(0, 0, 0, 0.04);
            border: 1px solid var(--border);
            border-top: 4px solid var(--primary);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .order-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            font-size: 0.8rem;
            font-weight: 800;
            color: var(--primary-dk);
            background: rgba(79, 126, 118, 0.1);
            padding: 4px 10px;
            border-radius: 16px;
            border: 1px solid rgba(79, 126, 118, 0.2);
            margin-bottom: 12px;
        }

        .customer-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
            padding-bottom: 8px;
            border-bottom: 1px solid var(--border);
            flex-wrap: wrap;
            gap: 6px;
        }

        .cust-name {
            font-size: 0.98rem;
            font-weight: 800;
            color: var(--text);
        }

        .cust-action-buttons {
            display: flex;
            gap: 5px;
        }

        .btn-call,
        .btn-whatsapp {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            font-size: 0.76rem;
            font-weight: 700;
            padding: 5px 10px;
            border-radius: 16px;
            text-decoration: none;
        }

        .btn-call {
            color: #15803d;
            background: rgba(22, 163, 74, 0.1);
            border: 1px solid rgba(22, 163, 74, 0.22);
        }

        .btn-whatsapp {
            color: #25d366;
            background: rgba(37, 211, 102, 0.1);
            border: 1px solid rgba(37, 211, 102, 0.3);
        }

        /* Address Box */
        .address-box {
            background: #f8fafc;
            border-radius: 10px;
            padding: 10px 12px;
            margin-bottom: 10px;
            border: 1px solid var(--border);
        }

        .box-label {
            font-size: 10px;
            font-weight: 800;
            color: var(--muted);
            text-transform: uppercase;
            letter-spacing: 0.4px;
            display: flex;
            align-items: center;
            gap: 4px;
            margin-bottom: 3px;
        }

        .address-text {
            font-size: 0.88rem;
            font-weight: 600;
            color: var(--text);
            line-height: 1.35;
            margin-bottom: 8px;
        }

        .btn-maps {
            width: 100%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            font-size: 0.8rem;
            font-weight: 800;
            color: #ffffff;
            background: linear-gradient(135deg, var(--primary), var(--primary-dk));
            border: none;
            border-radius: 16px;
            padding: 8px;
            text-decoration: none;
        }

        /* Items Box */
        .items-box {
            background: #f8fafc;
            border-radius: 10px;
            padding: 8px 12px;
            margin-bottom: 10px;
            border: 1px solid var(--border);
            font-size: 0.82rem;
        }

        .item-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 2px 0;
            color: var(--text);
            font-weight: 600;
        }

        .item-qty {
            font-weight: 800;
            color: var(--primary);
            font-size: 0.74rem;
            background: rgba(79, 126, 118, 0.1);
            padding: 1px 6px;
            border-radius: 12px;
        }

        /* Payment Box */
        .payment-box {
            display: flex;
            align-items: center;
            gap: 6px;
            background: rgba(255, 159, 67, 0.08);
            border: 1px solid rgba(255, 159, 67, 0.22);
            border-radius: 8px;
            padding: 8px 12px;
            margin-bottom: 12px;
            font-size: 0.84rem;
            font-weight: 800;
            color: var(--accent-dk);
        }

        /* OTP Section */
        .otp-section {
            background: #fffbeb;
            border: 1px solid #fde68a;
            border-radius: 10px;
            padding: 12px;
            text-align: center;
        }

        .otp-section-label {
            display: block;
            font-size: 0.75rem;
            font-weight: 800;
            color: #92400e;
            margin-bottom: 6px;
            text-transform: uppercase;
        }

        .otp-input {
            width: 130px;
            height: 38px;
            font-family: inherit;
            font-size: 18px;
            font-weight: 800;
            letter-spacing: 5px;
            text-align: center;
            border-radius: 8px;
            border: 1.5px solid #fcd34d;
            background: #ffffff;
            outline: none;
            margin-bottom: 8px;
        }

        .btn-verify {
            width: 100%;
            min-height: 36px;
            font-family: inherit;
            font-size: 0.84rem;
            font-weight: 800;
            color: #ffffff;
            background: linear-gradient(135deg, #16a34a, #15803d);
            border: none;
            border-radius: 16px;
            cursor: pointer;
        }

        /* Empty State */
        .empty-state {
            background: #ffffff;
            border-radius: 14px;
            padding: 32px 20px;
            text-align: center;
            border: 1px solid var(--border);
        }

        .empty-state-icon {
            width: 50px; height: 50px;
            border-radius: 50%;
            background: rgba(79, 126, 118, 0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 10px;
            font-size: 1.5rem;
            color: var(--primary);
        }

        .empty-state h3 {
            font-size: 1rem;
            font-weight: 800;
            color: var(--text);
            margin-bottom: 4px;
        }

        .empty-state p {
            font-size: 0.82rem;
            color: var(--muted);
        }

        /* History Card */
        .history-card {
            background: #ffffff;
            border-radius: 14px;
            padding: 14px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.03);
            border: 1px solid var(--border);
            border-left: 4px solid var(--success);
        }

        .delivered-badge {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            font-size: 0.75rem;
            font-weight: 800;
            color: #15803d;
            background: #f0fdf4;
            padding: 3px 8px;
            border-radius: 16px;
            border: 1px solid #bbf7d0;
        }

        @media (max-width: 768px) {
            .stats-grid { grid-template-columns: 1fr 1fr; }
            .deliveries-grid { grid-template-columns: 1fr; }
        }

        @media (max-width: 480px) {
            .stats-grid { grid-template-columns: 1fr 1fr; }
            .ck-nav-inner { width: calc(100% - 16px); }
            .nav-driver-info { display: none; }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <!-- LIGHTWEIGHT MOBILE NAVBAR -->
        <nav class="ck-navbar">
            <div class="ck-nav-inner">
                <a href="#" class="ck-brand">
                    <span class="ck-brand-mark"><i class="fas fa-motorcycle"></i></span>
                    <span class="ck-brand-text">
                        <span>Cloud Kitchen</span>
                        <span class="ck-brand-kicker">Driver App</span>
                    </span>
                </a>
                <div class="nav-right">
                    <div class="nav-driver-info">
                        <div class="nav-driver-name">
                            <asp:Label ID="lblDriverName" runat="server" Text="Driver"></asp:Label>
                        </div>
                        <div class="nav-vehicle">
                            Vehicle: <asp:Label ID="lblVehicleNo" runat="server" Text="--"></asp:Label>
                        </div>
                    </div>

                    <!-- DUTY STATUS BADGE -->
                    <asp:Label ID="lblDutyStatus" runat="server" CssClass="status-badge status-available" Text="Available"></asp:Label>

                    <!-- LIVE DUTY TOGGLE BUTTON -->
                    <asp:Button ID="btnToggleDuty" runat="server" CssClass="btn-duty-toggle btn-duty-online" Text="Go Offline" OnClick="btnToggleDuty_Click" CausesValidation="false" />

                    <!-- LOGOUT BUTTON -->
                    <asp:LinkButton ID="btnLogout" runat="server" CssClass="btn-logout" OnClick="btnLogout_Click" CausesValidation="false">
                        <i class="fas fa-sign-out-alt"></i> Exit
                    </asp:LinkButton>
                </div>
            </div>
        </nav>

        <div class="ck-container">
            <asp:UpdatePanel ID="updDriverPortal" runat="server">
                <ContentTemplate>
                    <!-- 15-SECOND AUTO-REFRESH TIMER -->
                    <asp:Timer ID="tmrAutoRefresh" runat="server" Interval="15000" OnTick="tmrAutoRefresh_Tick"></asp:Timer>

                    <!-- COMPACT SLIM GREETING STRIP -->
                    <div class="driver-mobile-welcome">
                        <div class="welcome-text">
                            <i class="fas fa-hand-wave" style="color:var(--accent);"></i> Welcome back, <asp:Label ID="lblDriverWelcomeName" runat="server" Text="Driver"></asp:Label>!
                        </div>
                        <a href="tel:9876543210" class="btn-support-pill">
                            <i class="fas fa-headset"></i> Kitchen Hotline
                        </a>
                    </div>

                    <!-- SYSTEM MESSAGE -->
                    <asp:Label ID="lblMsg" runat="server" EnableViewState="false" CssClass="sys-msg" Visible="false"></asp:Label>

                    <!-- LIGHTWEIGHT 2X2 COMPACT MICRO STAT PILLS -->
                    <div class="stats-grid">
                        <div class="stat-card">
                            <div class="stat-icon-box stat-icon-active">
                                <i class="fas fa-box-open"></i>
                            </div>
                            <div class="stat-content">
                                <div class="stat-label">Active</div>
                                <div class="stat-value">
                                    <asp:Label ID="lblActiveCount" runat="server" Text="0"></asp:Label>
                                </div>
                            </div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-icon-box stat-icon-done">
                                <i class="fas fa-circle-check"></i>
                            </div>
                            <div class="stat-content">
                                <div class="stat-label">Completed</div>
                                <div class="stat-value">
                                    <asp:Label ID="lblCompletedCount" runat="server" Text="0"></asp:Label>
                                </div>
                            </div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-icon-box stat-icon-cash">
                                <i class="fas fa-wallet"></i>
                            </div>
                            <div class="stat-content">
                                <div class="stat-label">COD Cash</div>
                                <div class="stat-value">
                                    ₹<asp:Label ID="lblTotalCashCollected" runat="server" Text="0.00"></asp:Label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- SECTION HEADER: ASSIGNED ACTIVE DELIVERIES -->
                    <div class="section-header">
                        <div class="section-title">
                            <i class="fas fa-motorcycle" style="color: var(--primary);"></i> Active Dispatches
                        </div>
                        <asp:Button ID="btnRefresh" runat="server" Text="↻ Refresh" CssClass="btn-refresh" OnClick="btnRefresh_Click" CausesValidation="false" />
                    </div>

                    <!-- ACTIVE DELIVERIES GRID -->
                    <div class="deliveries-grid">
                        <asp:Repeater ID="rptActiveDeliveries" runat="server" OnItemCommand="rptActiveDeliveries_ItemCommand">
                            <ItemTemplate>
                                <div class="delivery-card">

                                    <div class="order-badge">
                                        <i class="fas fa-box"></i> Order #<%# Eval("order_id") %>
                                    </div>

                                    <!-- Customer Info + Action Buttons -->
                                    <div class="customer-row">
                                        <div>
                                            <span style="font-size:10px; font-weight:700; color:var(--muted); text-transform:uppercase;">Customer</span>
                                            <div class="cust-name"><%# Eval("customer_name") %></div>
                                        </div>
                                        <div class="cust-action-buttons">
                                            <a href='tel:<%# Eval("phone") %>' class="btn-call" title="Call Customer">
                                                <i class="fas fa-phone"></i> Call
                                            </a>
                                            <a href='https://wa.me/91<%# Eval("phone") %>?text=Hello%20<%# Server.UrlEncode(Eval("customer_name").ToString()) %>,%20I%20am%20your%20Cloud%20Kitchen%20delivery%20partner%20with%20Order%20%23<%# Eval("order_id") %>.' target="_blank" class="btn-whatsapp" title="WhatsApp Customer">
                                                <i class="fab fa-whatsapp"></i> Chat
                                            </a>
                                        </div>
                                    </div>

                                    <!-- Address + Google Maps Navigation -->
                                    <div class="address-box">
                                        <div class="box-label"><i class="fas fa-location-dot" style="color:var(--primary);"></i> Delivery Address</div>
                                        <div class="address-text"><%# Eval("address") %>, <%# Eval("pincode") %></div>
                                        <a href='https://www.google.com/maps/search/?api=1&query=<%# Server.UrlEncode(Eval("address").ToString() & ", " & Eval("pincode").ToString()) %>' target="_blank" class="btn-maps">
                                            <i class="fas fa-location-arrow"></i> Google Maps Navigation
                                        </a>
                                    </div>

                                    <!-- Food Items -->
                                    <div class="items-box">
                                        <div class="box-label"><i class="fas fa-utensils"></i> Items Ordered</div>
                                        <asp:Repeater ID="rptItems" runat="server" DataSource='<%# Eval("OrderItems") %>'>
                                            <ItemTemplate>
                                                <div class="item-row">
                                                    <span><%# Eval("item_name") %></span>
                                                    <span class="item-qty">x<%# Eval("quantity") %></span>
                                                </div>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </div>

                                    <!-- Payment Type & Total Amount -->
                                    <div class="payment-box">
                                        <i class="fas fa-credit-card"></i>
                                        <span>Payment: <%# Eval("payment_type") %> &nbsp;|&nbsp; Total: ₹<%# Eval("total_amount", "{0:N2}") %></span>
                                    </div>

                                    <!-- Doorstep OTP Verification -->
                                    <div class="otp-section">
                                        <span class="otp-section-label"><i class="fas fa-shield-alt"></i> Doorstep OTP Verification</span>
                                        <asp:TextBox ID="txtOtpInput" runat="server" CssClass="otp-input" MaxLength="4" TextMode="Number" Placeholder="----"></asp:TextBox>
                                        <br />
                                        <asp:Button ID="btnVerify" runat="server" Text="Verify OTP & Complete Delivery" CssClass="btn-verify" CommandName="VerifyOtp" CommandArgument='<%# Eval("order_id") %>' CausesValidation="false" />
                                    </div>

                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>

                    <!-- EMPTY STATE FOR ACTIVE DELIVERIES -->
                    <asp:Panel ID="pnlNoActive" runat="server" CssClass="empty-state" Visible="false">
                        <div class="empty-state-icon"><i class="fas fa-circle-check"></i></div>
                        <h3>No Active Dispatches</h3>
                        <p>You have completed all assigned orders. New dispatches will automatically pop up here.</p>
                    </asp:Panel>

                    <!-- SECTION HEADER: COMPLETED DELIVERY HISTORY & LOGS -->
                    <div class="section-header" style="margin-top: 28px;">
                        <div class="section-title">
                            <i class="fas fa-clock-rotate-left" style="color: var(--success);"></i> Delivery History &amp; Logs
                        </div>
                    </div>

                    <!-- DELIVERY HISTORY DATE FILTER CARD -->
                    <div class="history-filter-card">
                        <div class="filter-grid">
                            
                            <div class="filter-group">
                                <label><i class="fas fa-calendar-alt" style="color:var(--primary);"></i> Date Range</label>
                                <asp:DropDownList ID="ddlHistoryFilter" runat="server" CssClass="styled-dropdown" AutoPostBack="true" OnSelectedIndexChanged="ddlHistoryFilter_SelectedIndexChanged">
                                    <asp:ListItem Text="Today" Value="Today"></asp:ListItem>
                                    <asp:ListItem Text="Yesterday" Value="Yesterday"></asp:ListItem>
                                    <asp:ListItem Text="Last 7 Days" Value="7Days"></asp:ListItem>
                                    <asp:ListItem Text="This Month" Value="Month"></asp:ListItem>
                                    <asp:ListItem Text="All Time" Value="All"></asp:ListItem>
                                    <asp:ListItem Text="Custom Dates" Value="Custom"></asp:ListItem>
                                </asp:DropDownList>
                            </div>

                            <div class="filter-group">
                                <label><i class="fas fa-calendar-day" style="color:var(--primary);"></i> Start Date</label>
                                <asp:TextBox ID="txtHistoryStart" runat="server" Type="date" CssClass="styled-input"></asp:TextBox>
                            </div>

                            <div class="filter-group">
                                <label><i class="fas fa-calendar-check" style="color:var(--primary);"></i> End Date</label>
                                <asp:TextBox ID="txtHistoryEnd" runat="server" Type="date" CssClass="styled-input"></asp:TextBox>
                            </div>

                            <asp:Button ID="btnFilterHistory" runat="server" Text="Filter" CssClass="btn-filter-apply" OnClick="btnFilterHistory_Click" CausesValidation="false" />

                        </div>
                    </div>

                    <!-- COMPLETED DELIVERIES HISTORY GRID -->
                    <div class="deliveries-grid">
                        <asp:Repeater ID="rptCompletedDeliveries" runat="server">
                            <ItemTemplate>
                                <div class="history-card">
                                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                                        <span class="delivered-badge"><i class="fas fa-circle-check"></i> Order #<%# Eval("order_id") %> Delivered</span>
                                        <span style="font-size: 0.75rem; font-weight: 700; color: #64748b;"><i class="fas fa-clock"></i> <%# Eval("delivered_time", "{0:dd-MMM-yyyy hh:mm tt}") %></span>
                                    </div>
                                    <div style="font-weight: 800; font-size: 0.95rem; color: #0f172a; margin-bottom: 2px;"><%# Eval("customer_name") %></div>
                                    <div style="font-size: 0.82rem; color: #64748b; margin-bottom: 8px;"><i class="fas fa-location-dot" style="color:var(--primary); margin-right:4px;"></i><%# Eval("address") %>, <%# Eval("pincode") %></div>
                                    
                                    <div class="items-box" style="margin-bottom: 8px; background: #fafafa;">
                                        <asp:Repeater ID="rptCompletedItems" runat="server" DataSource='<%# Eval("OrderItems") %>'>
                                            <ItemTemplate>
                                                <div class="item-row">
                                                    <span>• <%# Eval("item_name") %></span>
                                                    <span class="item-qty">x<%# Eval("quantity") %></span>
                                                </div>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </div>

                                    <div style="font-size: 0.84rem; font-weight: 800; color: #15803d; display: flex; justify-content: space-between;">
                                        <span>Payment: <%# Eval("payment_type") %></span>
                                        <span>₹<%# Eval("total_amount", "{0:N2}") %></span>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>

                    <!-- EMPTY STATE FOR COMPLETED DELIVERIES -->
                    <asp:Panel ID="pnlNoCompleted" runat="server" CssClass="empty-state" Visible="false" style="padding: 24px 16px;">
                        <p style="margin: 0; color: #64748b; font-size: 0.84rem;">No completed delivery logs found for the selected date range.</p>
                    </asp:Panel>

                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </form>
</body>
</html>
