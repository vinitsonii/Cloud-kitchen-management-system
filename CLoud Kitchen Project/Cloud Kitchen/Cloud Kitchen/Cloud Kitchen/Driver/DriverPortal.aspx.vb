Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Net.Mail

Public Class DriverPortal
    Inherits System.Web.UI.Page

    Private connString As String = ConfigurationManager.ConnectionStrings("constr").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            If Session("DriverId") Is Nothing Then
                Response.Redirect("DriverLogin.aspx")
            End If

            Dim driverNameStr As String = Session("DriverName").ToString()
            lblDriverName.Text = driverNameStr
            lblDriverWelcomeName.Text = driverNameStr
            lblVehicleNo.Text = Session("DriverVehicle").ToString()

            ' Default date filter to Today
            txtHistoryStart.Text = DateTime.Today.ToString("yyyy-MM-dd")
            txtHistoryEnd.Text = DateTime.Today.ToString("yyyy-MM-dd")

            RefreshPortalData()
        End If
    End Sub

    Protected Sub tmrAutoRefresh_Tick(ByVal sender As Object, ByVal e As EventArgs)
        RefreshPortalData()
    End Sub

    Protected Sub btnRefresh_Click(ByVal sender As Object, ByVal e As EventArgs)
        RefreshPortalData()
    End Sub

    Protected Sub btnLogout_Click(ByVal sender As Object, ByVal e As EventArgs)
        Session.Abandon()
        Response.Redirect("DriverLogin.aspx")
    End Sub

    Private Sub RefreshPortalData()
        LoadDriverSummaryStats()
        LoadActiveDeliveries()
        LoadAvailablePool()
        LoadCompletedDeliveries()
    End Sub

    ' TOGGLE DRIVER DUTY STATUS (ONLINE / OFFLINE)
    Protected Sub btnToggleDuty_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim driverId As Integer = Convert.ToInt32(Session("DriverId"))

        Using conn As New SqlConnection(connString)
            conn.Open()

            ' 1. Check if driver has active Out for Delivery orders
            Dim checkActiveQuery As String = "SELECT COUNT(*) FROM Orders WHERE driver_id = @DriverId AND order_status = 'Out for Delivery'"
            Dim activeCount As Integer = 0
            Using cmdCheck As New SqlCommand(checkActiveQuery, conn)
                cmdCheck.Parameters.AddWithValue("@DriverId", driverId)
                activeCount = Convert.ToInt32(cmdCheck.ExecuteScalar())
            End Using

            ' Fetch current status
            Dim currentStatus As String = ""
            Dim queryCheck As String = "SELECT status FROM Drivers WHERE driver_id = @DriverId"
            Using cmdCheck As New SqlCommand(queryCheck, conn)
                cmdCheck.Parameters.AddWithValue("@DriverId", driverId)
                Dim res = cmdCheck.ExecuteScalar()
                If res IsNot Nothing Then currentStatus = res.ToString()
            End Using

            ' If attempting to go offline while actively delivering -> block and alert
            If (currentStatus = "Available" OrElse currentStatus = "On Delivery") AndAlso activeCount > 0 Then
                conn.Close()
                ShowMessage("⚠️ You cannot go offline while you have an active delivery in progress!", False)
                Exit Sub
            End If

            ' Toggle: If Offline or Inactive -> set Available; If Available or On Delivery -> set Offline
            Dim newStatus As String = If(currentStatus = "Offline" OrElse currentStatus = "Inactive", "Available", "Offline")
            Dim queryUpdate As String = "UPDATE Drivers SET status = @NewStatus WHERE driver_id = @DriverId"
            Using cmdUpdate As New SqlCommand(queryUpdate, conn)
                cmdUpdate.Parameters.AddWithValue("@NewStatus", newStatus)
                cmdUpdate.Parameters.AddWithValue("@DriverId", driverId)
                cmdUpdate.ExecuteNonQuery()
            End Using
            conn.Close()
        End Using

        RefreshPortalData()
    End Sub

    Private Sub LoadDriverSummaryStats()
        If Session("DriverId") Is Nothing Then Exit Sub
        Dim driverId As Integer = Convert.ToInt32(Session("DriverId"))

        Using conn As New SqlConnection(connString)
            conn.Open()

            ' 1. Check active Out for Delivery count for this driver
            Dim activeCount As Integer = 0
            Dim checkActiveQuery As String = "SELECT COUNT(*) FROM Orders WHERE driver_id = @DriverId AND order_status = 'Out for Delivery'"
            Using cmdCheck As New SqlCommand(checkActiveQuery, conn)
                cmdCheck.Parameters.AddWithValue("@DriverId", driverId)
                Dim activeObj = cmdCheck.ExecuteScalar()
                If activeObj IsNot Nothing Then activeCount = Convert.ToInt32(activeObj)
            End Using

            ' 2. Fetch driver status for UI badge & toggle button
            Dim queryStatus As String = "SELECT status FROM Drivers WHERE driver_id = @DriverId"
            Using cmdStatus As New SqlCommand(queryStatus, conn)
                cmdStatus.Parameters.AddWithValue("@DriverId", driverId)
                Dim statusObj = cmdStatus.ExecuteScalar()
                If statusObj IsNot Nothing Then
                    Dim statusStr As String = statusObj.ToString()
                    If lblDutyStatus IsNot Nothing AndAlso btnToggleDuty IsNot Nothing Then
                        If statusStr = "On Delivery" AndAlso activeCount > 0 Then
                            lblDutyStatus.Text = "On Delivery"
                            lblDutyStatus.CssClass = "status-badge status-ondelivery"
                            btnToggleDuty.Text = "Go Offline"
                            btnToggleDuty.CssClass = "btn-duty-toggle btn-duty-offline"
                        ElseIf statusStr = "Offline" OrElse statusStr = "Inactive" Then
                            lblDutyStatus.Text = "Offline (Off Duty)"
                            lblDutyStatus.CssClass = "status-badge status-offline"
                            btnToggleDuty.Text = "Go Online"
                            btnToggleDuty.CssClass = "btn-duty-toggle btn-duty-online"
                        Else
                            lblDutyStatus.Text = "Available (Online)"
                            lblDutyStatus.CssClass = "status-badge status-available"
                            btnToggleDuty.Text = "Go Offline"
                            btnToggleDuty.CssClass = "btn-duty-toggle btn-duty-offline"
                        End If
                    End If
                End If
            End Using

            ' 3. Calculate date range for completed stats
            Dim startDate As DateTime = DateTime.Today
            Dim endDate As DateTime = DateTime.Now
            GetSelectedDateRange(startDate, endDate)

            Dim queryStats As String = "SELECT " &
                                       "(SELECT COUNT(*) FROM Orders WHERE driver_id = @DriverId AND order_status = 'Completed' AND ISNULL(delivered_time, order_date) BETWEEN @StartDate AND @EndDate) AS CompletedCount, " &
                                       "(SELECT ISNULL(SUM(total_amount), 0) FROM Orders WHERE driver_id = @DriverId AND order_status = 'Completed' AND (payment_type LIKE '%Cash%' OR payment_type LIKE '%COD%') AND ISNULL(delivered_time, order_date) BETWEEN @StartDate AND @EndDate) AS CashCollected"

            Using cmdStats As New SqlCommand(queryStats, conn)
                cmdStats.Parameters.AddWithValue("@DriverId", driverId)
                cmdStats.Parameters.AddWithValue("@StartDate", startDate)
                cmdStats.Parameters.AddWithValue("@EndDate", endDate)
                Using reader As SqlDataReader = cmdStats.ExecuteReader()
                    If reader.Read() Then
                        Dim completedCount As Integer = Convert.ToInt32(reader("CompletedCount"))
                        If lblCompletedCount IsNot Nothing Then lblCompletedCount.Text = completedCount.ToString()

                        Dim cashCollected As Decimal = Convert.ToDecimal(reader("CashCollected"))
                        If lblTotalCashCollected IsNot Nothing Then lblTotalCashCollected.Text = cashCollected.ToString("N2")
                    End If
                End Using
            End Using

        End Using
    End Sub

    Private Sub LoadActiveDeliveries()
        Dim driverId As Integer = Convert.ToInt32(Session("DriverId"))

        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT O.order_id, O.order_date, O.total_amount, O.payment_type, O.address, O.pincode, O.delivery_otp, " &
                                  "C.C_Name AS customer_name, C.Phone AS phone " &
                                  "FROM Orders O " &
                                  "INNER JOIN Customers C ON O.c_id = C.C_Id " &
                                  "WHERE O.driver_id = @DriverId AND O.order_status = 'Out for Delivery' " &
                                  "ORDER BY O.order_id DESC"

            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@DriverId", driverId)
                Dim dt As New DataTable()
                Dim adapter As New SqlDataAdapter(cmd)
                adapter.Fill(dt)

                dt.Columns.Add("OrderItems", GetType(DataTable))
                For Each row As DataRow In dt.Rows
                    Dim orderId As Integer = Convert.ToInt32(row("order_id"))
                    row("OrderItems") = GetOrderItems(orderId)
                Next

                lblActiveCount.Text = dt.Rows.Count.ToString()

                If dt.Rows.Count > 0 Then
                    rptActiveDeliveries.DataSource = dt
                    rptActiveDeliveries.DataBind()
                    pnlNoActive.Visible = False
                Else
                    rptActiveDeliveries.DataSource = Nothing
                    rptActiveDeliveries.DataBind()
                    pnlNoActive.Visible = True
                End If
            End Using
        End Using
    End Sub

    ' FILTER COMPLETED DELIVERIES HISTORY BY DATE RANGE
    Protected Sub ddlHistoryFilter_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
        Select Case ddlHistoryFilter.SelectedValue
            Case "Today"
                txtHistoryStart.Text = DateTime.Today.ToString("yyyy-MM-dd")
                txtHistoryEnd.Text = DateTime.Today.ToString("yyyy-MM-dd")
            Case "Yesterday"
                txtHistoryStart.Text = DateTime.Today.AddDays(-1).ToString("yyyy-MM-dd")
                txtHistoryEnd.Text = DateTime.Today.AddDays(-1).ToString("yyyy-MM-dd")
            Case "7Days"
                txtHistoryStart.Text = DateTime.Today.AddDays(-7).ToString("yyyy-MM-dd")
                txtHistoryEnd.Text = DateTime.Today.ToString("yyyy-MM-dd")
            Case "Month"
                txtHistoryStart.Text = New DateTime(DateTime.Today.Year, DateTime.Today.Month, 1).ToString("yyyy-MM-dd")
                txtHistoryEnd.Text = DateTime.Today.ToString("yyyy-MM-dd")
            Case "All"
                txtHistoryStart.Text = DateTime.Today.AddYears(-2).ToString("yyyy-MM-dd")
                txtHistoryEnd.Text = DateTime.Today.ToString("yyyy-MM-dd")
        End Select

        RefreshPortalData()
    End Sub

    Protected Sub btnFilterHistory_Click(ByVal sender As Object, ByVal e As EventArgs)
        RefreshPortalData()
    End Sub

    Private Sub GetSelectedDateRange(ByRef startDate As DateTime, ByRef endDate As DateTime)
        startDate = DateTime.Today
        endDate = DateTime.Now

        If Not String.IsNullOrEmpty(txtHistoryStart.Text) Then
            DateTime.TryParse(txtHistoryStart.Text, startDate)
        End If

        If Not String.IsNullOrEmpty(txtHistoryEnd.Text) Then
            DateTime.TryParse(txtHistoryEnd.Text, endDate)
            endDate = endDate.AddHours(23).AddMinutes(59).AddSeconds(59)
        End If
    End Sub

    Private Sub LoadCompletedDeliveries()
        Dim driverId As Integer = Convert.ToInt32(Session("DriverId"))

        Dim startDate As DateTime = DateTime.Today
        Dim endDate As DateTime = DateTime.Now
        GetSelectedDateRange(startDate, endDate)

        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT O.order_id, O.order_date, O.delivered_time, O.total_amount, O.payment_type, O.address, O.pincode, " &
                                  "C.C_Name AS customer_name, C.Phone AS phone " &
                                  "FROM Orders O " &
                                  "INNER JOIN Customers C ON O.c_id = C.C_Id " &
                                  "WHERE O.driver_id = @DriverId AND O.order_status = 'Completed' AND ISNULL(O.delivered_time, O.order_date) BETWEEN @StartDate AND @EndDate " &
                                  "ORDER BY ISNULL(O.delivered_time, O.order_date) DESC"

            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@DriverId", driverId)
                cmd.Parameters.AddWithValue("@StartDate", startDate)
                cmd.Parameters.AddWithValue("@EndDate", endDate)
                Dim dt As New DataTable()
                Dim adapter As New SqlDataAdapter(cmd)
                adapter.Fill(dt)

                dt.Columns.Add("OrderItems", GetType(DataTable))
                For Each row As DataRow In dt.Rows
                    Dim orderId As Integer = Convert.ToInt32(row("order_id"))
                    row("OrderItems") = GetOrderItems(orderId)
                Next

                If dt.Rows.Count > 0 Then
                    rptCompletedDeliveries.DataSource = dt
                    rptCompletedDeliveries.DataBind()
                    pnlNoCompleted.Visible = False
                Else
                    rptCompletedDeliveries.DataSource = Nothing
                    rptCompletedDeliveries.DataBind()
                    pnlNoCompleted.Visible = True
                End If
            End Using
        End Using
    End Sub

    Private Function GetOrderItems(ByVal orderId As Integer) As DataTable
        Dim dtItems As New DataTable()
        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT M.M_Name AS item_name, OI.quantity FROM Order_Details OI INNER JOIN Menu_Item M ON OI.m_id = M.M_Id WHERE OI.order_id = @OrderId"
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@OrderId", orderId)
                Dim adapter As New SqlDataAdapter(cmd)
                adapter.Fill(dtItems)
            End Using
        End Using
        Return dtItems
    End Function

    Protected Sub rptActiveDeliveries_ItemDataBound(ByVal sender As Object, ByVal e As RepeaterItemEventArgs)
        If e.Item.ItemType = ListItemType.Item OrElse e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim cvOtp As CustomValidator = CType(e.Item.FindControl("cvOtp"), CustomValidator)
            If cvOtp IsNot Nothing Then
                cvOtp.IsValid = True
            End If
        End If
    End Sub

    Protected Sub cvOtp_ServerValidate(ByVal source As Object, ByVal args As ServerValidateEventArgs)
        Dim val As String = If(args.Value IsNot Nothing, args.Value.Trim(), "")
        args.IsValid = System.Text.RegularExpressions.Regex.IsMatch(val, "^\d{4}$")
    End Sub

    Protected Sub rptActiveDeliveries_ItemCommand(ByVal source As Object, ByVal e As RepeaterCommandEventArgs)
        If e.CommandName = "VerifyOtp" Then
            Dim orderId As Integer = Convert.ToInt32(e.CommandArgument)
            Page.Validate("OtpGroup_" & orderId)
            If Not Page.IsValid Then Exit Sub

            Dim txtOtpInput As TextBox = CType(e.Item.FindControl("txtOtpInput"), TextBox)

            If txtOtpInput Is Nothing OrElse String.IsNullOrEmpty(txtOtpInput.Text.Trim()) Then
                ShowMessage("⚠️ Please enter the 4-digit OTP from customer.", False)
                Exit Sub
            End If

            Dim enteredOtp As String = txtOtpInput.Text.Trim()
            If Not System.Text.RegularExpressions.Regex.IsMatch(enteredOtp, "^\d{4}$") Then
                ShowMessage("⚠️ Invalid OTP format! OTP must be exactly 4 numeric digits.", False)
                Exit Sub
            End If

            Dim driverId As Integer = Convert.ToInt32(Session("DriverId"))

            Using conn As New SqlConnection(connString)
                conn.Open()
                ' Check if OTP matches
                Dim checkQuery As String = "SELECT delivery_otp FROM Orders WHERE order_id = @OrderId AND driver_id = @DriverId"
                Dim actualOtp As String = ""
                Using checkCmd As New SqlCommand(checkQuery, conn)
                    checkCmd.Parameters.AddWithValue("@OrderId", orderId)
                    checkCmd.Parameters.AddWithValue("@DriverId", driverId)
                    Dim result = checkCmd.ExecuteScalar()
                    If result IsNot Nothing Then actualOtp = result.ToString().Trim()
                End Using

                If actualOtp = enteredOtp Then
                    ' Mark order Completed & set delivered_time
                    Dim updateOrderQuery As String = "UPDATE Orders SET order_status = 'Completed', delivered_time = GETDATE() WHERE order_id = @OrderId"
                    Using cmdUpdate As New SqlCommand(updateOrderQuery, conn)
                        cmdUpdate.Parameters.AddWithValue("@OrderId", orderId)
                        cmdUpdate.ExecuteNonQuery()
                    End Using

                    ' Check if driver has any other active orders; if not, mark driver Available
                    Dim checkActiveQuery As String = "SELECT COUNT(*) FROM Orders WHERE driver_id = @DriverId AND order_status = 'Out for Delivery'"
                    Using cmdCheckActive As New SqlCommand(checkActiveQuery, conn)
                        cmdCheckActive.Parameters.AddWithValue("@DriverId", driverId)
                        Dim activeCount As Integer = Convert.ToInt32(cmdCheckActive.ExecuteScalar())
                        If activeCount = 0 Then
                            Dim updateDriverQuery As String = "UPDATE Drivers SET status = 'Available' WHERE driver_id = @DriverId"
                            Using cmdDriver As New SqlCommand(updateDriverQuery, conn)
                                cmdDriver.Parameters.AddWithValue("@DriverId", driverId)
                                cmdDriver.ExecuteNonQuery()
                            End Using
                        End If
                    End Using

                    conn.Close()
                    Dim dName As String = If(Session("DriverName") IsNot Nothing, Session("DriverName").ToString(), "Partner")
                    ShowMessage("🎉 Outstanding Job, " & dName & "! Order #" & orderId & " delivered successfully! Thank you for your fast & reliable service! 🛵⭐", True)
                    SendOrderNotificationEmail(orderId, "Completed")
                    RefreshPortalData()
                Else
                    conn.Close()
                    ShowMessage("❌ Invalid OTP (" & enteredOtp & ")! Ask customer for the 4-digit OTP shown on their screen.", False)
                End If
            End Using
        End If
    End Sub

    Private Sub LoadAvailablePool()
        If Session("DriverId") Is Nothing Then Exit Sub
        Dim driverId As Integer = Convert.ToInt32(Session("DriverId"))

        Dim driverStatus As String = "Offline"
        Using conn As New SqlConnection(connString)
            Dim statusQuery As String = "SELECT status FROM Drivers WHERE driver_id = @DriverId"
            Using cmdStatus As New SqlCommand(statusQuery, conn)
                cmdStatus.Parameters.AddWithValue("@DriverId", driverId)
                conn.Open()
                Dim res = cmdStatus.ExecuteScalar()
                If res IsNot Nothing Then
                    driverStatus = res.ToString()
                End If
                conn.Close()
            End Using
        End Using

        If driverStatus = "On Delivery" Then
            rptAvailablePool.DataSource = Nothing
            rptAvailablePool.DataBind()
            pnlNoPool.Visible = True
            litNoPoolMsg.Text = "🛵 You are currently carrying an active delivery. Complete your current delivery to view & claim new dispatches."
            pnlExpressPopUp.Visible = False
            If lblPoolBadge IsNot Nothing Then
                lblPoolBadge.Text = "On Delivery"
                lblPoolBadge.Style("background") = "#eff6ff"
                lblPoolBadge.Style("color") = "#1d4ed8"
                lblPoolBadge.Style("border-color") = "#bfdbfe"
            End If
            Exit Sub
        ElseIf driverStatus <> "Available" Then
            rptAvailablePool.DataSource = Nothing
            rptAvailablePool.DataBind()
            pnlNoPool.Visible = True
            litNoPoolMsg.Text = "🔒 You are currently offline. Tap 'Go Online' at the top to view & claim available dispatches."
            pnlExpressPopUp.Visible = False
            If lblPoolBadge IsNot Nothing Then
                lblPoolBadge.Text = "Offline"
                lblPoolBadge.Style("background") = "#f1f5f9"
                lblPoolBadge.Style("color") = "#64748b"
                lblPoolBadge.Style("border-color") = "#e2e8f0"
            End If
            Exit Sub
        End If

        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT O.order_id, O.order_date, O.total_amount, O.payment_type, O.address, O.pincode, " &
                                  "C.C_Name AS customer_name, C.Phone AS phone " &
                                  "FROM Orders O " &
                                  "INNER JOIN Customers C ON O.c_id = C.C_Id " &
                                  "WHERE (O.driver_id IS NULL OR O.driver_id = 0) AND O.order_status = 'Preparing' " &
                                  "ORDER BY O.order_id DESC"

            Using cmd As New SqlCommand(query, conn)
                Dim dt As New DataTable()
                Dim adapter As New SqlDataAdapter(cmd)
                adapter.Fill(dt)

                dt.Columns.Add("OrderItems", GetType(DataTable))
                For Each row As DataRow In dt.Rows
                    Dim orderId As Integer = Convert.ToInt32(row("order_id"))
                    row("OrderItems") = GetOrderItems(orderId)
                Next

                If lblPoolBadge IsNot Nothing Then lblPoolBadge.Text = dt.Rows.Count.ToString() & " Ready"

                If dt.Rows.Count > 0 Then
                    rptAvailablePool.DataSource = dt
                    rptAvailablePool.DataBind()
                    pnlNoPool.Visible = False

                    Dim topRow As DataRow = dt.Rows(0)
                    litExpressOrderId.Text = topRow("order_id").ToString()
                    litExpressCustName.Text = topRow("customer_name").ToString()
                    litExpressAddress.Text = topRow("address").ToString() & ", " & topRow("pincode").ToString()
                    litExpressPayment.Text = topRow("payment_type").ToString()
                    litExpressTotal.Text = Convert.ToDecimal(topRow("total_amount")).ToString("N2")
                    btnExpressClaim.CommandArgument = topRow("order_id").ToString()
                    pnlExpressPopUp.Visible = True

                    ScriptManager.RegisterStartupScript(Me, Me.GetType(), "StartTimer", "startExpressTimer(30);", True)
                Else
                    rptAvailablePool.DataSource = Nothing
                    rptAvailablePool.DataBind()
                    pnlNoPool.Visible = True
                    pnlExpressPopUp.Visible = False
                End If
            End Using
        End Using
    End Sub

    Protected Sub rptAvailablePool_ItemCommand(ByVal source As Object, ByVal e As RepeaterCommandEventArgs)
        If e.CommandName = "ClaimOrder" Then
            Dim orderId As Integer = Convert.ToInt32(e.CommandArgument)
            ClaimOrderInternal(orderId)
        End If
    End Sub

    Protected Sub btnExpressClaim_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim btn As Button = CType(sender, Button)
        If btn IsNot Nothing AndAlso Not String.IsNullOrEmpty(btn.CommandArgument) Then
            Dim orderId As Integer = Convert.ToInt32(btn.CommandArgument)
            ClaimOrderInternal(orderId)
        End If
    End Sub

    Private Sub ClaimOrderInternal(ByVal orderId As Integer)
        If Session("DriverId") Is Nothing Then Exit Sub
        Dim driverId As Integer = Convert.ToInt32(Session("DriverId"))
        Dim randomOtp As String = New Random().Next(1000, 9999).ToString()

        Dim isClaimedSuccess As Boolean = False

        Using conn As New SqlConnection(connString)
            conn.Open()
            Dim atomicQuery As String = "BEGIN TRANSACTION; " &
                                        "IF EXISTS (SELECT 1 FROM Orders WITH (UPDLOCK, HOLDLOCK) WHERE order_id = @OrderId AND (driver_id IS NULL OR driver_id = 0) AND order_status = 'Preparing') " &
                                        "BEGIN " &
                                        "    UPDATE Orders SET driver_id = @DriverId, order_status = 'Out for Delivery', delivery_otp = @Otp WHERE order_id = @OrderId; " &
                                        "    UPDATE Drivers SET status = 'On Delivery' WHERE driver_id = @DriverId; " &
                                        "    SELECT 1 AS Success; " &
                                        "END " &
                                        "ELSE IF EXISTS (SELECT 1 FROM Orders WITH (UPDLOCK, HOLDLOCK) WHERE order_id = @OrderId AND driver_id = @DriverId) " &
                                        "BEGIN " &
                                        "    UPDATE Drivers SET status = 'On Delivery' WHERE driver_id = @DriverId; " &
                                        "    SELECT 1 AS Success; " &
                                        "END " &
                                        "ELSE " &
                                        "BEGIN " &
                                        "    SELECT 0 AS Success; " &
                                        "END " &
                                        "COMMIT TRANSACTION;"

            Using cmd As New SqlCommand(atomicQuery, conn)
                cmd.Parameters.AddWithValue("@OrderId", orderId)
                cmd.Parameters.AddWithValue("@DriverId", driverId)
                cmd.Parameters.AddWithValue("@Otp", randomOtp)
                Dim res = cmd.ExecuteScalar()
                If res IsNot Nothing AndAlso Convert.ToInt32(res) = 1 Then
                    isClaimedSuccess = True
                End If
            End Using
            conn.Close()
        End Using

        If isClaimedSuccess Then
            SendOrderNotificationEmail(orderId, "Out for Delivery")
            ShowMessage("⚡ Order #" & orderId & " claimed successfully! Delivery dispatch started.", True)
        Else
            ShowMessage("⚠️ Order #" & orderId & " was just claimed by another driver!", False)
        End If

        RefreshPortalData()
    End Sub

    Private Sub SendOrderNotificationEmail(ByVal orderId As Integer, ByVal status As String)
        Try
            Dim userEmail As String = ""
            Dim userName As String = ""
            Dim address As String = ""
            Dim pincode As String = ""
            Dim paymentType As String = ""
            Dim totalAmount As Decimal = 0
            Dim driverName As String = ""
            Dim driverPhone As String = ""
            Dim vehicleNo As String = ""
            Dim deliveryOtp As String = ""

            Using conn As New SqlConnection(connString)
                Dim query As String = "SELECT O.total_amount, O.payment_type, O.address, O.pincode, O.delivery_otp, C.C_Name, C.Email, " &
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
                            address = reader("address").ToString()
                            pincode = reader("pincode").ToString()
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
            Dim cartTable As String = "<table class='order-table'><tr><th>Item</th><th>Qty</th></tr>"

            For Each row As DataRow In orderItems.Rows
                Dim itemName As String = row("item_name").ToString()
                Dim quantity As Integer = Convert.ToInt32(row("quantity"))
                cartTable &= "<tr><td>" & itemName & "</td><td>" & quantity & "</td></tr>"
            Next
            cartTable &= "</table>"

            Dim emailSubject As String = "🛵 Delivery Partner Assigned to Order #" & orderId & "! - Cloud Kitchen"
            Dim bannerHtml As String = "<div class='success-box' style='background:#eff6ff; border-left:5px solid #2563eb;'><h2 style='color:#1d4ed8; margin:0;'>🛵 Delivery Partner Assigned!</h2><p style='margin:4px 0 0 0; color:#1e40af;'>Your driver is heading to our kitchen to pick up your fresh meal.</p></div>"
            Dim messageText As String = "Great news! <b>" & driverName & "</b> has accepted your order and is heading to the kitchen to pick up your food. Once ready, it will be delivered directly to your doorstep."

            Dim driverBlock As String = "<div style='background-color: #eff6ff; border: 1.5px solid #bfdbfe; border-radius: 10px; padding: 16px; margin-top: 15px; text-align: left;'>" &
                                        "<h4 style='margin: 0 0 10px 0; color: #1e40af; font-size: 16px;'>🛵 Delivery Partner Details</h4>" &
                                        "<p style='margin: 4px 0; color: #334155;'><b>Driver Name:</b> " & driverName & "</p>" &
                                        "<p style='margin: 4px 0; color: #334155;'><b>Vehicle Number:</b> " & vehicleNo & "</p>" &
                                        "<p style='margin: 4px 0; color: #334155;'><b>Phone:</b> <a href='tel:" & driverPhone & "' style='color: #2563eb; font-weight: bold; text-decoration: none;'>📞 " & driverPhone & "</a></p>" &
                                        "<div style='background-color: #fef3c7; border: 1.5px solid #fde68a; color: #b45309; border-radius: 8px; padding: 12px; margin-top: 12px; text-align: center; font-weight: bold; font-size: 15px;'>" &
                                        "🔑 Doorstep Delivery OTP: <span style='font-size: 22px; font-weight: 900; color: #d97706; background: #ffffff; padding: 2px 14px; border-radius: 6px; border: 1px solid #fcd34d; margin-left: 6px;'>" & deliveryOtp & "</span>" &
                                        "<br/><span style='font-size: 12px; font-weight: normal; color: #92400e; display: block; margin-top: 4px;'>Please share this 4-digit OTP with your driver upon arrival.</span>" &
                                        "</div></div>"

            Dim baseUrl As String = ""
            If HttpContext.Current IsNot Nothing AndAlso HttpContext.Current.Request IsNot Nothing Then
                baseUrl = HttpContext.Current.Request.Url.Scheme & "://" & HttpContext.Current.Request.Url.Authority
            Else
                baseUrl = ConfigurationManager.AppSettings("WebsiteUrl")
                If String.IsNullOrEmpty(baseUrl) Then baseUrl = "http://localhost"
            End If
            Dim myOrdersUrl As String = baseUrl & "/Customers/MyOrders.aspx"

            Dim emailBody As String = "<!DOCTYPE html><html><head><meta charset='UTF-8'><style>" &
                                      "body{margin:0;padding:0;background:#f4f6f9;font-family:Arial,sans-serif;}" &
                                      ".wrapper{width:100%;padding:30px 0;}" &
                                      ".container{max-width:650px;background:#ffffff;margin:auto;border-radius:16px;overflow:hidden;box-shadow:0 8px 30px rgba(0,0,0,0.08);}" &
                                      ".header{background:linear-gradient(135deg,#4F7E76,#3a5f59);padding:35px;text-align:center;color:#fff;}" &
                                      ".header h1{margin:0;font-size:32px;}" &
                                      ".header p{margin-top:8px;opacity:0.9;font-size:15px;}" &
                                      ".content{padding:35px;}" &
                                      ".success-box{padding:18px;border-radius:10px;margin-bottom:25px;}" &
                                      ".details{background:#fafafa;padding:20px;border-radius:12px;margin-top:20px;text-align:left;}" &
                                      ".details p{margin:10px 0;color:#444;font-size:15px;}" &
                                      ".table-title{margin-top:30px;color:#333;font-size:22px;}" &
                                      ".order-table{width:100%;border-collapse:collapse;margin-top:15px;}" &
                                      ".order-table th{background:#4F7E76;color:white;padding:14px;text-align:left;font-size:14px;}" &
                                      ".order-table td{padding:14px;border-bottom:1px solid #eee;font-size:14px;}" &
                                      ".total-box{text-align:right;margin-top:20px;font-size:22px;color:#4F7E76;font-weight:bold;}" &
                                      ".button{display:inline-block;background:#ff9f43;color:#fff !important;text-decoration:none;padding:14px 28px;border-radius:50px;margin-top:30px;font-weight:bold;font-size:15px;}" &
                                      ".footer{background:#f8f8f8;padding:25px;text-align:center;color:#777;font-size:13px;}" &
                                      ".footer a{color:#4F7E76;text-decoration:none;}" &
                                      "</style></head><body>" &
                                      "<div class='wrapper'><div class='container'>" &
                                      "<div class='header'><h1>🍽 Cloud Kitchen</h1><p>Fresh Meals Delivered To Your Doorstep</p></div>" &
                                      "<div class='content'>" &
                                      bannerHtml &
                                      "<p>Hello <b>" & userName & "</b>,</p><p>" & messageText & "</p>" &
                                      "<div class='details'>" &
                                      "<p><strong>🧾 Order ID:</strong> #" & orderId & "</p>" &
                                      "<p><strong>🚚 Delivery Address:</strong> " & address & "</p>" &
                                      "<p><strong>📍 Pincode:</strong> " & pincode & "</p>" &
                                      "<p><strong>💰 Payment Method:</strong> " & paymentType & "</p>" &
                                      "<p><strong>⏰ Estimated Delivery:</strong> 30 - 40 Minutes</p>" &
                                      driverBlock &
                                      "</div>" &
                                      "<h3 class='table-title'>🛒 Order Summary</h3>" &
                                      cartTable &
                                      "<div class='total-box'>Total Amount: ₹" & totalAmount.ToString("N2") & "<br/><span style='font-size:12px; color:#64748b; font-weight:normal;'>(Incl. of all taxes & GST)</span></div>" &
                                      "<center><a href='" & myOrdersUrl & "' class='button'>View My Orders</a></center>" &
                                      "</div>" &
                                      "<div class='footer'><p>Need help? Contact us anytime</p><p>📧 info.cloudkitchenn@gmail.com</p><p>© Cloud Kitchen - All Rights Reserved</p></div>" &
                                      "</div></div></body></html>"

            Using mailMsg As New System.Net.Mail.MailMessage()
                mailMsg.From = New System.Net.Mail.MailAddress(emailUsername, "Cloud Kitchen")
                mailMsg.To.Add(userEmail)
                mailMsg.Subject = emailSubject
                mailMsg.Body = emailBody
                mailMsg.IsBodyHtml = True

                Using client As New System.Net.Mail.SmtpClient(smtpServer, smtpPort)
                    client.Credentials = New System.Net.NetworkCredential(emailUsername, emailPassword)
                    client.EnableSsl = True
                    client.Send(mailMsg)
                End Using
            End Using
        Catch ex As Exception
            ' Silent fail for email background errors
        End Try
    End Sub

    Private Sub ShowMessage(ByVal message As String, ByVal isSuccess As Boolean)
        lblMsg.Text = message
        lblMsg.Visible = True
        If isSuccess Then
            lblMsg.Style("background-color") = "#dcfce7"
            lblMsg.Style("color") = "#15803d"
            lblMsg.Style("border") = "1px solid #bbf7d0"
        Else
            lblMsg.Style("background-color") = "#fee2e2"
            lblMsg.Style("color") = "#b91c1c"
            lblMsg.Style("border") = "1px solid #fca5a5"
        End If
    End Sub

    Protected Sub btnOpenChangePwd_Click(ByVal sender As Object, ByVal e As EventArgs)
        txtCurrentPwd.Text = ""
        txtNewPwd.Text = ""
        txtConfirmPwd.Text = ""
        lblPwdMsg.Visible = False
        pnlChangePasswordModal.Visible = True
    End Sub

    Protected Sub btnClosePwdModal_Click(ByVal sender As Object, ByVal e As EventArgs)
        pnlChangePasswordModal.Visible = False
    End Sub

    Protected Sub btnUpdatePassword_Click(ByVal sender As Object, ByVal e As EventArgs)
        If Session("DriverId") Is Nothing Then Exit Sub

        Dim currentPwd As String = txtCurrentPwd.Text.Trim()
        Dim newPwd As String = txtNewPwd.Text.Trim()
        Dim confirmPwd As String = txtConfirmPwd.Text.Trim()

        If String.IsNullOrEmpty(currentPwd) OrElse String.IsNullOrEmpty(newPwd) OrElse String.IsNullOrEmpty(confirmPwd) Then
            ShowPwdMsg("⚠️ All fields are required!", False)
            Exit Sub
        End If

        If newPwd.Length < 4 Then
            ShowPwdMsg("⚠️ New password must be at least 4 characters long!", False)
            Exit Sub
        End If

        If newPwd <> confirmPwd Then
            ShowPwdMsg("⚠️ New password and confirmation do not match!", False)
            Exit Sub
        End If

        Dim driverId As Integer = Convert.ToInt32(Session("DriverId"))

        Using conn As New SqlConnection(connString)
            conn.Open()
            Dim dbPwd As String = ""
            Dim checkQuery As String = "SELECT password FROM Drivers WHERE driver_id = @DriverId"
            Using cmdCheck As New SqlCommand(checkQuery, conn)
                cmdCheck.Parameters.AddWithValue("@DriverId", driverId)
                Dim res = cmdCheck.ExecuteScalar()
                If res IsNot Nothing Then dbPwd = res.ToString()
            End Using

            If dbPwd <> currentPwd Then
                conn.Close()
                ShowPwdMsg("❌ Current password is incorrect!", False)
                Exit Sub
            End If

            Dim updateQuery As String = "UPDATE Drivers SET password = @NewPwd WHERE driver_id = @DriverId"
            Using cmdUpdate As New SqlCommand(updateQuery, conn)
                cmdUpdate.Parameters.AddWithValue("@NewPwd", newPwd)
                cmdUpdate.Parameters.AddWithValue("@DriverId", driverId)
                cmdUpdate.ExecuteNonQuery()
            End Using

            conn.Close()
        End Using

        pnlChangePasswordModal.Visible = False
        ShowMessage("🔑 Password updated successfully! Please use your new password next time you log in.", True)
    End Sub

    Private Sub ShowPwdMsg(ByVal msg As String, ByVal isSuccess As Boolean)
        lblPwdMsg.Text = msg
        lblPwdMsg.Visible = True
        If isSuccess Then
            lblPwdMsg.Style("background-color") = "#dcfce7"
            lblPwdMsg.Style("color") = "#15803d"
            lblPwdMsg.Style("border") = "1px solid #bbf7d0"
        Else
            lblPwdMsg.Style("background-color") = "#fee2e2"
            lblPwdMsg.Style("color") = "#b91c1c"
            lblPwdMsg.Style("border") = "1px solid #fca5a5"
        End If
    End Sub

    Protected Function GetCustomerWhatsAppUrl(ByVal phone As Object, ByVal customerName As Object, ByVal orderId As Object) As String
        If phone Is Nothing OrElse IsDBNull(phone) Then Return "#"
        Dim rawPhone As String = phone.ToString().Trim()
        Dim digitsOnly As String = System.Text.RegularExpressions.Regex.Replace(rawPhone, "[^\d]", "")
        If digitsOnly.Length = 10 Then
            digitsOnly = "91" & digitsOnly
        ElseIf digitsOnly.StartsWith("0") AndAlso digitsOnly.Length = 11 Then
            digitsOnly = "91" & digitsOnly.Substring(1)
        End If

        Dim custName As String = If(customerName IsNot Nothing AndAlso Not IsDBNull(customerName), customerName.ToString(), "Customer")
        Dim orderIdStr As String = If(orderId IsNot Nothing AndAlso Not IsDBNull(orderId), orderId.ToString(), "")

        Dim message As String = "Hello " & custName & ", I am your Cloud Kitchen delivery partner with Order #" & orderIdStr & "."
        Return "https://api.whatsapp.com/send?phone=" & digitsOnly & "&text=" & Server.UrlEncode(message)
    End Function
End Class
