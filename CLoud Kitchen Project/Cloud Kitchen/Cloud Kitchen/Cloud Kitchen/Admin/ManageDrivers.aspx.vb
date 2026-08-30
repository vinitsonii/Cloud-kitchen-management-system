Imports System.Data
Imports System.Data.SqlClient

Public Class ManageDrivers
    Inherits System.Web.UI.Page

    Private connString As String = ConfigurationManager.ConnectionStrings("constr").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            LoadDriverStats()
            LoadDrivers()
        End If
    End Sub

    Private Sub LoadDriverStats()
        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT " &
                                  "(SELECT COUNT(*) FROM Drivers WHERE status != 'Inactive') AS TotalDrivers, " &
                                  "(SELECT COUNT(*) FROM Drivers WHERE status = 'Available') AS AvailableDrivers, " &
                                  "(SELECT COUNT(*) FROM Drivers WHERE status = 'On Delivery') AS OnDeliveryDrivers"

            Using cmd As New SqlCommand(query, conn)
                conn.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        lblTotalDrivers.Text = reader("TotalDrivers").ToString()
                        lblAvailableDrivers.Text = reader("AvailableDrivers").ToString()
                        lblOnDeliveryDrivers.Text = reader("OnDeliveryDrivers").ToString()
                    End If
                End Using
                conn.Close()
            End Using
        End Using
    End Sub

    Private Sub LoadDrivers()
        Dim search As String = txtSearchDriver.Text.Trim()
        Dim statusFilter As String = If(ddlStatusFilter IsNot Nothing, ddlStatusFilter.SelectedValue, "All")

        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT driver_id, driver_name, phone, password, vehicle_no, status, created_date " &
                                  "FROM Drivers " &
                                  "WHERE (@Search = '' OR driver_name LIKE '%' + @Search + '%' OR phone LIKE '%' + @Search + '%') " &
                                  "AND (@StatusFilter = 'All' OR status = @StatusFilter) " &
                                  "ORDER BY driver_id DESC"

            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@Search", search)
                cmd.Parameters.AddWithValue("@StatusFilter", statusFilter)
                Dim dt As New DataTable()
                Dim adapter As New SqlDataAdapter(cmd)
                adapter.Fill(dt)
                rptDrivers.DataSource = dt
                rptDrivers.DataBind()
            End Using
        End Using
    End Sub

    Protected Sub txtSearchDriver_TextChanged(ByVal sender As Object, ByVal e As EventArgs)
        LoadDrivers()
    End Sub

    Protected Sub ddlStatusFilter_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
        LoadDrivers()
    End Sub

    Protected Sub btnSaveDriver_Click(ByVal sender As Object, ByVal e As EventArgs)
        If Page.IsValid Then
            Dim driverId As String = hfDriverId.Value
            Dim name As String = txtDriverName.Text.Trim()
            Dim phone As String = txtPhone.Text.Trim()
            Dim password As String = txtPassword.Text.Trim()
            Dim vehicleNo As String = txtVehicleNo.Text.Trim()

            Using conn As New SqlConnection(connString)
                conn.Open()

                If String.IsNullOrEmpty(driverId) Then
                    ' Insert New Driver
                    Dim checkQuery As String = "SELECT COUNT(*) FROM Drivers WHERE phone = @Phone"
                    Using checkCmd As New SqlCommand(checkQuery, conn)
                        checkCmd.Parameters.AddWithValue("@Phone", phone)
                        Dim count As Integer = Convert.ToInt32(checkCmd.ExecuteScalar())
                        If count > 0 Then
                            ShowMessage("❌ Phone number already registered to another driver!", False)
                            Exit Sub
                        End If
                    End Using

                    Dim insertQuery As String = "INSERT INTO Drivers (driver_name, phone, password, vehicle_no, status) " &
                                                "VALUES (@Name, @Phone, @Password, @VehicleNo, 'Available')"
                    Using cmd As New SqlCommand(insertQuery, conn)
                        cmd.Parameters.AddWithValue("@Name", name)
                        cmd.Parameters.AddWithValue("@Phone", phone)
                        cmd.Parameters.AddWithValue("@Password", password)
                        cmd.Parameters.AddWithValue("@VehicleNo", vehicleNo)
                        cmd.ExecuteNonQuery()
                    End Using
                    ShowMessage("✅ Driver registered successfully!", True)
                Else
                    ' Update Existing Driver
                    Dim updateQuery As String = "UPDATE Drivers SET driver_name=@Name, phone=@Phone, password=@Password, vehicle_no=@VehicleNo " &
                                                "WHERE driver_id=@DriverId"
                    Using cmd As New SqlCommand(updateQuery, conn)
                        cmd.Parameters.AddWithValue("@Name", name)
                        cmd.Parameters.AddWithValue("@Phone", phone)
                        cmd.Parameters.AddWithValue("@Password", password)
                        cmd.Parameters.AddWithValue("@VehicleNo", vehicleNo)
                        cmd.Parameters.AddWithValue("@DriverId", Convert.ToInt32(driverId))
                        cmd.ExecuteNonQuery()
                    End Using
                    ShowMessage("✅ Driver updated successfully!", True)
                End If

                conn.Close()
            End Using

            ResetForm()
            LoadDriverStats()
            LoadDrivers()
        End If
    End Sub

    Protected Sub rptDrivers_ItemCommand(ByVal source As Object, ByVal e As RepeaterCommandEventArgs)
        Dim driverId As Integer = Convert.ToInt32(e.CommandArgument)

        If e.CommandName = "EditDriver" Then
            Using conn As New SqlConnection(connString)
                Dim query As String = "SELECT driver_id, driver_name, phone, password, vehicle_no FROM Drivers WHERE driver_id=@DriverId"
                Using cmd As New SqlCommand(query, conn)
                    cmd.Parameters.AddWithValue("@DriverId", driverId)
                    conn.Open()
                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        If reader.Read() Then
                            hfDriverId.Value = reader("driver_id").ToString()
                            txtDriverName.Text = reader("driver_name").ToString()
                            txtPhone.Text = reader("phone").ToString()
                            txtPassword.Text = reader("password").ToString()
                            txtVehicleNo.Text = reader("vehicle_no").ToString()
                            litFormTitle.Text = "✏️ Edit Delivery Partner Details"
                            btnSaveDriver.Text = "💾 Update Driver"
                        End If
                    End Using
                    conn.Close()
                End Using
            End Using
        ElseIf e.CommandName = "ToggleStatus" Then
            Using conn As New SqlConnection(connString)
                Dim query As String = "UPDATE Drivers SET status = CASE WHEN status = 'Inactive' THEN 'Available' ELSE 'Inactive' END WHERE driver_id=@DriverId"
                Using cmd As New SqlCommand(query, conn)
                    cmd.Parameters.AddWithValue("@DriverId", driverId)
                    conn.Open()
                    cmd.ExecuteNonQuery()
                    conn.Close()
                End Using
            End Using
            ShowMessage("Status updated successfully!", True)
            LoadDriverStats()
            LoadDrivers()
        End If
    End Sub

    Protected Sub btnCancelDriver_Click(ByVal sender As Object, ByVal e As EventArgs)
        ResetForm()
    End Sub

    Private Sub ResetForm()
        hfDriverId.Value = ""
        txtDriverName.Text = ""
        txtPhone.Text = ""
        txtPassword.Text = ""
        txtVehicleNo.Text = ""
        litFormTitle.Text = "➕ Register New Delivery Partner"
        btnSaveDriver.Text = "💾 Save Driver"
    End Sub

    Protected Function GetStatusCss(ByVal status As String) As String
        Select Case status.ToLower()
            Case "available"
                Return "status-available"
            Case "on delivery"
                Return "status-ondelivery"
            Case "offline"
                Return "status-offline"
            Case Else
                Return "status-inactive"
        End Select
    End Function

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
