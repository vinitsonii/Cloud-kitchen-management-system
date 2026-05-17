<%@ Page Title="Your Cart" Language="vb" AutoEventWireup="false" MasterPageFile="~/Customers/Customer.Master"
    CodeBehind="Cart.aspx.vb" Inherits="Cloud_Kitchen.Cart" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet" />

    <style>
        :root {
            --primary: #4F7E76;
            --primary-dk: #3a5f59;
            --accent: #ff9f43;
            --danger: #e74c3c;
            --danger-dk: #c0392b;
            --orange: #ff6600;
            --orange-dk: #e55c00;
            --success: #28a745;
            --bg: #f6f8f7;
            --card-bg: #ffffff;
            --text: #333;
            --muted: #666;
            --border: #e8e8e8;
            --input-focus: rgba(79,126,118,.22);
        }

        body {
            font-family: 'Poppins', system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            background: var(--bg);
            color: var(--text);
        }

        .ck-cart-hero {
            position: relative;
            width: 100%;
            min-height: 260px;
            background: url('../Images/cp8.jpeg') top center/cover no-repeat;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            color: #fff;
        }

            .ck-cart-hero::before {
                content: '';
                position: absolute;
                inset: 0;
                background: rgba(0,0,0,.55);
            }

            .ck-cart-hero .hero-inner {
                position: relative;
                z-index: 2;
                background: rgba(0,0,0,.35);
                backdrop-filter: blur(6px);
                border: 1px solid rgba(255,255,255,.12);
                border-radius: 14px;
                padding: 1.4rem 2.2rem;
            }

                .ck-cart-hero .hero-inner span {
                    font-family: 'Poppins', system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
                    font-size: clamp(1.2rem, 3.5vw, 1.8rem);
                    font-weight: 700;
                    letter-spacing: .3px;
                }

        .ck-cart-wrap {
            max-width: 860px;
            margin: -40px auto 60px;
            background: var(--card-bg);
            border-radius: 18px;
            box-shadow: 0 8px 40px rgba(0,0,0,.10);
            overflow: hidden;
            position: relative;
            z-index: 10;
        }

        @media (max-width: 575px) {
            .ck-cart-wrap {
                margin-top: 0;
                border-radius: 0;
            }
        }

        .ck-cart-header {
            padding: 1.6rem 2rem 1rem;
            border-bottom: 2px solid var(--border);
        }

            .ck-cart-header h2 {
                font-family: 'Poppins', system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
                font-size: clamp(1.4rem, 3vw, 1.9rem);
                color: var(--primary);
                margin: 0;
            }

        .cart-item {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1.1rem 1.6rem;
            border-bottom: 1px solid var(--border);
            transition: background .2s;
        }

            .cart-item:hover {
                background: #fafcfb;
            }

        .cart-img {
            width: 110px;
            height: 90px;
            border-radius: 10px;
            object-fit: cover;
            flex-shrink: 0;
            border: 2px solid var(--border);
        }

        @media (max-width: 480px) {
            .cart-item {
                flex-wrap: wrap;
            }

            .cart-img {
                width: 100%;
                height: 160px;
            }
        }

        .cart-item-details {
            flex: 1;
            min-width: 0;
        }

            .cart-item-details h3 {
                font-size: 1.05rem;
                font-weight: 600;
                color: var(--text);
                margin: 0 0 .3rem;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }

            .cart-item-details p {
                font-size: .88rem;
                color: var(--muted);
                margin: .2rem 0;
            }

            .cart-item-details .item-total {
                font-weight: 700;
                color: var(--primary);
                font-size: .95rem;
            }

        .qty-row {
            display: flex;
            align-items: center;
            gap: 8px;
            flex-wrap: wrap;
            margin-top: .4rem;
        }

        .quantity-box {
            width: 52px;
            text-align: center;
            padding: 5px 8px;
            border: 1.5px solid var(--border);
            border-radius: 8px;
            font-family: 'DM Sans', sans-serif;
            font-size: .9rem;
            outline: none;
            transition: border-color .2s;
        }

            .quantity-box:focus {
                border-color: var(--primary);
            }

        .update-btn, .remove-btn, .checkout-btn,
        .btn-pay, .btn-cancel, .btn-success, .btn1 {
            font-family: 'DM Sans', sans-serif;
            font-weight: 600;
            border: none;
            border-radius: 50px;
            cursor: pointer;
            transition: transform .18s, box-shadow .18s, background .2s;
        }

        .update-btn {
            background: var(--orange);
            color: #fff;
            padding: 6px 14px;
            font-size: .82rem;
        }

            .update-btn:hover {
                background: var(--orange-dk);
                transform: translateY(-1px);
            }

        .remove-btn {
            background: var(--danger);
            color: #fff;
            padding: 7px 14px;
            font-size: .82rem;
            white-space: nowrap;
            flex-shrink: 0;
        }

            .remove-btn:hover {
                background: var(--danger-dk);
                transform: translateY(-1px);
            }

        .checkout-btn, .btn1 {
            background: linear-gradient(135deg, var(--primary), var(--primary-dk));
            color: #fff;
            padding: .78rem 2rem;
            font-size: 1rem;
            box-shadow: 0 5px 16px rgba(79,126,118,.32);
        }

            .checkout-btn:hover, .btn1:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 24px rgba(79,126,118,.42);
            }

        .cart-footer {
            padding: 1rem 1.6rem;
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .grand-total-label {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--primary);
        }

        .back-link {
            display: inline-block;
            color: var(--primary);
            font-size: .9rem;
            font-weight: 500;
            text-decoration: none;
            padding: .4rem .8rem;
            border-radius: 6px;
            transition: background .2s;
        }

            .back-link:hover {
                background: rgba(79,126,118,.08);
                text-decoration: none;
            }

        .delivery-section {
            padding: 1.4rem 1.6rem 0;
            border-top: 2px solid var(--border);
        }

            .delivery-section h2 {
                font-family: 'Playfair Display', serif;
                font-size: 1.35rem;
                color: var(--primary);
                margin-bottom: 1.2rem;
            }

        .ck-label {
            display: block;
            font-size: .85rem;
            font-weight: 600;
            color: #3a4a5b;
            margin-bottom: .4rem;
        }

        .ck-input {
            width: 100%;
            padding: .7rem 1rem;
            border: 1.5px solid var(--border);
            border-radius: 10px;
            font-family: 'DM Sans', sans-serif;
            font-size: .93rem;
            background: #fafbfc;
            outline: none;
            transition: border-color .25s, box-shadow .25s;
            box-sizing: border-box;
            resize: none;
        }

            .ck-input:focus {
                border-color: var(--primary);
                box-shadow: 0 0 0 3px var(--input-focus);
                background: #fff;
            }

        .error-message {
            font-size: .78rem;
            color: #e35a3c;
        }

        .checkout-action {
            padding: 1.4rem 1.6rem 2rem;
            display: flex;
            justify-content: center;
        }

        .overlay {
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,.68);
            backdrop-filter: blur(5px);
            display: none;
            z-index: 2000;
        }

        .update-panel {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: var(--card-bg);
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0,0,0,.28);
            padding: 2rem;
            width: 92%;
            max-width: 520px;
            max-height: 88vh;
            overflow-y: auto;
            z-index: 2050;
            animation: ck-pop-in .4s cubic-bezier(.34,1.56,.64,1) both;
        }

        @keyframes ck-pop-in {
            from {
                opacity: 0;
                transform: translate(-50%,-50%) scale(.88);
            }

            to {
                opacity: 1;
                transform: translate(-50%,-50%) scale(1);
            }
        }

        .payment-box {
            width: 100%;
        }

            .payment-box h3 {
                font-family: 'Poppins', system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
                font-size: 1.3rem;
                color: var(--primary);
                text-align: center;
                margin-bottom: 1.2rem;
            }

        .input-group {
            margin-bottom: 1rem;
        }

            .input-group label {
                display: block;
                font-size: .83rem;
                font-weight: 600;
                color: #3a4a5b;
                margin-bottom: .38rem;
            }

            .input-group input,
            .input-group .txtarea {
                width: 100%;
                padding: .65rem .9rem;
                border: 1.5px solid var(--border);
                border-radius: 8px;
                font-family: 'DM Sans', sans-serif;
                font-size: .93rem;
                outline: none;
                transition: border-color .2s, box-shadow .2s;
                box-sizing: border-box;
            }

                .input-group input:focus {
                    border-color: var(--primary);
                    box-shadow: 0 0 0 3px var(--input-focus);
                }

        .card-number {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

            .card-number input,
            .card-number .card-input {
                flex: 1;
                min-width: 52px;
                text-align: center;
                padding: .65rem .4rem;
                border: 1.5px solid var(--border);
                border-radius: 8px;
                font-size: 1rem;
                font-weight: 600;
                letter-spacing: 3px;
                outline: none;
                transition: border-color .2s;
                box-sizing: border-box;
            }

                .card-number input:focus,
                .card-number .card-input:focus {
                    border-color: var(--primary);
                }

        .button-group {
            display: flex;
            gap: 12px;
            margin-top: 1.2rem;
        }

        .btn-cancel {
            flex: 1;
            padding: .75rem;
            background: var(--orange);
            color: #fff;
            border-radius: 50px;
            font-size: .95rem;
        }

            .btn-cancel:hover {
                background: var(--orange-dk);
            }

        .btn-pay {
            flex: 1;
            padding: .75rem;
            background: linear-gradient(135deg, var(--success), #1e7e34);
            color: #fff;
            border-radius: 50px;
            font-size: .95rem;
            box-shadow: 0 4px 14px rgba(40,167,69,.3);
        }

            .btn-pay:hover {
                transform: translateY(-1px);
                box-shadow: 0 6px 20px rgba(40,167,69,.38);
            }

        .success-panel {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 260px;
        }

        .success-box {
            text-align: center;
            padding: 1.5rem;
        }

        .success-icon {
            width: 72px;
            height: 72px;
            margin-bottom: .8rem;
        }

        .success-message {
            font-family: 'Poppins', system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--success);
        }

        .success-text {
            font-size: .97rem;
            color: var(--muted);
            margin-top: .6rem;
            line-height: 1.65;
        }

        .transaction-id {
            font-weight: 700;
            color: var(--text);
        }

        .btn-success {
            margin-top: 1.2rem;
            background: var(--success);
            color: #fff;
            padding: .72rem 2rem;
            border-radius: 50px;
            font-size: .95rem;
            box-shadow: 0 4px 14px rgba(40,167,69,.3);
        }

            .btn-success:hover {
                background: #218838;
                transform: translateY(-1px);
            }

        /* loader */
        .loader-box {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 200px;
            gap: .8rem;
        }

        .spinner {
            width: 48px;
            height: 48px;
            border: 5px solid #f0f0f0;
            border-top-color: var(--primary);
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            to {
                transform: rotate(360deg);
            }
        }

        .loading-text {
            font-size: 1rem;
            color: var(--muted);
            font-weight: 600;
        }

        .ck-empty-cart {
            text-align: center;
            padding: 4rem 2rem;
        }

            .ck-empty-cart img {
                width: 180px;
                opacity: .85;
                margin-bottom: 1.2rem;
            }

            .ck-empty-cart h2 {
                font-family: 'Poppins', system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
                font-size: 1.6rem;
                color: var(--primary);
                margin-bottom: .6rem;
            }

            .ck-empty-cart p {
                color: var(--muted);
                font-size: .97rem;
            }

            .ck-empty-cart .shop-btn {
                display: inline-block;
                margin-top: 1.4rem;
                padding: .78rem 2rem;
                background: linear-gradient(135deg, var(--primary), var(--primary-dk));
                color: #fff;
                border-radius: 50px;
                text-decoration: none;
                font-weight: 600;
                box-shadow: 0 5px 16px rgba(79,126,118,.32);
                transition: transform .2s, box-shadow .2s;
            }

                .ck-empty-cart .shop-btn:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 8px 24px rgba(79,126,118,.42);
                    color: #fff;
                }


        .ck-validator {
            display: block;
            font-size: .78rem;
            font-weight: 500;
            color: #e35a3c !important;
            margin-top: .28rem;
            min-height: 0;
            line-height: 1.4;
        }

        span.ck-validator[style*="visibility:hidden"],
        span.ck-validator[style*="display:none"] {
            display: none !important;
        }

        .ck-input.input-error,
        .quantity-box.input-error {
            border-color: #e35a3c !important;
            box-shadow: 0 0 0 3px rgba(231,76,60,.15) !important;
        }

        .ck-input:valid {
            border-color: var(--border);
        }

        body.modal-open {
            overflow: hidden;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="ck-cart-hero">
        <div class="hero-inner">
            <span>🍽️ Your favorite meals, just a click away!</span>
        </div>
    </div>

    <asp:Panel ID="pnlfill" runat="server">
        <div class="ck-cart-wrap">

            <div class="ck-cart-header">
                <h2>Your Cart 🛒</h2>
            </div>

            <asp:Repeater ID="rptCartItems" runat="server">
                <ItemTemplate>
                    <div class="cart-item">
                        <img src='<%# GetValue(Container.DataItem, "m_image_url") %>' alt="Dish" class="cart-img" />
                        <div class="cart-item-details">
                            <h3><%# GetValue(Container.DataItem, "m_name") %></h3>
                            <p>Price: ₹<%# GetValue(Container.DataItem, "m_final_price") %></p>
                            <div class="qty-row">
                                <span style="font-size: .85rem; color: var(--muted);">Qty:</span>
                                <asp:TextBox ID="txtQuantity" MaxLength="2" runat="server"
                                    Text='<%# GetValue(Container.DataItem, "quantity") %>'
                                    CssClass="quantity-box"></asp:TextBox>
                                <asp:Button ID="btnUpdate" runat="server" Text="Update"
                                    CommandArgument='<%# GetValue(Container.DataItem, "m_id") %>'
                                    OnCommand="UpdateCartItem" CssClass="update-btn" />
                            </div>
                            <p class="item-total">Total: ₹<%# GetValue(Container.DataItem, "total_price") %></p>
                        </div>
                        <asp:Button ID="btnRemove" runat="server" Text="❌ Remove"
                            CommandArgument='<%# GetValue(Container.DataItem, "m_id") %>'
                            OnCommand="RemoveCartItem" CssClass="remove-btn" />
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                <ContentTemplate>

                    <div class="cart-footer">
                        <a href="Menu.aspx" class="back-link">⬅ Add Moree...</a>
                        <span class="grand-total-label">Grand Total: ₹<asp:Label ID="lblTotalPrice" runat="server" Text="0"></asp:Label>
                        </span>
                    </div>

                    <div class="delivery-section">
                        <h2 style="font-family: 'DM Sans', sans-serif;">Delivery Details 🚚</h2>

                        <div class="row g-3">
                            <div class="col-12">
                                <label class="ck-label">Address</label>
                                <asp:TextBox ID="txtAddress" runat="server"
                                    TextMode="MultiLine" Rows="3"
                                    CssClass="ck-input"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvAddress" runat="server"
                                    ControlToValidate="txtAddress"
                                    ErrorMessage="⚠ Address is required."
                                    CssClass="ck-validator" Display="Dynamic"
                                    ValidationGroup="DeliveryDetails"
                                    EnableClientScript="true"
                                    ForeColor="Red"></asp:RequiredFieldValidator>
                            </div>

                            <div class="col-12 col-sm-6">
                                <label class="ck-label">Pincode</label>
                                <asp:DropDownList ID="ddlpincode" runat="server" CssClass="ck-input">
                                    <asp:ListItem Text="🌍 Select Pincode" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvPincode" runat="server"
                                    ControlToValidate="ddlpincode"
                                    ErrorMessage="⚠ Please select a pincode."
                                    CssClass="ck-validator" InitialValue="0"
                                    Display="Dynamic" ValidationGroup="DeliveryDetails"
                                    EnableClientScript="true"
                                    ForeColor="Red"></asp:RequiredFieldValidator>
                            </div>

                            <div class="col-12 col-sm-6">
                                <label class="ck-label">Payment Type</label>
                                <asp:DropDownList ID="ddlPaymentType" runat="server"
                                    CssClass="ck-input" AutoPostBack="true">
                                    <asp:ListItem Value="">💵 Select Payment Type</asp:ListItem>
                                    <asp:ListItem Value="Cash on Delivery">Cash on Delivery</asp:ListItem>
                                    <asp:ListItem Value="Razorpay">Razorpay</asp:ListItem>
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvPaymentType" runat="server"
                                    ControlToValidate="ddlPaymentType"
                                    ErrorMessage="⚠ Please select a payment method."
                                    CssClass="ck-validator" InitialValue=""
                                    Display="Dynamic" ValidationGroup="DeliveryDetails"
                                    EnableClientScript="true"
                                    ForeColor="Red"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                    </div>

                    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

                    <div id="overlay" class="overlay"></div>

                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>
                            <asp:Panel ID="Panel2" runat="server" CssClass="update-panel success-panel" Visible="False">
                                <center>
                                    <div id="dvLoader" runat="server" class="loader-box">
                                        <div class="spinner"></div>
                                        <h3 class="loading-text">Processing Payment...</h3>
                                    </div>
                                    <div id="dvSuccess" runat="server" class="success-box" visible="false">
                                        <img src="../icons/complete.png" alt="Success" class="success-icon" />
                                        <h2 class="success-message">Payment Successful!</h2>
                                        <p class="success-text">
                                            Your card details have been verified successfully.<br />
                                            Thank you for your order!
                                        </p>
                                        <asp:Label ID="Label2" runat="server" CssClass="transaction-label" Visible="False"></asp:Label>
                                        <asp:Label ID="lblTransaction" runat="server" CssClass="transaction-id" Visible="False"></asp:Label>
                                        <br />
                                        <br />
                                        <asp:Button ID="Button1" runat="server" Text="Okay"
                                            CssClass="btn-success checkout-btn"
                                            OnClientClick="closePanel(); return false;" />
                                    </div>
                                </center>
                            </asp:Panel>
                            <asp:Timer ID="Timer1" runat="server" Interval="3000" Enabled="False" OnTick="Timer1_Tick"></asp:Timer>
                        </ContentTemplate>
                    </asp:UpdatePanel>

                    <script type="text/javascript">
                        function showPanel() {
                            document.getElementById("overlay").style.display = "block";
                            document.getElementById('<%= Panel2.ClientID %>').style.display = "block";
                            document.body.classList.add("modal-open");
                        }
                        function closePanel() {
                            document.getElementById("overlay").style.display = "none";
                            document.getElementById('<%= Panel2.ClientID %>').style.display = "none";
                            document.body.classList.remove("modal-open");
                        }
                    </script>

                    <asp:Panel ID="up" runat="server" CssClass="update-panel" Visible="False">
                        <div class="input-group text-center">
                            <asp:Label ID="label1" runat="server" CssClass="transaction-label" Visible="False"></asp:Label>
                        </div>

                        <asp:Panel ID="Panel1" runat="server" Visible="false">
                            <div class="payment-box">
                                <h3>Card Details</h3>
                                <hr style="border: none; height: 3px; background: linear-gradient(to right,var(--primary),var(--accent)); border-radius: 2px; margin-bottom: 1.4rem;" />

                                <div class="input-group">
                                    <label>Credit Card Number</label>
                                    <div class="card-number">
                                        <asp:TextBox ID="txtCard1" runat="server" MaxLength="4" CssClass="card-input"></asp:TextBox>
                                        <asp:TextBox ID="txtCard2" runat="server" MaxLength="4" CssClass="card-input"></asp:TextBox>
                                        <asp:TextBox ID="txtCard3" runat="server" MaxLength="4" CssClass="card-input"></asp:TextBox>
                                        <asp:TextBox ID="txtCard4" runat="server" MaxLength="4" CssClass="card-input"></asp:TextBox>
                                    </div>
                                    <asp:ValidationSummary ID="vsCardValidation" runat="server" ForeColor="Red"
                                        HeaderText="Card Number Error:" ShowMessageBox="False" ShowSummary="True"
                                        ValidationGroup="PaymentGroup" />
                                    <asp:RequiredFieldValidator ID="rfvCard" runat="server" ControlToValidate="txtCard1" ForeColor="Red" ErrorMessage="Card number is required" ValidationGroup="PaymentGroup" Display="None" />
                                    <asp:RequiredFieldValidator ID="rfvCard2" runat="server" ControlToValidate="txtCard2" ForeColor="Red" ErrorMessage="Card number is required" ValidationGroup="PaymentGroup" Display="None" />
                                    <asp:RequiredFieldValidator ID="rfvCard3" runat="server" ControlToValidate="txtCard3" ForeColor="Red" ErrorMessage="Card number is required" ValidationGroup="PaymentGroup" Display="None" />
                                    <asp:RequiredFieldValidator ID="rfvCard4" runat="server" ControlToValidate="txtCard4" ForeColor="Red" ErrorMessage="Card number is required" ValidationGroup="PaymentGroup" Display="None" />
                                    <asp:RegularExpressionValidator ID="revCardNumber" runat="server" ControlToValidate="txtCard1" ForeColor="Red" ErrorMessage="Invalid card number (must be 4 digits each)" ValidationGroup="PaymentGroup" ValidationExpression="\d{4}" Display="None" />
                                    <asp:RegularExpressionValidator ID="revCardNumber2" runat="server" ControlToValidate="txtCard2" ForeColor="Red" ErrorMessage="Invalid card number (must be 4 digits each)" ValidationGroup="PaymentGroup" ValidationExpression="\d{4}" Display="None" />
                                    <asp:RegularExpressionValidator ID="revCardNumber3" runat="server" ControlToValidate="txtCard3" ForeColor="Red" ErrorMessage="Invalid card number (must be 4 digits each)" ValidationGroup="PaymentGroup" ValidationExpression="\d{4}" Display="None" />
                                    <asp:RegularExpressionValidator ID="revCardNumber4" runat="server" ControlToValidate="txtCard4" ForeColor="Red" ErrorMessage="Invalid card number (must be 4 digits each)" ValidationGroup="PaymentGroup" ValidationExpression="\d{4}" Display="None" />
                                </div>

                                <div class="row g-3">
                                    <div class="col-6">
                                        <div class="input-group">
                                            <label>Expiry Month</label>
                                            <asp:TextBox ID="txtExpiryMonth" runat="server" MaxLength="2" placeholder="MM" CssClass="ck-input"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="rfvExpiryMonth" runat="server" ControlToValidate="txtExpiryMonth" ForeColor="Red" ErrorMessage="Expiry month required" ValidationGroup="PaymentGroup" Display="Dynamic" EnableClientScript="true" />
                                            <asp:RegularExpressionValidator ID="revExpiryMonth" runat="server" ControlToValidate="txtExpiryMonth" ForeColor="Red" ErrorMessage="Invalid month (01-12)" ValidationGroup="PaymentGroup" Display="Dynamic" ValidationExpression="^(0[1-9]|1[0-2])$" />
                                        </div>
                                    </div>
                                    <div class="col-6">
                                        <div class="input-group">
                                            <label>Expiry Year</label>
                                            <asp:TextBox ID="txtExpiryYear" runat="server" MaxLength="2" placeholder="YY" CssClass="ck-input"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="rfvExpiryYear" runat="server" ControlToValidate="txtExpiryYear" ForeColor="Red" ErrorMessage="Expiry year required" ValidationGroup="PaymentGroup" Display="Dynamic" EnableClientScript="true" />
                                            <asp:RegularExpressionValidator ID="revExpiryYear" runat="server" ControlToValidate="txtExpiryYear" ForeColor="Red" ErrorMessage="Invalid year (e.g., 24, 25)" ValidationGroup="PaymentGroup" Display="Dynamic" ValidationExpression="^\d{2}$" />
                                        </div>
                                    </div>
                                    <div class="col-6">
                                        <div class="input-group">
                                            <label>CVV</label>
                                            <asp:TextBox ID="txtCCV" runat="server" MaxLength="3" placeholder="CVV" CssClass="ck-input"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="rfvCCV" runat="server" ControlToValidate="txtCCV" ForeColor="Red" ErrorMessage="CVV required" ValidationGroup="PaymentGroup" Display="Dynamic" EnableClientScript="true" />
                                            <asp:RegularExpressionValidator ID="revCCV" runat="server" ControlToValidate="txtCCV" ForeColor="Red" ErrorMessage="Invalid CVV (3 digits)" ValidationGroup="PaymentGroup" ValidationExpression="^\d{3}$" Display="Dynamic" />
                                        </div>
                                    </div>
                                    <div class="col-6">
                                        <div class="input-group">
                                            <label>Name on Card</label>
                                            <asp:TextBox ID="txtCardName" runat="server" placeholder="Full Name" CssClass="ck-input"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="rfvCardName" runat="server" ControlToValidate="txtCardName" ForeColor="Red" ErrorMessage="Name required" ValidationGroup="PaymentGroup" Display="Dynamic" EnableClientScript="true" />
                                            <asp:RegularExpressionValidator ID="revCardName" runat="server" ControlToValidate="txtCardName" ForeColor="Red" ErrorMessage="Invalid name (letters only)" ValidationGroup="PaymentGroup" ValidationExpression="^[A-Za-z ]{3,50}$" Display="Dynamic" />
                                        </div>
                                    </div>
                                </div>

                                <div class="button-group mt-3">
                                    <asp:Button ID="btnPayNow" runat="server" Text="Verify Details"
                                        CssClass="btn-pay checkout-btn"
                                        OnClick="btnPayNow_Click"
                                        ValidationGroup="PaymentGroup" />

                                </div>
                            </div>
                        </asp:Panel>

                        <asp:Panel ID="Panel3" runat="server" Visible="false">
                            <div class="input-group text-center">
                                <h3 style="color: var(--primary); font-family: 'Playfair Display',serif;">Total Amount:
                                    <asp:Label ID="lbltotamt" runat="server" CssClass="transaction-label"></asp:Label>
                                </h3>
                            </div>
                            <div class="input-group">
                                <label>Transaction PIN</label>
                                <asp:TextBox ID="txtpin" runat="server" MaxLength="6"
                                    placeholder="Enter 6-digit PIN" TextMode="Password"
                                    CssClass="ck-input"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtpin" ForeColor="Red" ErrorMessage="Transaction PIN required." ValidationGroup="PaymentGroup1" Display="Dynamic" EnableClientScript="true" />
                                <asp:RegularExpressionValidator ID="revPin" runat="server" ControlToValidate="txtpin" ForeColor="Red" ErrorMessage="PIN must be exactly 6 digits." ValidationGroup="PaymentGroup1" Display="Dynamic" ValidationExpression="^\d{6}$" />
                            </div>
                            <div class="button-group">
                                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn-cancel checkout-btn" OnClick="btnCancel_Click" />
                                <asp:Button ID="Button3" runat="server" Text="Pay Now" CssClass="btn-pay checkout-btn" ValidationGroup="PaymentGroup1" Enabled="False" />
                            </div>
                        </asp:Panel>
                    </asp:Panel>

                </ContentTemplate>
            </asp:UpdatePanel>

            <div class="checkout-action">
                <asp:Button ID="btnCheckout" runat="server"
                    Text="🚀 Proceed to Order"
                    CssClass="checkout-btn btn1"
                    ValidationGroup="DeliveryDetails"
                    OnClick="Checkout_Click" />
            </div>
            <%--            <button type="button"
    id="rzp-button1"
    class="btn-pay checkout-btn"
    style="width:100%;">
    Pay with Razorpay
</button>--%>
            <asp:HiddenField ID="hdnPaymentId" runat="server" />
            <asp:HiddenField ID="hdnOrderId" runat="server" />

        </div>
    </asp:Panel>

    <asp:Panel ID="pnlempty" runat="server" Visible="false">
        <div class="ck-cart-wrap" style="margin-top: 2rem;">
            <div class="ck-empty-cart">
                <img src="../icons/empty1.png" alt="Empty Cart" />
                <h2>Your Cart is Empty 🛒</h2>
                <p>Looks like you haven't added anything yet!</p>
                <a href="Menu.aspx" class="shop-btn">🍽️ Browse Menu</a>
            </div>
        </div>
    </asp:Panel>


    <script type="text/javascript">

        document.addEventListener('DOMContentLoaded', function () {

            if (typeof Page_Validators !== 'undefined') {
                var origValidate = ValidatorValidate;
                ValidatorValidate = function (val, validationGroup, event) {
                    origValidate(val, validationGroup, event);
                    var ctrl = document.getElementById(val.controltovalidate);
                    if (!ctrl) return;
                    if (!val.isvalid) {
                        ctrl.classList.add('input-error');
                    } else {
                        ctrl.classList.remove('input-error');
                    }
                };
            }

            document.querySelectorAll('.ck-input, .quantity-box, .card-input').forEach(function (el) {
                ['input', 'change'].forEach(function (evt) {
                    el.addEventListener(evt, function () {
                        el.classList.remove('input-error');
                        if (typeof Page_Validators !== 'undefined') {
                            Page_Validators.forEach(function (v) {
                                if (v.controltovalidate === el.id) {
                                    ValidatorValidate(v);
                                }
                            });
                        }
                    });
                });
            });

            var cardBoxes = document.querySelectorAll('.card-input');
            cardBoxes.forEach(function (box, idx) {
                box.addEventListener('input', function () {
                    if (box.value.length >= 4 && idx < cardBoxes.length - 1) {
                        cardBoxes[idx + 1].focus();
                    }
                });
            });
        });

    </script>
    <script>

        function startRazorPay() {

            var amount = document.getElementById('<%= lblTotalPrice.ClientID %>').innerText;

            amount = parseFloat(amount) * 100;

            var options = {

                "key": "rzp_test_Sq7x7OL1DUIl17",

                "amount": amount,

                "currency": "INR",

                "name": "Cloud Kitchen",

                "description": "Food Order Payment",

                "image": "../Images/logo.png",

                "handler": function (response) {

                    document.getElementById('<%= hdnPaymentId.ClientID %>').value =
                    response.razorpay_payment_id;

                alert("Payment Successful");

                __doPostBack('PaymentSuccess', '');
            },

            "prefill": {

                "name": "<%= Session("username") %>",

                "email": "<%= Session("UserEmail") %>",

                    "contact": "9999999999"
                },

                "theme": {
                    "color": "#4F7E76"
                }

            };

            var rzp1 = new Razorpay(options);

            rzp1.open();
        }

        document.addEventListener("DOMContentLoaded", function () {

            var btn = document.getElementById("rzp-button1");

            if (btn) {

                btn.addEventListener("click", function () {

                    startRazorPay();

                });

            }

        });

    </script>
    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
</asp:Content>
