<%@ Page Title="Admin Dashboard" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Admin.Master" CodeBehind="WebForm2.aspx.vb" Inherits="Cloud_Kitchen.WebForm2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <style>
        /* Dashboard Grid */
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        /* Card Styles */
        .dashboard-card {
            background: #fff;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .dashboard-card i {
            font-size: 2rem;
            margin-bottom: 10px;
            color: #3F51B5;
        }

        .dashboard-card h3 {
            font-size: 1.2rem;
            margin: 0;
        }

        .dashboard-card p {
            font-size: 1.5rem;
            font-weight: bold;
            margin: 5px 0 0;
        }

        /* Recent Orders */
        .recent-orders {
            margin-top: 30px;
        }

        .recent-orders table {
            width: 100%;
            border-collapse: collapse;
        }

        .recent-orders th,
        .recent-orders td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }

        .recent-orders th {
            background: #3F51B5;
            color: #fff;
        }

        .recent-orders tr:nth-child(even) {
            background: #f9f9f9;
        }

        .recent-orders tr:hover {
            background: #f1f1f1;
        }

        /* Quick Actions */
        .quick-actions {
            margin-top: 30px;
        }

        .quick-actions button {
            background: #5C6BC0;
            color: #fff;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            margin-right: 10px;
            transition: background 0.3s;
        }

        .quick-actions button:hover {
            background: #3F51B5;
        }
    </style>

    <!-- Dashboard Overview Cards -->
    <h2>Admin Dashboard</h2>
    <div class="dashboard-grid">
        <div class="dashboard-card">
            <i class="fas fa-receipt"></i>
            <h3>Total Orders</h3>
            <p>1,250</p>
        </div>
        <div class="dashboard-card">
            <i class="fas fa-users"></i>
            <h3>Total Users</h3>
            <p>340</p>
        </div>
        <div class="dashboard-card">
            <i class="fas fa-dollar-sign"></i>
            <h3>Total Revenue</h3>
            <p>45,200</p>
        </div>
        <div class="dashboard-card">
            <i class="fas fa-chart-line"></i>
            <h3>Monthly Growth</h3>
            <p>8.5%</p>
        </div>
    </div>

    <!-- Recent Orders Table -->
    <div class="recent-orders">
        <h3>Recent Orders</h3>
        <table>
            <thead>
                <tr>
                    <th>Order ID</th>
                    <th>Customer</th>
                    <th>Status</th>
                    <th>Total</th>
                    <th>Date</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>#1001</td>
                    <td>John Doe</td>
                    <td><span style="color: green;">Completed</span></td>
                    <td>500</td>
                    <td>2024-06-20</td>
                </tr>
                <tr>
                    <td>#1002</td>
                    <td>Jane Smith</td>
                    <td><span style="color: orange;">Pending</span></td>
                    <td>985</td>
                    <td>2024-06-21</td>
                </tr>
                <tr>
                    <td>#1003</td>
                    <td>Mike Ross</td>
                    <td><span style="color: red;">Cancelled</span></td>
                    <td>940</td>
                    <td>2024-06-22</td>
                </tr>
            </tbody>
        </table>
    </div>

    <!-- Quick Actions -->
    <div class="quick-actions">
        <h3>Quick Actions</h3>
        <button onclick="window.location='ManageOrders.aspx'">Manage Orders</button>
        <button onclick="window.location='ManageUsers.aspx'">Manage Users</button>
        <button onclick="window.location='Reports.aspx'">View Reports</button>
    </div>

</asp:Content>
