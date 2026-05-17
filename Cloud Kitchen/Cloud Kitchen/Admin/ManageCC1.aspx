<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Admin.Master" CodeBehind="ManageCC1.aspx.vb" Inherits="Cloud_Kitchen.WebForm9" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .manage-cc-page {
            width: min(100%, 1240px);
            margin: 0 auto;
        }

        .manage-cc-page h3,
        .manage-cc-page .food-heading,
        .manage-cc-page .grid-manage h2 {
            font-family: 'Poppins', sans-serif;
            text-align: center;
            text-transform: uppercase;
            font-weight: 700;
            letter-spacing: 0.5px;
        }

        .manage-cc-page h3 {
            font-size: clamp(1.35rem, 3vw, 1.6rem);
            color: #1a73e8;
            margin-bottom: 22px;
            position: relative;
            padding-bottom: 10px;
        }

        .manage-cc-page h3::after {
            content: '';
            position: absolute;
            width: 60px;
            height: 3px;
            background: linear-gradient(90deg, #1a73e8, #6ab7ff);
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            border-radius: 3px;
        }

        .food-heading {
            font-size: clamp(1.55rem, 4vw, 2rem);
            background: -webkit-linear-gradient(45deg, #1a73e8, #6ab7ff);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: clamp(22px, 4vw, 30px);
            position: relative;
            display: inline-block;
            overflow-wrap: anywhere;
        }

        .food-heading::after {
            content: '';
            position: absolute;
            width: 80px;
            height: 4px;
            background: linear-gradient(90deg, #1a73e8, #6ab7ff);
            bottom: -8px;
            left: 50%;
            transform: translateX(-50%);
            border-radius: 4px;
        }

        .grid-manage h2 {
            font-size: clamp(1.1rem, 3vw, 1.4rem);
            color: #1a73e8;
            margin-top: 30px;
            margin-bottom: 15px;
            position: relative;
        }

        .card-container {
            width: 100%;
            min-height: calc(100vh - 48px);
            margin: 0 auto;
            padding: clamp(18px, 3vw, 30px);
            border-radius: 16px;
            background: #fff;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1), 0 5px 15px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            overflow: hidden;
            position: relative;
            animation: fadeIn 0.8s ease-out, slideUp 0.5s ease-out;
        }

        .card-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: linear-gradient(90deg, #1a73e8, #6ab7ff);
        }

        .heading-wrap {
            text-align: center;
        }

        .button-wrapper {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: clamp(18px, 3vw, 30px);
            width: 100%;
            align-items: start;
        }

        .button-box {
            min-width: 0;
            max-height: calc(100vh - 210px);
            overflow: auto;
            padding: clamp(18px, 3vw, 25px);
            border-radius: 16px;
            background: #fff;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
            border: 1px solid #f0f0f0;
            position: relative;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .button-box::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #1a73e8, #6ab7ff);
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .button-box:hover {
            transform: translateY(-6px);
            box-shadow: 0 15px 35px rgba(26, 115, 232, 0.15);
        }

        .button-box:hover::before {
            opacity: 1;
        }

        .button-box::-webkit-scrollbar {
            width: 8px;
            height: 8px;
        }

        .button-box::-webkit-scrollbar-track {
            background: #f0f2f5;
            border-radius: 10px;
        }

        .button-box::-webkit-scrollbar-thumb {
            background: rgba(26, 115, 232, 0.6);
            border-radius: 10px;
            border: 2px solid #f0f2f5;
        }

        .button-box::-webkit-scrollbar-thumb:hover {
            background: rgba(26, 115, 232, 0.8);
        }

        .scrollable-panel {
            width: 100%;
            padding-top: 20px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
            margin-bottom: 20px;
        }

        .form-group label {
            font-size: 0.9rem;
            font-weight: 600;
            color: #424242;
            letter-spacing: 0.3px;
        }

        .manage-cc-page input[type="text"],
        .manage-cc-page select,
        .manage-cc-page .form-control {
            width: 100% !important;
            max-width: 100%;
            padding: 12px 16px;
            font-size: 0.95rem;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            background: #f8f9fa;
            box-shadow: inset 1px 1px 4px rgba(0, 0, 0, 0.05);
            transition: border-color 0.3s, box-shadow 0.3s, background 0.3s;
        }

        .manage-cc-page input[type="text"]:focus,
        .manage-cc-page select:focus,
        .manage-cc-page .form-control:focus {
            border-color: #1a73e8;
            outline: none;
            box-shadow: 0 0 0 3px rgba(26, 115, 232, 0.2);
            background: #fff;
        }

        .form-actions {
            display: flex;
            gap: 12px;
            margin-top: 24px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn-save,
        .btn-cancel {
            min-height: 42px;
            color: white;
            padding: 10px 22px;
            font-size: 0.95rem;
            font-weight: 600;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: transform 0.3s ease, box-shadow 0.3s ease, background 0.3s ease;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            white-space: nowrap;
        }

        .btn-save {
            background: linear-gradient(135deg, #1a73e8, #0d47a1);
        }

        .btn-save:hover {
            background: linear-gradient(135deg, #0d47a1, #0a3880);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(26, 115, 232, 0.3);
        }

        .btn-cancel {
            background: linear-gradient(135deg, #f44336, #d32f2f);
        }

        .btn-cancel:hover {
            background: linear-gradient(135deg, #d32f2f, #b71c1c);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(244, 67, 54, 0.3);
        }

        .lblmsg {
            color: #f44336;
            text-align: center;
            font-size: 0.9rem;
            font-weight: 500;
            padding: 5px 0;
            overflow-wrap: anywhere;
        }

        .table-responsive {
            width: 100%;
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
            background: white;
        }

        .table-bordered {
            width: 100%;
            min-width: 520px;
            border-collapse: separate;
            border-spacing: 0;
            margin: 0;
            overflow: hidden;
            background: white;
        }

        .table-bordered thead {
            background: linear-gradient(135deg, #1a73e8, #0d47a1);
            color: white;
            font-weight: bold;
        }

        .table-bordered th,
        .table-bordered td {
            padding: 12px 14px;
            border: none;
            border-bottom: 1px solid #eaeaea;
            text-align: left;
            font-size: 0.95rem;
            vertical-align: middle;
        }

        .table-bordered th {
            letter-spacing: 0.5px;
            text-transform: uppercase;
            font-size: 0.85rem;
            white-space: nowrap;
        }

        .table-bordered tbody tr:last-child td {
            border-bottom: none;
        }

        .table-bordered tbody tr {
            transition: background 0.2s ease, box-shadow 0.2s ease;
        }

        .table-bordered tbody tr:nth-child(even) {
            background: #f8fafd;
        }

        .table-bordered tbody tr:hover {
            background: #e8f0fe;
            cursor: pointer;
            box-shadow: 0 2px 10px rgba(26, 115, 232, 0.15);
        }

        .table-actions {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .table-bordered .btn-save,
        .table-bordered .btn-cancel {
            padding: 6px 12px;
            font-size: 0.85rem;
            min-width: 70px;
            min-height: 34px;
        }

        .image-button {
            width: 110px;
            height: 110px;
            transition: transform 0.4s ease-in-out;
            filter: drop-shadow(0 5px 15px rgba(0, 0, 0, 0.1));
        }

        .button-text {
            font-size: 16px;
            font-weight: 700;
            color: #1a73e8;
            text-align: center;
            margin-top: 15px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        [id*="RegularExpressionValidator"] {
            font-size: 0.8rem;
            padding: 5px 0;
            transition: all 0.3s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(14px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @media (max-width: 1100px) {
            .button-wrapper {
                grid-template-columns: 1fr;
            }

            .button-box {
                max-height: none;
                overflow: visible;
            }
        }

        @media (max-width: 768px) {
            .card-container {
                padding: 20px;
            }

            .form-actions {
                flex-direction: column;
            }

            .btn-save,
            .btn-cancel {
                width: 100%;
            }
        }

        @media (max-width: 576px) {
            .card-container {
                padding: 18px 14px;
                border-radius: 12px;
            }

            .button-box {
                padding: 16px;
                border-radius: 12px;
            }

            .button-box:hover,
            .btn-save:hover,
            .btn-cancel:hover {
                transform: none;
            }

            .table-actions {
                flex-direction: column;
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
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

    <div class="manage-cc-page">
        <asp:UpdatePanel ID="UpdatePanel4" runat="server">
            <ContentTemplate>
                <div class="card-container">
                    <div class="heading-wrap">
                        <h2 class="food-heading">Manage Food Items</h2>
                    </div>

                    <div class="button-wrapper">
                        <div class="button-box">
                            <%-- <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="~/icons/users1.png" CssClass="image-button" CausesValidation="false" ToolTip="Category Management" />
                            <p class="button-text">Manage Categories</p> --%>
                            <asp:Panel ID="up1" runat="server" CssClass="scrollable-panel">
                                <h3>Manage Category</h3>

                                <asp:HiddenField ID="hfCategoryId" runat="server" />

                                <div class="form-group">
                                    <label for="txtCategoryName">Category Name</label>
                                    <asp:TextBox ID="txtCategoryName" runat="server" CssClass="form-control" placeholder="Enter category name"></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="revcatName" runat="server" ControlToValidate="txtCategoryName"
                                        ErrorMessage="Only alphabets and spaces are allowed." ValidationGroup="frm1" ValidationExpression="^[A-Za-z ]+$"
                                        Display="Dynamic" ForeColor="Red" />
                                </div>

                                <div class="form-group">
                                    <label for="ddlCategoryStatus">Category Status</label>
                                    <asp:DropDownList ID="ddlCategoryStatus" runat="server" CssClass="form-control">
                                        <asp:ListItem Text="Active" Value="1"></asp:ListItem>
                                        <asp:ListItem Text="Inactive" Value="0"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>

                                <div class="form-group lblmsg">
                                    <asp:Label ID="lblmsg" runat="server" ForeColor="Red"></asp:Label>
                                </div>

                                <div class="form-actions">
                                    <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="btn-save" OnClick="btnSave_Click" ValidationGroup="frm1" />
                                    <asp:Button ID="btnUpdate" runat="server" Text="Update" CssClass="btn-save" OnClick="btnUpdate_Click" Visible="False" ValidationGroup="frm1" />
                                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn-cancel" OnClick="btnCancel_Click" CausesValidation="false" />
                                </div>

                                <div class="grid-manage">
                                    <h2>Select Category To Edit</h2>
                                    <div class="table-responsive">
                                        <asp:Repeater ID="rptcat" runat="server" OnItemCommand="rptcat_ItemCommand">
                                            <HeaderTemplate>
                                                <table class="table table-striped table-bordered">
                                                    <thead>
                                                        <tr>
                                                            <th>Category Name</th>
                                                            <th>Status</th>
                                                            <th>Actions</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <tr>
                                                    <td><%# Eval("category_name") %></td>
                                                    <td><%# Eval("category_status") %></td>
                                                    <td>
                                                        <div class="table-actions">
                                                            <asp:Button ID="btnEdit" runat="server" CssClass="btn-save" CommandName="EditCategory" CommandArgument='<%# Eval("category_id") %>' Text="Edit" CausesValidation="false" />
                                                            <asp:Button ID="btnDelete" runat="server" CssClass="btn-cancel" CommandName="DeleteCategory" CommandArgument='<%# Eval("category_id") %>' Text="Delete" CausesValidation="false" />
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
                                </div>
                            </asp:Panel>
                        </div>

                        <div class="button-box">
                            <%--<asp:ImageButton ID="ImageButton2" runat="server" ImageUrl="~/icons/edit.png" CssClass="image-button" CausesValidation="false" ToolTip="Cuisine Item" />
                            <p class="button-text">Manage Cuisines</p>
                            --%>
                            <asp:Panel ID="up2" runat="server" CssClass="scrollable-panel">
                                <h3>Manage Cuisine</h3>

                                <asp:HiddenField ID="hfCuisineId" runat="server" />

                                <div class="form-group">
                                    <label for="txtCuisineName">Cuisine Name</label>
                                    <asp:TextBox ID="txtCuisineName" runat="server" CssClass="form-control" placeholder="Enter Cuisine name"></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtCuisineName"
                                        ErrorMessage="Only alphabets and spaces are allowed." ValidationGroup="frm2" ValidationExpression="^[A-Za-z ]+$"
                                        Display="Dynamic" ForeColor="Red" />
                                </div>

                                <div class="form-group">
                                    <label for="ddlCuisineStatus">Cuisine Status</label>
                                    <asp:DropDownList ID="ddlCuisineStatus" runat="server" CssClass="form-control">
                                        <asp:ListItem Text="Active" Value="1"></asp:ListItem>
                                        <asp:ListItem Text="Inactive" Value="0"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>

                                <div class="form-group lblmsg">
                                    <asp:Label ID="lblmsg2" runat="server" ForeColor="Red"></asp:Label>
                                </div>

                                <div class="form-actions">
                                    <asp:Button ID="btnSave2" runat="server" Text="Save" CssClass="btn-save" ValidationGroup="frm2" />
                                    <asp:Button ID="btnUpdate2" runat="server" Text="Update" CssClass="btn-save" ValidationGroup="frm2" Visible="False" />
                                    <asp:Button ID="btnCancel2" runat="server" Text="Cancel" CssClass="btn-cancel" CausesValidation="false" />
                                </div>

                                <div class="grid-manage">
                                    <h2>Select Cuisine To Edit</h2>
                                    <div class="table-responsive">
                                        <asp:Repeater ID="rptcuisine" runat="server" OnItemCommand="rptcuisine_ItemCommand">
                                            <HeaderTemplate>
                                                <table class="table table-striped table-bordered">
                                                    <thead>
                                                        <tr>
                                                            <th>Cuisine Name</th>
                                                            <th>Status</th>
                                                            <th>Actions</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <tr>
                                                    <td><%# Eval("cuisine_name")%></td>
                                                    <td><%# Eval("cuisine_status")%></td>
                                                    <td>
                                                        <div class="table-actions">
                                                            <asp:Button ID="btnEdit2" runat="server" CommandName="EditCuisine" CommandArgument='<%# Eval("cuisine_id") %>' Text="Edit" CssClass="btn-save" CausesValidation="false" />
                                                            <asp:Button ID="btnDelete2" runat="server" CommandName="DeleteCuisineName" CommandArgument='<%# Eval("cuisine_id") %>' Text="Delete" CssClass="btn-cancel" CausesValidation="false" />
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
                                </div>
                            </asp:Panel>
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>
