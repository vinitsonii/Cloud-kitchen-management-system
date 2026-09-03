<%@ Page Title="Your Cart" Language="vb" AutoEventWireup="false" MasterPageFile="~/Customers/Customer.Master"
    CodeBehind="Cart.aspx.vb" Inherits="Cloud_Kitchen.Cart" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=DM+Sans:wght@300;400;500;600;700;800&family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet" />

    <style>
        :root {
            --primary: #4F7E76;
            --primary-dk: #355b54;
            --accent: #ff9f43;
            --danger: #dc2626;
            --danger-bg: #fef2f2;
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
            min-height: 200px;
            background: linear-gradient(135deg, rgba(79, 126, 118, 0.92), rgba(53, 91, 84, 0.95)), url('../Images/cp8.jpeg') center/cover no-repeat;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            color: #fff;
            padding: 30px 20px;
        }

        .ck-cart-hero .hero-inner span {
            font-size: clamp(1.2rem, 3.5vw, 1.7rem);
            font-weight: 800;
            letter-spacing: .3px;
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(10px);
            padding: 10px 24px;
            border-radius: 50px;
            border: 1px solid rgba(255, 255, 255, 0.25);
            display: inline-block;
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
            border-radius: 20px;
            border: 1.5px solid #e2e8f0;
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.05);
            padding: 24px;
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

        /* CART ITEM STYLING */
        .cart-item-card {
            display: flex;
            align-items: center;
            gap: 16px;
            padding: 16px 0;
            border-bottom: 1px solid #f1f5f9;
        }

        .cart-item-card:last-child {
            border-bottom: none;
        }

        .cart-dish-img {
            width: 90px;
            height: 90px;
            border-radius: 14px;
            object-fit: cover;
            flex-shrink: 0;
            border: 1.5px solid #e2e8f0;
        }

        .cart-dish-info {
            flex: 1;
            min-width: 0;
        }

        .cart-dish-name {
            font-size: 1.05rem;
            font-weight: 700;
            color: #0f172a;
            margin: 0 0 4px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .cart-unit-price {
            font-size: 0.88rem;
            color: #64748b;
            margin-bottom: 8px;
        }

        .cart-stepper-wrap {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #f8fafc;
            border: 1.5px solid #cbd5e1;
            border-radius: 50px;
            padding: 3px 8px;
        }

        .qty-step-btn {
            width: 28px;
            height: 28px;
            border-radius: 50%;
            background: #ffffff;
            border: 1px solid #cbd5e1;
            color: #334155;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 11px;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.2s;
        }

        .qty-step-btn:hover {
            background: var(--primary);
            color: #ffffff;
            border-color: var(--primary);
        }

        .qty-val-display {
            font-size: 0.95rem;
            font-weight: 800;
            color: #0f172a;
            min-width: 20px;
            text-align: center;
        }

        .cart-item-right {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 8px;
        }

        .cart-item-total-price {
            font-size: 1.1rem;
            font-weight: 800;
            color: #16a34a;
        }

        .btn-remove-item {
            background: #fef2f2;
            color: #dc2626;
            border: 1px solid #fecaca;
            width: 34px;
            height: 34px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 13px;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.2s;
        }

        .btn-remove-item:hover {
            background: #dc2626;
            color: #ffffff;
            border-color: #dc2626;
        }

        .add-more-bar {
            margin-top: 18px;
            padding-top: 14px;
            border-top: 1.5px solid #e2e8f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .back-link-btn {
            color: var(--primary);
            font-weight: 700;
            font-size: 0.92rem;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s;
        }

        .back-link-btn:hover {
            color: var(--primary-dk);
            transform: translateX(-3px);
        }

        /* SUMMARY & FORM STYLING */
        .summary-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 0.92rem;
            color: #64748b;
            margin-bottom: 10px;
        }

        .summary-row.total-row {
            font-size: 1.25rem;
            font-weight: 800;
            color: #0f172a;
            padding-top: 12px;
            margin-top: 12px;
            border-top: 1.5px dashed #cbd5e1;
        }

        .badge-free-del {
            background: #f0fdf4;
            color: #166534;
            border: 1px solid #bbf7d0;
            font-size: 11px;
            font-weight: 800;
            padding: 3px 8px;
            border-radius: 12px;
        }

        .form-group-cart {
            margin-bottom: 16px;
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
            padding: 11px 14px;
            border: 1.5px solid #cbd5e1;
            border-radius: 10px;
            font-size: 14px;
            outline: none;
            transition: all 0.2s;
            box-sizing: border-box;
            background: #ffffff;
        }

        .ck-cart-field:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(79, 126, 118, 0.18);
        }

        .btn-checkout-cta {
            width: 100%;
            background: linear-gradient(135deg, var(--primary), var(--primary-dk));
            color: #ffffff;
            font-weight: 800;
            font-size: 1rem;
            padding: 14px;
            border-radius: 50px;
            border: none;
            cursor: pointer;
            transition: all 0.25s;
            box-shadow: 0 6px 20px rgba(79, 126, 118, 0.35);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            margin-top: 10px;
        }

        .btn-checkout-cta:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 26px rgba(79, 126, 118, 0.45);
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
            padding: 50px 20px;
        }

        .ck-empty-cart h2 {
            font-size: 1.6rem;
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
                                        <asp:LinkButton ID="btnMinus" runat="server" CssClass="qty-step-btn" CommandArgument='<%# GetValue(Container.DataItem, "m_id") %>' OnCommand="DecreaseQuantity" CausesValidation="false">
                                            <i class="fas fa-minus"></i>
                                        </asp:LinkButton>
                                        <span class="qty-val-display"><%# GetValue(Container.DataItem, "quantity") %></span>
                                        <asp:LinkButton ID="btnPlus" runat="server" CssClass="qty-step-btn" CommandArgument='<%# GetValue(Container.DataItem, "m_id") %>' OnCommand="IncreaseQuantity" CausesValidation="false">
                                            <i class="fas fa-plus"></i>
                                        </asp:LinkButton>
                                    </div>
                                </div>

                                <div class="cart-item-right">
                                    <span class="cart-item-total-price">₹<%# GetValue(Container.DataItem, "total_price") %></span>
                                    <asp:LinkButton ID="btnRemove" runat="server" CssClass="btn-remove-item" CommandArgument='<%# GetValue(Container.DataItem, "m_id") %>' OnCommand="RemoveCartItem" CausesValidation="false" title="Remove item">
                                        <i class="fas fa-trash-can"></i>
                                    </asp:LinkButton>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>

                    <div class="add-more-bar">
                        <a href="Menu.aspx" class="back-link-btn"><i class="fas fa-arrow-left"></i> Add More Items</a>
                    </div>
                </div>

                <!-- RIGHT COLUMN: ORDER SUMMARY & DELIVERY DETAILS -->
                <div class="cart-card-box">
                    <div class="cart-box-title">
                        <span><i class="fas fa-receipt" style="color:var(--primary);"></i> Order Summary</span>
                    </div>

                    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                        <ContentTemplate>
                            <div class="summary-row">
                                <span>Items Subtotal</span>
                                <span>₹<asp:Label ID="lblTotalPrice" runat="server" Text="0"></asp:Label></span>
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

                            <div style="margin-top: 20px; padding-top: 16px; border-top: 1.5px solid #e2e8f0;">
                                <h4 style="font-size: 0.95rem; font-weight: 800; color: #0f172a; margin-bottom: 14px;">
                                    <i class="fas fa-truck-fast" style="color:var(--primary);"></i> Delivery & Payment Details
                                </h4>

                                <div class="form-group-cart">
                                    <label for="txtAddress">Delivery Address</label>
                                    <asp:TextBox ID="txtAddress" runat="server" TextMode="MultiLine" Rows="3" CssClass="ck-cart-field" placeholder="Enter complete delivery address with street and landmark..."></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvAddress" runat="server" ControlToValidate="txtAddress" ErrorMessage="⚠ Delivery address is required." CssClass="ck-validator" Display="Dynamic" ValidationGroup="DeliveryDetails" EnableClientScript="true" ForeColor="#dc2626" />
                                </div>

                                <div class="form-group-cart">
                                    <label for="ddlpincode">Delivery Pincode</label>
                                    <asp:DropDownList ID="ddlpincode" runat="server" CssClass="ck-cart-field">
                                        <asp:ListItem Text="📍 Select Pincode" Value=""></asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="rfvPincode" runat="server" ControlToValidate="ddlpincode" ErrorMessage="⚠ Please select a valid pincode." CssClass="ck-validator" InitialValue="" Display="Dynamic" ValidationGroup="DeliveryDetails" EnableClientScript="true" ForeColor="#dc2626" />
                                </div>

                                <div class="form-group-cart">
                                    <label for="ddlPaymentType">Payment Method</label>
                                    <asp:DropDownList ID="ddlPaymentType" runat="server" CssClass="ck-cart-field" AutoPostBack="true">
                                        <asp:ListItem Value="">💵 Select Payment Method</asp:ListItem>
                                        <asp:ListItem Value="Cash on Delivery">Cash on Delivery</asp:ListItem>
                                        <asp:ListItem Value="Razorpay">Razorpay</asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="rfvPaymentType" runat="server" ControlToValidate="ddlPaymentType" ErrorMessage="⚠ Please select a payment method." CssClass="ck-validator" InitialValue="" Display="Dynamic" ValidationGroup="DeliveryDetails" EnableClientScript="true" ForeColor="#dc2626" />
                                </div>

                                <asp:Button ID="btnCheckout" runat="server" Text="🚀 Place Order Now" CssClass="btn-checkout-cta" ValidationGroup="DeliveryDetails" OnClick="Checkout_Click" />
                            </div>

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
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>

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
