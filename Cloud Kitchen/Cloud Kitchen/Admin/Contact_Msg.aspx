<%@ Page Title="Contact Messages" Language="vb" AutoEventWireup="false" MasterPageFile="~/Admin/Admin.Master"
    CodeBehind="Contact_Msg.aspx.vb" Inherits="Cloud_Kitchen.WebForm12" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .contact-msg-page {
            width: min(100%, 1240px);
            margin: 0 auto;
            font-family: "Poppins", sans-serif;
        }

        .messages-container {
            width: 100%;
            padding: clamp(16px, 3vw, 30px);
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0px 8px 25px rgba(0, 0, 0, 0.08);
            transition: box-shadow 0.3s ease-in-out;
            overflow: hidden;
        }

        .contact-msg-page .dashboard-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 18px;
            margin-bottom: 25px;
            border-bottom: 2px solid royalblue;
            padding-bottom: 15px;
        }

        .messages-header {
            font-size: clamp(1.45rem, 4vw, 1.9rem);
            font-weight: 700;
            color: #2c3e50;
            margin: 0;
            padding-bottom: 8px;
            border-bottom: 3px solid #4A90E2;
            overflow-wrap: anywhere;
        }

        .messages-stat {
            display: flex;
            gap: 16px;
            flex-wrap: wrap;
            justify-content: flex-end;
        }

        .stat-item {
            min-width: 96px;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 10px 15px;
            border-radius: 8px;
            background: #f8f9fa;
        }

        .stat-value {
            font-size: 20px;
            font-weight: 800;
            color: #3498db;
            overflow-wrap: anywhere;
        }

        .stat-label {
            font-size: 12px;
            color: #6c757d;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .filters-section {
            display: grid;
            grid-template-columns: minmax(280px, 1fr) minmax(220px, 350px);
            gap: 16px;
            align-items: center;
            margin-bottom: 25px;
            padding: 16px;
            background-color: #f8f9fa;
            border-radius: 10px;
        }

        .filter-controls {
            min-width: 0;
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap;
        }

        .filter-label {
            font-size: 14px;
            font-weight: 700;
            color: #495057;
            white-space: nowrap;
        }

        .styled-dropdown {
            width: min(100%, 190px);
            font-family: "Poppins", sans-serif;
            font-weight: 500;
            padding: 10px 16px;
            font-size: 14px;
            border: 1px solid #ced4da;
            border-radius: 6px;
            background: #fff;
            transition: border-color 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
            cursor: pointer;
        }

        .styled-dropdown:focus {
            outline: none;
            border-color: #4dabf7;
            box-shadow: 0 0 0 3px rgba(77, 171, 247, 0.2);
        }

        .search-box {
            position: relative;
            width: 100%;
        }

        .search-input {
            width: 100% !important;
            max-width: 100%;
            padding: 10px 16px;
            font-family: "Poppins", sans-serif;
            font-size: 14px;
            border: 1px solid #ced4da;
            border-radius: 6px;
            transition: border-color 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
        }

        .search-input:focus {
            outline: none;
            border-color: #4dabf7;
            box-shadow: 0 0 0 3px rgba(77, 171, 247, 0.2);
        }

        .messages-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(min(100%, 320px), 1fr));
            gap: clamp(16px, 3vw, 24px);
        }

        .message-card {
            min-width: 0;
            background: white;
            border-radius: 10px;
            padding: clamp(16px, 3vw, 20px);
            box-shadow: 0 3px 15px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s ease-in-out, box-shadow 0.3s ease-in-out;
            border-left: 5px solid #e9ecef;
            position: relative;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .message-card.unread {
            border-left-color: #3498db;
            background-color: #f8fbff;
        }

        .message-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
        }

        .message-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 14px;
            margin-bottom: 15px;
            position: relative;
        }

        .message-info {
            flex-grow: 1;
            min-width: 0;
        }

        .message-name {
            font-weight: 700;
            font-size: 17px;
            color: #2c3e50;
            margin-bottom: 4px;
            overflow-wrap: anywhere;
        }

        .message-name::before {
            content: "> ";
            color: #3498db;
        }

        .message-email {
            font-size: 14px;
            color: #6c757d;
            margin-left: 12px;
            overflow-wrap: anywhere;
        }

        .message-email::before {
            content: "Email: ";
            color: #6c757d;
            font-weight: 600;
        }

        .message-date {
            font-size: 12px;
            color: #000;
            margin-top: 5px;
            margin-left: 12px;
        }

        .message-date::before {
            content: "Date: ";
            color: #6c757d;
            font-weight: 600;
        }

        .message-status {
            flex: 0 0 auto;
            font-size: 12px;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 30px;
            background: #e9ecef;
            color: #6c757d;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            white-space: nowrap;
        }

        .message-status.unread {
            background: #e3f2fd;
            color: #0d6efd;
        }

        .message-content {
            font-size: 15px;
            color: #495057;
            margin-bottom: 20px;
            line-height: 1.6;
            max-height: 140px;
            overflow: auto;
            position: relative;
            overflow-wrap: anywhere;
            padding-right: 4px;
        }

        .message-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            margin-top: 10px;
            flex-wrap: wrap;
        }

        .btn-mark-read,
        .btn-delete {
            min-height: 38px;
            padding: 8px 16px;
            font-size: 14px;
            font-weight: 700;
            border-radius: 6px;
            cursor: pointer;
            transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out, background 0.2s ease-in-out, border-color 0.2s ease-in-out;
            white-space: nowrap;
        }

        .btn-mark-read {
            color: white;
            border: none;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .btn-mark-read.unread {
            background: #3498db;
        }

        .btn-mark-read.read {
            background: #6c757d;
            opacity: 0.7;
        }

        .btn-mark-read:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .btn-mark-read.unread:hover {
            background: #2980b9;
        }

        .btn-delete {
            color: #6c757d;
            background: none;
            border: 1px solid #ced4da;
        }

        .btn-delete:hover {
            color: #dc3545;
            border-color: #dc3545;
            background: #fff5f5;
        }

        .empty-state {
            text-align: center;
            padding: clamp(32px, 6vw, 50px) 20px;
            color: #6c757d;
            background: #f8f9fa;
            border-radius: 10px;
            margin-bottom: 20px;
        }

        .empty-state-text {
            font-size: 16px;
            font-weight: 600;
            margin: 0;
        }

        .empty-state-text::before {
            content: "No data";
            font-size: 14px;
            display: block;
            margin-bottom: 10px;
            color: #adb5bd;
            text-transform: uppercase;
            letter-spacing: 0.6px;
        }

        .pagination-container {
            display: flex;
            justify-content: center;
            margin-top: 30px;
        }

        .pagination {
            display: flex;
            list-style: none;
            padding: 0;
            margin: 0;
            gap: 6px;
            flex-wrap: wrap;
            justify-content: center;
        }

        .page-item {
            display: inline-block;
        }

        .page-link {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: #f8f9fa;
            color: #495057;
            text-decoration: none;
            transition: background 0.2s, color 0.2s;
            font-weight: 700;
        }

        .page-link:hover {
            background: #e9ecef;
        }

        .page-item.active .page-link {
            background: #3498db;
            color: white;
        }

        .page-nav-prev::after {
            content: "<";
        }

        .page-nav-next::after {
            content: ">";
        }

        @media (max-width: 768px) {
            .contact-msg-page .dashboard-header {
                flex-direction: column;
                align-items: stretch;
            }

            .messages-stat {
                width: 100%;
                justify-content: space-between;
            }

            .stat-item {
                flex: 1 1 120px;
            }

            .filters-section {
                grid-template-columns: 1fr;
                align-items: stretch;
            }

            .filter-controls {
                width: 100%;
                align-items: stretch;
            }

            .styled-dropdown {
                width: 100%;
            }

            .message-header {
                flex-direction: column;
            }

            .message-status {
                align-self: flex-start;
            }
        }

        @media (max-width: 480px) {
            .messages-container {
                border-radius: 10px;
            }

            .messages-stat {
                flex-direction: column;
            }

            .filter-controls {
                flex-direction: column;
            }

            .message-actions {
                flex-direction: column;
                align-items: stretch;
            }

            .btn-mark-read,
            .btn-delete {
                width: 100%;
                white-space: normal;
            }

            .message-card:hover,
            .btn-mark-read:hover {
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
    <script type="text/javascript">
        function markAsReadSuccess(buttonId) {
            var button = document.getElementById(buttonId);
            if (!button) return;

            button.innerText = "Read";
            button.classList.remove("unread");
            button.classList.add("read");
            button.disabled = true;

            var messageCard = button.closest(".message-card");
            if (messageCard) {
                messageCard.classList.remove("unread");

                var statusBadge = messageCard.querySelector(".message-status");
                if (statusBadge) {
                    statusBadge.innerText = "Read";
                    statusBadge.classList.remove("unread");
                }
            }

            var unreadCount = document.getElementById("unreadCount");
            if (unreadCount) {
                var currentCount = parseInt(unreadCount.innerText, 10);
                if (currentCount > 0) {
                    unreadCount.innerText = currentCount - 1;
                }
            }
        }

        function confirmDelete() {
            return confirm("Are you sure you want to delete this message?");
        }

        function toggleSearch() {
            var searchBox = document.getElementById("searchBox");
            if (searchBox) {
                searchBox.classList.toggle("active");
                searchBox.focus();
            }
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="contact-msg-page">
        <div class="messages-container">
            <div class="dashboard-header">
                <h1 class="messages-header">Contact Messages</h1>

                <div class="messages-stat">
                    <div class="stat-item">
                        <span class="stat-value"><asp:Literal ID="litTotalCount" runat="server">0</asp:Literal></span>
                        <span class="stat-label">Total</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-value" id="unreadCount"><asp:Literal ID="litUnreadCount" runat="server">0</asp:Literal></span>
                        <span class="stat-label">Unread</span>
                    </div>
                </div>
            </div>

            <div class="filters-section">
                <div class="filter-controls">
                    <span class="filter-label">Show:</span>
                    <asp:DropDownList ID="ddlFilterStatus" runat="server" AutoPostBack="true" CssClass="styled-dropdown"
                        OnSelectedIndexChanged="ddlFilterStatus_SelectedIndexChanged">
                        <asp:ListItem Text="All Messages" Value=""></asp:ListItem>
                        <asp:ListItem Text="Unread Messages" Value="0" Selected></asp:ListItem>
                        <asp:ListItem Text="Read Messages" Value="1"></asp:ListItem>
                    </asp:DropDownList>

                    <asp:DropDownList ID="ddlSortOrder" runat="server" AutoPostBack="true" CssClass="styled-dropdown"
                        OnSelectedIndexChanged="ddlSortOrder_SelectedIndexChanged">
                        <asp:ListItem Text="Newest First" Value="newest" Selected></asp:ListItem>
                        <asp:ListItem Text="Oldest First" Value="oldest"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="search-box">
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" placeholder="Search by name or email..."
                        AutoPostBack="true" OnTextChanged="txtSearch_TextChanged"></asp:TextBox>
                </div>
            </div>

            <asp:Panel ID="pnlNoMessages" runat="server" CssClass="empty-state" Visible="false">
                <p class="empty-state-text">No messages found. Check back later!</p>
            </asp:Panel>

            <div class="messages-grid">
                <asp:Repeater ID="rptMessages" runat="server" OnItemCommand="rptMessages_ItemCommand">
                    <ItemTemplate>
                        <div class='message-card <%# IIf(Eval("status"), "", "unread") %>'>
                            <div class="message-header">
                                <div class="message-info">
                                    <div class="message-name">
                                        <%# Eval("c_name") %>
                                    </div>
                                    <div class="message-email">
                                        <%# Eval("email") %>
                                    </div>
                                    <div class="message-date">
                                        <%# FormatDateTime(Eval("submitted_at"), DateFormat.ShortDate)%>
                                    </div>
                                </div>
                                <div class="message-status <%# IIf(Eval("status"), "", "unread") %>">
                                    <%# IIf(Eval("status"), "Read", "Unread") %>
                                </div>
                            </div>
                            <div class="message-content">
                                <%# Eval("message") %>
                            </div>
                            <div class="message-actions">
                                <asp:Button ID="btnMarkRead" runat="server" Text='<%# IIf(Eval("status"), "Read", "Mark as Read") %>'
                                    CssClass='<%# IIf(Eval("status"), "btn-mark-read read", "btn-mark-read unread") %>'
                                    CommandArgument='<%# Eval("message_id") %>' CommandName="MarkRead"
                                    Enabled='<%# Not(Eval("status")) %>' ClientIDMode="Static" />

                                <asp:Button ID="btnDelete" runat="server" Text="Delete" CssClass="btn-delete"
                                    CommandArgument='<%# Eval("message_id") %>' CommandName="DeleteMessage"
                                    OnClientClick="return confirmDelete();" />
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <asp:Panel ID="pnlPagination" runat="server" CssClass="pagination-container">
                <ul class="pagination">
                    <li class="page-item">
                        <asp:LinkButton ID="lnkPrevious" runat="server" CssClass="page-link page-nav-prev"
                            OnClick="lnkPrevious_Click"></asp:LinkButton>
                    </li>

                    <asp:Repeater ID="rptPagination" runat="server" OnItemCommand="rptPagination_ItemCommand">
                        <ItemTemplate>
                            <li class='page-item <%# IIf(Container.DataItem = ViewState("CurrentPage"), "active", "") %>'>
                                <asp:LinkButton ID="lnkPage" runat="server" CssClass="page-link"
                                    CommandArgument='<%# Container.DataItem %>' CommandName="ChangePage">
                                    <%# Container.DataItem %>
                                </asp:LinkButton>
                            </li>
                        </ItemTemplate>
                    </asp:Repeater>

                    <li class="page-item">
                        <asp:LinkButton ID="lnkNext" runat="server" CssClass="page-link page-nav-next"
                            OnClick="lnkNext_Click"></asp:LinkButton>
                    </li>
                </ul>
            </asp:Panel>
        </div>
    </div>
</asp:Content>
