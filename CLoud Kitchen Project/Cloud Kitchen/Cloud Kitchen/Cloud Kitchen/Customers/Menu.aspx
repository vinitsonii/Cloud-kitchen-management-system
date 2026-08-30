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
        .ck-menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(290px, 1fr));
            gap: 24px;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 16px 4rem;
        }

        .menu-card {
            background: var(--card-bg);
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.05);
            border: 1.5px solid var(--border);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .menu-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 14px 32px rgba(0, 0, 0, 0.1);
        }

        .card-img-wrap {
            width: 100%;
            height: 200px;
            overflow: hidden;
            position: relative;
            flex-shrink: 0;
        }

        .menu-card img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.4s ease;
            display: block;
        }

        .menu-card:hover img {
            transform: scale(1.06);
        }

        .card-body {
            padding: 18px;
            display: flex;
            flex-direction: column;
            flex: 1;
            gap: 8px;
        }

        .menu-card h3 {
            font-size: 1.3rem;
            line-height: 1.2;
            color: var(--text);
            margin: 0;
            font-weight: 800;
        }

        .menu-card p {
            font-size: 13px;
            color: var(--muted);
            margin: 0;
            line-height: 1.5;
            font-weight: 500;
        }

        .menu-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
            margin-top: 4px;
        }

        .tag {
            font-size: 11px;
            padding: 4px 10px;
            border-radius: 20px;
            font-weight: 700;
            color: #ffffff;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .category-tag { background: #2563eb; }
        .cuisine-tag { background: #16a34a; }

        .menu-price {
            font-size: 1.35rem;
            font-weight: 800;
            color: var(--primary);
            margin: 6px 0 0;
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
            padding: 6px 14px;
            border-radius: 8px;
            margin-top: 8px;
            width: fit-content;
        }

        .order-btn {
            margin-top: 10px;
            padding: 11px 20px;
            background: linear-gradient(135deg, var(--primary), var(--primary-dk));
            color: #ffffff;
            border: none;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
            box-shadow: 0 4px 14px rgba(79, 126, 118, 0.28);
            transition: transform 0.2s, box-shadow 0.2s;
            width: 100%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .order-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 7px 20px rgba(79, 126, 118, 0.4);
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

        /* RESPONSIVE MEDIA QUERIES */
        @media (max-width: 991px) {
            .filter-row-grid {
                grid-template-columns: 1fr 1fr;
            }
        }

        @media (max-width: 600px) {
            .filter-row-grid {
                grid-template-columns: 1fr;
            }

            .ck-menu-hero {
                min-height: 240px;
                padding: 40px 16px 60px;
            }

            .ck-menu-grid {
                grid-template-columns: 1fr;
                gap: 18px;
            }

            .card-img-wrap {
                height: 190px;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <!-- HERO BANNER -->
    <div class="ck-menu-hero">
        <div class="hero-inner">
            <h1><i class="fas fa-utensils" style="color:var(--accent);"></i> Delicious Food, Delivered Fast!</h1>
            <p>Order your favorite meals fresh &amp; hot. Enjoy restaurant-quality food at your doorstep!</p>
        </div>
    </div>

    <!-- FLOATING FILTER BAR -->
    <div class="ck-filter-wrap">
        <div class="ck-filter-card">
            <div class="filter-row-grid">
                
                <div class="filter-group-item">
                    <label><i class="fas fa-search" style="color:var(--primary);"></i> Search Food Item</label>
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="filter-box" placeholder="Search dish by name..." AutoPostBack="true" OnTextChanged="FilterMenu"></asp:TextBox>
                </div>

                <div class="filter-group-item">
                    <label><i class="fas fa-layer-group" style="color:var(--primary);"></i> Category</label>
                    <asp:DropDownList ID="ddlCategory" runat="server" CssClass="filter-box" AutoPostBack="true" OnSelectedIndexChanged="FilterMenu">
                        <asp:ListItem Text="All Categories" Value="0"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="filter-group-item">
                    <label><i class="fas fa-globe" style="color:var(--primary);"></i> Cuisine</label>
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
                    </div>
                    <div class="card-body">
                        <h3><%# Eval("m_name") %></h3>
                        <p><%# Eval("m_description") %></p>

                        <div class="menu-tags">
                            <span class="tag category-tag"><i class="fas fa-tag"></i> <%# Eval("category_name") %></span>
                            <span class="tag cuisine-tag"><i class="fas fa-globe"></i> <%# Eval("cuisine_name") %></span>
                        </div>

                        <p class="menu-price">₹<%# Eval("m_final_price", "{0:N2}") %></p>

                        <asp:Panel ID="Panel1" runat="server" CssClass="not-available-label" Visible='<%# Not Convert.ToBoolean(Eval("m_availability")) %>'>
                            <i class="fas fa-ban"></i> Currently Unavailable
                        </asp:Panel>

                        <asp:Button ID="btnOrderNow" runat="server" CssClass="order-btn" Text="Order Now" CommandArgument='<%# Eval("m_id") %>' Visible='<%# Convert.ToBoolean(Eval("m_availability")) %>' OnCommand="OrderNow_Click" />
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
