<%@ Page Title="Manage Inventory - Admin" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Admin.Master" CodeBehind="ManageInventory.aspx.vb" Inherits="Cloud_Kitchen.ManageInventory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .inv-page-container {
            width: min(100%, 1280px);
            margin: 0 auto;
            padding: clamp(12px, 2vw, 24px);
            font-family: 'Poppins', -apple-system, BlinkMacSystemFont, sans-serif;
        }

        /* LIGHT THEME HEADER CARD */
        .inv-header-card {
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

        .inv-header-title {
            font-size: clamp(1.2rem, 3.5vw, 1.85rem);
            font-weight: 800;
            color: #0f172a;
            margin: 0 0 6px 0;
            letter-spacing: -0.3px;
            line-height: 1.25;
            display: flex;
            align-items: flex-start;
            gap: 10px;
            word-break: break-word;
            overflow-wrap: anywhere;
        }

        .inv-title-icon {
            flex: 0 0 auto;
            display: inline-block;
            line-height: 1.2;
        }

        .inv-title-text {
            flex: 1 1 auto;
            min-width: 0;
        }

        .inv-header-subtitle {
            font-size: clamp(0.82rem, 1.8vw, 0.95rem);
            color: #64748b;
            margin: 0;
            line-height: 1.4;
            word-break: break-word;
        }

        /* NAVIGATION TABS */
        .inv-nav-tabs {
            display: flex;
            gap: 6px;
            margin-bottom: 22px;
            background: #f1f5f9;
            padding: 6px;
            border-radius: 12px;
            width: 100%;
            max-width: 600px;
            border: 1px solid #e2e8f0;
            flex-wrap: wrap;
        }

        .tab-btn {
            flex: 1 1 140px;
            padding: 10px 16px;
            font-weight: 700;
            font-size: clamp(0.8rem, 2vw, 0.9rem);
            border-radius: 8px;
            border: none;
            background: transparent;
            color: #64748b;
            cursor: pointer;
            transition: all 0.25s ease;
            text-align: center;
            white-space: normal;
            word-break: break-word;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }

        .tab-btn.active {
            background: #ffffff;
            color: #2563eb;
            box-shadow: 0 2px 8px rgba(37, 99, 235, 0.12);
        }

        .tab-btn:hover:not(.active) {
            color: #0f172a;
            background: rgba(255, 255, 255, 0.6);
        }

        /* CARDS & PANELS */
        .inv-card {
            background: #ffffff;
            border-radius: 14px;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.04);
            border: 1px solid #e2e8f0;
            padding: clamp(18px, 2.5vw, 28px);
            margin-bottom: 24px;
        }

        .form-section-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
            padding-bottom: 12px;
            border-bottom: 2px solid #f1f5f9;
        }

        .form-section-title {
            font-size: 1.1rem;
            font-weight: 700;
            color: #1e293b;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* USER FRIENDLY FORM GRID */
        .form-grid-3 {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 18px;
            margin-bottom: 16px;
        }

        .form-grid-actions {
            display: flex;
            gap: 10px;
            align-items: flex-end;
            justify-content: flex-end;
            margin-top: 10px;
            padding-top: 16px;
            border-top: 1px dashed #e2e8f0;
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
            margin: 0;
        }

        .form-control-custom {
            width: 100%;
            height: 44px;
            padding: 10px 14px;
            border: 1.5px solid #cbd5e1;
            border-radius: 9px;
            font-size: 14px;
            background-color: #ffffff;
            color: #0f172a;
            transition: all 0.2s ease;
        }

        .form-control-custom:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 3.5px rgba(37, 99, 235, 0.12);
        }

        select.form-control-custom {
            cursor: pointer;
            background-color: #ffffff;
        }

        /* ACTION BUTTONS */
        .btn-action {
            height: 44px;
            padding: 0 24px;
            border-radius: 9px;
            font-size: 14px;
            font-weight: 700;
            border: none;
            cursor: pointer;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            white-space: nowrap;
        }

        .btn-primary-custom {
            background-color: #2563eb;
            color: #ffffff;
            box-shadow: 0 3px 10px rgba(37, 99, 235, 0.2);
        }

        .btn-primary-custom:hover {
            background-color: #1d4ed8;
            transform: translateY(-1px);
            box-shadow: 0 5px 14px rgba(37, 99, 235, 0.3);
        }

        .btn-secondary-custom {
            background-color: #f1f5f9;
            color: #475569;
            border: 1px solid #cbd5e1;
        }

        .btn-secondary-custom:hover {
            background-color: #e2e8f0;
            color: #0f172a;
        }

        /* TABLE HEADER BAR */
        .table-header-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
            flex-wrap: wrap;
            gap: 12px;
        }

        .table-title {
            font-size: 1.15rem;
            font-weight: 800;
            color: #0f172a;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .table-header-controls {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }

        .table-filter-input {
            height: 42px !important;
            margin-bottom: 0 !important;
            box-sizing: border-box;
        }

        .filter-dropdown-custom {
            width: 200px;
        }

        .filter-search-custom {
            width: 240px;
        }

        @media (max-width: 576px) {
            .table-header-bar {
                flex-direction: column;
                align-items: stretch;
                gap: 12px;
            }

            .table-header-controls {
                width: 100%;
                flex-direction: column;
                align-items: stretch;
                gap: 10px;
            }

            .filter-dropdown-custom,
            .filter-search-custom {
                width: 100% !important;
                max-width: 100% !important;
            }
        }

        /* LIGHT SCROLLABLE TABLE CONTAINER */
        .table-scroll-container {
            max-height: 460px;
            overflow-y: auto;
            border-radius: 10px;
            border: 1px solid #cbd5e1;
            background: #ffffff;
        }

        .table-scroll-container::-webkit-scrollbar {
            width: 8px;
            height: 8px;
        }

        .table-scroll-container::-webkit-scrollbar-track {
            background: #f8fafc;
        }

        .table-scroll-container::-webkit-scrollbar-thumb {
            background: #cbd5e1;
            border-radius: 6px;
        }

        .table-scroll-container::-webkit-scrollbar-thumb:hover {
            background: #94a3b8;
        }

        .inv-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            text-align: left;
        }

        .inv-table th {
            position: sticky;
            top: 0;
            z-index: 10;
            background: #f1f5f9;
            color: #1e293b;
            font-weight: 700;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding: 13px 18px;
            border-bottom: 2px solid #cbd5e1;
        }

        .inv-table td {
            padding: 13px 18px;
            border-bottom: 1px solid #e2e8f0;
            color: #334155;
            font-size: 14px;
            vertical-align: middle;
            background: #ffffff;
            transition: background 0.15s ease;
        }

        .inv-table tr:nth-child(even) td {
            background: #f8fafc;
        }

        .inv-table tr:hover td {
            background: #eff6ff;
        }

        .badge-instock {
            background: #dcfce7;
            color: #15803d;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            border: 1px solid #bbf7d0;
        }

        .badge-lowstock {
            background: #fef3c7;
            color: #b45309;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            border: 1px solid #fde68a;
        }

        .badge-outstock {
            background: #fee2e2;
            color: #b91c1c;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            border: 1px solid #fecaca;
        }

        .action-link-edit {
            background: #eff6ff;
            color: #2563eb;
            padding: 5px 12px;
            border-radius: 7px;
            font-weight: 700;
            font-size: 13px;
            text-decoration: none;
            margin-right: 8px;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            border: 1px solid #bfdbfe;
        }

        .action-link-edit:hover {
            background: #2563eb;
            color: #ffffff;
            border-color: #2563eb;
        }

        .action-link-delete {
            background: #fef2f2;
            color: #dc2626;
            padding: 5px 12px;
            border-radius: 7px;
            font-weight: 700;
            font-size: 13px;
            text-decoration: none;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            border: 1px solid #fecaca;
        }

        .action-link-delete:hover {
            background: #dc2626;
            color: #ffffff;
            border-color: #dc2626;
        }

        .empty-state-box {
            text-align: center;
            padding: 40px 20px;
            color: #64748b;
            background: #f8fafc;
            border-radius: 8px;
            margin: 10px;
        }

        .empty-state-box p {
            margin: 0;
            font-size: 14px;
            font-weight: 600;
        }

        @media (max-width: 992px) {
            .form-grid-3 {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 640px) {
            .form-grid-3 {
                grid-template-columns: 1fr;
            }
            .form-grid-actions {
                flex-direction: column;
            }
            .btn-action {
                width: 100%;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

    <asp:UpdatePanel ID="updInventory" runat="server">
        <ContentTemplate>
            <div class="inv-page-container">
                <!-- Light Theme Header Banner -->
                <div class="inv-header-card">
                    <div>
                        <h1 class="inv-header-title">
                            <span class="inv-title-icon">📦</span>
                            <span class="inv-title-text">Inventory Management & Recipe Builder</span>
                        </h1>
                        <p class="inv-header-subtitle">Track raw ingredient stocks, manage unit costs, and map dish recipe ratios.</p>
                    </div>
                </div>

                <asp:Label ID="lblMsg" runat="server" EnableViewState="false" style="display: block; margin-bottom: 16px; font-weight: 700; border-radius: 10px; padding: 10px 16px;"></asp:Label>

                <!-- Navigation Tabs -->
                <div class="inv-nav-tabs">
                    <asp:Button ID="btnTabIngredients" runat="server" Text="🥦 Raw Ingredient Stock" CssClass="tab-btn active" OnClick="btnTabIngredients_Click" CausesValidation="false" />
                    <asp:Button ID="btnTabRecipe" runat="server" Text="📖 Recipe Builder Matrix" CssClass="tab-btn" OnClick="btnTabRecipe_Click" CausesValidation="false" />
                </div>

                <!-- TAB 1: RAW INGREDIENT STOCK -->
                <asp:Panel ID="pnlIngredients" runat="server">
                    <!-- INVENTORY QUICK STATS CARDS -->
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; margin-bottom: 20px;">
                        <div style="background: #ffffff; border-radius: 12px; padding: 16px 20px; border: 1px solid #e2e8f0; border-left: 4px solid #2563eb; box-shadow: 0 2px 8px rgba(0,0,0,0.03);">
                            <div style="font-size: 12px; font-weight: 700; color: #64748b; text-transform: uppercase; letter-spacing: 0.5px;">Total Raw Items</div>
                            <div style="font-size: 1.5rem; font-weight: 800; color: #0f172a; margin-top: 4px;"><asp:Label ID="lblTotalItems" runat="server" Text="0"></asp:Label> Items</div>
                        </div>
                        <div style="background: #ffffff; border-radius: 12px; padding: 16px 20px; border: 1px solid #e2e8f0; border-left: 4px solid #16a34a; box-shadow: 0 2px 8px rgba(0,0,0,0.03);">
                            <div style="font-size: 12px; font-weight: 700; color: #64748b; text-transform: uppercase; letter-spacing: 0.5px;">Healthy Stock</div>
                            <div style="font-size: 1.5rem; font-weight: 800; color: #16a34a; margin-top: 4px;"><asp:Label ID="lblHealthyItems" runat="server" Text="0"></asp:Label> Items</div>
                        </div>
                        <div style="background: #ffffff; border-radius: 12px; padding: 16px 20px; border: 1px solid #e2e8f0; border-left: 4px solid #d97706; box-shadow: 0 2px 8px rgba(0,0,0,0.03);">
                            <div style="font-size: 12px; font-weight: 700; color: #64748b; text-transform: uppercase; letter-spacing: 0.5px;">Low Stock Alerts</div>
                            <div style="font-size: 1.5rem; font-weight: 800; color: #d97706; margin-top: 4px;"><asp:Label ID="lblLowStockCount" runat="server" Text="0"></asp:Label> Items</div>
                        </div>
                        <div style="background: #ffffff; border-radius: 12px; padding: 16px 20px; border: 1px solid #e2e8f0; border-left: 4px solid #9333ea; box-shadow: 0 2px 8px rgba(0,0,0,0.03);">
                            <div style="font-size: 12px; font-weight: 700; color: #64748b; text-transform: uppercase; letter-spacing: 0.5px;">Est. Inventory Value</div>
                            <div style="font-size: 1.5rem; font-weight: 800; color: #9333ea; margin-top: 4px;"><asp:Label ID="lblTotalValuation" runat="server" Text="₹0.00"></asp:Label></div>
                        </div>
                    </div>

                    <!-- TOP SECTION: FORM WITH SEPARATE WELL-ORGANIZED CONTROLS -->
                    <div class="inv-card">
                        <div class="form-section-header">
                            <h3 class="form-section-title">
                                <asp:Literal ID="litFormTitle" runat="server" Text="➕ Add New Raw Ingredient"></asp:Literal>
                            </h3>
                        </div>
                        <asp:HiddenField ID="hfIngredientId" runat="server" />

                        <!-- Row 1: Ingredient Name, Stock Quantity, Unit Metric -->
                        <div class="form-grid-3">
                            <div class="form-group-custom">
                                <label class="form-label-custom">Ingredient Name *</label>
                                <asp:TextBox ID="txtIngredientName" runat="server" CssClass="form-control-custom" Placeholder="e.g. Paneer, Butter, Cheese, Rice"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvIngredientName" runat="server" ControlToValidate="txtIngredientName" ErrorMessage="Ingredient Name is required." ForeColor="#dc2626" Display="Dynamic" Font-Size="12px" Font-Bold="true" ValidationGroup="vgIngredient" />
                            </div>

                            <div class="form-group-custom">
                                <label class="form-label-custom">Stock Quantity *</label>
                                <asp:TextBox ID="txtStockQty" runat="server" CssClass="form-control-custom" Placeholder="e.g. 15.00"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvStockQty" runat="server" ControlToValidate="txtStockQty" ErrorMessage="Stock Quantity is required." ForeColor="#dc2626" Display="Dynamic" Font-Size="12px" Font-Bold="true" ValidationGroup="vgIngredient" />
                                <asp:CompareValidator ID="cvStockQty" runat="server" ControlToValidate="txtStockQty" Operator="GreaterThanEqual" ValueToCompare="0" Type="Double" ErrorMessage="Qty must be &ge; 0." ForeColor="#dc2626" Display="Dynamic" Font-Size="12px" Font-Bold="true" ValidationGroup="vgIngredient" />
                            </div>

                            <div class="form-group-custom">
                                <label class="form-label-custom">Unit Metric *</label>
                                <asp:DropDownList ID="ddlUnit" runat="server" CssClass="form-control-custom">
                                    <asp:ListItem Value="kg">kg (Kilograms)</asp:ListItem>
                                    <asp:ListItem Value="grams">grams</asp:ListItem>
                                    <asp:ListItem Value="L">L (Liters)</asp:ListItem>
                                    <asp:ListItem Value="ml">ml (Milliliters)</asp:ListItem>
                                    <asp:ListItem Value="pcs">pcs (Pieces)</asp:ListItem>
                                    <asp:ListItem Value="packets">packets</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>

                        <!-- Row 2: Cost Per Unit, Low Stock Threshold, Form Actions -->
                        <div class="form-grid-3">
                            <div class="form-group-custom">
                                <label class="form-label-custom">Cost per Unit (₹) *</label>
                                <asp:TextBox ID="txtCostPerUnit" runat="server" CssClass="form-control-custom" Placeholder="e.g. 320.00"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvCostPerUnit" runat="server" ControlToValidate="txtCostPerUnit" ErrorMessage="Cost per Unit is required." ForeColor="#dc2626" Display="Dynamic" Font-Size="12px" Font-Bold="true" ValidationGroup="vgIngredient" />
                                <asp:CompareValidator ID="cvCostPerUnit" runat="server" ControlToValidate="txtCostPerUnit" Operator="GreaterThanEqual" ValueToCompare="0" Type="Double" ErrorMessage="Cost must be &ge; 0." ForeColor="#dc2626" Display="Dynamic" Font-Size="12px" Font-Bold="true" ValidationGroup="vgIngredient" />
                            </div>

                            <div class="form-group-custom">
                                <label class="form-label-custom">Low Stock Threshold Alert *</label>
                                <asp:TextBox ID="txtLowStockThreshold" runat="server" CssClass="form-control-custom" Placeholder="e.g. 3.00"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvThreshold" runat="server" ControlToValidate="txtLowStockThreshold" ErrorMessage="Low Stock Threshold is required." ForeColor="#dc2626" Display="Dynamic" Font-Size="12px" Font-Bold="true" ValidationGroup="vgIngredient" />
                                <asp:CompareValidator ID="cvThreshold" runat="server" ControlToValidate="txtLowStockThreshold" Operator="GreaterThanEqual" ValueToCompare="0" Type="Double" ErrorMessage="Threshold must be &ge; 0." ForeColor="#dc2626" Display="Dynamic" Font-Size="12px" Font-Bold="true" ValidationGroup="vgIngredient" />
                            </div>

                            <div class="form-group-custom">
                                <label class="form-label-custom">&nbsp;</label>
                                <div style="display: flex; gap: 10px;">
                                    <asp:Button ID="btnSaveIngredient" runat="server" Text="💾 Save Ingredient" CssClass="btn-action btn-primary-custom" OnClick="btnSaveIngredient_Click" ValidationGroup="vgIngredient" style="flex: 1;" />
                                    <asp:Button ID="btnCancelIngredient" runat="server" Text="Cancel" CssClass="btn-action btn-secondary-custom" OnClick="btnCancelIngredient_Click" CausesValidation="false" />
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- BOTTOM SECTION: DATA TABLE IN SCROLLABLE CONTAINER -->
                    <div class="inv-card">
                        <div class="table-header-bar">
                            <h3 class="table-title">📊 Current Stock Inventory</h3>
                            <div class="table-header-controls">
                                <asp:DropDownList ID="ddlStockFilter" runat="server" CssClass="form-control-custom table-filter-input filter-dropdown-custom" AutoPostBack="true" OnSelectedIndexChanged="ddlStockFilter_SelectedIndexChanged" CausesValidation="false">
                                    <asp:ListItem Value="All">All Stock Statuses</asp:ListItem>
                                    <asp:ListItem Value="InStock">🟢 In Stock</asp:ListItem>
                                    <asp:ListItem Value="LowStock">🟡 Low Stock Alerts</asp:ListItem>
                                    <asp:ListItem Value="OutOfStock">🔴 Out of Stock</asp:ListItem>
                                </asp:DropDownList>
                                <asp:TextBox ID="txtSearchIngredient" runat="server" CssClass="form-control-custom table-filter-input filter-search-custom" Placeholder="🔍 Search ingredient..." AutoPostBack="true" OnTextChanged="txtSearchIngredient_TextChanged" CausesValidation="false"></asp:TextBox>
                            </div>
                        </div>

                        <div class="table-scroll-container">
                            <asp:Repeater ID="rptIngredients" runat="server" OnItemCommand="rptIngredients_ItemCommand">
                                <HeaderTemplate>
                                    <table class="inv-table">
                                        <thead>
                                            <tr>
                                                <th>Ingredient Name</th>
                                                <th>Stock Level</th>
                                                <th>Unit Cost</th>
                                                <th>Stock Status</th>
                                                <th style="text-align: center;">Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td>
                                            <strong style="color: #0f172a;"><%# Eval("ingredient_name") %></strong>
                                        </td>
                                        <td>
                                            <span style="font-weight: 700; color: #1e293b;"><%# Eval("stock_quantity", "{0:N2}") %></span> <%# Eval("unit") %>
                                        </td>
                                        <td>
                                            <strong>₹<%# Eval("cost_per_unit", "{0:N2}") %></strong> / <%# Eval("unit") %>
                                        </td>
                                        <td>
                                            <%# GetStockBadge(Eval("stock_quantity"), Eval("low_stock_threshold")) %>
                                        </td>
                                        <td style="text-align: center;">
                                            <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditIngredient" CommandArgument='<%# Eval("ingredient_id") %>' Text="✏️ Edit" CssClass="action-link-edit" CausesValidation="false"></asp:LinkButton>
                                            <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteIngredient" CommandArgument='<%# Eval("ingredient_id") %>' Text="🗑️ Delete" OnClientClick="return confirm('Are you sure you want to delete this ingredient?');" CssClass="action-link-delete" CausesValidation="false"></asp:LinkButton>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate>
                                        </tbody>
                                    </table>
                                </FooterTemplate>
                            </asp:Repeater>

                            <asp:Panel ID="pnlNoIngredients" runat="server" Visible="false" CssClass="empty-state-box">
                                <p>No raw ingredients found matching your search. Add your first raw ingredient using the form above.</p>
                            </asp:Panel>
                        </div>
                    </div>
                </asp:Panel>

                <!-- TAB 2: RECIPE BUILDER MATRIX -->
                <asp:Panel ID="pnlRecipe" runat="server" Visible="false">
                    <!-- RECIPE FINANCIALS BAR -->
                    <asp:Panel ID="pnlRecipeFinancials" runat="server" Visible="false" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; margin-bottom: 20px;">
                        <div style="background: #ffffff; border-radius: 12px; padding: 14px 18px; border: 1px solid #e2e8f0; border-left: 4px solid #2563eb;">
                            <div style="font-size: 11px; font-weight: 700; color: #64748b; text-transform: uppercase;">Dish Selling Price</div>
                            <div style="font-size: 1.3rem; font-weight: 800; color: #0f172a; margin-top: 2px;"><asp:Label ID="lblDishSellingPrice" runat="server" Text="₹0.00"></asp:Label></div>
                        </div>
                        <div style="background: #ffffff; border-radius: 12px; padding: 14px 18px; border: 1px solid #e2e8f0; border-left: 4px solid #d97706;">
                            <div style="font-size: 11px; font-weight: 700; color: #64748b; text-transform: uppercase;">Est. Raw Ingredient Cost</div>
                            <div style="font-size: 1.3rem; font-weight: 800; color: #d97706; margin-top: 2px;"><asp:Label ID="lblEstRecipeCost" runat="server" Text="₹0.00"></asp:Label></div>
                        </div>
                        <div style="background: #ffffff; border-radius: 12px; padding: 14px 18px; border: 1px solid #e2e8f0; border-left: 4px solid #16a34a;">
                            <div style="font-size: 11px; font-weight: 700; color: #64748b; text-transform: uppercase;">Est. Gross Profit Margin</div>
                            <div style="font-size: 1.3rem; font-weight: 800; color: #16a34a; margin-top: 2px;"><asp:Label ID="lblEstGrossMargin" runat="server" Text="₹0.00 (0%)"></asp:Label></div>
                        </div>
                    </asp:Panel>

                    <!-- TOP SECTION: RECIPE MAPPING FORM -->
                    <div class="inv-card">
                        <div class="form-section-header">
                            <h3 class="form-section-title">📖 Map Dish to Raw Ingredients (Recipe Matrix)</h3>
                        </div>

                        <div class="form-grid-3">
                            <div class="form-group-custom">
                                <label class="form-label-custom">Select Dish from Menu Catalog *</label>
                                <asp:DropDownList ID="ddlRecipeDish" runat="server" CssClass="form-control-custom" AutoPostBack="true" OnSelectedIndexChanged="ddlRecipeDish_SelectedIndexChanged" CausesValidation="false"></asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvRecipeDish" runat="server" ControlToValidate="ddlRecipeDish" InitialValue="0" ErrorMessage="Please select a dish." ForeColor="#dc2626" Display="Dynamic" Font-Size="12px" Font-Bold="true" ValidationGroup="vgRecipe" />
                            </div>

                            <div class="form-group-custom">
                                <label class="form-label-custom">Select Required Raw Ingredient *</label>
                                <asp:DropDownList ID="ddlRecipeIngredient" runat="server" CssClass="form-control-custom"></asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvRecipeIngredient" runat="server" ControlToValidate="ddlRecipeIngredient" InitialValue="0" ErrorMessage="Please select an ingredient." ForeColor="#dc2626" Display="Dynamic" Font-Size="12px" Font-Bold="true" ValidationGroup="vgRecipe" />
                            </div>

                            <div class="form-group-custom">
                                <label class="form-label-custom">Qty Required per Portion *</label>
                                <asp:TextBox ID="txtRecipeQty" runat="server" CssClass="form-control-custom" Placeholder="e.g. 0.25"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvRecipeQty" runat="server" ControlToValidate="txtRecipeQty" ErrorMessage="Quantity is required." ForeColor="#dc2626" Display="Dynamic" Font-Size="12px" Font-Bold="true" ValidationGroup="vgRecipe" />
                                <asp:CompareValidator ID="cvRecipeQty" runat="server" ControlToValidate="txtRecipeQty" Operator="GreaterThan" ValueToCompare="0" Type="Double" ErrorMessage="Qty must be > 0." ForeColor="#dc2626" Display="Dynamic" Font-Size="12px" Font-Bold="true" ValidationGroup="vgRecipe" />
                            </div>
                        </div>

                        <div class="form-grid-actions">
                            <asp:Button ID="btnAddRecipeItem" runat="server" Text="➕ Link Ingredient to Recipe" CssClass="btn-action btn-primary-custom" OnClick="btnAddRecipeItem_Click" ValidationGroup="vgRecipe" />
                        </div>
                    </div>

                    <!-- BOTTOM SECTION: RECIPE DATA TABLE IN SCROLLABLE CONTAINER -->
                    <div class="inv-card">
                        <div class="table-header-bar">
                            <h3 class="table-title">
                                🥘 Recipe Matrix for: <asp:Label ID="lblSelectedDishName" runat="server" style="color: #2563eb; font-weight: 800;" Text="Select a dish above"></asp:Label>
                            </h3>
                        </div>

                        <div class="table-scroll-container">
                            <asp:Repeater ID="rptRecipeItems" runat="server" OnItemCommand="rptRecipeItems_ItemCommand">
                                <HeaderTemplate>
                                    <table class="inv-table">
                                        <thead>
                                            <tr>
                                                <th>Ingredient Name</th>
                                                <th>Required per Portion</th>
                                                <th>Unit Rate</th>
                                                <th>Est. Cost Contribution</th>
                                                <th style="text-align: center;">Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td><strong style="color: #0f172a;"><%# Eval("ingredient_name") %></strong></td>
                                        <td><span style="font-weight: 700; color: #1e293b;"><%# Eval("qty_required") %></span> <%# Eval("unit") %></td>
                                        <td>₹<%# Eval("cost_per_unit", "{0:N2}") %> / <%# Eval("unit") %></td>
                                        <td><strong style="color: #16a34a;">₹<%# (Convert.ToDecimal(Eval("qty_required")) * Convert.ToDecimal(Eval("cost_per_unit"))).ToString("N2") %></strong></td>
                                        <td style="text-align: center;">
                                            <asp:LinkButton ID="btnEditRecipe" runat="server" CommandName="EditRecipe" CommandArgument='<%# Eval("recipe_id") %>' Text="✏️ Edit Qty" CssClass="action-link-edit" CausesValidation="false"></asp:LinkButton>
                                            <asp:LinkButton ID="btnRemoveRecipe" runat="server" CommandName="RemoveRecipe" CommandArgument='<%# Eval("recipe_id") %>' Text="❌ Remove" OnClientClick="return confirm('Remove ingredient from recipe?');" CssClass="action-link-delete" CausesValidation="false"></asp:LinkButton>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate>
                                        </tbody>
                                    </table>
                                </FooterTemplate>
                            </asp:Repeater>

                            <asp:Panel ID="pnlNoRecipeItems" runat="server" Visible="false" CssClass="empty-state-box">
                                <p>No ingredients mapped to this dish recipe yet. Select a dish and raw ingredient above to build the recipe matrix.</p>
                            </asp:Panel>
                        </div>
                    </div>
                </asp:Panel>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

