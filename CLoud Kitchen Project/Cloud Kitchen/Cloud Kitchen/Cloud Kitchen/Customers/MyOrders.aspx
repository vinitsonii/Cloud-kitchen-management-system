<%@ Page Title="My Orders" Language="vb" AutoEventWireup="false" MasterPageFile="~/Customers/Customer.Master" CodeBehind="MyOrders.aspx.vb" Inherits="Cloud_Kitchen.MyOrders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Google Fonts & FontAwesome 6 Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

    <style type="text/css">
        :root {
            --primary: #4F7E76;
            --primary-dk: #3a5f59;
            --accent: #ff9f43;
            --blue: #2563eb;
            --blue-dk: #1d4ed8;
            --success: #16a34a;
            --warning: #d97706;
            --danger: #dc2626;
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
        .ck-orders-hero {
            position: relative;
            min-height: 240px;
            background: linear-gradient(135deg, rgba(15, 23, 42, 0.78), rgba(79, 126, 118, 0.85)),
                        url('../Images/img9.jpg') center/cover no-repeat;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            text-align: center;
            padding: 40px 20px;
        }

        .ck-orders-hero .hero-inner {
            z-index: 2;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 10px;
        }

        .ck-orders-hero h1 {
            font-size: clamp(1.8rem, 4vw, 2.6rem);
            font-weight: 800;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 12px;
            text-shadow: 0 4px 16px rgba(0,0,0,0.3);
        }

        .ck-orders-hero p {
            font-size: clamp(0.88rem, 1.8vw, 1.05rem);
            color: #e2e8f0;
            margin: 0;
            font-weight: 500;
        }

        /* MAIN CONTAINER WRAPPER */
        .ck-orders-wrap {
            max-width: 1280px;
            margin: -35px auto 60px;
            padding: 0 1rem;
            position: relative;
            z-index: 10;
        }

        /* FILTER CARD */
        .ck-filter-card {
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.06);
            padding: 20px 24px;
            margin-bottom: 24px;
            border: 1px solid var(--border);
            border-top: 4px solid var(--primary);
        }

        .ck-filter-card .filter-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            align-items: end;
            gap: 16px;
        }

        .ck-filter-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .ck-filter-group label {
            font-size: 13px;
            font-weight: 700;
            color: #475569;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .styled-dropdown,
        .styled-input {
            padding: 10px 14px;
            font-size: 13.5px;
            font-family: inherit;
            border: 1.5px solid var(--border);
            border-radius: 10px;
            background: #f8fafc;
            color: var(--text);
            transition: all 0.25s ease;
            outline: none;
            width: 100%;
            box-sizing: border-box;
        }

        .styled-dropdown:focus,
        .styled-input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(79, 126, 118, 0.18);
            background: #ffffff;
        }

        .btn-filter {
            padding: 11px 24px;
            font-size: 14px;
            font-weight: 700;
            color: #ffffff;
            background: linear-gradient(135deg, var(--primary), var(--primary-dk));
            border: none;
            border-radius: 10px;
            cursor: pointer;
            box-shadow: 0 4px 14px rgba(79, 126, 118, 0.3);
            transition: transform 0.2s, box-shadow 0.2s;
            white-space: nowrap;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            min-height: 42px;
        }

        .btn-filter:hover {
            transform: translateY(-2px);
            box-shadow: 0 7px 20px rgba(79, 126, 118, 0.4);
        }

        /* ORDERS GRID & CARDS */
        .orders-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
            gap: 24px;
        }

        .order-card {
            background: var(--card-bg);
            border-radius: 16px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.05);
            border: 1.5px solid var(--border);
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            position: relative;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .order-card::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 5px;
            background: linear-gradient(to bottom, var(--primary), var(--accent));
        }

        .order-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 32px rgba(0, 0, 0, 0.1);
        }

        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 14px 18px;
            border-bottom: 1.5px solid var(--border);
            background: #f8fafc;
            flex-wrap: wrap;
            gap: 8px;
        }

        .order-header .order-id {
            font-size: 15px;
            font-weight: 800;
            color: var(--primary-dk);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .order-header .order-date {
            font-size: 12px;
            color: var(--muted);
            background: #f1f5f9;
            padding: 4px 10px;
            border-radius: 20px;
            font-weight: 600;
        }

        .order-body {
            padding: 16px 18px;
        }

        /* RESPONSIVE ORDER PROGRESS TRACKER */
        .progress-tracker {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #f8fafc;
            padding: 8px 10px;
            border-radius: 12px;
            margin-bottom: 16px;
            border: 1px solid #e2e8f0;
            font-size: 10px;
            font-weight: 700;
            gap: 2px;
            overflow: hidden;
        }

        .progress-step {
            display: flex;
            align-items: center;
            gap: 3px;
            color: #94a3b8;
            white-space: nowrap;
            font-size: 10px;
        }

        .progress-step.active {
            color: #2563eb;
            font-weight: 800;
        }

        .progress-step.delivered {
            color: #16a34a;
            font-weight: 800;
        }

        .progress-arrow {
            color: #cbd5e1;
            font-size: 8px;
            flex-shrink: 0;
        }

        /* ORDER DETAILS LIST */
        .order-info {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            padding: 7px 0;
            font-size: 13px;
            color: var(--muted);
            border-bottom: 1px dashed #e2e8f0;
        }

        .order-info:last-child {
            border-bottom: none;
        }

        .order-info .oi-icon {
            width: 30px;
            height: 30px;
            background: #f1f5f9;
            color: var(--primary);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            font-size: 13px;
        }

        .order-info strong {
            color: var(--text);
            margin-right: 4px;
        }

        /* STATUS BADGES */
        .status {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 800;
            letter-spacing: 0.4px;
            text-transform: uppercase;
        }

        .status-pending { background: #fefce8; color: #a16207; border: 1px solid #fef08a; }
        .status-completed { background: #f0fdf4; color: #15803d; border: 1px solid #bbf7d0; }
        .status-cancelled { background: #fef2f2; color: #b91c1c; border: 1px solid #fecaca; }

        /* ITEMS ORDERED CONTAINER */
        .order-items {
            margin: 10px 18px;
            background: #f8fafc;
            border-radius: 12px;
            border: 1.5px solid var(--border);
            overflow: hidden;
        }

        .order-items-title {
            font-size: 12px;
            font-weight: 800;
            color: #475569;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding: 8px 14px;
            border-bottom: 1px solid var(--border);
            background: #f1f5f9;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .item-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 14px;
            font-size: 13px;
            border-bottom: 1px solid #f1f5f9;
            color: var(--text);
        }

        .item-row:last-child {
            border-bottom: none;
        }

        .item-row span:last-child {
            font-weight: 800;
            color: var(--primary-dk);
        }

        /* CARD FOOTER BUTTONS */
        .order-card-footer {
            padding: 14px 18px;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            border-top: 1.5px solid var(--border);
            background: #fafcfb;
        }

        .btn-reorder,
        .btn-print {
            flex: 1;
            min-width: 120px;
            padding: 10px 16px;
            font-size: 13.5px;
            font-weight: 700;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.2s ease;
            text-align: center;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-reorder {
            background: linear-gradient(135deg, var(--blue), var(--blue-dk));
            color: #ffffff;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.2);
        }

        .btn-reorder:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(37, 99, 235, 0.3);
        }

        .btn-print {
            background: linear-gradient(135deg, var(--primary), var(--primary-dk));
            color: #ffffff;
            box-shadow: 0 4px 12px rgba(79, 126, 118, 0.2);
        }

        .btn-print:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(79, 126, 118, 0.3);
        }

        /* RESPONSIVE MEDIA QUERIES */
        @media (max-width: 768px) {
            .orders-grid {
                grid-template-columns: 1fr;
            }

            .progress-tracker {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 6px;
            }

            .progress-arrow {
                display: none;
            }
        }

        @media (max-width: 480px) {
            .ck-filter-card .filter-row {
                grid-template-columns: 1fr;
            }

            .btn-filter,
            .btn-reorder,
            .btn-print {
                width: 100%;
            }

            .order-header {
                flex-direction: column;
                align-items: flex-start;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <!-- HERO BANNER -->
    <div class="ck-orders-hero">
        <div class="hero-inner">
            <h1><i class="fas fa-boxes-stacked" style="color:#ff9f43;"></i> My Orders</h1>
            <p>Track your active kitchen orders in real-time or reorder your favorite meals</p>
        </div>
    </div>

    <div class="ck-orders-wrap">

        <!-- FILTERS BAR CARD -->
        <div class="ck-filter-card">
            <div class="filter-row">

                <div class="ck-filter-group">
                    <label>
                        <i class="fas fa-filter" style="color:var(--primary);"></i> Order Status
                    </label>
                    <asp:DropDownList ID="ddlStatus" runat="server" AutoPostBack="true" CssClass="styled-dropdown" OnSelectedIndexChanged="ddlStatus_SelectedIndexChanged">
                        <asp:ListItem Text="All Orders" Value=""></asp:ListItem>
                        <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                        <asp:ListItem Text="Completed" Value="Completed"></asp:ListItem>
                        <asp:ListItem Text="Cancelled" Value="Cancelled"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="ck-filter-group">
                    <label>
                        <i class="fas fa-calendar-day" style="color:var(--primary);"></i> Start Date
                    </label>
                    <asp:TextBox ID="txtStartDate" runat="server" Type="date" CssClass="styled-input"></asp:TextBox>
                </div>

                <div class="ck-filter-group">
                    <label>
                        <i class="fas fa-calendar-check" style="color:var(--primary);"></i> End Date
                    </label>
                    <asp:TextBox ID="txtEndDate" runat="server" Type="date" CssClass="styled-input"></asp:TextBox>
                </div>

                <asp:Button ID="btnFilter" runat="server" Text="Apply Filters" CssClass="btn-filter" OnClick="btnFilter_Click" />

            </div>
        </div>

        <!-- REPEATER ORDERS GRID -->
        <div class="orders-grid">
            <asp:Repeater ID="rptOrders" runat="server">
                <ItemTemplate>
                    <div class="order-card" id='<%# "order_" & Eval("order_id") %>'>

                        <div>
                            <!-- ORDER HEADER BAR -->
                            <div class="order-header">
                                <span class="order-id">
                                    <i class="fas fa-box" style="color:var(--primary);"></i> Order #<%# Eval("order_id") %>
                                </span>
                                <span class="order-date">
                                    <i class="fas fa-clock" style="margin-right:4px;"></i><%# Eval("order_date", "{0:dd-MMM-yyyy hh:mm tt}") %>
                                </span>
                            </div>

                            <div class="order-body">
                                <!-- RESPONSIVE ORDER PROGRESS TRACKER -->
                                <div class="progress-tracker">
                                    <span class='progress-step <%# IIf(Eval("order_status").ToString()="Pending" Or Eval("order_status").ToString()="Preparing" Or Eval("order_status").ToString()="Out for Delivery" Or Eval("order_status").ToString()="Completed", "active", "") %>'>
                                        <i class="fas fa-check-circle"></i> 1. Placed
                                    </span>
                                    <span class="progress-arrow">➔</span>
                                    <span class='progress-step <%# IIf(Eval("order_status").ToString()="Preparing" Or Eval("order_status").ToString()="Out for Delivery" Or Eval("order_status").ToString()="Completed", "active", "") %>'>
                                        <i class="fas fa-fire-burner"></i> 2. Cooking
                                    </span>
                                    <span class="progress-arrow">➔</span>
                                    <span class='progress-step <%# IIf(Eval("order_status").ToString()="Out for Delivery" Or Eval("order_status").ToString()="Completed", "active", "") %>'>
                                        <i class="fas fa-motorcycle"></i> 3. Dispatched
                                    </span>
                                    <span class="progress-arrow">➔</span>
                                    <span class='progress-step <%# IIf(Eval("order_status").ToString()="Completed", "delivered", "") %>'>
                                        <i class="fas fa-house-circle-check"></i> 4. Delivered
                                    </span>
                                </div>

                                <!-- ORDER INFO LIST WITH VECTOR ICONS -->
                                <div class="order-info">
                                    <span class="oi-icon"><i class="fas fa-hashtag"></i></span>
                                    <span><strong>Transaction:</strong> <%# Eval("transaction_number") %></span>
                                </div>
                                <div class="order-info">
                                    <span class="oi-icon"><i class="fas fa-indian-rupee-sign"></i></span>
                                    <span><strong>Total Amount:</strong> ₹<%# Eval("total_amount", "{0:N2}") %></span>
                                </div>
                                <div class="order-info">
                                    <span class="oi-icon"><i class="fas fa-credit-card"></i></span>
                                    <span><strong>Payment Method:</strong> <%# Eval("payment_type") %></span>
                                </div>
                                <div class="order-info">
                                    <span class="oi-icon"><i class="fas fa-location-dot"></i></span>
                                    <span><strong>Delivery Address:</strong> <%# Eval("delivery_address") %>, <%# Eval("pincode") %></span>
                                </div>
                                <div class="order-info">
                                    <span class="oi-icon"><i class="fas fa-tag"></i></span>
                                    <span>
                                        <strong>Current Status:</strong>
                                        <span class="status <%# GetStatusClass(Eval("order_status").ToString()) %>">
                                            <%# Eval("order_status") %>
                                        </span>
                                    </span>
                                </div>

                                <!-- DRIVER ASSIGNED BADGE -->
                                <%# IIf(Not String.IsNullOrEmpty(Eval("driver_name").ToString()), "<div class='order-info' style='background: #eff6ff; border-radius: 10px; padding: 10px 14px; margin-top: 8px; border: 1px solid #bfdbfe;'><span class='oi-icon' style='background:#dbeafe; color:#2563eb;'><i class='fas fa-motorcycle'></i></span><span><strong>Driver:</strong> " & Eval("driver_name").ToString() & " (📞 <a href='tel:" & Eval("driver_phone").ToString() & "' style='color:#2563eb; font-weight:700; text-decoration:none;'>" & Eval("driver_phone").ToString() & "</a>) - " & Eval("vehicle_no").ToString() & "</span></div>", "") %>

                                <!-- DELIVERY OTP BADGE -->
                                <%# IIf(Not String.IsNullOrEmpty(Eval("delivery_otp").ToString()) AndAlso Eval("order_status").ToString() = "Out for Delivery", "<div style='background: #fef3c7; border: 1.5px solid #fde68a; color: #92400e; border-radius: 10px; padding: 10px 14px; margin-top: 10px; font-weight: 700; text-align: center; font-size: 13px;'><i class='fas fa-key' style='color:#d97706; margin-right:6px;'></i> Delivery OTP: <span style='font-size: 18px; font-weight: 900; letter-spacing: 2px; color: #d97706; background: #ffffff; padding: 2px 10px; border-radius: 6px; border: 1px solid #fcd34d; margin-left: 6px;'>" & Eval("delivery_otp").ToString() & "</span></div>", "") %>
                            </div>

                            <!-- ITEMIZED ITEMS ORDERED CARD -->
                            <div class="order-items">
                                <div class="order-items-title"><i class="fas fa-utensils"></i> Items Ordered</div>
                                <asp:Repeater ID="rptOrderItems" runat="server" DataSource='<%# Eval("OrderItems") %>'>
                                    <ItemTemplate>
                                        <div class="item-row">
                                            <span><%# Eval("item_name") %> (x<%# Eval("quantity") %>)</span>
                                            <span>₹<%# Eval("price", "{0:N2}") %></span>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </div>

                        <!-- CARD FOOTER ACTIONS -->
                        <div class="order-card-footer">
                            <asp:Button ID="btnPrintBill" runat="server" CssClass="btn-print" Text="Print Receipt" Visible='<%# IIf(Convert.ToString(Eval("order_status")) = "Completed", True, False) %>' CommandArgument='<%# Eval("order_id") %>' OnClick="btnPrintBill_Click" />

                            <asp:Button ID="btnReorder" runat="server" CssClass="btn-reorder" Text="Reorder" CommandArgument='<%# Eval("order_id") %>' OnClick="btnReorder_Click" />
                        </div>

                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

    </div>

</asp:Content>