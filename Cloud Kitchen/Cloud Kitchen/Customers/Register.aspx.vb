Imports System.Data.SqlClient
Imports System.Security.Cryptography
Imports System.Text

Public Class WebForm4
    Inherits System.Web.UI.Page

    Dim connString As String = ConfigurationManager.ConnectionStrings("constr").ConnectionString

   Protected Sub btnRegister_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnRegister.Click
        Dim fullName As String = txtFullName.Text.Trim()
        Dim email As String = txtEmail.Text.Trim()
        Dim phone As String = txtCountryCode.Text.Trim() & txtPhone.Text.Trim()
        Dim password As String = txtPassword.Text.Trim()

        If String.IsNullOrEmpty(fullName) OrElse String.IsNullOrEmpty(email) OrElse String.IsNullOrEmpty(phone) OrElse String.IsNullOrEmpty(password) Then
            lblmsg.Text = "All fields are required."
            lblmsg.ForeColor = System.Drawing.Color.Red
            Return
        End If

        If IsEmailExists(email) Then
            lblEmailError.Text = "❌ Email already registered."
            lblEmailError.ForeColor = System.Drawing.Color.Red
            Return
        ElseIf IsPhoneExists(phone) Then
            lblPhoneError.Text = "❌ Phone number already registered."
            lblPhoneError.ForeColor = System.Drawing.Color.Red
            Return
        End If


        Dim hashedPassword As String = HashPassword(password)
        Dim query As String = "INSERT INTO Customers (c_name, email, phone, password) VALUES (@FullName, @Email, @Phone, @Password)"

        Using conn As New SqlConnection(connString)
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@FullName", fullName)
                cmd.Parameters.AddWithValue("@Email", email)
                cmd.Parameters.AddWithValue("@Phone", phone)
                cmd.Parameters.AddWithValue("@Password", hashedPassword)


                Try
                    conn.Open()
                    cmd.ExecuteNonQuery()
                    ShowMessage("✅ " & fullName & " You can now log in.", True)

                Catch ex As Exception
                    lblmsg.Text = "Error: " & ex.Message
                    lblmsg.ForeColor = System.Drawing.Color.Red
                End Try
            End Using
        End Using
    End Sub


    Protected Sub txtEmail_TextChanged(ByVal sender As Object, ByVal e As EventArgs) Handles txtEmail.TextChanged
        Dim email As String = txtEmail.Text.Trim()
        If Not String.IsNullOrEmpty(email) AndAlso IsEmailExists(email) Then
            lblEmailError.Text = "❌ Email already registered."
            lblEmailError.ForeColor = System.Drawing.Color.Red
        Else
            lblEmailError.Text = ""
        End If
    End Sub

    Protected Sub txtPhone_TextChanged(ByVal sender As Object, ByVal e As EventArgs) Handles txtPhone.TextChanged
        Dim phone As String = txtCountryCode.Text.Trim() & txtPhone.Text.Trim()
        If txtPhone.Text.Length = 10 Then
            If Not String.IsNullOrEmpty(phone) AndAlso IsPhoneExists(phone) Then
                lblPhoneError.Text = "❌ Phone number already registered."
                lblPhoneError.ForeColor = System.Drawing.Color.Red
            Else
                lblPhoneError.Text = ""
            End If
        Else
            lblPhoneError.Text = "❌ Phone number must be 10 digit."
            lblPhoneError.ForeColor = System.Drawing.Color.Red
        End If
    End Sub

    Private Function IsEmailExists(ByVal email As String) As Boolean
        Dim exists As Boolean = False
        Dim query As String = "SELECT COUNT(*) FROM Customers WHERE email = @Email"

        Using conn As New SqlConnection(connString)
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@Email", email)

                Try
                    conn.Open()
                    Dim count As Integer = Convert.ToInt32(cmd.ExecuteScalar())
                    If count > 0 Then exists = True
                Catch ex As Exception
                    lblmsg.Text = "Error: " & ex.Message
                    lblmsg.ForeColor = System.Drawing.Color.Red
                End Try
            End Using
        End Using

        Return exists
    End Function

    Private Function IsPhoneExists(ByVal phone As String) As Boolean
        Dim exists As Boolean = False
        Dim query As String = "SELECT COUNT(*) FROM Customers WHERE phone = @Phone"

        Using conn As New SqlConnection(connString)
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@Phone", phone)

                Try
                    conn.Open()
                    Dim count As Integer = Convert.ToInt32(cmd.ExecuteScalar())
                    If count > 0 Then exists = True
                Catch ex As Exception
                    lblmsg.Text = "Error: " & ex.Message
                    lblmsg.ForeColor = System.Drawing.Color.Red
                End Try
            End Using
        End Using

        Return exists
    End Function

    Private Function HashPassword(ByVal password As String) As String
        Using sha256 As SHA256 = SHA256.Create()
            Dim bytes As Byte() = Encoding.UTF8.GetBytes(password)
            Dim hashBytes As Byte() = sha256.ComputeHash(bytes)
            Return Convert.ToBase64String(hashBytes)
        End Using
    End Function
    Private Sub ShowMessage(ByVal message As String, ByVal isSuccess As Boolean)
        lblmsg1.Text = message
        lblmsg1.ForeColor = If(isSuccess, System.Drawing.Color.Green, System.Drawing.Color.Red)
        pnlmsg.Visible = True
        overlay.Style("display") = "block"
    End Sub



End Class
