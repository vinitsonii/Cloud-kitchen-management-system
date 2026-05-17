Imports System.Data.SqlClient

Public Class WebForm6
    Inherits System.Web.UI.Page

    Dim connStr As String = ConfigurationManager.ConnectionStrings("constr").ConnectionString

    ' Page Load
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            BindCuisines()
        End If
    End Sub

    ' Bind Cuisines to Repeater
    Private Sub BindCuisines()
        Dim query As String = "SELECT * FROM cuisine_type"
        Using conn As New SqlConnection(connStr)
            Using cmd As New SqlCommand(query, conn)
                conn.Open()
                Dim reader As SqlDataReader = cmd.ExecuteReader()
                rptcuisine.DataSource = reader
                rptcuisine.DataBind()
            End Using
        End Using
    End Sub

    ' Open Add Cuisine Panel
    Protected Sub ImageButton2_Click(ByVal sender As Object, ByVal e As ImageClickEventArgs) Handles ImageButton2.Click
        up2.Visible = True
        btnSave2.Visible = True
        btnUpdate2.Visible = False
        txtCuisineName.Text = ""
        ddlCuisineStatus.SelectedIndex = 0
    End Sub

    ' Save New Cuisine
    Protected Sub btnSave2_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnSave2.Click
        Dim cuisineName As String = txtCuisineName.Text.Trim()
        Dim cuisineStatus As Boolean = ddlCuisineStatus.SelectedValue = "1"



        Dim query As String = "INSERT INTO cuisine_type (cuisine_name, cuisine_status) VALUES (@name, @status)"
        Using conn As New SqlConnection(connStr)
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@name", cuisineName)
                cmd.Parameters.AddWithValue("@status", cuisineStatus)
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using

        lblmsg2.Text = "Cuisine added successfully!"
        BindCuisines()
    End Sub

    ' Update Cuisine
    Protected Sub btnUpdate2_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnUpdate2.Click
        Dim cuisineId As Integer = Convert.ToInt32(hfCuisineId.Value)
        Dim cuisineName As String = txtCuisineName.Text.Trim()
        Dim cuisineStatus As Boolean = ddlCuisineStatus.SelectedValue = "1"

        If String.IsNullOrEmpty(cuisineName) Then
            lblmsg2.Text = "Cuisine name cannot be empty."
            Return
        End If

        Dim query As String = "UPDATE cuisine_type SET cuisine_name = @name, cuisine_status = @status WHERE cuisine_id = @id"
        Using conn As New SqlConnection(connStr)
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@id", cuisineId)
                cmd.Parameters.AddWithValue("@name", cuisineName)
                cmd.Parameters.AddWithValue("@status", cuisineStatus)
                conn.Open()
                cmd.ExecuteNonQuery()
            End Using
        End Using

        lblmsg2.Text = "Cuisine updated successfully!"
        BindCuisines()
    End Sub

    ' Cancel Button
    Protected Sub btnCancel2_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancel2.Click
        up2.Visible = False
        txtCuisineName.Text = ""
        ddlCuisineStatus.SelectedIndex = 0
    End Sub

    ' Handle Edit & Delete Commands
    Protected Sub rptcuisine_ItemCommand(ByVal sender As Object, ByVal e As RepeaterCommandEventArgs) Handles rptcuisine.ItemCommand
        Dim cuisineId As Integer = Convert.ToInt32(e.CommandArgument)

        If e.CommandName = "EditCuisine" Then
            Dim query As String = "SELECT * FROM cuisine_type WHERE cuisine_id = @id"
            Using conn As New SqlConnection(connStr)
                Using cmd As New SqlCommand(query, conn)
                    cmd.Parameters.AddWithValue("@id", cuisineId)
                    conn.Open()
                    Dim reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.HasRows Then
                        reader.Read()
                        hfCuisineId.Value = reader("cuisine_id").ToString()
                        txtCuisineName.Text = reader("cuisine_name").ToString()
                        ddlCuisineStatus.SelectedValue = If(reader("cuisine_status"), "1", "0")
                        btnSave2.Visible = False
                        btnUpdate2.Visible = True
                        up2.Visible = True
                    End If
                End Using
            End Using

        ElseIf e.CommandName = "DeleteCuisineName" Then
            Dim query As String = "DELETE FROM cuisine_type WHERE cuisine_id = @id"
            Using conn As New SqlConnection(connStr)
                Using cmd As New SqlCommand(query, conn)
                    cmd.Parameters.AddWithValue("@id", cuisineId)
                    conn.Open()
                    cmd.ExecuteNonQuery()
                End Using
            End Using

            lblmsg2.Text = "Cuisine deleted successfully!"
            BindCuisines()
        End If
    End Sub
End Class
