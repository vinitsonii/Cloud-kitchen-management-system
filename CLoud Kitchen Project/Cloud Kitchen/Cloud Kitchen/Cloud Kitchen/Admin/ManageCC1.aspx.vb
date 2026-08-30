Imports System.Data
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

    ' Helper for Status Badge formatting
    Protected Function GetStatusBadge(ByVal statusObj As Object) As String
        If statusObj Is Nothing OrElse Convert.IsDBNull(statusObj) Then
            Return "<span style='padding: 4px 10px; border-radius: 20px; background: #f1f5f9; color: #64748b; font-weight: 700; font-size: 12px;'>Unknown</span>"
        End If
        Dim statusStr As String = statusObj.ToString().Trim()
        If statusStr = "1" OrElse statusStr.Equals("True", StringComparison.OrdinalIgnoreCase) OrElse statusStr.Equals("Active", StringComparison.OrdinalIgnoreCase) Then
            Return "<span style='padding: 4px 12px; border-radius: 20px; background: #dcfce7; color: #166534; font-weight: 700; font-size: 12px;'>🟢 Active</span>"
        Else
            Return "<span style='padding: 4px 12px; border-radius: 20px; background: #fee2e2; color: #991b1b; font-weight: 700; font-size: 12px;'>🔴 Inactive</span>"
        End If
    End Function

    ' Tab Navigation Handlers
    Protected Sub btnTabCategory_Click(ByVal sender As Object, ByVal e As EventArgs)
        up1.Visible = True
        up2.Visible = False
        btnTabCategory.CssClass = "tab-btn active"
        btnTabCuisine.CssClass = "tab-btn"
        lblmsg.Text = ""
        lblmsg2.Text = ""
    End Sub

    Protected Sub btnTabCuisine_Click(ByVal sender As Object, ByVal e As EventArgs)
        up1.Visible = False
        up2.Visible = True
        btnTabCategory.CssClass = "tab-btn"
        btnTabCuisine.CssClass = "tab-btn active"
        lblmsg.Text = ""
        lblmsg2.Text = ""
    End Sub

    ' Search Box Handlers
    Protected Sub txtSearchCat_TextChanged(ByVal sender As Object, ByVal e As EventArgs)
        BindCategories()
    End Sub

    Protected Sub txtSearchCuisine_TextChanged(ByVal sender As Object, ByVal e As EventArgs)
        BindCuisines()
    End Sub

    Private Sub BindCategories()
        Try
            Dim search As String = txtSearchCat.Text.Trim()
            Using conn As New SqlConnection(connStr)
                Dim query As String = "SELECT * FROM menu_category"
                If Not String.IsNullOrEmpty(search) Then
                    query &= " WHERE category_name LIKE @Search"
                End If
                query &= " ORDER BY category_name ASC"

                Using cmd As New SqlCommand(query, conn)
                    If Not String.IsNullOrEmpty(search) Then
                        cmd.Parameters.AddWithValue("@Search", "%" & search & "%")
                    End If
                    conn.Open()
                    Dim dt As New DataTable()
                    Using adapter As New SqlDataAdapter(cmd)
                        adapter.Fill(dt)
                    End Using

                    rptcat.DataSource = dt
                    rptcat.DataBind()
                    pnlNoCat.Visible = (dt.Rows.Count = 0)
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
                            litCategoryFormTitle.Text = "✏️ Edit Food Category"
                            btnSave.Visible = False
                            btnUpdate.Visible = True
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

                lblmsg.ForeColor = Drawing.Color.DarkGreen
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
            If String.IsNullOrEmpty(txtCategoryName.Text.Trim()) Then
                lblmsg.ForeColor = Drawing.Color.Red
                lblmsg.Text = "Category name is required."
                Return
            End If

            Using conn As New SqlConnection(connStr)
                Dim query As String = "INSERT INTO menu_category (category_name, category_status) VALUES (@categoryName, @categoryStatus)"
                Using cmd As New SqlCommand(query, conn)
                    cmd.Parameters.AddWithValue("@categoryName", txtCategoryName.Text.Trim())
                    cmd.Parameters.AddWithValue("@categoryStatus", ddlCategoryStatus.SelectedValue)
                    conn.Open()
                    cmd.ExecuteNonQuery()
                End Using
            End Using
            lblmsg.ForeColor = Drawing.Color.DarkGreen
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
            If String.IsNullOrEmpty(hfCategoryId.Value) Then Return
            Dim categoryId As Integer = Convert.ToInt32(hfCategoryId.Value)

            If String.IsNullOrEmpty(txtCategoryName.Text.Trim()) Then
                lblmsg.ForeColor = Drawing.Color.Red
                lblmsg.Text = "Category name is required."
                Return
            End If

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
            lblmsg.ForeColor = Drawing.Color.DarkGreen
            lblmsg.Text = "Category updated successfully."
            ClearForm()
            BindCategories()
        Catch ex As Exception
            lblmsg.ForeColor = Drawing.Color.Red
            lblmsg.Text = "Error: " & ex.Message
        End Try
    End Sub

    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancel.Click
        ClearForm()
    End Sub

    Private Sub ClearForm()
        txtCategoryName.Text = ""
        ddlCategoryStatus.SelectedIndex = 0
        hfCategoryId.Value = ""
        litCategoryFormTitle.Text = "➕ Add New Food Category"
        btnSave.Visible = True
        btnUpdate.Visible = False

        txtCuisineName.Text = ""
        hfCuisineId.Value = ""
        litCuisineFormTitle.Text = "➕ Add New Cuisine Type"
        btnSave2.Visible = True
        btnUpdate2.Visible = False
        ddlCuisineStatus.SelectedIndex = 0
    End Sub

    Private Sub BindCuisines()
        Try
            Dim search As String = txtSearchCuisine.Text.Trim()
            Using conn As New SqlConnection(connStr)
                Dim query As String = "SELECT * FROM cuisine_type"
                If Not String.IsNullOrEmpty(search) Then
                    query &= " WHERE cuisine_name LIKE @Search"
                End If
                query &= " ORDER BY cuisine_name ASC"

                Using cmd As New SqlCommand(query, conn)
                    If Not String.IsNullOrEmpty(search) Then
                        cmd.Parameters.AddWithValue("@Search", "%" & search & "%")
                    End If
                    conn.Open()
                    Dim dt As New DataTable()
                    Using adapter As New SqlDataAdapter(cmd)
                        adapter.Fill(dt)
                    End Using

                    rptcuisine.DataSource = dt
                    rptcuisine.DataBind()
                    pnlNoCuisine.Visible = (dt.Rows.Count = 0)
                End Using
            End Using
        Catch ex As Exception
            lblmsg2.ForeColor = Drawing.Color.Red
            lblmsg2.Text = "Error: " & ex.Message
        End Try
    End Sub

    Protected Sub btnSave2_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnSave2.Click
        Try
            Dim cuisineName As String = txtCuisineName.Text.Trim()
            If String.IsNullOrEmpty(cuisineName) Then
                lblmsg2.ForeColor = Drawing.Color.Red
                lblmsg2.Text = "Cuisine name is required."
                Return
            End If

            Dim cuisineStatus As String = ddlCuisineStatus.SelectedValue
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
            lblmsg2.ForeColor = Drawing.Color.DarkGreen
            ClearForm()
            BindCuisines()
        Catch ex As Exception
            lblmsg2.ForeColor = Drawing.Color.Red
            lblmsg2.Text = "Error: " & ex.Message
        End Try
    End Sub

    Protected Sub btnUpdate2_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnUpdate2.Click
        Try
            If String.IsNullOrEmpty(hfCuisineId.Value) Then Return
            Dim cuisineId As Integer = Convert.ToInt32(hfCuisineId.Value)
            Dim cuisineName As String = txtCuisineName.Text.Trim()
            Dim cuisineStatus As String = ddlCuisineStatus.SelectedValue

            If String.IsNullOrEmpty(cuisineName) Then
                lblmsg2.ForeColor = Drawing.Color.Red
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
            lblmsg2.ForeColor = Drawing.Color.DarkGreen
            ClearForm()
            BindCuisines()
        Catch ex As Exception
            lblmsg2.ForeColor = Drawing.Color.Red
            lblmsg2.Text = "Error: " & ex.Message
        End Try
    End Sub

    Protected Sub btnCancel2_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancel2.Click
        ClearForm()
    End Sub

    Protected Sub rptcuisine_ItemCommand(ByVal sender As Object, ByVal e As RepeaterCommandEventArgs) Handles rptcuisine.ItemCommand
        Try
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
                            ddlCuisineStatus.SelectedValue = If(reader("cuisine_status").ToString() = "True" OrElse reader("cuisine_status").ToString() = "1", "1", "0")
                            litCuisineFormTitle.Text = "✏️ Edit Cuisine Type"
                            btnSave2.Visible = False
                            btnUpdate2.Visible = True
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

                lblmsg2.ForeColor = Drawing.Color.DarkGreen
                lblmsg2.Text = "Cuisine deleted successfully."
                BindCuisines()
            End If
        Catch ex As Exception
            lblmsg2.ForeColor = Drawing.Color.Red
            lblmsg2.Text = "Error: " & ex.Message
        End Try
    End Sub

End Class