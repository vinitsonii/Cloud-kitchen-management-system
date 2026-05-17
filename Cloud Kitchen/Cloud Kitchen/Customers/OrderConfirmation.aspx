<%@ Page Title="Order Confirmation" Language="vb" AutoEventWireup="false" MasterPageFile="~/Customers/Customer.Master" CodeBehind="OrderConfirmation.aspx.vb" Inherits="Cloud_Kitchen.OrderConfirmation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet" />

    <style>
        :root {
            --primary:    #4F7E76;
            --primary-dk: #3a5f59;
            --accent:     #ff9f43;
            --success:    #4CAF50;
            --warning:    #ff9800;
            --bg:         #f6f8f7;
            --card-bg:    #ffffff;
            --text:       #333;
            --muted:      #666;
            --border:     #eaeaea;
        }

        body {
            font-family: 'DM Sans', sans-serif;
            background: var(--bg);
            color: var(--text);
        }

        .ck-confirm-hero {
            position: relative;
            width: 100%;
            min-height: 300px;
            background: url('../Images/lb8.jpeg') top/cover no-repeat;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            text-align: center;
        }

        .ck-confirm-hero::before {
            content: '';
            position: absolute; inset: 0;
            background: linear-gradient(160deg, rgba(0,0,0,.55), rgba(79,126,118,.35));
        }

        .ck-confirm-hero .hero-inner {
            position: relative; z-index: 2;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: .6rem;
            padding: 1rem 2rem;
        }

        .ck-confirm-hero .hero-burger {
            width: 60px;
            filter: drop-shadow(0 4px 12px rgba(0,0,0,.4));
            animation: ck-float 2.8s ease-in-out infinite;
        }

        @keyframes ck-float {
            0%,100% { transform: translateY(0); }
            50%      { transform: translateY(-9px); }
        }

        .ck-confirm-hero h1 {
            font-family: 'Playfair Display', serif;
            font-size: clamp(1.6rem, 4.5vw, 2.4rem);
            margin: 0;
            text-shadow: 0 2px 14px rgba(0,0,0,.45);
        }

        @media (max-width: 575px) { .ck-confirm-hero { min-height: 220px; } }

        .ck-confirm-card {
            max-width: 580px;
            margin: -60px auto 60px;
            background: var(--card-bg);
            border-radius: 22px;
            box-shadow: 0 12px 48px rgba(0,0,0,.13);
            overflow: hidden;
            position: relative;
            z-index: 10;
            animation: ck-rise .65s cubic-bezier(.34,1.56,.64,1) both;
        }

        @keyframes ck-rise {
            from { opacity: 0; transform: translateY(32px) scale(.96); }
            to   { opacity: 1; transform: translateY(0) scale(1); }
        }

        @media (max-width: 575px) {
            .ck-confirm-card { margin: 0 auto 40px; border-radius: 0; box-shadow: none; }
        }

        .ck-confetti-bar {
            height: 6px;
            background: repeating-linear-gradient(
                90deg,
                var(--accent) 0 18px,
                var(--primary) 18px 36px,
                #fff 36px 54px,
                var(--success) 54px 72px
            );
        }

        .ck-card-header {
            background: linear-gradient(135deg, var(--primary), var(--primary-dk));
            padding: 2rem 1.5rem 1.8rem;
            text-align: center;
            color: #fff;
        }

        .ck-card-header .logo-gif {
            width: 64px; height: 64px;
            border-radius: 50%;
            border: 3px solid rgba(255,255,255,.35);
            object-fit: cover;
            margin-bottom: .9rem;
        }

        .ck-card-header h2 {
            font-family: 'Playfair Display', serif;
            font-size: clamp(1.25rem, 3.5vw, 1.85rem);
            margin: 0 0 .35rem;
        }

        .ck-card-header p { font-size: .97rem; opacity: .88; margin: 0; }

        
        .ck-order-details { padding: 1.6rem 2rem; }

        .detail-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1rem;
            padding: .8rem 0;
            border-bottom: 1px solid var(--border);
            font-size: .95rem;
            flex-wrap: wrap;
        }

        .detail-row:last-child { border-bottom: none; }

        .detail-label {
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 600;
            color: var(--muted);
            white-space: nowrap;
        }

        .detail-value {
            font-weight: 700;
            color: var(--text);
            text-align: right;
            word-break: break-all;
        }

        .detail-value.price { color: var(--primary); font-size: 1.05rem; }

        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 4px 14px;
            border-radius: 20px;
            font-size: .82rem;
            font-weight: 700;
            letter-spacing: .3px;
        }

        .status-pending {
            background: rgba(255,152,0,.12);
            color: var(--warning);
            border: 1.5px solid rgba(255,152,0,.3);
        }

        .status-success {
            background: rgba(76,175,80,.12);
            color: var(--success);
            border: 1.5px solid rgba(76,175,80,.3);
        }

        .ck-pending-panel {
            margin: 0 2rem 1.6rem;
            background: rgba(255,152,0,.07);
            border: 1.5px solid rgba(255,152,0,.28);
            border-radius: 14px;
            padding: 1.3rem 1.5rem;
            text-align: center;
        }

        .ck-pending-panel p {
            font-size: .93rem;
            color: #7a5c00;
            margin: 0 0 1rem;
            line-height: 1.65;
        }

        .ck-track-btn {
            display: inline-block;
            padding: .75rem 2rem;
            background: linear-gradient(135deg, var(--primary), var(--primary-dk));
            color: #fff !important;
            border: none;
            border-radius: 50px;
            font-family: 'DM Sans', sans-serif;
            font-size: .95rem;
            font-weight: 600;
            cursor: pointer;
            box-shadow: 0 5px 16px rgba(79,126,118,.32);
            transition: transform .2s, box-shadow .2s;
            text-decoration: none;
        }

        .ck-track-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(79,126,118,.44);
        }

        .ck-card-footer {
            padding: 0 2rem 2rem;
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            justify-content: center;
        }

        .ck-pill-link {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: .65rem 1.6rem;
            border-radius: 50px;
            font-size: .9rem;
            font-weight: 600;
            text-decoration: none;
            border: 2px solid var(--primary);
            color: var(--primary);
            transition: background .2s, transform .18s;
        }

        .ck-pill-link:hover {
            background: rgba(79,126,118,.08);
            transform: translateY(-1px);
            color: var(--primary);
        }
    </style>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="ck-confirm-hero">
        <div class="hero-inner">
            <img src="../icons/burger.png" alt="Order" class="hero-burger" />
            <h1>Order Confirmation</h1>
        </div>
    </div>

    <div class="ck-confirm-card">

        <div class="ck-confetti-bar"></div>

        <div class="ck-card-header">
            <img src="../icons/logo.gif" alt="Cloud Kitchen" class="logo-gif" />
            <h2>Thank You for Your Order! 🎉</h2>
            <p>Your delicious meal is on its way. 🍽️</p>
        </div>

        <div class="ck-order-details">

            <div class="detail-row">
                <span class="detail-label">🧾 Order ID</span>
                <span class="detail-value">
                    <asp:Label ID="lblOrderId" runat="server"></asp:Label>
                </span>
            </div>

            <div class="detail-row">
                <span class="detail-label">🔖 Transaction No.</span>
                <span class="detail-value">
                    <asp:Label ID="lblTransactionNumber" runat="server"></asp:Label>
                </span>
            </div>

            <div class="detail-row">
                <span class="detail-label">💰 Total Amount</span>
                <span class="detail-value price">
                    ₹<asp:Label ID="lblTotalAmount" runat="server"></asp:Label>
                </span>
            </div>

            <div class="detail-row">
                <span class="detail-label">📦 Order Status</span>
                <span class="detail-value">
                    <asp:Label ID="lblOrderStatus" runat="server" CssClass="status-badge status-pending"></asp:Label>
                </span>
            </div>

        </div>

        <asp:Panel ID="pnlPendingMessage" runat="server" Visible="false">
            <div class="ck-pending-panel">
                <p>⏳ Your order is currently <strong>Pending</strong>. We're preparing it and will update you soon!</p>
                <asp:Button ID="btnTrackOrder" runat="server"
                    CssClass="ck-track-btn"
                    Text="📍 Track My Order"
                    PostBackUrl="MyOrders.aspx" />
            </div>
        </asp:Panel>

        <div class="ck-card-footer">
            <a href="Menu.aspx"     class="ck-pill-link">🍽️ Order More</a>
            <a href="MyOrders.aspx" class="ck-pill-link">📋 My Orders</a>
        </div>

    </div>

</asp:Content>
