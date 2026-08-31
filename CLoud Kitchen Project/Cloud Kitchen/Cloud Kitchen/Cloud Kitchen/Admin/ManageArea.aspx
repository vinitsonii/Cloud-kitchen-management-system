<%@ Page Title="Manage Service Areas" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Admin.Master" CodeBehind="ManageArea.aspx.vb" Inherits="Cloud_Kitchen.ManageArea" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- FontAwesome 6.4 Free Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    
    <style type="text/css">
        .manage-area-page {
            width: min(100%, 1240px);
            margin: 0 auto;
            font-family: 'Poppins', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            color: #1e293b;
        }

        /* HEADER SECTION */
        .dashboard-header-card {
            background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);
            border-radius: 18px;
            padding: 26px 30px;
            margin-bottom: 24px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.04);
            border: 1.5px solid #e2e8f0;
            border-left: 6px solid #2563eb;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
        }

        .header-title-group h1 {
            font-size: 1.7rem;
            font-weight: 800;
            color: #0f172a;
            margin: 0 0 6px 0;
            display: flex;
            align-items: center;
            gap: 12px;
            letter-spacing: -0.3px;
        }

        .header-title-group p {
            font-size: 0.94rem;
            color: #64748b;
            margin: 0;
            font-weight: 500;
        }

        .btn-header-add {
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            color: #ffffff !important;
            font-weight: 700;
            padding: 12px 24px;
            border-radius: 12px;
            border: none;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            box-shadow: 0 4px 16px rgba(37, 99, 235, 0.28);
            transition: all 0.25s ease-in-out;
            text-decoration: none;
        }

        .btn-header-add:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 22px rgba(37, 99, 235, 0.38);
        }

        /* STATS GRID */
        .stats-grid-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 20px;
            margin-bottom: 24px;
        }

        .stat-card-modern {
            background: #ffffff;
            border-radius: 18px;
            padding: 22px 26px;
            border: 1.5px solid #e2e8f0;
            box-shadow: 0 4px 18px rgba(0, 0, 0, 0.03);
            display: flex;
            align-items: center;
            gap: 20px;
            transition: all 0.25s ease;
            position: relative;
            overflow: hidden;
        }

        .stat-card-modern:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 26px rgba(0, 0, 0, 0.06);
            border-color: #cbd5e1;
        }

        .stat-icon-wrapper {
            width: 58px;
            height: 58px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            flex-shrink: 0;
        }

        .icon-blue {
            background: linear-gradient(135deg, #eff6ff, #dbeafe);
            color: #2563eb;
            border: 1px solid #bfdbfe;
        }

        .icon-emerald {
            background: linear-gradient(135deg, #ecfdf5, #d1fae5);
            color: #10b981;
            border: 1px solid #a7f3d0;
        }

        .icon-amber {
            background: linear-gradient(135deg, #fffbeb, #fef3c7);
            color: #f59e0b;
            border: 1px solid #fde68a;
        }

        .stat-content {
            display: flex;
            flex-direction: column;
        }

        .stat-num-val {
            font-size: 1.9rem;
            font-weight: 800;
            color: #0f172a;
            line-height: 1.1;
        }

        .stat-title-lbl {
            font-size: 0.88rem;
            color: #64748b;
            font-weight: 600;
            margin-top: 4px;
        }

        /* MAIN CONTENT CARD */
        .content-card-main {
            background: #ffffff;
            border-radius: 18px;
            border: 1.5px solid #e2e8f0;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.03);
            padding: 26px;
        }

        /* TABLE TOP BAR */
        .table-top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 18px;
            flex-wrap: wrap;
            gap: 12px;
        }

        .table-title {
            font-size: 1.1rem;
            font-weight: 800;
            color: #0f172a;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* SEARCH BAR */
        .search-filter-box {
            display: flex;
            gap: 12px;
            margin-bottom: 22px;
            background: #f8fafc;
            padding: 14px 18px;
            border-radius: 14px;
            border: 1.5px solid #e2e8f0;
            align-items: center;
            flex-wrap: wrap;
        }

        .search-input-wrapper {
            position: relative;
            flex: 1;
            min-width: 260px;
        }

        .search-input-wrapper i {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
            font-size: 15px;
        }

        .search-input-field {
            width: 100%;
            padding: 11px 16px 11px 40px;
            border: 1.5px solid #cbd5e1;
            border-radius: 10px;
            font-size: 14px;
            outline: none;
            transition: all 0.2s;
            background: #ffffff;
            box-sizing: border-box;
        }

        .search-input-field:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.15);
        }

        .btn-search-action {
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            color: #ffffff;
            font-weight: 700;
            padding: 11px 22px;
            border-radius: 10px;
            border: none;
            cursor: pointer;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
        }

        .btn-search-action:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 14px rgba(37, 99, 235, 0.28);
        }

        .btn-clear-action {
            background: #ffffff;
            color: #475569;
            font-weight: 700;
            padding: 11px 18px;
            border-radius: 10px;
            border: 1.5px solid #cbd5e1;
            cursor: pointer;
            transition: all 0.2s;
            font-size: 14px;
        }

        .btn-clear-action:hover {
            background: #e2e8f0;
            color: #0f172a;
        }

        /* DATA TABLE STYLING */
        .table-responsive-wrapper {
            overflow-x: auto;
            border-radius: 14px;
            border: 1.5px solid #e2e8f0;
        }

        .area-custom-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
            text-align: left;
        }

        .area-custom-table th {
            background: #f8fafc;
            padding: 14px 20px;
            font-weight: 800;
            color: #475569;
            text-transform: uppercase;
            font-size: 12px;
            letter-spacing: 0.5px;
            border-bottom: 1.5px solid #e2e8f0;
        }

        .area-custom-table td {
            padding: 16px 20px;
            border-bottom: 1px solid #f1f5f9;
            color: #334155;
            vertical-align: middle;
        }

        .area-custom-table tbody tr {
            transition: background 0.15s ease-in-out;
        }

        .area-custom-table tbody tr:hover {
            background: #f8fafc;
        }

        .area-name-cell {
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 700;
            color: #0f172a;
        }

        .area-name-icon {
            width: 36px;
            height: 36px;
            border-radius: 10px;
            background: #eff6ff;
            color: #2563eb;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
            border: 1px solid #bfdbfe;
            flex-shrink: 0;
        }

        .pincode-badge {
            background: #f0fdf4;
            color: #166534;
            border: 1px solid #bbf7d0;
            padding: 6px 14px;
            border-radius: 20px;
            font-weight: 800;
            font-size: 13px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .zone-status-pill {
            background: #eff6ff;
            color: #1d4ed8;
            border: 1px solid #bfdbfe;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .action-btn-group {
            display: flex;
            gap: 8px;
        }

        .btn-table-edit {
            background: #eff6ff;
            color: #2563eb;
            border: 1.5px solid #bfdbfe;
            font-weight: 700;
            padding: 7px 16px;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.2s;
            font-size: 13px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .btn-table-edit:hover {
            background: #2563eb;
            color: #ffffff;
        }

        .btn-table-delete {
            background: #fef2f2;
            color: #dc2626;
            border: 1.5px solid #fca5a5;
            font-weight: 700;
            padding: 7px 16px;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.2s;
            font-size: 13px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .btn-table-delete:hover {
            background: #dc2626;
            color: #ffffff;
        }

        /* MODAL POPUP DIALOG */
        .overlay {
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(15, 23, 42, 0.65);
            backdrop-filter: blur(6px);
            z-index: 2000;
        }

        .floating-panel {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            z-index: 2050;
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.22);
            width: min(500px, calc(100vw - 32px));
            padding: 30px;
            border: 1.5px solid #e2e8f0;
        }

        .modal-header-title {
            font-size: 1.4rem;
            font-weight: 800;
            color: #0f172a;
            margin-bottom: 20px;
            padding-bottom: 14px;
            border-bottom: 1.5px solid #e2e8f0;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .form-group-custom {
            display: flex;
            flex-direction: column;
            gap: 6px;
            margin-bottom: 18px;
        }

        .form-group-custom label {
            font-size: 12px;
            font-weight: 800;
            color: #475569;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .modal-input-field {
            width: 100%;
            padding: 12px 16px;
            border: 1.5px solid #cbd5e1;
            border-radius: 10px;
            font-size: 14px;
            outline: none;
            transition: all 0.2s;
            box-sizing: border-box;
        }

        .modal-input-field:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.15);
        }

        .modal-actions-bar {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 24px;
        }

        .message-alert {
            padding: 14px 20px;
            border-radius: 12px;
            margin-bottom: 20px;
            font-size: 14px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .message-alert.success {
            background: #f0fdf4;
            color: #15803d;
            border: 1.5px solid #bbf7d0;
        }

        .message-alert.error {
            background: #fef2f2;
            color: #b91c1c;
            border: 1.5px solid #fecaca;
        }

        .no-data-card {
            text-align: center;
            padding: 44px 20px;
            color: #64748b;
        }

        /* CUSTOM DELETE CONFIRMATION MODAL */
        .delete-modal-overlay {
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(15, 23, 42, 0.7);
            backdrop-filter: blur(8px);
            z-index: 3000;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .delete-modal-box {
            background: #ffffff;
            border-radius: 20px;
            padding: 32px 28px;
            width: min(420px, calc(100vw - 32px));
            text-align: center;
            box-shadow: 0 25px 60px rgba(0, 0, 0, 0.25);
            border: 1.5px solid #e2e8f0;
        }

        .delete-icon-circle {
            width: 68px;
            height: 68px;
            background: #fef2f2;
            color: #dc2626;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            margin: 0 auto 18px auto;
            border: 1.5px solid #fca5a5;
            box-shadow: 0 6px 20px rgba(220, 38, 38, 0.15);
        }

        .delete-modal-title {
            font-size: 1.35rem;
            font-weight: 800;
            color: #0f172a;
            margin-bottom: 8px;
        }

        .delete-modal-desc {
            font-size: 14px;
            color: #64748b;
            line-height: 1.5;
            margin-bottom: 24px;
        }

        .delete-modal-actions {
            display: flex;
            gap: 12px;
            justify-content: center;
        }

        .btn-cancel-delete {
            flex: 1;
            background: #f1f5f9;
            color: #475569;
            font-weight: 700;
            padding: 12px 20px;
            border-radius: 10px;
            border: 1.5px solid #cbd5e1;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.2s;
        }

        .btn-cancel-delete:hover {
            background: #e2e8f0;
            color: #0f172a;
        }

        .btn-confirm-delete {
            flex: 1;
            background: linear-gradient(135deg, #dc2626, #b91c1c);
            color: #ffffff !important;
            font-weight: 700;
            padding: 12px 20px;
            border-radius: 10px;
            border: none;
            cursor: pointer;
            font-size: 14px;
            box-shadow: 0 4px 14px rgba(220, 38, 38, 0.3);
            transition: all 0.2s;
        }

        .btn-confirm-delete:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(220, 38, 38, 0.4);
        }

        /* RESPONSIVE MEDIA QUERIES FOR ALL DEVICES */
        @media (max-width: 768px) {
            .dashboard-header-card {
                flex-direction: column;
                align-items: stretch;
                padding: 20px;
            }

            .btn-header-add {
                width: 100%;
                justify-content: center;
            }

            .stats-grid-container {
                grid-template-columns: 1fr;
                gap: 14px;
            }

            .search-filter-box {
                flex-direction: column;
                align-items: stretch;
            }

            .search-input-wrapper {
                width: 100%;
            }

            .btn-search-action,
            .btn-clear-action {
                width: 100%;
                justify-content: center;
            }

            .content-card-main {
                padding: 16px;
            }

            .action-btn-group {
                flex-direction: column;
                width: 100%;
            }

            .btn-table-edit,
            .btn-table-delete {
                width: 100%;
                justify-content: center;
            }
        }

        @media (max-width: 480px) {
            .header-title-group h1 {
                font-size: 1.35rem;
            }

            .stat-card-modern {
                padding: 16px 18px;
            }

            .stat-num-val {
                font-size: 1.6rem;
            }

            .floating-panel,
            .delete-modal-box {
                width: calc(100vw - 20px);
                padding: 22px 18px;
            }

            .delete-modal-actions {
                flex-direction: column;
            }

            .btn-cancel-delete,
            .btn-confirm-delete {
                width: 100%;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

    <div class="manage-area-page">
        <asp:HiddenField ID="hdnDeleteAreaId" runat="server" />

        <!-- HEADER SECTION -->
        <div class="dashboard-header-card">
            <div class="header-title-group">
                <h1><i class="fas fa-map-location-dot" style="color:#2563eb;"></i> Service Area Management</h1>
                <p>Configure active delivery zones, pincode coverage, and service locations for your cloud kitchen.</p>
            </div>
            <asp:Button ID="btnAddNew" runat="server" Text="➕ Add New Area" CssClass="btn-header-add" OnClick="btnAddNew_Click" CausesValidation="false" />
        </div>

        <!-- STATS GRID -->
        <div class="stats-grid-container">
            <div class="stat-card-modern">
                <div class="stat-icon-wrapper icon-blue">
                    <i class="fas fa-city"></i>
                </div>
                <div class="stat-content">
                    <div class="stat-num-val">
                        <asp:Literal ID="litTotalAreas" runat="server">0</asp:Literal>
                    </div>
                    <div class="stat-title-lbl">Total Service Areas</div>
                </div>
            </div>

            <div class="stat-card-modern">
                <div class="stat-icon-wrapper icon-emerald">
                    <i class="fas fa-map-pin"></i>
                </div>
                <div class="stat-content">
                    <div class="stat-num-val">
                        <asp:Literal ID="litRecentAdditions" runat="server">0</asp:Literal>
                    </div>
                    <div class="stat-title-lbl">Active Delivery Pincodes</div>
                </div>
            </div>

            <div class="stat-card-modern">
                <div class="stat-icon-wrapper icon-amber">
                    <i class="fas fa-shield-halved"></i>
                </div>
                <div class="stat-content">
                    <div class="stat-num-val">100%</div>
                    <div class="stat-title-lbl">Operational Coverage</div>
                </div>
            </div>
        </div>

        <!-- NOTIFICATION MESSAGE BANNER -->
        <div id="messagePanel" class="message-alert success" style="display: none;">
            <asp:Literal ID="litMessage" runat="server"></asp:Literal>
        </div>

        <!-- MAIN CONTENT CARD -->
        <div class="content-card-main">
            
            <!-- TABLE TOP BAR -->
            <div class="table-top-bar">
                <div class="table-title">
                    <i class="fas fa-list-check" style="color:#2563eb;"></i> Active Service Coverage Zones
                </div>
            </div>

            <!-- SEARCH BAR -->
            <div class="search-filter-box">
                <div class="search-input-wrapper">
                    <i class="fas fa-magnifying-glass"></i>
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input-field" placeholder="Search by area name or 6-digit pincode..." />
                </div>
                <asp:Button ID="btnSearch" runat="server" Text="Search Area" CssClass="btn-search-action" OnClick="btnSearch_Click" CausesValidation="false" />
                <asp:Button ID="btnClearSearch" runat="server" Text="Reset" CssClass="btn-clear-action" OnClick="btnClearSearch_Click" CausesValidation="false" />
            </div>

            <!-- TABLE CONTAINER -->
            <div class="table-responsive-wrapper">
                <asp:Repeater ID="rptArea" runat="server" OnItemCommand="rptArea_ItemCommand">
                    <HeaderTemplate>
                        <table class="area-custom-table">
                            <thead>
                                <tr>
                                    <th>Area Name</th>
                                    <th>Pincode</th>
                                    <th>Zone Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td>
                                <div class="area-name-cell">
                                    <div class="area-name-icon"><i class="fas fa-location-dot"></i></div>
                                    <span><%# Eval("Area_Name") %></span>
                                </div>
                            </td>
                            <td>
                                <span class="pincode-badge">
                                    <i class="fas fa-hashtag"></i> <%# Eval("Pincode") %>
                                </span>
                            </td>
                            <td>
                                <span class="zone-status-pill">
                                    <i class="fas fa-bolt" style="color:#2563eb;"></i> Active Delivery Zone
                                </span>
                            </td>
                            <td>
                                <div class="action-btn-group">
                                    <asp:Button ID="btnEdit" runat="server" CssClass="btn-table-edit" CommandName="EditArea" CommandArgument='<%# Eval("Area_Id") %>' Text="✏️ Edit" CausesValidation="false" />
                                    <button type="button" class="btn-table-delete" onclick="openDeleteModal('<%# Eval("Area_Id") %>', '<%# Eval("Area_Name").ToString().Replace("'", "\'") %>');">
                                        <i class="fas fa-trash-can"></i> Delete
                                    </button>
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

            <asp:Panel ID="pnlNoData" runat="server" CssClass="no-data-card" Visible="false">
                <i class="fas fa-map-location-dot" style="font-size: 3rem; margin-bottom: 12px; color: #cbd5e1;"></i>
                <h3>No service areas found</h3>
                <p>Click "Add New Area" above to create your first coverage zone.</p>
            </asp:Panel>
        </div>

        <!-- MODAL OVERLAY & POPUP FORM -->
        <asp:Panel ID="Panel1" runat="server" Visible="false">
            <div id="overlay" class="overlay" runat="server"></div>
        </asp:Panel>

        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <asp:Panel ID="pnlEditArea" Visible="false" runat="server" CssClass="floating-panel">
                    <div class="modal-header-title">
                        <span>
                            <i class="fas fa-map-location-dot" style="color:#2563eb; margin-right:8px;"></i>
                            <asp:Literal ID="litPanelTitle" runat="server">Add New Service Area</asp:Literal>
                        </span>
                        <asp:LinkButton ID="btnCloseX" runat="server" OnClick="btnCancel_Click" CausesValidation="false" style="background:none; border:none; font-size:18px; color:#94a3b8; cursor:pointer;" aria-label="Close"><i class="fas fa-xmark"></i></asp:LinkButton>
                    </div>

                    <asp:HiddenField ID="hfAreaId" runat="server" />

                    <div class="form-group-custom">
                        <label for="txtArea">Area Name</label>
                        <asp:TextBox ID="txtArea" runat="server" CssClass="modal-input-field" placeholder="Enter area name (e.g. Anand, Vallabh Vidhyanagar)"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvFullName" runat="server" ControlToValidate="txtArea"
                            ErrorMessage="Area Name is required." Display="Dynamic" ForeColor="#dc2626" Font-Size="12px" />
                        <asp:RegularExpressionValidator ID="revFullName" runat="server" ControlToValidate="txtArea"
                            ErrorMessage="Only alphabets and spaces are allowed." ValidationExpression="^[A-Za-z ]+$"
                            Display="Dynamic" ForeColor="#dc2626" Font-Size="12px" />
                    </div>

                    <div class="form-group-custom">
                        <label for="txtPincode">Pincode</label>
                        <asp:TextBox ID="txtPincode" runat="server" CssClass="modal-input-field" placeholder="Enter 6-digit postal pincode (e.g. 388120)"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvPincode" runat="server" ControlToValidate="txtPincode"
                            ErrorMessage="Pincode is required" Display="Dynamic" ForeColor="#dc2626" Font-Size="12px"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="revPincode" runat="server" ControlToValidate="txtPincode"
                            ErrorMessage="Must be a valid 6-digit pincode" ValidationExpression="^\d{6}$"
                            Display="Dynamic" ForeColor="#dc2626" Font-Size="12px"></asp:RegularExpressionValidator>
                    </div>

                    <div style="margin-top: 8px;">
                        <asp:Label ID="lblmsg" runat="server" ForeColor="#dc2626" Font-Size="13px" Font-Bold="true"></asp:Label>
                    </div>

                    <div class="modal-actions-bar">
                        <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn-clear-action" OnClick="btnCancel_Click" CausesValidation="false" />
                        <asp:Button ID="btnSave" runat="server" Text="Save Area" CssClass="btn-search-action" OnClick="btnSave_Click" />
                        <asp:Button ID="btnUpdate" runat="server" Text="Update Area" CssClass="btn-search-action" OnClick="btnUpdate_Click" Visible="False" />
                    </div>
                </asp:Panel>
            </ContentTemplate>
        </asp:UpdatePanel>

        <!-- CUSTOM DELETE CONFIRMATION MODAL POPUP -->
        <div id="deleteModalOverlay" class="delete-modal-overlay" style="display:none;">
            <div class="delete-modal-box">
                <div class="delete-icon-circle">
                    <i class="fas fa-trash-can"></i>
                </div>
                <div class="delete-modal-title">Delete Service Area?</div>
                <div class="delete-modal-desc">
                    Are you sure you want to delete <strong id="deleteAreaNameText" style="color:#0f172a;">this area</strong>?<br />
                    This action will remove it from active delivery zones.
                </div>
                <div class="delete-modal-actions">
                    <button type="button" class="btn-cancel-delete" onclick="closeDeleteModal();">Cancel</button>
                    <asp:Button ID="btnConfirmDelete" runat="server" Text="Yes, Delete Area" CssClass="btn-confirm-delete" OnClick="btnConfirmDelete_Click" CausesValidation="false" />
                </div>
            </div>
        </div>

    </div>

    <script type="text/javascript">
        function hideAddEditPanel() {
            var panel = document.getElementById('<%= Panel1.ClientID %>');
            var overlay = document.getElementById('<%= overlay.ClientID %>');
            var editArea = document.getElementById('<%= pnlEditArea.ClientID %>');
            if (panel) panel.style.display = "none";
            if (overlay) overlay.style.display = "none";
            if (editArea) editArea.style.display = "none";
        }

        function showAddEditPanel() {
            var panel = document.getElementById('<%= Panel1.ClientID %>');
            var overlay = document.getElementById('<%= overlay.ClientID %>');
            if (panel) panel.style.display = "block";
            if (overlay) overlay.style.display = "block";
        }

        function openDeleteModal(areaId, areaName) {
            document.getElementById('<%= hdnDeleteAreaId.ClientID %>').value = areaId;
            document.getElementById('deleteAreaNameText').innerText = '"' + areaName + '"';
            document.getElementById('deleteModalOverlay').style.display = 'flex';
            return false;
        }

        function closeDeleteModal() {
            document.getElementById('deleteModalOverlay').style.display = 'none';
            return false;
        }
    </script>
</asp:Content>
