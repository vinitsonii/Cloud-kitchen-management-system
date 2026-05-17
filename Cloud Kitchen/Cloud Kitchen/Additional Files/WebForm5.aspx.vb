Imports System.Data.SqlClient

Public Class WebForm5
    Inherits System.Web.UI.Page

    ' Connection string from Web.config
    Dim connStr As String = ConfigurationManager.ConnectionStrings("constr").ConnectionString

    ' Runs when the page loads
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            BindCategories()
        End If
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

    ' Handle Edit and Delete commands from Repeater
    Protected Sub rptcat_ItemCommand(ByVal sender As Object, ByVal e As RepeaterCommandEventArgs)
        Try
            Dim categoryId As Integer = Convert.ToInt32(e.CommandArgument)

            If e.CommandName = "EditCategory" Then
                ' Fetch category data for editing
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
                ' Delete category
                Using conn As New SqlConnection(connStr)
                    Dim query As String = "DELETE FROM menu_category WHERE category_id = @categoryId"
                    Using cmd As New SqlCommand(query, conn)
                        cmd.Parameters.AddWithValue("@categoryId", categoryId)
                        conn.Open()
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

    Protected Sub ImageButton1_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImageButton1.Click
        txtCategoryName.Text = ""
        ddlCategoryStatus.SelectedIndex = 0
        hfCategoryId.Value = ""
        btnSave.Visible = True
        btnUpdate.Visible = False
        up1.Visible = True
        lblmsg.Text = ""
    End Sub

    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As EventArgs)
        up1.Visible = False
        ClearForm()
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

    ' Clear form fields
    Private Sub ClearForm()
        txtCategoryName.Text = ""
        ddlCategoryStatus.SelectedIndex = 0
        hfCategoryId.Value = ""
        btnSave.Visible = True
        btnUpdate.Visible = False
    End Sub
End Class
