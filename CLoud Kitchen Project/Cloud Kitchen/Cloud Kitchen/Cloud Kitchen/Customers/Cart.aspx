<%@ Page Title="Your Cart" Language="vb" AutoEventWireup="false" MasterPageFile="~/Customers/Customer.Master"
    CodeBehind="Cart.aspx.vb" Inherits="Cloud_Kitchen.Cart" MaintainScrollPositionOnPostback="true" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
        <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
        <link
            href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=DM+Sans:wght@300;400;500;600;700;800&family=Poppins:wght@400;500;600;700;800&display=swap"
            rel="stylesheet" />

        <style>
            :root {
                --primary: #4F7E76;
                --primary-dk: #355b54;
                --accent: #ff9f43;
                --danger: #dc2626;
                --danger-bg: #fee2e2;
                --success: #16a34a;
                --success-bg: #f0fdf4;
                --bg: #f8fafc;
                --card-bg: #ffffff;
                --text-main: #0f172a;
                --text-muted: #64748b;
                --border-light: #e2e8f0;
            }

            body {
                font-family: 'Poppins', system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
                background: #f1f5f9;
                color: var(--text-main);
            }

            /* ELEGANT HERO BANNER WITH BACKGROUND IMAGE */
            .ck-cart-hero {
                position: relative;
                width: 100%;
                min-height: 180px;
                background: linear-gradient(135deg, rgba(30, 50, 46, 0.85), rgba(79, 126, 118, 0.88)), url('../Images/cp8.jpeg') center/cover no-repeat;
                display: flex;
                align-items: center;
                justify-content: center;
                text-align: center;
                color: #ffffff;
                padding: 36px 20px;
                margin-bottom: 30px;
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.12);
            }

            .ck-cart-hero .hero-inner span {
                font-size: clamp(1.1rem, 3vw, 1.5rem);
                font-weight: 800;
                letter-spacing: 0.3px;
                background: rgba(255, 255, 255, 0.18);
                backdrop-filter: blur(12px);
                -webkit-backdrop-filter: blur(12px);
                padding: 12px 28px;
                border-radius: 50px;
                border: 1px solid rgba(255, 255, 255, 0.3);
                display: inline-block;
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
            }

            .cart-container-main {
                max-width: 1140px;
                margin: 0 auto 60px;
                padding: 0 20px;
                position: relative;
                z-index: 10;
            }

            /* PLAN 2 LAYOUT GRID & TABLE STYLING */
            .plan2-top-section {
                margin-bottom: 28px;
            }

            .plan2-bottom-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 28px;
                align-items: stretch;
            }

            @media (max-width: 900px) {
                .plan2-bottom-grid {
                    grid-template-columns: 1fr;
                }
            }

            .cart-card-box {
                background: #ffffff;
                border-radius: 20px;
                border: 1.5px solid #e2e8f0;
                box-shadow: 0 8px 24px rgba(15, 23, 42, 0.04);
                padding: 26px;
                box-sizing: border-box;
            }

            .cart-items-table-wrap {
                overflow-x: auto;
            }

            .cart-items-table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 10px;
            }

            .cart-items-table th {
                background: #f8fafc;
                color: #475569;
                font-size: 0.82rem;
                font-weight: 800;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                padding: 14px 16px;
                border-bottom: 2px solid #e2e8f0;
                text-align: left;
            }

            .cart-items-table td {
                padding: 16px;
                border-bottom: 1px solid #f1f5f9;
                vertical-align: middle;
            }

            .cart-table-dish-cell {
                display: flex;
                align-items: center;
                gap: 14px;
            }

            .cart-table-img {
                width: 58px;
                height: 58px;
                border-radius: 14px;
                object-fit: cover;
                border: 1.5px solid #e2e8f0;
                flex-shrink: 0;
            }

            .cart-box-title {
                font-size: 1.2rem;
                font-weight: 800;
                color: #0f172a;
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin-bottom: 20px;
                padding-bottom: 14px;
                border-bottom: 1.5px solid #f1f5f9;
            }

            /* CART ITEM STYLING - INDIVIDUAL CARD BOXES */
            .cart-item-card {
                display: flex;
                align-items: center;
                gap: 16px;
                padding: 16px 18px;
                background: #f8fafc;
                border-radius: 18px;
                border: 1.5px solid #e2e8f0;
                margin-bottom: 14px;
                transition: all 0.25s ease;
            }

            .cart-item-card:hover {
                background: #ffffff;
                border-color: #cbd5e1;
                transform: translateY(-2px);
                box-shadow: 0 8px 24px rgba(15, 23, 42, 0.06);
            }

            .cart-dish-img {
                width: 82px;
                height: 82px;
                border-radius: 16px;
                object-fit: cover;
                border: 1.5px solid #e2e8f0;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.04);
                flex-shrink: 0;
            }

            .cart-dish-info {
                flex: 1;
            }

            .cart-dish-name {
                font-size: 1.05rem;
                font-weight: 800;
                color: var(--text-dark);
                margin-bottom: 4px;
            }

            .cart-unit-price {
                font-size: 0.85rem;
                color: var(--text-muted);
                margin-bottom: 10px;
            }

            /* QUANTITY STEPPER BUTTONS - SLEEK PILL */
            .cart-stepper-wrap {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                background: #ffffff;
                border: 1.5px solid #cbd5e1;
                border-radius: 50px;
                padding: 3px 8px;
                box-shadow: 0 2px 6px rgba(0, 0, 0, 0.03);
            }

            .qty-step-btn {
                width: 30px !important;
                height: 30px !important;
                border-radius: 50% !important;
                background: #4F7E76 !important;
                color: #ffffff !important;
                border: none !important;
                display: inline-flex !important;
                align-items: center !important;
                justify-content: center !important;
                font-size: 15px !important;
                font-weight: 900 !important;
                line-height: 1 !important;
                cursor: pointer !important;
                text-decoration: none !important;
                transition: all 0.2s ease !important;
                box-shadow: 0 2px 6px rgba(79, 126, 118, 0.3) !important;
            }

            .qty-step-btn:hover {
                background: #355b54 !important;
                color: #ffffff !important;
                transform: scale(1.1) !important;
                box-shadow: 0 4px 10px rgba(53, 91, 84, 0.4) !important;
            }

            .qty-val-display {
                font-size: 1rem;
                font-weight: 800;
                color: #0f172a;
                min-width: 22px;
                text-align: center;
            }

            .cart-item-right {
                display: flex;
                flex-direction: column;
                align-items: flex-end;
                justify-content: space-between;
                gap: 12px;
                min-height: 72px;
            }

            .cart-item-total-price {
                font-size: 1.25rem;
                font-weight: 900;
                color: var(--primary);
                line-height: 1;
            }

            /* DELETE BUTTON - VISIBLE SVG TRASH BUTTON */
            .btn-remove-item {
                background: #fee2e2 !important;
                border: 1.5px solid #fca5a5 !important;
                width: 36px !important;
                height: 36px !important;
                border-radius: 50% !important;
                display: inline-flex !important;
                align-items: center !important;
                justify-content: center !important;
                cursor: pointer !important;
                text-decoration: none !important;
                transition: all 0.2s ease !important;
                box-shadow: 0 2px 6px rgba(220, 38, 38, 0.15) !important;
            }

            .btn-remove-item svg {
                stroke: #dc2626 !important;
                transition: stroke 0.2s ease !important;
            }

            .btn-remove-item:hover {
                background: #dc2626 !important;
                border-color: #dc2626 !important;
                transform: scale(1.1) !important;
                box-shadow: 0 4px 12px rgba(220, 38, 38, 0.35) !important;
            }

            .btn-remove-item:hover svg {
                stroke: #ffffff !important;
            }

            .add-more-bar {
                margin-top: 20px;
                padding-top: 16px;
                border-top: 1.5px solid #f1f5f9;
                display: flex;
                justify-content: flex-start;
            }

            .back-link-btn {
                background: #f1f5f9;
                color: var(--primary);
                font-weight: 800;
                font-size: 0.92rem;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 8px;
                padding: 10px 22px;
                border-radius: 50px;
                border: 1.5px solid #cbd5e1;
                transition: all 0.2s ease;
            }

            .back-link-btn:hover {
                background: var(--primary);
                color: #ffffff;
                border-color: var(--primary);
                transform: translateY(-2px);
                box-shadow: 0 4px 14px rgba(79, 126, 118, 0.3);
            }

            /* SUMMARY & FORM STYLING */
            .summary-box-wrap {
                background: #f8fafc;
                border-radius: 18px;
                padding: 18px 20px;
                border: 1.5px solid #e2e8f0;
                margin-bottom: 22px;
            }

            .summary-row {
                display: flex;
                justify-content: space-between;
                align-items: center;
                font-size: 0.94rem;
                color: #64748b;
                padding: 6px 0;
            }

            .summary-row.total-row {
                font-size: 1.25rem;
                font-weight: 900;
                color: #0f172a;
                padding-top: 14px;
                margin-top: 8px;
                border-top: 1.5px dashed #cbd5e1;
            }

            .badge-free-del {
                background: #dcfce7;
                color: #15803d;
                border: 1px solid #86efac;
                font-size: 11px;
                font-weight: 800;
                padding: 4px 12px;
                border-radius: 20px;
                letter-spacing: 0.5px;
                display: inline-flex;
                align-items: center;
            }

            .form-group-cart {
                margin-bottom: 18px;
            }

            .form-group-cart label {
                font-size: 12px;
                font-weight: 800;
                color: #475569;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                margin-bottom: 6px;
                display: block;
            }

            .ck-cart-field {
                width: 100%;
                padding: 12px 16px;
                border: 1.5px solid #cbd5e1;
                border-radius: 14px;
                font-size: 14px;
                outline: none;
                transition: all 0.2s;
                box-sizing: border-box;
                background: #ffffff;
                color: #0f172a;
            }

            .ck-cart-field:focus {
                border-color: var(--primary);
                box-shadow: 0 0 0 3.5px rgba(79, 126, 118, 0.18);
            }

            .btn-checkout-cta {
                width: 100%;
                background: linear-gradient(135deg, var(--primary) 0%, #355b54 100%);
                color: #ffffff;
                font-weight: 800;
                font-size: 1.05rem;
                padding: 15px;
                border-radius: 16px;
                border: none;
                cursor: pointer;
                transition: all 0.25s ease;
                box-shadow: 0 10px 25px rgba(79, 126, 118, 0.35);
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                margin-top: 14px;
            }

            .btn-checkout-cta:hover {
                transform: translateY(-2px);
                box-shadow: 0 14px 30px rgba(79, 126, 118, 0.45);
            }

            /* CLEAN SIMPLE ORDER PROCESSING OVERLAY */
            .ck-processing-overlay {
                position: fixed;
                inset: 0;
                background: rgba(15, 23, 42, 0.72);
                backdrop-filter: blur(8px);
                -webkit-backdrop-filter: blur(8px);
                z-index: 99999;
                display: none;
                align-items: center;
                justify-content: center;
                animation: fadeIn 0.25s ease;
            }

            .ck-processing-card {
                background: #ffffff;
                border-radius: 20px;
                padding: 32px 28px;
                width: min(380px, calc(100vw - 32px));
                text-align: center;
                box-shadow: 0 20px 50px rgba(0, 0, 0, 0.25);
                animation: popUp 0.25s ease;
            }

            .spinner-ring-wrap {
                position: relative;
                width: 64px;
                height: 64px;
                margin: 0 auto 16px;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .spinner-pulse-ring {
                position: absolute;
                inset: 0;
                border-radius: 50%;
                border: 3.5px solid #e2e8f0;
                border-top: 3.5px solid var(--primary);
                animation: spinRing 0.8s linear infinite;
            }

            .spinner-icon {
                font-size: 26px;
            }

            @keyframes spinRing {
                0% {
                    transform: rotate(0deg);
                }

                100% {
                    transform: rotate(360deg);
                }
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                }

                to {
                    opacity: 1;
                }
            }

            @keyframes popUp {
                from {
                    transform: scale(0.9);
                    opacity: 0;
                }

                to {
                    transform: scale(1);
                    opacity: 1;
                }
            }

            .proc-title {
                font-size: 1.25rem;
                font-weight: 800;
                color: #0f172a;
                margin: 0 0 6px;
            }

            .proc-subtitle {
                font-size: 0.9rem;
                color: #64748b;
                margin: 0;
                line-height: 1.4;
            }

            /* MODAL OVERLAY & POPUP */
            .overlay {
                position: fixed;
                inset: 0;
                background: rgba(15, 23, 42, 0.7);
                backdrop-filter: blur(6px);
                display: none;
                z-index: 2000;
            }

            .update-panel {
                position: fixed;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                background: #ffffff;
                border-radius: 20px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, .25);
                padding: 28px;
                width: min(500px, calc(100vw - 32px));
                z-index: 2050;
            }

            .ck-validator {
                font-size: 12px;
                font-weight: 700;
                color: #dc2626 !important;
                margin-top: 4px;
                display: block;
            }

            .ck-empty-cart {
                text-align: center;
                padding: 55px 20px;
            }

            .ck-empty-cart h2 {
                font-size: 1.7rem;
                font-weight: 800;
                color: var(--primary);
                margin: 14px 0 8px;
            }
        </style>
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        <div class="ck-cart-hero">
            <div class="hero-inner">
                <span>🍽️ Your favorite meals, prepared with love!</span>
            </div>
        </div>

        <div class="cart-container-main">
            <asp:Panel ID="pnlfill" runat="server">

                <!-- TOP SECTION: FULL-WIDTH CART ITEMS TABLE (AJAX UPDATED) -->
                <asp:UpdatePanel ID="upCart" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="true">
                    <ContentTemplate>
                        <div class="cart-card-box plan2-top-section">
                            <div class="cart-box-title">
                                <span><i class="fas fa-utensils" style="color:var(--primary);"></i> 1. Review Your
                                    Dishes</span>
                            </div>

                            <div class="cart-items-table-wrap">
                                <table class="cart-items-table">
                                    <thead>
                                        <tr>
                                            <th>Dish Item</th>
                                            <th>Unit Price</th>
                                            <th style="text-align:center;">Quantity</th>
                                            <th>Subtotal</th>
                                            <th style="text-align:center;">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <asp:Repeater ID="rptCartItems" runat="server" OnItemCommand="rptCartItems_ItemCommand">
                                            <ItemTemplate>
                                                <tr>
                                                    <td>
                                                        <div class="cart-table-dish-cell">
                                                            <img src='<%# GetValue(Container.DataItem, "m_image_url") %>'
                                                                alt="Dish" class="cart-table-img" />
                                                            <span
                                                                style="font-weight:800; color:#0f172a; font-size:1rem;">
                                                                <%# GetValue(Container.DataItem, "m_name" ) %>
                                                            </span>
                                                        </div>
                                                    </td>
                                                    <td style="color:#64748b; font-weight:700;">₹<%#
                                                            GetValue(Container.DataItem, "m_final_price" ) %>
                                                    </td>
                                                    <td style="text-align:center;">
                                                        <div class="cart-stepper-wrap" style="display:inline-flex;">
                                                            <asp:LinkButton ID="btnMinus" runat="server"
                                                                CssClass="qty-step-btn"
                                                                CommandName="Decrease"
                                                                CommandArgument='<%# GetValue(Container.DataItem, "m_id") %>'
                                                                CausesValidation="false"
                                                                title="Decrease Quantity">
                                                                <b>−</b>
                                                            </asp:LinkButton>
                                                            <span class="qty-val-display">
                                                                <%# GetValue(Container.DataItem, "quantity" ) %>
                                                            </span>
                                                            <asp:LinkButton ID="btnPlus" runat="server"
                                                                CssClass="qty-step-btn"
                                                                CommandName="Increase"
                                                                CommandArgument='<%# GetValue(Container.DataItem, "m_id") %>'
                                                                CausesValidation="false"
                                                                title="Increase Quantity">
                                                                <b>+</b>
                                                            </asp:LinkButton>
                                                        </div>
                                                    </td>
                                                    <td
                                                        style="color:var(--primary); font-weight:900; font-size:1.1rem;">
                                                        ₹<%# GetValue(Container.DataItem, "total_price" ) %>
                                                    </td>
                                                    <td style="text-align:center;">
                                                        <asp:LinkButton ID="btnRemove" runat="server"
                                                            CssClass="btn-remove-item"
                                                            CommandName="Remove"
                                                            CommandArgument='<%# GetValue(Container.DataItem, "m_id") %>'
                                                            CausesValidation="false"
                                                            title="Remove item from cart">
                                                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none"
                                                                stroke="#dc2626" stroke-width="2.5"
                                                                stroke-linecap="round" stroke-linejoin="round">
                                                                <polyline points="3 6 5 6 21 6"></polyline>
                                                                <path
                                                                    d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2">
                                                                </path>
                                                                <line x1="10" y1="11" x2="10" y2="17"></line>
                                                                <line x1="14" y1="11" x2="14" y2="17"></line>
                                                            </svg>
                                                        </asp:LinkButton>
                                                    </td>
                                                </tr>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </tbody>
                                </table>
                            </div>

                            <div class="add-more-bar">
                                <a href="Menu.aspx" class="back-link-btn"><i class="fas fa-plus"></i> Add More
                                    Dishes</a>
                            </div>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>

                <!-- BOTTOM SECTION: 50/50 SPLIT GRID FOR DELIVERY & SUMMARY -->
                <div class="plan2-bottom-grid">

                    <!-- LEFT BOX: DELIVERY ADDRESS (STATIC FORM - NO AJAX RE-RENDER ON QTY CLICK) -->
                    <div class="cart-card-box">
                        <div class="cart-box-title">
                            <span><i class="fas fa-location-dot" style="color:var(--primary);"></i> 2. Delivery
                                Address</span>
                        </div>

                        <div class="form-group-cart">
                            <label for="txtHouseNo">House / Flat / Building No.</label>
                            <asp:TextBox ID="txtHouseNo" runat="server" ClientIDMode="Static"
                                CssClass="ck-cart-field" placeholder="e.g. Flat 402, Sunshine Apartments">
                            </asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvHouseNo" runat="server"
                                ControlToValidate="txtHouseNo" ErrorMessage="⚠ Flat / House number is required."
                                CssClass="ck-validator" Display="Dynamic" ValidationGroup="DeliveryDetails"
                                EnableClientScript="true" ForeColor="#dc2626" />
                        </div>

                        <div class="form-group-cart">
                            <label for="txtStreet">Street / Area / Locality</label>
                            <asp:TextBox ID="txtStreet" runat="server" ClientIDMode="Static"
                                CssClass="ck-cart-field" placeholder="e.g. Near City Mall, MG Road">
                            </asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvStreet" runat="server"
                                ControlToValidate="txtStreet" ErrorMessage="⚠ Street / Area is required."
                                CssClass="ck-validator" Display="Dynamic" ValidationGroup="DeliveryDetails"
                                EnableClientScript="true" ForeColor="#dc2626" />
                        </div>

                        <div class="form-group-cart">
                            <label for="txtLandmark">Landmark (Optional)</label>
                            <asp:TextBox ID="txtLandmark" runat="server" ClientIDMode="Static"
                                CssClass="ck-cart-field" placeholder="e.g. Opp. HDFC Bank"></asp:TextBox>
                        </div>

                        <div class="form-group-cart" style="margin-bottom:0;">
                            <label for="ddlAreaPincode">Delivery Area & Pincode</label>
                            <asp:DropDownList ID="ddlAreaPincode" runat="server" ClientIDMode="Static"
                                CssClass="ck-cart-field">
                                <asp:ListItem Text="🚚 Select Delivery Area & Pincode" Value=""></asp:ListItem>
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvAreaPincode" runat="server"
                                ControlToValidate="ddlAreaPincode"
                                ErrorMessage="⚠ Please select your delivery area & pincode."
                                CssClass="ck-validator" InitialValue="" Display="Dynamic"
                                ValidationGroup="DeliveryDetails" EnableClientScript="true"
                                ForeColor="#dc2626" />
                        </div>
                    </div>

                    <!-- RIGHT BOX: ORDER SUMMARY & PAYMENT -->
                    <div class="cart-card-box">
                        <div class="cart-box-title">
                            <span><i class="fas fa-receipt" style="color:var(--primary);"></i> 3. Order Summary
                                & Payment</span>
                        </div>

                        <!-- TOTAL PRICE SUMMARY (AJAX UPDATED) -->
                        <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <div class="summary-box-wrap">
                                    <div class="summary-row">
                                        <span>Items Subtotal</span>
                                        <span style="font-weight:800; color:#0f172a; font-size:1.05rem;">₹<asp:Label
                                                ID="lblTotalPrice" runat="server" Text="0"></asp:Label></span>
                                    </div>
                                    <div class="summary-row">
                                        <span>Delivery Fee</span>
                                        <span class="badge-free-del">FREE DELIVERY</span>
                                    </div>
                                    <div class="summary-row">
                                        <span>Taxes & GST</span>
                                        <span style="color:#16a34a; font-weight:800;">Included</span>
                                    </div>

                                    <div class="summary-row total-row">
                                        <span>Grand Total</span>
                                        <span style="color:var(--primary); font-size: 1.35rem;">₹<asp:Label
                                                ID="lblGrandTotal" runat="server" Text="0"></asp:Label></span>
                                    </div>
                                </div>
                            </ContentTemplate>
                        </asp:UpdatePanel>

                                <div class="form-group-cart">
                                    <label for="ddlPaymentType">Payment Method</label>
                                    <asp:DropDownList ID="ddlPaymentType" runat="server" ClientIDMode="Static"
                                        CssClass="ck-cart-field">
                                        <asp:ListItem Value="">💳 Select Payment Method</asp:ListItem>
                                        <asp:ListItem Value="Cash on Delivery">💵 Cash on Delivery (COD)</asp:ListItem>
                                        <asp:ListItem Value="Razorpay">💳 Online Payment (UPI, Cards, NetBanking)
                                        </asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="rfvPaymentType" runat="server"
                                        ControlToValidate="ddlPaymentType"
                                        ErrorMessage="⚠ Please select a payment method." CssClass="ck-validator"
                                        InitialValue="" Display="Dynamic" ValidationGroup="DeliveryDetails"
                                        EnableClientScript="true" ForeColor="#dc2626" />
                                </div>

                                <asp:Button ID="btnCheckout" runat="server" Text="🛍️ Place Order Now"
                                    CssClass="btn-checkout-cta" ValidationGroup="DeliveryDetails"
                                    OnClick="Checkout_Click" OnClientClick="return onCheckoutClick(this);" />
                            </div>

                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>

                <div id="overlay" class="overlay"></div>

                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <asp:Panel ID="Panel2" runat="server" CssClass="update-panel" Visible="False">
                            <center>
                                <div id="dvLoader" runat="server" style="text-align:center; padding: 20px 0;">
                                    <i class="fas fa-spinner fa-spin"
                                        style="font-size: 40px; color: var(--primary); margin-bottom: 12px;"></i>
                                    <h3 style="font-size: 1.1rem; font-weight: 700; color: #0f172a;">Processing Order...
                                    </h3>
                                </div>
                                <div id="dvSuccess" runat="server" visible="false" style="text-align:center;">
                                    <i class="fas fa-circle-check"
                                        style="font-size: 55px; color: #16a34a; margin-bottom: 12px;"></i>
                                    <h2 style="font-size: 1.4rem; font-weight: 800; color: #16a34a; margin: 0 0 8px;">
                                        Order Confirmed!</h2>
                                    <p style="font-size: 14px; color: #64748b; margin-bottom: 16px;">
                                        Your payment was verified successfully.<br />
                                        Thank you for ordering with Cloud Kitchen!
                                    </p>
                                    <asp:Label ID="lblTransaction" runat="server" Font-Bold="true" ForeColor="#16a34a">
                                    </asp:Label>
                                    <br /><br />
                                    <asp:Button ID="Button1" runat="server" Text="Okay" CssClass="btn-checkout-cta"
                                        OnClientClick="closePanel(); return false;" />
                                </div>
                            </center>
                        </asp:Panel>
                        <asp:Timer ID="Timer1" runat="server" Interval="3000" Enabled="False" OnTick="Timer1_Tick">
                        </asp:Timer>
                    </ContentTemplate>
                </asp:UpdatePanel>

                <asp:Panel ID="up" runat="server" CssClass="update-panel" Visible="False">
                    <asp:Label ID="label1" runat="server" Visible="False"></asp:Label>
                    <asp:Panel ID="Panel1" runat="server" Visible="false">
                        <h3>Card Details</h3>
                        <div style="display:flex; gap:6px; margin-bottom:12px;">
                            <asp:TextBox ID="txtCard1" runat="server" MaxLength="4" CssClass="ck-cart-field"
                                style="text-align:center;"></asp:TextBox>
                            <asp:TextBox ID="txtCard2" runat="server" MaxLength="4" CssClass="ck-cart-field"
                                style="text-align:center;"></asp:TextBox>
                            <asp:TextBox ID="txtCard3" runat="server" MaxLength="4" CssClass="ck-cart-field"
                                style="text-align:center;"></asp:TextBox>
                            <asp:TextBox ID="txtCard4" runat="server" MaxLength="4" CssClass="ck-cart-field"
                                style="text-align:center;"></asp:TextBox>
                        </div>
                        <div style="display:flex; gap:10px; margin-bottom:12px;">
                            <asp:TextBox ID="txtExpiryMonth" runat="server" MaxLength="2" placeholder="MM"
                                CssClass="ck-cart-field"></asp:TextBox>
                            <asp:TextBox ID="txtExpiryYear" runat="server" MaxLength="2" placeholder="YY"
                                CssClass="ck-cart-field"></asp:TextBox>
                            <asp:TextBox ID="txtCCV" runat="server" MaxLength="3" placeholder="CVV"
                                CssClass="ck-cart-field"></asp:TextBox>
                        </div>
                        <asp:TextBox ID="txtCardName" runat="server" placeholder="Name on Card" CssClass="ck-cart-field"
                            style="margin-bottom:14px;"></asp:TextBox>
                        <asp:Button ID="btnPayNow" runat="server" Text="Verify Details" CssClass="btn-checkout-cta"
                            OnClick="btnPayNow_Click" />
                    </asp:Panel>

                    <asp:Panel ID="Panel3" runat="server" Visible="false">
                        <h3>Total Amount: ₹<asp:Label ID="lbltotamt" runat="server"></asp:Label>
                        </h3>
                        <div style="margin-bottom:14px;">
                            <label>Transaction PIN</label>
                            <asp:TextBox ID="txtpin" runat="server" MaxLength="6" TextMode="Password"
                                CssClass="ck-cart-field"></asp:TextBox>
                        </div>
                        <div style="display:flex; gap:10px;">
                            <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn-checkout-cta"
                                style="background:#64748b;" OnClick="btnCancel_Click" CausesValidation="false" />
                            <asp:Button ID="Button3" runat="server" Text="Pay Now" CssClass="btn-checkout-cta"
                                Enabled="False" />
                        </div>
                    </asp:Panel>
                </asp:Panel>

                <asp:HiddenField ID="hdnPaymentId" runat="server" />
                <asp:HiddenField ID="hdnOrderId" runat="server" />
            </asp:Panel>

            <!-- EMPTY CART STATE -->
            <asp:Panel ID="pnlempty" runat="server" Visible="false">
                <div class="cart-card-box ck-empty-cart">
                    <img src="../icons/empty1.png" alt="Empty Cart" style="width:160px; opacity:0.85;" />
                    <h2>Your Cart is Empty 🛒</h2>
                    <p style="color:#64748b;">Looks like you haven't added any delicious food yet!</p>
                    <a href="Menu.aspx" class="btn-checkout-cta"
                        style="display:inline-flex; width:auto; padding:12px 30px; margin-top:16px; text-decoration:none;">
                        🍽️ Browse Menu
                    </a>
                </div>
            </asp:Panel>
        </div>

        <script type="text/javascript">
            function onCheckoutClick(btn) {
                if (typeof (Page_ClientValidate) === 'function') {
                    if (!Page_ClientValidate('DeliveryDetails')) {
                        return false;
                    }
                }
                setTimeout(function () {
                    btn.disabled = true;
                    btn.value = "⏳ Processing Order...";
                }, 20);
                return true;
            }

            function showPanel() {
                var ov = document.getElementById("overlay");
                if (ov) ov.style.display = "block";
                var p2 = document.getElementById('<%= Panel2.ClientID %>');
                if (p2) p2.style.display = "block";
            }

            function closePanel() {
                var ov = document.getElementById("overlay");
                if (ov) ov.style.display = "none";
                var p2 = document.getElementById('<%= Panel2.ClientID %>');
                if (p2) p2.style.display = "none";
            }
        </script>
    </asp:Content>