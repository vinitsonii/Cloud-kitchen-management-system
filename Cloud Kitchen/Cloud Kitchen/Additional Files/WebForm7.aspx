<%@ Page Title="" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Admin.Master"
    CodeBehind="WebForm7.aspx.vb" Inherits="Cloud_Kitchen.WebForm7" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .update-panel
        {
            position: fixed;
            top: 60%;
            left: 60%;
            transform: translate(-50%, -50%);
            background: #ffffff;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 30px;
            max-width: 900px;
            width: 90%;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
            z-index: 1000;
            overflow-y: auto;
            max-height: 80vh;
            margin-bottom:50px;
            
        }
        .update-panel h3
        {
            text-align: center;
            font-size: 1.8em;
            margin-bottom: 20px;
            color: #0078D7;
        }
        .form-container
        {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
        }
        .form-column
        {
            flex: 1;
            min-width: 200px;
        }
        .form-group
        {
            margin-bottom: 15px;
        }
        .form-group label
        {
            display: block;
            font-weight: bold;
            margin-bottom: 5px;
            color: #555;
        }
        .form-group input, .form-group select, .form-group textarea
        {
            width: 90%;
            padding: 10px;
            font-size: 14px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .form-actions
        {
            margin-top: 20px;
            display: flex;
            justify-content: space-around;
        }
        .btn-save
        {
            background-color: #28a745;
            color: #fff;
            padding: 8px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .btn-cancel
        {
            background-color: #dc3545;
            color: #fff;
            padding: 8px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .grid-manage
        {
            margin-top: 30px;
            margin-bottom:50px;
        }
        .lblmsg
        {
            text-align: center;
            margin-top: 15px;
        }
        .item-image
        {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 5px;
        }
        @media (max-width: 768px)
        {
            .form-container
            {
                flex-direction: column;
            }
        }
        
        
        

/* Update Panel Styling */
.update-panel {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    background: #ffffff;
    border: 1px solid #ddd;
    border-radius: 12px;
    padding: 40px;
    max-width: 900px;
    width: 90%;
    box-shadow: 0 15px 40px rgba(0, 0, 0, 0.2);
    z-index: 1000;
    overflow-y: auto;
    max-height: 80vh;
}

/* Heading Styling */
.update-panel h3 {
    text-align: center;
    font-size: 2.2em;
    margin-bottom: 25px;
    color: #0078D7;
    border-bottom: 2px solid #0078D7;
    padding-bottom: 10px;
}

/* Search and Filter Styling */
.search-filter-container {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 20px;
    margin: 20px 0;
}

.search-box, .filter-dropdown {
    flex: 1;
    max-width: 280px;
    padding: 12px;
    border: 1px solid #ddd;
    border-radius: 8px;
    font-size: 14px;
}

.search-box::placeholder {
    color: #999;
}

/* Repeater Item Cards Styling */
.menu-items-container {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 20px;
    margin-top: 20px;
}

.menu-card {
    background-color: #f9f9f9;
    padding: 15px;
    border: 1px solid #ddd;
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    display: flex;
    flex-direction: column;
    justify-content: space-between;
}

.menu-card img {
    width: 100%;
    max-height: 160px;
    object-fit: cover;
    border-radius: 8px;
    margin-bottom: 10px;
}

.menu-card h4 {
    font-size: 18px;
    color: #333;
    margin-bottom: 8px;
}

.menu-card p {
    margin: 4px 0;
    color: #555;
}

.card-actions {
    display: flex;
    justify-content: space-between;
    margin-top: 10px;
}

.card-btn {
    background-color: #28a745;
    color: #fff;
    padding: 8px 12px;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    font-size: 14px;
}

.card-btn:hover {
    background-color: #218838;
}

.card-btn-danger {
    background-color: #dc3545;
}

.card-btn-danger:hover {
    background-color: #c82333;
}

.lblmsg {
    color: #f00;
    font-weight: 600;
    text-align: center;
    margin-top: 20px;
}

/* Responsive Design */
@media (max-width: 768px) {
    .search-filter-container {
        flex-direction: column;
        gap: 15px;
    }
}




    </style>








</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ImageButton ID="ImageButton3" runat="server" ImageUrl="~/icons/users.png" />
<%--   <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>

    <asp:UpdatePanel ID="UpdatePanel3" runat="server">
        <ContentTemplate>--%>
            <asp:Panel ID="up3" runat="server" CssClass="update-panel" Visible="False">
                <h3>
                    Manage Menu Item</h3>
                <asp:HiddenField ID="hfMenuItemId3" runat="server" />
                <div class="form-container">
                    <!-- Column 1 -->
                    <div class="form-column">
                        <div class="form-group">
                            <label>
                                Item Name</label>
                            <asp:TextBox ID="txtItemName3" runat="server" placeholder="Enter Item Name"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label>
                                Category</label>
                            <asp:DropDownList ID="ddlCategory3" runat="server" Width="98%">
                            </asp:DropDownList>
                        </div>
                        <div class="form-group">
                            <label>
                                Cuisine</label>
                            <asp:DropDownList ID="ddlCuisine3" runat="server" Width="98%">
                            </asp:DropDownList>
                        </div>
                        <div class="form-group">
                            <label>
                                Image</label>
                            <asp:FileUpload ID="fuImage3" runat="server" />
                            <asp:HiddenField ID="fn" runat="server" />
              
                        </div>
                    </div>
                    <!-- Column 2 -->
                    <div class="form-column">
                        <div class="form-group">
                            <label>
                                Price</label>
                            <asp:TextBox ID="txtPrice3" runat="server" TextMode="Number"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label>
                                Discount</label>
                            <asp:TextBox ID="txtDiscount3" runat="server" TextMode="Number"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label>
                                Final Price</label>
                            <asp:TextBox ID="txtFinalPrice3" runat="server" TextMode="Number"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label>
                                Description</label>
                            <asp:TextBox ID="txtDescription3" runat="server" TextMode="MultiLine" Rows="1" Style="resize: none;"></asp:TextBox>
                        </div>
                    </div>
                    <!-- Column 3 -->
                    <div class="form-column">
                        <div class="form-group">
                            <label>
                                Availability</label>
                            <asp:DropDownList ID="ddlAvailability3" runat="server" Width="100%">
                                <asp:ListItem Text="Available" Value="1"></asp:ListItem>
                                <asp:ListItem Text="Unavailable" Value="0"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="form-group">
                            <label>
                                Featured</label>
                            <asp:DropDownList ID="ddlFeatured3" runat="server" Width="100%">
                                <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                <asp:ListItem Text="No" Value="0"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="form-group">
                            <label>
                                Status</label>
                            <asp:DropDownList ID="ddlStatus3" runat="server" Width="100%">
                                <asp:ListItem Text="Active" Value="1"></asp:ListItem>
                                <asp:ListItem Text="Inactive" Value="0"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                       
                        <!--<div class="form-group"> -->
                        <div class="form-actions">
                            <asp:Button ID="btnSave3" runat="server" Text="Save" CssClass="btn-save" OnClick="btnSave3_Click" />
                            <asp:Button ID="btnUpdate3" runat="server" Text="Update" CssClass="btn-save" OnClick="btnUpdate3_Click"
                                Visible="False" />
                            <asp:Button ID="btnCancel3" runat="server" Text="Cancel" CssClass="btn-cancel" OnClick="btnCancel3_Click" />
                            <!--</div> -->
                        </div>
                    </div>
                </div>
                <div class="form-group lblmsg">
                    <asp:Label ID="lblmsg3" runat="server" ForeColor="Red"></asp:Label>
                </div>
                <%--<div class="grid-manage">

               
                    <div class="form-group" >
                        <label for="txtSearch">Search Menu Item</label>
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="search-box" AutoPostBack="True" 
                                     OnTextChanged="txtSearch_TextChanged" placeholder="Search by Name..." Width="30%"></asp:TextBox>
                    
                        <label for="ddlFilterCategory">Filter by Category</label>
                        <asp:DropDownList ID="ddlFilterCategory" runat="server" CssClass="filter-dropdown" 
                                          AutoPostBack="True" OnSelectedIndexChanged="ddlFilterCategory_SelectedIndexChanged" Width="30%">
                        </asp:DropDownList>
                    </div>

                    <h2>
                        Menu Items List</h2>
                    <asp:Repeater ID="rptMenuItems3" runat="server" OnItemCommand="rptMenuItems3_ItemCommand">
                        <HeaderTemplate>
                            <table class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th>Image</th>
                                        <th>Name</th>
                                        <th>Price</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td><img src='<%# Eval("m_image_url") %>' class="item-image" /></td>
                                <td><%# Eval("m_name") %></td>
                                <td><%# Eval("m_price") %></td>
                                <td><%# Eval("m_status") %></td>
                                <td>
                                    <asp:Button ID="btnEdit3" runat="server" CommandName="EditItem" CommandArgument='<%# Eval("m_id") %>' Text="Edit" CssClass="btn btn-primary btn-sm" />
                                    <asp:Button ID="btnDelete3" runat="server" CommandName="DeleteItem" CommandArgument='<%# Eval("m_id") %>' Text="Delete" CssClass="btn btn-danger btn-sm" />
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                            </tbody></table>
                        </FooterTemplate>
                    </asp:Repeater>
                </div>--%>

                <!-- Search & Filter Section -->
                    <div class="search-filter-container">

                            <asp:TextBox ID="txtSearch" runat="server" CssClass="search-box" AutoPostBack="True"
                                         OnTextChanged="txtSearch_TextChanged" placeholder="Search by Name..."></asp:TextBox>
                            <asp:DropDownList ID="ddlFilterCategory" runat="server" CssClass="filter-dropdown" 
                                              AutoPostBack="True" OnSelectedIndexChanged="ddlFilterCategory_SelectedIndexChanged">
                            </asp:DropDownList>
                        </div>

                        <!-- Menu Items List -->
                        <div class="menu-items-container">
                            <asp:Repeater ID="rptMenuItems3" runat="server" OnItemCommand="rptMenuItems3_ItemCommand">
                                <ItemTemplate>
                                    <div class="menu-card">
                                        <img src='<%# Eval("m_image_url") %>' alt="Menu Image" />
                                        <h4><%# Eval("m_name") %></h4>
                                        <p>Price: $<%# Eval("m_price") %></p>
                                        <p>Status: <%# Eval("m_status") %></p>
                                        <div class="card-actions">
                                            <asp:Button ID="btnEdit3" runat="server" CommandName="EditItem"
                                                        CommandArgument='<%# Eval("m_id") %>' Text="Edit" CssClass="card-btn" />
                                            <asp:Button ID="btnDelete3" runat="server" CommandName="DeleteItem"
                                                        CommandArgument='<%# Eval("m_id") %>' Text="Delete" CssClass="card-btn card-btn-danger" />
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>

            </asp:Panel>
<%--        </ContentTemplate>
    </asp:UpdatePanel>--%>
</asp:Content>
