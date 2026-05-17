<%@ Page Title="Manage Orders" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Admin.Master" CodeBehind="ManageOrders.aspx.vb" Inherits="Cloud_Kitchen.WebForm11" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .admin-container {
            width: min(100%, 1240px);
            margin: 0 auto;
            font-family: 'Segoe UI', Arial, sans-serif;
            padding: clamp(16px, 3vw, 25px);
            background: linear-gradient(to bottom right, #f8fdff, #e6f4ff);
            border-radius: 12px;
            box-shadow: 0px 8px 20px rgba(0, 0, 0, 0.12);
            overflow: hidden;
        }

        .admin-header {
            font-size: clamp(1.55rem, 4vw, 1.75rem);
            font-weight: 700;
            margin-bottom: 25px;
            color: #00264d;
            text-align: center;
            text-transform: uppercase;
            letter-spacing: 1px;
            padding-bottom: 10px;
            border-bottom: 2px solid #007bff;
            overflow-wrap: anywhere;
        }

        .dashboard-summary {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: clamp(14px, 2vw, 20px);
            margin-bottom: 28px;
        }

        .summary-card {
            min-width: 0;
            background: white;
            padding: clamp(16px, 2vw, 20px);
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .summary-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
        }

        .summary-card img {
            width: clamp(28px, 5vw, 36px);
            height: clamp(28px, 5vw, 36px);
            object-fit: contain;
            margin-bottom: 10px;
        }

        .summary-value {
            font-size: clamp(1.55rem, 4vw, 1.9rem);
            font-weight: 800;
            margin-bottom: 8px;
            overflow-wrap: anywhere;
        }

        .summary-label {
            font-size: 14px;
            color: #6c757d;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            line-height: 1.35;
        }

        .filters {
            display: grid;
            grid-template-columns: minmax(160px, 0.8fr) minmax(300px, 1.4fr) minmax(280px, 1.3fr);
            align-items: end;
            gap: 16px;
            margin-bottom: 25px;
            background: white;
            padding: clamp(15px, 2vw, 20px);
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.08);
        }

        .filter-group {
            min-width: 0;
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .filter-label {
            flex: 0 0 auto;
            font-weight: 700;
            color: #495057;
            white-space: nowrap;
        }

        .date-filter {
            min-width: 0;
            display: grid;
            grid-template-columns: minmax(0, 1fr) auto minmax(0, 1fr);
            gap: 10px;
            align-items: center;
            width: 100%;
        }

        .styled-dropdown,
        .styled-input {
            width: 100% !important;
            min-height: 46px;
            padding: 12px 14px;
            font-size: 15px;
            border: 1px solid #ced4da;
            border-radius: 8px;
            background: #ffffff;
            transition: border-color 0.3s, box-shadow 0.3s;
            outline: none;
            box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.075);
        }

        .styled-dropdown:focus,
        .styled-input:focus {
            border-color: #4dabf7;
            box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, .25);
        }

        .btn-filter {
            min-height: 46px;
            padding: 12px 18px;
            font-size: 15px;
            font-weight: 700;
            color: #fff;
            background: #007bff;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: transform 0.3s, box-shadow 0.3s, background 0.3s;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            white-space: nowrap;
        }

        .btn-filter:hover {
            background: #0069d9;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 123, 255, 0.3);
        }

        .orders-table-wrap {
            width: 100%;
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
            border-radius: 10px;
            box-shadow: 0px 6px 16px rgba(0, 0, 0, 0.1);
            background: #ffffff;
        }

        .orders-table {
            width: 100%;
            min-width: 1050px;
            border-collapse: separate;
            border-spacing: 0;
            background: #ffffff;
            border-radius: 10px;
            overflow: hidden;
            margin: 0;
        }

        .orders-table th,
        .orders-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e9ecef;
            vertical-align: top;
        }

        .orders-table th {
            background: #1a66b7;
            color: white;
            font-size: 14px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            white-space: nowrap;
        }

        .orders-table tr:last-child td {
            border-bottom: none;
        }

        .orders-table tr:nth-child(even) {
            background: #f8fbff;
        }

        .orders-table tr:hover {
            background: #e6f2ff;
        }

        .status-badge {
            padding: 6px 12px;
            font-size: 13px;
            border-radius: 50px;
            font-weight: 700;
            display: inline-block;
            white-space: nowrap;
        }

        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }

        .status-completed {
            background-color: #d4edda;
            color: #155724;
        }

        .status-cancelled {
            background-color: #f8d7da;
            color: #721c24;
        }

        .btn-update,
        .btn-cancel {
            min-height: 36px;
            padding: 7px 12px;
            font-size: 14px;
            font-weight: 700;
            color: #fff;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: transform 0.3s, box-shadow 0.3s, background 0.3s;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            white-space: nowrap;
        }

        .btn-update {
            background: #007bff;
        }

        .btn-update:hover {
            background: #0069d9;
            transform: translateY(-3px);
            box-shadow: 0 4px 8px rgba(0, 123, 255, 0.3);
        }

        .btn-cancel {
            background: #dc3545;
        }

        .btn-cancel:hover {
            background: #c82333;
            transform: translateY(-3px);
            box-shadow: 0 4px 8px rgba(220, 53, 69, 0.3);
        }

        .toggle-btn {
            cursor: pointer;
            color: #007bff;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            font-weight: 600;
            transition: color 0.3s;
            white-space: nowrap;
        }

        .toggle-btn:hover {
            color: #0056b3;
            text-decoration: underline;
        }

        .toggle-btn i {
            transition: transform 0.3s;
        }

        .rotate-icon {
            transform: rotate(180deg);
        }

        .order-items {
            display: none;
            min-width: 240px;
            background: #f1f9ff;
            padding: 12px;
            border-radius: 8px;
            box-shadow: 0px 3px 8px rgba(0, 0, 0, 0.1);
            margin-top: 10px;
            transition: all 0.3s ease-in-out;
        }

        .item-row {
            display: grid;
            grid-template-columns: minmax(110px, 1fr) auto auto;
            gap: 10px;
            align-items: center;
            padding: 8px 0;
            border-bottom: 1px solid #ddd;
        }

        .item-row:last-child {
            border-bottom: none;
        }

        .item-name {
            font-weight: 600;
            color: #495057;
            overflow-wrap: anywhere;
        }

        .item-quantity {
            background: #e9ecef;
            color: #495057;
            padding: 2px 8px;
            border-radius: 4px;
            font-size: 14px;
            white-space: nowrap;
        }

        .item-price {
            color: #28a745;
            font-weight: 700;
            white-space: nowrap;
        }

        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-top: 25px;
            gap: 10px;
            flex-wrap: wrap;
        }

        .page-item {
            width: 40px;
            height: 40px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            font-weight: 700;
            cursor: pointer;
            transition: background 0.3s, color 0.3s, border-color 0.3s;
            border: 1px solid #dee2e6;
            background: white;
            color: #212529;
            text-decoration: none;
            flex: 0 0 auto;
        }

        .page-item img {
            width: 24px;
            height: 24px;
            object-fit: contain;
        }

        .page-item:hover:not(.active) {
            background: #e9ecef;
        }

        .page-item.active {
            background: #007bff;
            color: white;
            border-color: #007bff;
        }

        .empty-message {
            text-align: center;
            padding: clamp(24px, 5vw, 40px);
            font-size: 18px;
            color: #6c757d;
            background: white;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.08);
        }

        .empty-message p {
            margin: 0;
        }

        .customer-info {
            display: flex;
            align-items: center;
            gap: 10px;
            min-width: 190px;
        }

        .customer-avatar {
            flex: 0 0 40px;
            width: 40px;
            height: 40px;
            background: #e9ecef;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            font-weight: bold;
            color: #495057;
        }

        .customer-details {
            display: flex;
            flex-direction: column;
            min-width: 0;
        }

        .customer-name {
            font-weight: 700;
            color: #212529;
            overflow-wrap: anywhere;
        }

        .customer-phone {
            font-size: 13px;
            color: #6c757d;
            white-space: nowrap;
        }

        .payment-cell {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            white-space: nowrap;
        }

        .payment-icon {
            width: 20px;
            height: 20px;
            object-fit: contain;
        }

        .order-actions {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        @media (max-width: 1100px) {
            .dashboard-summary {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .filters {
                grid-template-columns: 1fr 1fr;
            }

            .filters .filter-group:last-child {
                grid-column: 1 / -1;
            }
        }

        @media (max-width: 768px) {
            .filters {
                grid-template-columns: 1fr;
                align-items: stretch;
            }

            .filter-group {
                width: 100%;
                align-items: stretch;
            }

            .filter-group:not(:has(.date-filter)) {
                flex-direction: column;
            }

            .filter-label {
                white-space: normal;
            }

            .btn-filter {
                width: 100%;
            }
        }

        @media (max-width: 576px) {
            .admin-container {
                border-radius: 10px;
            }

            .dashboard-summary {
                grid-template-columns: 1fr;
            }

            .date-filter {
                grid-template-columns: 1fr;
            }

            .date-filter span {
                display: none;
            }

            .summary-card:hover,
            .btn-filter:hover,
            .btn-update:hover,
            .btn-cancel:hover {
                transform: none;
            }

            .pagination {
                gap: 8px;
            }

            .page-item {
                width: 36px;
                height: 36px;
            }
        }

        @supports not selector(:has(*)) {
            @media (max-width: 768px) {
                .filter-group {
                    flex-direction: column;
                }

                .filter-group .date-filter {
                    width: 100%;
                }
            }
        }

        @media (prefers-reduced-motion: reduce) {
            *,
            *::before,
            *::after {
                animation-duration: 0.01ms !important;
                animation-iteration-count: 1 !important;
                scroll-behavior: auto !important;
                transition-duration: 0.01ms !important;
            }
        }
    </style>

    <script type="text/javascript">
        function toggleItems(orderId) {
            var element = document.getElementById("items-" + orderId);
            var icon = document.getElementById("icon-" + orderId);

            if (!element || !icon) return;

            if (element.style.display === "none" || element.style.display === "") {
                element.style.display = "block";
                icon.classList.add("rotate-icon");
            } else {
                element.style.display = "none";
                icon.classList.remove("rotate-icon");
            }
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="admin-container">
        <div class="admin-header">Manage Orders</div>

        <div class="dashboard-summary">
            <div class="summary-card pending">
                <img src="../icons/pen.png" alt="Pending Orders" />
                <div class="summary-value">
                    <asp:Literal ID="litPendingOrders" runat="server">0</asp:Literal>
                </div>
                <div class="summary-label">Pending Orders</div>
            </div>

            <div class="summary-card completed">
                <img src="../icons/comm1.png" alt="Completed Orders" />
                <div class="summary-value">
                    <asp:Literal ID="litCompletedOrders" runat="server">0</asp:Literal>
                </div>
                <div class="summary-label">Completed Orders</div>
            </div>

            <div class="summary-card cancelled">
                <img src="../icons/c3.png" alt="Cancelled Orders" />
                <div class="summary-value">
                    <asp:Literal ID="litCancelledOrders" runat="server">0</asp:Literal>
                </div>
                <div class="summary-label">Cancelled Orders</div>
            </div>

            <div class="summary-card total">
                <img src="../icons/total.png" alt="Total Orders" />
                <div class="summary-value">
                    <asp:Literal ID="litTotalOrders" runat="server">0</asp:Literal>
                </div>
                <div class="summary-label">Total Orders</div>
            </div>
        </div>

        <div class="filters">
            <div class="filter-group">
                <span class="filter-label">Status:</span>
                <asp:DropDownList ID="ddlFilterStatus" runat="server" AutoPostBack="true" CssClass="styled-dropdown" OnSelectedIndexChanged="ddlFilterStatus_SelectedIndexChanged">
                    <asp:ListItem Text="All Orders" Value=""></asp:ListItem>
                    <asp:ListItem Text="Pending" Value="Pending" Selected></asp:ListItem>
                    <asp:ListItem Text="Completed" Value="Completed"></asp:ListItem>
                    <asp:ListItem Text="Cancelled" Value="Cancelled"></asp:ListItem>
                </asp:DropDownList>
            </div>

            <div class="filter-group">
                <span class="filter-label">From:</span>
                <div class="date-filter">
                    <asp:TextBox ID="txtStartDate" runat="server" CssClass="styled-input" TextMode="Date"></asp:TextBox>
                    <span>-</span>
                    <asp:TextBox ID="txtEndDate" runat="server" CssClass="styled-input" TextMode="Date"></asp:TextBox>
                </div>
            </div>

            <div class="filter-group">
                <asp:TextBox ID="txtSearch" runat="server" CssClass="styled-input" placeholder="Search Here"></asp:TextBox>
                <asp:Button ID="btnFilter" runat="server" Text="Apply Filters" OnClick="btnFilter_Click" CssClass="btn-filter"></asp:Button>
            </div>
        </div>

        <asp:Panel ID="pnlNoOrders" runat="server" CssClass="empty-message" Visible="false">
            <i class="fas fa-search" style="font-size: 48px; color: #adb5bd; margin-bottom: 15px;"></i>
            <p>No orders found matching your criteria. Try adjusting your filters.</p>
        </asp:Panel>

        <div class="orders-table-wrap">
            <asp:Repeater ID="rptOrders" runat="server">
                <HeaderTemplate>
                    <table class="orders-table">
                        <tr>
                            <th style="display:none;">Order ID</th>
                            <th>Customer</th>
                            <th>Delivery Address</th>
                            <th>Total Amount</th>
                            <th>Payment Type</th>
                            <th>Order Date</th>
                            <th>Status</th>
                            <th>Items</th>
                            <th>Actions</th>
                        </tr>
                </HeaderTemplate>
                <ItemTemplate>
                        <tr>
                            <td style="display:none;">#<%# Eval("order_id") %></td>
                            <td>
                                <div class="customer-info">
                                    <div class="customer-avatar">
                                        <%# Eval("customer_name").ToString().Substring(0, 1).ToUpper() %>
                                    </div>
                                    <div class="customer-details">
                                        <span class="customer-name"><%# Eval("customer_name") %></span>
                                        <span class="customer-phone"><%# Eval("phone", "{0:(###) ###-####}") %></span>
                                    </div>
                                </div>
                            </td>
                            <td><%# Eval("address") %>, <%# Eval("pincode") %></td>
                            <td>₹<%# Eval("total_amount", "{0:N2}") %></td>
                            <td>
                                <span class="payment-cell">
                                    <img src='<%# GetPaymentIcon(Eval("payment_type").ToString()) %>' class="payment-icon" alt="" />
                                    <%# Eval("payment_type") %>
                                </span>
                            </td>
                            <td><%# Eval("order_date", "{0:dd-MMM-yyyy hh:mm tt}") %></td>
                            <td>
                                <span class="status-badge status-<%# Eval("order_status").ToString().ToLower() %>">
                                    <%# Eval("order_status") %>
                                </span>
                            </td>
                            <td>
                                <span class="toggle-btn" onclick="toggleItems('<%# Eval("order_id") %>')">
                                    <i id="icon-<%# Eval("order_id") %>" class="fas fa-chevron-down"></i>
                                    View items
                                </span>
                                <div class="order-items" id="items-<%# Eval("order_id") %>">
                                    <asp:Repeater ID="rptOrderItems" runat="server" DataSource='<%# Eval("OrderItems") %>'>
                                        <ItemTemplate>
                                            <div class="item-row">
                                                <span class="item-name"><%# Eval("item_name") %></span>
                                                <span class="item-quantity">x<%# Eval("quantity") %></span>
                                                <span class="item-price">₹<%# Eval("price", "{0:N2}") %></span>
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>
                            </td>
                            <td>
                                <div class="order-actions">
                                    <asp:Button ID="btnUpdate" runat="server" Text="Complete" CssClass="btn-update" CommandArgument='<%# Eval("order_id") %>' OnClick="btnUpdate_Click" Visible='<%# Eval("order_status").ToString() = "Pending" %>' />
                                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn-cancel" CommandArgument='<%# Eval("order_id") %>' OnClick="btnCancel_Click" Visible='<%# Eval("order_status").ToString() = "Pending" %>' />
                                </div>
                            </td>
                        </tr>
                </ItemTemplate>
                <FooterTemplate>
                    </table>
                </FooterTemplate>
            </asp:Repeater>
        </div>

        <div class="pagination">
            <asp:LinkButton ID="lnkFirst" runat="server" CssClass="page-item" OnClick="lnkFirst_Click">
                <img src="../icons/a1.png" alt="First Page" />
            </asp:LinkButton>

            <asp:LinkButton ID="lnkPrevious" runat="server" CssClass="page-item" OnClick="lnkPrevious_Click">
                <img src="../icons/a2.png" alt="Previous Page" />
            </asp:LinkButton>

            <asp:Repeater ID="rptPagination" runat="server" OnItemCommand="rptPagination_ItemCommand">
                <ItemTemplate>
                    <asp:LinkButton ID="lnkPage" runat="server" CssClass='<%# IIf(Convert.ToBoolean(Eval("IsActive")), "page-item active", "page-item") %>'
                        CommandName="Page" CommandArgument='<%# Eval("PageNumber") %>'>
                        <%# Eval("PageNumber") %>
                    </asp:LinkButton>
                </ItemTemplate>
            </asp:Repeater>

            <asp:LinkButton ID="lnkNext" runat="server" CssClass="page-item" OnClick="lnkNext_Click">
                <img src="../icons/a3.png" alt="Next Page" />
            </asp:LinkButton>

            <asp:LinkButton ID="lnkLast" runat="server" CssClass="page-item" OnClick="lnkLast_Click">
                <img src="../icons/a4.png" alt="Last Page" />
            </asp:LinkButton>
        </div>
    </div>
</asp:Content>
