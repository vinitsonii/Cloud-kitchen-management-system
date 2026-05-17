Imports System.Data.SqlClient
Imports System.Data
Imports System.Web.Script.Serialization

Partial Class Dashboard
    Inherits System.Web.UI.Page

    Public ChartData As String
    Public OrderStatusData As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Try
                LoadPopularItems()
                LoadDashboardData()
                LoadSalesChartData()
                LoadOrderStatusChartData()
                LoadRecentOrders()

            Catch ex As Exception
                Response.Write("<script>alert('Error: " & ex.Message & "');</script>")
            End Try
        End If
    End Sub

    Private Sub LoadPopularItems()
        Dim connStr As String = ConfigurationManager.ConnectionStrings("constr").ConnectionString
        Dim query As String = "SELECT TOP (3) M.m_name, M.m_image_url, COUNT(OD.m_id) AS OrderCount FROM Order_Details AS OD INNER JOIN menu_item AS M ON OD.m_id = M.m_id GROUP BY M.m_name, M.m_image_url ORDER BY OrderCount DESC"

        Using conn As New SqlConnection(connStr)
            Using cmd As New SqlCommand(query, conn)
                conn.Open()
                Dim dt As New DataTable()
                Dim da As New SqlDataAdapter(cmd)
                da.Fill(dt)


                If dt.Rows.Count > 0 Then
                    rptPopular.DataSource = dt
                    rptPopular.DataBind()
                Else
                    rptPopular.DataSource = Nothing
                    rptPopular.DataBind()
                End If

                conn.Close()
            End Using
        End Using
    End Sub


    Private Sub LoadDashboardData()
        Try
            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("constr").ConnectionString)
                conn.Open()

                Dim totalOrders As Object = New SqlCommand("SELECT COUNT(*) FROM orders", conn).ExecuteScalar()
                lblTotalOrders.Text = If(IsDBNull(totalOrders), "0", totalOrders.ToString())

                Dim revenue As Object = New SqlCommand("SELECT SUM(ISNULL(total_amount, 0)) FROM orders where order_status='Completed'", conn).ExecuteScalar()
                lblTotalRevenue.Text = If(IsDBNull(revenue) OrElse revenue Is Nothing, "0.00", Convert.ToDouble(revenue).ToString("0.00"))

                Dim activeCustomers As Object = New SqlCommand("SELECT COUNT(DISTINCT c_id) FROM orders", conn).ExecuteScalar()
                lblActiveCustomers.Text = If(IsDBNull(activeCustomers), "0", activeCustomers.ToString())

                Dim topDishQuery As String = "SELECT TOP 1 m_name FROM menu_item " & _
                                               "INNER JOIN order_details ON menu_item.m_id = order_details.m_id " & _
                                               "GROUP BY m_name ORDER BY COUNT(order_details.m_id) DESC"
                Dim topDish As Object = New SqlCommand(topDishQuery, conn).ExecuteScalar()
                lblTopDish.Text = If(topDish IsNot Nothing AndAlso Not IsDBNull(topDish), topDish.ToString(), "No Data")
            End Using
        Catch ex As Exception
            Response.Write("<script>alert('Dashboard Data Error: " & ex.Message & "');</script>")
        End Try
    End Sub

    Private Sub LoadSalesChartData()
        Try
            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("constr").ConnectionString)
                conn.Open()
                Dim dt As New DataTable()
                Dim salesQuery As String = "SELECT DATENAME(MONTH, order_date) + ' ' + CAST(YEAR(order_date) AS VARCHAR) AS MonthYear, SUM(total_amount) AS Sales " & _
                                           "FROM orders GROUP BY DATENAME(MONTH, order_date), YEAR(order_date) ORDER BY MIN(order_date)"
                Dim da As New SqlDataAdapter(salesQuery, conn)
                da.Fill(dt)

                Dim chartDataList As New List(Of List(Of Object))()
                chartDataList.Add(New List(Of Object) From {"Month", "Total Sales"}) ' Header

                For Each row As DataRow In dt.Rows
                    chartDataList.Add(New List(Of Object) From {row("MonthYear").ToString(), Convert.ToDecimal(row("Sales"))})
                Next

                Dim serializer As New JavaScriptSerializer()
                ChartData = serializer.Serialize(chartDataList)
                hfChartData.Value = ChartData
            End Using
        Catch ex As Exception
            Response.Write("<script>alert('Sales Chart Error: " & ex.Message & "');</script>")
        End Try
    End Sub

Private Sub LoadOrderStatusChartData()
        Try
            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("constr").ConnectionString)
                conn.Open()
                Dim dt As New DataTable()
                Dim statusQuery As String = "SELECT order_status, COUNT(*) AS Count FROM orders GROUP BY order_status"
                Dim da As New SqlDataAdapter(statusQuery, conn)
                da.Fill(dt)

                Dim chartDataList As New List(Of List(Of Object))()
                chartDataList.Add(New List(Of Object) From {"Order Status", "Count"}) ' Header

                For Each row As DataRow In dt.Rows
                    chartDataList.Add(New List(Of Object) From {row("order_status").ToString(), Convert.ToInt32(row("Count"))})
                Next

                Dim serializer As New JavaScriptSerializer()
                OrderStatusData = serializer.Serialize(chartDataList)
                hfOrderStatusData.Value = OrderStatusData
            End Using
        Catch ex As Exception
            Response.Write("<script>alert('Order Status Chart Error: " & ex.Message & "');</script>")
        End Try
    End Sub


    Private Function GetOrderStatusName(ByVal statusCode As Integer) As String
        Select Case statusCode
            Case 0 : Return "Pending"
            Case 1 : Return "Processing"
            Case 2 : Return "Cancelled"
            Case 3 : Return "Completed"
            Case Else : Return "Unknown"
        End Select
    End Function


    Private Sub LoadRecentOrders()
        Try
            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("constr").ConnectionString)
                conn.Open()
                Dim dt As New DataTable()
                Dim recentOrdersQuery As String = "SELECT TOP 5 orders.order_id, customers.c_name, menu_item.m_name, " & _
                                                  "ISNULL(orders.total_amount, 0) AS total_amount, orders.order_status, orders.order_date " & _
                                                  "FROM orders " & _
                                                  "INNER JOIN customers ON orders.c_id = customers.c_id " & _
                                                  "INNER JOIN order_details ON orders.order_id = order_details.order_id " & _
                                                  "INNER JOIN menu_item ON order_details.m_id = menu_item.m_id " & _
                                                  "ORDER BY orders.order_date DESC"
                Dim da As New SqlDataAdapter(recentOrdersQuery, conn)
                da.Fill(dt)

                gvRecentOrders.DataSource = dt
                gvRecentOrders.DataBind()
            End Using
        Catch ex As Exception
            Response.Write("<script>alert('Recent Orders Error: " & ex.Message & "');</script>")
        End Try
    End Sub
End Class
