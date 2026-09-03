<%@ Page Title="Order Confirmation & Receipt" Language="vb" AutoEventWireup="false" MasterPageFile="~/Customers/Customer.Master" CodeBehind="OrderConfirmation.aspx.vb" Inherits="Cloud_Kitchen.OrderConfirmation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=DM+Sans:wght@300;400;500;600;700;800&family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

    <style>
        :root {
            --primary:    #4F7E76;
            --primary-dk: #3a5f59;
            --accent:     #ff9f43;
            --success:    #16a34a;
            --warning:    #d97706;
            --bg:         #f1f5f9;
            --card-bg:    #ffffff;
            --text:       #0f172a;
            --muted:      #64748b;
            --border:     #e2e8f0;
        }

        body {
            font-family: 'Poppins', system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            background: var(--bg);
            color: var(--text);
        }

        .ck-confirm-hero {
            position: relative;
            width: 100%;
            min-height: 260px;
            background: linear-gradient(135deg, rgba(15, 23, 42, 0.8), rgba(53, 91, 84, 0.85)),
                        url('../Images/lb8.jpeg') center/cover no-repeat;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            text-align: center;
            padding: 40px 20px 60px;
        }

        .ck-confirm-hero .hero-inner {
            position: relative;
            z-index: 2;
            max-width: 850px;
        }

        .ck-confirm-hero h1 {
            font-size: clamp(1.8rem, 4.5vw, 2.8rem);
            font-weight: 800;
            margin: 0;
            text-shadow: 0 4px 16px rgba(0,0,0,0.4);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            color: #ffffff;
        }

        .ck-confirm-hero p {
            font-size: clamp(0.92rem, 2vw, 1.05rem);
            color: rgba(255, 255, 255, 0.9);
            margin: 8px 0 0 0;
            line-height: 1.6;
            font-weight: 500;
        }

        .ck-confirm-card {
            max-width: 680px;
            margin: -50px auto 60px;
            background: var(--card-bg);
            border-radius: 24px;
            box-shadow: 0 15px 45px rgba(0, 0, 0, 0.12);
            overflow: hidden;
            position: relative;
            z-index: 10;
            border: 1px solid #ffffff;
            animation: ck-rise .65s cubic-bezier(.34,1.56,.64,1) both;
        }

        @keyframes ck-rise {
            from { opacity: 0; transform: translateY(32px) scale(.96); }
            to   { opacity: 1; transform: translateY(0) scale(1); }
        }

        .ck-confetti-bar {
            height: 6px;
            background: repeating-linear-gradient(
                90deg,
                var(--accent) 0 20px,
                var(--primary) 20px 40px,
                #ffffff 40px 60px,
                var(--success) 60px 80px
            );
        }

        .ck-card-header {
            background: linear-gradient(135deg, var(--primary), var(--primary-dk));
            padding: 2.2rem 2rem;
            text-align: center;
            color: #ffffff;
        }

        .ck-card-header h2 {
            font-size: clamp(1.4rem, 3.5vw, 1.9rem);
            font-weight: 800;
            margin: 0 0 .35rem;
            letter-spacing: -0.3px;
        }

        .ck-card-header p { font-size: 0.95rem; opacity: 0.92; margin: 0; font-weight: 500; }

        .ck-order-details { padding: 1.8rem 2rem 1rem; }

        .detail-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1rem;
            padding: 0.85rem 0;
            border-bottom: 1px dashed var(--border);
            font-size: 0.95rem;
        }

        .detail-row:last-child { border-bottom: none; }

        .detail-label {
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 600;
            color: var(--muted);
        }

        .detail-value {
            font-weight: 700;
            color: var(--text);
            text-align: right;
        }

        .detail-value.price { color: var(--primary); font-size: 1.25rem; font-weight: 800; }

        .status-badge {
            display: inline-flex !important;
            align-items: center !important;
            gap: 6px !important;
            padding: 6px 16px !important;
            border-radius: 50px !important;
            font-size: 0.82rem !important;
            font-weight: 800 !important;
            letter-spacing: 0.5px !important;
            text-transform: uppercase !important;
        }

        .status-pending {
            background: #fef3c7 !important;
            color: #b45309 !important;
            border: 1.5px solid #fcd34d !important;
        }

        .status-success {
            background: #dcfce7 !important;
            color: #15803d !important;
            border: 1.5px solid #86efac !important;
        }

        /* 📋 DISH ITEMS RECEIPT TABLE STYLING */
        .receipt-items-wrap {
            margin: 1.2rem 2rem 1.6rem;
            background: #f8fafc;
            border-radius: 16px;
            padding: 1.2rem;
            border: 1px solid #e2e8f0;
        }

        .receipt-table-title {
            font-size: 0.92rem;
            font-weight: 800;
            color: #334155;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .receipt-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.9rem;
        }

        .receipt-table th {
            text-align: left;
            padding: 8px 10px;
            background: #e2e8f0;
            color: #475569;
            font-weight: 700;
            border-radius: 6px;
            font-size: 0.8rem;
            text-transform: uppercase;
        }

        .receipt-table td {
            padding: 10px;
            border-bottom: 1px solid #f1f5f9;
            color: #1e293b;
            font-weight: 500;
        }

        .receipt-table tr:last-child td {
            border-bottom: none;
        }

        .receipt-table .text-right {
            text-align: right;
        }

        .receipt-table .text-center {
            text-align: center;
        }

        .ck-pending-panel {
            margin: 0 2rem 1.6rem;
            background: #fffbeb;
            border: 1.5px solid #fde68a;
            border-radius: 18px;
            padding: 1.4rem 1.6rem;
            text-align: center;
            box-shadow: 0 4px 16px rgba(217, 119, 6, 0.06);
        }

        .ck-pending-panel p {
            font-size: 0.93rem;
            color: #7a5c00;
            margin: 0 0 1rem;
            line-height: 1.65;
        }

        .ck-card-footer {
            padding: 0 2rem 2.2rem;
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            justify-content: center;
        }

        .ck-pill-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 0.75rem 1.6rem;
            border-radius: 50px;
            font-size: 0.9rem;
            font-weight: 700;
            text-decoration: none;
            border: 2px solid var(--primary);
            color: var(--primary);
            background: #ffffff;
            transition: all 0.2s ease;
            cursor: pointer;
        }

        .ck-pill-link:hover {
            background: var(--primary);
            color: #ffffff !important;
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(79, 126, 118, 0.25);
        }

        .btn-print {
            background: linear-gradient(135deg, var(--accent), #e67e22);
            border-color: var(--accent);
            color: #ffffff !important;
        }

        .btn-print:hover {
            background: linear-gradient(135deg, #e67e22, #d35400);
            border-color: #e67e22;
        }

        /* 🖨️ PRINT MEDIA STYLES FOR CLEAN INVOICE PRINTING */
        @media print {
            body { background: #ffffff !important; color: #000000 !important; }
            .ck-confirm-hero, .ck-card-footer, header, footer, nav, .navbar { display: none !important; }
            .ck-confirm-card {
                margin: 0 !important;
                box-shadow: none !important;
                border: 1px solid #ccc !important;
                max-width: 100% !important;
                width: 100% !important;
            }
            .ck-card-header { background: #4F7E76 !important; color: #ffffff !important; print-color-adjust: exact; -webkit-print-color-adjust: exact; }
            .receipt-items-wrap { background: #ffffff !important; border: 1px solid #ccc !important; }
        }

        @media (max-width: 600px) {
            .ck-confirm-card { margin: 15px auto 40px; border-radius: 18px; }
            .ck-order-details, .receipt-items-wrap, .ck-card-footer { padding-left: 1rem; padding-right: 1rem; }
            .detail-row { flex-direction: column; align-items: flex-start; gap: 4px; }
            .detail-value { text-align: left; }
        }
    </style>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="ck-confirm-hero">
        <div class="hero-inner">
            <h1><i class="fas fa-receipt" style="color:#ff9f43;"></i> Order Confirmation & Receipt</h1>
            <p>Thank you for choosing Cloud Kitchen! Here is your official order receipt.</p>
        </div>
    </div>

    <div class="ck-confirm-card">

        <div class="ck-confetti-bar"></div>

        <div class="ck-card-header">
            <h2>🎉 Thank You for Your Order!</h2>
            <p>Your fresh, delicious meal is being prepared with love! 🍽️</p>
        </div>

        <div class="ck-order-details">

            <div class="detail-row">
                <span class="detail-label"><i class="fas fa-hashtag" style="color:var(--primary);"></i> Order ID</span>
                <span class="detail-value">
                    #<asp:Label ID="lblOrderId" runat="server"></asp:Label>
                </span>
            </div>

            <div class="detail-row">
                <span class="detail-label"><i class="fas fa-barcode" style="color:var(--primary);"></i> Transaction Ref No.</span>
                <span class="detail-value">
                    <asp:Label ID="lblTransactionNumber" runat="server"></asp:Label>
                </span>
            </div>

            <div class="detail-row">
                <span class="detail-label"><i class="fas fa-clock" style="color:var(--primary);"></i> Date & Time (IST)</span>
                <span class="detail-value">
                    <asp:Label ID="lblOrderDate" runat="server"></asp:Label>
                </span>
            </div>

            <div class="detail-row">
                <span class="detail-label"><i class="fas fa-wallet" style="color:var(--primary);"></i> Payment Method</span>
                <span class="detail-value">
                    <asp:Label ID="lblPaymentType" runat="server"></asp:Label>
                </span>
            </div>

            <div class="detail-row">
                <span class="detail-label"><i class="fas fa-location-dot" style="color:var(--primary);"></i> Delivery Address</span>
                <span class="detail-value" style="max-width: 320px; line-height: 1.4;">
                    <asp:Label ID="lblAddress" runat="server"></asp:Label>
                </span>
            </div>

            <div class="detail-row">
                <span class="detail-label"><i class="fas fa-spinner" style="color:var(--primary);"></i> Order Status</span>
                <span class="detail-value">
                    <asp:Label ID="lblOrderStatus" runat="server" CssClass="status-badge status-pending"></asp:Label>
                </span>
            </div>

        </div>

        <!-- 📋 ORDER DISH ITEMS BREAKDOWN RECEIPT TABLE -->
        <div class="receipt-items-wrap">
            <div class="receipt-table-title">
                <i class="fas fa-utensils" style="color:var(--primary);"></i> Ordered Dishes Summary
            </div>
            <table class="receipt-table">
                <thead>
                    <tr>
                        <th>Dish Name</th>
                        <th class="text-center">Qty</th>
                        <th class="text-right">Price</th>
                        <th class="text-right">Total</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptReceiptItems" runat="server">
                        <ItemTemplate>
                            <tr>
                                <td><%# Eval("item_name") %></td>
                                <td class="text-center"><%# Eval("quantity") %></td>
                                <td class="text-right">₹<%# Convert.ToDecimal(Eval("price")).ToString("N2") %></td>
                                <td class="text-right" style="font-weight:700;">₹<%# Convert.ToDecimal(Eval("total_price")).ToString("N2") %></td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>
        </div>

        <!-- GRAND TOTAL SUMMARY ROW -->
        <div class="ck-order-details" style="padding-top: 0;">
            <div class="detail-row" style="border-top: 2px solid var(--border); padding-top: 1rem;">
                <span class="detail-label" style="font-size: 1.1rem; color: var(--text); font-weight: 800;">
                    <i class="fas fa-coins" style="color:var(--accent);"></i> Grand Total
                </span>
                <span class="detail-value price">
                    ₹<asp:Label ID="lblTotalAmount" runat="server"></asp:Label>
                </span>
            </div>
        </div>

        <asp:Panel ID="pnlPendingMessage" runat="server" Visible="false">
            <div class="ck-pending-panel">
                <p>⏳ Your order is currently <strong>Pending</strong>. Our kitchen is preparing it and will update you shortly!</p>
            </div>
        </asp:Panel>

        <div class="ck-card-footer">
            <button type="button" onclick="window.print();" class="ck-pill-link btn-print">
                <i class="fas fa-print"></i> Print Receipt
            </button>
            <a href="MyOrders.aspx" class="ck-pill-link">
                <i class="fas fa-boxes-stacked"></i> Track My Orders
            </a>
            <a href="Menu.aspx" class="ck-pill-link">
                <i class="fas fa-bowl-food"></i> Order More
            </a>
        </div>

    </div>

</asp:Content>
