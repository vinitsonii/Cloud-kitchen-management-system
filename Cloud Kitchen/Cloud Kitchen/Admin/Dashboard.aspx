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
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .dashboard-container {
            width: min(100%, 1320px);
            margin: 0 auto;
            padding: clamp(16px, 3vw, 30px);
            animation: fadeIn 0.8s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .dashboard-header-block {
            background: var(--primary-gradient, linear-gradient(135deg, #4A90E2, #1E3C72));
            color: #ffffff;
            border-radius: 16px;
            padding: clamp(1.5rem, 4vw, 2.5rem);
            margin: 0 auto 24px;
            box-shadow: 0 10px 25px rgba(30, 60, 114, 0.15);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            position: relative;
            overflow: hidden;
            width: 100%;
        }

        .dashboard-header-block::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            height: 100%;
            width: 40%;
            background: radial-gradient(circle at center, rgba(255, 255, 255, 0.18), transparent 62%);
            opacity: 0.7;
            pointer-events: none;
        }

        .animated-heading {
            font-size: clamp(1.75rem, 5vw, 2.5rem);
            font-weight: 800;
            letter-spacing: -0.5px;
            margin: 0 0 8px;
            color: #ffffff;
            animation: fadeIn 1s ease-in-out;
            z-index: 2;
        }

        .dashboard-subtitle {
            font-size: clamp(0.95rem, 2vw, 1.1rem);
            color: rgba(255, 255, 255, 0.9);
            font-weight: 400;
            margin: 0;
            letter-spacing: 0.3px;
            z-index: 2;
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

        .table-panel {
            border-radius: 10px;
            overflow: hidden;
        }

        .table-container {
            margin-top: 30px;
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
        }

        .table-container table,
        .table {
            width: 100%;
            min-width: 640px;
            border-collapse: collapse;
            margin: 0;
            background: white;
            animation: fadeInUp 0.8s ease-in-out;
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .table-container th,
        .table-container td {
            padding: 14px;
            border: 1px solid #ddd;
            text-align: left;
            vertical-align: middle;
            white-space: nowrap;
        }

        .table-container th {
            background: #007bff;
            color: white;
            text-transform: uppercase;
            font-size: 14px;
        }

        .table-container tr:nth-child(even) { background: #f8f9fa; }
        .table-container tr:hover { background: #e9ecef; transition: background 0.3s; }

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
            from { opacity: 0; scale: 0.96; }
            to { opacity: 1; scale: 1; }
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
            <h1 class="animated-heading">Cloud Kitchen</h1>
            <p class="dashboard-subtitle">Real-time Admin Analytics & Management</p>
        </div>

        <hr class="section-divider" />

        <div class="row g-4">
            <div class="col-12 col-sm-6 col-xl-3">
                <div class="stat-card">
                    <img alt="Orders" src="../icons/cart1.png" />
                    <h3><asp:Label ID="lblTotalOrders" runat="server" Text="0"></asp:Label></h3>
                    <p>Total Orders</p>
                </div>
            </div>

            <div class="col-12 col-sm-6 col-xl-3">
                <div class="stat-card">
                    <img alt="Revenue" src="../icons/moneyy.png" />
                    <h3>₹<asp:Label ID="lblTotalRevenue" runat="server" Text="0.00"></asp:Label></h3>
                    <p>Total Revenue</p>
                </div>
            </div>

            <div class="col-12 col-sm-6 col-xl-3">
                <div class="stat-card">
                    <img alt="Customers" src="../icons/users1.png" />
                    <h3><asp:Label ID="lblActiveCustomers" runat="server" Text="0"></asp:Label></h3>
                    <p>Active Customers</p>
                </div>
            </div>

            <div class="col-12 col-sm-6 col-xl-3">
                <div class="stat-card">
                    <img alt="Top dish" src="../icons/chef1.png" />
                    <h3><asp:Label ID="lblTopDish" runat="server" Text="No Data"></asp:Label></h3>
                    <p>Top Selling Dish</p>
                </div>
            </div>
        </div>

        <hr class="section-divider" />

        <h3 class="section-title">Popular Food Items</h3>
        <div class="popular-items">
            <asp:Repeater ID="rptPopular" runat="server">
                <ItemTemplate>
                    <div class="item">
                        <img src='<%# Eval("M_Image_Url") %>' alt='<%# Eval("M_Name") %>' />
                        <h4><%# Eval("M_Name") %></h4>
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

        <div class="table-container">
            <hr class="section-divider" />
            <h3 class="section-title">Recent Orders</h3>
            <div class="table-panel">
                <asp:GridView ID="gvRecentOrders" runat="server" CssClass="table" AutoGenerateColumns="true">
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