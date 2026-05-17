<%@ Page Title="Reports Dashboard" Language="VB" AutoEventWireup="false" MasterPageFile="~/Admin/Admin.Master" CodeBehind="Reports.aspx.vb" Inherits="Cloud_Kitchen.Reports" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .reports-page {
            width: min(100%, 1240px);
            margin: 0 auto;
        }

        .report-container {
            width: 100%;
            padding: clamp(16px, 3vw, 30px);
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
            transition: box-shadow 0.3s ease;
            overflow: hidden;
        }

        .reports-page .dashboard-header {
            margin-bottom: 30px;
            border-bottom: 2px solid #f0f0f0;
            padding-bottom: 15px;
        }

        .reports-page .dashboard-header h2 {
            font-size: clamp(1.55rem, 4vw, 1.85rem);
            color: #333;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 700;
            overflow-wrap: anywhere;
        }

        .reports-page .dashboard-header h2 img {
            width: clamp(32px, 6vw, 38px);
            height: clamp(32px, 6vw, 38px);
            object-fit: contain;
            flex: 0 0 auto;
        }

        .reports-page .dashboard-header p {
            color: #666;
            font-size: clamp(0.95rem, 2vw, 1rem);
            margin: 0;
            line-height: 1.5;
        }

        .filter-panel {
            background: #f8f9fa;
            border-radius: 10px;
            padding: clamp(16px, 3vw, 20px);
            margin-bottom: 30px;
            border: 1px solid #e9ecef;
        }

        .filter-row {
            display: grid;
            grid-template-columns: minmax(240px, 1.4fr) repeat(2, minmax(180px, 1fr));
            gap: 15px;
            margin-bottom: 15px;
            align-items: start;
        }

        .filter-group {
            min-width: 0;
        }

        .filter-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 700;
            color: #495057;
            line-height: 1.4;
        }

        .filter-control {
            width: 100% !important;
            max-width: 100%;
            min-height: 46px;
            padding: 12px 15px;
            border-radius: 8px;
            border: 1px solid #ced4da;
            background-color: white;
            font-size: 15px;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }

        .filter-control:focus {
            border-color: #007BFF;
            box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.25);
            outline: none;
        }

        select.filter-control {
            appearance: none;
            background-repeat: no-repeat;
            background-position: right 15px center;
            background-size: 16px;
            padding-right: 45px;
        }

        .reports-page .btn {
            min-height: 46px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 12px 24px;
            font-size: 16px;
            font-weight: 700;
            text-align: center;
            text-decoration: none;
            border-radius: 8px;
            cursor: pointer;
            transition: transform 0.3s ease, box-shadow 0.3s ease, background 0.3s ease, border-color 0.3s ease;
            border: none;
            gap: 8px;
            white-space: nowrap;
        }

        .reports-page .btn-primary {
            background-color: #007BFF;
            color: white;
            border: 2px solid #007BFF;
        }

        .reports-page .btn-primary:hover {
            background-color: #0069d9;
            border-color: #0062cc;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .reports-page .btn-success {
            background-color: #28a745;
            color: white;
            border: 2px solid #28a745;
        }

        .reports-page .btn-success:hover {
            background-color: #218838;
            border-color: #1e7e34;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .report-section {
            background: #ffffff;
            border-radius: 10px;
            padding: clamp(12px, 2vw, 20px);
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            margin-bottom: 20px;
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
        }

        .report-table {
            width: 100%;
            min-width: 760px;
            border-collapse: separate;
            border-spacing: 0;
            margin-top: 15px;
        }

        .report-table th,
        .report-table td {
            padding: 14px 15px;
            text-align: left;
            border-bottom: 1px solid #e9ecef;
            vertical-align: middle;
        }

        .report-table th {
            background-color: #007BFF;
            color: white;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-size: 14px;
            border: none;
            position: sticky;
            top: 0;
            z-index: 10;
            white-space: nowrap;
        }

        .report-table th:first-child {
            border-top-left-radius: 8px;
        }

        .report-table th:last-child {
            border-top-right-radius: 8px;
        }

        .report-table tr:nth-child(even) {
            background-color: #f8f9fa;
        }

        .report-table tr:hover {
            background-color: #f1f1f1;
        }

        .report-actions {
            display: flex;
            justify-content: flex-end;
            gap: 15px;
            margin-top: 20px;
            flex-wrap: wrap;
        }

        .report-summary {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }

        .summary-card {
            min-width: 0;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            border-left: 4px solid #007BFF;
        }

        .summary-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 15px rgba(0, 0, 0, 0.1);
        }

        .summary-title {
            font-size: 14px;
            color: #6c757d;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .summary-value {
            font-size: clamp(1.35rem, 4vw, 1.5rem);
            font-weight: 800;
            color: #343a40;
            margin: 0;
            overflow-wrap: anywhere;
        }

        .summary-value.small {
            font-size: clamp(1rem, 3vw, 1.125rem);
        }

        .no-data {
            text-align: center;
            padding: clamp(24px, 5vw, 40px);
            color: #6c757d;
            font-size: 18px;
            background: #f8f9fa;
            border-radius: 10px;
            margin: 20px 0;
        }

        .no-data img {
            width: min(180px, 55vw);
            color: #dee2e6;
            display: block;
            margin: 0 auto 30px;
        }

        .no-data p {
            margin: 0;
        }

        .reports-page .pagination {
            display: flex;
            justify-content: flex-end;
            gap: 6px;
            flex-wrap: wrap;
            padding: 12px 0;
        }

        .reports-page .pagination a,
        .reports-page .pagination span {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 34px;
            min-height: 34px;
            padding: 6px 10px;
            border-radius: 999px;
            background: #f8f9fa;
            color: #343a40;
            text-decoration: none;
            font-weight: 700;
        }

        .reports-page .pagination span {
            background: #007BFF;
            color: white;
        }

        .loading {
            position: fixed;
            inset: 0;
            background: rgba(255, 255, 255, 0.8);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 3000;
        }

        .loading-spinner {
            width: 50px;
            height: 50px;
            border: 5px solid #f3f3f3;
            border-top: 5px solid #007BFF;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        @media (max-width: 992px) {
            .filter-row {
                grid-template-columns: 1fr;
            }

            .report-summary {
                grid-template-columns: 1fr;
            }

            .reports-page .btn {
                width: 100%;
            }
        }

        @media (max-width: 576px) {
            .report-container {
                border-radius: 10px;
            }

            .reports-page .dashboard-header h2 {
                align-items: flex-start;
            }

            .report-actions {
                flex-direction: column;
            }

            .summary-card:hover,
            .reports-page .btn-primary:hover,
            .reports-page .btn-success:hover {
                transform: none;
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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="reports-page">
        <div class="report-container">
            <div class="dashboard-header">
                <h2><img src="../icons/rep2.png" alt="Total Orders" /> Report Dashboard</h2>
                <p>Generate and analyze detailed reports for your cloud kitchen business</p>
            </div>

            <div class="filter-panel">
                <div class="filter-row">
                    <div class="filter-group">
                        <label for="ddlReportType" class="filter-label">💹 Report Type</label>
                        <asp:DropDownList ID="ddlReportType" runat="server" CssClass="filter-control">
                            <asp:ListItem Value="" Enabled="false">-- Select Report Type --</asp:ListItem>
                            <asp:ListItem Value="orders">📃 Orders Report</asp:ListItem>
                            <asp:ListItem Value="customers">👥 Customers Report</asp:ListItem>
                            <asp:ListItem Value="menu">🍽️ Menu Items Report</asp:ListItem>
                            <asp:ListItem Value="messages">📩 Contact Messages Report</asp:ListItem>
                            <asp:ListItem Value="daily_sales">📊 Daily Sales Report</asp:ListItem>
                            <asp:ListItem Value="top_selling">🔥 Top Selling Menu Items</asp:ListItem>
                            <asp:ListItem Value="customer_summary">📜 Customer Order Summary</asp:ListItem>
                            <asp:ListItem Value="active_customers">📌 Active vs Inactive Customers</asp:ListItem>
                            <asp:ListItem Value="revenue_cuisine">🍛 Revenue by Cuisine Type</asp:ListItem>
                            <asp:ListItem Value="order_status">🛒 Pending vs Completed Orders</asp:ListItem>
                            <asp:ListItem Value="loyal_customers">🏆 Most Loyal Customers</asp:ListItem>
                            <asp:ListItem Value="highest_orders">💰 Highest Total Amount Orders</asp:ListItem>
                            <asp:ListItem Value="feedback">💬 Customer Feedback Report</asp:ListItem>
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                            ErrorMessage="Please select Report Type" ControlToValidate="ddlReportType"
                            ForeColor="Red" InitialValue=""></asp:RequiredFieldValidator>
                    </div>

                    <div class="filter-group">
                        <label for="txtStartDate" class="filter-label">📅 Start Date</label>
                        <asp:TextBox ID="txtStartDate" runat="server" TextMode="Date" CssClass="filter-control"></asp:TextBox>
                    </div>

                    <div class="filter-group">
                        <label for="txtEndDate" class="filter-label">📅 End Date</label>
                        <asp:TextBox ID="txtEndDate" runat="server" TextMode="Date" CssClass="filter-control"></asp:TextBox>
                    </div>
                </div>

                <asp:Button ID="btnGenerate" runat="server" Text="Generate Report" CssClass="btn btn-primary" OnClick="btnGenerate_Click" OnClientClick="showLoading();" />
            </div>

            <div class="report-summary">
                <div class="summary-card">
                    <div class="summary-title">Total Records</div>
                    <div class="summary-value">
                        <asp:Literal ID="litTotalRecords" runat="server">0</asp:Literal>
                    </div>
                </div>
                <div class="summary-card" style="border-left-color: #28a745;">
                    <div class="summary-title">Date Range</div>
                    <div class="summary-value small">
                        <asp:Literal ID="litDateRange" runat="server">All Time</asp:Literal>
                    </div>
                </div>
                <div class="summary-card" style="border-left-color: #fd7e14;">
                    <div class="summary-title">Last Updated</div>
                    <div class="summary-value small">
                        <asp:Label ID="Label1" runat="server"></asp:Label>
                    </div>
                </div>
            </div>

            <div class="report-section">
                <asp:Panel ID="pnlNoData" runat="server" CssClass="no-data" Visible="false">
                    <img src="../icons/em1.png" alt="" />
                    <p>No data available for the selected criteria. Try adjusting your filters.</p>
                </asp:Panel>

                <asp:GridView ID="gvReport" runat="server" CssClass="report-table" AutoGenerateColumns="true"
                    EmptyDataText="<div class='no-data'><i class='fas fa-chart-bar' style='font-size: 48px; color: #dee2e6; display: block; margin-bottom: 15px;'></i><p>No data available for the selected criteria</p></div>"
                    AllowPaging="true" PageSize="15" OnPageIndexChanging="gvReport_PageIndexChanging">
                    <PagerSettings Mode="NumericFirstLast" FirstPageText="<<" LastPageText=">>" PageButtonCount="5" />
                    <PagerStyle CssClass="pagination" HorizontalAlign="Right" />
                </asp:GridView>
            </div>

            <div class="report-actions">
                <asp:Button ID="btnExportCSV" runat="server" Text="Export to Excel" CssClass="btn btn-primary" OnClick="btnExportCSV_Click" Visible="false" />
                <asp:Button ID="btnPrint" runat="server" Text="Print Report" CssClass="btn btn-primary" OnClick="btnPrint_Click" />
            </div>
        </div>
    </div>

    <div id="loadingIndicator" class="loading" style="display: none;">
        <div class="loading-spinner"></div>
    </div>

    <script type="text/javascript">
        function showLoading() {
            var loadingIndicator = document.getElementById('loadingIndicator');
            if (loadingIndicator) {
                loadingIndicator.style.display = 'flex';
            }
            return true;
        }

        function hideLoading() {
            var loadingIndicator = document.getElementById('loadingIndicator');
            if (loadingIndicator) {
                loadingIndicator.style.display = 'none';
            }
        }

        window.onload = function () {
            hideLoading();
        };
    </script>
</asp:Content>
