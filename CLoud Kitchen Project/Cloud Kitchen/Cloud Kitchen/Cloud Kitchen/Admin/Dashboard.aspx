<%@ Page Title="Dashboard" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Admin.Master"
    CodeBehind="Dashboard.aspx.vb" Inherits="Cloud_Kitchen.Dashboard" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
        <style type="text/css">
            body {
                font-family: 'Poppins', sans-serif;
                background-color: #f0f2f5;
                overflow-x: hidden;
                color: #333;
                animation: fadeInBody 1s ease-in;
            }

            @keyframes fadeInBody {
                from {
                    opacity: 0;
                }

                to {
                    opacity: 1;
                }
            }

            .dashboard-container {
                width: min(100%, 1320px);
                margin: 0 auto;
                padding: clamp(16px, 3vw, 30px);
                animation: fadeIn 0.8s ease-in-out;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(-10px);
                }

                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .dashboard-header-block {
                background: #ffffff;
                border: 1px solid #e2e8f0;
                border-left: 6px solid #2563eb;
                border-radius: 16px;
                padding: clamp(16px, 2.5vw, 24px) clamp(16px, 3vw, 32px);
                margin: 0 auto 24px;
                box-shadow: 0 4px 18px rgba(0, 0, 0, 0.03);
                display: flex;
                flex-direction: row;
                align-items: center;
                justify-content: space-between;
                text-align: left;
                position: relative;
                overflow: hidden;
                width: 100%;
                flex-wrap: wrap;
                gap: 12px 16px;
            }

            .animated-heading {
                font-size: clamp(1.25rem, 3.5vw, 2rem);
                font-weight: 800;
                letter-spacing: -0.5px;
                margin: 0;
                color: #0f172a;
                display: flex;
                align-items: flex-start;
                gap: 10px;
                word-break: break-word;
                overflow-wrap: anywhere;
                line-height: 1.25;
            }

            .animated-heading-icon {
                flex: 0 0 auto;
                line-height: 1.2;
            }

            .animated-heading-text {
                flex: 1 1 auto;
                min-width: 0;
            }

            .dashboard-subtitle {
                font-size: clamp(0.82rem, 1.8vw, 0.98rem);
                color: #64748b;
                font-weight: 500;
                margin: 4px 0 0 0;
                letter-spacing: 0.2px;
                word-break: break-word;
            }

            .section-divider {
                border: 0;
                border-top: 1px solid rgba(0, 0, 0, 0.08);
                margin: clamp(18px, 3vw, 28px) 0;
            }

            .stat-card,
            .item,
            .chart-box,
            .table-panel {
                background: linear-gradient(145deg, #ffffff, #e3e6ea);
                box-shadow: 8px 8px 15px #d1d9e6, -8px -8px 15px #ffffff;
            }

            .stat-card {
                min-height: 190px;
                border-radius: 12px;
                padding: clamp(16px, 3vw, 22px);
                text-align: center;
                transition: transform 0.3s ease-in-out, box-shadow 0.3s;
                cursor: pointer;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                gap: 8px;
            }

            .stat-card:hover {
                transform: translateY(-5px);
                box-shadow: 10px 10px 20px #c3c8d1, -10px -10px 20px #ffffff;
            }

            .stat-card img {
                width: clamp(46px, 8vw, 64px);
                height: clamp(46px, 8vw, 64px);
                object-fit: contain;
            }

            .stat-card h3 {
                font-size: clamp(22px, 4vw, 28px);
                margin: 4px 0;
                font-weight: 700;
                max-width: 100%;
                overflow-wrap: anywhere;
            }

            .stat-card p {
                font-size: 14px;
                color: #777;
                margin: 0;
            }

            .section-title {
                font-size: clamp(18px, 3vw, 24px);
                font-weight: 700;
                color: #1e293b;
                margin: 24px 0 16px;
                position: relative;
                padding-bottom: 8px;
                display: inline-block;
            }

            .section-title::after {
                content: '';
                position: absolute;
                bottom: 0;
                left: 0;
                width: 40px;
                height: 3px;
                background: linear-gradient(90deg, #4A90E2, #1E3C72);
                border-radius: 2px;
            }

            .popular-items {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(min(100%, 240px), 1fr));
                gap: 20px;
                margin-top: 20px;
            }

            .item {
                border-radius: 14px;
                text-align: center;
                transition: transform 0.3s ease-in-out, box-shadow 0.3s;
                cursor: pointer;
                overflow: hidden;
                min-height: 330px;
                display: flex;
                flex-direction: column;
            }

            .item:hover {
                transform: translateY(-4px) scale(1.01);
                box-shadow: 8px 8px 20px rgba(0, 0, 0, 0.15);
            }

            .item img {
                width: 100%;
                aspect-ratio: 4 / 3;
                object-fit: cover;
                display: block;
            }

            .item h4 {
                font-size: 18px;
                margin: 14px 12px 6px;
                font-weight: 700;
                overflow-wrap: anywhere;
            }

            .item p {
                font-size: 14px;
                color: #666;
                margin: 0 12px 16px;
            }

            .chart-box {
                min-width: 0;
                padding: clamp(16px, 3vw, 22px);
                border-radius: 10px;
                text-align: center;
                transition: transform 0.3s ease-in-out;
                height: 100%;
            }

            .chart-box:hover {
                transform: scale(1.01);
            }

            .chart-box h2 {
                font-size: clamp(19px, 3vw, 25px);
                font-weight: 700;
                margin-bottom: 16px;
            }

            .chart-wrap {
                position: relative;
                width: 100%;
                height: clamp(260px, 45vw, 380px);
            }

            .chart-empty {
                height: clamp(220px, 40vw, 320px);
                display: none;
                align-items: center;
                justify-content: center;
                color: #777;
                font-weight: 600;
                background: #fff;
                border-radius: 10px;
            }

            /* RECENT ORDERS GLASS CARD & CLEAN TABLE */
            .recent-orders-card {
                background: #ffffff;
                border-radius: 18px;
                border: 1.5px solid #e2e8f0;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.04);
                padding: 24px;
                margin-top: 28px;
            }

            .recent-orders-scroll-box {
                width: 100%;
                overflow-x: auto;
                border-radius: 12px;
                border: 1.5px solid #e2e8f0;
                -webkit-overflow-scrolling: touch;
            }

            .recent-orders-table {
                width: 100%;
                border-collapse: collapse;
                font-size: 14px;
                background: #ffffff;
            }

            .recent-orders-table th {
                background: #2563eb;
                color: #ffffff;
                font-weight: 700;
                text-transform: uppercase;
                font-size: 12px;
                letter-spacing: 0.5px;
                padding: 14px 18px;
                border: none;
            }

            .recent-orders-table td {
                padding: 14px 18px;
                border-bottom: 1px solid #f1f5f9;
                color: #334155;
                vertical-align: middle;
            }

            .recent-orders-table tr:hover {
                background: #f8fafc;
            }

            .status-pill {
                padding: 5px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 700;
                display: inline-flex;
                align-items: center;
                gap: 5px;
            }

            .status-completed {
                background: #f0fdf4;
                color: #15803d;
                border: 1px solid #bbf7d0;
            }

            .status-preparing {
                background: #fffbeb;
                color: #b45309;
                border: 1px solid #fde68a;
            }

            .status-delivery {
                background: #eff6ff;
                color: #1d4ed8;
                border: 1px solid #bfdbfe;
            }

            .status-cancelled {
                background: #fef2f2;
                color: #b91c1c;
                border: 1px solid #fecaca;
            }

            .status-pending {
                background: #f8fafc;
                color: #475569;
                border: 1px solid #e2e8f0;
            }

            .popular-items,
            .charts-row {
                animation: appear linear;
                animation-timeline: view();
                animation-range: entry 0% cover 33%;
            }

            .table-container {
                animation: appear linear;
                animation-timeline: view();
                animation-range: entry 0% cover 15%;
            }

            @keyframes appear {
                from {
                    opacity: 0;
                    scale: 0.96;
                }

                to {
                    opacity: 1;
                    scale: 1;
                }
            }

            @media (max-width: 575.98px) {
                .dashboard-container {
                    padding: 14px;
                }

                .stat-card {
                    min-height: 160px;
                }

                .item {
                    min-height: auto;
                }

                .chart-wrap {
                    height: 280px;
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
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        <div class="dashboard-container">
            <div class="dashboard-header-block">
                <div>
                    <h1 class="animated-heading">
                        <span class="animated-heading-icon">👨‍🍳</span>
                        <span class="animated-heading-text">Cloud Kitchen Admin Dashboard</span>
                    </h1>
                    <p class="dashboard-subtitle">Real-time management center for food orders, revenue, inventory alerts, and sales performance.</p>
                </div>
                <div style="background: #eff6ff; color: #2563eb; border: 1px solid #bfdbfe; font-size: 0.85rem; font-weight: 700; padding: 8px 18px; border-radius: 30px; display: inline-flex; align-items: center; gap: 8px;">
                    <span>🟢 Kitchen Status: <strong>Live & Active</strong></span>
                </div>
            </div>

            <asp:Panel ID="pnlLowStockBanner" runat="server" Visible="false"
                style="background: #fffbebf5; border: 1.5px solid #fde68a; border-left: 6px solid #d97706; border-radius: 12px; padding: 14px 20px; margin-bottom: 24px; box-shadow: 0 4px 12px rgba(217, 119, 6, 0.1); display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 12px;">
                <div style="display: flex; align-items: center; gap: 12px;">
                    <span style="font-size: 1.5rem;">⚠️</span>
                    <div>
                        <strong style="color: #92400e; font-size: 15px;">Attention Admin: Low Stock Alert!</strong>
                        <div style="color: #b45309; font-size: 13.5px; margin-top: 2px;">
                            You have <asp:Label ID="lblBannerLowStockCount" runat="server" Font-Bold="true"></asp:Label>
                            raw ingredient(s) running below safety thresholds or out of stock.
                        </div>
                    </div>
                </div>
                <asp:HyperLink ID="lnkRestockBanner" runat="server" NavigateUrl="ManageInventory.aspx?filter=LowStock"
                    style="background: #d97706; color: white; padding: 8px 18px; border-radius: 8px; font-weight: 700; font-size: 13.5px; text-decoration: none; transition: background 0.2s ease;">
                    ⚡ Restock & Reorder Alerts ➔</asp:HyperLink>
            </asp:Panel>

            <hr class="section-divider" />

            <div class="row g-4">
                <div class="col-12 col-sm-6 col-md-4 col-lg-2">
                    <div class="stat-card">
                        <img alt="Orders" src="../icons/cart1.png" />
                        <h3>
                            <asp:Label ID="lblTotalOrders" runat="server" Text="0"></asp:Label>
                        </h3>
                        <p>Total Orders</p>
                    </div>
                </div>

                <div class="col-12 col-sm-6 col-md-4 col-lg-2">
                    <div class="stat-card">
                        <img alt="Revenue" src="../icons/moneyy.png" />
                        <h3>₹<asp:Label ID="lblTotalRevenue" runat="server" Text="0.00"></asp:Label>
                        </h3>
                        <p>Total Revenue</p>
                    </div>
                </div>

                <div class="col-12 col-sm-6 col-md-4 col-lg-2">
                    <div class="stat-card">
                        <img alt="Customers" src="../icons/users1.png" />
                        <h3>
                            <asp:Label ID="lblActiveCustomers" runat="server" Text="0"></asp:Label>
                        </h3>
                        <p>Active Customers</p>
                    </div>
                </div>

                <div class="col-12 col-sm-6 col-md-4 col-lg-3">
                    <div class="stat-card">
                        <img alt="Top dish" src="../icons/chef1.png" />
                        <h3>
                            <asp:Label ID="lblTopDish" runat="server" Text="No Data"></asp:Label>
                        </h3>
                        <p>Top Selling Dish</p>
                    </div>
                </div>

                <div class="col-12 col-sm-6 col-md-4 col-lg-3">
                    <a href="ManageInventory.aspx" style="text-decoration: none; color: inherit;">
                        <div class="stat-card" style="border: 2px solid #ffc107;">
                            <img alt="Low Stock Alerts" src="../icons/manageitem.png" />
                            <h3>
                                <asp:Label ID="lblLowStockAlerts" runat="server" Text="0"></asp:Label>
                            </h3>
                            <p style="color: #d97706; font-weight: 600;">Low Stock Alerts</p>
                        </div>
                    </a>
                </div>
            </div>

            <hr class="section-divider" />

            <h3 class="section-title">Popular Food Items</h3>
            <div class="popular-items">
                <asp:Repeater ID="rptPopular" runat="server">
                    <ItemTemplate>
                        <div class="item">
                            <img src='<%# Eval("M_Image_Url") %>' alt='<%# Eval("M_Name") %>' />
                            <h4>
                                <%# Eval("M_Name") %>
                            </h4>
                            <p>Ordered <%# Eval("OrderCount") %> times!</p>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <hr class="section-divider" />

            <div class="row g-4 charts-row">
                <div class="col-12 col-xl-6">
                    <div class="chart-box">
                        <h2>Sales Trend</h2>
                        <div class="chart-wrap" id="salesChartWrap">
                            <canvas id="salesChart"></canvas>
                        </div>
                        <div class="chart-empty" id="salesChartEmpty">No sales data available</div>
                    </div>
                </div>

                <div class="col-12 col-xl-6">
                    <div class="chart-box">
                        <h2>Order Status Distribution</h2>
                        <div class="chart-wrap" id="orderStatusChartWrap">
                            <canvas id="orderStatusChart"></canvas>
                        </div>
                        <div class="chart-empty" id="orderStatusChartEmpty">No order status data available</div>
                    </div>
                </div>
            </div>

            <!-- RECENT ORDERS SECTION WITH STICKY HEADER & SMOOTH SCROLL -->
            <div class="recent-orders-card">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; flex-wrap: wrap; gap: 10px;">
                    <h3 class="section-title" style="margin: 0; font-size: 1.25rem;">Recent Orders</h3>
                    <a href="ManageOrders.aspx" style="color: #2563eb; font-weight: 700; font-size: 14px; text-decoration: none;">View All Orders ➔</a>
                </div>

                <div class="recent-orders-scroll-box">
                    <asp:Repeater ID="rptRecentOrders" runat="server">
                        <HeaderTemplate>
                            <table class="recent-orders-table">
                                <thead>
                                    <tr>
                                        <th>Order ID</th>
                                        <th>Customer</th>
                                        <th>Dish Item</th>
                                        <th>Total Amount</th>
                                        <th>Status</th>
                                        <th>Order Date</th>
                                    </tr>
                                </thead>
                                <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td><strong style="color: #2563eb;">#<%# Eval("order_id") %></strong></td>
                                <td><i class="fas fa-user" style="color: #94a3b8; margin-right: 6px;"></i><%# Eval("c_name") %></td>
                                <td><strong style="color: #0f172a;"><%# Eval("m_name") %></strong></td>
                                <td><strong style="color: #15803d;">₹<%# Convert.ToDecimal(Eval("total_amount")).ToString("0.00") %></strong></td>
                                <td><%# GetStatusBadge(Eval("order_status")) %></td>
                                <td style="color: #64748b; font-size: 13px;"><%# Convert.ToDateTime(Eval("order_date")).ToString("dd MMM yyyy, hh:mm tt") %></td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                                </tbody>
                            </table>
                        </FooterTemplate>
                    </asp:Repeater>

                    <asp:GridView ID="gvRecentOrders" runat="server" Visible="false" AutoGenerateColumns="true">
                    </asp:GridView>
                </div>
            </div>
        </div>

        <asp:HiddenField ID="hfChartData" runat="server" />
        <asp:HiddenField ID="hfOrderStatusData" runat="server" />

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                drawSalesChart();
                drawOrderStatusChart();
            });

            function showEmptyState(canvasId, wrapId, emptyId) {
                document.getElementById(canvasId).style.display = "none";
                document.getElementById(wrapId).style.display = "none";
                document.getElementById(emptyId).style.display = "flex";
            }

            function drawSalesChart() {
                var rawData = document.getElementById('<%= hfChartData.ClientID %>').value;
                if (!rawData || rawData.trim() === "" || rawData.trim() === "[]") {
                    showEmptyState("salesChart", "salesChartWrap", "salesChartEmpty");
                    return;
                }

                var chartData = JSON.parse(rawData);
                var labels = chartData.map(row => row[0]);
                var data = chartData.map(row => row[1]);

                var ctx = document.getElementById('salesChart').getContext('2d');
                new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: 'Total Sales',
                            data: data,
                            backgroundColor: ['#4CAF50', '#FFC107', '#FF5733', '#2196F3', '#9C27B0'],
                            borderColor: '#fff',
                            borderWidth: 1,
                            borderRadius: 5,
                            maxBarThickness: 42
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        animation: {
                            duration: 1500,
                            easing: 'easeOutBounce'
                        },
                        plugins: {
                            legend: {
                                labels: {
                                    color: '#333',
                                    font: { size: 13, weight: 'bold' }
                                }
                            }
                        },
                        scales: {
                            x: {
                                ticks: {
                                    maxRotation: 45,
                                    minRotation: 0,
                                    autoSkip: true
                                }
                            },
                            y: {
                                beginAtZero: true
                            }
                        }
                    }
                });
            }

            function drawOrderStatusChart() {
                var rawData = document.getElementById('<%= hfOrderStatusData.ClientID %>').value;
                if (!rawData || rawData.trim() === "" || rawData.trim() === "[]") {
                    showEmptyState("orderStatusChart", "orderStatusChartWrap", "orderStatusChartEmpty");
                    return;
                }

                var chartData = JSON.parse(rawData);
                var labelMap = {};

                chartData.forEach(row => {
                    var label = row[0];
                    var count = row[1];
                    labelMap[label] = (labelMap[label] || 0) + count;
                });

                var labels = Object.keys(labelMap);
                var data = Object.values(labelMap);
                var colors = ['#FF5733', '#4CAF50', '#2196F3', '#9C27B0', '#E91E63', '#FFC107'];

                var ctx = document.getElementById('orderStatusChart').getContext('2d');
                new Chart(ctx, {
                    type: 'doughnut',
                    data: {
                        labels: labels,
                        datasets: [{
                            data: data,
                            backgroundColor: colors,
                            borderColor: '#fff',
                            borderWidth: 2
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                labels: {
                                    color: '#333',
                                    font: { size: 13, weight: 'bold' },
                                    boxWidth: 14
                                },
                                position: 'bottom'
                            }
                        },
                        cutout: '60%',
                        animation: {
                            animateRotate: true,
                            animateScale: true
                        }
                    }
                });
            }
        </script>
    </asp:Content>