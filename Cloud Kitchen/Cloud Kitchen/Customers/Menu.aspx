<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Customers/Customer.Master"
    CodeBehind="Menu.aspx.vb" Inherits="Cloud_Kitchen.Menu" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@600;700&family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet" />

    <style>
        :root {
            --primary: #4F7E76;
            --primary-dk: #3a5f59;
            --accent: #ff9f43;
            --bg: #f6f8f7;
            --card-bg: #ffffff;
            --text: #263445;
            --muted: #687382;
        }

        body {
            font-family: 'Poppins', system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            background: var(--bg);
            color: var(--text);
        }

        .ck-menu-hero {
            position: relative;
            width: 100%;
            min-height: 420px;
            background: url('../Images/menubg.jpg') center/cover no-repeat;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            color: #fff;
        }

        .ck-menu-hero::before {
            content: '';
            position: absolute;
            inset: 0;
            background: rgba(0, 0, 0, .58);
        }

        .hero-inner {
            position: relative;
            z-index: 2;
            padding: 2rem 1.5rem;
            max-width: 900px;
        }

        .hero-inner h1 {
            font-family: 'Poppins', system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            font-size: clamp(2.4rem, 2.5vw, 4.6rem);
            font-weight: 700;
            line-height: 0.98;
            margin-bottom: .9rem;
            text-shadow: 0 2px 14px rgba(0, 0, 0, .5);
        }

        .hero-inner p {
            font-size: clamp(.98rem, 2.2vw, 1.12rem);
            color: rgba(255, 255, 255, .88);
            margin: 0;
            line-height: 1.7;
            font-weight: 500;
        }

        .ck-filter-bar {
            max-width: 960px;
            margin: -44px auto 0;
            padding: 1.4rem 1.6rem;
            background: rgba(15, 25, 35, .82);
            backdrop-filter: blur(14px);
            -webkit-backdrop-filter: blur(14px);
            border-radius: 16px;
            box-shadow: 0 12px 40px rgba(0, 0, 0, .22);
            position: relative;
            z-index: 100;
        }

        .ck-filter-bar .filter-box {
            width: 100%;
            padding: .78rem 1.1rem;
            border: 1.5px solid rgba(255, 255, 255, .18);
            border-radius: 10px;
            font-family: 'Poppins', sans-serif;
            font-size: .94rem;
            font-weight: 600;
            color: #fff;
            background: rgba(255, 255, 255, .1);
            transition: border-color .25s, box-shadow .25s, background .25s;
            outline: none;
            box-sizing: border-box;
        }

        .ck-filter-bar .filter-box::placeholder {
            color: rgba(255, 255, 255, .55);
        }

        .ck-filter-bar .filter-box:focus {
            border-color: var(--accent);
            box-shadow: 0 0 0 3px rgba(255, 159, 67, .2);
            background: rgba(255, 255, 255, .15);
        }

        .ck-filter-bar select.filter-box option {
            background: #1a2535;
            color: #fff;
        }

        .ck-section-label {
            text-align: center;
            margin: 3.5rem 0 2rem;
        }

        .ck-section-label h2 {
            font-family: 'Poppins', system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            font-size: clamp(2rem, 4.5vw, 3rem);
            color: var(--primary);
            display: inline-block;
            position: relative;
            padding-bottom: .5rem;
            font-weight: 700;
        }

        .ck-section-label h2::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 50px;
            height: 4px;
            background: var(--accent);
            border-radius: 2px;
        }

        .ck-menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 24px;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 1rem 4rem;
        }

        .menu-card {
            background: var(--card-bg);
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0, 0, 0, .08);
            transition: transform .3s, box-shadow .3s;
            display: flex;
            flex-direction: column;
        }

        .menu-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 14px 36px rgba(0, 0, 0, .14);
        }

        .card-img-wrap {
            width: 100%;
            height: 210px;
            overflow: hidden;
            flex-shrink: 0;
        }

        .menu-card img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform .4s ease;
            display: block;
        }

        .menu-card:hover img {
            transform: scale(1.06);
        }

        .card-body {
            padding: 1.1rem 1.2rem 1.4rem;
            display: flex;
            flex-direction: column;
            flex: 1;
            gap: .4rem;
        }

        .menu-card h3 {
            font-family: 'Poppins', system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            font-size: 1.45rem;
            line-height: 1.05;
            color: var(--text);
            margin: 0;
            font-weight: 700;
        }

        .menu-card p {
            font-size: .88rem;
            color: var(--muted);
            margin: 0;
            line-height: 1.6;
            font-weight: 500;
        }

        .menu-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 7px;
            margin-top: .3rem;
        }

        .tag {
            font-size: .72rem;
            padding: 4px 11px;
            border-radius: 20px;
            font-weight: 700;
            color: #fff;
            letter-spacing: .3px;
            font-family: 'Poppins', sans-serif;
        }

        .category-tag { background: #0078d7; }
        .cuisine-tag { background: #27ae60; }

        .menu-price {
            font-size: 1.28rem;
            font-weight: 800;
            color: var(--primary);
            margin: .3rem 0 0;
            font-family: 'Poppins', sans-serif;
        }

        .not-available-label {
            display: inline-block;
            background: #e74c3c;
            color: #fff;
            font-size: .8rem;
            font-weight: 800;
            padding: 4px 12px;
            border-radius: 6px;
            margin-top: .4rem;
            width: fit-content;
        }

        .order-btn {
            margin-top: auto;
            padding: .76rem 1.2rem;
            background: linear-gradient(135deg, var(--primary), var(--primary-dk));
            color: #fff;
            border: none;
            border-radius: 50px;
            font-family: 'Poppins', sans-serif;
            font-size: .93rem;
            font-weight: 700;
            cursor: pointer;
            box-shadow: 0 4px 14px rgba(79, 126, 118, .32);
            transition: transform .2s, box-shadow .2s;
            width: 100%;
        }

        .order-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 22px rgba(79, 126, 118, .45);
        }

        .menu-empty-container {
            max-width: 580px;
            margin: 60px auto;
            padding: 3rem 2rem;
            text-align: center;
            background: linear-gradient(135deg, #f5faff, #eaf3ff);
            border-radius: 20px;
            box-shadow: 0 12px 32px rgba(0, 0, 0, .07);
        }

        .menu-empty-container h2 {
            font-family: 'Poppins', system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            font-size: clamp(1.7rem, 4vw, 2.25rem);
            color: #2c3e50;
            margin-bottom: .8rem;
            font-weight: 700;
        }

        .menu-empty-container img {
            margin: 1rem 0 1.4rem;
            animation: ck-float 4s ease-in-out infinite;
            filter: drop-shadow(2px 4px 8px rgba(0, 0, 0, .1));
        }

        .menu-empty-container p {
            font-size: .97rem;
            color: #555;
            line-height: 1.65;
            margin-bottom: .6rem;
            font-weight: 500;
        }

        .empty-reset-btn {
            display: inline-block;
            margin-top: 1.2rem;
            padding: .75rem 1.8rem;
            background: var(--primary);
            color: #fff;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 700;
            font-size: .95rem;
            box-shadow: 0 5px 16px rgba(79, 126, 118, .32);
            transition: background .25s, transform .2s;
        }

        .empty-reset-btn:hover {
            background: var(--primary-dk);
            transform: translateY(-2px);
            color: #fff;
        }

        @keyframes ck-float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-7px); }
        }

        @media (max-width: 767px) {
            .ck-menu-hero { min-height: 320px; }
            .ck-menu-grid { grid-template-columns: repeat(auto-fill, minmax(240px, 1fr)); gap: 16px; }
        }

        @media (max-width: 575px) {
            .ck-filter-bar { margin-top: 0; border-radius: 0; }
        }

        @media (max-width: 480px) {
            .ck-menu-hero { min-height: 260px; }
            .ck-menu-grid { grid-template-columns: 1fr; }
            .card-img-wrap { height: 190px; }
            .hero-inner h1 { font-size: clamp(2.15rem, 14vw, 3.2rem); }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="ck-menu-hero">
        <div class="hero-inner">
            <h1>🍽️ Delicious Food, Delivered Fast! 🚀</h1>
            <p>Order your favorite meals fresh &amp; hot. Enjoy restaurant-quality food at your doorstep!</p>
        </div>
    </div>

    <div class="ck-filter-bar">
        <div class="row g-3 align-items-center">
            <div class="col-12 col-md-5">
                <asp:TextBox ID="txtSearch" runat="server"
                    CssClass="filter-box"
                    placeholder="🔍 Search food..."
                    AutoPostBack="true"
                    OnTextChanged="FilterMenu"></asp:TextBox>
            </div>
            <div class="col-12 col-sm-6 col-md-3">
                <asp:DropDownList ID="ddlCategory" runat="server"
                    CssClass="filter-box"
                    AutoPostBack="true"
                    OnSelectedIndexChanged="FilterMenu">
                    <asp:ListItem Text="🍽️ All Categories" Value="0"></asp:ListItem>
                </asp:DropDownList>
            </div>
            <div class="col-12 col-sm-6 col-md-4">
                <asp:DropDownList ID="ddlCuisine" runat="server"
                    CssClass="filter-box"
                    AutoPostBack="true"
                    OnSelectedIndexChanged="FilterMenu">
                    <asp:ListItem Text="🌍 All Cuisines" Value="0"></asp:ListItem>
                </asp:DropDownList>
            </div>
        </div>
    </div>

    <div class="ck-section-label">
        <h2>Our Menu</h2>
    </div>

    <div class="ck-menu-grid">
        <asp:Repeater ID="rptMenuItems" runat="server">
            <ItemTemplate>
                <div class="menu-card">
                    <div class="card-img-wrap">
                        <img src='<%# Eval("m_image_url") %>' alt='<%# Eval("m_name") %>' />
                    </div>
                    <div class="card-body">
                        <h3><%# Eval("m_name") %></h3>
                        <p><%# Eval("m_description") %></p>

                        <div class="menu-tags">
                            <span class="tag category-tag"><%# Eval("category_name") %></span>
                            <span class="tag cuisine-tag"><%# Eval("cuisine_name") %></span>
                        </div>

                        <p class="menu-price">₹<%# Eval("m_final_price") %></p>

                        <asp:Panel ID="Panel1" runat="server"
                            CssClass="not-available-label"
                            Visible='<%# Not Convert.ToBoolean(Eval("m_availability")) %>'>
                            ❌ Not Available
                        </asp:Panel>

                        <asp:Button ID="btnOrderNow" runat="server"
                            CssClass="order-btn"
                            Text="😋 Order Now"
                            CommandArgument='<%# Eval("m_id") %>'
                            Visible='<%# Convert.ToBoolean(Eval("m_availability")) %>'
                            OnCommand="OrderNow_Click" />
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlempty" runat="server" Visible="false">
            <div class="menu-empty-container">
                <h2>We're sorry, nothing's available right now 🙁</h2>
                <img src="../icons/em5.png" width="110" alt="No Items Found" />
                <p>We couldn't find any menu items matching your search or selected filters.</p>
                <p style="color:#777;font-size:.9rem;">
                    Try adjusting your selection or check back shortly — we're always cooking up something new! 🍳
                </p>
                <a href="menu.aspx" class="empty-reset-btn">🔁 View All Menu Items</a>
            </div>
        </asp:Panel>
    </div>

    <br /><br />
</asp:Content>
