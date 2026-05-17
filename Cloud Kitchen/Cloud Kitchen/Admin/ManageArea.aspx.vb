Imports System.Data.SqlClient

Partial Class ManageArea
    Inherits System.Web.UI.Page
    Dim con As New SqlConnection(ConfigurationManager.ConnectionStrings("constr").ConnectionString)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            BindAreas()
            UpdateStatistics()
            litMessage.Text = String.Empty
            'Else
            '    ' Check if this is a delete postback
            '    Dim eventTarget As String = Request("__EVENTTARGET")
            '    Dim eventArgument As String = Request("__EVENTARGUMENT")

            '    If eventTarget = "DeleteArea" And Not String.IsNullOrEmpty(eventArgument) Then
            '        DeleteArea(Convert.ToInt32(eventArgument))
            '    End If
        End If
    End Sub
    Private Sub DeleteArea(ByVal areaId As Integer)
        Try
            con.Open()
            Dim cmd As New SqlCommand("DELETE FROM Area_Pincode WHERE Area_Id = @AreaId", con)
            cmd.Parameters.AddWithValue("@AreaId", areaId)
            cmd.ExecuteNonQuery()

            litMessage.Text = "Service area deleted successfully!"
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowMessage", "document.getElementById('messagePanel').className = 'message success'; document.getElementById('messagePanel').style.display = 'block';", True)

            ' Refresh data
            BindAreas()
            UpdateStatistics()
        Catch ex As Exception
            litMessage.Text = "Error deleting area: " & ex.Message
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowMessage", "document.getElementById('messagePanel').className = 'message error'; document.getElementById('messagePanel').style.display = 'block';", True)
        Finally
            If con.State = ConnectionState.Open Then
                con.Close()
            End If
        End Try
    End Sub
    Private Sub BindAreas(Optional ByVal searchTerm As String = "")
        Dim cmd As SqlCommand

        If String.IsNullOrEmpty(searchTerm) Then
            cmd = New SqlCommand("SELECT * FROM Area_Pincode ORDER BY Area_Id DESC", con)
        Else
            cmd = New SqlCommand("SELECT * FROM Area_Pincode WHERE Area_Name LIKE @SearchTerm OR Pincode LIKE @SearchTerm ORDER BY Area_Id DESC", con)
            cmd.Parameters.AddWithValue("@SearchTerm", "%" & searchTerm & "%")
        End If

        Dim da As New SqlDataAdapter(cmd)
        Dim dt As New DataTable()
        da.Fill(dt)

        rptArea.DataSource = dt
        rptArea.DataBind()

        pnlNoData.Visible = (dt.Rows.Count = 0)
    End Sub

    Private Sub UpdateStatistics()
        Try
            con.Open()

            ' Get total areas count
            Dim cmdTotal As New SqlCommand("SELECT COUNT(*) FROM Area_Pincode", con)
            Dim totalAreas As Integer = Convert.ToInt32(cmdTotal.ExecuteScalar())
            litTotalAreas.Text = totalAreas.ToString()

            ' Get recent additions (last 30 days, assuming there's a CreatedDate column)
            ' If there's no CreatedDate column, can use last 3 entries or similar logic
            Dim cmdRecent As New SqlCommand("SELECT COUNT(*) FROM (SELECT TOP 3 * FROM Area_Pincode ORDER BY Area_Id DESC) AS RecentAreas", con)
            Dim recentAdditions As Integer = Convert.ToInt32(cmdRecent.ExecuteScalar())
            litRecentAdditions.Text = recentAdditions.ToString()

        Catch ex As Exception
            ' Handle any errors
            litMessage.Text = "Error updating statistics: " & ex.Message
            ' ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowMessage", "document.getElementById('messagePanel').className = 'message error'; document.getElementById('messagePanel').style.display = 'block';", True)
        Finally
            If con.State = ConnectionState.Open Then
                con.Close()
            End If
        End Try
    End Sub

    ' Add New button click
    Protected Sub btnAddNew_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnAddNew.Click
        pnlEditArea.Visible = True
        ' Clear fields for new entry
        hfAreaId.Value = String.Empty
        txtArea.Text = String.Empty
        txtPincode.Text = String.Empty
        lblmsg.Text = String.Empty

        ' Show Save button, hide Update button
        btnSave.Visible = True
        btnUpdate.Visible = False
        Panel1.Visible = True
        litPanelTitle.Text = "Add New Service Area"

        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowPanel", "showAddEditPanel();", True)
    End Sub

    Protected Sub btnSave_Click(ByVal sender As Object, ByVal e As EventArgs)
        If Not Page.IsValid Then
            Return
        End If

        Try
            con.Open()
            Dim cmdCheck As New SqlCommand("SELECT COUNT(*) FROM Area_Pincode WHERE Pincode = @Pincode", con)
            cmdCheck.Parameters.AddWithValue("@Pincode", txtPincode.Text.Trim())
            Dim count As Integer = Convert.ToInt32(cmdCheck.ExecuteScalar())

            If count > 0 Then
                lblmsg.ForeColor = Drawing.Color.Red
                lblmsg.Text = "This pincode already exists in the system!"
                Return
            End If

            Dim cmd As New SqlCommand("INSERT INTO Area_Pincode (Area_Name, Pincode) VALUES (@AreaName, @Pincode)", con)
            cmd.Parameters.AddWithValue("@AreaName", txtArea.Text.Trim())
            cmd.Parameters.AddWithValue("@Pincode", txtPincode.Text.Trim())
            cmd.ExecuteNonQuery()

            litMessage.Text = "Service area added successfully!"
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowMessage", "document.getElementById('messagePanel').className = 'message success'; document.getElementById('messagePanel').style.display = 'block';", True)

            txtArea.Text = String.Empty
            txtPincode.Text = String.Empty
            lblmsg.Text = String.Empty


            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "HidePanel", "hideAddEditPanel();", True)

            BindAreas()
            UpdateStatistics()
            Response.Redirect("ManageArea.aspx")
        Catch ex As Exception
            lblmsg.ForeColor = Drawing.Color.Red
            lblmsg.Text = "Error: " & ex.Message
        Finally
            If con.State = ConnectionState.Open Then
                con.Close()
            End If
        End Try
    End Sub

    ' Update area
    Protected Sub btnUpdate_Click(ByVal sender As Object, ByVal e As EventArgs)
        If Not Page.IsValid Then
            Return
        End If

        Try
            ' Check if pincode already exists with a different area
            con.Open()
            Dim cmdCheck As New SqlCommand("SELECT COUNT(*) FROM Area_Pincode WHERE Pincode = @Pincode AND Area_Id <> @AreaId", con)
            cmdCheck.Parameters.AddWithValue("@Pincode", txtPincode.Text.Trim())
            cmdCheck.Parameters.AddWithValue("@AreaId", hfAreaId.Value)
            Dim count As Integer = Convert.ToInt32(cmdCheck.ExecuteScalar())

            If count > 0 Then
                lblmsg.ForeColor = Drawing.Color.Red
                lblmsg.Text = "This pincode is already assigned to another area!"
                Return
            End If

            Dim cmd As New SqlCommand("UPDATE Area_Pincode SET Area_Name = @AreaName, Pincode = @Pincode WHERE Area_Id = @AreaId", con)
            cmd.Parameters.AddWithValue("@AreaName", txtArea.Text.Trim())
            cmd.Parameters.AddWithValue("@Pincode", txtPincode.Text.Trim())
            cmd.Parameters.AddWithValue("@AreaId", hfAreaId.Value)
            cmd.ExecuteNonQuery()

            ' Show success message
            litMessage.Text = "Service area updated successfully!"
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowMessage", "document.getElementById('messagePanel').className = 'message success'; document.getElementById('messagePanel').style.display = 'block';", True)

            ' Clear form
            txtArea.Text = String.Empty
            txtPincode.Text = String.Empty
            lblmsg.Text = String.Empty
            btnSave.Visible = True
            btnUpdate.Visible = False


            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "HidePanel", "hideAddEditPanel();", True)

            ' Refresh data
            BindAreas()
            Response.Redirect("ManageArea.aspx")
        Catch ex As Exception
            lblmsg.ForeColor = Drawing.Color.Red
            lblmsg.Text = "Error: " & ex.Message
        Finally
            If con.State = ConnectionState.Open Then
                con.Close()
            End If
        End Try
    End Sub

    ' Cancel button click
    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancel.Click
        txtArea.Text = String.Empty
        txtPincode.Text = String.Empty
        lblmsg.Text = String.Empty
        btnSave.Visible = True
        btnUpdate.Visible = False
        pnlEditArea.Visible = False
        Panel1.Style("display") = "none"
        overlay.Style("display") = "none"

        ' Call JavaScript to hide the panel properly
        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "hideOverlay", "hideAddEditPanel();", True)
    End Sub


    Protected Sub rptArea_ItemCommand(ByVal source As Object, ByVal e As RepeaterCommandEventArgs)
        Dim areaId As Integer = Convert.ToInt32(e.CommandArgument)

        If e.CommandName = "EditArea" Then
            Try
                con.Open()
                Dim cmd As New SqlCommand("SELECT * FROM Area_Pincode WHERE Area_Id = @AreaId", con)
                cmd.Parameters.AddWithValue("@AreaId", areaId)
                Dim dr As SqlDataReader = cmd.ExecuteReader()

                If dr.Read() Then
                    hfAreaId.Value = dr("Area_Id").ToString()
                    txtArea.Text = dr("Area_Name").ToString()
                    txtPincode.Text = dr("Pincode").ToString()
                    btnSave.Visible = False
                    btnUpdate.Visible = True
                    pnlEditArea.Visible = True
                    Panel1.Visible = True
                    litPanelTitle.Text = "Edit Service Area"
                    Panel1.Visible = True
                    Panel1.Style("display") = "block"
                    overlay.Style("display") = "block"

                    ' Call JavaScript to hide the panel properly
                    ScriptManager.RegisterStartupScript(Me, Me.GetType(), "hideOverlay", "showAddEditPanel();", True)
                    'ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowPanel", "showAddEditPanel();", True)
                End If

                dr.Close()
            Catch ex As Exception
                litMessage.Text = "Error loading area details: " & ex.Message
                'ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowMessage", "document.getElementById('messagePanel').className = 'message error'; document.getElementById('messagePanel').style.display = 'block';", True)
            Finally
                If con.State = ConnectionState.Open Then
                    con.Close()
                End If
            End Try

        ElseIf e.CommandName = "DeleteArea" Then
            Try
                con.Open()

                ' Check if the area is used in any orders or other tables first (if relevant)
                ' This is just a placeholder - you'd need to add actual relationship checks
                ' Dim cmdCheck As New SqlCommand("SELECT COUNT(*) FROM Orders WHERE Area_Id = @AreaId", con)
                ' cmdCheck.Parameters.AddWithValue("@AreaId", areaId)
                ' Dim count As Integer = Convert.ToInt32(cmdCheck.ExecuteScalar())

                ' If count > 0 Then
                '     litMessage.Text = "This area cannot be deleted as it is associated with existing orders!"
                '     ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowMessage", "document.getElementById('messagePanel').className = 'message error'; document.getElementById('messagePanel').style.display = 'block';", True)
                '     Return
                ' End If

                Dim cmd As New SqlCommand("DELETE FROM Area_Pincode WHERE Area_Id = @AreaId", con)
                cmd.Parameters.AddWithValue("@AreaId", areaId)
                cmd.ExecuteNonQuery()

                litMessage.Text = "Service area deleted successfully!"
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowMessage", "document.getElementById('messagePanel').className = 'message success'; document.getElementById('messagePanel').style.display = 'block';", True)

                ' Refresh data
                BindAreas()
                UpdateStatistics()

            Catch ex As Exception
                litMessage.Text = "Error deleting area: " & ex.Message
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowMessage", "document.getElementById('messagePanel').className = 'message error'; document.getElementById('messagePanel').style.display = 'block';", True)
            Finally
                If con.State = ConnectionState.Open Then
                    con.Close()
                End If
            End Try
        End If
    End Sub

    ' Search button click
    Protected Sub btnSearch_Click(ByVal sender As Object, ByVal e As EventArgs)
        BindAreas(txtSearch.Text.Trim())
    End Sub

    ' Clear search button click
    Protected Sub btnClearSearch_Click(ByVal sender As Object, ByVal e As EventArgs)
        txtSearch.Text = String.Empty
        BindAreas()
    End Sub
End Class