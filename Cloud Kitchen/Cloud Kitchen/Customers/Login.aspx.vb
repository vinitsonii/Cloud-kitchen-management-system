Imports System.Data.SqlClient
Imports System.Security.Cryptography
Imports System.Text
Imports System
Imports System.Web

Public Class WebForm3
    Inherits System.Web.UI.Page

    ' Database connection string
    Dim connString As String = ConfigurationManager.ConnectionStrings("constr").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        lblmsg.Text = ""
        If Not IsPostBack Then
            ' Retrieve saved email from cookies (if exists)
            If Request.Cookies("UserEmail") IsNot Nothing Then
                txtLoginEmail.Text = Request.Cookies("UserEmail").Value
            End If

            ' Retrieve saved password from cookies (if exists)
            If Request.Cookies("UserPass") IsNot Nothing Then
                txtLoginPass.Attributes("value") = Request.Cookies("UserPass").Value
                chkRememberMe.Checked = True
            End If
        End If
    End Sub

    Protected Sub btnLogin_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLogin.Click
        Dim email As String = txtLoginEmail.Text.Trim()
        Dim password As String = txtLoginPass.Text.Trim()

        Try
            If email = "yourmail" And password = "pass" Then
                Session("UserEmail") = email
                If chkRememberMe.Checked Then
                    SetPersistentCookie("UserEmail", email, 30)
                    SetPersistentCookie("UserPass", password, 30)
                Else
                    RemoveCookie("UserEmail")
                    RemoveCookie("UserPass")
                End If
                Response.Redirect("../Admin/Dashboard.aspx")
            Else
                If AuthenticateUser(email, password) Then
                    Session("UserEmail") = email
                    Response.Redirect("Home.aspx")
                Else
                    lblmsg.Text = "Invalid email or password."
                    lblmsg.ForeColor = System.Drawing.Color.Red
                End If
            End If
        Catch ex As Exception
            lblmsg.Text = "An error occurred: " & ex.Message
            lblmsg.ForeColor = System.Drawing.Color.Red
        End Try
    End Sub

    Private Function AuthenticateUser(ByVal email As String, ByVal password As String) As Boolean
        Dim query As String = "SELECT * FROM Customers WHERE email = @Email"

        Using conn As New SqlConnection(connString)
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@Email", email)

                Try
                    conn.Open()
                    Dim reader As SqlDataReader = cmd.ExecuteReader()

                    If reader.Read() Then
                        Dim storedHashedPassword As String = reader("password").ToString()
                        Dim customerId As Integer = Convert.ToInt32(reader("c_id"))

                        If VerifyPassword(password, storedHashedPassword) Then
                            Session("c_id") = customerId
                            Session("c_name") = reader("c_name").ToString()
                            If chkRememberMe.Checked Then
                                SetPersistentCookie("UserEmail", email, 30)
                                SetPersistentCookie("UserPass", password, 30)
                            Else
                                RemoveCookie("UserEmail")
                                RemoveCookie("UserPass")
                            End If
                            Return True
                        End If
                    End If
                Catch ex As Exception
                    lblmsg.Text = "Error: " & ex.Message
                    lblmsg.ForeColor = System.Drawing.Color.Red
                End Try
            End Using
        End Using

        Return False
    End Function
    Private Sub SetPersistentCookie(ByVal name As String, ByVal value As String, ByVal days As Integer)
        Dim userCookie As New HttpCookie(name, value)
        userCookie.Expires = DateTime.Now.AddDays(days)
        userCookie.HttpOnly = True
        Response.Cookies.Add(userCookie)
    End Sub

    Private Sub RemoveCookie(ByVal name As String)
        If Request.Cookies(name) IsNot Nothing Then
            Dim userCookie As New HttpCookie(name)
            userCookie.Expires = DateTime.Now.AddDays(-1)
            Response.Cookies.Add(userCookie)
        End If
    End Sub


    Private Function VerifyPassword(ByVal enteredPassword As String, ByVal storedHashedPassword As String) As Boolean
        Dim hashedEnteredPassword As String = HashPassword(enteredPassword)
        Return String.Equals(hashedEnteredPassword, storedHashedPassword)
    End Function

    Private Function HashPassword(ByVal password As String) As String
        Using sha256 As SHA256 = SHA256.Create()
            Dim bytes As Byte() = Encoding.UTF8.GetBytes(password)
            Dim hashBytes As Byte() = sha256.ComputeHash(bytes)
            Return Convert.ToBase64String(hashBytes)
        End Using
    End Function
End Class
