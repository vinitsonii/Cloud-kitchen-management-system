<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Admin.Master" CodeBehind="WebForm6.aspx.vb" Inherits="Cloud_Kitchen.WebForm6" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

   <style>
        .update-panel {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: #ffffff;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 30px;
            max-width: 500px;
            width: 90%;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
            z-index: 1000;
        }

        .update-panel h3 {
            text-align: center;
            font-size: 1.8em;
            margin-bottom: 20px;
            color: #0078D7;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            font-weight: bold;
            margin-bottom: 5px;
            color: #555;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 8px;
            font-size: 14px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        .form-group input:focus,
        .form-group select:focus {
            border-color: #0078D7;
            outline: none;
        }

        .form-actions {
            margin-top: 20px;
            display: flex;
            justify-content: space-around;
        }

        .btn-save {
            background-color: #28a745;
            color: #fff;
            padding: 8px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .btn-save:hover {
            background-color: #218838;
        }

        .btn-cancel {
            background-color: #dc3545;
            color: #fff;
            padding: 8px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .btn-cancel:hover {
            background-color: #c82333;
        }

        .grid-manage {
            margin-top: 30px;
        }

        .grid-manage h2 {
            text-align: center;
            margin-bottom: 20px;
        }

        .lblmsg {
            text-align: center;
            margin-top: 15px;
        }
    </style>



</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
 <asp:ImageButton ID="ImageButton2" runat="server" ImageUrl="~/icons/users1.png" OnClick="ImageButton2_Click" />
    
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>
            <asp:Panel ID="up2" runat="server" CssClass="update-panel" Visible="False">
                <h3>Manage Cuisine</h3>

                <asp:HiddenField ID="hfCuisineId" runat="server" />

                <div class="form-group">
                    <label for="txtCuisineName">Cuisine Name</label>
                    <asp:TextBox ID="txtCuisineName" runat="server" CssClass="form-control" placeholder="Enter Cuisine name"></asp:TextBox>
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
                    <asp:Button ID="btnSave2" runat="server" Text="Save" CssClass="btn-save"  />
                    <asp:Button ID="btnUpdate2" runat="server" Text="Update" CssClass="btn-save"  Visible="False" />
                    <asp:Button ID="btnCancel2" runat="server" Text="Cancel" CssClass="btn-cancel"  />
                </div>

                <div class="grid-manage">
                    <h2>Select Cuisine To Edit</h2>
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
                                    <asp:Button ID="btnEdit2" runat="server" CommandName="EditCuisine" CommandArgument='<%# Eval("cuisine_id") %>' Text="Edit" CssClass="btn btn-primary btn-sm" />
                                    <asp:Button ID="btnDelete2" runat="server" CommandName="DeleteCuisineName" CommandArgument='<%# Eval("cuisine_id") %>' Text="Delete" CssClass="btn btn-danger btn-sm" />
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                                </tbody>
                            </table>
                        </FooterTemplate>
                    </asp:Repeater>
                </div>
            </asp:Panel>
        </ContentTemplate>
    </asp:UpdatePanel>
    
</asp:Content>
