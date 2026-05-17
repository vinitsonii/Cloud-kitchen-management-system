Imports System.Data.SqlClient
Imports System.Web.Script.Serialization

Public Class WebForm1
    Inherits System.Web.UI.Page

    Dim conn As String = ConfigurationManager.ConnectionStrings("constr").ConnectionString


    <System.Web.Services.WebMethod()>
    Public Shared Function GetMenuItems() As String
        Dim menuItems As New List(Of String)()

        Dim connString As String = ConfigurationManager.ConnectionStrings("constr").ConnectionString
        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT m_name FROM menu_item"
            Using cmd As New SqlCommand(query, conn)
                conn.Open()
                Dim reader As SqlDataReader = cmd.ExecuteReader()
                While reader.Read()
                    menuItems.Add(reader("m_name").ToString())
                End While
            End Using
        End Using

        Dim serializer As New JavaScriptSerializer()
        Return serializer.Serialize(menuItems)
    End Function

    Private Sub AutoFillUserData()
        If Session("c_id") IsNot Nothing Then
            Dim c_id As Integer = Convert.ToInt32(Session("c_id"))
            Dim query As String = "SELECT c_name, email FROM Customers WHERE c_id = @c_id"
            Dim con As New SqlConnection(conn)
            Using cmd As New SqlCommand(query, con)
                cmd.Parameters.AddWithValue("@c_id", c_id)
                con.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        txtName.Text = reader("c_name").ToString()
                        txtEmail.Text = reader("email").ToString()
                    End If
                End Using
                con.Close()
            End Using
        End If
    End Sub

    ' Handle form submission
    Protected Sub btnSubmit_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnSubmit.Click
        If Session("c_id") Is Nothing Then
            Response.Redirect("Login.aspx")
        End If
        If Page.IsValid Then
            Dim con As New SqlConnection(conn)
            Dim c_id As Object = If(Session("c_id") IsNot Nothing, Session("c_id"), DBNull.Value)
            Dim name As String = txtName.Text.Trim()
            Dim email As String = txtEmail.Text.Trim()
            Dim message As String = txtMessage.Text.Trim()

            Dim query As String = "INSERT INTO contact_messages (c_id, name, email, message) VALUES (@c_id, @name, @email, @message)"

            Using cmd As New SqlCommand(query, con)
                cmd.Parameters.AddWithValue("@c_id", c_id)
                cmd.Parameters.AddWithValue("@name", name)
                cmd.Parameters.AddWithValue("@email", email)
                cmd.Parameters.AddWithValue("@message", message)

                con.Open()
                cmd.ExecuteNonQuery()
                con.Close()
            End Using

            txtMessage.Text = ""

            Label1.Text = "Message Sent Successfully!"
        End If
    End Sub
    Protected Sub LoadReadMessages()
        Dim query As String = "SELECT name, message FROM contact_messages WHERE status = 1 ORDER BY submitted_at DESC"

        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("constr").ConnectionString)
            Using cmd As New SqlCommand(query, conn)
                conn.Open()
                rptReadMessages.DataSource = cmd.ExecuteReader()
                rptReadMessages.DataBind()
                conn.Close()
            End Using
        End Using
    End Sub
    Private Sub Loadfeatured()
        Try
            Using con As New SqlConnection(conn)
                ' Base query
                Dim query As String = "SELECT * FROM menu_item where m_featured = 1"


                Dim cmd As New SqlCommand(query, con)

                con.Open()
                rptFeatured.DataSource = cmd.ExecuteReader()
                rptFeatured.DataBind()
            End Using
        Catch ex As Exception
            Response.Write("<script>alert('Error loading menu items!');</script>")
        End Try
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Loadfeatured()
        AutoFillUserData()
        LoadReadMessages()
    End Sub

    Protected Sub btnSearch_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnSearch.Click
        Dim searchQuery As String = hiddenSearch.Value.Trim()

        If Not String.IsNullOrEmpty(searchQuery) Then
            Response.Redirect("Menu.aspx?search=" & Server.UrlEncode(searchQuery))
        End If
    End Sub


End Class