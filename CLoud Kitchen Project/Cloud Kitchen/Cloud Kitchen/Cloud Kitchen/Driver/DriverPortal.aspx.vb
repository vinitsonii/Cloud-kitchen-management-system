Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

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

    Protected Sub rptActiveDeliveries_ItemCommand(ByVal source As Object, ByVal e As RepeaterCommandEventArgs)
        If e.CommandName = "VerifyOtp" Then
            Dim orderId As Integer = Convert.ToInt32(e.CommandArgument)
            Dim txtOtpInput As TextBox = CType(e.Item.FindControl("txtOtpInput"), TextBox)

            If txtOtpInput Is Nothing OrElse String.IsNullOrEmpty(txtOtpInput.Text.Trim()) Then
                ShowMessage("⚠️ Please enter the 4-digit OTP from customer.", False)
                Exit Sub
            End If

            Dim enteredOtp As String = txtOtpInput.Text.Trim()
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
                    ShowMessage("🎉 Delivery Completed Successfully for Order #" & orderId & "!", True)
                    RefreshPortalData()
                Else
                    conn.Close()
                    ShowMessage("❌ Invalid OTP (" & enteredOtp & ")! Ask customer for the 4-digit OTP shown on their screen.", False)
                End If
            End Using
        End If
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
End Class
