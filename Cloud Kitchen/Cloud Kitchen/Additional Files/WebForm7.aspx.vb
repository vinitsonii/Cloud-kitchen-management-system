Imports System.Data
Imports System.Data.SqlClient

Public Class WebForm7
    Inherits System.Web.UI.Page

    Private ReadOnly connString As String = ConfigurationManager.ConnectionStrings("constr").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            BindCategories3()
            BindCuisines3()
            BindMenuItems3()
            BindfltCategories3()
        End If
    End Sub

    Private Sub BindCategories3()
        Using conn As New SqlConnection(connString)
            Dim cmd As New SqlCommand("SELECT * FROM menu_category", conn)
            conn.Open()
            Dim rdr1 As SqlDataReader = cmd.ExecuteReader()
            ddlCategory3.DataSource = rdr1
            ddlCategory3.DataTextField = "category_name"
            ddlCategory3.DataValueField = "category_id"
            ddlCategory3.DataBind()

        End Using
    End Sub

    Private Sub BindfltCategories3()
        Using conn As New SqlConnection(connString)
            Dim cmd As New SqlCommand("SELECT * FROM menu_category", conn)
            conn.Open()
            Dim rdr As SqlDataReader = cmd.ExecuteReader()
            ddlFilterCategory.DataSource = rdr
            ddlFilterCategory.DataTextField = "category_name"
            ddlFilterCategory.DataValueField = "category_id"
            ddlFilterCategory.DataBind()

        End Using
    End Sub
    Private Sub BindCuisines3()
        Using conn As New SqlConnection(connString)
            Dim cmd As New SqlCommand("SELECT * FROM cuisine_type", conn)
            conn.Open()
            Dim rdr As SqlDataReader = cmd.ExecuteReader()
            ddlCuisine3.DataSource = rdr
            ddlCuisine3.DataTextField = "cuisine_name"
            ddlCuisine3.DataValueField = "cuisine_id"
            ddlCuisine3.DataBind()
        End Using
    End Sub

    Private Sub BindMenuItems3()
        Using conn As New SqlConnection(connString)
            Dim cmd As New SqlCommand("SELECT * FROM menu_item", conn)
            conn.Open()
            Dim rdr As SqlDataReader = cmd.ExecuteReader()
            rptMenuItems3.DataSource = rdr
            rptMenuItems3.DataBind()

        End Using
    End Sub

    Protected Sub btnSave3_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnSave3.Click
        Try
            Dim price As Decimal = 0
            Dim discount As Decimal = 0
            Dim finalPrice As Decimal = 0

            If Not Decimal.TryParse(txtPrice3.Text.Trim(), price) Then
                ClientScript.RegisterStartupScript(Me.GetType(), "Alert", "alert('Invalid Price');", True)
                Return
            End If

            If Not String.IsNullOrEmpty(txtDiscount3.Text.Trim()) Then
                Decimal.TryParse(txtDiscount3.Text.Trim(), discount)
            End If

            If Not String.IsNullOrEmpty(txtFinalPrice3.Text.Trim()) Then
                Decimal.TryParse(txtFinalPrice3.Text.Trim(), finalPrice)
            End If


            Dim filePath As String = ""

            If fuImage3.HasFile Then

                Dim fe As String = System.IO.Path.GetExtension(fuImage3.FileName)
                If fe.ToLower() <> ".jpg" AndAlso fe.ToLower() <> ".jpeg" Then
                    lblmsg3.ForeColor = System.Drawing.Color.Red
                    lblmsg3.Text = "Only .jpg or .jpeg files are allowed."
                Else
                    Dim fs As Integer = fuImage3.PostedFile.ContentLength
                    If fs > 2097152 Then
                        lblmsg3.ForeColor = System.Drawing.Color.Red
                        lblmsg3.Text = "Maximum file size 2MB Exceeded!"
                    Else
                        fuImage3.SaveAs(Server.MapPath("../Images/Menu/" & fuImage3.FileName))
                        filePath = "../Images/Menu/" & fuImage3.FileName
                    End If
                End If
            End If


            Dim query As String = "INSERT INTO menu_item (m_name, m_category_id, m_cuisine_id, m_description, m_price, m_discount, m_final_price, m_image_url, m_availability, m_featured, m_status) VALUES (@Name, @CategoryId, @CuisineId, @Description, @Price, @Discount, @FinalPrice, @ImageUrl, @Availability, @Featured, @Status)"

            Using conn As New SqlConnection(connString)
                Using cmd As New SqlCommand(query, conn)
                    cmd.Parameters.AddWithValue("@Name", txtItemName3.Text.Trim())
                    cmd.Parameters.AddWithValue("@CategoryId", ddlCategory3.SelectedValue)
                    cmd.Parameters.AddWithValue("@CuisineId", ddlCuisine3.SelectedValue)
                    cmd.Parameters.AddWithValue("@Description", txtDescription3.Text.Trim())
                    cmd.Parameters.AddWithValue("@Price", txtPrice3.Text)
                    cmd.Parameters.AddWithValue("@Discount", txtDiscount3.Text)
                    cmd.Parameters.AddWithValue("@FinalPrice", txtFinalPrice3.Text)
                    cmd.Parameters.AddWithValue("@ImageUrl", filePath)
                    cmd.Parameters.AddWithValue("@Availability", ddlAvailability3.SelectedValue)
                    cmd.Parameters.AddWithValue("@Featured", ddlFeatured3.SelectedValue)
                    cmd.Parameters.AddWithValue("@Status", ddlStatus3.SelectedValue)

                    conn.Open()
                    cmd.ExecuteNonQuery()

                End Using
            End Using

            BindMenuItems3()
            ClearForm3()
        Catch ex As Exception
            ClientScript.RegisterStartupScript(Me.GetType(), "Error", "alert('Error: " & ex.Message.Replace("'", "\'") & "');", True)
        End Try
    End Sub

    Protected Sub btnUpdate3_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnUpdate3.Click

        Dim filePath As String = ""
        If fuImage3.HasFile Then

            Dim fe As String = System.IO.Path.GetExtension(fuImage3.FileName)
            If fe.ToLower() <> ".jpg" AndAlso fe.ToLower() <> ".jpeg" AndAlso fe.ToLower() <> ".png" Then
                lblmsg3.ForeColor = System.Drawing.Color.Red
                lblmsg3.Text = "Only .jpg .png or .jpeg files are allowed."
            Else
                Dim fs As Integer = fuImage3.PostedFile.ContentLength
                If fs > 2097152 Then
                    lblmsg3.ForeColor = System.Drawing.Color.Red
                    lblmsg3.Text = "Maximum file size 2MB Exceeded!"
                Else
                    fuImage3.SaveAs(Server.MapPath("../Images/Menu/" & fuImage3.FileName))
                    filePath = "../Images/Menu/" & fuImage3.FileName
                    UpdateMenuItem(txtItemName3.Text, ddlCategory3.SelectedValue, ddlCuisine3.SelectedValue, txtDescription3.Text, Convert.ToDecimal(txtPrice3.Text), Convert.ToDecimal(txtDiscount3.Text), Convert.ToDecimal(txtFinalPrice3.Text), filePath, ddlAvailability3.SelectedValue, ddlFeatured3.SelectedValue, ddlStatus3.SelectedValue)

                End If
            End If
        Else

            UpdateMenuItem(txtItemName3.Text, ddlCategory3.SelectedValue, ddlCuisine3.SelectedValue, txtDescription3.Text, Convert.ToDecimal(txtPrice3.Text), Convert.ToDecimal(txtDiscount3.Text), Convert.ToDecimal(txtFinalPrice3.Text), fn.Value, ddlAvailability3.SelectedValue, ddlFeatured3.SelectedValue, ddlStatus3.SelectedValue)

        End If


        btnSave3.Visible = True
        btnUpdate3.Visible = False
        BindMenuItems3()
        ClearForm3()
    End Sub

    Private Sub UpdateMenuItem(ByVal name As String, ByVal categoryId As String, ByVal cuisineId As String, ByVal description As String, ByVal price As Decimal, ByVal discount As Decimal, ByVal finalPrice As Decimal, ByVal imageUrl As String, ByVal availability As String, ByVal featured As String, ByVal status As String)
        Using conn As New SqlConnection(connString)
            Dim cmd As New SqlCommand("UPDATE menu_item SET m_name = @Name, m_category_id = @CategoryId, m_cuisine_id = @CuisineId, m_description = @Description, m_price = @Price, m_discount = @Discount, m_final_price = @FinalPrice, m_image_url = @ImageUrl, m_availability = @Availability, m_featured = @Featured, m_status = @Status WHERE m_id = @MenuItemId", conn)
            cmd.Parameters.AddWithValue("@Name", name)
            cmd.Parameters.AddWithValue("@CategoryId", categoryId)
            cmd.Parameters.AddWithValue("@CuisineId", cuisineId)
            cmd.Parameters.AddWithValue("@Description", description)
            cmd.Parameters.AddWithValue("@Price", price)
            cmd.Parameters.AddWithValue("@Discount", discount)
            cmd.Parameters.AddWithValue("@FinalPrice", finalPrice)
            If imageUrl IsNot Nothing Then
                cmd.Parameters.AddWithValue("@ImageUrl", imageUrl)
            End If
            cmd.Parameters.AddWithValue("@Availability", availability)
            cmd.Parameters.AddWithValue("@Featured", featured)
            cmd.Parameters.AddWithValue("@Status", status)
            cmd.Parameters.AddWithValue("@MenuItemId", hfMenuItemId3.Value)

            conn.Open()
            cmd.ExecuteNonQuery()
        End Using
    End Sub

    Protected Sub rptMenuItems3_ItemCommand(ByVal sender As Object, ByVal e As RepeaterCommandEventArgs) Handles rptMenuItems3.ItemCommand
        If e.CommandName = "EditItem" Then
            Dim itemId As Integer = Convert.ToInt32(e.CommandArgument)

            Using conn As New SqlConnection(connString)
                Dim cmd As New SqlCommand("SELECT * FROM menu_item WHERE m_id = @MenuItemId", conn)
                cmd.Parameters.AddWithValue("@MenuItemId", itemId)

                conn.Open()
                Dim rdr As SqlDataReader = cmd.ExecuteReader()
                If rdr.Read() Then
                    hfMenuItemId3.Value = rdr("m_id").ToString()
                    txtItemName3.Text = rdr("m_name").ToString()
                    ddlCategory3.SelectedValue = rdr("m_category_id").ToString()
                    ddlCuisine3.SelectedValue = rdr("m_cuisine_id").ToString()
                    txtDescription3.Text = rdr("m_description").ToString()
                    txtPrice3.Text = rdr("m_price").ToString()
                    txtDiscount3.Text = rdr("m_discount").ToString()
                    txtFinalPrice3.Text = rdr("m_final_price").ToString()
                    ddlAvailability3.SelectedValue = rdr("m_availability").ToString()
                    ddlFeatured3.SelectedValue = rdr("m_featured")
                    ddlStatus3.SelectedValue = rdr("m_status")
                    fn.Value = rdr("m_image_url")
                End If
            End Using

            up3.Visible = True
            btnSave3.Visible = False
            btnUpdate3.Visible = True
        ElseIf e.CommandName = "DeleteItem" Then
            Dim itemId As Integer = Convert.ToInt32(e.CommandArgument)

            Using conn As New SqlConnection(connString)
                Dim cmd As New SqlCommand("DELETE FROM menu_item WHERE m_id = @MenuItemId", conn)

                cmd.Parameters.AddWithValue("@MenuItemId", itemId)

                conn.Open()
                cmd.ExecuteNonQuery()
            End Using

            ' up3.Visible = False
            btnSave3.Visible = True
            btnUpdate3.Visible = False

            lblmsg3.Text = "Menu item Deleted successfully!"
            lblmsg3.ForeColor = System.Drawing.Color.Blue

            BindMenuItems3()
        End If
    End Sub

    Private Sub ClearForm3()
        txtItemName3.Text = String.Empty
        txtDescription3.Text = String.Empty
        txtPrice3.Text = String.Empty
        txtDiscount3.Text = String.Empty
        txtFinalPrice3.Text = String.Empty
        ddlCategory3.SelectedIndex = -1
        ddlCuisine3.SelectedIndex = -1
        ddlAvailability3.SelectedIndex = -1
        ddlFeatured3.SelectedIndex = -1
        ddlStatus3.SelectedIndex = -1
        hfMenuItemId3.Value = String.Empty
        fn.Value = String.Empty
        btnSave3.Visible = True
        btnUpdate3.Visible = False
    End Sub

    Protected Sub btnCancel3_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancel3.Click
        ClearForm3()
        up3.Visible = False
    End Sub


    Private Sub ImageButton3_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles ImageButton3.Click
        up3.Visible = True
    End Sub

    Protected Sub txtSearch_TextChanged(ByVal sender As Object, ByVal e As EventArgs)
        Dim searchQuery As String = txtSearch.Text.Trim()
        Using conn As New SqlConnection(connString)
            Dim cmd As New SqlCommand("SELECT * FROM menu_item WHERE m_name LIKE '%' + @Search + '%'", conn)
            cmd.Parameters.AddWithValue("@Search", searchQuery)
            conn.Open()
            rptMenuItems3.DataSource = cmd.ExecuteReader()
            rptMenuItems3.DataBind()
        End Using
    End Sub

    Protected Sub ddlFilterCategory_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
        Dim selectedCategoryId As Integer = Convert.ToInt32(ddlFilterCategory.SelectedValue)
        Using conn As New SqlConnection(connString)
            Dim cmd As New SqlCommand("SELECT * FROM menu_item WHERE m_category_id = @CategoryId", conn)
            cmd.Parameters.AddWithValue("@CategoryId", selectedCategoryId)
            conn.Open()
            rptMenuItems3.DataSource = cmd.ExecuteReader()
            rptMenuItems3.DataBind()
        End Using
    End Sub


End Class
