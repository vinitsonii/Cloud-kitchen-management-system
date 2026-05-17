<%@ Page Title="My Orders" Language="vb" AutoEventWireup="false" MasterPageFile="~/Customers/Customer.Master" CodeBehind="MyOrders.aspx.vb" Inherits="Cloud_Kitchen.MyOrders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet" />

    <style>
        :root {
            --primary:    #4F7E76;
            --primary-dk: #3a5f59;
            --accent:     #ff9f43;
            --blue:       #007BFF;
            --blue-dk:    #0056b3;
            --success:    #4CAF50;
            --warning:    #ff9800;
            --danger:     #e74c3c;
            --bg:         #f4f7f6;
            --card-bg:    #ffffff;
            --text:       #333;
            --muted:      #666;
            --border:     #eaeaea;
        }

        body { font-family: 'Poppins', system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;; background: var(--bg); color: var(--text); }

        .ck-orders-hero {
            font-family: 'Poppins', system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            position: relative;
            min-height: 280px;
            background: linear-gradient(rgba(0,0,0,.52), rgba(0,0,0,.52)),
                        url('../Images/img9.jpg') center/cover no-repeat;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            text-align: center;
            overflow: hidden;
        }

        .ck-orders-hero::after {
            content: '';
            position: absolute;
            bottom: 0; left: 0; right: 0;
            height: 40px;
            background: linear-gradient(to top, var(--bg), transparent);
        }

        .ck-orders-hero .hero-inner {
            position: relative; z-index: 2;
            display: flex; align-items: center; gap: 1rem;
        }

        .ck-orders-hero .hero-icon {
            width: 52px;
            filter: drop-shadow(0 2px 10px rgba(255,255,255,.4));
        }

        .ck-orders-hero h1 {
            font-family: 'Poppins', system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            font-size: clamp(1.6rem, 4.5vw, 2.4rem);
            margin: 0;
            text-shadow: 0 2px 14px rgba(0,0,0,.45);
        }

        @media (max-width:575px) { .ck-orders-hero { min-height: 200px; } }

        .ck-orders-wrap {
            max-width: 1280px;
            margin: -30px auto 60px;
            padding: 0 1rem;
            position: relative; z-index: 10;
        }

        .ck-filter-card {
            background: var(--card-bg);
            border-radius: 16px;
            box-shadow: 0 8px 32px rgba(0,0,0,.08);
            padding: 1.4rem 1.8rem;
            margin-bottom: 2rem;
            border-top: 4px solid var(--primary);
            position: relative;
            overflow: hidden;
        }

        .ck-filter-card .filter-row {
            display: flex;
            flex-wrap: wrap;
            align-items: flex-end;
            gap: 1rem;
        }

        .ck-filter-group {
            display: flex;
            flex-direction: column;
            gap: .35rem;
            flex: 1;
            min-width: 160px;
        }

        .ck-filter-group label {
            font-size: .82rem;
            font-weight: 600;
            color: var(--muted);
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .styled-dropdown, .styled-input {
            padding: .65rem 1rem;
            font-size: .93rem;
           font-family: 'Poppins', system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            border: 1.5px solid var(--border);
            border-radius: 10px;
            background: #fafbfc;
            color: var(--text);
            transition: border-color .25s, box-shadow .25s;
            outline: none;
            width: 100%;
            box-sizing: border-box;
        }

        .styled-dropdown:focus, .styled-input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(79,126,118,.18);
            background: #fff;
        }

        .btn-filter {
            padding: .7rem 1.8rem;
            font-family: 'Poppins', system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            font-size: .93rem;
            font-weight: 600;
            color: #fff;
            background: linear-gradient(135deg, var(--primary), var(--primary-dk));
            border: none;
            border-radius: 50px;
            cursor: pointer;
            box-shadow: 0 4px 14px rgba(79,126,118,.3);
            transition: transform .2s, box-shadow .2s;
            white-space: nowrap;
            align-self: flex-end;
        }

        .btn-filter:hover { transform: translateY(-2px); box-shadow: 0 7px 20px rgba(79,126,118,.4); }

        .orders-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(420px, 1fr));
            gap: 22px;
        }

        @media (max-width:767px) { .orders-grid { grid-template-columns: 1fr; } }
        @media (max-width:480px) { .orders-grid { grid-template-columns: 1fr; gap: 14px; } }

        .order-card {
            background: var(--card-bg);
            border-radius: 16px;
            box-shadow: 0 6px 24px rgba(0,0,0,.07);
            border: 1px solid var(--border);
            overflow: hidden;
            transition: transform .35s, box-shadow .35s;
            animation: ck-fadein .5s ease both;
            position: relative;
        }

        .order-card::before {
            content: '';
            position: absolute;
            left: 0; top: 0; bottom: 0;
            width: 5px;
            background: linear-gradient(to bottom, var(--primary), var(--accent));
            border-radius: 4px 0 0 4px;
        }

        .order-card:hover { transform: translateY(-6px); box-shadow: 0 14px 36px rgba(0,0,0,.12); }

        @keyframes ck-fadein {
            from { opacity: 0; transform: translateY(20px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .orders-grid > div:nth-child(1) .order-card { animation-delay: .05s; }
        .orders-grid > div:nth-child(2) .order-card { animation-delay: .12s; }
        .orders-grid > div:nth-child(3) .order-card { animation-delay: .19s; }
        .orders-grid > div:nth-child(4) .order-card { animation-delay: .26s; }
        .orders-grid > div:nth-child(5) .order-card { animation-delay: .33s; }
        .orders-grid > div:nth-child(6) .order-card { animation-delay: .40s; }

        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: .5rem;
            padding: 1.1rem 1.4rem 1rem 1.6rem;
            border-bottom: 1px solid var(--border);
            background: #fafcfb;
        }

        .order-header .order-id {
            font-family: 'Poppins', system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            font-size: 1rem;
            font-weight: 700;
            color: var(--primary);
        }

        .order-header .order-date {
            font-size: .8rem;
            color: var(--muted);
            background: #f0f4f3;
            padding: 3px 10px;
            border-radius: 20px;
        }

        .order-body { padding: 1rem 1.4rem 1rem 1.6rem; }

        .order-info {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            padding: .42rem 0;
            font-size: .88rem;
            color: var(--muted);
            border-bottom: 1px solid #f5f5f5;
            transition: color .2s;
        }

        .order-info:last-child { border-bottom: none; }
        .order-info:hover { color: var(--primary); }

        .order-info .oi-icon {
            width: 28px; height: 28px;
            background: rgba(79,126,118,.1);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            flex-shrink: 0;
        }

        .order-info .oi-icon img { width: 16px; }

        .order-info strong { color: var(--text); margin-right: 4px; }

        .status {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 4px 14px;
            border-radius: 20px;
            font-size: .78rem;
            font-weight: 700;
            letter-spacing: .4px;
            text-transform: uppercase;
        }

        .status-pending   { background: linear-gradient(45deg,#ff9800,#ff5722); color:#fff; }
        .status-completed { background: linear-gradient(45deg,#4CAF50,#009688); color:#fff; }
        .status-cancelled { background: linear-gradient(45deg,#e74c3c,#c0392b); color:#fff; }

        .order-items {
            margin: .8rem 1.4rem .8rem 1.6rem;
            background: #f8faf9;
            border-radius: 10px;
            border: 1px solid var(--border);
            overflow: hidden;
        }

        .order-items-title {
            font-size: .82rem;
            font-weight: 700;
            color: var(--muted);
            text-transform: uppercase;
            letter-spacing: .5px;
            padding: .6rem 1rem;
            border-bottom: 1px solid var(--border);
            background: #f0f4f3;
        }

        .item-row {
            display: flex;
            justify-content: space-between;
            padding: .55rem 1rem;
            font-size: .87rem;
            border-bottom: 1px solid #efefef;
            color: var(--text);
            transition: background .2s;
        }

        .item-row:last-child { border-bottom: none; }
        .item-row:hover { background: rgba(79,126,118,.05); }

        .item-row span:last-child { font-weight: 700; color: var(--primary); }

        .order-card-footer {
            padding: .9rem 1.4rem 1.2rem 1.6rem;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            border-top: 1px solid var(--border);
        }

        .btn-reorder, .btn-print {
            flex: 1;
            min-width: 110px;
            padding: .65rem 1rem;
            font-family: 'DM Sans', sans-serif;
            font-size: .85rem;
            font-weight: 600;
            border: none;
            border-radius: 50px;
            cursor: pointer;
            transition: transform .2s, box-shadow .2s;
            text-align: center;
        }

        .btn-reorder {
            background: linear-gradient(135deg, var(--blue), var(--blue-dk));
            color: #fff;
            box-shadow: 0 4px 12px rgba(0,123,255,.22);
        }

        .btn-reorder:hover { transform: translateY(-2px); box-shadow: 0 7px 18px rgba(0,123,255,.32); }

        .btn-print {
            background: linear-gradient(135deg, var(--primary), var(--primary-dk));
            color: #fff;
            box-shadow: 0 4px 12px rgba(79,126,118,.22);
        }

        .btn-print:hover { transform: translateY(-2px); box-shadow: 0 7px 18px rgba(79,126,118,.32); }
    </style>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="ck-orders-hero">
        <div class="hero-inner">
            <img src="../icons/manageitem.png" alt="" class="hero-icon" />
            <h1>My Orders</h1>
        </div>
    </div>

    <div class="ck-orders-wrap">

        <div class="ck-filter-card">
            <div class="filter-row">

                <div class="ck-filter-group">
                    <label>
                        <img src="../icons/total.png" alt="" width="14" /> Status
                    </label>
                    <asp:DropDownList ID="ddlStatus" runat="server"
                        AutoPostBack="true"
                        CssClass="styled-dropdown"
                        OnSelectedIndexChanged="ddlStatus_SelectedIndexChanged">
                        <asp:ListItem Text="All Orders" Value=""></asp:ListItem>
                        <asp:ListItem Text="Pending"    Value="Pending"></asp:ListItem>
                        <asp:ListItem Text="Completed"  Value="Completed"></asp:ListItem>
                        <asp:ListItem Text="Cancelled"  Value="Cancelled"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="ck-filter-group">
                    <label>
                        <img src="../icons/cal1.png" alt="" width="14" /> Start Date
                    </label>
                    <asp:TextBox ID="txtStartDate" runat="server"
                        Type="date" CssClass="styled-input"></asp:TextBox>
                </div>

                <div class="ck-filter-group">
                    <label>
                        <img src="../icons/cal1.png" alt="" width="14" /> End Date
                    </label>
                    <asp:TextBox ID="txtEndDate" runat="server"
                        Type="date" CssClass="styled-input"></asp:TextBox>
                </div>

                <asp:Button ID="btnFilter" runat="server"
                    Text="🔍 Apply Filters"
                    CssClass="btn-filter"
                    OnClick="btnFilter_Click" />

            </div>
        </div>

        <div class="orders-grid">
            <asp:Repeater ID="rptOrders" runat="server">
                <ItemTemplate>
                    <div>
                    <div class="order-card" id='<%# "order_" & Eval("order_id") %>'>

                        <div class="order-header">
                            <span class="order-id">
                                <img src="../icons/order.png" width="16" style="vertical-align:middle;margin-right:5px;" />
                                Order #<%# Eval("order_id") %>
                            </span>
                            <span class="order-date">
                                <%# Eval("order_date", "{0:dd-MMM-yyyy HH:mm}") %>
                            </span>
                        </div>

                        <div class="order-body">
                            <div class="order-info">
                                <span class="oi-icon"><img src="../icons/tr.png" alt="" /></span>
                                <span><strong>Transaction:</strong> <%# Eval("transaction_number") %></span>
                            </div>
                            <div class="order-info">
                                <span class="oi-icon"><img src="../icons/rupee.png" alt="" /></span>
                                <span><strong>Amount:</strong> ₹<%# Eval("total_amount") %></span>
                            </div>
                            <div class="order-info">
                                <span class="oi-icon"><img src="../icons/payment.png" alt="" /></span>
                                <span><strong>Payment:</strong> <%# Eval("payment_type") %></span>
                            </div>
                            <div class="order-info">
                                <span class="oi-icon"><img src="../icons/location1.png" alt="" /></span>
                                <span><strong>Address:</strong> <%# Eval("delivery_address") %>, <%# Eval("pincode") %></span>
                            </div>
                            <div class="order-info">
                                <span class="oi-icon"><img src="../icons/status.png" alt="" /></span>
                                <span>
                                    <strong>Status:</strong>
                                    <span class="status <%# GetStatusClass(Eval("order_status").ToString()) %>">
                                        <%# Eval("order_status") %>
                                    </span>
                                </span>
                            </div>
                        </div>

                        <div class="order-items">
                            <div class="order-items-title">🍴 Items Ordered</div>
                            <asp:Repeater ID="rptOrderItems" runat="server"
                                DataSource='<%# Eval("OrderItems") %>'>
                                <ItemTemplate>
                                    <div class="item-row">
                                        <span><%# Eval("item_name") %> (x<%# Eval("quantity") %>)</span>
                                        <span>₹<%# Eval("price") %></span>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>

                        <!-- Action buttons -->
                        <div class="order-card-footer">
                            <asp:Button ID="btnPrintBill" runat="server"
                                CssClass="btn-print"
                                Text="🖨️ Print Bill"
                                Visible='<%# IIf(Convert.ToString(Eval("order_status")) = "Completed", True, False) %>'
                                CommandArgument='<%# Eval("order_id") %>'
                                OnClick="btnPrintBill_Click" />

                            <asp:Button ID="btnReorder" runat="server"
                                CssClass="btn-reorder"
                                Text="🔄 Reorder"
                                CommandArgument='<%# Eval("order_id") %>'
                                OnClick="btnReorder_Click" />
                        </div>

                    </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

    </div>

    <script>
        function printBill(orderId) {
            var orderCard = document.getElementById("order_" + orderId);
            if (!orderCard) { alert("Order details not found!"); return; }

            const today = new Date();
            const formattedDate = today.toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' });

            const transactionInfo = orderCard.querySelector('.order-info:nth-child(1)').innerHTML;
            const amountInfo = orderCard.querySelector('.order-info:nth-child(2)').innerHTML;
            const paymentInfo = orderCard.querySelector('.order-info:nth-child(3)').innerHTML;
            const deliveryInfo = orderCard.querySelector('.order-info:nth-child(4)').innerHTML;
            const orderDateText = orderCard.querySelector('.order-date')?.textContent.trim() || formattedDate;

            var printWindow = window.open('', '', 'width=800,height=800');
            printWindow.document.write('<html><head><title>Cloud Kitchen - Invoice</title>');
            printWindow.document.write('<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;600;700&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">');
            printWindow.document.write('<style>');
            printWindow.document.write(`
            *{margin:0;padding:0;box-sizing:border-box;font-family:'DM Sans',Arial,sans-serif;}
            body{background:#f5f7fa;padding:40px;color:#333;}
            .invoice-container{width:100%;max-width:800px;margin:0 auto;background:#fff;padding:40px;border-radius:16px;box-shadow:0 10px 30px rgba(0,0,0,.1);position:relative;}
            .invoice-container::before{content:'';position:absolute;top:0;left:0;width:100%;height:6px;background:linear-gradient(to right,#4F7E76,#ff9f43);border-radius:16px 16px 0 0;}
            .invoice-header{display:flex;justify-content:space-between;align-items:center;padding-bottom:20px;border-bottom:2px dashed #eee;margin-bottom:30px;}
            .company-name{font-family:'Playfair Display',serif;font-size:26px;font-weight:700;color:#2c3e50;margin-bottom:4px;}
            .company-tagline{color:#7f8c8d;font-size:13px;}
            .invoice-title h2{font-size:36px;color:#4F7E76;text-transform:uppercase;letter-spacing:2px;margin-bottom:4px;font-weight:700;text-align:right;}
            .invoice-title p{color:#7f8c8d;font-size:13px;text-align:right;}
            .invoice-details{display:flex;justify-content:space-between;margin-bottom:30px;}
            .detail-title{color:#7f8c8d;font-size:12px;margin-bottom:4px;text-transform:uppercase;letter-spacing:.5px;}
            .detail-value{font-weight:600;color:#2c3e50;font-size:15px;margin-bottom:14px;}
            .invoice-details-right{text-align:right;}
            .customer-info{background:#f8faf9;padding:18px;border-radius:10px;margin-bottom:26px;border-left:4px solid #4F7E76;}
            .customer-title{color:#4F7E76;font-weight:700;margin-bottom:7px;font-size:13px;text-transform:uppercase;letter-spacing:.5px;}
            .customer-address{color:#555;font-size:14px;line-height:1.6;}
            .invoice-table{width:100%;border-collapse:collapse;margin-bottom:26px;border-radius:10px;overflow:hidden;}
            .invoice-table thead{background:#f0f4f3;}
            .invoice-table th{padding:13px 15px;text-align:left;font-weight:700;font-size:13px;text-transform:uppercase;color:#4F7E76;letter-spacing:.5px;}
            .invoice-table td{padding:13px 15px;border-bottom:1px solid #ecf0f1;color:#2c3e50;font-size:14px;}
            .invoice-table tbody tr:last-child td{border-bottom:none;}
            .item-quantity{text-align:center;}
            .item-price{text-align:right;font-weight:600;}
            .total-section{padding-top:18px;border-top:2px dashed #eee;}
            .total-row{display:flex;justify-content:flex-end;align-items:center;margin-bottom:8px;}
            .total-label{width:160px;text-align:right;margin-right:24px;color:#7f8c8d;font-size:14px;}
            .total-value{width:120px;text-align:right;font-weight:600;color:#2c3e50;font-size:14px;}
            .grand-total{font-size:18px!important;color:#4F7E76!important;font-weight:700!important;}
            .payment-badge{display:inline-block;padding:4px 10px;background:rgba(79,126,118,.12);color:#4F7E76;border-radius:5px;font-weight:600;font-size:13px;}
            .footer-note{text-align:center;margin-top:36px;padding-top:18px;border-top:1px solid #ecf0f1;color:#7f8c8d;font-size:13px;}
            .watermark{position:absolute;top:50%;left:50%;transform:translate(-50%,-50%) rotate(-35deg);font-size:110px;color:rgba(0,0,0,.03);font-weight:900;text-transform:uppercase;pointer-events:none;}
            .print-button{display:block;margin:28px auto;padding:12px 32px;background:linear-gradient(135deg,#4F7E76,#3a5f59);color:#fff;border:none;border-radius:50px;font-size:15px;font-weight:600;cursor:pointer;box-shadow:0 5px 14px rgba(79,126,118,.3);}
            @media print{body{background:#fff;padding:0;}.invoice-container{box-shadow:none;max-width:100%;}.print-button{display:none;}}

        `);
            printWindow.document.write('</style></head><body>');

            printWindow.document.write(`
            <div class="invoice-container">
                <div class="watermark">Paid</div>
                <div class="invoice-header">
                    <div>
                        <div class="company-name">Cloud Kitchen</div>
                        <div class="company-tagline">Delicious food delivered to your doorstep</div>
                    </div>
                    <div class="invoice-title">
                        <h2>Invoice</h2>
                        <p>Receipt for your order</p>
                    </div>
                </div>
                <div class="invoice-details">
                    <div class="invoice-details-left">
                        <div class="detail-title">Invoice Number</div>
                        <div class="detail-value">INV-${orderId}</div>
                        <div class="detail-title">Order Date</div>
                        <div class="detail-value">${orderDateText}</div>
                    </div>
                    <div class="invoice-details-right">
                        <div class="detail-title">Transaction ID</div>
                        <div class="detail-value">${extractText(transactionInfo)}</div>
                        <div class="detail-title">Payment Method</div>
                        <div class="detail-value"><span class="payment-badge">${extractText(paymentInfo)}</span></div>
                    </div>
                </div>
                <div class="customer-info">
                    <div class="customer-title">Delivered To</div>
                    <div class="customer-address">${extractText(deliveryInfo)}</div>
                </div>
                <table class="invoice-table">
                    <thead>
                        <tr>
                            <th>Item</th>
                            <th class="item-quantity">Qty</th>
                            <th class="item-price">Price</th>
                        </tr>
                    </thead>
                    <tbody>
        `);

            var items = orderCard.querySelectorAll('.item-row');
            let subtotal = 0;
            items.forEach(function (item) {
                const t = item.textContent.trim();
                const parts = t.split('₹');
                if (parts.length > 1) {
                    const nameQty = parts[0].trim();
                    const price = parts[1].trim();
                    const m = nameQty.match(/(.*)\s+\(x(\d+)\)/);
                    if (m && m.length > 2) {
                        printWindow.document.write(`<tr><td>${m[1].trim()}</td><td class="item-quantity">${m[2]}</td><td class="item-price">₹${price}</td></tr>`);
                        const p = parseFloat(price.replace(/,/g, ''));
                        if (!isNaN(p)) subtotal += p;
                    }
                }
            });

            const tax = subtotal * 0.05;
            const grandTotal = subtotal + tax;

            printWindow.document.write(`
                    </tbody>
                </table>
                <div class="total-section">
                    <div class="total-row"><div class="total-label">Subtotal</div><div class="total-value">₹${subtotal.toFixed(2)}</div></div>
                    <div class="total-row"><div class="total-label">Tax (5% GST)</div><div class="total-value">₹${tax.toFixed(2)}</div></div>
                    <div class="total-row"><div class="total-label">Delivery Fee</div><div class="total-value">₹0.00</div></div>
                    <div class="total-row"><div class="total-label grand-total">Grand Total</div><div class="total-value grand-total">₹${grandTotal.toFixed(2)}</div></div>
                </div>
                <div class="footer-note">Thank you for your order! We hope you enjoyed your meal.</div>
            </div>
            <button class="print-button" onclick="window.print();">🖨️ Print Invoice</button>
        `);

            printWindow.document.write('</body></html>');
            printWindow.document.close();

            function extractText(html) {
                const d = document.createElement('div');
                d.innerHTML = html;
                ['strong', 'span.oi-icon'].forEach(sel => d.querySelectorAll(sel).forEach(el => el.remove()));
                return d.textContent.trim().replace(/:/g, '');
            }
        }
    </script>

</asp:Content>
