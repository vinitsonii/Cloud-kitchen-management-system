Imports System.Data.SqlClient
Imports System.Data

Public Class WebForm12
    Inherits System.Web.UI.Page

    Private pageSize As Integer = 6  ' Number of messages per page
    Private currentPage As Integer = 1

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ViewState("CurrentPage") = 1
            ViewState("SortOrder") = "newest"
            ViewState("SearchTerm") = ""
            LoadMessages()
            UpdateMessageCounts()
        End If
    End Sub

    Protected Sub LoadMessages()
        Dim filterStatus As String = ddlFilterStatus.SelectedValue
        Dim sortOrder As String = ViewState("SortOrder").ToString()
        Dim searchTerm As String = ViewState("SearchTerm").ToString()
        Dim currentPage As Integer = Convert.ToInt32(ViewState("CurrentPage"))

        Dim whereClause As String = ""
        If filterStatus = "0" Then
            whereClause = " WHERE cm.status = 0"
        ElseIf filterStatus = "1" Then
            whereClause = " WHERE cm.status = 1"
        End If

        If Not String.IsNullOrEmpty(searchTerm) Then
            If String.IsNullOrEmpty(whereClause) Then
                whereClause = " WHERE (c.c_name LIKE @SearchTerm OR cm.email LIKE @SearchTerm)"
            Else
                whereClause &= " AND (c.c_name LIKE @SearchTerm OR cm.email LIKE @SearchTerm)"
            End If
        End If

        Dim orderByClause As String = " ORDER BY cm.submitted_at DESC"
        If sortOrder = "oldest" Then
            orderByClause = " ORDER BY cm.submitted_at ASC"
        End If

        ' Count total records for pagination
        Dim countQuery As String = "SELECT COUNT(*) FROM contact_messages cm LEFT JOIN Customers c ON cm.c_id = c.c_id" & whereClause

        ' Query to get paginated data
        Dim query As String = "SELECT cm.message_id, c.c_name, cm.email, cm.message, cm.status, cm.submitted_at FROM contact_messages cm " & _
                              "LEFT JOIN Customers c ON cm.c_id = c.c_id" & whereClause & orderByClause



        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("constr").ConnectionString)
            conn.Open()

            ' Get total record count
            Dim totalRecords As Integer = 0
            Using cmdCount As New SqlCommand(countQuery, conn)
                If Not String.IsNullOrEmpty(searchTerm) Then
                    cmdCount.Parameters.AddWithValue("@SearchTerm", "%" & searchTerm & "%")
                End If
                totalRecords = Convert.ToInt32(cmdCount.ExecuteScalar())
            End Using

            ' Get paginated data
            Using cmd As New SqlCommand(query, conn)
                If Not String.IsNullOrEmpty(searchTerm) Then
                    cmd.Parameters.AddWithValue("@SearchTerm", "%" & searchTerm & "%")
                End If

                If IsSqlServer2012OrHigher() Then
                    cmd.Parameters.AddWithValue("@Offset", (currentPage - 1) * pageSize)
                    cmd.Parameters.AddWithValue("@PageSize", pageSize)
                Else
                    cmd.Parameters.AddWithValue("@StartRow", ((currentPage - 1) * pageSize) + 1)
                    cmd.Parameters.AddWithValue("@EndRow", currentPage * pageSize)
                End If

                Dim dt As New DataTable()
                Using adapter As New SqlDataAdapter(cmd)
                    adapter.Fill(dt)
                End Using

                If dt.Rows.Count > 0 Then
                    rptMessages.DataSource = dt
                    rptMessages.DataBind()
                    pnlNoMessages.Visible = False
                Else
                    rptMessages.DataSource = Nothing
                    rptMessages.DataBind()
                    pnlNoMessages.Visible = True
                End If
            End Using

            ' Setup pagination
            SetupPagination(totalRecords)
        End Using
    End Sub

    Private Function IsSqlServer2012OrHigher() As Boolean
        ' In a real implementation, you might detect SQL Server version
        ' or use a configuration setting. For simplicity, we'll return true.
        Return True
    End Function

    Private Sub SetupPagination(ByVal totalRecords As Integer)
        Dim totalPages As Integer = Math.Ceiling(totalRecords / CDbl(pageSize))
        ViewState("TotalPages") = totalPages

        If totalPages <= 1 Then
            pnlPagination.Visible = False
            Return
        Else
            pnlPagination.Visible = True
        End If

        Dim currentPage As Integer = Convert.ToInt32(ViewState("CurrentPage"))

        ' Enable/disable previous/next buttons
        lnkPrevious.Enabled = (currentPage > 1)
        lnkNext.Enabled = (currentPage < totalPages)

        ' Create page numbers
        Dim pageNumbers As New List(Of Integer)

        ' Show up to 5 page numbers
        Dim startPage As Integer = Math.Max(1, currentPage - 2)
        Dim endPage As Integer = Math.Min(totalPages, startPage + 4)

        For i As Integer = startPage To endPage
            pageNumbers.Add(i)
        Next

        rptPagination.DataSource = pageNumbers
        rptPagination.DataBind()
    End Sub

    Protected Sub UpdateMessageCounts()
        Dim connStr As String = ConfigurationManager.ConnectionStrings("constr").ConnectionString
        Using conn As New SqlConnection(connStr)
            conn.Open()

            ' Get total count
            Dim totalCountQuery As String = "SELECT COUNT(*) FROM contact_messages"
            Using cmdTotal As New SqlCommand(totalCountQuery, conn)
                litTotalCount.Text = cmdTotal.ExecuteScalar().ToString()
            End Using

            ' Get unread count
            Dim unreadCountQuery As String = "SELECT COUNT(*) FROM contact_messages WHERE status = 0"
            Using cmdUnread As New SqlCommand(unreadCountQuery, conn)
                litUnreadCount.Text = cmdUnread.ExecuteScalar().ToString()
            End Using
        End Using
    End Sub

    Protected Sub rptMessages_ItemCommand(ByVal source As Object, ByVal e As RepeaterCommandEventArgs)
        Dim messageId As Integer = Convert.ToInt32(e.CommandArgument)

        If e.CommandName = "MarkRead" Then
            MarkMessageAsRead(messageId)
        ElseIf e.CommandName = "DeleteMessage" Then
            DeleteMessage(messageId)
        End If
    End Sub

    Protected Sub MarkMessageAsRead(ByVal messageId As Integer)
        Dim connStr As String = ConfigurationManager.ConnectionStrings("constr").ConnectionString
        Using conn As New SqlConnection(connStr)
            conn.Open()
            Dim query As String = "UPDATE contact_messages SET status = 1 WHERE message_id = @MessageId"
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@MessageId", messageId)
                cmd.ExecuteNonQuery()
            End Using
            LoadMessages()
        End Using

        ' Use client-side callback to update UI without full page refresh
        Dim buttonId As String = "btnMarkRead_" & messageId
        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "MarkReadSuccess",
            "markAsReadSuccess('" & buttonId & "');", True)

        ' Update message counts
        UpdateMessageCounts()
    End Sub

    Protected Sub DeleteMessage(ByVal messageId As Integer)
        Dim connStr As String = ConfigurationManager.ConnectionStrings("constr").ConnectionString
        Using conn As New SqlConnection(connStr)
            conn.Open()
            Dim query As String = "DELETE FROM contact_messages WHERE message_id = @MessageId"
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@MessageId", messageId)
                cmd.ExecuteNonQuery()
            End Using
        End Using

        LoadMessages()
        UpdateMessageCounts()
    End Sub

    Protected Sub ddlFilterStatus_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
        ViewState("CurrentPage") = 1
        LoadMessages()
    End Sub

    Protected Sub ddlSortOrder_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
        ViewState("CurrentPage") = 1
        ViewState("SortOrder") = ddlSortOrder.SelectedValue
        LoadMessages()
    End Sub

    Protected Sub txtSearch_TextChanged(ByVal sender As Object, ByVal e As EventArgs)
        ViewState("CurrentPage") = 1
        ViewState("SearchTerm") = txtSearch.Text.Trim()
        LoadMessages()
    End Sub

    Protected Sub lnkPrevious_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim currentPage As Integer = Convert.ToInt32(ViewState("CurrentPage"))
        If currentPage > 1 Then
            ViewState("CurrentPage") = currentPage - 1
            LoadMessages()
        End If
    End Sub

    Protected Sub lnkNext_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim currentPage As Integer = Convert.ToInt32(ViewState("CurrentPage"))
        Dim totalPages As Integer = Convert.ToInt32(ViewState("TotalPages"))
        If currentPage < totalPages Then
            ViewState("CurrentPage") = currentPage + 1
            LoadMessages()
        End If
    End Sub

    Protected Sub rptPagination_ItemCommand(ByVal source As Object, ByVal e As RepeaterCommandEventArgs)
        If e.CommandName = "ChangePage" Then
            ViewState("CurrentPage") = Convert.ToInt32(e.CommandArgument)
            LoadMessages()
        End If
    End Sub
End Class