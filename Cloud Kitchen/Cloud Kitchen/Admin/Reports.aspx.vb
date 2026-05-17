Imports System.Data.SqlClient
Imports System.Data
Imports System.IO
Imports System.Text

Partial Class Reports
    Inherits System.Web.UI.Page

    Dim connString As String = ConfigurationManager.ConnectionStrings("constr").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Label1.Text = DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt")
            txtEndDate.Text = DateTime.Now.ToString("yyyy-MM-dd")
            txtStartDate.Text = DateTime.Now.AddDays(-30).ToString("yyyy-MM-dd")

            btnExportCSV.Visible = False
            pnlNoData.Visible = True
        End If
    End Sub

    Protected Sub btnGenerate_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnGenerate.Click
        Dim reportType As String = ddlReportType.SelectedValue
        Dim startDate As String = txtStartDate.Text
        Dim endDate As String = txtEndDate.Text

        Dim dt As DataTable = GenerateReport(reportType, startDate, endDate)
        gvReport.DataSource = dt
        gvReport.DataBind()

        litTotalRecords.Text = dt.Rows.Count.ToString()

        If Not String.IsNullOrEmpty(startDate) AndAlso Not String.IsNullOrEmpty(endDate) Then
            litDateRange.Text = Convert.ToDateTime(startDate).ToString("MMM dd, yyyy") & " - " & Convert.ToDateTime(endDate).ToString("MMM dd, yyyy")
        Else
            litDateRange.Text = "All Time"
        End If

        ' Update last updated time
        Label1.Text = DateTime.Now.ToString("MMM dd, yyyy HH:mm")

        ' Show/hide panels based on data availability
        If dt.Rows.Count > 0 Then
            pnlNoData.Visible = False
            btnExportCSV.Visible = True
        Else
            pnlNoData.Visible = True
            btnExportCSV.Visible = False
        End If

        If gvReport.Rows.Count > 0 Then
            Select Case reportType
                Case "orders"
                    gvReport.HeaderRow.Cells(0).Text = "Order ID"
                    gvReport.HeaderRow.Cells(1).Text = "Customer Name"
                    gvReport.HeaderRow.Cells(2).Text = "Total Amount"
                    gvReport.HeaderRow.Cells(3).Text = "Order Status"
                    gvReport.HeaderRow.Cells(4).Text = "Order Date"
                    gvReport.HeaderRow.Cells(5).Text = "Payment Type"
                    gvReport.HeaderRow.Cells(6).Text = "Address"
                    gvReport.HeaderRow.Cells(7).Text = "Pincode"

                    FormatCurrencyColumn(2)
                    FormatDateColumn(4)

                Case "customers"
                    gvReport.HeaderRow.Cells(0).Text = "Customer ID"
                    gvReport.HeaderRow.Cells(1).Text = "Customer Name"
                    gvReport.HeaderRow.Cells(2).Text = "Email"
                    gvReport.HeaderRow.Cells(3).Text = "Phone"

                Case "menu"
                    gvReport.HeaderRow.Cells(0).Text = "Menu ID"
                    gvReport.HeaderRow.Cells(1).Text = "Item Name"
                    gvReport.HeaderRow.Cells(2).Text = "Category"
                    gvReport.HeaderRow.Cells(3).Text = "Cuisine"
                    gvReport.HeaderRow.Cells(4).Text = "Price"
                    gvReport.HeaderRow.Cells(5).Text = "Final Price"
                    gvReport.HeaderRow.Cells(6).Text = "Availability"

                    ' Format currency columns
                    FormatCurrencyColumn(4)
                    FormatCurrencyColumn(5)

                Case "messages"
                    gvReport.HeaderRow.Cells(0).Text = "Message ID"
                    gvReport.HeaderRow.Cells(1).Text = "Sender Name"
                    gvReport.HeaderRow.Cells(2).Text = "Email"
                    gvReport.HeaderRow.Cells(3).Text = "Message"
                    gvReport.HeaderRow.Cells(4).Text = "Submitted At"
                    gvReport.HeaderRow.Cells(5).Text = "Status"

                    ' Format date column
                    FormatDateColumn(4)

                Case "daily_sales"
                    gvReport.HeaderRow.Cells(0).Text = "Order Date"
                    gvReport.HeaderRow.Cells(1).Text = "Total Sales"

                    ' Format date and currency columns
                    FormatDateColumn(0)
                    FormatCurrencyColumn(1)

                Case "top_selling"
                    gvReport.HeaderRow.Cells(0).Text = "Item Name"
                    gvReport.HeaderRow.Cells(1).Text = "Category"
                    gvReport.HeaderRow.Cells(2).Text = "Total Sold"

                Case "customer_summary"
                    gvReport.HeaderRow.Cells(0).Text = "Customer Name"
                    gvReport.HeaderRow.Cells(1).Text = "Email"
                    gvReport.HeaderRow.Cells(2).Text = "Total Orders"
                    gvReport.HeaderRow.Cells(3).Text = "Total Spent"

                    ' Format currency column
                    FormatCurrencyColumn(3)

                Case "active_customers"
                    gvReport.HeaderRow.Cells(0).Text = "Customer Name"
                    gvReport.HeaderRow.Cells(1).Text = "Email"
                    gvReport.HeaderRow.Cells(2).Text = "Order Count"
                    gvReport.HeaderRow.Cells(3).Text = "Status"

                    ' Apply status styling
                    FormatStatusColumn(3)

                Case "revenue_cuisine"
                    gvReport.HeaderRow.Cells(0).Text = "Cuisine Name"
                    gvReport.HeaderRow.Cells(1).Text = "Total Revenue"

                    ' Format currency column
                    FormatCurrencyColumn(1)

                Case "order_status"
                    gvReport.HeaderRow.Cells(0).Text = "Order Status"
                    gvReport.HeaderRow.Cells(1).Text = "Total Orders"

                Case "loyal_customers"
                    gvReport.HeaderRow.Cells(0).Text = "Customer Name"
                    gvReport.HeaderRow.Cells(1).Text = "Total Orders"
                    gvReport.HeaderRow.Cells(2).Text = "Total Spent"

                    ' Format currency column
                    FormatCurrencyColumn(2)

                Case "highest_orders"
                    gvReport.HeaderRow.Cells(0).Text = "Order ID"
                    gvReport.HeaderRow.Cells(1).Text = "Customer Name"
                    gvReport.HeaderRow.Cells(2).Text = "Total Amount"
                    gvReport.HeaderRow.Cells(3).Text = "Order Date"

                    ' Format currency and date columns
                    FormatCurrencyColumn(2)
                    FormatDateColumn(3)

                Case "feedback"
                    gvReport.HeaderRow.Cells(0).Text = "Customer Name"
                    gvReport.HeaderRow.Cells(1).Text = "Message"
                    gvReport.HeaderRow.Cells(2).Text = "Submitted At"
                    gvReport.HeaderRow.Cells(3).Text = "Status"

                    FormatDateColumn(2)

                    FormatStatusColumn(3)
            End Select
        End If

        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "hideLoading", "hideLoading();", True)
    End Sub

    ' Helper method to format currency columns
    Private Sub FormatCurrencyColumn(ByVal columnIndex As Integer)
        For Each row As GridViewRow In gvReport.Rows
            Dim value As Decimal
            If Decimal.TryParse(row.Cells(columnIndex).Text, value) Then
                row.Cells(columnIndex).Text = String.Format("₹{0:N2}", value)
            End If
        Next
    End Sub

    ' Helper method to format date columns
    Private Sub FormatDateColumn(ByVal columnIndex As Integer)
        For Each row As GridViewRow In gvReport.Rows
            Dim dateValue As DateTime
            If DateTime.TryParse(row.Cells(columnIndex).Text, dateValue) Then
                row.Cells(columnIndex).Text = dateValue.ToString("MMM dd, yyyy")
            End If
        Next
    End Sub

    ' Helper method to format status columns
    Private Sub FormatStatusColumn(ByVal columnIndex As Integer)
        For Each row As GridViewRow In gvReport.Rows
            Dim status As String = row.Cells(columnIndex).Text
            If status.ToLower() = "active" Then
                row.Cells(columnIndex).Text = "<span style='color: #28a745; font-weight: bold;'>" & status & "</span>"
            ElseIf status.ToLower() = "inactive" Then
                row.Cells(columnIndex).Text = "<span style='color: #dc3545; font-weight: bold;'>" & status & "</span>"
            ElseIf status.ToLower() = "read" Then
                row.Cells(columnIndex).Text = "<span style='color: #28a745; font-weight: bold;'>" & status & "</span>"
            ElseIf status.ToLower() = "unread" Then
                row.Cells(columnIndex).Text = "<span style='color: #007bff; font-weight: bold;'>" & status & "</span>"
            End If
        Next
    End Sub

    Private Function GenerateReport(ByVal reportType As String, ByVal startDate As String, ByVal endDate As String) As DataTable
        Using conn As New SqlConnection(connString)
            Dim query As String = ""

            Select Case reportType
                Case "orders"
                    query = "SELECT o.order_id, c.c_name AS customer_name, o.total_amount, o.order_status, o.order_date, o.payment_type, o.address, o.pincode " &
                            " FROM Orders o " &
                            " INNER JOIN Customers c ON o.c_id = c.c_id " &
                            " WHERE 1=1 "

                    ' Add date filter
                    If Not String.IsNullOrEmpty(startDate) AndAlso Not String.IsNullOrEmpty(endDate) Then
                        query &= " AND o.order_date BETWEEN @StartDate AND @EndDate"
                    End If

                    query &= " ORDER BY o.order_date DESC"

                Case "customers"
                    query = "SELECT c_id, c_name, email, phone FROM Customers WHERE 1=1"

                    ' Add ordering
                    query &= " ORDER BY c_name ASC"

                Case "menu"
                    query = "SELECT m.m_id, m.m_name, mc.category_name, ct.cuisine_name, m.m_price, m.m_final_price, m.m_availability " &
                            " FROM Menu_Item m " &
                            " INNER JOIN Menu_Category mc ON m.m_category_id = mc.category_id " &
                            " INNER JOIN Cuisine_Type ct ON m.m_cuisine_id = ct.cuisine_id " &
                            " WHERE 1=1"

                    ' Add ordering
                    query &= " ORDER BY mc.category_name, m.m_name ASC"

                Case "messages"
                    query = "SELECT m.message_id, COALESCE(c.c_name, m.name) AS sender_name, m.email, m.message, m.submitted_at, " &
                            " CASE WHEN m.status = 0 THEN 'Unread' ELSE 'Read' END AS status " &
                            " FROM contact_messages m " &
                            " LEFT JOIN Customers c ON m.c_id = c.c_id WHERE 1=1"

                    ' Add date filter
                    If Not String.IsNullOrEmpty(startDate) AndAlso Not String.IsNullOrEmpty(endDate) Then
                        query &= " AND m.submitted_at BETWEEN @StartDate AND @EndDate"
                    End If

                    query &= " ORDER BY m.submitted_at DESC"

                Case "daily_sales"
                    query = "SELECT CAST(order_date AS DATE) AS Order_Date, SUM(total_amount) AS Total_Sales " &
                            " FROM Orders "

                    ' Add date filter
                    If Not String.IsNullOrEmpty(startDate) AndAlso Not String.IsNullOrEmpty(endDate) Then
                        query &= " WHERE order_date BETWEEN @StartDate AND @EndDate"
                    End If

                    query &= " GROUP BY CAST(order_date AS DATE) ORDER BY Order_Date DESC"

                Case "top_selling"
                    query = "SELECT TOP 10 m.m_name, mc.category_name, SUM(od.quantity) AS Total_Sold " &
                            " FROM Order_Details od " &
                            " INNER JOIN Menu_Item m ON od.m_id = m.m_id " &
                            " INNER JOIN Menu_Category mc ON m.m_category_id = mc.category_id " &
                            " INNER JOIN Orders o ON od.order_id = o.order_id "

                    ' Add date filter
                    If Not String.IsNullOrEmpty(startDate) AndAlso Not String.IsNullOrEmpty(endDate) Then
                        query &= " WHERE o.order_date BETWEEN @StartDate AND @EndDate"
                    End If

                    query &= " GROUP BY m.m_name, mc.category_name ORDER BY Total_Sold DESC"

                Case "customer_summary"
                    query = "SELECT c.c_name, c.email, COUNT(o.order_id) AS Total_Orders, SUM(o.total_amount) AS Total_Spent " &
                            " FROM Customers c " &
                            " LEFT JOIN Orders o ON c.c_id = o.c_id "

                    ' Add date filter
                    If Not String.IsNullOrEmpty(startDate) AndAlso Not String.IsNullOrEmpty(endDate) Then
                        query &= " WHERE o.order_date BETWEEN @StartDate AND @EndDate OR o.order_id IS NULL"
                    End If

                    query &= " GROUP BY c.c_name, c.email ORDER BY Total_Spent DESC"

                Case "active_customers"
                    query = "SELECT c.c_name, c.email, COUNT(o.order_id) AS Order_Count, " &
                            " CASE WHEN COUNT(o.order_id) > 0 THEN 'Active' ELSE 'Inactive' END AS Status " &
                            " FROM Customers c " &
                            " LEFT JOIN Orders o ON c.c_id = o.c_id "

                    ' Add date filter
                    If Not String.IsNullOrEmpty(startDate) AndAlso Not String.IsNullOrEmpty(endDate) Then
                        query &= " AND (o.order_date BETWEEN @StartDate AND @EndDate OR o.order_id IS NULL)"
                    End If

                    query &= " GROUP BY c.c_name, c.email " &
                            " ORDER BY Order_Count DESC"

                Case "revenue_cuisine"
                    query = "SELECT ct.cuisine_name, SUM(od.total_price) AS Revenue " &
                            " FROM Order_Details od " &
                            " INNER JOIN Menu_Item m ON od.m_id = m.m_id " &
                            " INNER JOIN Cuisine_Type ct ON m.m_cuisine_id = ct.cuisine_id " &
                            " INNER JOIN Orders o ON od.order_id = o.order_id "

                    ' Add date filter
                    If Not String.IsNullOrEmpty(startDate) AndAlso Not String.IsNullOrEmpty(endDate) Then
                        query &= " WHERE o.order_date BETWEEN @StartDate AND @EndDate"
                    End If

                    query &= " GROUP BY ct.cuisine_name ORDER BY Revenue DESC"

                Case "order_status"
                    query = "SELECT order_status, COUNT(order_id) AS Total_Orders " &
                            " FROM Orders "

                    ' Add date filter
                    If Not String.IsNullOrEmpty(startDate) AndAlso Not String.IsNullOrEmpty(endDate) Then
                        query &= " WHERE order_date BETWEEN @StartDate AND @EndDate"
                    End If

                    query &= " GROUP BY order_status ORDER BY Total_Orders DESC"

                Case "loyal_customers"
                    query = "SELECT TOP 10 c.c_name, COUNT(o.order_id) AS Total_Orders, SUM(o.total_amount) AS Total_Spent " &
                            " FROM Customers c " &
                            " INNER JOIN Orders o ON c.c_id = o.c_id "


                    If Not String.IsNullOrEmpty(startDate) AndAlso Not String.IsNullOrEmpty(endDate) Then
                        query &= " WHERE o.order_date BETWEEN @StartDate AND @EndDate"
                    End If

                    query &= " GROUP BY c.c_name " &
                            " ORDER BY Total_Orders DESC"

                Case "highest_orders"
                    query = "SELECT TOP 20 o.order_id, c.c_name, o.total_amount, o.order_date " &
                            " FROM Orders o " &
                            " INNER JOIN Customers c ON o.c_id = c.c_id "


                    If Not String.IsNullOrEmpty(startDate) AndAlso Not String.IsNullOrEmpty(endDate) Then
                        query &= " WHERE o.order_date BETWEEN @StartDate AND @EndDate"
                    End If

                    query &= " ORDER BY o.total_amount DESC"

                Case "feedback"
                    query = "SELECT COALESCE(c.c_name, m.name) AS Customer_Name, m.message, m.submitted_at, " &
                            " CASE WHEN m.status = 0 THEN 'Unread' ELSE 'Read' END AS Status " &
                            " FROM contact_messages m " &
                            " LEFT JOIN Customers c ON m.c_id = c.c_id "


                    If Not String.IsNullOrEmpty(startDate) AndAlso Not String.IsNullOrEmpty(endDate) Then
                        query &= " WHERE m.submitted_at BETWEEN @StartDate AND @EndDate"
                    End If

                    query &= " ORDER BY m.submitted_at DESC"
            End Select

            Dim cmd As New SqlCommand(query, conn)

            If Not String.IsNullOrEmpty(startDate) AndAlso Not String.IsNullOrEmpty(endDate) Then
                cmd.Parameters.AddWithValue("@StartDate", Convert.ToDateTime(startDate))
                cmd.Parameters.AddWithValue("@EndDate", Convert.ToDateTime(endDate).AddDays(1).AddSeconds(-1))
            End If

            Dim dt As New DataTable()
            Dim adapter As New SqlDataAdapter(cmd)
            adapter.Fill(dt)
            Return dt
        End Using
    End Function


    Protected Sub btnPrint_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnPrint.Click
        Try
            Dim sw As New StringWriter()
            Dim hw As New HtmlTextWriter(sw)

            Dim reportTitle As String = "📊 " & ddlReportType.SelectedItem.Text
            Dim startDate As String = txtStartDate.Text
            Dim endDate As String = txtEndDate.Text
            Dim timestamp As String = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")

            Dim sb As New StringBuilder()
            sb.Append("<html><head><title>" & reportTitle & "</title>")
            sb.Append("<style>")
            sb.Append("body { font-family: Arial, sans-serif; padding: 20px; background-color: #f8f9fa; }")
            sb.Append("h2 { text-align: center; color: #333; font-size: 22px; }")
            sb.Append("p { text-align: center; font-size: 14px; color: #666; }")
            sb.Append("table { width: 100%; border-collapse: collapse; margin-top: 20px; background: white; border-radius: 8px; overflow: hidden; }")
            sb.Append("th, td { border: 1px solid #ddd; padding: 12px; text-align: left; font-size: 14px; }")
            sb.Append("th { background: #007BFF; color: white; text-transform: uppercase; font-size: 14px; }")
            sb.Append("tr:nth-child(even) { background: #f2f2f2; }")
            sb.Append("tr:hover { background: #ddd; }")
            sb.Append("@media print {")
            sb.Append("  body { background-color: white; }")
            sb.Append("  .report-actions { display: none; }")
            sb.Append("}")
            sb.Append("</style></head><body>")

            sb.Append("<h2>" & reportTitle & "</h2>")
            If Not String.IsNullOrEmpty(startDate) AndAlso Not String.IsNullOrEmpty(endDate) Then
                sb.Append("<p>📅 Date Range: " & Convert.ToDateTime(startDate).ToString("MMM dd, yyyy") & " to " & Convert.ToDateTime(endDate).ToString("MMM dd, yyyy") & "</p>")
            End If
            sb.Append("<p>🕒 Generated on: " & timestamp & "</p>")
            sb.Append("<p>📊 Total Records: " & litTotalRecords.Text & "</p>")
            sb.Append("<hr>")

            sb.Append("<table>")

            ' Add header row
            sb.Append("<tr>")
            For Each cell As TableCell In gvReport.HeaderRow.Cells
                sb.Append("<th>" & cell.Text & "</th>")
            Next
            sb.Append("</tr>")

            ' Add data rows
            For Each row As GridViewRow In gvReport.Rows
                sb.Append("<tr>")
                For Each cell As TableCell In row.Cells
                    sb.Append("<td>" & cell.Text & "</td>")
                Next
                sb.Append("</tr>")
            Next

            sb.Append("</table>")
            sb.Append("<hr>")
            sb.Append("<p>© " & DateTime.Now.Year & " Cloud Kitchen. All rights reserved.</p>")
            sb.Append("</body></html>")

            Dim script As String = "var newWin = window.open('', '_blank');"
            script &= "newWin.document.open();"
            script &= "newWin.document.write(`" & sb.ToString().Replace("`", "\`") & "`);"
            script &= "newWin.document.close();"
            script &= "setTimeout(function() { newWin.print(); }, 500);"

            ClientScript.RegisterStartupScript(Me.GetType(), "PrintReport", script, True)

        Catch ex As Exception
            Response.Write("<script>alert('An error occurred while generating the report: " & ex.Message.Replace("'", "") & "');</script>")
        End Try
    End Sub




    'Protected Sub btnExportExcel_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnExportCSV.Click
    '    Try
    '        ' Get report parameters
    '        Dim reportType As String = ddlReportType.SelectedValue
    '        Dim startDate As String = txtStartDate.Text
    '        Dim endDate As String = txtEndDate.Text

    '        ' Generate report data
    '        Dim dt As DataTable = GenerateReport(reportType, startDate, endDate)
    '        gvReport.DataSource = dt
    '        gvReport.DataBind()

    '        litTotalRecords.Text = dt.Rows.Count.ToString()

    '        ' Set date range text
    '        If Not String.IsNullOrEmpty(startDate) AndAlso Not String.IsNullOrEmpty(endDate) Then
    '            litDateRange.Text = Convert.ToDateTime(startDate).ToString("MMM dd, yyyy") & " - " & Convert.ToDateTime(endDate).ToString("MMM dd, yyyy")
    '        Else
    '            litDateRange.Text = "All Time"
    '        End If

    '        ' Check if we have data to export
    '        If dt Is Nothing OrElse dt.Rows.Count = 0 Then
    '            Response.Write("<script>alert('No data to export.');</script>")
    '            Return
    '        End If

    '        ' Start building HTML content
    '        Dim sb As New StringBuilder()

    '        ' Add HTML header with styling
    '        sb.AppendLine("<!DOCTYPE html>")
    '        sb.AppendLine("<html>")
    '        sb.AppendLine("<head>")
    '        sb.AppendLine("<meta http-equiv=""Content-Type"" content=""text/html; charset=utf-8"" />")
    '        sb.AppendLine("<title>" & reportType & " Report</title>")
    '        sb.AppendLine("<style type=""text/css"">")
    '        sb.AppendLine("  body { font-family: Arial, sans-serif; }")
    '        sb.AppendLine("  table { border-collapse: collapse; width: 100%; }")
    '        sb.AppendLine("  th { background-color: #f2f2f2; font-weight: bold; text-align: left; padding: 8px; border: 1px solid #ddd; }")
    '        sb.AppendLine("  td { padding: 8px; border: 1px solid #ddd; }")
    '        sb.AppendLine("  tr:nth-child(even) { background-color: #f9f9f9; }")
    '        sb.AppendLine("  .title { font-size: 20px; font-weight: bold; margin-bottom: 10px; text-align: center; }")
    '        sb.AppendLine("  .subtitle { font-size: 14px; margin-bottom: 15px; text-align: center; }")
    '        sb.AppendLine("  .currency { text-align: right; }")
    '        sb.AppendLine("  .date { text-align: center; }")
    '        sb.AppendLine("  .status-completed, .status-active, .status-resolved { background-color: #d4edda; }")
    '        sb.AppendLine("  .status-processing, .status-pending { background-color: #fff3cd; }")
    '        sb.AppendLine("  .status-cancelled, .status-inactive { background-color: #f8d7da; }")
    '        sb.AppendLine("</style>")
    '        sb.AppendLine("</head>")
    '        sb.AppendLine("<body>")

    '        ' Add report title and metadata
    '        sb.AppendLine("<div class=""title"">" & reportType.ToUpper() & " REPORT</div>")
    '        sb.AppendLine("<div class=""subtitle"">Date Range: " & litDateRange.Text & "</div>")
    '        sb.AppendLine("<div class=""subtitle"">Total Records: " & litTotalRecords.Text & "</div>")

    '        ' Start table
    '        sb.AppendLine("<table>")

    '        ' Add header row with formatted column names
    '        sb.AppendLine("<tr>")
    '        For Each cell As TableCell In gvReport.HeaderRow.Cells
    '            sb.AppendLine("  <th>" & cell.Text & "</th>")
    '        Next
    '        sb.AppendLine("</tr>")

    '        ' Add data rows with formatting
    '        For i As Integer = 0 To dt.Rows.Count - 1
    '            sb.AppendLine("<tr>")
    '            For j As Integer = 0 To dt.Columns.Count - 1
    '                Dim value As String = If(dt.Rows(i)(j) IsNot DBNull.Value, dt.Rows(i)(j).ToString(), "")
    '                Dim cellClass As String = String.Empty

    '                ' Format based on column type and report type
    '                If reportType = "orders" Then
    '                    ' Format currency
    '                    If j = 2 Then
    '                        ' Total Amount column
    '                        If Decimal.TryParse(value, Nothing) Then
    '                            value = Decimal.Parse(value).ToString("C2")
    '                            cellClass = "currency"
    '                        End If
    '                    ElseIf j = 4 Then
    '                        ' Order Date column
    '                        If DateTime.TryParse(value, Nothing) Then
    '                            value = DateTime.Parse(value).ToString("MM/dd/yyyy")
    '                            cellClass = "date"
    '                        End If
    '                    ElseIf j = 3 Then
    '                        ' Order Status column
    '                        If value.ToLower().Contains("completed") Then
    '                            cellClass = "status-completed"
    '                        ElseIf value.ToLower().Contains("processing") Then
    '                            cellClass = "status-processing"
    '                        ElseIf value.ToLower().Contains("cancelled") Then
    '                            cellClass = "status-cancelled"
    '                        End If
    '                    End If
    '                ElseIf reportType = "menu" Then
    '                    ' Format currency for Price and Final Price
    '                    If j = 4 OrElse j = 5 Then
    '                        If Decimal.TryParse(value, Nothing) Then
    '                            value = Decimal.Parse(value).ToString("C2")
    '                            cellClass = "currency"
    '                        End If
    '                    End If
    '                ElseIf reportType = "messages" OrElse reportType = "feedback" Then
    '                    ' Format date for Submitted At
    '                    If j = 4 Then
    '                        If DateTime.TryParse(value, Nothing) Then
    '                            value = DateTime.Parse(value).ToString("MM/dd/yyyy HH:mm")
    '                            cellClass = "date"
    '                        End If
    '                    End If
    '                    ' Format status
    '                    If j = 5 OrElse (reportType = "feedback" AndAlso j = 3) Then
    '                        If value.ToLower().Contains("resolved") Then
    '                            cellClass = "status-resolved"
    '                        ElseIf value.ToLower().Contains("pending") Then
    '                            cellClass = "status-pending"
    '                        End If
    '                    End If
    '                ElseIf reportType = "daily_sales" Then
    '                    ' Format date for Order Date
    '                    If j = 0 Then
    '                        If DateTime.TryParse(value, Nothing) Then
    '                            value = DateTime.Parse(value).ToString("MM/dd/yyyy")
    '                            cellClass = "date"
    '                        End If
    '                    End If
    '                    ' Format currency for Total Sales
    '                    If j = 1 Then
    '                        If Decimal.TryParse(value, Nothing) Then
    '                            value = Decimal.Parse(value).ToString("C2")
    '                            cellClass = "currency"
    '                        End If
    '                    End If
    '                ElseIf reportType = "customer_summary" OrElse reportType = "loyal_customers" Then
    '                    ' Format currency for Total Spent
    '                    If (reportType = "customer_summary" AndAlso j = 3) OrElse
    '                       (reportType = "loyal_customers" AndAlso j = 2) Then
    '                        If Decimal.TryParse(value, Nothing) Then
    '                            value = Decimal.Parse(value).ToString("C2")
    '                            cellClass = "currency"
    '                        End If
    '                    End If
    '                ElseIf reportType = "active_customers" Then
    '                    ' Format status
    '                    If j = 3 Then
    '                        If value.ToLower().Contains("active") Then
    '                            cellClass = "status-active"
    '                        ElseIf value.ToLower().Contains("inactive") Then
    '                            cellClass = "status-inactive"
    '                        End If
    '                    End If
    '                ElseIf reportType = "revenue_cuisine" Then
    '                    ' Format currency for Total Revenue
    '                    If j = 1 Then
    '                        If Decimal.TryParse(value, Nothing) Then
    '                            value = Decimal.Parse(value).ToString("C2")
    '                            cellClass = "currency"
    '                        End If
    '                    End If
    '                ElseIf reportType = "highest_orders" Then
    '                    ' Format currency for Total Amount
    '                    If j = 2 Then
    '                        If Decimal.TryParse(value, Nothing) Then
    '                            value = Decimal.Parse(value).ToString("C2")
    '                            cellClass = "currency"
    '                        End If
    '                    End If
    '                    ' Format date for Order Date
    '                    If j = 3 Then
    '                        If DateTime.TryParse(value, Nothing) Then
    '                            value = DateTime.Parse(value).ToString("MM/dd/yyyy")
    '                            cellClass = "date"
    '                        End If
    '                    End If
    '                End If

    '                ' Output the cell with appropriate class
    '                If String.IsNullOrEmpty(cellClass) Then
    '                    sb.AppendLine("  <td>" & value & "</td>")
    '                Else
    '                    sb.AppendLine("  <td class=""" & cellClass & """>" & value & "</td>")
    '                End If
    '            Next
    '            sb.AppendLine("</tr>")
    '        Next

    '        ' Close table and HTML
    '        sb.AppendLine("</table>")
    '        sb.AppendLine("</body>")
    '        sb.AppendLine("</html>")

    '        ' Prepare the response
    '        Response.Clear()
    '        Response.Buffer = True
    '        Response.Charset = ""
    '        Response.ContentType = "application/vnd.ms-excel"
    '        Response.AddHeader("content-disposition", "attachment;filename=" & reportType & "_report_" & DateTime.Now.ToString("yyyyMMdd_HHmmss") & ".xls")


    '        Response.Output.Write(sb.ToString())
    '        Response.Flush()
    '        Response.End()

    '    Catch ex As Exception
    '        Response.Clear()
    '        System.IO.File.AppendAllText(Server.MapPath("~/logs/errors.txt"), DateTime.Now.ToString() & " - Excel HTML Export Error: " & ex.Message & Environment.NewLine)
    '        Response.Write("<script>alert('An error occurred during export.');</script>")
    '    End Try
    'End Sub



    Protected Sub btnExportExcel_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnExportCSV.Click
        Try
            ' Get report parameters
            Dim reportType As String = ddlReportType.SelectedValue
            Dim startDate As String = txtStartDate.Text
            Dim endDate As String = txtEndDate.Text

            ' Generate report data
            Dim dt As DataTable = GenerateReport(reportType, startDate, endDate)

            ' Display data in grid view
            gvReport.DataSource = dt
            gvReport.DataBind()

            ' Update UI elements
            UpdateReportMetadata(dt, startDate, endDate)

            ' Check if we have data to export
            If dt Is Nothing OrElse dt.Rows.Count = 0 Then
                ShowMessage("No data to export.")
                Return
            End If

            ' Export the data
            ExportToExcel(dt, reportType)

        Catch ex As Exception
            LogError("Excel HTML Export Error", ex)
            ShowMessage("An error occurred during export.")
        End Try
    End Sub

    Private Sub UpdateReportMetadata(ByVal dt As DataTable, ByVal startDate As String, ByVal endDate As String)
        ' Set record count
        litTotalRecords.Text = If(dt IsNot Nothing, dt.Rows.Count.ToString(), "0")

        ' Set date range text
        If Not String.IsNullOrEmpty(startDate) AndAlso Not String.IsNullOrEmpty(endDate) Then
            litDateRange.Text = FormatDateRange(startDate, endDate)
        Else
            litDateRange.Text = "All Time"
        End If
    End Sub

    Private Function FormatDateRange(ByVal startDate As String, ByVal endDate As String) As String
        Try
            Return Convert.ToDateTime(startDate).ToString("MMM dd, yyyy") & " - " & Convert.ToDateTime(endDate).ToString("MMM dd, yyyy")
        Catch
            Return "Invalid Date Range"
        End Try
    End Function

    Private Sub ExportToExcel(ByVal dt As DataTable, ByVal reportType As String)
        ' Create HTML builder
        Dim sb As New StringBuilder()

        ' Add HTML document structure with enhanced styling
        BuildHtmlHeader(sb, reportType)

        ' Add report metadata
        BuildReportMetadata(sb, reportType)

        ' Build table with data
        BuildDataTable(sb, dt, reportType)

        ' Close HTML document
        sb.AppendLine("</body>")
        sb.AppendLine("</html>")

        ' Send to browser as Excel file
        SendExcelResponse(sb.ToString(), reportType)
    End Sub

    Private Sub BuildHtmlHeader(ByVal sb As StringBuilder, ByVal reportType As String)
        sb.AppendLine("<!DOCTYPE html>")
        sb.AppendLine("<html>")
        sb.AppendLine("<head>")
        sb.AppendLine("<meta http-equiv=""Content-Type"" content=""text/html; charset=utf-8"" />")
        sb.AppendLine("<title>" & reportType & " Report</title>")
        sb.AppendLine("<style type=""text/css"">")
        sb.AppendLine("  body { font-family: Arial, sans-serif; margin: 20px; }")
        sb.AppendLine("  table { border-collapse: collapse; width: 100%; margin-top: 20px; }")
        sb.AppendLine("  th { background-color: #4472C4; color: white; font-weight: bold; text-align: left; padding: 10px; border: 1px solid #ddd; }")
        sb.AppendLine("  td { padding: 8px; border: 1px solid #ddd; }")
        sb.AppendLine("  tr:nth-child(even) { background-color: #f2f6fc; }")
        sb.AppendLine("  tr:hover { background-color: #e6eef9; }")
        sb.AppendLine("  .title { font-size: 22px; font-weight: bold; margin-bottom: 10px; color: #2F5597; }")
        sb.AppendLine("  .subtitle { font-size: 14px; margin-bottom: 5px; color: #555; }")
        sb.AppendLine("  .metadata { margin-bottom: 20px; border-bottom: 1px solid #ddd; padding-bottom: 10px; }")
        sb.AppendLine("  .currency { text-align: right; }")
        sb.AppendLine("  .number { text-align: right; }")
        sb.AppendLine("  .date { text-align: center; }")
        sb.AppendLine("  .status-completed, .status-active, .status-resolved { background-color: #d4edda; color: #155724; }")
        sb.AppendLine("  .status-processing, .status-pending { background-color: #fff3cd; color: #856404; }")
        sb.AppendLine("  .status-cancelled, .status-inactive { background-color: #f8d7da; color: #721c24; }")
        sb.AppendLine("  .footer { margin-top: 20px; font-size: 12px; color: #777; text-align: center; }")
        sb.AppendLine("</style>")
        sb.AppendLine("</head>")
        sb.AppendLine("<body>")
    End Sub

    Private Sub BuildReportMetadata(ByVal sb As StringBuilder, ByVal reportType As String)
        sb.AppendLine("<div class=""metadata"">")
        sb.AppendLine("  <div class=""title"">" & reportType.ToUpper() & " REPORT</div>")
        sb.AppendLine("  <div class=""subtitle"">Date Range: " & litDateRange.Text & "</div>")
        sb.AppendLine("  <div class=""subtitle"">Total Records: " & litTotalRecords.Text & "</div>")
        sb.AppendLine("  <div class=""subtitle"">Generated: " & DateTime.Now.ToString("MMMM dd, yyyy hh:mm tt") & "</div>")
        sb.AppendLine("</div>")
    End Sub

    Private Sub BuildDataTable(ByVal sb As StringBuilder, ByVal dt As DataTable, ByVal reportType As String)
        ' Start table
        sb.AppendLine("<table>")

        ' Add header row with formatted column names
        sb.AppendLine("<tr>")
        For Each cell As TableCell In gvReport.HeaderRow.Cells
            sb.AppendLine("  <th>" & cell.Text & "</th>")
        Next
        sb.AppendLine("</tr>")

        ' Add data rows with formatting
        For i As Integer = 0 To dt.Rows.Count - 1
            sb.AppendLine("<tr>")
            For j As Integer = 0 To dt.Columns.Count - 1
                Dim value As String = If(dt.Rows(i)(j) IsNot DBNull.Value, dt.Rows(i)(j).ToString(), "")
                Dim formattedValue As String = value
                Dim cellClass As String = GetCellClass(reportType, j, value)

                ' Format value based on column type
                formattedValue = FormatCellValue(reportType, j, value)

                ' Output the cell with appropriate class
                If String.IsNullOrEmpty(cellClass) Then
                    sb.AppendLine("  <td>" & formattedValue & "</td>")
                Else
                    sb.AppendLine("  <td class=""" & cellClass & """>" & formattedValue & "</td>")
                End If
            Next
            sb.AppendLine("</tr>")
        Next

        ' Close table
        sb.AppendLine("</table>")

        ' Add footer
        sb.AppendLine("<div class=""footer"">This report was automatically generated by Cloud Kitchen system.</div>")
    End Sub

    Private Function GetCellClass(ByVal reportType As String, ByVal columnIndex As Integer, ByVal value As String) As String

        Select Case reportType
            Case "orders"
                If columnIndex = 2 Then ' Total Amount
                    Return "currency"
                ElseIf columnIndex = 4 Then ' Order Date
                    Return "date"
                ElseIf columnIndex = 3 Then ' Order Status
                    If value.ToLower().Contains("completed") Then
                        Return "status-completed"
                    ElseIf value.ToLower().Contains("processing") Then
                        Return "status-processing"
                    ElseIf value.ToLower().Contains("cancelled") Then
                        Return "status-cancelled"
                    End If
                End If

            Case "menu"
                If columnIndex = 4 OrElse columnIndex = 5 Then ' Price and Final Price
                    Return "currency"
                End If

            Case "messages", "feedback"
                If columnIndex = 4 Then ' Submitted At
                    Return "date"
                ElseIf columnIndex = 5 OrElse (reportType = "feedback" AndAlso columnIndex = 3) Then ' Status
                    If value.ToLower().Contains("resolved") Then
                        Return "status-resolved"
                    ElseIf value.ToLower().Contains("pending") Then
                        Return "status-pending"
                    End If
                End If

            Case "daily_sales"
                If columnIndex = 0 Then ' Order Date
                    Return "date"
                ElseIf columnIndex = 1 Then ' Total Sales
                    Return "currency"
                End If

            Case "customer_summary", "loyal_customers"
                If (reportType = "customer_summary" AndAlso columnIndex = 3) OrElse
                   (reportType = "loyal_customers" AndAlso columnIndex = 2) Then ' Total Spent
                    Return "currency"
                End If

            Case "active_customers"
                If columnIndex = 3 Then ' Status
                    If value.ToLower().Contains("active") Then
                        Return "status-active"
                    ElseIf value.ToLower().Contains("inactive") Then
                        Return "status-inactive"
                    End If
                End If

            Case "revenue_cuisine"
                If columnIndex = 1 Then ' Total Revenue
                    Return "currency"
                End If

            Case "highest_orders"
                If columnIndex = 2 Then ' Total Amount
                    Return "currency"
                ElseIf columnIndex = 3 Then ' Order Date
                    Return "date"
                End If
        End Select

        Return String.Empty
    End Function

    Private Function FormatCellValue(ByVal reportType As String, ByVal columnIndex As Integer, ByVal value As String) As String
        ' Format cell value based on its data type and report type
        If String.IsNullOrEmpty(value) Then
            Return ""
        End If

        ' Try to identify and format data types
        Dim numericValue As Decimal
        Dim dateValue As DateTime

        ' Format currency values
        If IsCurrencyColumn(reportType, columnIndex) AndAlso Decimal.TryParse(value, numericValue) Then
            Return numericValue.ToString("C2")
        End If

        ' Format date values
        If IsDateColumn(reportType, columnIndex) AndAlso DateTime.TryParse(value, dateValue) Then
            ' Use different date formats based on column needs
            If IsDateTimeColumn(reportType, columnIndex) Then
                Return dateValue.ToString("MM/dd/yyyy HH:mm")
            Else
                Return dateValue.ToString("MM/dd/yyyy")
            End If
        End If

        ' If no special formatting needed, return as is
        Return value
    End Function

    Private Function IsCurrencyColumn(ByVal reportType As String, ByVal columnIndex As Integer) As Boolean
        ' Identify columns that should be formatted as currency
        Select Case reportType
            Case "orders"
                Return columnIndex = 2
            Case "menu"
                Return columnIndex = 4 OrElse columnIndex = 5
            Case "daily_sales"
                Return columnIndex = 1
            Case "customer_summary"
                Return columnIndex = 3
            Case "loyal_customers"
                Return columnIndex = 2
            Case "revenue_cuisine"
                Return columnIndex = 1
            Case "highest_orders"
                Return columnIndex = 2
            Case Else
                Return False
        End Select
    End Function

    Private Function IsDateColumn(ByVal reportType As String, ByVal columnIndex As Integer) As Boolean
        ' Identify columns that should be formatted as dates
        Select Case reportType
            Case "orders"
                Return columnIndex = 4
            Case "messages", "feedback"
                Return columnIndex = 4
            Case "daily_sales"
                Return columnIndex = 0
            Case "highest_orders"
                Return columnIndex = 3
            Case Else
                Return False
        End Select
    End Function

    Private Function IsDateTimeColumn(ByVal reportType As String, ByVal columnIndex As Integer) As Boolean

        Return (reportType = "messages" OrElse reportType = "feedback") AndAlso columnIndex = 4
    End Function

    Private Sub SendExcelResponse(ByVal html As String, ByVal reportType As String)
        Response.Clear()
        Response.Buffer = True
        Response.Charset = ""
        Response.ContentType = "application/vnd.ms-excel"
        Response.AddHeader("content-disposition", "attachment;filename=" & reportType & "_report_" & DateTime.Now.ToString("yyyyMMdd_HHmmss") & ".xls")
        Response.Output.Write(html)
        Response.Flush()
        Response.End()
    End Sub

    Private Sub ShowMessage(ByVal message As String)
        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alert", "alert('{message}');", True)
    End Sub

    Private Sub LogError(ByVal errorType As String, ByVal ex As Exception)
        Dim logPath As String = Server.MapPath("~/logs/errors.txt")
        Dim logMessage As String = DateTime.Now.ToString() & " - " & errorType & ": " & ex.Message

        ' Add stack trace for more detailed debugging
        logMessage &= Environment.NewLine & "Stack Trace: " & ex.StackTrace

        ' Ensure directory exists
        Dim logDir As String = Path.GetDirectoryName(logPath)
        If Not Directory.Exists(logDir) Then
            Directory.CreateDirectory(logDir)
        End If

        ' Append to log file
        System.IO.File.AppendAllText(logPath, logMessage & Environment.NewLine & Environment.NewLine)
    End Sub


    Protected Sub btnExportCSV_Click(ByVal sender As Object, ByVal e As EventArgs)
        Try


            Dim reportType As String = ddlReportType.SelectedValue
            Dim startDate As String = txtStartDate.Text
            Dim endDate As String = txtEndDate.Text

            Dim dt As DataTable = GenerateReport(reportType, startDate, endDate)
            gvReport.DataSource = dt
            gvReport.DataBind()

            litTotalRecords.Text = dt.Rows.Count.ToString()

            If Not String.IsNullOrEmpty(startDate) AndAlso Not String.IsNullOrEmpty(endDate) Then
                litDateRange.Text = Convert.ToDateTime(startDate).ToString("MMM dd, yyyy") & " - " & Convert.ToDateTime(endDate).ToString("MMM dd, yyyy")
            Else
                litDateRange.Text = "All Time"
            End If


            If gvReport.Rows.Count > 0 Then
                ' Format the header row based on report type
                Select Case reportType
                    Case "orders"
                        gvReport.HeaderRow.Cells(0).Text = "Order ID"
                        gvReport.HeaderRow.Cells(1).Text = "Customer Name"
                        gvReport.HeaderRow.Cells(2).Text = "Total Amount"
                        gvReport.HeaderRow.Cells(3).Text = "Order Status"
                        gvReport.HeaderRow.Cells(4).Text = "Order Date"
                        gvReport.HeaderRow.Cells(5).Text = "Payment Type"
                        gvReport.HeaderRow.Cells(6).Text = "Address"
                        gvReport.HeaderRow.Cells(7).Text = "Pincode"

                        ' Format currency and date columns
                        FormatCurrencyColumn(2)
                        FormatDateColumn(4)

                    Case "customers"
                        gvReport.HeaderRow.Cells(0).Text = "Customer ID"
                        gvReport.HeaderRow.Cells(1).Text = "Customer Name"
                        gvReport.HeaderRow.Cells(2).Text = "Email"
                        gvReport.HeaderRow.Cells(3).Text = "Phone"

                    Case "menu"
                        gvReport.HeaderRow.Cells(0).Text = "Menu ID"
                        gvReport.HeaderRow.Cells(1).Text = "Item Name"
                        gvReport.HeaderRow.Cells(2).Text = "Category"
                        gvReport.HeaderRow.Cells(3).Text = "Cuisine"
                        gvReport.HeaderRow.Cells(4).Text = "Price"
                        gvReport.HeaderRow.Cells(5).Text = "Final Price"
                        gvReport.HeaderRow.Cells(6).Text = "Availability"

                        ' Format currency columns
                        FormatCurrencyColumn(4)
                        FormatCurrencyColumn(5)

                    Case "messages"
                        gvReport.HeaderRow.Cells(0).Text = "Message ID"
                        gvReport.HeaderRow.Cells(1).Text = "Sender Name"
                        gvReport.HeaderRow.Cells(2).Text = "Email"
                        gvReport.HeaderRow.Cells(3).Text = "Message"
                        gvReport.HeaderRow.Cells(4).Text = "Submitted At"
                        gvReport.HeaderRow.Cells(5).Text = "Status"

                        ' Format date column
                        FormatDateColumn(4)

                    Case "daily_sales"
                        gvReport.HeaderRow.Cells(0).Text = "Order Date"
                        gvReport.HeaderRow.Cells(1).Text = "Total Sales"

                        ' Format date and currency columns
                        FormatDateColumn(0)
                        FormatCurrencyColumn(1)

                    Case "top_selling"
                        gvReport.HeaderRow.Cells(0).Text = "Item Name"
                        gvReport.HeaderRow.Cells(1).Text = "Category"
                        gvReport.HeaderRow.Cells(2).Text = "Total Sold"

                    Case "customer_summary"
                        gvReport.HeaderRow.Cells(0).Text = "Customer Name"
                        gvReport.HeaderRow.Cells(1).Text = "Email"
                        gvReport.HeaderRow.Cells(2).Text = "Total Orders"
                        gvReport.HeaderRow.Cells(3).Text = "Total Spent"

                        ' Format currency column
                        FormatCurrencyColumn(3)

                    Case "active_customers"
                        gvReport.HeaderRow.Cells(0).Text = "Customer Name"
                        gvReport.HeaderRow.Cells(1).Text = "Email"
                        gvReport.HeaderRow.Cells(2).Text = "Order Count"
                        gvReport.HeaderRow.Cells(3).Text = "Status"

                        ' Apply status styling
                        FormatStatusColumn(3)

                    Case "revenue_cuisine"
                        gvReport.HeaderRow.Cells(0).Text = "Cuisine Name"
                        gvReport.HeaderRow.Cells(1).Text = "Total Revenue"

                        ' Format currency column
                        FormatCurrencyColumn(1)

                    Case "order_status"
                        gvReport.HeaderRow.Cells(0).Text = "Order Status"
                        gvReport.HeaderRow.Cells(1).Text = "Total Orders"

                    Case "loyal_customers"
                        gvReport.HeaderRow.Cells(0).Text = "Customer Name"
                        gvReport.HeaderRow.Cells(1).Text = "Total Orders"
                        gvReport.HeaderRow.Cells(2).Text = "Total Spent"

                        ' Format currency column
                        FormatCurrencyColumn(2)

                    Case "highest_orders"
                        gvReport.HeaderRow.Cells(0).Text = "Order ID"
                        gvReport.HeaderRow.Cells(1).Text = "Customer Name"
                        gvReport.HeaderRow.Cells(2).Text = "Total Amount"
                        gvReport.HeaderRow.Cells(3).Text = "Order Date"

                        ' Format currency and date columns
                        FormatCurrencyColumn(2)
                        FormatDateColumn(3)

                    Case "feedback"
                        gvReport.HeaderRow.Cells(0).Text = "Customer Name"
                        gvReport.HeaderRow.Cells(1).Text = "Message"
                        gvReport.HeaderRow.Cells(2).Text = "Submitted At"
                        gvReport.HeaderRow.Cells(3).Text = "Status"

                        FormatDateColumn(2)

                        FormatStatusColumn(3)
                End Select
            End If


            If dt Is Nothing OrElse dt.Rows.Count = 0 Then
                Response.Write("<script>alert('No data to export.');</script>")
                Return
            End If

            Dim sb As New StringBuilder()

            Dim headerRow As New List(Of String)
            For Each cell As TableCell In gvReport.HeaderRow.Cells
                headerRow.Add("""" & cell.Text.Replace("""", """""") & """")
            Next
            sb.AppendLine(String.Join(",", headerRow))

            ' Add data rows
            For Each row As DataRow In dt.Rows
                Dim dataRow As New List(Of String)
                For Each column As DataColumn In dt.Columns
                    Dim value As String = If(row(column) IsNot DBNull.Value, row(column).ToString(), "")
                    dataRow.Add("""" & value.Replace("""", """""") & """")
                Next
                sb.AppendLine(String.Join(",", dataRow))
            Next

            Response.Clear()
            Response.Buffer = True
            Response.AddHeader("content-disposition", "attachment;filename=" & reportType & "_report_" & DateTime.Now.ToString("yyyyMMdd_HHmmss") & ".csv")
            Response.Charset = ""
            Response.ContentType = "application/text"
            Response.Output.Write(sb.ToString())
            Response.Flush()
            Response.SuppressContent = True ' Suppresses further content output


        Catch ex As Exception
            Response.Clear()
            System.IO.File.AppendAllText(Server.MapPath("~/logs/errors.txt"), DateTime.Now.ToString() & " - CSV Export Error: " & ex.Message & Environment.NewLine)
        End Try

    End Sub

    Protected Sub gvReport_PageIndexChanging(ByVal sender As Object, ByVal e As GridViewPageEventArgs) Handles gvReport.PageIndexChanging
        gvReport.PageIndex = e.NewPageIndex
        Dim reportType As String = ddlReportType.SelectedValue
        Dim startDate As String = txtStartDate.Text
        Dim endDate As String = txtEndDate.Text

        Dim dt As DataTable = GenerateReport(reportType, startDate, endDate)
        gvReport.DataSource = dt
        gvReport.DataBind()

        ' Reapply formatting
        If gvReport.Rows.Count > 0 Then
            Select Case reportType
                Case "orders", "highest_orders"
                    FormatCurrencyColumn(2)
                    FormatDateColumn(If(reportType = "orders", 4, 3))

                Case "menu"
                    FormatCurrencyColumn(4)
                    FormatCurrencyColumn(5)

                Case "messages", "feedback"
                    FormatDateColumn(If(reportType = "messages", 4, 2))
                    FormatStatusColumn(If(reportType = "messages", 5, 3))

                Case "daily_sales"
                    FormatDateColumn(0)
                    FormatCurrencyColumn(1)

                Case "customer_summary", "loyal_customers"
                    FormatCurrencyColumn(If(reportType = "customer_summary", 3, 2))

                Case "active_customers"
                    FormatStatusColumn(3)

                Case "revenue_cuisine"
                    FormatCurrencyColumn(1)
            End Select
        End If
    End Sub

    Public Overrides Sub VerifyRenderingInServerForm(ByVal control As Control)

    End Sub

End Class