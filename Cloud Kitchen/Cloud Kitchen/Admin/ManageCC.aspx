<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Admin.Master" CodeBehind="ManageCC.aspx.vb" Inherits="Cloud_Kitchen.WebForm8" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">


 <style type="text/css">
 
.update-panel {
            animation: fadeIn 0.8s ease-out, slideDown 0.5s ease-out;
            position: fixed; 
            top: 50%;
            left: 60%;
            transform: translate(-50%, -50%);
            padding: 30px;
            background: #ffffff; 
            border: 1px solid #e0e0e0;
            border-radius: 5px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.4); 
            max-width: 600px;
            width: 80%;
            z-index: 2050; 
            max-height: 80vh;
            margin-bottom:5%;
            overflow-y: auto;
}

h3 {
    font-family: 'Poppins', sans-serif;
    font-size: 1.6rem;
    color: #0073e6;
    text-align: center;
    font-weight: 700;
    margin-bottom: 18px;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.form-group {
    display: flex;
    flex-direction: column;
    gap: 8px;
    margin-bottom: 16px;
}

.form-group label {
    font-size: 0.9rem;
    font-weight: 600;
    color: #333;
}

input[type="text"], select {
    padding: 10px;
    font-size: 0.9rem;
    border: 1px solid #ccc;
    border-radius: 6px;
    background: #ffffff;
    box-shadow: inset 1px 1px 4px rgba(0, 0, 0, 0.05);
    transition: all 0.3s;
}

input[type="text"]:focus, select:focus {
    border-color: #0073e6;
    outline: none;
    box-shadow: 0 0 5px rgba(0, 115, 230, 0.4);
}

.form-actions {
    display: flex;
    justify-content: flex-start;
    margin-top: 20px;
    gap: 10px;
}

.btn-save {
    background: linear-gradient(135deg, #0078d4, #005fa3);
    color: white;
    padding: 8px 22px;
    font-size: 0.9rem;
    font-weight: 600;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    transition: background 0.3s ease;
}

.btn-save:hover {
    background: linear-gradient(135deg, #005fa3, #004a7a);
}

.btn-cancel {
    background: #d9534f;
    color: white;
    padding: 8px 18px;
    font-size: 0.9rem;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    transition: background 0.3s ease;
}

.btn-cancel:hover {
    background: #b12b27;
}

.grid-manage h2 {
    font-family: 'Poppins', sans-serif;
    font-size: 1.4rem;
    font-weight: 700;
    text-align: center;
    color: #0073e6;
    margin-top: 30px;
}

table.table-bordered {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
    box-shadow: 0 8px 12px rgba(0, 0, 0, 0.08);
    overflow: hidden;
}

table.table-bordered thead {
    background: linear-gradient(135deg, #0078d4, #005fa3);
    color: white;
    font-weight: bold;
}

table.table-bordered th, table.table-bordered td {
    padding: 12px;
    border: 1px solid #ddd;
    text-align: left;
    font-size: 0.9rem;
}

table.table-bordered tbody tr:nth-child(even) {
    background: #f9f9f9;
}

table.table-bordered tbody tr:hover {
    background: #f1f7ff;
    cursor: pointer;
}

.lblmsg {
    color: #d9534f;
    text-align: center;
    margin-top: 10px;
    font-size: 0.9rem;
}

.message {
    text-align: center;
    font-size: 0.8rem;
    padding: 10px;
    border-radius: 5px;
    display: none;
}

.message.success {
    background-color: #d4edda;
    color: #155724;
    border: 1px solid #c3e6cb;
}

.message.error {
    background-color: #f8d7da;
    color: #721c24;
    border: 1px solid #f5c6cb;
}


@keyframes fadeIn {
    0% { opacity: 0; }
    100% { opacity: 1; }
}


@media (max-width: 768px) {
    .update-panel {
        width: 95%;
    }

    .form-actions {
        flex-direction: column;
        gap: 8px;
    }
}

 
 
.card-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    height: 50vh;
   // background: linear-gradient(135deg, #0078d4, #005fa3);
    padding: 30px;
    border-radius: 12px;
    box-shadow: 0px 10px 25px rgba(0, 0, 0, 0.2);
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}


.food-heading {
    font-size: 1.8rem;
    color: #000;
    font-family: 'Poppins', sans-serif;
    font-weight: 700;
    text-align: center;
    margin-bottom: 20px;
    text-transform: uppercase;
    letter-spacing: 1px;
}

.button-wrapper {
    display: flex;
    gap: 25px;
    justify-content: center;
    align-items: center;
    cursor:pointer;
}
.button-box {
    background: white;
    padding: 20px;
    border-radius: 12px;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
    display: flex;
    flex-direction: column;
    align-items: center;
    transition: all 0.3s ease;
    width: 250px;
    height:200px;
}

.button-box:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.3);
}

.image-button {
    width: 100px;
    height: 100px;
    //border-radius: 50%;
    transition: all 0.4s ease-in-out;
}

.button-text {
    font-size: 14px;
    font-weight: bold;
    color: #333;
    text-align: center;
    margin-top: 10px;
}

@media (max-width: 768px) {
    .button-wrapper {
        flex-direction: column;
        gap: 15px;
    }
}


 </style>


</asp:Content>



<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


<asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    

<asp:UpdatePanel ID="UpdatePanel4" runat="server">
    <ContentTemplate>
        <div class="card-container">
            <h2 class="food-heading">Manage Food Items</h2>
            <div class="button-wrapper">
                <div class="button-box">
                    <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="~/icons/users1.png" CssClass="image-button" CausesValidation="false" ToolTip="Category Management" />
                    <p class="button-text">Manage Categories</p>
                </div>
                <div class="button-box">
                    <asp:ImageButton ID="ImageButton2" runat="server" ImageUrl="~/icons/edit.png" CssClass="image-button" CausesValidation="false" ToolTip="Cuisine Item" />
                    <p class="button-text">Manage Cuisines</p>
                </div>
            </div>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>






    
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:Panel ID="up1" runat="server" CssClass="update-panel" Visible="False">
                <h3>Manage Category</h3>

                <asp:HiddenField ID="hfCategoryId" runat="server" />

                <div class="form-group">
                    <label for="txtCategoryName">Category Name</label>
                    <asp:TextBox ID="txtCategoryName" runat="server" CssClass="form-control" placeholder="Enter category name"></asp:TextBox>
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
                    <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="btn-save" OnClick="btnSave_Click" CausesValidation="false"/>
                    <asp:Button ID="btnUpdate" runat="server" Text="Update" CssClass="btn-save" OnClick="btnUpdate_Click" Visible="False" CausesValidation="false"/>
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn-cancel" OnClick="btnCancel_Click" CausesValidation="false" />
                </div>

                <div class="grid-manage">
                    <h2>Select Category To Edit</h2>
                    <asp:Repeater ID="rptcat" runat="server" OnItemCommand="rptcat_ItemCommand" >
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
                                <td >
                                    <asp:Button ID="btnEdit" runat="server" CssClass="btn-save" CommandName="EditCategory" CommandArgument='<%# Eval("category_id") %>' Text="Edit" CausesValidation="false" />
                                    <asp:Button ID="btnDelete" runat="server" CssClass="btn-cancel" CommandName="DeleteCategory" CommandArgument='<%# Eval("category_id") %>' Text="Delete" CausesValidation="false" />
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
                    <asp:Button ID="btnSave2" runat="server" Text="Save" CssClass="btn-save" CausesValidation="false"  />
                    <asp:Button ID="btnUpdate2" runat="server" Text="Update" CssClass="btn-save"  Visible="False" CausesValidation="false"/>
                    <asp:Button ID="btnCancel2" runat="server" Text="Cancel" CssClass="btn-cancel" CausesValidation="false" />
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
                                    <asp:Button ID="btnEdit2" runat="server" CommandName="EditCuisine" CommandArgument='<%# Eval("cuisine_id") %>' Text="Edit" CssClass="btn-save" CausesValidation="false"/>
                                    <asp:Button ID="btnDelete2" runat="server" CommandName="DeleteCuisineName" CommandArgument='<%# Eval("cuisine_id") %>' Text="Delete" CssClass="btn-cancel" CausesValidation="false"/>
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
