<%@ Page Title="Manage Categories & Cuisines" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Admin.Master" CodeBehind="ManageCC1.aspx.vb" Inherits="Cloud_Kitchen.WebForm9" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .cc-page-container {
            padding: 24px;
            background-color: #f8fafc;
            min-height: calc(100vh - 70px);
            font-family: 'Poppins', -apple-system, BlinkMacSystemFont, sans-serif;
            color: #1e293b;
        }

        .cc-header-card {
            background: #ffffff;
            border-radius: 14px;
            padding: clamp(16px, 2.5vw, 24px);
            margin-bottom: 24px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.03);
            border: 1px solid #e2e8f0;
            border-left: 6px solid #2563eb;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px 16px;
            width: 100%;
        }

        .cc-header-title {
            font-size: clamp(1.25rem, 3.5vw, 1.6rem);
            font-weight: 800;
            color: #0f172a;
            margin: 0;
            display: flex;
            align-items: flex-start;
            gap: 10px;
            line-height: 1.25;
            word-break: break-word;
            overflow-wrap: anywhere;
        }

        .cc-header-subtitle {
            font-size: clamp(0.82rem, 1.8vw, 0.9rem);
            color: #64748b;
            margin: 4px 0 0 0;
            word-break: break-word;
        }

        .cc-nav-tabs {
            display: flex;
            gap: 6px;
            margin-bottom: 20px;
            background: #e2e8f0;
            padding: 5px;
            border-radius: 12px;
            width: 100%;
            max-width: 600px;
            flex-wrap: wrap;
        }

        .tab-btn {
            flex: 1 1 140px;
            padding: 10px 16px;
            border-radius: 8px;
            font-weight: 700;
            font-size: clamp(0.8rem, 2vw, 0.9rem);
            border: none;
            cursor: pointer;
            background: transparent;
            color: #475569;
            transition: all 0.2s ease;
            text-align: center;
            white-space: normal;
            word-break: break-word;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }

        .tab-btn.active, .tab-btn:hover {
            background: #ffffff;
            color: #2563eb;
            box-shadow: 0 2px 6px rgba(0,0,0,0.06);
        }

        .cc-card {
            background: #ffffff;
            border-radius: 14px;
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.03);
            border: 1px solid #e2e8f0;
        }

        .form-section-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 18px;
            padding-bottom: 12px;
            border-bottom: 1px solid #f1f5f9;
        }

        .form-section-title {
            font-size: 1.1rem;
            font-weight: 800;
            color: #1e293b;
            margin: 0;
        }

        .form-grid-3 {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 18px;
            align-items: end;
        }

        .form-group-custom {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .form-label-custom {
            font-size: 0.85rem;
            font-weight: 700;
            color: #334155;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-control-custom {
            width: 100%;
            height: 44px;
            padding: 8px 14px;
            border: 1.5px solid #cbd5e1;
            border-radius: 8px;
            font-size: 0.95rem;
            background: #ffffff;
            color: #0f172a;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        .form-control-custom:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.15);
        }

        .btn-action {
            height: 44px;
            padding: 0 20px;
            font-weight: 700;
            font-size: 0.9rem;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: all 0.2s ease;
        }

        .btn-primary-custom {
            background: #2563eb;
            color: #ffffff;
        }

        .btn-primary-custom:hover {
            background: #1d4ed8;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.25);
        }

        .btn-secondary-custom {
            background: #f1f5f9;
            color: #475569;
            border: 1px solid #cbd5e1;
        }

        .btn-secondary-custom:hover {
            background: #e2e8f0;
            color: #1e293b;
        }

        .table-header-bar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 16px;
            gap: 12px;
            flex-wrap: wrap;
        }

        .table-title {
            font-size: 1.1rem;
            font-weight: 800;
            color: #0f172a;
            margin: 0;
        }

        .table-scroll-container {
            max-height: 460px;
            overflow-y: auto;
            border-radius: 10px;
            border: 1px solid #e2e8f0;
        }

        .cc-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.9rem;
        }

        .cc-table th {
            background: #f1f5f9;
            color: #334155;
            font-weight: 700;
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 0.5px;
            padding: 14px 16px;
            text-align: left;
            position: sticky;
            top: 0;
            z-index: 10;
            border-bottom: 2px solid #e2e8f0;
        }

        .cc-table td {
            padding: 14px 16px;
            border-bottom: 1px solid #f1f5f9;
            color: #334155;
            vertical-align: middle;
        }

        .cc-table tbody tr:nth-child(even) {
            background: #f8fafc;
        }

        .cc-table tbody tr:hover {
            background: #f1f5f9;
        }

        .action-link-edit {
            color: #2563eb;
            font-weight: 700;
            text-decoration: none;
            margin-right: 12px;
            padding: 6px 12px;
            background: #eff6ff;
            border-radius: 6px;
            display: inline-block;
        }

        .action-link-edit:hover {
            background: #dbeafe;
            color: #1d4ed8;
        }

        .action-link-delete {
            color: #dc2626;
            font-weight: 700;
            text-decoration: none;
            padding: 6px 12px;
            background: #fef2f2;
            border-radius: 6px;
            display: inline-block;
        }

        .action-link-delete:hover {
            background: #fee2e2;
            color: #b91c1c;
        }

        .empty-state-box {
            text-align: center;
            padding: 40px 20px;
            color: #64748b;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

    <asp:UpdatePanel ID="UpdatePanel4" runat="server">
        <ContentTemplate>
            <div class="cc-page-container">
                <!-- Light Theme Header Banner -->
                <div class="cc-header-card">
                    <div>
                        <h1 class="cc-header-title">🏷️ Food Catalog & Cuisine Management</h1>
                        <p class="cc-header-subtitle">Manage menu categories, regional cuisine types, and availability status.</p>
                    </div>
                </div>

                <!-- Navigation Tabs -->
                <div class="cc-nav-tabs">
                    <asp:Button ID="btnTabCategory" runat="server" Text="📁 Manage Food Categories" CssClass="tab-btn active" OnClick="btnTabCategory_Click" CausesValidation="false" />
                    <asp:Button ID="btnTabCuisine" runat="server" Text="🍲 Manage Cuisine Types" CssClass="tab-btn" OnClick="btnTabCuisine_Click" CausesValidation="false" />
                </div>

                <!-- TAB 1: MANAGE CATEGORIES -->
                <asp:Panel ID="up1" runat="server">
                    <!-- TOP SECTION: CATEGORY FORM -->
                    <div class="cc-card">
                        <div class="form-section-header">
                            <h3 class="form-section-title">
                                <asp:Literal ID="litCategoryFormTitle" runat="server" Text="➕ Add New Food Category"></asp:Literal>
                            </h3>
                        </div>
                        <asp:HiddenField ID="hfCategoryId" runat="server" />

                        <asp:Label ID="lblmsg" runat="server" EnableViewState="false" style="display: block; margin-bottom: 14px; font-weight: 700; border-radius: 8px; padding: 8px 14px;"></asp:Label>

                        <div class="form-grid-3">
                            <div class="form-group-custom">
                                <label class="form-label-custom">Category Name *</label>
                                <asp:TextBox ID="txtCategoryName" runat="server" CssClass="form-control-custom" Placeholder="e.g. Starter, Main Course, Desserts"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvCategoryName" runat="server" ControlToValidate="txtCategoryName" ErrorMessage="Category Name is required." ForeColor="#dc2626" Display="Dynamic" Font-Size="12px" Font-Bold="true" ValidationGroup="vgCategory" />
                                <asp:RegularExpressionValidator ID="revcatName" runat="server" ControlToValidate="txtCategoryName" ErrorMessage="Only letters and spaces allowed." ValidationGroup="vgCategory" ValidationExpression="^[A-Za-z ]+$" Display="Dynamic" ForeColor="#dc2626" Font-Size="12px" Font-Bold="true" />
                            </div>

                            <div class="form-group-custom">
                                <label class="form-label-custom">Category Status *</label>
                                <asp:DropDownList ID="ddlCategoryStatus" runat="server" CssClass="form-control-custom">
                                    <asp:ListItem Text="Active" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="Inactive" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                            </div>

                            <div class="form-group-custom">
                                <label class="form-label-custom">&nbsp;</label>
                                <div style="display: flex; gap: 10px;">
                                    <asp:Button ID="btnSave" runat="server" Text="💾 Save Category" CssClass="btn-action btn-primary-custom" OnClick="btnSave_Click" ValidationGroup="vgCategory" style="flex: 1;" />
                                    <asp:Button ID="btnUpdate" runat="server" Text="🔄 Update Category" CssClass="btn-action btn-primary-custom" OnClick="btnUpdate_Click" Visible="False" ValidationGroup="vgCategory" style="flex: 1;" />
                                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn-action btn-secondary-custom" OnClick="btnCancel_Click" CausesValidation="false" />
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- BOTTOM SECTION: CATEGORY TABLE IN SCROLLABLE CONTAINER -->
                    <div class="cc-card">
                        <div class="table-header-bar">
                            <h3 class="table-title">📁 Menu Categories Catalog</h3>
                            <div style="display: flex; align-items: center; gap: 12px;">
                                <asp:TextBox ID="txtSearchCat" runat="server" CssClass="form-control-custom" style="width: 260px; height: 42px; margin-bottom: 0;" Placeholder="🔍 Search category..." AutoPostBack="true" OnTextChanged="txtSearchCat_TextChanged" CausesValidation="false"></asp:TextBox>
                            </div>
                        </div>

                        <div class="table-scroll-container">
                            <asp:Repeater ID="rptcat" runat="server" OnItemCommand="rptcat_ItemCommand">
                                <HeaderTemplate>
                                    <table class="cc-table">
                                        <thead>
                                            <tr>
                                                <th>Category Name</th>
                                                <th>Status</th>
                                                <th style="text-align: center;">Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td><strong style="color: #0f172a;"><%# Eval("category_name") %></strong></td>
                                        <td><%# GetStatusBadge(Eval("category_status")) %></td>
                                        <td style="text-align: center;">
                                            <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditCategory" CommandArgument='<%# Eval("category_id") %>' Text="✏️ Edit" CssClass="action-link-edit" CausesValidation="false"></asp:LinkButton>
                                            <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteCategory" CommandArgument='<%# Eval("category_id") %>' Text="🗑️ Delete" OnClientClick="return confirm('Are you sure you want to delete this category?');" CssClass="action-link-delete" CausesValidation="false"></asp:LinkButton>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate>
                                        </tbody>
                                    </table>
                                </FooterTemplate>
                            </asp:Repeater>

                            <asp:Panel ID="pnlNoCat" runat="server" Visible="false" CssClass="empty-state-box">
                                <p>No menu categories found matching your search. Create your first category using the form above.</p>
                            </asp:Panel>
                        </div>
                    </div>
                </asp:Panel>

                <!-- TAB 2: MANAGE CUISINES -->
                <asp:Panel ID="up2" runat="server" Visible="false">
                    <!-- TOP SECTION: CUISINE FORM -->
                    <div class="cc-card">
                        <div class="form-section-header">
                            <h3 class="form-section-title">
                                <asp:Literal ID="litCuisineFormTitle" runat="server" Text="➕ Add New Cuisine Type"></asp:Literal>
                            </h3>
                        </div>
                        <asp:HiddenField ID="hfCuisineId" runat="server" />

                        <asp:Label ID="lblmsg2" runat="server" EnableViewState="false" style="display: block; margin-bottom: 14px; font-weight: 700; border-radius: 8px; padding: 8px 14px;"></asp:Label>

                        <div class="form-grid-3">
                            <div class="form-group-custom">
                                <label class="form-label-custom">Cuisine Name *</label>
                                <asp:TextBox ID="txtCuisineName" runat="server" CssClass="form-control-custom" Placeholder="e.g. North Indian, South Indian, Chinese"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvCuisineName" runat="server" ControlToValidate="txtCuisineName" ErrorMessage="Cuisine Name is required." ForeColor="#dc2626" Display="Dynamic" Font-Size="12px" Font-Bold="true" ValidationGroup="vgCuisine" />
                                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtCuisineName" ErrorMessage="Only letters and spaces allowed." ValidationGroup="vgCuisine" ValidationExpression="^[A-Za-z ]+$" Display="Dynamic" ForeColor="#dc2626" Font-Size="12px" Font-Bold="true" />
                            </div>

                            <div class="form-group-custom">
                                <label class="form-label-custom">Cuisine Status *</label>
                                <asp:DropDownList ID="ddlCuisineStatus" runat="server" CssClass="form-control-custom">
                                    <asp:ListItem Text="Active" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="Inactive" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                            </div>

                            <div class="form-group-custom">
                                <label class="form-label-custom">&nbsp;</label>
                                <div style="display: flex; gap: 10px;">
                                    <asp:Button ID="btnSave2" runat="server" Text="💾 Save Cuisine" CssClass="btn-action btn-primary-custom" OnClick="btnSave2_Click" ValidationGroup="vgCuisine" style="flex: 1;" />
                                    <asp:Button ID="btnUpdate2" runat="server" Text="🔄 Update Cuisine" CssClass="btn-action btn-primary-custom" OnClick="btnUpdate2_Click" ValidationGroup="vgCuisine" Visible="False" style="flex: 1;" />
                                    <asp:Button ID="btnCancel2" runat="server" Text="Cancel" CssClass="btn-action btn-secondary-custom" OnClick="btnCancel2_Click" CausesValidation="false" />
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- BOTTOM SECTION: CUISINE TABLE IN SCROLLABLE CONTAINER -->
                    <div class="cc-card">
                        <div class="table-header-bar">
                            <h3 class="table-title">🍲 Cuisine Types Catalog</h3>
                            <div style="display: flex; align-items: center; gap: 12px;">
                                <asp:TextBox ID="txtSearchCuisine" runat="server" CssClass="form-control-custom" style="width: 260px; height: 42px; margin-bottom: 0;" Placeholder="🔍 Search cuisine..." AutoPostBack="true" OnTextChanged="txtSearchCuisine_TextChanged" CausesValidation="false"></asp:TextBox>
                            </div>
                        </div>

                        <div class="table-scroll-container">
                            <asp:Repeater ID="rptcuisine" runat="server" OnItemCommand="rptcuisine_ItemCommand">
                                <HeaderTemplate>
                                    <table class="cc-table">
                                        <thead>
                                            <tr>
                                                <th>Cuisine Name</th>
                                                <th>Status</th>
                                                <th style="text-align: center;">Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td><strong style="color: #0f172a;"><%# Eval("cuisine_name") %></strong></td>
                                        <td><%# GetStatusBadge(Eval("cuisine_status")) %></td>
                                        <td style="text-align: center;">
                                            <asp:LinkButton ID="btnEdit2" runat="server" CommandName="EditCuisine" CommandArgument='<%# Eval("cuisine_id") %>' Text="✏️ Edit" CssClass="action-link-edit" CausesValidation="false"></asp:LinkButton>
                                            <asp:LinkButton ID="btnDelete2" runat="server" CommandName="DeleteCuisineName" CommandArgument='<%# Eval("cuisine_id") %>' Text="🗑️ Delete" OnClientClick="return confirm('Are you sure you want to delete this cuisine?');" CssClass="action-link-delete" CausesValidation="false"></asp:LinkButton>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate>
                                        </tbody>
                                    </table>
                                </FooterTemplate>
                            </asp:Repeater>

                            <asp:Panel ID="pnlNoCuisine" runat="server" Visible="false" CssClass="empty-state-box">
                                <p>No cuisine types found matching your search. Create your first cuisine type using the form above.</p>
                            </asp:Panel>
                        </div>
                    </div>
                </asp:Panel>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
