<%@ Page Title="ADD ITEMS" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Admin.Master"
    CodeBehind="AddFoodItems.aspx.vb" Inherits="Cloud_Kitchen.AddFoodItems" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        :root {
            --primary-color: #3a86ff;
            --primary-dark: #2667cc;
            --secondary-color: #2b2d42;
            --danger-color: #d90429;
            --light-grey: #f8f9fa;
            --medium-grey: #e9ecef;
            --dark-grey: #6c757d;
            --shadow-sm: 0 2px 8px rgba(0, 0, 0, 0.08);
            --shadow-md: 0 4px 12px rgba(0, 0, 0, 0.12);
            --shadow-lg: 0 8px 24px rgba(0, 0, 0, 0.15);
            --radius-sm: 6px;
            --radius-md: 10px;
            --radius-lg: 16px;
            --transition-fast: 0.2s ease;
            --transition-med: 0.3s ease;
            --font-main: 'Segoe UI', system-ui, -apple-system, sans-serif;
        }

        body {
            font-family: var(--font-main);
            background-color: #f5f7fa;
            color: #333;
        }

        .add-items-page {
            width: min(100%, 1240px);
            margin: 0 auto;
        }

        .update-panel3 {
            width: 100%;
            background: #ffffff;
            border: none;
            border-radius: var(--radius-lg);
            padding: clamp(18px, 3vw, 36px);
            box-shadow: var(--shadow-lg);
            animation: fadeIn 0.8s ease-out, slideUp 0.5s ease-out;
            overflow: hidden;
        }

        .update-panel3 h3 {
            text-align: center;
            font-size: clamp(1.7rem, 4vw, 2.2rem);
            margin-bottom: clamp(22px, 4vw, 30px);
            color: var(--primary-color);
            font-weight: 700;
            letter-spacing: 0.03em;
            position: relative;
            padding-bottom: 15px;
            overflow-wrap: anywhere;
        }

        .update-panel3 h3::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-color), var(--primary-dark));
            border-radius: 2px;
        }

        .update-panel3 h2 {
            font-size: clamp(1.45rem, 3vw, 1.8rem);
            margin: 28px 0 20px;
            color: var(--secondary-color);
            font-weight: 600;
            text-align: center;
        }

        .section-divider {
            border: 0;
            border-top: 2px solid royalblue;
            opacity: 1;
            margin: clamp(20px, 3vw, 28px) 0;
        }

        .form-container {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: clamp(16px, 2vw, 26px);
            margin-bottom: 26px;
        }

        .form-column {
            min-width: 0;
            background: var(--light-grey);
            padding: clamp(16px, 2vw, 20px);
            border-radius: var(--radius-md);
            box-shadow: var(--shadow-sm);
            transition: transform var(--transition-med), box-shadow var(--transition-med);
        }

        .form-column:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-md);
        }

        .form-group {
            margin-bottom: 20px;
            position: relative;
        }

        .form-group label {
            display: block;
            font-weight: 600;
            margin-bottom: 8px;
            color: var(--secondary-color);
            font-size: 15px;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100% !important;
            max-width: 100%;
            padding: 12px 15px;
            font-size: 15px;
            border: 1px solid #ddd;
            border-radius: var(--radius-sm);
            transition: border-color var(--transition-fast), box-shadow var(--transition-fast);
            background-color: #fff;
            color: #333;
        }

        .form-group input[type="file"] {
            padding: 10px;
            line-height: 1.4;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(58, 134, 255, 0.2);
            outline: none;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 86px;
        }

        .form-actions {
            display: flex;
            justify-content: center;
            align-items: stretch;
            gap: 14px;
            margin-top: 24px;
            flex-wrap: wrap;
        }

        .btn,
        .card-btn {
            min-height: 44px;
            padding: 12px 24px;
            font-size: 15px;
            font-weight: 700;
            border: none;
            border-radius: var(--radius-md);
            cursor: pointer;
            transition: transform var(--transition-med), box-shadow var(--transition-med);
            text-transform: uppercase;
            letter-spacing: 0.4px;
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
            box-shadow: 0 4px 6px rgba(58, 134, 255, 0.25);
            text-decoration: none;
            white-space: nowrap;
        }

        .btn:hover,
        .card-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 15px rgba(58, 134, 255, 0.3);
        }

        .btn:active,
        .card-btn:active {
            transform: translateY(1px);
        }

        .btn-cancel,
        .card-btn-danger {
            background: linear-gradient(135deg, var(--danger-color), #b00020);
            box-shadow: 0 4px 6px rgba(217, 4, 41, 0.25);
        }

        .btn-cancel:hover,
        .card-btn-danger:hover {
            box-shadow: 0 8px 15px rgba(217, 4, 41, 0.3);
        }

        .search-filter-container {
            display: grid;
            grid-template-columns: auto minmax(180px, 1fr) auto minmax(180px, 1fr);
            align-items: center;
            gap: 14px 16px;
            margin: 26px 0;
            background: var(--light-grey);
            padding: clamp(16px, 2vw, 20px);
            border-radius: var(--radius-md);
            box-shadow: var(--shadow-sm);
        }

        .search-filter-container label {
            font-weight: 700;
            color: var(--secondary-color);
            margin: 0;
            white-space: nowrap;
        }

        .filter-box {
            width: 100% !important;
            min-height: 46px;
            padding: 12px 15px;
            border: 2px solid transparent;
            border-radius: var(--radius-md);
            font-size: 15px;
            transition: border-color var(--transition-med), box-shadow var(--transition-med);
            background: white;
            color: var(--secondary-color);
            box-shadow: var(--shadow-sm);
        }

        .filter-box::placeholder {
            color: var(--dark-grey);
            opacity: 0.75;
        }

        .filter-box:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(58, 134, 255, 0.2);
            outline: none;
        }

        .menu-items-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(min(100%, 270px), 1fr));
            gap: clamp(18px, 2.5vw, 28px);
            margin: 26px 0 0;
        }

        .menu-card {
            background: white;
            padding: 0;
            border: none;
            border-radius: var(--radius-lg);
            overflow: hidden;
            box-shadow: var(--shadow-md);
            transition: transform var(--transition-med), box-shadow var(--transition-med);
            display: flex;
            flex-direction: column;
            min-width: 0;
        }

        .menu-card:hover {
            transform: translateY(-6px);
            box-shadow: var(--shadow-lg);
        }

        .menu-card img {
            width: 100%;
            aspect-ratio: 16 / 10;
            height: auto;
            object-fit: cover;
            border-radius: 0;
            margin: 0;
            display: block;
            background: var(--medium-grey);
        }

        .menu-card-content {
            padding: 20px;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }

        .menu-card h4 {
            font-size: 20px;
            font-weight: 700;
            color: var(--secondary-color);
            margin: 0 0 15px 0;
            position: relative;
            padding-bottom: 10px;
            overflow-wrap: anywhere;
        }

        .menu-card h4::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 40px;
            height: 3px;
            background: var(--primary-color);
            border-radius: 1.5px;
        }

        .menu-card p {
            margin: 8px 0;
            color: var(--dark-grey);
            font-size: 15px;
            display: flex;
            justify-content: space-between;
            gap: 12px;
            line-height: 1.4;
        }

        .menu-card p strong {
            color: var(--secondary-color);
            flex: 0 0 auto;
        }

        .menu-card p span {
            min-width: 0;
            text-align: right;
            overflow-wrap: anywhere;
        }

        .card-actions {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 12px;
            margin-top: auto;
            padding: 18px;
            background: var(--light-grey);
        }

        .card-actions .card-btn {
            width: 100%;
            padding: 11px 10px;
            text-align: center;
            font-size: 14px;
        }

        .lblmsg {
            text-align: center;
            padding: 12px;
            margin: 16px 0 0;
            font-weight: 600;
            border-radius: var(--radius-md);
            color: var(--danger-color);
            overflow-wrap: anywhere;
        }

        .validation-error {
            color: var(--danger-color);
            font-size: 14px;
            margin-top: 5px;
            display: block;
            overflow-wrap: anywhere;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(14px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @media (max-width: 1180px) {
            .form-container {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .form-column:last-child {
                grid-column: 1 / -1;
            }
        }

        @media (max-width: 820px) {
            .form-container,
            .search-filter-container {
                grid-template-columns: 1fr;
            }

            .search-filter-container label {
                white-space: normal;
            }
        }

        @media (max-width: 576px) {
            .update-panel3 {
                border-radius: 12px;
                box-shadow: var(--shadow-md);
            }

            .form-column:hover,
            .menu-card:hover,
            .btn:hover,
            .card-btn:hover {
                transform: none;
            }

            .form-actions,
            .card-actions {
                grid-template-columns: 1fr;
                flex-direction: column;
            }

            .btn,
            .card-btn {
                width: 100%;
                white-space: normal;
            }

            .menu-card p {
                align-items: flex-start;
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

    <div class="add-items-page">
        <asp:Panel ID="up3" runat="server" CssClass="update-panel3">
            <h3>Manage Menu Item</h3>
            <asp:HiddenField ID="hfMenuItemId3" runat="server" />

            <div class="form-container">
                <div class="form-column">
                    <div class="form-group">
                        <label>Item Name</label>
                        <asp:TextBox ID="txtItemName3" runat="server" placeholder="Enter Item Name"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvItemName" runat="server" ControlToValidate="txtItemName3"
                            ErrorMessage="Item Name is required." CssClass="validation-error" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="revFullName" CssClass="validation-error" runat="server" ControlToValidate="txtItemName3"
                            ErrorMessage="Only alphabets and spaces are allowed." ValidationExpression="^[A-Za-z ]+$"
                            Display="Dynamic" ForeColor="Red" />
                    </div>

                    <div class="form-group">
                        <label>Category</label>
                        <asp:DropDownList ID="ddlCategory3" runat="server" Width="100%">
                            <asp:ListItem Text="- Select -" Value=""></asp:ListItem>
                            <asp:ListItem Text="Starter" Value="Starter"></asp:ListItem>
                            <asp:ListItem Text="Main Course" Value="Main Course"></asp:ListItem>
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvCategory" CssClass="validation-error" runat="server" ControlToValidate="ddlCategory3"
                            InitialValue="" ForeColor="Red" ErrorMessage="Please select a category." Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group">
                        <label>Cuisine</label>
                        <asp:DropDownList ID="ddlCuisine3" runat="server" Width="100%">
                            <asp:ListItem Text="- Select -" Value=""></asp:ListItem>
                            <asp:ListItem Text="Indian" Value="Indian"></asp:ListItem>
                            <asp:ListItem Text="Italian" Value="Italian"></asp:ListItem>
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvCuisine" runat="server" ControlToValidate="ddlCuisine3"
                            InitialValue="" ForeColor="Red" CssClass="validation-error" ErrorMessage="Please select a cuisine." Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group">
                        <label>Image</label>
                        <asp:FileUpload ID="fuImage3" runat="server" />
                        <asp:HiddenField ID="fn" runat="server" />
                    </div>
                </div>

                <div class="form-column">
                    <div class="form-group">
                        <label>Price</label>
                        <asp:TextBox ID="txtPrice3" runat="server" TextMode="Number" OnTextChanged="txtPrice3_TextChanged"
                            AutoPostBack="true"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvPrice" CssClass="validation-error" runat="server" ControlToValidate="txtPrice3"
                            ErrorMessage="Price is required." Display="Dynamic"></asp:RequiredFieldValidator>
                        <asp:RangeValidator ID="rvPrice" CssClass="validation-error" runat="server" ControlToValidate="txtPrice3" MinimumValue="1"
                            MaximumValue="10000" Type="Double" ErrorMessage="Price must be between 1 and 10000."
                            Display="Dynamic" ForeColor="Red"></asp:RangeValidator>
                    </div>

                    <div class="form-group">
                        <label>Discount (%)</label>
                        <asp:TextBox ID="txtDiscount3" runat="server" TextMode="Number" OnTextChanged="txtDiscount3_TextChanged"
                            AutoPostBack="true"></asp:TextBox>
                        <asp:RangeValidator ID="rvDiscount" runat="server" CssClass="validation-error" ControlToValidate="txtDiscount3"
                            MinimumValue="0" MaximumValue="100" Type="Double" ErrorMessage="Discount must be between 0% and 100%."
                            Display="Dynamic" ForeColor="Red"></asp:RangeValidator>
                    </div>

                    <div class="form-group">
                        <label>Final Price</label>
                        <asp:TextBox ID="txtFinalPrice3" runat="server" TextMode="Number" Enabled="False"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label>Description</label>
                        <asp:TextBox ID="txtDescription3" runat="server" TextMode="MultiLine" Rows="2" Style="resize: none;"></asp:TextBox>
                    </div>
                </div>

                <div class="form-column">
                    <div class="form-group">
                        <label>Availability</label>
                        <asp:DropDownList ID="ddlAvailability3" runat="server" Width="100%">
                            <asp:ListItem Text="Available" Value="1"></asp:ListItem>
                            <asp:ListItem Text="Unavailable" Value="0"></asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="form-group">
                        <label>Featured</label>
                        <asp:DropDownList ID="ddlFeatured3" runat="server" Width="100%">
                            <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                            <asp:ListItem Text="No" Value="0" Selected="True"></asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="form-group">
                        <label>Status</label>
                        <asp:DropDownList ID="ddlStatus3" runat="server" Width="100%">
                            <asp:ListItem Text="Active" Value="1"></asp:ListItem>
                            <asp:ListItem Text="Inactive" Value="0"></asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="form-actions">
                        <asp:Button ID="btnSave3" runat="server" Text="Save" CssClass="btn" OnClick="btnSave3_Click" />
                        <asp:Button ID="btnUpdate3" runat="server" Text="Update" CssClass="btn" OnClick="btnUpdate3_Click"
                            Visible="False" />
                        <asp:Button ID="btnCancel3" runat="server" Text="Cancel" CssClass="card-btn card-btn-danger" OnClick="btnCancel3_Click"
                            CausesValidation="false" />
                    </div>
                </div>
            </div>

            <div class="form-group lblmsg">
                <asp:Label ID="lblmsg3" runat="server" ForeColor="Red"></asp:Label>
            </div>

            <hr class="section-divider" />

            <div class="search-filter-container">
                <label for="txtSearch">Search Menu Item</label>
                <asp:TextBox ID="txtSearch" runat="server" CssClass="filter-box" AutoPostBack="True"
                    OnTextChanged="txtSearch_TextChanged" placeholder="Search by Name..."></asp:TextBox>

                <label for="ddlFilterCategory">Filter by Category</label>
                <asp:DropDownList ID="ddlFilterCategory" runat="server" CssClass="filter-box"
                    AutoPostBack="True" OnSelectedIndexChanged="ddlFilterCategory_SelectedIndexChanged">
                    <asp:ListItem Text="- Select -" Value="" Selected="True"></asp:ListItem>
                </asp:DropDownList>
            </div>

            <hr class="section-divider" />

            <h2>Menu Items List</h2>
            <div class="menu-items-container">
                <asp:Repeater ID="rptMenuItems3" runat="server" OnItemCommand="rptMenuItems3_ItemCommand">
                    <ItemTemplate>
                        <div class="menu-card">
                            <img src='<%# Eval("m_image_url") %>' alt="Menu Image" />
                            <div class="menu-card-content">
                                <h4><%# Eval("m_name") %></h4>
                                <p><strong>Price:</strong> <span>₹<%# Eval("m_price") %></span></p>
                                <%--<p><strong>Category:</strong> <span><%# Eval("m_category_id")%></span></p>--%>
                                <p><strong>Availability:</strong> <span><%# Eval("m_availability")%></span></p>
                                <p><strong>Featured:</strong> <span><%# Eval("m_featured")%></span></p>
                                <p><strong>Status:</strong> <span><%# Eval("m_status") %></span></p>
                            </div>
                            <div class="card-actions">
                                <asp:Button ID="btnEdit3" runat="server" CommandName="EditItem" CommandArgument='<%# Eval("m_id") %>' Text="Edit" CssClass="card-btn" CausesValidation="false" />
                                <asp:Button ID="btnDelete3" runat="server" CommandName="DeleteItem" CommandArgument='<%# Eval("m_id") %>' Text="Delete" CssClass="card-btn card-btn-danger" CausesValidation="false" />
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </asp:Panel>
    </div>
</asp:Content>
