Imports System.Data.SqlClient
Imports System.Data
Imports System.Net.Mail

Public Class WebForm11
    Inherits System.Web.UI.Page

    Private connString As String = ConfigurationManager.ConnectionStrings("constr").ConnectionString
    Private pageSize As Integer = 10
    Private currentPage As Integer = 1

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then

            'SendOrderEmail("vinitsoni5911@gmail.com", "Vinit", 11, "Cancelled")
            'SendOrderEmail("vinitsoni5911@gmail.com", "Vinit", 11, "Out for Delivery")


            If Request.QueryString("page") IsNot Nothing Then
                Integer.TryParse(Request.QueryString("page"), currentPage)
            End If

            ' Set default date range to last 30 days
            txtStartDate.Text = DateTime.Now.AddDays(-30).ToString("yyyy-MM-dd")
            txtEndDate.Text = DateTime.Now.ToString("yyyy-MM-dd")

            LoadDashboardSummary()
            LoadOrders()
        End If
    End Sub

    Private Sub LoadDashboardSummary()
        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT " &
                                  "(SELECT COUNT(*) FROM Orders WHERE order_status = 'Pending') AS PendingOrders, " &
                                  "(SELECT COUNT(*) FROM Orders WHERE order_status = 'Completed') AS CompletedOrders, " &
                                  "(SELECT COUNT(*) FROM Orders WHERE order_status = 'Cancelled') AS CancelledOrders, " &
                                  "(SELECT COUNT(*) FROM Orders) AS TotalOrders"

            Using cmd As New SqlCommand(query, conn)
                conn.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        litPendingOrders.Text = reader("PendingOrders").ToString()
                        litCompletedOrders.Text = reader("CompletedOrders").ToString()
                        litCancelledOrders.Text = reader("CancelledOrders").ToString()
                        litTotalOrders.Text = reader("TotalOrders").ToString()
                    End If
                End Using
                conn.Close()
            End Using
        End Using
    End Sub

    Private Sub LoadOrders()
        Dim statusFilter As String = ddlFilterStatus.SelectedValue
        Dim searchQuery As String = txtSearch.Text.Trim()
        Dim startDate As DateTime = DateTime.Now.AddDays(-30)
        Dim endDate As DateTime = DateTime.Now

        If Not String.IsNullOrEmpty(txtStartDate.Text) Then
            DateTime.TryParse(txtStartDate.Text, startDate)
        End If

        If Not String.IsNullOrEmpty(txtEndDate.Text) Then
            DateTime.TryParse(txtEndDate.Text, endDate)
            ' Set end date to end of day
            endDate = endDate.AddHours(23).AddMinutes(59).AddSeconds(59)
        End If

        ' Get total record count for pagination
        Dim totalRecords As Integer = GetTotalRecordCount(statusFilter, searchQuery, startDate, endDate)

        ' Calculate pagination values
        Dim totalPages As Integer = Math.Ceiling(totalRecords / pageSize)
        If currentPage > totalPages And totalPages > 0 Then
            currentPage = totalPages
        ElseIf currentPage < 1 Then
            currentPage = 1
        End If

        ' Setup pagination controls
        SetupPagination(totalPages, currentPage)

        Using conn As New SqlConnection(connString)
            Dim query As String = "WITH OrderedOrders AS (" &
                      " SELECT O.order_id, O.order_date, O.total_amount, O.payment_type, O.order_status, " &
                      " C.C_Name AS customer_name, C.Phone AS phone, O.address, O.pincode, " &
                      " ROW_NUMBER() OVER (ORDER BY O.order_date DESC) AS RowNum " &
                      " FROM Orders O " &
                      " INNER JOIN Customers C ON O.c_id = C.C_Id " &
                      " WHERE (O.order_status = @Status OR @Status = '') " &
                      " AND (O.order_id LIKE '%' + @Search + '%' OR C.C_Name LIKE '%' + @Search + '%' OR C.Phone LIKE '%' + @Search + '%') " &
                      " AND (O.order_date BETWEEN @StartDate AND @EndDate) " &
                      ") " &
                      "SELECT * FROM OrderedOrders " &
                      "WHERE RowNum BETWEEN @Offset AND (@Offset + @PageSize - 1)"


            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@Status", statusFilter)
                cmd.Parameters.AddWithValue("@Search", searchQuery)
                cmd.Parameters.AddWithValue("@StartDate", startDate)
                cmd.Parameters.AddWithValue("@EndDate", endDate)
                cmd.Parameters.AddWithValue("@Offset", ((currentPage - 1) * pageSize) + 1)
                cmd.Parameters.AddWithValue("@PageSize", pageSize)


                Dim dt As New DataTable()
                Dim adapter As New SqlDataAdapter(cmd)
                adapter.Fill(dt)

                dt.Columns.Add("OrderItems", GetType(DataTable))
                For Each row As DataRow In dt.Rows
                    Dim orderId As Integer = Convert.ToInt32(row("order_id"))
                    row("OrderItems") = GetOrderItems(orderId)
                Next

                If dt.Rows.Count > 0 Then
                    rptOrders.DataSource = dt
                    rptOrders.DataBind()
                    pnlNoOrders.Visible = False
                Else
                    rptOrders.DataSource = Nothing
                    rptOrders.DataBind()
                    pnlNoOrders.Visible = True
                End If
            End Using
        End Using
    End Sub

    Private Function GetTotalRecordCount(ByVal statusFilter As String, ByVal searchQuery As String, ByVal startDate As DateTime, ByVal endDate As DateTime) As Integer
        Dim count As Integer = 0

        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT COUNT(*) FROM Orders O " &
                                  " INNER JOIN Customers C ON O.c_id = C.C_Id " &
                                  " WHERE (O.order_status = @Status OR @Status = '') " &
                                  " AND (O.order_id LIKE '%' + @Search + '%' OR C.C_Name LIKE '%' + @Search + '%' OR C.Phone LIKE '%' + @Search + '%') " &
                                  " AND (O.order_date BETWEEN @StartDate AND @EndDate) "

            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@Status", statusFilter)
                cmd.Parameters.AddWithValue("@Search", searchQuery)
                cmd.Parameters.AddWithValue("@StartDate", startDate)
                cmd.Parameters.AddWithValue("@EndDate", endDate)

                conn.Open()
                count = Convert.ToInt32(cmd.ExecuteScalar())
                conn.Close()
            End Using
        End Using

        Return count
    End Function

    Private Sub SetupPagination(ByVal totalPages As Integer, ByVal currentPage As Integer)
        lnkFirst.Visible = (currentPage > 1)
        lnkPrevious.Visible = (currentPage > 1)
        lnkNext.Visible = (currentPage < totalPages)
        lnkLast.Visible = (currentPage < totalPages)

        ' Create page links
        Dim pages As New List(Of Object)()
        Dim startPage As Integer = Math.Max(1, currentPage - 2)
        Dim endPage As Integer = Math.Min(totalPages, startPage + 4)

        For i As Integer = startPage To endPage
            pages.Add(New With {
                .PageNumber = i,
                .IsActive = (i = currentPage)
            })
        Next

        rptPagination.DataSource = pages
        rptPagination.DataBind()
    End Sub

    Private Function GetOrderItems(ByVal orderId As Integer) As DataTable
        Dim dtItems As New DataTable()

        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT M.M_Name AS item_name, OI.quantity, OI.price FROM Order_Details OI INNER JOIN Menu_Item M ON OI.m_id = M.M_Id WHERE OI.order_id = @OrderId"

            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@OrderId", orderId)

                Dim adapter As New SqlDataAdapter(cmd)
                adapter.Fill(dtItems)
            End Using
        End Using

        Return dtItems
    End Function

    Protected Sub btnUpdate_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim btn As Button = CType(sender, Button)
        Dim orderId As Integer = Convert.ToInt32(btn.CommandArgument)
        Dim email As String = ""
        Dim customerName As String = ""

        Using conn As New SqlConnection(connString)
            ' First, get customer email and name
            Dim queryCustomer As String = "SELECT C.Email, C.C_Name FROM Orders O INNER JOIN Customers C ON O.c_id = C.C_Id WHERE O.order_id = @OrderId"
            Using cmdCustomer As New SqlCommand(queryCustomer, conn)
                cmdCustomer.Parameters.AddWithValue("@OrderId", orderId)
                conn.Open()
                Using reader As SqlDataReader = cmdCustomer.ExecuteReader()
                    If reader.Read() Then
                        email = reader("Email").ToString()
                        customerName = reader("C_Name").ToString()
                    End If
                End Using
                conn.Close()
            End Using

            ' Then update order status
            Dim query As String = "UPDATE Orders SET order_status = 'Completed' WHERE order_id = @OrderId"
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@OrderId", orderId)
                conn.Open()
                cmd.ExecuteNonQuery()
                conn.Close()
            End Using
        End Using

        ' Send notification email to customer
        If Not String.IsNullOrEmpty(email) Then
            Try
                SendOrderEmail(email, customerName, orderId, "Out for Delivery")
            Catch ex As Exception
                ' Log error but continue processing
                System.Diagnostics.Debug.WriteLine("Email sending failed: " & ex.Message)
            End Try
        End If

        ' Reload the page data
        LoadDashboardSummary()
        LoadOrders()
    End Sub

    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim btn As Button = CType(sender, Button)
        Dim orderId As Integer = Convert.ToInt32(btn.CommandArgument)
        Dim email As String = ""
        Dim customerName As String = ""

        Using conn As New SqlConnection(connString)
            ' First, get customer email and name
            Dim queryCustomer As String = "SELECT C.Email, C.C_Name FROM Orders O INNER JOIN Customers C ON O.c_id = C.C_Id WHERE O.order_id = @OrderId"
            Using cmdCustomer As New SqlCommand(queryCustomer, conn)
                cmdCustomer.Parameters.AddWithValue("@OrderId", orderId)
                conn.Open()
                Using reader As SqlDataReader = cmdCustomer.ExecuteReader()
                    If reader.Read() Then
                        email = reader("Email").ToString()
                        customerName = reader("C_Name").ToString()
                    End If
                End Using
                conn.Close()
            End Using

            ' Then update order status
            Dim query As String = "UPDATE Orders SET order_status = 'Cancelled' WHERE order_id = @OrderId"
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@OrderId", orderId)
                conn.Open()
                cmd.ExecuteNonQuery()
                conn.Close()
            End Using
        End Using

        ' Send notification email to customer
        If Not String.IsNullOrEmpty(email) Then
            Try
                SendOrderEmail(email, customerName, orderId, "Cancelled")
            Catch ex As Exception
                ' Log error but continue processing
                System.Diagnostics.Debug.WriteLine("Email sending failed: " & ex.Message)
            End Try
        End If

        ' Reload the page data
        LoadDashboardSummary()
        LoadOrders()
    End Sub

    Private Sub SendOrderEmail(ByVal userEmail As String, ByVal userName As String, ByVal orderId As Integer, ByVal status As String)
        Try
            Dim smtpServer As String = ConfigurationManager.AppSettings("SMTPServer")
            Dim smtpPort As Integer = Convert.ToInt32(ConfigurationManager.AppSettings("SMTPPort"))
            Dim emailUsername As String = ConfigurationManager.AppSettings("EmailUsername")
            Dim emailPassword As String = ConfigurationManager.AppSettings("EmailPassword")

            Dim orderItems As DataTable = GetOrderItems(orderId)
            Dim itemsHtml As String = "<table border='1' width='100%' cellpadding='8' cellspacing='0' style='border-collapse: collapse;'>"
            itemsHtml &= "<tr style='background-color: #4A90E2; color: white; text-align: left;'><th>Item</th><th>Quantity</th><th>Price</th><th>Total</th></tr>"

            Dim totalAmount As Decimal = 0

            For Each row As DataRow In orderItems.Rows
                Dim itemName As String = row("item_name").ToString()
                Dim quantity As Integer = Convert.ToInt32(row("quantity"))
                Dim price As Decimal = Convert.ToDecimal(row("price"))
                totalAmount += price * quantity

                itemsHtml &= "<tr><td>" & itemName & "</td><td>" & quantity & "</td><td>₹" & price & "</td><td>₹" & price * quantity & "</td></tr>"
            Next
            itemsHtml &= "<tr style='font-weight: bold;'><td colspan='3' align='right'>Total:</td><td>₹" & totalAmount & "</td></tr>"
            itemsHtml &= "</table>"

            Dim emailSubject As String = ""
            Dim emailBody As String = ""

            If status = "Out for Delivery" Then
                emailSubject = "Your Order #" & orderId & " is Out for Delivery! 🚚"
                emailBody &= "<div class='header'>Your Order is on the way! 🚚</div>"
                emailBody &= "<div class='content'>"
                emailBody &= "<p>Dear <b>" & userName & "</b>,</p>"
                emailBody &= "<p>Your order (#" & orderId & ") is now out for delivery. It will arrive soon! 🚀</p>"
                emailBody &= "</div>"
            ElseIf status = "Cancelled" Then
                emailSubject = "Your Order #" & orderId & " has been Cancelled ❌"
                emailBody &= "<div class='header'>Order Cancelled ❌</div>"
                emailBody &= "<div class='content'>"
                emailBody &= "<p>Dear <b>" & userName & "</b>,</p>"
                emailBody &= "<p>We regret to inform you that your order (#" & orderId & ") has been cancelled.</p>"
                emailBody &= "<p>If you have any questions, feel free to contact our support team.</p>"
                emailBody &= "</div>"
            End If

            emailBody = "<html><head><style>" &
                        "body { font-family: Arial, sans-serif; background-color: #f4f4f4; padding: 20px; }" &
                        ".email-container { background-color: #ffffff; padding: 20px; border-radius: 5px; }" &
                        ".header { font-size: 22px; font-weight: bold; color: #4A90E2; }" &
                        ".content { font-size: 16px; color: #333; margin-top: 10px; }" &
                        ".footer { font-size: 14px; color: #888; margin-top: 20px; }" &
                        "</style></head><body>" &
                        "<div class='email-container'>" & emailBody &
                        "<div class='order-details'>" & itemsHtml & "</div>" &
                        "<div class='footer'>Thank you for choosing Cloud Kitchen! 😊</div>" &
                        "</div></body></html>"


            Dim mail As New MailMessage()
            mail.From = New MailAddress(emailUsername, "Cloud Kitchen")
            mail.To.Add(userEmail)
            mail.Subject = emailSubject
            mail.Body = emailBody
            mail.IsBodyHtml = True


            Dim smtp As New SmtpClient(smtpServer, smtpPort)
            smtp.Credentials = New Net.NetworkCredential(emailUsername, emailPassword)
            smtp.EnableSsl = True


            smtp.Send(mail)
        Catch ex As Exception
            Console.WriteLine("Error sending email: " & ex.Message)
        End Try
    End Sub
    Protected Sub btnFilter_Click(ByVal sender As Object, ByVal e As EventArgs)
        currentPage = 1
        LoadOrders()
    End Sub

    Protected Sub ddlFilterStatus_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
        currentPage = 1
        LoadOrders()
    End Sub

    Protected Sub lnkFirst_Click(ByVal sender As Object, ByVal e As EventArgs)
        currentPage = 1
        LoadOrders()
    End Sub

    Protected Sub lnkPrevious_Click(ByVal sender As Object, ByVal e As EventArgs)
        If currentPage > 1 Then
            currentPage -= 1
            LoadOrders()
        End If
    End Sub

    Protected Sub lnkNext_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim statusFilter As String = ddlFilterStatus.SelectedValue
        Dim searchQuery As String = txtSearch.Text.Trim()
        Dim startDate As DateTime = DateTime.Now.AddDays(-30)
        Dim endDate As DateTime = DateTime.Now

        If Not String.IsNullOrEmpty(txtStartDate.Text) Then
            DateTime.TryParse(txtStartDate.Text, startDate)
        End If

        If Not String.IsNullOrEmpty(txtEndDate.Text) Then
            DateTime.TryParse(txtEndDate.Text, endDate)
            endDate = endDate.AddHours(23).AddMinutes(59).AddSeconds(59)
        End If

        Dim totalRecords As Integer = GetTotalRecordCount(statusFilter, searchQuery, startDate, endDate)
        Dim totalPages As Integer = Math.Ceiling(totalRecords / pageSize)

        If currentPage < totalPages Then
            currentPage += 1
            LoadOrders()
        End If
    End Sub

    Protected Sub lnkLast_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim statusFilter As String = ddlFilterStatus.SelectedValue
        Dim searchQuery As String = txtSearch.Text.Trim()
        Dim startDate As DateTime = DateTime.Now.AddDays(-30)
        Dim endDate As DateTime = DateTime.Now

        If Not String.IsNullOrEmpty(txtStartDate.Text) Then
            DateTime.TryParse(txtStartDate.Text, startDate)
        End If

        If Not String.IsNullOrEmpty(txtEndDate.Text) Then
            DateTime.TryParse(txtEndDate.Text, endDate)
            endDate = endDate.AddHours(23).AddMinutes(59).AddSeconds(59)
        End If

        Dim totalRecords As Integer = GetTotalRecordCount(statusFilter, searchQuery, startDate, endDate)
        Dim totalPages As Integer = Math.Ceiling(totalRecords / pageSize)

        currentPage = totalPages
        LoadOrders()
    End Sub

    Protected Sub rptPagination_ItemCommand(ByVal source As Object, ByVal e As RepeaterCommandEventArgs)
        If e.CommandName = "Page" Then
            currentPage = Convert.ToInt32(e.CommandArgument)
            LoadOrders()
        End If
    End Sub

    Protected Function GetPaymentIcon(ByVal paymentType As String) As String
        Select Case paymentType.ToLower()
            Case "card payment"
                Return "../icons/c2.png"
            Case "debit card"
                Return "../icons/debit-card.png"
            Case "cash on delivery", "cod"
                Return "../icons/cod.png"
            Case "wallet"
                Return "../icons/wallet.png"
            Case "upi"
                Return "../icons/upi.png"
            Case Else
                Return "../icons/c2.png"
        End Select
    End Function

End Class