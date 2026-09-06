<%@ Page Title="Our Menu" Language="vb" AutoEventWireup="false" MasterPageFile="~/Customers/Customer.Master" CodeBehind="Menu.aspx.vb" Inherits="Cloud_Kitchen.Menu" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Google Fonts & FontAwesome 6 Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

    <style type="text/css">
        :root {
            --primary: #4F7E76;
            --primary-dk: #355b54;
            --accent: #ff9f43;
            --bg: #f8fafc;
            --card-bg: #ffffff;
            --text: #0f172a;
            --muted: #64748b;
            --border: #e2e8f0;
        }

        body {
            font-family: 'Poppins', system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            background: var(--bg);
            color: var(--text);
            margin: 0;
            padding: 0;
        }

        /* HERO HEADER */
        .ck-menu-hero {
            position: relative;
            width: 100%;
            min-height: 320px;
            background: linear-gradient(135deg, rgba(15, 23, 42, 0.8), rgba(53, 91, 84, 0.85)),
                        url('../Images/menubg.jpg') center/cover no-repeat;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            color: #ffffff;
            padding: 50px 20px 70px;
        }

        .hero-inner {
            position: relative;
            z-index: 2;
            max-width: 850px;
        }

        .hero-inner h1 {
            font-size: clamp(1.8rem, 4.5vw, 3rem);
            font-weight: 800;
            line-height: 1.2;
            margin-bottom: 12px;
            text-shadow: 0 4px 16px rgba(0, 0, 0, 0.4);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            flex-wrap: wrap;
        }

        .hero-inner p {
            font-size: clamp(0.92rem, 2vw, 1.1rem);
            color: rgba(255, 255, 255, 0.9);
            margin: 0;
            line-height: 1.6;
            font-weight: 500;
        }

        /* FLOATING FILTER BAR */
        .ck-filter-wrap {
            max-width: 1100px;
            margin: -40px auto 30px;
            padding: 0 16px;
            position: relative;
            z-index: 10;
        }

        .ck-filter-card {
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            padding: 18px 24px;
            border: 1px solid var(--border);
            border-top: 4px solid var(--primary);
        }

        .filter-row-grid {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr;
            gap: 16px;
            align-items: center;
        }

        .filter-group-item {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .filter-group-item label {
            font-size: 12.5px;
            font-weight: 700;
            color: #475569;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .filter-box {
            width: 100%;
            padding: 11px 16px;
            border: 1.5px solid var(--border);
            border-radius: 10px;
            font-family: inherit;
            font-size: 13.5px;
            font-weight: 600;
            color: var(--text);
            background: #f8fafc;
            transition: all 0.25s ease;
            outline: none;
            box-sizing: border-box;
        }

        .filter-box:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(79, 126, 118, 0.18);
            background: #ffffff;
        }

        /* SECTION LABEL */
        .ck-section-label {
            text-align: center;
            margin: 2rem 0 2.5rem;
        }

        .ck-section-label h2 {
            font-size: clamp(1.8rem, 4vw, 2.5rem);
            color: var(--primary);
            display: inline-block;
            position: relative;
            padding-bottom: 8px;
            font-weight: 800;
            margin: 0;
        }

        .ck-section-label h2::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 60px;
            height: 4px;
            background: var(--accent);
            border-radius: 2px;
        }

        /* MENU GRID & CARDS */
        /* ENHANCED MENU GRID & CARDS */
        .ck-menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(310px, 1fr));
            gap: 28px;
            max-width: 1240px;
            margin: 0 auto;
            padding: 0 16px 4rem;
        }

        .menu-card {
            background: #ffffff;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 8px 26px rgba(15, 23, 42, 0.06);
            border: 1.5px solid #e2e8f0;
            transition: all 0.35s cubic-bezier(0.16, 1, 0.3, 1);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            position: relative;
        }

        .menu-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 45px rgba(15, 23, 42, 0.12);
            border-color: rgba(79, 126, 118, 0.4);
        }

        .card-img-wrap {
            width: 100%;
            height: 220px;
            overflow: hidden;
            position: relative;
            flex-shrink: 0;
            background: #f1f5f9;
        }

        .menu-card img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
            display: block;
        }

        .menu-card:hover img {
            transform: scale(1.08);
        }

        .card-img-wrap::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 60px;
            background: linear-gradient(to top, rgba(0, 0, 0, 0.35), transparent);
            pointer-events: none;
        }

        .card-badge {
            position: absolute;
            top: 14px;
            right: 14px;
            background: rgba(15, 23, 42, 0.75);
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            color: #ff9f43;
            font-size: 11px;
            font-weight: 800;
            padding: 5px 12px;
            border-radius: 30px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            z-index: 2;
            display: flex;
            align-items: center;
            gap: 5px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        .card-body {
            padding: 20px;
            display: flex;
            flex-direction: column;
            flex: 1;
            gap: 10px;
        }

        .menu-card h3 {
            font-size: 1.35rem;
            line-height: 1.25;
            color: #0f172a;
            margin: 0;
            font-weight: 800;
            letter-spacing: -0.3px;
        }

        .card-desc {
            font-size: 13.5px;
            color: #64748b;
            margin: 0;
            line-height: 1.55;
            font-weight: 400;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            min-height: 42px;
        }

        .menu-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
            margin-top: 2px;
        }

        .tag {
            font-size: 11px;
            padding: 4px 11px;
            border-radius: 20px;
            font-weight: 700;
            color: #ffffff;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            letter-spacing: 0.2px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.06);
        }

        .category-tag {
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
        }

        .cuisine-tag {
            background: linear-gradient(135deg, #059669, #047857);
        }

        /* PROMINENT PRICE & ACTION FOOTER */
        .card-footer-action {
            margin-top: 10px;
            padding-top: 14px;
            border-top: 1px dashed #e2e8f0;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
        }

        .price-container {
            display: flex;
            flex-direction: column;
        }

        .price-label {
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #94a3b8;
        }

        .menu-price {
            font-size: 1.35rem;
            font-weight: 800;
            color: #16a34a;
            margin: 0;
            letter-spacing: -0.3px;
            line-height: 1.15;
        }

        .not-available-label {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: #fef2f2;
            color: #dc2626;
            border: 1px solid #fecaca;
            font-size: 12px;
            font-weight: 800;
            padding: 8px 16px;
            border-radius: 12px;
            width: fit-content;
        }

        .order-btn {
            padding: 11px 22px;
            height: 46px;
            background: linear-gradient(135deg, #4F7E76, #355b54);
            color: #ffffff !important;
            text-decoration: none;
            border: none;
            border-radius: 50px;
            font-size: 14px;
            font-weight: 700;
            letter-spacing: 0.3px;
            cursor: pointer;
            box-shadow: 0 6px 20px rgba(79, 126, 118, 0.38);
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 9px;
            white-space: nowrap;
            flex: 1;
            max-width: 175px;
        }

        .order-btn:hover {
            transform: translateY(-3px) scale(1.02);
            background: linear-gradient(135deg, #3a5f59, #25423d);
            box-shadow: 0 10px 26px rgba(79, 126, 118, 0.52);
            color: #ffffff !important;
        }

        .order-btn i {
            font-size: 15px;
            transition: transform 0.25s ease;
        }

        .order-btn:hover i {
            transform: rotate(-10deg) scale(1.15);
        }

        /* EMPTY STATE CONTAINER */
        .menu-empty-container {
            max-width: 580px;
            margin: 40px auto;
            padding: 3rem 2rem;
            text-align: center;
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.06);
            border: 1px solid var(--border);
        }

        .menu-empty-container h2 {
            font-size: clamp(1.4rem, 3.5vw, 2rem);
            color: #0f172a;
            margin-bottom: 12px;
            font-weight: 800;
        }

        .empty-reset-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-top: 16px;
            padding: 11px 24px;
            background: var(--primary);
            color: #ffffff;
            border-radius: 10px;
            text-decoration: none;
            font-weight: 700;
            font-size: 14px;
            box-shadow: 0 5px 16px rgba(79, 126, 118, 0.3);
            transition: all 0.25s ease;
        }

        .empty-reset-btn:hover {
            background: var(--primary-dk);
            transform: translateY(-2px);
            color: #ffffff;
        }

        /* 📱 RESPONSIVE MOBILE HORIZONTAL FOOD CARDS (DESKTOP UNCHANGED) */
        @media (max-width: 991px) {
            .filter-row-grid {
                grid-template-columns: 1fr 1fr;
            }
        }

        @media (max-width: 768px) {
            .ck-filter-wrap {
                margin: -25px auto 20px;
                padding: 0 12px;
            }

            .ck-filter-card {
                padding: 14px 16px;
                border-radius: 14px;
            }

            .filter-row-grid {
                grid-template-columns: 1fr !important;
                gap: 10px !important;
            }

            .ck-menu-hero {
                min-height: 200px !important;
                padding: 30px 16px 50px !important;
            }

            .ck-menu-grid {
                display: flex !important;
                flex-direction: column !important;
                gap: 14px !important;
                padding: 0 12px 3rem !important;
            }

            .menu-card {
                flex-direction: row !important;
                align-items: center !important;
                padding: 12px !important;
                border-radius: 16px !important;
                box-shadow: 0 4px 16px rgba(15, 23, 42, 0.05) !important;
                gap: 12px !important;
                position: relative !important;
            }

            .menu-card:hover {
                transform: none !important;
            }

            /* SQUARE IMAGE ON RIGHT SIDE (SWIGGY / ZOMATO STYLE) */
            .card-img-wrap {
                width: 105px !important;
                height: 105px !important;
                border-radius: 14px !important;
                order: 2 !important;
                flex-shrink: 0 !important;
            }

            .card-badge {
                display: none !important;
            }

            .card-body {
                padding: 0 !important;
                order: 1 !important;
                flex: 1 !important;
                gap: 4px !important;
            }

            .menu-card h3 {
                font-size: 1.05rem !important;
                line-height: 1.25 !important;
            }

            .card-desc {
                font-size: 12px !important;
                min-height: auto !important;
                margin-bottom: 4px !important;
                -webkit-line-clamp: 2 !important;
                line-clamp: 2 !important;
            }

            .menu-tags {
                margin-top: 2px !important;
                gap: 4px !important;
            }

            .tag {
                font-size: 10px !important;
                padding: 2px 8px !important;
            }

            .card-footer-action {
                margin-top: 8px !important;
                padding-top: 8px !important;
                border-top: 1px dashed #e2e8f0 !important;
                display: flex !important;
                flex-direction: row !important;
                align-items: center !important;
                justify-content: space-between !important;
                gap: 8px !important;
                background: transparent !important;
                padding: 0 !important;
                border: none !important;
            }

            .price-container {
                flex-direction: column !important;
            }

            .price-label {
                display: none !important;
            }

            .menu-price {
                font-size: 1.15rem !important;
            }

            .order-btn {
                padding: 8px 14px !important;
                height: 38px !important;
                font-size: 12.5px !important;
                border-radius: 30px !important;
                max-width: 125px !important;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <!-- HERO BANNER -->
    <div class="ck-menu-hero">
        <div class="hero-inner">
            <h1><i class="fas fa-bowl-food" style="color:var(--accent);"></i> Delicious Food, Delivered Fast!</h1>
            <p>Order your favorite meals fresh &amp; hot. Enjoy restaurant-quality food at your doorstep!</p>
        </div>
    </div>

    <!-- FLOATING FILTER BAR -->
    <div class="ck-filter-wrap">
        <div class="ck-filter-card">
            <div class="filter-row-grid">
                
                <div class="filter-group-item">
                    <label><i class="fas fa-magnifying-glass" style="color:var(--primary);"></i> Search Food Item</label>
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="filter-box" placeholder="Search dish by name..." AutoPostBack="true" OnTextChanged="FilterMenu"></asp:TextBox>
                </div>

                <div class="filter-group-item">
                    <label><i class="fas fa-utensils" style="color:var(--primary);"></i> Category</label>
                    <asp:DropDownList ID="ddlCategory" runat="server" CssClass="filter-box" AutoPostBack="true" OnSelectedIndexChanged="FilterMenu">
                        <asp:ListItem Text="All Categories" Value="0"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="filter-group-item">
                    <label><i class="fas fa-pepper-hot" style="color:var(--primary);"></i> Cuisine</label>
                    <asp:DropDownList ID="ddlCuisine" runat="server" CssClass="filter-box" AutoPostBack="true" OnSelectedIndexChanged="FilterMenu">
                        <asp:ListItem Text="All Cuisines" Value="0"></asp:ListItem>
                    </asp:DropDownList>
                </div>

            </div>
        </div>
    </div>

    <!-- SECTION TITLE -->
    <div class="ck-section-label">
        <h2>Our Menu</h2>
    </div>

    <!-- MENU DISH CARDS GRID -->
    <div class="ck-menu-grid">
        <asp:Repeater ID="rptMenuItems" runat="server">
            <ItemTemplate>
                <div class="menu-card">
                    <div class="card-img-wrap">
                        <img src='<%# Eval("m_image_url") %>' alt='<%# Eval("m_name") %>' />
                        <span class="card-badge"><i class="fas fa-star" style="color:#ffc107;"></i> Freshly Prepared</span>
                    </div>
                    <div class="card-body">
                        <h3><%# Eval("m_name") %></h3>
                        <p class="card-desc"><%# Eval("m_description") %></p>

                        <div class="menu-tags">
                            <span class="tag category-tag"><i class='<%# GetCategoryIcon(Eval("category_name")) %>'></i> <%# Eval("category_name") %></span>
                            <span class="tag cuisine-tag"><i class='<%# GetCuisineIcon(Eval("cuisine_name")) %>'></i> <%# Eval("cuisine_name") %></span>
                        </div>

                        <div class="card-footer-action">
                            <div class="price-container">
                                <span class="price-label">Price</span>
                                <span class="menu-price">₹<%# Eval("m_final_price", "{0:N2}") %></span>
                            </div>

                            <asp:Panel ID="Panel1" runat="server" CssClass="not-available-label" Visible='<%# Not Convert.ToBoolean(Eval("m_availability")) %>'>
                                <i class="fas fa-ban"></i> Unavailable
                            </asp:Panel>

                            <asp:LinkButton ID="btnOrderNow" runat="server" CssClass="order-btn" CommandName="OrderNow" CommandArgument='<%# Eval("m_id") %>' Visible='<%# Convert.ToBoolean(Eval("m_availability")) %>' OnCommand="OrderNow_Click">
                                <i class="fas fa-utensils"></i> Order Now
                            </asp:LinkButton>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>

    <!-- EMPTY STATE PANEL -->
    <asp:Panel ID="pnlempty" runat="server" Visible="false">
        <div class="menu-empty-container">
            <h2>No Menu Items Found</h2>
            <img src="../icons/em5.png" width="110" alt="No Items Found" style="margin: 16px 0;" />
            <p>We couldn't find any dishes matching your search or selected filters.</p>
            <a href="menu.aspx" class="empty-reset-btn"><i class="fas fa-rotate-left"></i> View All Menu Items</a>
        </div>
    </asp:Panel>

</asp:Content>
