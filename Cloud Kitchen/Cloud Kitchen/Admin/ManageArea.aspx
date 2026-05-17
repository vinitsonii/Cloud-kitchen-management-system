<%@ Page Title="Manage Service Areas" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Admin.Master" CodeBehind="ManageArea.aspx.vb" Inherits="Cloud_Kitchen.ManageArea" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        :root {
            --area-primary-color: #4361ee;
            --area-primary-dark: #3a0ca3;
            --area-primary-light: #eef2ff;
            --area-primary-gradient: linear-gradient(135deg, #4361ee, #3a0ca3);
            --area-secondary-color: #f72585;
            --area-secondary-dark: #d31876;
            --area-secondary-light: #feeaf3;
            --area-text-primary: #2d3748;
            --area-text-secondary: #64748b;
            --area-text-light: #ffffff;
            --area-border-color: #e2e8f0;
            --area-bg-light: #f8fafc;
            --area-bg-body: #f5f7fa;
            --area-success: #10b981;
            --area-success-dark: royalblue;
            --area-success-light: #ecfdf5;
            --area-shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.1);
            --area-shadow-md: 0 4px 6px rgba(0, 0, 0, 0.07), 0 12px 16px rgba(0, 0, 0, 0.03);
            --area-shadow-lg: 0 10px 25px rgba(0, 0, 0, 0.1);
            --area-shadow-focus: 0 0 0 3px rgba(67, 97, 238, 0.3);
            --area-transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            --area-radius-sm: 6px;
            --area-radius-md: 10px;
            --area-radius-lg: 16px;
        }

        .manage-area-page {
            width: min(100%, 1240px);
            margin: 0 auto;
            font-family: 'Poppins', sans-serif;
            color: var(--area-text-primary);
            line-height: 1.6;
        }

        .dashboard-header {
            background: var(--area-primary-gradient);
            color: var(--area-text-light);
            padding: clamp(1.5rem, 4vw, 2.5rem);
            margin-bottom: clamp(1.5rem, 4vw, 2.5rem);
            border-radius: var(--area-radius-lg);
            box-shadow: var(--area-shadow-lg);
            position: relative;
            overflow: hidden;
        }

        .dashboard-header::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            height: 100%;
            width: 40%;
            background: radial-gradient(circle at center, rgba(255, 255, 255, 0.18), transparent 62%);
            opacity: 0.7;
        }

        .dashboard-title {
            font-size: clamp(1.75rem, 5vw, 2.25rem);
            font-weight: 800;
            margin-bottom: 0.75rem;
            line-height: 1.2;
            position: relative;
            z-index: 2;
            overflow-wrap: anywhere;
        }

        .dashboard-description {
            font-size: clamp(0.98rem, 2vw, 1.1rem);
            opacity: 0.9;
            max-width: 720px;
            position: relative;
            z-index: 2;
            margin: 0;
        }

        .stats-container {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: clamp(1rem, 3vw, 1.75rem);
            margin-bottom: clamp(1.5rem, 4vw, 2.5rem);
        }

        .stat-card {
            min-width: 0;
            background: white;
            border-radius: var(--area-radius-lg);
            padding: clamp(1.25rem, 3vw, 1.75rem);
            box-shadow: var(--area-shadow-md);
            display: flex;
            align-items: center;
            gap: clamp(1rem, 3vw, 1.75rem);
            transition: var(--area-transition);
            border: 1px solid rgba(230, 235, 245, 0.8);
            position: relative;
            overflow: hidden;
        }

        .stat-card::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--area-primary-gradient);
            transform: scaleX(0);
            transform-origin: left;
            transition: transform 0.4s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--area-shadow-lg);
        }

        .stat-card:hover::after {
            transform: scaleX(1);
        }

        .stat-icon {
            flex: 0 0 auto;
            background: var(--area-primary-light);
            width: clamp(60px, 9vw, 70px);
            height: clamp(60px, 9vw, 70px);
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }

        .stat-icon::before {
            content: '';
            position: absolute;
            top: -10px;
            right: -10px;
            width: 40px;
            height: 40px;
            background: rgba(67, 97, 238, 0.2);
            border-radius: 50%;
        }

        .stat-icon img {
            width: 40px;
            height: 40px;
            object-fit: contain;
            position: relative;
            z-index: 1;
        }

        .stat-info {
            flex-grow: 1;
            min-width: 0;
        }

        .stat-value {
            font-size: clamp(1.75rem, 5vw, 2.25rem);
            font-weight: 800;
            color: var(--area-text-primary);
            margin-bottom: 0.25rem;
            line-height: 1.2;
            background: var(--area-primary-gradient);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
            overflow-wrap: anywhere;
        }

        .stat-label {
            font-size: 1rem;
            font-weight: 500;
            color: var(--area-text-secondary);
            letter-spacing: 0.3px;
        }

        .update-panel {
            position: relative;
            padding: clamp(1.25rem, 4vw, 2.5rem);
            background: #ffffff;
            border-radius: var(--area-radius-lg);
            box-shadow: var(--area-shadow-md);
            width: 100%;
            margin: 0 auto 2.5rem;
            transition: var(--area-transition);
            border: 1px solid rgba(230, 235, 245, 0.8);
            overflow: hidden;
        }

        .floating-panel {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            z-index: 2050;
            max-height: min(85vh, 720px);
            overflow-y: auto;
            background: #ffffff;
            border-radius: var(--area-radius-lg);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.25);
            width: min(500px, calc(100vw - 24px));
            padding: clamp(1.5rem, 4vw, 2.5rem);
            animation: fadeInScale 0.35s cubic-bezier(0.16, 1, 0.3, 1);
            border: 1px solid rgba(230, 235, 245, 0.8);
        }

        .overlay {
            position: fixed;
            inset: 0;
            background-color: rgba(17, 24, 39, 0.6);
            backdrop-filter: blur(4px);
            z-index: 2000;
            animation: fadeIn 0.25s ease-out;
        }

        .manage-area-page h3 {
            font-family: 'Poppins', sans-serif;
            font-size: clamp(1.4rem, 4vw, 1.75rem);
            color: var(--area-primary-color);
            text-align: center;
            font-weight: 700;
            margin-bottom: 2rem;
            position: relative;
            padding-bottom: 0.75rem;
        }

        .manage-area-page h3::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 60px;
            height: 4px;
            background: var(--area-primary-gradient);
            border-radius: 4px;
        }

        .grid-manage h2 {
            font-family: 'Poppins', sans-serif;
            font-size: clamp(1.2rem, 3vw, 1.5rem);
            font-weight: 700;
            text-align: left;
            color: var(--area-text-primary);
            margin: 2.25rem 0 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            overflow-wrap: anywhere;
        }

        .grid-manage h2 img {
            width: 36px;
            height: 36px;
            object-fit: contain;
            flex: 0 0 auto;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
            margin-bottom: 1.75rem;
        }

        .form-group label {
            font-size: 1rem;
            font-weight: 600;
            color: var(--area-text-primary);
        }

        .manage-area-page input[type="text"],
        .manage-area-page select,
        .manage-area-page .form-control {
            width: 100% !important;
            max-width: 100%;
            padding: 0.9rem 1.1rem;
            font-size: 1rem;
            border: 1px solid var(--area-border-color);
            border-radius: var(--area-radius-md);
            background: #ffffff;
            transition: var(--area-transition);
            box-shadow: var(--area-shadow-sm);
        }

        .manage-area-page input[type="text"]:focus,
        .manage-area-page select:focus,
        .manage-area-page .form-control:focus {
            border-color: var(--area-primary-color);
            outline: none;
            box-shadow: var(--area-shadow-focus);
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
            margin-top: 2rem;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .btn {
            min-height: 44px;
            padding: 0.85rem 1.5rem;
            font-size: 1rem;
            font-weight: 700;
            border: none;
            border-radius: var(--area-radius-md);
            cursor: pointer;
            transition: var(--area-transition);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.6rem;
            letter-spacing: 0.3px;
            box-shadow: var(--area-shadow-sm);
            text-decoration: none;
            white-space: nowrap;
        }

        .btn-save {
            background: var(--area-primary-gradient);
            color: white;
            position: relative;
            overflow: hidden;
        }

        .btn-save:hover {
            transform: translateY(-3px);
            box-shadow: 0 7px 14px rgba(67, 97, 238, 0.3);
        }

        .btn-cancel {
            background: #f1f5f9;
            color: var(--area-text-secondary);
            position: relative;
            overflow: hidden;
        }

        .btn-cancel:hover {
            background: #e2e8f0;
            transform: translateY(-3px);
            box-shadow: var(--area-shadow-md);
        }

        .btn-add {
            background: var(--area-success);
            color: white;
            margin-bottom: 1.5rem;
            align-self: flex-start;
            position: relative;
            overflow: hidden;
        }

        .btn-add:hover {
            background: var(--area-success-dark);
            transform: translateY(-3px);
            box-shadow: 0 7px 14px rgba(16, 185, 129, 0.25);
        }

        .btn-table {
            padding: 0.6rem 1.15rem;
            font-size: 0.9rem;
            border-radius: var(--area-radius-sm);
            min-height: 38px;
        }

        .btn-edit {
            background: var(--area-primary-color);
            color: white;
        }

        .btn-edit:hover {
            background: var(--area-primary-dark);
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(67, 97, 238, 0.25);
        }

        .btn-delete {
            background: var(--area-secondary-color);
            color: white;
        }

        .btn-delete:hover {
            background: var(--area-secondary-dark);
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(247, 37, 133, 0.25);
        }

        .table-responsive {
            width: 100%;
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
            border-radius: var(--area-radius-lg);
            box-shadow: var(--area-shadow-md);
            border: 1px solid rgba(230, 235, 245, 0.8);
            background: white;
        }

        table.table-bordered {
            width: 100%;
            min-width: 560px;
            border-collapse: separate;
            border-spacing: 0;
            margin: 0;
            overflow: hidden;
            background: white;
        }

        table.table-bordered thead {
            background: var(--area-primary-gradient);
            color: white;
            font-weight: 600;
        }

        table.table-bordered th,
        table.table-bordered td {
            padding: 1rem 1.25rem;
            border: 1px solid var(--area-border-color);
            text-align: left;
            font-size: 1rem;
            vertical-align: middle;
        }

        table.table-bordered th {
            text-transform: uppercase;
            font-size: 0.9rem;
            letter-spacing: 1px;
            font-weight: 700;
            white-space: nowrap;
        }

        table.table-bordered tbody tr:nth-child(even) {
            background: rgba(243, 246, 252, 0.7);
        }

        table.table-bordered tbody tr {
            transition: background 0.3s ease;
        }

        table.table-bordered tbody tr:hover {
            background: var(--area-primary-light);
        }

        .action-buttons {
            display: flex;
            gap: 0.75rem;
            flex-wrap: wrap;
        }

        .lblmsg {
            color: var(--area-secondary-color);
            text-align: center;
            font-size: 1rem;
            font-weight: 500;
            overflow-wrap: anywhere;
        }

        .message {
            text-align: center;
            font-size: 1rem;
            padding: 1.25rem;
            border-radius: var(--area-radius-md);
            margin: 1.5rem 0;
            animation: slideDown 0.3s ease-out;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.75rem;
        }

        .message.success {
            background-color: var(--area-success-light);
            color: var(--area-success-dark);
            border: 1px solid rgba(16, 185, 129, 0.2);
        }

        .message.error {
            background-color: var(--area-secondary-light);
            color: var(--area-secondary-dark);
            border: 1px solid rgba(247, 37, 133, 0.2);
        }

        .no-data {
            text-align: center;
            padding: 3rem 2rem;
            color: var(--area-text-secondary);
            font-style: italic;
            background-color: var(--area-bg-light);
            border-radius: var(--area-radius-lg);
            margin-top: 1.5rem;
            border: 2px dashed var(--area-border-color);
        }

        .no-data p {
            margin: 0;
        }

        .search-bar {
            display: grid;
            grid-template-columns: minmax(0, 1fr) auto auto;
            gap: 0.9rem;
            margin-bottom: 1.5rem;
            align-items: center;
            width: 100%;
            background: var(--area-bg-light);
            padding: 0.75rem;
            border-radius: var(--area-radius-md);
            border: 1px solid var(--area-border-color);
        }

        .search-bar input {
            width: 100% !important;
            max-width: none;
        }

        .error-message {
            color: var(--area-secondary-color);
            font-size: 0.85rem;
            margin-top: 0.35rem;
            display: block;
            animation: fadeIn 0.3s ease;
            overflow-wrap: anywhere;
        }

        .manage-area-page *:focus-visible {
            outline: 2px solid var(--area-primary-color);
            outline-offset: 2px;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes slideDown {
            from { transform: translateY(-20px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        @keyframes fadeInScale {
            from { opacity: 0; transform: translate(-50%, -50%) scale(0.95); }
            to { opacity: 1; transform: translate(-50%, -50%) scale(1); }
        }

        @media (max-width: 768px) {
            .stats-container {
                grid-template-columns: 1fr;
            }

            .search-bar {
                grid-template-columns: 1fr;
            }

            .form-actions {
                flex-direction: column;
            }

            .btn {
                width: 100%;
                white-space: normal;
            }

            table.table-bordered th,
            table.table-bordered td {
                padding: 0.85rem;
                font-size: 0.9rem;
            }
        }

        @media (max-width: 480px) {
            .dashboard-header {
                border-radius: 12px;
            }

            .dashboard-description {
                max-width: 100%;
            }

            .stat-card {
                padding: 1.25rem;
                align-items: flex-start;
            }

            .floating-panel {
                width: 100%;
                height: 100%;
                max-height: 100%;
                border-radius: 0;
                top: 0;
                left: 0;
                transform: none;
            }

            .floating-panel {
                animation: fadeIn 0.25s ease-out;
            }

            .action-buttons {
                flex-direction: column;
            }

            .btn-save:hover,
            .btn-cancel:hover,
            .btn-add:hover,
            .btn-edit:hover,
            .btn-delete:hover,
            .stat-card:hover {
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
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>

    <div class="manage-area-page">
        <div class="dashboard-header">
            <h1 class="dashboard-title">Service Area Management</h1>
            <p class="dashboard-description">Manage delivery areas and pincodes for your cloud kitchen service</p>
        </div>

        <div class="stats-container">
            <div class="stat-card">
                <div class="stat-icon">
                    <img src="../icons/loc2.png" alt="" />
                </div>
                <div class="stat-info">
                    <div class="stat-value">
                        <asp:Literal ID="litTotalAreas" runat="server">12</asp:Literal>
                    </div>
                    <div class="stat-label">Total Areas</div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon">
                    <img src="../icons/track.png" alt="" />
                </div>
                <div class="stat-info">
                    <div class="stat-value">
                        <asp:Literal ID="litRecentAdditions" runat="server">3</asp:Literal>
                    </div>
                    <div class="stat-label">Recent Additions</div>
                </div>
            </div>
        </div>

        <div id="messagePanel" class="message success" style="display: none;">
            <asp:Literal ID="litMessage" runat="server"></asp:Literal>
        </div>

        <div class="update-panel">
            <asp:Button ID="btnAddNew" runat="server" Text="➕ Add New Area" CssClass="btn btn-add" OnClick="btnAddNew_Click" CausesValidation="false" />

            <div class="search-bar">
                <asp:TextBox ID="txtSearch" runat="server" placeholder="Search by area name or pincode..." />
                <asp:Button ID="btnSearch" runat="server" Text="🔍 Search" CssClass="btn btn-save" OnClick="btnSearch_Click" CausesValidation="false" />
                <asp:Button ID="btnClearSearch" runat="server" Text="Clear" CssClass="btn btn-cancel" OnClick="btnClearSearch_Click" CausesValidation="false" />
            </div>

            <div class="grid-manage">
                <h2><img src="../icons/loc1.png" alt="" /> Service Areas List</h2>
                <asp:HiddenField ID="hdnDeleteAreaId" runat="server" />

                <div class="table-responsive">
                    <asp:Repeater ID="rptArea" runat="server" OnItemCommand="rptArea_ItemCommand">
                        <HeaderTemplate>
                            <table class="table table-striped table-bordered">
                                <thead>
                                    <tr>
                                        <th>Area Name</th>
                                        <th>Pincode</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td><%# Eval("Area_Name") %></td>
                                <td><%# Eval("Pincode") %></td>
                                <td>
                                    <div class="action-buttons">
                                        <asp:Button ID="btnEdit" runat="server" CssClass="btn btn-table btn-edit" CommandName="EditArea" CommandArgument='<%# Eval("Area_Id") %>' Text="✏️ Edit" CausesValidation="false" />
                                    </div>
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                                </tbody>
                            </table>
                        </FooterTemplate>
                    </asp:Repeater>
                </div>

                <asp:Panel ID="pnlNoData" runat="server" CssClass="no-data" Visible="false">
                    <p>No service areas found. Click "Add New Area" to create one.</p>
                </asp:Panel>
            </div>
        </div>

        <asp:Panel ID="Panel1" runat="server" CssClass="panel-class" Visible="false">
            <div id="overlay" class="overlay" runat="server"></div>
        </asp:Panel>

        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <asp:Panel ID="pnlEditArea" Visible="false" runat="server" CssClass="floating-panel">
                    <h3>
                        <asp:Literal ID="litPanelTitle" runat="server">Add New Service Area</asp:Literal>
                    </h3>

                    <asp:HiddenField ID="hfAreaId" runat="server" />

                    <div class="form-group">
                        <label for="txtArea">Area Name</label>
                        <asp:TextBox ID="txtArea" runat="server" CssClass="form-control" placeholder="Enter area name (e.g. Downtown, Westside)"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvFullName" runat="server" ControlToValidate="txtArea"
                            ErrorMessage="Area Name is required." Display="Dynamic" ForeColor="Red" />
                        <asp:RegularExpressionValidator
                            ID="revFullName"
                            runat="server"
                            ControlToValidate="txtArea"
                            ErrorMessage="Only alphabets and spaces are allowed."
                            ValidationExpression="^[A-Za-z ]+$"
                            Display="Dynamic"
                            ForeColor="Red" />
                    </div>

                    <div class="form-group">
                        <label for="txtPincode">Pincode</label>
                        <asp:TextBox ID="txtPincode" runat="server" CssClass="form-control" placeholder="Enter 6-digit pincode"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvPincode" runat="server" ControlToValidate="txtPincode"
                            ErrorMessage="Pincode is required" CssClass="error-message" Display="Dynamic"
                            ForeColor="red"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="revPincode" runat="server" ControlToValidate="txtPincode"
                            ErrorMessage="Must be a valid 6-digit pincode" ValidationExpression="^\d{6}$" CssClass="error-message"
                            Display="Dynamic" ForeColor="red"></asp:RegularExpressionValidator>
                    </div>

                    <div class="form-group lblmsg">
                        <asp:Label ID="lblmsg" runat="server" ForeColor="Red"></asp:Label>
                    </div>

                    <div class="form-actions">
                        <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="btn btn-save" OnClick="btnSave_Click" />
                        <asp:Button ID="btnUpdate" runat="server" Text="Update" CssClass="btn btn-save" OnClick="btnUpdate_Click" Visible="False" />
                        <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-cancel" OnClick="btnCancel_Click" CausesValidation="false" />
                    </div>
                </asp:Panel>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>

    <script type="text/javascript">
        function hideAddEditPanel() {
            var panel = document.getElementById('<%= Panel1.ClientID %>');
            var overlay = document.getElementById('<%= overlay.ClientID %>');
            if (panel) panel.style.display = "none";
            if (overlay) overlay.style.display = "none";
        }

        function showAddEditPanel() {
            var panel = document.getElementById('<%= Panel1.ClientID %>');
            var overlay = document.getElementById('<%= overlay.ClientID %>');
            if (panel) panel.style.display = "block";
            if (overlay) overlay.style.display = "block";
        }
    </script>
</asp:Content>
