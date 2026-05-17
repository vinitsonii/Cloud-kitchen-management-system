Imports System.Data.SqlClient

Public Class WebForm9
    Inherits System.Web.UI.Page

    Dim connStr As String = ConfigurationManager.ConnectionStrings("constr").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            BindCategories()
            BindCuisines()
        End If
    End Sub

    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancel.Click
        ClearForm()
    End Sub

    Private Sub Button2_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        ClearForm()
    End Sub

    Private Sub BindCategories()
        Try
            Using conn As New SqlConnection(connStr)
                Dim query As String = "SELECT * FROM menu_category"
                Using cmd As New SqlCommand(query, conn)
                    conn.Open()
                    rptcat.DataSource = cmd.ExecuteReader()
                    rptcat.DataBind()
                End Using
            End Using
        Catch ex As Exception
            lblmsg.ForeColor = Drawing.Color.Red
            lblmsg.Text = "Error: " & ex.Message
        End Try
    End Sub

    Protected Sub rptcat_ItemCommand(ByVal sender As Object, ByVal e As RepeaterCommandEventArgs)
        Try
            Dim categoryId As Integer = Convert.ToInt32(e.CommandArgument)

            If e.CommandName = "EditCategory" Then
                Using conn As New SqlConnection(connStr)
                    Dim query As String = "SELECT * FROM menu_category WHERE category_id = @categoryId"
                    Using cmd As New SqlCommand(query, conn)
                        cmd.Parameters.AddWithValue("@categoryId", categoryId)
                        conn.Open()
                        Dim reader As SqlDataReader = cmd.ExecuteReader()
                        If reader.HasRows Then
                            reader.Read()
                            txtCategoryName.Text = reader("category_name").ToString()
                            ddlCategoryStatus.SelectedValue = reader("category_status").ToString()
                            hfCategoryId.Value = categoryId.ToString()
                            btnSave.Visible = False
                            btnUpdate.Visible = True
                            up1.Visible = True
                        End If
                    End Using
                End Using

            ElseIf e.CommandName = "DeleteCategory" Then
                Dim countQuery As String = "SELECT COUNT(*) FROM menu_item WHERE m_category_id = @categoryId"
                Dim deleteQuery As String = "DELETE FROM menu_category WHERE category_id = @categoryId"

                Using conn As New SqlConnection(connStr)
                    Using cmd As New SqlCommand(countQuery, conn)
                        cmd.Parameters.AddWithValue("@categoryId", categoryId)
                        conn.Open()
                        Dim itemCount As Integer = Convert.ToInt32(cmd.ExecuteScalar())

                        If itemCount > 0 Then
                            lblmsg.ForeColor = Drawing.Color.Red
                            lblmsg.Text = "Cannot delete category. Menu items exist under this category."
                            Exit Sub
                        End If
                    End Using

                    Using cmd As New SqlCommand(deleteQuery, conn)
                        cmd.Parameters.AddWithValue("@categoryId", categoryId)
                        cmd.ExecuteNonQuery()
                    End Using
                End Using

                lblmsg.ForeColor = Drawing.Color.Green
                lblmsg.Text = "Category deleted successfully."
                BindCategories()
            End If


        Catch ex As Exception
            lblmsg.ForeColor = Drawing.Color.Red
            lblmsg.Text = "Error: " & ex.Message
        End Try
    End Sub


    Protected Sub btnSave_Click(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Using conn As New SqlConnection(connStr)
                Dim query As String = "INSERT INTO menu_category (category_name, category_status) VALUES (@categoryName, @categoryStatus)"
                Using cmd As New SqlCommand(query, conn)
                    cmd.Parameters.AddWithValue("@categoryName", txtCategoryName.Text.Trim())
                    cmd.Parameters.AddWithValue("@categoryStatus", ddlCategoryStatus.SelectedValue)
                    conn.Open()
                    cmd.ExecuteNonQuery()
                End Using
            End Using
            lblmsg.ForeColor = Drawing.Color.Green
            lblmsg.Text = "Category added successfully."
            ClearForm()
            BindCategories()
        Catch ex As Exception
            lblmsg.ForeColor = Drawing.Color.Red
            lblmsg.Text = "Error: " & ex.Message
        End Try
    End Sub

    Protected Sub btnUpdate_Click(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim categoryId As Integer = Convert.ToInt32(hfCategoryId.Value)

            Using conn As New SqlConnection(connStr)
                Dim query As String = "UPDATE menu_category SET category_name = @categoryName, category_status = @categoryStatus WHERE category_id = @categoryId"
                Using cmd As New SqlCommand(query, conn)
                    cmd.Parameters.AddWithValue("@categoryName", txtCategoryName.Text.Trim())
                    cmd.Parameters.AddWithValue("@categoryStatus", ddlCategoryStatus.SelectedValue)
                    cmd.Parameters.AddWithValue("@categoryId", categoryId)
                    conn.Open()
                    cmd.ExecuteNonQuery()
                End Using
            End Using
            lblmsg.ForeColor = Drawing.Color.Green
            lblmsg.Text = "Category updated successfully."
            ClearForm()
            BindCategories()
        Catch ex As Exception
            lblmsg.ForeColor = Drawing.Color.Red
            lblmsg.Text = "Error: " & ex.Message
        End Try
    End Sub



    Private Sub ClearForm()
        txtCategoryName.Text = ""
        ddlCategoryStatus.SelectedIndex = 0
        hfCategoryId.Value = ""
        btnSave.Visible = True
        btnUpdate.Visible = False

        txtCuisineName.Text = ""
        hfCuisineId.Value = ""
        btnSave2.Visible = True
        btnUpdate2.Visible = False
        ddlCuisineStatus.SelectedIndex = 0
    End Sub

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
        lblmsg2.ForeColor = System.Drawing.Color.Green
        BindCuisines()
    End Sub

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
        btnSave2.Visible = True
        btnUpdate2.Visible = False

        BindCuisines()
    End Sub

    Protected Sub btnCancel2_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancel2.Click
        ClearForm()
        ddlCuisineStatus.SelectedIndex = 0
    End Sub

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
            Dim countQuery As String = "SELECT COUNT(*) FROM menu_item WHERE m_cuisine_id = @id"
            Dim deleteQuery As String = "DELETE FROM cuisine_type WHERE cuisine_id = @id"

            Using conn As New SqlConnection(connStr)
                Using cmd As New SqlCommand(countQuery, conn)
                    cmd.Parameters.AddWithValue("@id", cuisineId)
                    conn.Open()
                    Dim itemCount As Integer = Convert.ToInt32(cmd.ExecuteScalar())

                    If itemCount > 0 Then
                        lblmsg2.ForeColor = Drawing.Color.Red
                        lblmsg2.Text = "Cannot delete cuisine. Menu items exist under this cuisine."
                        Exit Sub
                    End If
                End Using

                Using cmd As New SqlCommand(deleteQuery, conn)
                    cmd.Parameters.AddWithValue("@id", cuisineId)
                    cmd.ExecuteNonQuery()
                End Using
            End Using

            lblmsg2.ForeColor = Drawing.Color.Green
            lblmsg2.Text = "Cuisine deleted successfully."
            BindCuisines()
        End If

    End Sub

End Class