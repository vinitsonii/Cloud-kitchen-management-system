Imports System.Data.SqlClient
Imports System.Configuration

Public Class Menu
    Inherits System.Web.UI.Page

    Dim connString As String = ConfigurationManager.ConnectionStrings("constr").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        'Session("c_id") = 1
        If Not IsPostBack Then
            LoadCategories()
            LoadCuisines()
            LoadMenuItems()


            If Request.QueryString("search") IsNot Nothing Then
                Dim searchQuery As String = Server.UrlDecode(Request.QueryString("search"))
                txtSearch.Text = searchQuery

                LoadMenuItems(txtSearch.Text.Trim(), Convert.ToInt32(ddlCategory.SelectedValue), Convert.ToInt32(ddlCuisine.SelectedValue))
            End If
        End If

    End Sub
 
    Private Sub LoadCategories()
        Try
            Using con As New SqlConnection(connString)
                Dim cmd As New SqlCommand("SELECT category_id, category_name FROM menu_category", con)
                con.Open()
                ddlCategory.DataSource = cmd.ExecuteReader()
                ddlCategory.DataTextField = "category_name"
                ddlCategory.DataValueField = "category_id"
                ddlCategory.DataBind()
            End Using
        Catch ex As Exception
            Response.Write("<script>alert('Error loading categories!');</script>")
        End Try
        ddlCategory.Items.Insert(0, New ListItem("All Categories", "0"))
    End Sub


    Private Sub LoadCuisines()
        Try
            Using con As New SqlConnection(connString)
                Dim cmd As New SqlCommand("SELECT cuisine_id, cuisine_name FROM cuisine_type", con)
                con.Open()
                ddlCuisine.DataSource = cmd.ExecuteReader()
                ddlCuisine.DataTextField = "cuisine_name"
                ddlCuisine.DataValueField = "cuisine_id"
                ddlCuisine.DataBind()
            End Using
        Catch ex As Exception
            ' Handle Error
            Response.Write("<script>alert('Error loading cuisines!');</script>")
        End Try
        ddlCuisine.Items.Insert(0, New ListItem("All Cuisines", "0"))
    End Sub

    'Private Sub LoadMenuItems(Optional ByVal search As String = "", Optional ByVal category As Integer = 0, Optional ByVal cuisine As Integer = 0)
    '    Try
    '        Using con As New SqlConnection(connString)
    '            ' Base query
    '            Dim query As String = "SELECT mi.*, mc.category_name, mi.m_availability, ct.cuisine_name FROM menu_item mi INNER JOIN menu_category mc ON mi.m_category_id = mc.category_id INNER JOIN cuisine_type ct ON mi.m_cuisine_id = ct.cuisine_id WHERE mi.m_status = 1"

    '            ' Dynamic Filters
    '            Dim parameters As New List(Of SqlParameter)
    '            If Not String.IsNullOrEmpty(search) Then
    '                query &= " AND mi.m_name LIKE @search"
    '                parameters.Add(New SqlParameter("@search", "%" & search & "%"))
    '            End If
    '            If category > 0 Then
    '                query &= " AND mi.m_category_id = @category"
    '                parameters.Add(New SqlParameter("@category", category))
    '            End If
    '            If cuisine > 0 Then
    '                query &= " AND mi.m_cuisine_id = @cuisine"
    '                parameters.Add(New SqlParameter("@cuisine", cuisine))
    '            End If

    '            ' Execute Query
    '            Dim cmd As New SqlCommand(query, con)
    '            cmd.Parameters.AddRange(parameters.ToArray())

    '            con.Open()
    '            rptMenuItems.DataSource = cmd.ExecuteReader()
    '            rptMenuItems.DataBind()
    '        End Using
    '    Catch ex As Exception
    '        ' Handle Error
    '        Response.Write("<script>alert('Error loading menu items!');</script>")
    '    End Try
    'End Sub

    Private Sub LoadMenuItems(Optional ByVal search As String = "", Optional ByVal category As Integer = 0, Optional ByVal cuisine As Integer = 0)
        Try
            Using con As New SqlConnection(connString)
                Dim query As String = "SELECT mi.m_id, mi.m_name, mi.m_description, mi.m_final_price, mi.m_image_url, " &
                                      "mi.m_availability, mc.category_name, ct.cuisine_name " &
                                      "FROM menu_item mi " &
                                      "INNER JOIN menu_category mc ON mi.m_category_id = mc.category_id " &
                                      "INNER JOIN cuisine_type ct ON mi.m_cuisine_id = ct.cuisine_id " &
                                      "WHERE mi.m_status = 1"

                Dim parameters As New List(Of SqlParameter)
                If Not String.IsNullOrEmpty(search) Then
                    query &= " AND mi.m_name LIKE @search"
                    parameters.Add(New SqlParameter("@search", "%" & search & "%"))
                End If
                If category > 0 Then
                    query &= " AND mi.m_category_id = @category"
                    parameters.Add(New SqlParameter("@category", category))
                End If
                If cuisine > 0 Then
                    query &= " AND mi.m_cuisine_id = @cuisine"
                    parameters.Add(New SqlParameter("@cuisine", cuisine))
                End If

                query &= " ORDER BY mi.m_name"

                Dim cmd As New SqlCommand(query, con)
                cmd.Parameters.AddRange(parameters.ToArray())

                con.Open()
                Dim reader As SqlDataReader = cmd.ExecuteReader()
                Dim dt As New DataTable()
                dt.Load(reader)

                rptMenuItems.DataSource = dt
                rptMenuItems.DataBind()

                ' Show or hide the "No items" message
                pnlempty.Visible = (dt.Rows.Count = 0)

            End Using
        Catch ex As Exception
            Response.Write("<script>alert('Error loading menu items!');</script>")
        End Try
    End Sub



    Protected Sub FilterMenu(ByVal sender As Object, ByVal e As EventArgs)
        LoadMenuItems(txtSearch.Text.Trim(), Convert.ToInt32(ddlCategory.SelectedValue), Convert.ToInt32(ddlCuisine.SelectedValue))
    End Sub

    



    Protected Sub OrderNow_Click(ByVal sender As Object, ByVal e As CommandEventArgs)
        Try
            If Session("c_id") IsNot Nothing Then
                Dim menuId As Integer
                If Not Integer.TryParse(e.CommandArgument.ToString(), menuId) Then
                    Response.Write("<script>alert('Invalid menu item!');</script>")
                    Exit Sub
                End If

                Dim menuItem As Dictionary(Of String, Object) = GetMenuItem(menuId)

                If menuItem Is Nothing OrElse menuItem.Count = 0 Then
                    Response.Write("<script>alert('Menu item not found!');</script>")
                    Exit Sub
                End If


                Dim cart As List(Of Dictionary(Of String, Object)) = If(Session("Cart"), New List(Of Dictionary(Of String, Object)))

                Dim existingItem = cart.FirstOrDefault(Function(x) x("m_id") = menuId)

                If existingItem IsNot Nothing Then
                    Dim newQty As Integer = CInt(existingItem("quantity")) + 1
                    If newQty > 25 Then newQty = 25
                    existingItem("quantity") = newQty
                    existingItem("total_price") = CDec(newQty) * CDec(existingItem("m_final_price"))
                Else
                    menuItem("quantity") = 1
                    menuItem("total_price") = CDec(menuItem("m_final_price"))
                    cart.Add(menuItem)
                End If

                Session("Cart") = cart

                Response.Redirect("Cart.aspx")
            Else
                Response.Redirect("Login.aspx")
            End If
        Catch ex As Exception
            Response.Write("<script>alert('An error occurred while processing your order.');</script>")
        End Try
    End Sub




    Private Function GetMenuItem(ByVal menuId As Integer) As Dictionary(Of String, Object)
        Dim item As New Dictionary(Of String, Object)
        Using con As New SqlConnection(connString)
            Dim cmd As New SqlCommand("SELECT m_id, m_name, m_final_price, ISNULL(m_image_url, '') AS m_image_url FROM menu_Item WHERE m_id = @M_Id", con)
            cmd.Parameters.AddWithValue("@M_Id", menuId)
            con.Open()
            Dim reader As SqlDataReader = cmd.ExecuteReader()
            If reader.Read() Then
                item("m_id") = reader("m_id")
                item("m_name") = reader("m_name")
                item("m_final_price") = Convert.ToDecimal(reader("m_final_price"))
                item("m_image_url") = reader("m_image_url").ToString()
            End If
        End Using
        Return item
    End Function

    Public Function GetCategoryIcon(ByVal categoryName As Object) As String
        If categoryName Is Nothing OrElse IsDBNull(categoryName) Then Return "fas fa-utensils"
        Dim name As String = categoryName.ToString().Trim().ToLower()

        If name.Contains("dessert") OrElse name.Contains("sweet") OrElse name.Contains("ice cream") OrElse name.Contains("cake") Then
            Return "fas fa-cake-candles"
        ElseIf name.Contains("beverage") OrElse name.Contains("drink") OrElse name.Contains("shake") OrElse name.Contains("juice") OrElse name.Contains("tea") OrElse name.Contains("coffee") Then
            Return "fas fa-glass-water"
        ElseIf name.Contains("starter") OrElse name.Contains("snack") OrElse name.Contains("appetizer") OrElse name.Contains("finger") Then
            Return "fas fa-cookie-bite"
        ElseIf name.Contains("pizza") OrElse name.Contains("burger") OrElse name.Contains("fast food") OrElse name.Contains("sandwich") Then
            Return "fas fa-pizza-slice"
        ElseIf name.Contains("main") OrElse name.Contains("thali") OrElse name.Contains("meal") OrElse name.Contains("rice") OrElse name.Contains("roti") Then
            Return "fas fa-bowl-rice"
        Else
            Return "fas fa-utensils"
        End If
    End Function

    Public Function GetCuisineIcon(ByVal cuisineName As Object) As String
        If cuisineName Is Nothing OrElse IsDBNull(cuisineName) Then Return "fas fa-utensils"
        Dim name As String = cuisineName.ToString().Trim().ToLower()

        If name.Contains("indian") OrElse name.Contains("deshi") OrElse name.Contains("gujarati") OrElse name.Contains("punjabi") Then
            Return "fas fa-pepper-hot"
        ElseIf name.Contains("chinese") OrElse name.Contains("asian") OrElse name.Contains("noodle") Then
            Return "fas fa-bowl-food"
        ElseIf name.Contains("italian") OrElse name.Contains("pasta") OrElse name.Contains("pizza") Then
            Return "fas fa-pizza-slice"
        ElseIf name.Contains("dessert") OrElse name.Contains("sweet") OrElse name.Contains("bakery") Then
            Return "fas fa-ice-cream"
        Else
            Return "fas fa-fire-flame-curved"
        End If
    End Function


End Class
