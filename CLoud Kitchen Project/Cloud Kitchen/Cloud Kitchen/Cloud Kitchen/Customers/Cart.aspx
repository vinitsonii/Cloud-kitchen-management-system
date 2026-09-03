<%@ Page Title="Your Cart" Language="vb" AutoEventWireup="false" MasterPageFile="~/Customers/Customer.Master"
    CodeBehind="Cart.aspx.vb" Inherits="Cloud_Kitchen.Cart" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=DM+Sans:wght@300;400;500;600;700;800&family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet" />

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

        .ck-cart-hero {
            position: relative;
            width: 100%;
            min-height: 220px;
            background: linear-gradient(135deg, rgba(45, 78, 72, 0.94), rgba(79, 126, 118, 0.92)), url('../Images/cp8.jpeg') center/cover no-repeat;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            color: #fff;
            padding: 36px 20px;
        }

        .ck-cart-hero .hero-inner span {
            font-size: clamp(1.2rem, 3.5vw, 1.7rem);
            font-weight: 800;
            letter-spacing: .3px;
            background: rgba(255, 255, 255, 0.18);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            padding: 12px 28px;
            border-radius: 50px;
            border: 1px solid rgba(255, 255, 255, 0.3);
            display: inline-block;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        }

        .cart-container-main {
            max-width: 1140px;
            margin: -35px auto 60px;
            padding: 0 16px;
            position: relative;
            z-index: 10;
        }

        .cart-grid-2col {
            display: grid;
            grid-template-columns: 1.35fr 1fr;
            gap: 24px;
            align-items: start;
        }

        @media (max-width: 991px) {
            .cart-grid-2col {
                grid-template-columns: 1fr;
            }
        }

        .cart-card-box {
            background: #ffffff;
            border-radius: 24px;
            border: 1.5px solid #e2e8f0;
            box-shadow: 0 12px 36px rgba(15, 23, 42, 0.06);
            padding: 26px;
        }

        .cart-box-title {
            font-size: 1.25rem;
            font-weight: 800;
            color: #0f172a;
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
            padding-bottom: 14px;
            border-bottom: 1.5px solid #e2e8f0;
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
            box-shadow: 0 8px 24px rgba(15, 23, 42, 0.06);
            transform: translateY(-2px);
        }

        .cart-item-card:last-child {
            margin-bottom: 0;
        }

        .cart-dish-img {
            width: 88px;
            height: 88px;
            border-radius: 14px;
            object-fit: cover;
            flex-shrink: 0;
            border: 1.5px solid #cbd5e1;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }

        .cart-dish-info {
            flex: 1;
            min-width: 0;
        }

        .cart-dish-name {
            font-size: 1.1rem;
            font-weight: 800;
            color: #0f172a;
            margin: 0 0 3px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .cart-unit-price {
            font-size: 0.88rem;
            font-weight: 600;
            color: #64748b;
            margin-bottom: 8px;
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
            box-shadow: 0 2px 6px rgba(0,0,0,0.03);
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
            color: #16a34a;
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
            border-top: 1.5px solid #e2e8f0;
            display: flex;
            justify-content: flex-start;
        }

        .back-link-btn {
            background: #f1f5f9;
            color: var(--primary);
            font-weight: 700;
            font-size: 0.92rem;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
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
        .summary-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 0.95rem;
            color: #64748b;
            margin-bottom: 12px;
        }

        .summary-row.total-row {
            font-size: 1.35rem;
            font-weight: 900;
            color: #0f172a;
            padding-top: 14px;
            margin-top: 14px;
            border-top: 1.5px dashed #cbd5e1;
        }

        .badge-free-del {
            background: #f0fdf4;
            color: #166534;
            border: 1px solid #bbf7d0;
            font-size: 11px;
            font-weight: 800;
            padding: 4px 10px;
            border-radius: 12px;
            letter-spacing: 0.5px;
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
            border-radius: 12px;
            font-size: 14px;
            outline: none;
            transition: all 0.2s;
            box-sizing: border-box;
            background: #ffffff;
            color: #0f172a;
        }

        .ck-cart-field:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(79, 126, 118, 0.2);
        }

        .btn-checkout-cta {
            width: 100%;
            background: linear-gradient(135deg, var(--primary), var(--primary-dk));
            color: #ffffff;
            font-weight: 800;
            font-size: 1.05rem;
            padding: 15px;
            border-radius: 50px;
            border: none;
            cursor: pointer;
            transition: all 0.25s ease;
            box-shadow: 0 8px 24px rgba(79, 126, 118, 0.38);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            margin-top: 12px;
        }

        .btn-checkout-cta:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 30px rgba(79, 126, 118, 0.5);
            background: linear-gradient(135deg, #3f6861, #2d4e48);
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
            box-shadow: 0 20px 50px rgba(0,0,0,0.25);
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
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes popUp {
            from { transform: scale(0.9); opacity: 0; }
            to { transform: scale(1); opacity: 1; }
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
            box-shadow: 0 20px 60px rgba(0,0,0,.25);
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
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

    <div class="ck-cart-hero">
        <div class="hero-inner">
            <span>🍽️ Your favorite meals, prepared with love!</span>
        </div>
    </div>

    <div class="cart-container-main">
        <asp:Panel ID="pnlfill" runat="server">
            
            <!-- UPDATE PANEL WRAPS ENTIRE CART GRID TO PREVENT FULL PAGE REFRESH -->
            <asp:UpdatePanel ID="upCart" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <div class="cart-grid-2col">
                        
                        <!-- LEFT COLUMN: CART ITEMS -->
                        <div class="cart-card-box">
                            <div class="cart-box-title">
                                <span><i class="fas fa-cart-shopping" style="color:var(--primary);"></i> Your Cart Items</span>
                            </div>

                            <asp:Repeater ID="rptCartItems" runat="server">
                                <ItemTemplate>
                                    <div class="cart-item-card">
                                        <img src='<%# GetValue(Container.DataItem, "m_image_url") %>' alt="Dish" class="cart-dish-img" />
                                        <div class="cart-dish-info">
                                            <div class="cart-dish-name"><%# GetValue(Container.DataItem, "m_name") %></div>
                                            <div class="cart-unit-price">Price: ₹<%# GetValue(Container.DataItem, "m_final_price") %></div>
                                            
                                            <div class="cart-stepper-wrap">
                                                <asp:LinkButton ID="btnMinus" runat="server" CssClass="qty-step-btn" CommandArgument='<%# GetValue(Container.DataItem, "m_id") %>' OnCommand="DecreaseQuantity" CausesValidation="false" title="Decrease Quantity">
                                                    <b>−</b>
                                                </asp:LinkButton>
                                                <span class="qty-val-display"><%# GetValue(Container.DataItem, "quantity") %></span>
                                                <asp:LinkButton ID="btnPlus" runat="server" CssClass="qty-step-btn" CommandArgument='<%# GetValue(Container.DataItem, "m_id") %>' OnCommand="IncreaseQuantity" CausesValidation="false" title="Increase Quantity">
                                                    <b>+</b>
                                                </asp:LinkButton>
                                            </div>
                                        </div>

                                        <div class="cart-item-right">
                                            <span class="cart-item-total-price">₹<%# GetValue(Container.DataItem, "total_price") %></span>
                                            <asp:LinkButton ID="btnRemove" runat="server" CssClass="btn-remove-item" CommandArgument='<%# GetValue(Container.DataItem, "m_id") %>' OnCommand="RemoveCartItem" CausesValidation="false" title="Remove item from cart">
                                                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#dc2626" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                                    <polyline points="3 6 5 6 21 6"></polyline>
                                                    <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                                                    <line x1="10" y1="11" x2="10" y2="17"></line>
                                                    <line x1="14" y1="11" x2="14" y2="17"></line>
                                                </svg>
                                            </asp:LinkButton>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>

                            <div class="add-more-bar">
                                <a href="Menu.aspx" class="back-link-btn"><i class="fas fa-plus"></i> Add More Items</a>
                            </div>
                        </div>

                        <!-- RIGHT COLUMN: ORDER SUMMARY & DELIVERY DETAILS -->
                        <div class="cart-card-box">
                            <div class="cart-box-title">
                                <span><i class="fas fa-receipt" style="color:var(--primary);"></i> Order Summary</span>
                            </div>

                            <div class="summary-row">
                                <span>Items Subtotal</span>
                                <span style="font-weight:700; color:#0f172a;">₹<asp:Label ID="lblTotalPrice" runat="server" Text="0"></asp:Label></span>
                            </div>
                            <div class="summary-row">
                                <span>Delivery Fee</span>
                                <span class="badge-free-del">FREE DELIVERY</span>
                            </div>
                            <div class="summary-row">
                                <span>Taxes & GST</span>
                                <span style="color:#16a34a; font-weight:700;">Included</span>
                            </div>

                            <div class="summary-row total-row">
                                <span>Grand Total</span>
                                <span style="color:var(--primary);">₹<asp:Label ID="lblGrandTotal" runat="server" Text="0"></asp:Label></span>
                            </div>

                            <div style="margin-top: 22px; padding-top: 18px; border-top: 1.5px solid #e2e8f0;">
                                <h4 style="font-size: 0.95rem; font-weight: 800; color: #0f172a; margin-bottom: 14px;">
                                    <i class="fas fa-truck-fast" style="color:var(--primary);"></i> Delivery & Payment Details
                                </h4>

                                <div class="form-group-cart">
                                    <label for="txtHouseNo">House / Flat / Building No.</label>
                                    <asp:TextBox ID="txtHouseNo" runat="server" ClientIDMode="Static" CssClass="ck-cart-field" placeholder="e.g. Flat 402, Sunshine Apartments"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvHouseNo" runat="server" ControlToValidate="txtHouseNo" ErrorMessage="⚠ Flat / House number is required." CssClass="ck-validator" Display="Dynamic" ValidationGroup="DeliveryDetails" EnableClientScript="true" ForeColor="#dc2626" />
                                </div>

                                <div class="form-group-cart">
                                    <label for="txtStreet">Street / Area / Locality</label>
                                    <asp:TextBox ID="txtStreet" runat="server" ClientIDMode="Static" CssClass="ck-cart-field" placeholder="e.g. Near City Mall, MG Road"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvStreet" runat="server" ControlToValidate="txtStreet" ErrorMessage="⚠ Street / Area is required." CssClass="ck-validator" Display="Dynamic" ValidationGroup="DeliveryDetails" EnableClientScript="true" ForeColor="#dc2626" />
                                </div>

                                <div class="form-group-cart">
                                    <label for="txtLandmark">Landmark (Optional)</label>
                                    <asp:TextBox ID="txtLandmark" runat="server" ClientIDMode="Static" CssClass="ck-cart-field" placeholder="e.g. Opp. HDFC Bank"></asp:TextBox>
                                </div>

                                <div class="form-group-cart">
                                    <label for="ddlAreaPincode">Delivery Area & Pincode</label>
                                    <asp:DropDownList ID="ddlAreaPincode" runat="server" ClientIDMode="Static" CssClass="ck-cart-field">
                                        <asp:ListItem Text="📍 Select Delivery Area & Pincode" Value=""></asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="rfvAreaPincode" runat="server" ControlToValidate="ddlAreaPincode" ErrorMessage="⚠ Please select your delivery area & pincode." CssClass="ck-validator" InitialValue="" Display="Dynamic" ValidationGroup="DeliveryDetails" EnableClientScript="true" ForeColor="#dc2626" />
                                </div>

                                <div class="form-group-cart">
                                    <label for="ddlPaymentType">Payment Method</label>
                                    <asp:DropDownList ID="ddlPaymentType" runat="server" ClientIDMode="Static" CssClass="ck-cart-field">
                                        <asp:ListItem Value="">💳 Select Payment Method</asp:ListItem>
                                        <asp:ListItem Value="Cash on Delivery">💵 Cash on Delivery (COD)</asp:ListItem>
                                        <asp:ListItem Value="Razorpay">💳 Online Payment (UPI, Cards, NetBanking)</asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="rfvPaymentType" runat="server" ControlToValidate="ddlPaymentType" ErrorMessage="⚠ Please select a payment method." CssClass="ck-validator" InitialValue="" Display="Dynamic" ValidationGroup="DeliveryDetails" EnableClientScript="true" ForeColor="#dc2626" />
                                </div>

                                <asp:Button ID="btnCheckout" runat="server" Text="🚀 Place Order Now" CssClass="btn-checkout-cta" ValidationGroup="DeliveryDetails" OnClick="Checkout_Click" OnClientClick="return onCheckoutClick(this);" />
                            </div>

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
                                <i class="fas fa-spinner fa-spin" style="font-size: 40px; color: var(--primary); margin-bottom: 12px;"></i>
                                <h3 style="font-size: 1.1rem; font-weight: 700; color: #0f172a;">Processing Order...</h3>
                            </div>
                            <div id="dvSuccess" runat="server" visible="false" style="text-align:center;">
                                <i class="fas fa-circle-check" style="font-size: 55px; color: #16a34a; margin-bottom: 12px;"></i>
                                <h2 style="font-size: 1.4rem; font-weight: 800; color: #16a34a; margin: 0 0 8px;">Order Confirmed!</h2>
                                <p style="font-size: 14px; color: #64748b; margin-bottom: 16px;">
                                    Your payment was verified successfully.<br />
                                    Thank you for ordering with Cloud Kitchen!
                                </p>
                                <asp:Label ID="lblTransaction" runat="server" Font-Bold="true" ForeColor="#16a34a"></asp:Label>
                                <br /><br />
                                <asp:Button ID="Button1" runat="server" Text="Okay" CssClass="btn-checkout-cta" OnClientClick="closePanel(); return false;" />
                            </div>
                        </center>
                    </asp:Panel>
                    <asp:Timer ID="Timer1" runat="server" Interval="3000" Enabled="False" OnTick="Timer1_Tick"></asp:Timer>
                </ContentTemplate>
            </asp:UpdatePanel>

            <asp:Panel ID="up" runat="server" CssClass="update-panel" Visible="False">
                <asp:Label ID="label1" runat="server" Visible="False"></asp:Label>
                <asp:Panel ID="Panel1" runat="server" Visible="false">
                    <h3>Card Details</h3>
                    <div style="display:flex; gap:6px; margin-bottom:12px;">
                        <asp:TextBox ID="txtCard1" runat="server" MaxLength="4" CssClass="ck-cart-field" style="text-align:center;"></asp:TextBox>
                        <asp:TextBox ID="txtCard2" runat="server" MaxLength="4" CssClass="ck-cart-field" style="text-align:center;"></asp:TextBox>
                        <asp:TextBox ID="txtCard3" runat="server" MaxLength="4" CssClass="ck-cart-field" style="text-align:center;"></asp:TextBox>
                        <asp:TextBox ID="txtCard4" runat="server" MaxLength="4" CssClass="ck-cart-field" style="text-align:center;"></asp:TextBox>
                    </div>
                    <div style="display:flex; gap:10px; margin-bottom:12px;">
                        <asp:TextBox ID="txtExpiryMonth" runat="server" MaxLength="2" placeholder="MM" CssClass="ck-cart-field"></asp:TextBox>
                        <asp:TextBox ID="txtExpiryYear" runat="server" MaxLength="2" placeholder="YY" CssClass="ck-cart-field"></asp:TextBox>
                        <asp:TextBox ID="txtCCV" runat="server" MaxLength="3" placeholder="CVV" CssClass="ck-cart-field"></asp:TextBox>
                    </div>
                    <asp:TextBox ID="txtCardName" runat="server" placeholder="Name on Card" CssClass="ck-cart-field" style="margin-bottom:14px;"></asp:TextBox>
                    <asp:Button ID="btnPayNow" runat="server" Text="Verify Details" CssClass="btn-checkout-cta" OnClick="btnPayNow_Click" />
                </asp:Panel>

                <asp:Panel ID="Panel3" runat="server" Visible="false">
                    <h3>Total Amount: ₹<asp:Label ID="lbltotamt" runat="server"></asp:Label></h3>
                    <div style="margin-bottom:14px;">
                        <label>Transaction PIN</label>
                        <asp:TextBox ID="txtpin" runat="server" MaxLength="6" TextMode="Password" CssClass="ck-cart-field"></asp:TextBox>
                    </div>
                    <div style="display:flex; gap:10px;">
                        <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn-checkout-cta" style="background:#64748b;" OnClick="btnCancel_Click" CausesValidation="false" />
                        <asp:Button ID="Button3" runat="server" Text="Pay Now" CssClass="btn-checkout-cta" Enabled="False" />
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
                <a href="Menu.aspx" class="btn-checkout-cta" style="display:inline-flex; width:auto; padding:12px 30px; margin-top:16px; text-decoration:none;">
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
