Imports System.Data.SqlClient

Public Class DriverLogin
    Inherits System.Web.UI.Page

    Private connString As String = ConfigurationManager.ConnectionStrings("constr").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            If Session("DriverId") IsNot Nothing Then
                Response.Redirect("DriverPortal.aspx")
            End If
        End If
    End Sub

    Protected Sub btnLogin_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim phone As String = txtPhone.Text.Trim()
        Dim password As String = txtPassword.Text.Trim()

        If String.IsNullOrEmpty(phone) OrElse String.IsNullOrEmpty(password) Then
            lblMsg.Text = "Please enter both Phone Number and Password."
            lblMsg.Visible = True
            Exit Sub
        End If

        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT driver_id, driver_name, vehicle_no, status FROM Drivers WHERE phone = @Phone AND password = @Password"
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@Phone", phone)
                cmd.Parameters.AddWithValue("@Password", password)
                conn.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        Session("DriverId") = reader("driver_id")
                        Session("DriverName") = reader("driver_name")
                        Session("DriverVehicle") = reader("vehicle_no")
                        Response.Redirect("DriverPortal.aspx")
                    Else
                        lblMsg.Text = "❌ Invalid Phone Number or Password."
                        lblMsg.Visible = True
                    End If
                End Using
                conn.Close()
            End Using
        End Using
    End Sub
End Class
