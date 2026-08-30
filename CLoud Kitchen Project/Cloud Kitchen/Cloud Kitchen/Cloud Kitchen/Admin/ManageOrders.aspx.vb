Imports System.Data.SqlClient
Imports System.Data
Imports System.Net.Mail

Public Class WebForm11
    Inherits System.Web.UI.Page

    Private connString As String = ConfigurationManager.ConnectionStrings("constr").ConnectionString
    Private pageSize As Integer = 15
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

    Private Property SelectedOrderId As Integer
        Get
            If ViewState("SelectedOrderId") IsNot Nothing Then
                Return Convert.ToInt32(ViewState("SelectedOrderId"))
            End If
            Return 0
        End Get
        Set(ByVal value As Integer)
            ViewState("SelectedOrderId") = value
        End Set
    End Property

    Private Sub LoadOrders()
        SyncDriverStatuses()

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
        If currentPage > totalPages And totalPages > 0 Then
            currentPage = totalPages
        ElseIf currentPage < 1 Then
            currentPage = 1
        End If

        SetupPagination(totalPages, currentPage)

        Using conn As New SqlConnection(connString)
            Dim query As String = "WITH OrderedOrders AS (" &
                      " SELECT O.order_id, O.order_date, O.total_amount, O.payment_type, O.order_status, O.driver_id, O.delivery_otp, " &
                      " C.C_Name AS customer_name, C.Phone AS phone, O.address, O.pincode, " &
                      " D.driver_name, D.phone AS driver_phone, " &
                      " ROW_NUMBER() OVER (ORDER BY CASE WHEN O.order_status = 'Pending' THEN 1 ELSE 2 END ASC, CASE WHEN O.order_status = 'Pending' THEN O.order_date END ASC, O.order_date DESC) AS RowNum " &
                      " FROM Orders O " &
                      " INNER JOIN Customers C ON O.c_id = C.C_Id " &
                      " LEFT JOIN Drivers D ON O.driver_id = D.driver_id " &
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

                If dt.Rows.Count > 0 Then
                    Dim found As Boolean = False
                    For Each row As DataRow In dt.Rows
                        If Convert.ToInt32(row("order_id")) = SelectedOrderId Then
                            found = True
                            Exit For
                        End If
                    Next
                    If Not found Then
                        SelectedOrderId = Convert.ToInt32(dt.Rows(0)("order_id"))
                    End If

                    dt.Columns.Add("IsSelected", GetType(Boolean))
                    For Each row As DataRow In dt.Rows
                        row("IsSelected") = (Convert.ToInt32(row("order_id")) = SelectedOrderId)
                    Next

                    rptMasterOrders.DataSource = dt
                    rptMasterOrders.DataBind()

                    rptOrders.DataSource = dt
                    rptOrders.DataBind()

                    pnlNoOrders.Visible = False
                    pnlDetailView.Visible = True
                    pnlNoSelectedOrder.Visible = False

                    RenderOrderDetail(SelectedOrderId)
                Else
                    rptMasterOrders.DataSource = Nothing
                    rptMasterOrders.DataBind()

                    rptOrders.DataSource = Nothing
                    rptOrders.DataBind()

                    pnlNoOrders.Visible = True
                    pnlDetailView.Visible = False
                    pnlNoSelectedOrder.Visible = True
                End If

                BindKanbanSwimlanes(dt)
            End Using
        End Using
    End Sub

    Private Sub RenderOrderDetail(ByVal orderId As Integer)
        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT O.order_id, O.order_date, O.total_amount, O.payment_type, O.order_status, O.delivery_otp, O.delivered_time, O.address, O.pincode, O.transaction_number, " &
                                  "C.C_Name AS customer_name, C.Phone AS phone, " &
                                  "D.driver_name, D.phone AS driver_phone, D.vehicle_no " &
                                  "FROM Orders O " &
                                  "INNER JOIN Customers C ON O.c_id = C.C_Id " &
                                  "LEFT JOIN Drivers D ON O.driver_id = D.driver_id " &
                                  "WHERE O.order_id = @OrderId"

            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@OrderId", orderId)
                conn.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        litDetailOrderId.Text = orderId.ToString()
                        If Not IsDBNull(reader("order_date")) Then
                            litDetailOrderDate.Text = Convert.ToDateTime(reader("order_date")).ToString("dd-MMM-yyyy hh:mm tt")
                        Else
                            litDetailOrderDate.Text = "N/A"
                        End If

                        Dim custName As String = If(IsDBNull(reader("customer_name")), "Customer", reader("customer_name").ToString())
                        litDetailCustName.Text = custName
                        If custName.Length > 0 Then
                            litDetailCustAvatar.Text = custName.Substring(0, 1).ToUpper()
                        Else
                            litDetailCustAvatar.Text = "U"
                        End If

                        Dim custPhone As String = If(IsDBNull(reader("phone")), "", reader("phone").ToString())
                        litDetailCustPhone.Text = custPhone
                        If lnkCallCust IsNot Nothing Then
                            lnkCallCust.NavigateUrl = "tel:" & custPhone
                            lnkCallCust.Text = "<i class='fas fa-phone-alt'></i> " & custPhone
                        End If

                        Dim addr As String = If(IsDBNull(reader("address")), "", reader("address").ToString())
                        Dim pin As String = If(IsDBNull(reader("pincode")), "", reader("pincode").ToString())
                        litDetailAddress.Text = addr & If(pin.Length > 0, ", " & pin, "")
                        litDetailPayment.Text = If(IsDBNull(reader("payment_type")), "Cash on Delivery", reader("payment_type").ToString())

                        Dim status As String = If(IsDBNull(reader("order_status")), "Pending", reader("order_status").ToString())
                        FormatDetailStatusBadge(status)

                        Dim dtItems As DataTable = GetOrderItems(orderId)
                        rptDetailItems.DataSource = dtItems
                        rptDetailItems.DataBind()

                        Dim subtotal As Decimal = 0
                        If dtItems IsNot Nothing Then
                            For Each itemRow As DataRow In dtItems.Rows
                                Dim price As Decimal = Convert.ToDecimal(itemRow("price"))
                                Dim qty As Integer = Convert.ToInt32(itemRow("quantity"))
                                subtotal += (price * qty)
                            Next
                        End If
                        Dim tax As Decimal = subtotal * 0.05
                        Dim grandTotal As Decimal = subtotal + tax

                        litDetailSubtotal.Text = "₹" & subtotal.ToString("N2")
                        litDetailTax.Text = "₹" & tax.ToString("N2")
                        litDetailGrandTotal.Text = "₹" & grandTotal.ToString("N2")

                        If pnlAcceptAction IsNot Nothing Then pnlAcceptAction.Visible = False
                        If pnlDispatchAction IsNot Nothing Then pnlDispatchAction.Visible = False
                        If pnlDispatchedDriverBadge IsNot Nothing Then pnlDispatchedDriverBadge.Visible = False
                        If pnlCompletedAction IsNot Nothing Then pnlCompletedAction.Visible = False
                        If btnDetailCancel IsNot Nothing Then btnDetailCancel.Visible = False

                        If status.Equals("Pending", StringComparison.OrdinalIgnoreCase) Then
                            If pnlAcceptAction IsNot Nothing Then pnlAcceptAction.Visible = True
                            If btnDetailCancel IsNot Nothing Then btnDetailCancel.Visible = True
                            If btnDetailAccept IsNot Nothing Then btnDetailAccept.CommandArgument = orderId.ToString()
                            If btnDetailCancel IsNot Nothing Then btnDetailCancel.CommandArgument = orderId.ToString()
                        ElseIf status.Equals("Preparing", StringComparison.OrdinalIgnoreCase) Then
                            If pnlDispatchAction IsNot Nothing Then pnlDispatchAction.Visible = True
                            If btnDetailCancel IsNot Nothing Then btnDetailCancel.Visible = True
                            If btnDetailDispatch IsNot Nothing Then btnDetailDispatch.CommandArgument = orderId.ToString()
                            If btnDetailCancel IsNot Nothing Then btnDetailCancel.CommandArgument = orderId.ToString()
                            If ddlDetailDriver IsNot Nothing Then PopulateDriverDropdown(ddlDetailDriver)
                        ElseIf status.Equals("Out for Delivery", StringComparison.OrdinalIgnoreCase) Then
                            If pnlDispatchedDriverBadge IsNot Nothing Then pnlDispatchedDriverBadge.Visible = True
                            Dim driverName As String = If(IsDBNull(reader("driver_name")), "Assigned Driver", reader("driver_name").ToString())
                            Dim driverPhone As String = If(IsDBNull(reader("driver_phone")), "", reader("driver_phone").ToString())
                            Dim driverVehicle As String = If(IsDBNull(reader("vehicle_no")), "N/A", reader("vehicle_no").ToString())
                            Dim otp As String = If(IsDBNull(reader("delivery_otp")), "----", reader("delivery_otp").ToString())

                            If litDetailDriverName IsNot Nothing Then litDetailDriverName.Text = driverName
                            If litDetailDriverPhone IsNot Nothing Then litDetailDriverPhone.Text = driverPhone
                            If litDetailDriverVehicle IsNot Nothing Then litDetailDriverVehicle.Text = driverVehicle
                            If litDetailOtp IsNot Nothing Then litDetailOtp.Text = otp

                            If lnkCallDriver IsNot Nothing Then
                                lnkCallDriver.NavigateUrl = "tel:" & driverPhone
                                lnkCallDriver.Text = "<i class='fas fa-phone-alt'></i> Call Driver"
                            End If

                            If btnDetailComplete IsNot Nothing Then btnDetailComplete.CommandArgument = orderId.ToString()
                        ElseIf status.Equals("Completed", StringComparison.OrdinalIgnoreCase) Then
                            If pnlCompletedAction IsNot Nothing Then pnlCompletedAction.Visible = True
                            If litDetailDeliveredTime IsNot Nothing Then
                                If Not IsDBNull(reader("delivered_time")) Then
                                    litDetailDeliveredTime.Text = Convert.ToDateTime(reader("delivered_time")).ToString("dd-MMM-yyyy hh:mm tt")
                                Else
                                    litDetailDeliveredTime.Text = "Completed"
                                End If
                            End If
                        End If

                        If btnDetailPrint IsNot Nothing Then
                            btnDetailPrint.CommandArgument = orderId.ToString()
                            btnDetailPrint.OnClientClick = "printInvoice('" & orderId & "', '" & custName.Replace("'", "\'") & "', '" & grandTotal.ToString("F2") & "'); return false;"
                        End If
                    End If
                End Using
                conn.Close()
            End Using
        End Using
    End Sub

    Private Sub FormatDetailStatusBadge(ByVal status As String)
        Select Case status.ToLower()
            Case "pending"
                litDetailStatusBadge.Text = "<span class='status-pill pill-pending'><i class='fas fa-clock'></i> Pending</span>"
            Case "preparing"
                litDetailStatusBadge.Text = "<span class='status-pill pill-preparing'><i class='fas fa-fire-burner'></i> Preparing</span>"
            Case "out for delivery"
                litDetailStatusBadge.Text = "<span class='status-pill pill-dispatched'><i class='fas fa-motorcycle'></i> Out for Delivery</span>"
            Case "completed"
                litDetailStatusBadge.Text = "<span class='status-pill pill-completed'><i class='fas fa-circle-check'></i> Delivered</span>"
            Case "cancelled"
                litDetailStatusBadge.Text = "<span class='status-pill pill-cancelled'><i class='fas fa-times-circle'></i> Cancelled</span>"
            Case Else
                litDetailStatusBadge.Text = "<span class='status-pill pill-pending'>" & status & "</span>"
        End Select
    End Sub

    Protected Function FormatMasterStatusPill(ByVal status As String) As String
        Select Case status.ToLower()
            Case "pending"
                Return "<span class='status-pill pill-pending'><i class='fas fa-clock'></i> Pending</span>"
            Case "preparing"
                Return "<span class='status-pill pill-preparing'><i class='fas fa-fire-burner'></i> Preparing</span>"
            Case "out for delivery"
                Return "<span class='status-pill pill-dispatched'><i class='fas fa-motorcycle'></i> Dispatched</span>"
            Case "completed"
                Return "<span class='status-pill pill-completed'><i class='fas fa-circle-check'></i> Delivered</span>"
            Case "cancelled"
                Return "<span class='status-pill pill-cancelled'><i class='fas fa-times-circle'></i> Cancelled</span>"
            Case Else
                Return "<span class='status-pill pill-pending'>" & status & "</span>"
        End Select
    End Function

    Protected Function GetFifoWaitBadge(ByVal orderDateObj As Object, ByVal status As String) As String
        If status.Equals("Pending", StringComparison.OrdinalIgnoreCase) AndAlso Not IsDBNull(orderDateObj) Then
            Dim orderDate As DateTime = Convert.ToDateTime(orderDateObj)
            Dim ts As TimeSpan = DateTime.Now.Subtract(orderDate)
            Dim mins As Integer = Convert.ToInt32(Math.Floor(ts.TotalMinutes))
            If mins < 1 Then
                Return "<span class='fifo-badge fifo-fresh'><i class='fas fa-stopwatch'></i> Just now</span>"
            ElseIf mins > 20 Then
                Return "<span class='fifo-badge fifo-urgent'><i class='fas fa-fire'></i> Waiting " & mins & "m (Urgent)</span>"
            Else
                Return "<span class='fifo-badge fifo-waiting'><i class='fas fa-stopwatch'></i> Waiting " & mins & "m</span>"
            End If
        End If
        Return ""
    End Function

    Protected Sub ddlQuickDate_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
        Dim range As String = ddlQuickDate.SelectedValue
        Select Case range.ToLower()
            Case "today"
                txtStartDate.Text = DateTime.Today.ToString("yyyy-MM-dd")
                txtEndDate.Text = DateTime.Today.ToString("yyyy-MM-dd")
            Case "yesterday"
                txtStartDate.Text = DateTime.Today.AddDays(-1).ToString("yyyy-MM-dd")
                txtEndDate.Text = DateTime.Today.AddDays(-1).ToString("yyyy-MM-dd")
            Case "7days"
                txtStartDate.Text = DateTime.Today.AddDays(-7).ToString("yyyy-MM-dd")
                txtEndDate.Text = DateTime.Today.ToString("yyyy-MM-dd")
            Case "30days"
                txtStartDate.Text = DateTime.Today.AddDays(-30).ToString("yyyy-MM-dd")
                txtEndDate.Text = DateTime.Today.ToString("yyyy-MM-dd")
        End Select
        currentPage = 1
        LoadOrders()
    End Sub

    Protected Sub rptMasterOrders_ItemCommand(ByVal source As Object, ByVal e As RepeaterCommandEventArgs)
        If e.CommandName = "SelectOrder" Then
            SelectedOrderId = Convert.ToInt32(e.CommandArgument)
            LoadOrders()
        End If
    End Sub

    Protected Sub btnDetailAccept_Click(ByVal sender As Object, ByVal e As EventArgs)
        If SelectedOrderId > 0 Then
            UpdateOrderStatus(SelectedOrderId, "Preparing")
            DeductInventoryForOrder(SelectedOrderId)
            SendOrderNotificationEmail(SelectedOrderId, "Preparing")
            LoadDashboardSummary()
            LoadOrders()
        End If
    End Sub

    Protected Sub btnDetailDispatch_Click(ByVal sender As Object, ByVal e As EventArgs)
        If SelectedOrderId > 0 AndAlso Not String.IsNullOrEmpty(ddlDetailDriver.SelectedValue) Then
            Dim driverId As Integer = Convert.ToInt32(ddlDetailDriver.SelectedValue)
            Dim randomOtp As String = New Random().Next(1000, 9999).ToString()

            Using conn As New SqlConnection(connString)
                conn.Open()
                Dim query As String = "UPDATE Orders SET order_status = 'Out for Delivery', driver_id = @DriverId, delivery_otp = @OTP WHERE order_id = @OrderId; " &
                                      "UPDATE Drivers SET status = 'On Delivery' WHERE driver_id = @DriverId;"
                Using cmd As New SqlCommand(query, conn)
                    cmd.Parameters.AddWithValue("@DriverId", driverId)
                    cmd.Parameters.AddWithValue("@OTP", randomOtp)
                    cmd.Parameters.AddWithValue("@OrderId", SelectedOrderId)
                    cmd.ExecuteNonQuery()
                End Using
                conn.Close()
            End Using

            SendOrderNotificationEmail(SelectedOrderId, "Out for Delivery")
            LoadDashboardSummary()
            LoadOrders()
        End If
    End Sub

    Protected Sub btnDetailComplete_Click(ByVal sender As Object, ByVal e As EventArgs)
        If SelectedOrderId > 0 Then
            CompleteOrderInternal(SelectedOrderId)
            LoadDashboardSummary()
            LoadOrders()
        End If
    End Sub

    Protected Sub btnDetailCancel_Click(ByVal sender As Object, ByVal e As EventArgs)
        If SelectedOrderId > 0 Then
            CancelOrderInternal(SelectedOrderId)
            LoadDashboardSummary()
            LoadOrders()
        End If
    End Sub

    Private Sub SyncDriverStatuses()
        Try
            Using conn As New SqlConnection(connString)
                conn.Open()
                Dim query As String = "UPDATE Drivers " &
                                      "SET status = CASE " &
                                      "    WHEN status = 'Offline' THEN 'Offline' " &
                                      "    WHEN status = 'Inactive' THEN 'Inactive' " &
                                      "    WHEN (SELECT COUNT(*) FROM Orders WHERE driver_id = Drivers.driver_id AND order_status = 'Out for Delivery') > 0 THEN 'On Delivery' " &
                                      "    ELSE 'Available' " &
                                      "END"
                Using cmd As New SqlCommand(query, conn)
                    cmd.ExecuteNonQuery()
                End Using
                conn.Close()
            End Using
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("SyncDriverStatuses error: " & ex.Message)
        End Try
    End Sub

    Private Sub BindKanbanSwimlanes(ByVal dtAll As DataTable)
        If dtAll Is Nothing OrElse dtAll.Rows.Count = 0 Then
            rptPending.DataSource = Nothing
            rptPending.DataBind()
            rptPreparing.DataSource = Nothing
            rptPreparing.DataBind()
            rptDispatched.DataSource = Nothing
            rptDispatched.DataBind()
            rptCompleted.DataSource = Nothing
            rptCompleted.DataBind()

            litPendingCount.Text = "0"
            litPreparingCount.Text = "0"
            litDispatchedCount.Text = "0"
            litCompletedCount.Text = "0"
            Exit Sub
        End If

        Dim dtPending As DataTable = dtAll.Clone()
        Dim dtPreparing As DataTable = dtAll.Clone()
        Dim dtDispatched As DataTable = dtAll.Clone()
        Dim dtCompleted As DataTable = dtAll.Clone()

        For Each row As DataRow In dtAll.Rows
            Dim st As String = row("order_status").ToString().Trim()
            If st.Equals("Pending", StringComparison.OrdinalIgnoreCase) Then
                dtPending.ImportRow(row)
            ElseIf st.Equals("Preparing", StringComparison.OrdinalIgnoreCase) Then
                dtPreparing.ImportRow(row)
            ElseIf st.Equals("Out for Delivery", StringComparison.OrdinalIgnoreCase) Then
                dtDispatched.ImportRow(row)
            ElseIf st.Equals("Completed", StringComparison.OrdinalIgnoreCase) OrElse st.Equals("Cancelled", StringComparison.OrdinalIgnoreCase) Then
                dtCompleted.ImportRow(row)
            End If
        Next

        rptPending.DataSource = dtPending
        rptPending.DataBind()
        litPendingCount.Text = dtPending.Rows.Count.ToString()

        rptPreparing.DataSource = dtPreparing
        rptPreparing.DataBind()
        litPreparingCount.Text = dtPreparing.Rows.Count.ToString()

        rptDispatched.DataSource = dtDispatched
        rptDispatched.DataBind()
        litDispatchedCount.Text = dtDispatched.Rows.Count.ToString()

        rptCompleted.DataSource = dtCompleted
        rptCompleted.DataBind()
        litCompletedCount.Text = dtCompleted.Rows.Count.ToString()
    End Sub

    Protected Sub rptSwimlane_ItemDataBound(ByVal sender As Object, ByVal e As RepeaterItemEventArgs) Handles rptPending.ItemDataBound, rptPreparing.ItemDataBound, rptDispatched.ItemDataBound, rptCompleted.ItemDataBound
        rptOrders_ItemDataBound(sender, e)
    End Sub

    Protected Sub rptSwimlane_ItemCommand(ByVal source As Object, ByVal e As RepeaterCommandEventArgs) Handles rptPending.ItemCommand, rptPreparing.ItemCommand, rptDispatched.ItemCommand, rptCompleted.ItemCommand
        rptOrders_ItemCommand(source, e)
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

    Protected Sub rptOrders_ItemDataBound(ByVal sender As Object, ByVal e As RepeaterItemEventArgs)
        If e.Item.ItemType = ListItemType.Item OrElse e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim rowView As DataRowView = CType(e.Item.DataItem, DataRowView)
            Dim status As String = rowView("order_status").ToString()

            If status = "Preparing" Then
                Dim ddlDriver As DropDownList = CType(e.Item.FindControl("ddlDriver"), DropDownList)
                If ddlDriver IsNot Nothing Then
                    PopulateDriverDropdown(ddlDriver)
                End If
            End If
        End If
    End Sub

    Private Sub PopulateDriverDropdown(ByVal ddl As DropDownList)
        ddl.Items.Clear()

        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT driver_id, driver_name + ' (' + vehicle_no + ')' AS DriverText " &
                                  "FROM Drivers D " &
                                  "WHERE D.status = 'Available' " &
                                  "  AND (SELECT COUNT(*) FROM Orders WHERE driver_id = D.driver_id AND order_status = 'Out for Delivery') = 0 " &
                                  "ORDER BY D.driver_name ASC"
            Using cmd As New SqlCommand(query, conn)
                conn.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        ddl.Items.Add(New ListItem(reader("DriverText").ToString(), reader("driver_id").ToString()))
                    End While
                End Using
                conn.Close()
            End Using
        End Using

        If ddl.Items.Count > 0 Then
            ddl.Items.Insert(0, New ListItem("-- Select Available Driver --", ""))
        Else
            ddl.Items.Insert(0, New ListItem("-- No Drivers Available (All On Duty) --", ""))
        End If
    End Sub

    Protected Sub rptOrders_ItemCommand(ByVal source As Object, ByVal e As RepeaterCommandEventArgs)
        Dim orderId As Integer = Convert.ToInt32(e.CommandArgument)

        If e.CommandName = "AcceptOrder" Then
            UpdateOrderStatus(orderId, "Preparing")
            DeductInventoryForOrder(orderId)
            SendOrderNotificationEmail(orderId, "Preparing")
        ElseIf e.CommandName = "DispatchOrder" Then
            Dim ddlDriver As DropDownList = CType(e.Item.FindControl("ddlDriver"), DropDownList)
            If ddlDriver IsNot Nothing AndAlso Not String.IsNullOrEmpty(ddlDriver.SelectedValue) Then
                Dim driverId As Integer = Convert.ToInt32(ddlDriver.SelectedValue)
                Dim randomOtp As String = New Random().Next(1000, 9999).ToString()

                Using conn As New SqlConnection(connString)
                    conn.Open()
                    Dim query As String = "UPDATE Orders SET order_status = 'Out for Delivery', driver_id = @DriverId, delivery_otp = @OTP WHERE order_id = @OrderId; " &
                                          "UPDATE Drivers SET status = 'On Delivery' WHERE driver_id = @DriverId;"
                    Using cmd As New SqlCommand(query, conn)
                        cmd.Parameters.AddWithValue("@DriverId", driverId)
                        cmd.Parameters.AddWithValue("@OTP", randomOtp)
                        cmd.Parameters.AddWithValue("@OrderId", orderId)
                        cmd.ExecuteNonQuery()
                    End Using
                    conn.Close()
                End Using

                SendOrderNotificationEmail(orderId, "Out for Delivery")
            End If
        ElseIf e.CommandName = "CompleteOrder" Then
            CompleteOrderInternal(orderId)
        ElseIf e.CommandName = "CancelOrder" Then
            CancelOrderInternal(orderId)
        End If

        LoadDashboardSummary()
        LoadOrders()
    End Sub

    Private Sub UpdateOrderStatus(ByVal orderId As Integer, ByVal status As String)
        Using conn As New SqlConnection(connString)
            Dim query As String = "UPDATE Orders SET order_status = @Status WHERE order_id = @OrderId"
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@Status", status)
                cmd.Parameters.AddWithValue("@OrderId", orderId)
                conn.Open()
                cmd.ExecuteNonQuery()
                conn.Close()
            End Using
        End Using
    End Sub

    Private Sub CompleteOrderInternal(ByVal orderId As Integer)
        Using conn As New SqlConnection(connString)
            conn.Open()
            Dim queryDriver As String = "UPDATE Drivers SET status = 'Available' WHERE driver_id = (SELECT driver_id FROM Orders WHERE order_id = @OrderId AND driver_id IS NOT NULL)"
            Using cmdDriver As New SqlCommand(queryDriver, conn)
                cmdDriver.Parameters.AddWithValue("@OrderId", orderId)
                cmdDriver.ExecuteNonQuery()
            End Using

            Dim queryOrder As String = "UPDATE Orders SET order_status = 'Completed', delivered_time = GETDATE() WHERE order_id = @OrderId"
            Using cmdOrder As New SqlCommand(queryOrder, conn)
                cmdOrder.Parameters.AddWithValue("@OrderId", orderId)
                cmdOrder.ExecuteNonQuery()
            End Using
            conn.Close()
        End Using

        DeductInventoryForOrder(orderId)
        SendOrderNotificationEmail(orderId, "Completed")
    End Sub

    Private Sub CancelOrderInternal(ByVal orderId As Integer)
        Using conn As New SqlConnection(connString)
            conn.Open()
            Dim queryDriver As String = "UPDATE Drivers SET status = 'Available' WHERE driver_id = (SELECT driver_id FROM Orders WHERE order_id = @OrderId AND driver_id IS NOT NULL)"
            Using cmdDriver As New SqlCommand(queryDriver, conn)
                cmdDriver.Parameters.AddWithValue("@OrderId", orderId)
                cmdDriver.ExecuteNonQuery()
            End Using

            Dim queryOrder As String = "UPDATE Orders SET order_status = 'Cancelled' WHERE order_id = @OrderId"
            Using cmdOrder As New SqlCommand(queryOrder, conn)
                cmdOrder.Parameters.AddWithValue("@OrderId", orderId)
                cmdOrder.ExecuteNonQuery()
            End Using
            conn.Close()
        End Using

        SendOrderNotificationEmail(orderId, "Cancelled")
    End Sub

    Protected Sub btnUpdate_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim btn As Button = CType(sender, Button)
        Dim orderId As Integer = Convert.ToInt32(btn.CommandArgument)
        CompleteOrderInternal(orderId)
        LoadDashboardSummary()
        LoadOrders()
    End Sub

    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim btn As Button = CType(sender, Button)
        Dim orderId As Integer = Convert.ToInt32(btn.CommandArgument)
        CancelOrderInternal(orderId)
        LoadDashboardSummary()
        LoadOrders()
    End Sub

    Private Sub SendOrderNotificationEmail(ByVal orderId As Integer, ByVal status As String)
        Try
            Dim userEmail As String = ""
            Dim userName As String = ""
            Dim driverName As String = ""
            Dim driverPhone As String = ""
            Dim vehicleNo As String = ""
            Dim deliveryOtp As String = ""
            Dim paymentType As String = ""
            Dim totalAmount As Decimal = 0

            Using conn As New SqlConnection(connString)
                Dim query As String = "SELECT O.total_amount, O.payment_type, O.delivery_otp, C.C_Name, C.Email, " &
                                      "D.driver_name, D.phone AS driver_phone, D.vehicle_no " &
                                      "FROM Orders O " &
                                      "INNER JOIN Customers C ON O.c_id = C.C_Id " &
                                      "LEFT JOIN Drivers D ON O.driver_id = D.driver_id " &
                                      "WHERE O.order_id = @OrderId"

                Using cmd As New SqlCommand(query, conn)
                    cmd.Parameters.AddWithValue("@OrderId", orderId)
                    conn.Open()
                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        If reader.Read() Then
                            userEmail = reader("Email").ToString()
                            userName = reader("C_Name").ToString()
                            paymentType = reader("payment_type").ToString()
                            If Not IsDBNull(reader("total_amount")) Then totalAmount = Convert.ToDecimal(reader("total_amount"))
                            If Not IsDBNull(reader("delivery_otp")) Then deliveryOtp = reader("delivery_otp").ToString()
                            If Not IsDBNull(reader("driver_name")) Then driverName = reader("driver_name").ToString()
                            If Not IsDBNull(reader("driver_phone")) Then driverPhone = reader("driver_phone").ToString()
                            If Not IsDBNull(reader("vehicle_no")) Then vehicleNo = reader("vehicle_no").ToString()
                        End If
                    End Using
                    conn.Close()
                End Using
            End Using

            If String.IsNullOrEmpty(userEmail) Then Exit Sub

            Dim smtpServer As String = ConfigurationManager.AppSettings("SMTPServer")
            Dim smtpPort As Integer = Convert.ToInt32(ConfigurationManager.AppSettings("SMTPPort"))
            Dim emailUsername As String = ConfigurationManager.AppSettings("EmailUsername")
            Dim emailPassword As String = ConfigurationManager.AppSettings("EmailPassword")

            Dim orderItems As DataTable = GetOrderItems(orderId)
            Dim itemsHtml As String = "<table border='1' width='100%' cellpadding='8' cellspacing='0' style='border-collapse: collapse; margin-top: 15px; border-color: #e2e8f0;'>"
            itemsHtml &= "<tr style='background-color: #2563eb; color: white; text-align: left;'><th>Item</th><th>Qty</th><th>Price</th><th>Total</th></tr>"

            For Each row As DataRow In orderItems.Rows
                Dim itemName As String = row("item_name").ToString()
                Dim quantity As Integer = Convert.ToInt32(row("quantity"))
                Dim price As Decimal = Convert.ToDecimal(row("price"))
                itemsHtml &= "<tr><td>" & itemName & "</td><td>" & quantity & "</td><td>₹" & price.ToString("N2") & "</td><td>₹" & (price * quantity).ToString("N2") & "</td></tr>"
            Next
            itemsHtml &= "<tr style='font-weight: bold; background-color: #f8fafc;'><td colspan='3' align='right'>Total Amount:</td><td>₹" & totalAmount.ToString("N2") & "</td></tr>"
            itemsHtml &= "</table>"

            Dim emailSubject As String = ""
            Dim emailBanner As String = ""
            Dim driverBlock As String = ""

            If status = "Preparing" Then
                emailSubject = "🧑‍🍳 Order #" & orderId & " is Being Cooked! - Cloud Kitchen"
                emailBanner = "<h2 style='color:#2563eb; margin:0 0 10px 0;'>🧑‍🍳 Your Order is Being Prepared!</h2><p>Dear <b>" & userName & "</b>, our chefs have accepted your order (#" & orderId & ") and are preparing your fresh meal now!</p>"
            ElseIf status = "Out for Delivery" Then
                emailSubject = "🛵 Order #" & orderId & " Dispatched! Driver & Delivery OTP Details"
                emailBanner = "<h2 style='color:#d97706; margin:0 0 10px 0;'>🛵 Your Order is Out for Delivery!</h2><p>Dear <b>" & userName & "</b>, great news! Your order (#" & orderId & ") is on its way to your doorstep.</p>"

                driverBlock = "<div style='background-color: #eff6ff; border: 1.5px solid #bfdbfe; border-radius: 10px; padding: 16px; margin: 16px 0;'>" &
                              "<h4 style='margin: 0 0 10px 0; color: #1e40af; font-size: 16px;'>🛵 Delivery Partner Information</h4>" &
                              "<p style='margin: 4px 0;'><b>Driver Name:</b> " & driverName & "</p>" &
                              "<p style='margin: 4px 0;'><b>Vehicle Number:</b> " & vehicleNo & "</p>" &
                              "<p style='margin: 4px 0;'><b>Phone:</b> <a href='tel:" & driverPhone & "' style='color: #2563eb; font-weight: bold; text-decoration: none;'>📞 " & driverPhone & "</a></p>" &
                              "<div style='background-color: #fef3c7; border: 1.5px solid #fde68a; color: #b45309; border-radius: 8px; padding: 12px; margin-top: 12px; text-align: center; font-weight: bold; font-size: 15px;'>" &
                              "🔑 Doorstep Delivery OTP: <span style='font-size: 22px; font-weight: 900; color: #d97706; background: #ffffff; padding: 2px 12px; border-radius: 6px; border: 1px solid #fcd34d; margin-left: 6px;'>" & deliveryOtp & "</span>" &
                              "<br/><span style='font-size: 12px; font-weight: normal; color: #92400e; display: block; margin-top: 4px;'>Please share this 4-digit OTP with your driver upon arrival.</span>" &
                              "</div></div>"
            ElseIf status = "Completed" Then
                emailSubject = "🎉 Order #" & orderId & " Delivered! Thank You - Cloud Kitchen"
                emailBanner = "<h2 style='color:#16a34a; margin:0 0 10px 0;'>🎉 Order Delivered Successfully!</h2><p>Dear <b>" & userName & "</b>, your order (#" & orderId & ") has been delivered. We hope you enjoy your meal!</p>"
            ElseIf status = "Cancelled" Then
                emailSubject = "❌ Order #" & orderId & " Cancelled - Cloud Kitchen"
                emailBanner = "<h2 style='color:#dc2626; margin:0 0 10px 0;'>❌ Order Cancelled</h2><p>Dear <b>" & userName & "</b>, your order (#" & orderId & ") has been cancelled. If you have any queries, please reach out to support.</p>"
            End If

            Dim emailBody As String = "<html><body style='font-family: Arial, sans-serif; background-color: #f8fafc; padding: 20px; color: #334155;'>" &
                                     "<div style='max-width: 600px; margin: 0 auto; background: #ffffff; border-radius: 12px; padding: 24px; box-shadow: 0 4px 16px rgba(0,0,0,0.06); border: 1px solid #e2e8f0;'>" &
                                     "<div style='text-align: center; border-bottom: 2px solid #e2e8f0; padding-bottom: 15px; margin-bottom: 20px;'>" &
                                     "<h1 style='color: #0f172a; margin: 0; font-size: 24px;'>🍳 Cloud Kitchen</h1>" &
                                     "<p style='color: #64748b; font-size: 13px; margin: 4px 0 0 0;'>Delicious Food Delivered Hot & Fresh</p>" &
                                     "</div>" &
                                     emailBanner &
                                     driverBlock &
                                     "<h4 style='margin: 20px 0 8px 0; color: #0f172a;'>🍴 Order Items (Order #" & orderId & ")</h4>" &
                                     itemsHtml &
                                     "<div style='margin-top: 24px; padding-top: 16px; border-top: 1px solid #e2e8f0; text-align: center; font-size: 12px; color: #94a3b8;'>" &
                                     "<p>Thank you for choosing Cloud Kitchen!</p>" &
                                     "</div></div></body></html>"

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
            System.Diagnostics.Debug.WriteLine("Error sending status email: " & ex.Message)
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

    Private Sub DeductInventoryForOrder(ByVal orderId As Integer)
        Try
            Using conn As New SqlConnection(connString)
                conn.Open()
                ' 1. Get line items from Order_Details for this order
                Dim dtItems As New DataTable()
                Dim queryItems As String = "SELECT m_id, quantity FROM Order_Details WHERE order_id = @OrderId"
                Using cmdItems As New SqlCommand(queryItems, conn)
                    cmdItems.Parameters.AddWithValue("@OrderId", orderId)
                    Dim adapter As New SqlDataAdapter(cmdItems)
                    adapter.Fill(dtItems)
                End Using

                Dim affectedDishIds As New System.Collections.Generic.List(Of Integer)()

                ' 2. For each line item, deduct mapped raw ingredients and direct unit stocks
                For Each row As DataRow In dtItems.Rows
                    Dim mId As Integer = Convert.ToInt32(row("m_id"))
                    Dim itemQty As Integer = Convert.ToInt32(row("quantity"))
                    If Not affectedDishIds.Contains(mId) Then
                        affectedDishIds.Add(mId)
                    End If

                    ' A. Deduct direct unit stock if specified in menu_item
                    Dim queryUnit As String = "UPDATE menu_item SET m_unit_stock = CASE WHEN m_unit_stock - @Qty < 0 THEN 0 ELSE m_unit_stock - @Qty END WHERE m_id = @MId AND m_unit_stock IS NOT NULL"
                    Using cmdUnit As New SqlCommand(queryUnit, conn)
                        cmdUnit.Parameters.AddWithValue("@Qty", itemQty)
                        cmdUnit.Parameters.AddWithValue("@MId", mId)
                        cmdUnit.ExecuteNonQuery()
                    End Using

                    ' B. Deduct raw ingredients mapped in Dish_Ingredients
                    Dim queryDeduct As String = "UPDATE Ingredients " &
                                                "SET stock_quantity = CASE WHEN (stock_quantity - (DI.qty_required * @ItemQty)) < 0 THEN 0 ELSE (stock_quantity - (DI.qty_required * @ItemQty)) END, " &
                                                "    last_updated = GETDATE() " &
                                                "FROM Ingredients I " &
                                                "INNER JOIN Dish_Ingredients DI ON I.ingredient_id = DI.ingredient_id " &
                                                "WHERE DI.m_id = @MId"
                    Using cmdDeduct As New SqlCommand(queryDeduct, conn)
                        cmdDeduct.Parameters.AddWithValue("@ItemQty", itemQty)
                        cmdDeduct.Parameters.AddWithValue("@MId", mId)
                        cmdDeduct.ExecuteNonQuery()
                    End Using
                Next

                ' 3. Out-of-Stock Safeguard: If any ingredient mapped to a dish reaches 0 stock, set m_availability = 'No'
                For Each mId As Integer In affectedDishIds
                    Dim queryCheckOut As String = "SELECT COUNT(*) FROM Dish_Ingredients DI INNER JOIN Ingredients I ON DI.ingredient_id = I.ingredient_id WHERE DI.m_id = @MId AND I.stock_quantity <= 0"
                    Using cmdCheckOut As New SqlCommand(queryCheckOut, conn)
                        cmdCheckOut.Parameters.AddWithValue("@MId", mId)
                        Dim outOfStockCount As Integer = Convert.ToInt32(cmdCheckOut.ExecuteScalar())
                        If outOfStockCount > 0 Then
                            Dim querySetUnavailable As String = "UPDATE menu_item SET m_availability = 'No' WHERE m_id = @MId"
                            Using cmdUnavail As New SqlCommand(querySetUnavailable, conn)
                                cmdUnavail.Parameters.AddWithValue("@MId", mId)
                                cmdUnavail.ExecuteNonQuery()
                            End Using
                        End If
                    End Using
                Next
            End Using
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine("Inventory deduction failed: " & ex.Message)
        End Try
    End Sub

End Class