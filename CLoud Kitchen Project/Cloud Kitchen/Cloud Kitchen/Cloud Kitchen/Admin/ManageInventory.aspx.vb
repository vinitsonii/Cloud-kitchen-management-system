Imports System.Data.SqlClient
Imports System.Data
Imports System.Configuration
Imports System.Web.UI.WebControls

Public Class ManageInventory
    Inherits System.Web.UI.Page

    Private ReadOnly connString As String = ConfigurationManager.ConnectionStrings("constr").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            ' Check query string for stock filter (e.g. from Dashboard low/out of stock banner link)
            If Request.QueryString("filter") IsNot Nothing Then
                Dim filterParam As String = Request.QueryString("filter").Trim().ToLower()
                If filterParam = "outofstock" OrElse filterParam = "outstock" OrElse filterParam = "out" Then
                    ddlStockFilter.SelectedValue = "OutOfStock"
                ElseIf filterParam = "lowstock" OrElse filterParam = "low" Then
                    ddlStockFilter.SelectedValue = "LowStock"
                ElseIf filterParam = "instock" OrElse filterParam = "in" Then
                    ddlStockFilter.SelectedValue = "InStock"
                End If
            End If

            BindIngredients()
            BindRecipeDishes()
            BindRecipeIngredientsDropdown()

            ' Check query string for pre-selected dish (e.g. from AddFoodItems.aspx)
            If Request.QueryString("m_id") IsNot Nothing Then
                Dim selectedDishId As String = Request.QueryString("m_id")
                SwitchToRecipeTab()
                If ddlRecipeDish.Items.FindByValue(selectedDishId) IsNot Nothing Then
                    ddlRecipeDish.SelectedValue = selectedDishId
                    LoadDishRecipe(Convert.ToInt32(selectedDishId))
                End If
            End If
        End If
    End Sub

    ' --- TAB SWITCHING LOGIC ---
    Protected Sub btnTabIngredients_Click(ByVal sender As Object, ByVal e As EventArgs)
        SwitchToIngredientsTab()
    End Sub

    Protected Sub btnTabRecipe_Click(ByVal sender As Object, ByVal e As EventArgs)
        SwitchToRecipeTab()
    End Sub

    Private Sub SwitchToIngredientsTab()
        pnlIngredients.Visible = True
        pnlRecipe.Visible = False
        btnTabIngredients.CssClass = "tab-btn active"
        btnTabRecipe.CssClass = "tab-btn"
        BindIngredients()
    End Sub

    Private Sub SwitchToRecipeTab()
        pnlIngredients.Visible = False
        pnlRecipe.Visible = True
        btnTabIngredients.CssClass = "tab-btn"
        btnTabRecipe.CssClass = "tab-btn active"
    End Sub

    Protected Sub ddlStockFilter_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
        BindIngredients()
    End Sub

    ' --- TAB 1: INGREDIENT INVENTORY LOGIC ---
    Private Sub BindIngredients()
        Dim searchQuery As String = txtSearchIngredient.Text.Trim()
        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT * FROM Ingredients WHERE ingredient_name LIKE '%' + @Search + '%' ORDER BY ingredient_name ASC"
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@Search", searchQuery)
                conn.Open()
                Dim dt As New DataTable()
                Dim adapter As New SqlDataAdapter(cmd)
                adapter.Fill(dt)

                ' Calculate quick summary metrics from full inventory
                Dim totalValuation As Decimal = 0
                Dim lowCount As Integer = 0
                Dim healthyCount As Integer = 0

                For Each row As DataRow In dt.Rows
                    Dim qty As Decimal = Convert.ToDecimal(row("stock_quantity"))
                    Dim cost As Decimal = Convert.ToDecimal(row("cost_per_unit"))
                    Dim thresh As Decimal = Convert.ToDecimal(row("low_stock_threshold"))
                    totalValuation += (qty * cost)
                    If qty <= thresh Then
                        lowCount += 1
                    Else
                        healthyCount += 1
                    End If
                Next

                lblTotalItems.Text = dt.Rows.Count.ToString()
                lblHealthyItems.Text = healthyCount.ToString()
                lblLowStockCount.Text = lowCount.ToString()
                lblTotalValuation.Text = "₹" & totalValuation.ToString("N2")

                ' Apply Status Dropdown Filter for Repeater Display
                Dim filterVal As String = ddlStockFilter.SelectedValue
                Dim dv As New DataView(dt)
                Dim filterExpr As String = ""

                If filterVal = "InStock" Then
                    filterExpr = "stock_quantity > low_stock_threshold"
                ElseIf filterVal = "LowStock" Then
                    filterExpr = "stock_quantity <= low_stock_threshold AND stock_quantity > 0"
                ElseIf filterVal = "OutOfStock" Then
                    filterExpr = "stock_quantity <= 0"
                End If

                If Not String.IsNullOrEmpty(filterExpr) Then
                    dv.RowFilter = filterExpr
                End If

                If dv.Count > 0 Then
                    rptIngredients.DataSource = dv
                    rptIngredients.DataBind()
                    pnlNoIngredients.Visible = False
                Else
                    rptIngredients.DataSource = Nothing
                    rptIngredients.DataBind()
                    pnlNoIngredients.Visible = True
                End If
            End Using
        End Using
    End Sub

    Protected Sub btnSaveIngredient_Click(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim name As String = txtIngredientName.Text.Trim()
            Dim stockQty As Decimal = 0
            Dim unit As String = ddlUnit.SelectedValue
            Dim costPerUnit As Decimal = 0
            Dim threshold As Decimal = 2.0

            If String.IsNullOrEmpty(name) Then
                lblMsg.Text = "Please enter an ingredient name."
                lblMsg.ForeColor = Drawing.Color.Red
                Return
            End If

            If String.IsNullOrEmpty(txtStockQty.Text.Trim()) OrElse Not Decimal.TryParse(txtStockQty.Text.Trim(), stockQty) OrElse stockQty < 0 Then
                lblMsg.Text = "Please enter a valid Stock Quantity (&ge; 0)."
                lblMsg.ForeColor = Drawing.Color.Red
                Return
            End If

            If String.IsNullOrEmpty(txtCostPerUnit.Text.Trim()) OrElse Not Decimal.TryParse(txtCostPerUnit.Text.Trim(), costPerUnit) OrElse costPerUnit < 0 Then
                lblMsg.Text = "Please enter a valid Cost per Unit (₹)."
                lblMsg.ForeColor = Drawing.Color.Red
                Return
            End If

            If String.IsNullOrEmpty(txtLowStockThreshold.Text.Trim()) OrElse Not Decimal.TryParse(txtLowStockThreshold.Text.Trim(), threshold) OrElse threshold < 0 Then
                lblMsg.Text = "Please enter a valid Low Stock Threshold."
                lblMsg.ForeColor = Drawing.Color.Red
                Return
            End If

            Using conn As New SqlConnection(connString)
                conn.Open()
                If String.IsNullOrEmpty(hfIngredientId.Value) Then
                    ' INSERT
                    Dim query As String = "INSERT INTO Ingredients (ingredient_name, stock_quantity, unit, cost_per_unit, low_stock_threshold, last_updated) VALUES (@Name, @Stock, @Unit, @Cost, @Threshold, GETDATE())"
                    Using cmd As New SqlCommand(query, conn)
                        cmd.Parameters.AddWithValue("@Name", name)
                        cmd.Parameters.AddWithValue("@Stock", stockQty)
                        cmd.Parameters.AddWithValue("@Unit", unit)
                        cmd.Parameters.AddWithValue("@Cost", costPerUnit)
                        cmd.Parameters.AddWithValue("@Threshold", threshold)
                        cmd.ExecuteNonQuery()
                    End Using
                    lblMsg.Text = "Ingredient added successfully!"
                    lblMsg.ForeColor = Drawing.Color.DarkGreen
                Else
                    ' UPDATE
                    Dim query As String = "UPDATE Ingredients SET ingredient_name = @Name, stock_quantity = @Stock, unit = @Unit, cost_per_unit = @Cost, low_stock_threshold = @Threshold, last_updated = GETDATE() WHERE ingredient_id = @Id"
                    Using cmd As New SqlCommand(query, conn)
                        cmd.Parameters.AddWithValue("@Name", name)
                        cmd.Parameters.AddWithValue("@Stock", stockQty)
                        cmd.Parameters.AddWithValue("@Unit", unit)
                        cmd.Parameters.AddWithValue("@Cost", costPerUnit)
                        cmd.Parameters.AddWithValue("@Threshold", threshold)
                        cmd.Parameters.AddWithValue("@Id", Convert.ToInt32(hfIngredientId.Value))
                        cmd.ExecuteNonQuery()
                    End Using
                    lblMsg.Text = "Ingredient updated successfully!"
                    lblMsg.ForeColor = Drawing.Color.DarkGreen
                End If
            End Using

            ClearIngredientForm()
            BindIngredients()
            BindRecipeIngredientsDropdown()
        Catch ex As Exception
            lblMsg.Text = "Error: " & ex.Message
            lblMsg.ForeColor = Drawing.Color.Red
        End Try
    End Sub

    Protected Sub btnCancelIngredient_Click(ByVal sender As Object, ByVal e As EventArgs)
        ClearIngredientForm()
    End Sub

    Private Sub ClearIngredientForm()
        txtIngredientName.Text = ""
        txtStockQty.Text = ""
        txtCostPerUnit.Text = ""
        txtLowStockThreshold.Text = ""
        ddlUnit.SelectedIndex = 0
        hfIngredientId.Value = ""
        litFormTitle.Text = "Add New Raw Ingredient"
        btnSaveIngredient.Text = "Save Ingredient"
    End Sub

    Protected Sub rptIngredients_ItemCommand(ByVal source As Object, ByVal e As RepeaterCommandEventArgs)
        If e.CommandName = "EditIngredient" Then
            Dim id As Integer = Convert.ToInt32(e.CommandArgument)
            Using conn As New SqlConnection(connString)
                Dim query As String = "SELECT * FROM Ingredients WHERE ingredient_id = @Id"
                Using cmd As New SqlCommand(query, conn)
                    cmd.Parameters.AddWithValue("@Id", id)
                    conn.Open()
                    Using rdr As SqlDataReader = cmd.ExecuteReader()
                        If rdr.Read() Then
                            hfIngredientId.Value = rdr("ingredient_id").ToString()
                            txtIngredientName.Text = rdr("ingredient_name").ToString()
                            txtStockQty.Text = rdr("stock_quantity").ToString()
                            txtCostPerUnit.Text = rdr("cost_per_unit").ToString()
                            txtLowStockThreshold.Text = rdr("low_stock_threshold").ToString()
                            If ddlUnit.Items.FindByValue(rdr("unit").ToString()) IsNot Nothing Then
                                ddlUnit.SelectedValue = rdr("unit").ToString()
                            End If
                            litFormTitle.Text = "Edit Raw Ingredient"
                            btnSaveIngredient.Text = "Update Ingredient"
                        End If
                    End Using
                End Using
            End Using
        ElseIf e.CommandName = "DeleteIngredient" Then
            Dim id As Integer = Convert.ToInt32(e.CommandArgument)
            Using conn As New SqlConnection(connString)
                Dim query As String = "DELETE FROM Ingredients WHERE ingredient_id = @Id"
                Using cmd As New SqlCommand(query, conn)
                    cmd.Parameters.AddWithValue("@Id", id)
                    conn.Open()
                    cmd.ExecuteNonQuery()
                End Using
            End Using
            lblMsg.Text = "Ingredient deleted successfully!"
            lblMsg.ForeColor = Drawing.Color.Blue
            BindIngredients()
            BindRecipeIngredientsDropdown()
        End If
    End Sub

    Protected Sub txtSearchIngredient_TextChanged(ByVal sender As Object, ByVal e As EventArgs)
        BindIngredients()
    End Sub

    Protected Function GetStockBadge(ByVal stockVal As Object, ByVal thresholdVal As Object) As String
        Dim stock As Decimal = Convert.ToDecimal(stockVal)
        Dim threshold As Decimal = Convert.ToDecimal(thresholdVal)

        If stock <= 0 Then
            Return "<span class='badge-outstock'>🔴 Out of Stock</span>"
        ElseIf stock <= threshold Then
            Return "<span class='badge-lowstock'>🟡 Low Stock</span>"
        Else
            Return "<span class='badge-instock'>🟢 In Stock</span>"
        End If
    End Function

    ' --- TAB 2: RECIPE BUILDER MATRIX LOGIC ---
    Private Sub BindRecipeDishes()
        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT m_id, m_name FROM menu_item ORDER BY m_name ASC"
            Using cmd As New SqlCommand(query, conn)
                conn.Open()
                ddlRecipeDish.DataSource = cmd.ExecuteReader()
                ddlRecipeDish.DataTextField = "m_name"
                ddlRecipeDish.DataValueField = "m_id"
                ddlRecipeDish.DataBind()
                ddlRecipeDish.Items.Insert(0, New ListItem("-- Select Dish to Build Recipe --", "0"))
            End Using
        End Using
    End Sub

    Private Sub BindRecipeIngredientsDropdown()
        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT ingredient_id, ingredient_name + ' (' + unit + ')' AS display_name FROM Ingredients ORDER BY ingredient_name ASC"
            Using cmd As New SqlCommand(query, conn)
                conn.Open()
                ddlRecipeIngredient.DataSource = cmd.ExecuteReader()
                ddlRecipeIngredient.DataTextField = "display_name"
                ddlRecipeIngredient.DataValueField = "ingredient_id"
                ddlRecipeIngredient.DataBind()
                ddlRecipeIngredient.Items.Insert(0, New ListItem("-- Select Ingredient --", "0"))
            End Using
        End Using
    End Sub

    Protected Sub ddlRecipeDish_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
        If ddlRecipeDish.SelectedValue <> "0" Then
            LoadDishRecipe(Convert.ToInt32(ddlRecipeDish.SelectedValue))
        Else
            lblSelectedDishName.Text = "Select a dish above"
            rptRecipeItems.DataSource = Nothing
            rptRecipeItems.DataBind()
            pnlNoRecipeItems.Visible = True
        End If
    End Sub

    Private Sub LoadDishRecipe(ByVal dishId As Integer)
        lblSelectedDishName.Text = ddlRecipeDish.SelectedItem.Text
        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT DI.recipe_id, DI.qty_required, I.ingredient_name, I.unit, I.cost_per_unit " &
                                  "FROM Dish_Ingredients DI " &
                                  "INNER JOIN Ingredients I ON DI.ingredient_id = I.ingredient_id " &
                                  "WHERE DI.m_id = @DishId ORDER BY I.ingredient_name ASC"
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@DishId", dishId)
                conn.Open()
                Dim dt As New DataTable()
                Dim adapter As New SqlDataAdapter(cmd)
                adapter.Fill(dt)

                Dim estCost As Decimal = 0

                If dt.Rows.Count > 0 Then
                    rptRecipeItems.DataSource = dt
                    rptRecipeItems.DataBind()
                    pnlNoRecipeItems.Visible = False

                    For Each row As DataRow In dt.Rows
                        Dim qty As Decimal = Convert.ToDecimal(row("qty_required"))
                        Dim cost As Decimal = Convert.ToDecimal(row("cost_per_unit"))
                        estCost += (qty * cost)
                    Next
                Else
                    rptRecipeItems.DataSource = Nothing
                    rptRecipeItems.DataBind()
                    pnlNoRecipeItems.Visible = True
                End If

                ' Fetch selling price from menu_item
                Dim sellingPrice As Decimal = 0
                Dim queryDish As String = "SELECT m_final_price FROM menu_item WHERE m_id = @DishId"
                Using cmdDish As New SqlCommand(queryDish, conn)
                    cmdDish.Parameters.AddWithValue("@DishId", dishId)
                    Dim priceObj As Object = cmdDish.ExecuteScalar()
                    If priceObj IsNot Nothing AndAlso Not IsDBNull(priceObj) Then
                        sellingPrice = Convert.ToDecimal(priceObj)
                    End If
                End Using

                Dim margin As Decimal = sellingPrice - estCost
                Dim marginPct As Decimal = If(sellingPrice > 0, (margin / sellingPrice) * 100, 0)

                lblDishSellingPrice.Text = "₹" & sellingPrice.ToString("N2")
                lblEstRecipeCost.Text = "₹" & estCost.ToString("N2")
                lblEstGrossMargin.Text = "₹" & margin.ToString("N2") & " (" & marginPct.ToString("F1") & "%)"
                pnlRecipeFinancials.Visible = True
            End Using
        End Using
    End Sub

    Protected Sub btnAddRecipeItem_Click(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim dishId As Integer = Convert.ToInt32(ddlRecipeDish.SelectedValue)
            Dim ingredientId As Integer = Convert.ToInt32(ddlRecipeIngredient.SelectedValue)
            Dim qty As Decimal = 0

            If dishId = 0 Then
                lblMsg.Text = "Please select a dish."
                lblMsg.ForeColor = Drawing.Color.Red
                Return
            End If

            If ingredientId = 0 Then
                lblMsg.Text = "Please select an ingredient."
                lblMsg.ForeColor = Drawing.Color.Red
                Return
            End If

            If Not Decimal.TryParse(txtRecipeQty.Text.Trim(), qty) OrElse qty <= 0 Then
                lblMsg.Text = "Please enter a valid quantity greater than 0."
                lblMsg.ForeColor = Drawing.Color.Red
                Return
            End If

            Using conn As New SqlConnection(connString)
                conn.Open()
                ' Check if ingredient already in recipe for this dish
                Dim checkQuery As String = "SELECT COUNT(*) FROM Dish_Ingredients WHERE m_id = @DishId AND ingredient_id = @IngredientId"
                Using checkCmd As New SqlCommand(checkQuery, conn)
                    checkCmd.Parameters.AddWithValue("@DishId", dishId)
                    checkCmd.Parameters.AddWithValue("@IngredientId", ingredientId)
                    Dim count As Integer = Convert.ToInt32(checkCmd.ExecuteScalar())

                    If count > 0 Then
                        ' Update existing recipe ratio
                        Dim updateQuery As String = "UPDATE Dish_Ingredients SET qty_required = @Qty WHERE m_id = @DishId AND ingredient_id = @IngredientId"
                        Using updateCmd As New SqlCommand(updateQuery, conn)
                            updateCmd.Parameters.AddWithValue("@Qty", qty)
                            updateCmd.Parameters.AddWithValue("@DishId", dishId)
                            updateCmd.Parameters.AddWithValue("@IngredientId", ingredientId)
                            updateCmd.ExecuteNonQuery()
                        End Using
                        lblMsg.Text = "Recipe ingredient ratio updated!"
                        lblMsg.ForeColor = Drawing.Color.DarkGreen
                    Else
                        ' Insert new recipe mapping
                        Dim insertQuery As String = "INSERT INTO Dish_Ingredients (m_id, ingredient_id, qty_required) VALUES (@DishId, @IngredientId, @Qty)"
                        Using insertCmd As New SqlCommand(insertQuery, conn)
                            insertCmd.Parameters.AddWithValue("@DishId", dishId)
                            insertCmd.Parameters.AddWithValue("@IngredientId", ingredientId)
                            insertCmd.Parameters.AddWithValue("@Qty", qty)
                            insertCmd.ExecuteNonQuery()
                        End Using
                        lblMsg.Text = "Ingredient added to recipe!"
                        lblMsg.ForeColor = Drawing.Color.DarkGreen
                    End If
                End Using
            End Using

            txtRecipeQty.Text = ""
            ddlRecipeIngredient.SelectedIndex = 0
            LoadDishRecipe(dishId)
        Catch ex As Exception
            lblMsg.Text = "Error: " & ex.Message
            lblMsg.ForeColor = Drawing.Color.Red
        End Try
    End Sub

    Protected Sub rptRecipeItems_ItemCommand(ByVal source As Object, ByVal e As RepeaterCommandEventArgs)
        If e.CommandName = "RemoveRecipe" Then
            Dim recipeId As Integer = Convert.ToInt32(e.CommandArgument)
            Using conn As New SqlConnection(connString)
                Dim query As String = "DELETE FROM Dish_Ingredients WHERE recipe_id = @RecipeId"
                Using cmd As New SqlCommand(query, conn)
                    cmd.Parameters.AddWithValue("@RecipeId", recipeId)
                    conn.Open()
                    cmd.ExecuteNonQuery()
                End Using
            End Using

            lblMsg.Text = "Ingredient removed from recipe."
            lblMsg.ForeColor = Drawing.Color.Blue
            If ddlRecipeDish.SelectedValue <> "0" Then
                LoadDishRecipe(Convert.ToInt32(ddlRecipeDish.SelectedValue))
            End If
        ElseIf e.CommandName = "EditRecipe" Then
            Dim recipeId As Integer = Convert.ToInt32(e.CommandArgument)
            Using conn As New SqlConnection(connString)
                Dim query As String = "SELECT ingredient_id, qty_required FROM Dish_Ingredients WHERE recipe_id = @RecipeId"
                Using cmd As New SqlCommand(query, conn)
                    cmd.Parameters.AddWithValue("@RecipeId", recipeId)
                    conn.Open()
                    Using reader As SqlDataReader = cmd.ExecuteReader()
                        If reader.Read() Then
                            Dim ingId As String = reader("ingredient_id").ToString()
                            Dim qty As String = reader("qty_required").ToString()
                            If ddlRecipeIngredient.Items.FindByValue(ingId) IsNot Nothing Then
                                ddlRecipeIngredient.SelectedValue = ingId
                            End If
                            txtRecipeQty.Text = qty
                            lblMsg.Text = "Selected ingredient for editing. Change quantity above and click 'Link Ingredient to Recipe' to save."
                            lblMsg.ForeColor = Drawing.Color.Blue
                        End If
                    End Using
                End Using
            End Using
        End If
    End Sub

End Class
