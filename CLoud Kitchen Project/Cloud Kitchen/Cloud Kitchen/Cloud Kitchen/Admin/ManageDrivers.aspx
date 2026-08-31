<%@ Page Title="Manage Delivery Partners" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Admin.Master"
    CodeBehind="ManageDrivers.aspx.vb" Inherits="Cloud_Kitchen.ManageDrivers" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
        <style type="text/css">
            .driver-page-container {
                width: min(100%, 1280px);
                margin: 0 auto;
                padding: clamp(12px, 2vw, 24px);
                font-family: 'Poppins', -apple-system, BlinkMacSystemFont, sans-serif;
            }

            .driver-header-card {
                background: #ffffff;
                border-radius: 14px;
                padding: clamp(16px, 2.5vw, 24px);
                margin-bottom: 24px;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.04);
                border: 1px solid #e2e8f0;
                border-left: 6px solid #2563eb;
                display: flex;
                justify-content: space-between;
                align-items: center;
                flex-wrap: wrap;
                gap: 12px 16px;
                width: 100%;
            }

            .driver-header-title {
                font-size: clamp(1.2rem, 3.5vw, 1.85rem);
                font-weight: 800;
                color: #0f172a;
                margin: 0 0 4px 0;
                display: flex;
                align-items: flex-start;
                gap: 10px;
                line-height: 1.25;
            }

            .driver-header-subtitle {
                font-size: clamp(0.82rem, 1.8vw, 0.95rem);
                color: #64748b;
                margin: 0;
            }

            .driver-card {
                background: #ffffff;
                border-radius: 14px;
                padding: clamp(16px, 2.5vw, 24px);
                margin-bottom: 24px;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.03);
                border: 1px solid #e2e8f0;
            }

            .form-grid-4 {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
                gap: 16px;
                margin-bottom: 16px;
            }

            .form-group-custom {
                display: flex;
                flex-direction: column;
                gap: 6px;
            }

            .form-label-custom {
                font-size: 13px;
                font-weight: 700;
                color: #334155;
            }

            .form-control-custom {
                padding: 10px 14px;
                border-radius: 8px;
                border: 1px solid #cbd5e1;
                font-size: 14px;
                font-family: inherit;
                outline: none;
                transition: border-color 0.2s, box-shadow 0.2s;
                width: 100%;
                box-sizing: border-box;
            }

            .form-control-custom:focus {
                border-color: #2563eb;
                box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.15);
            }

            .btn-action {
                min-height: 42px;
                padding: 10px 20px;
                font-weight: 700;
                font-size: 14px;
                border-radius: 8px;
                border: none;
                cursor: pointer;
                transition: all 0.2s ease;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                gap: 6px;
            }

            .btn-primary-custom {
                background: #2563eb;
                color: #ffffff;
                box-shadow: 0 4px 12px rgba(37, 99, 235, 0.2);
            }

            .btn-primary-custom:hover {
                background: #1d4ed8;
                transform: translateY(-1px);
            }

            .btn-secondary-custom {
                background: #f1f5f9;
                color: #475569;
                border: 1px solid #cbd5e1;
            }

            .driver-table {
                width: 100%;
                border-collapse: collapse;
                font-size: 14px;
            }

            .driver-table th {
                background: #f8fafc;
                color: #475569;
                font-size: 12px;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                padding: 12px 16px;
                text-align: left;
                border-bottom: 2px solid #e2e8f0;
            }

            .driver-table td {
                padding: 14px 16px;
                border-bottom: 1px solid #f1f5f9;
                color: #1e293b;
                vertical-align: middle;
            }

            .driver-table tr:hover {
                background: #f8fafc;
            }

            .status-badge {
                padding: 4px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 700;
                display: inline-block;
            }

            .status-available {
                background: #dcfce7;
                color: #15803d;
            }

            .status-ondelivery {
                background: #fef3c7;
                color: #b45309;
            }

            .status-inactive {
                background: #fee2e2;
                color: #b91c1c;
            }
        </style>
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <asp:UpdatePanel ID="updDrivers" runat="server">
            <ContentTemplate>
                <div class="driver-page-container">
                    <!-- Header Banner -->
                    <div class="driver-header-card">
                        <div>
                            <h1 class="driver-header-title">
                                <span style="flex: 0 0 auto;">🛵</span>
                                <span>Manage Delivery Partners</span>
                            </h1>
                            <p class="driver-header-subtitle">Register in-house delivery partners, manage vehicle
                                numbers, login credentials, and status.</p>
                        </div>
                        <div
                            style="background: #eff6ff; color: #2563eb; border: 1px solid #bfdbfe; font-size: 0.85rem; font-weight: 700; padding: 6px 16px; border-radius: 30px; display: inline-flex; align-items: center; gap: 6px;">
                            <span>🚚 Fleet Management</span>
                        </div>
                    </div>

                    <!-- Driver Access Portal Banner with Camera QR Code 
                <div style="background: linear-gradient(135deg, #1e293b, #0f172a); border-radius: 16px; padding: 20px 24px; margin-bottom: 24px; color: #ffffff; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px; box-shadow: 0 4px 16px rgba(15, 23, 42, 0.15);">
                    <div style="display: flex; align-items: center; gap: 16px; flex-wrap: wrap;">
                        <div style="background: #ffffff; padding: 6px; border-radius: 12px; display: inline-flex; align-items: center; justify-content: center; box-shadow: 0 4px 12px rgba(0,0,0,0.2);">
                            <img src="https://api.qrserver.com/v1/create-qr-code/?size=100x100&data=http://localhost/Cloud%20Kitchen/Driver/DriverLogin.aspx" alt="Scan QR Code" style="width: 90px; height: 90px; border-radius: 6px;" />
                        </div>
                        <div>
                            <div style="font-size: 1.1rem; font-weight: 800; color: #38bdf8; display: flex; align-items: center; gap: 6px;">
                                <span>📱 1-Scan Smartphone QR Access</span>
                            </div>
                            <div style="font-size: 0.85rem; color: #94a3b8; margin-top: 4px; max-width: 480px; line-height: 1.4;">
                                Drivers simply scan this QR code with their phone camera at the kitchen counter to immediately launch their driver app! Zero URL typing required.
                            </div>
                        </div>
                    </div>
                    <div style="display: flex; gap: 10px; flex-wrap: wrap;">
                        <a href="../Driver/DriverLogin.aspx" target="_blank" style="background: #2563eb; color: #ffffff; padding: 10px 18px; border-radius: 10px; font-weight: 700; font-size: 13px; text-decoration: none; display: inline-flex; align-items: center; gap: 6px; box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);">
                            🚀 Launch App Preview ➔
                        </a>
                    </div>
                </div> -->

                    <asp:Label ID="lblMsg" runat="server" EnableViewState="false"
                        style="display: block; margin-bottom: 16px; font-weight: 700; border-radius: 10px; padding: 10px 16px;">
                    </asp:Label>

                    <!-- Stat Cards -->
                    <div
                        style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; margin-bottom: 24px;">
                        <div
                            style="background: #ffffff; border-radius: 12px; padding: 16px 20px; border: 1px solid #e2e8f0; border-left: 4px solid #2563eb; box-shadow: 0 2px 8px rgba(0,0,0,0.03);">
                            <div style="font-size: 12px; font-weight: 700; color: #64748b; text-transform: uppercase;">
                                Total Delivery Drivers</div>
                            <div style="font-size: 1.5rem; font-weight: 800; color: #0f172a; margin-top: 4px;">
                                <asp:Label ID="lblTotalDrivers" runat="server" Text="0"></asp:Label>
                            </div>
                        </div>
                        <div
                            style="background: #ffffff; border-radius: 12px; padding: 16px 20px; border: 1px solid #e2e8f0; border-left: 4px solid #16a34a; box-shadow: 0 2px 8px rgba(0,0,0,0.03);">
                            <div style="font-size: 12px; font-weight: 700; color: #64748b; text-transform: uppercase;">
                                Available Drivers</div>
                            <div style="font-size: 1.5rem; font-weight: 800; color: #16a34a; margin-top: 4px;">
                                <asp:Label ID="lblAvailableDrivers" runat="server" Text="0"></asp:Label>
                            </div>
                        </div>
                        <div
                            style="background: #ffffff; border-radius: 12px; padding: 16px 20px; border: 1px solid #e2e8f0; border-left: 4px solid #d97706; box-shadow: 0 2px 8px rgba(0,0,0,0.03);">
                            <div style="font-size: 12px; font-weight: 700; color: #64748b; text-transform: uppercase;">
                                Currently On Delivery</div>
                            <div style="font-size: 1.5rem; font-weight: 800; color: #d97706; margin-top: 4px;">
                                <asp:Label ID="lblOnDeliveryDrivers" runat="server" Text="0"></asp:Label>
                            </div>
                        </div>
                    </div>

                    <!-- Form Section -->
                    <div class="driver-card">
                        <h3 style="font-size: 1.1rem; font-weight: 800; color: #0f172a; margin: 0 0 16px 0;">
                            <asp:Literal ID="litFormTitle" runat="server" Text="➕ Register New Delivery Partner">
                            </asp:Literal>
                        </h3>
                        <asp:HiddenField ID="hfDriverId" runat="server" />

                        <div class="form-grid-4">
                            <div class="form-group-custom">
                                <label class="form-label-custom">Driver Name *</label>
                                <asp:TextBox ID="txtDriverName" runat="server" CssClass="form-control-custom"
                                    Placeholder="e.g. Ramesh Kumar"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvDriverName" runat="server"
                                    ControlToValidate="txtDriverName" ErrorMessage="Driver Name is required."
                                    ForeColor="#dc2626" Display="Dynamic" Font-Size="12px" Font-Bold="true"
                                    ValidationGroup="vgDriver" />
                            </div>

                            <div class="form-group-custom">
                                <label class="form-label-custom">Phone Number (Login Username) *</label>
                                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control-custom"
                                    Placeholder="e.g. 9876543210"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvPhone" runat="server" ControlToValidate="txtPhone"
                                    ErrorMessage="Phone is required." ForeColor="#dc2626" Display="Dynamic"
                                    Font-Size="12px" Font-Bold="true" ValidationGroup="vgDriver" />
                                <asp:RegularExpressionValidator ID="revPhone" runat="server"
                                    ControlToValidate="txtPhone" ValidationExpression="^\d{10}$"
                                    ErrorMessage="Must be 10 digits." ForeColor="#dc2626" Display="Dynamic"
                                    Font-Size="12px" Font-Bold="true" ValidationGroup="vgDriver" />
                            </div>

                            <div class="form-group-custom">
                                <label class="form-label-custom">Password *</label>
                                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control-custom"
                                    Placeholder="e.g. 123456"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                                    ControlToValidate="txtPassword" ErrorMessage="Password is required."
                                    ForeColor="#dc2626" Display="Dynamic" Font-Size="12px" Font-Bold="true"
                                    ValidationGroup="vgDriver" />
                            </div>

                            <div class="form-group-custom">
                                <label class="form-label-custom">Vehicle Number *</label>
                                <asp:TextBox ID="txtVehicleNo" runat="server" CssClass="form-control-custom"
                                    Placeholder="e.g. GJ-01-AB-1234"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvVehicleNo" runat="server"
                                    ControlToValidate="txtVehicleNo" ErrorMessage="Vehicle No is required."
                                    ForeColor="#dc2626" Display="Dynamic" Font-Size="12px" Font-Bold="true"
                                    ValidationGroup="vgDriver" />
                            </div>
                        </div>

                        <div style="display: flex; gap: 10px; justify-content: flex-end; margin-top: 12px;">
                            <asp:Button ID="btnSaveDriver" runat="server" Text="💾 Save Driver"
                                CssClass="btn-action btn-primary-custom" OnClick="btnSaveDriver_Click"
                                ValidationGroup="vgDriver" />
                            <asp:Button ID="btnCancelDriver" runat="server" Text="Cancel"
                                CssClass="btn-action btn-secondary-custom" OnClick="btnCancelDriver_Click"
                                CausesValidation="false" />
                        </div>
                    </div>

                    <!-- Drivers Table with Status Filter -->
                    <div class="driver-card">
                        <div
                            style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; flex-wrap: wrap; gap: 12px;">
                            <h3 style="font-size: 1.1rem; font-weight: 800; color: #0f172a; margin: 0;">📋 Registered
                                Delivery Fleet</h3>
                            <div style="display: flex; gap: 10px; align-items: center; flex-wrap: wrap;">
                                <asp:DropDownList ID="ddlStatusFilter" runat="server" CssClass="form-control-custom"
                                    style="width: 160px;" AutoPostBack="true"
                                    OnSelectedIndexChanged="ddlStatusFilter_SelectedIndexChanged"
                                    CausesValidation="false">
                                    <asp:ListItem Text="All Statuses" Value="All"></asp:ListItem>
                                    <asp:ListItem Text="🟢 Available" Value="Available"></asp:ListItem>
                                    <asp:ListItem Text="🛵 On Delivery" Value="On Delivery"></asp:ListItem>
                                    <asp:ListItem Text="🔴 Inactive" Value="Inactive"></asp:ListItem>
                                </asp:DropDownList>
                                <asp:TextBox ID="txtSearchDriver" runat="server" CssClass="form-control-custom"
                                    style="width: 200px;" Placeholder="🔍 Search driver or phone..." AutoPostBack="true"
                                    OnTextChanged="txtSearchDriver_TextChanged" CausesValidation="false"></asp:TextBox>
                            </div>
                        </div>

                        <div style="overflow-x: auto;">
                            <asp:Repeater ID="rptDrivers" runat="server" OnItemCommand="rptDrivers_ItemCommand">
                                <HeaderTemplate>
                                    <table class="driver-table">
                                        <thead>
                                            <tr>
                                                <th>Driver Name</th>
                                                <th>Phone Number</th>
                                                <th>Vehicle No</th>
                                                <th>Status</th>
                                                <th>Registered Date</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td><strong>
                                                <%# Eval("driver_name") %>
                                            </strong></td>
                                        <td>
                                            <%# Eval("phone") %>
                                        </td>
                                        <td><code><%# Eval("vehicle_no") %></code></td>
                                        <td>
                                            <span class='status-badge <%# GetStatusCss(Eval("status").ToString()) %>'>
                                                <%# Eval("status") %>
                                            </span>
                                        </td>
                                        <td>
                                            <%# Eval("created_date", "{0:dd-MMM-yyyy}" ) %>
                                        </td>
                                        <td>
                                            <asp:Button ID="btnEdit" runat="server" Text="✏️ Edit"
                                                CssClass="btn-action btn-secondary-custom"
                                                style="padding: 4px 10px; min-height: 32px; font-size: 12px;"
                                                CommandName="EditDriver" CommandArgument='<%# Eval("driver_id") %>'
                                                CausesValidation="false" />
                                            <asp:Button ID="btnToggle" runat="server"
                                                Text='<%# IIf(Eval("status").ToString() = "Inactive", "🟢 Activate", "🔴 Deactivate") %>'
                                                CssClass="btn-action btn-secondary-custom"
                                                style="padding: 4px 10px; min-height: 32px; font-size: 12px; margin-left: 6px;"
                                                CommandName="ToggleStatus" CommandArgument='<%# Eval("driver_id") %>'
                                                CausesValidation="false" />
                                            <!--<a href='<%# GetWhatsAppUrl(Eval("phone"), Eval("driver_name")) %>' target='_blank' class='btn-action btn-secondary-custom' style='padding: 4px 10px; min-height: 32px; font-size: 12px; margin-left: 6px; background: #dcfce7; color: #15803d; border-color: #bbf7d0; text-decoration: none;'>
                                            💬 WhatsApp Link
                                        </a>-->
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate>
                                    </tbody>
                                    </table>
                                </FooterTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </asp:Content>