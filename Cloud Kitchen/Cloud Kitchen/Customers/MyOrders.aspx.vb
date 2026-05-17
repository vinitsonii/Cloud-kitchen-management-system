Imports System.Data.SqlClient
Imports System.Data
Imports System.IO

Partial Class MyOrders
    Inherits System.Web.UI.Page

    Dim connString As String = ConfigurationManager.ConnectionStrings("constr").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then

            If Session("c_id") Is Nothing Then
                Response.Redirect("Login.aspx")
            End If
            LoadOrders()
        End If
    End Sub
    Protected Sub ddlStatus_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
        LoadOrders()
    End Sub

    Protected Sub btnFilter_Click(ByVal sender As Object, ByVal e As EventArgs)
        LoadOrders()
    End Sub

    Private Sub LoadOrders()
        Dim statusFilter As String = ddlStatus.SelectedValue
        Dim startDate As String = txtStartDate.Text
        Dim endDate As String = txtEndDate.Text

        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT order_id, order_date, transaction_number, total_amount, payment_type, address AS delivery_address, pincode, order_status FROM Orders WHERE c_id = @CustomerId"

            ' Add Status Filter
            If Not String.IsNullOrEmpty(statusFilter) Then
                query &= " AND order_status = @Status"
            End If

            ' Add Date Range Filter
            If Not String.IsNullOrEmpty(startDate) And Not String.IsNullOrEmpty(endDate) Then
                query &= " AND order_date BETWEEN @StartDate AND @EndDate"
            End If

            query &= " ORDER BY order_date DESC"

            Dim cmd As New SqlCommand(query, conn)
            cmd.Parameters.AddWithValue("@CustomerId", Session("c_id"))

            ' Add status parameter if a filter is selected
            If Not String.IsNullOrEmpty(statusFilter) Then
                cmd.Parameters.AddWithValue("@Status", statusFilter)
            End If

            ' Add date parameters if a range is selected
            If Not String.IsNullOrEmpty(startDate) And Not String.IsNullOrEmpty(endDate) Then
                cmd.Parameters.AddWithValue("@StartDate", Convert.ToDateTime(startDate))
                cmd.Parameters.AddWithValue("@EndDate", Convert.ToDateTime(endDate).AddDays(1)) ' Include full end date
            End If

            Dim dt As New DataTable()
            Dim adapter As New SqlDataAdapter(cmd)
            adapter.Fill(dt)

            ' Fetch order items for each order
            dt.Columns.Add("OrderItems", GetType(DataTable)) ' Add new column for nested data
            For Each row As DataRow In dt.Rows
                Dim orderId As Integer = Convert.ToInt32(row("order_id"))
                row("OrderItems") = GetOrderItems(orderId)
            Next

            rptOrders.DataSource = dt
            rptOrders.DataBind()
        End Using
    End Sub


    Private Function GetOrderItems(ByVal orderId As Integer) As DataTable
        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT mi.m_name AS item_name, od.quantity, od.price, od.total_price FROM Order_Details od INNER JOIN Menu_Item mi ON od.m_id = mi.m_id WHERE od.order_id = @OrderId"

            Dim cmd As New SqlCommand(query, conn)
            cmd.Parameters.AddWithValue("@OrderId", orderId)

            Dim dt As New DataTable()
            Dim adapter As New SqlDataAdapter(cmd)
            adapter.Fill(dt)
            Return dt
        End Using
    End Function

    Public Function GetStatusClass(ByVal orderStatus As String) As String
        Select Case orderStatus.ToLower()
            Case "pending"
                Return "status-pending"
            Case "completed"
                Return "status-completed"
            Case "cancelled"
                Return "status-cancelled"
            Case Else
                Return ""
        End Select
    End Function

    Protected Sub btnReorder_Click(ByVal sender As Object, ByVal e As EventArgs)
        If Session("c_id") IsNot Nothing Then
            Dim btn As Button = CType(sender, Button)
            Dim orderId As Integer

            ' Ensure the Order ID is valid
            If Integer.TryParse(btn.CommandArgument.ToString(), orderId) Then
                Dim cart As List(Of Dictionary(Of String, Object))

                ' Initialize the cart if it doesn't exist
                If Session("Cart") Is Nothing Then
                    cart = New List(Of Dictionary(Of String, Object))
                Else
                    cart = CType(Session("Cart"), List(Of Dictionary(Of String, Object)))
                End If

                ' Retrieve all items from the selected order
                Dim orderItems As List(Of Dictionary(Of String, Object)) = GetOrderItemsList(orderId)

                ' Loop through each item and add/update in the session cart
                For Each item In orderItems
                    Dim menuId As Integer = Convert.ToInt32(item("m_id"))

                    ' Check if item already exists in cart
                    Dim existingItem = cart.FirstOrDefault(Function(x) x("m_id") = menuId)

                    If existingItem IsNot Nothing Then
                        existingItem("quantity") += item("quantity")
                        existingItem("total_price") = existingItem("quantity") * existingItem("m_final_price")
                    Else
                        Dim menuItem As Dictionary(Of String, Object) = GetMenuItem(menuId)

                        If menuItem IsNot Nothing AndAlso menuItem.Count > 0 Then
                            menuItem("quantity") = item("quantity")
                            menuItem("total_price") = menuItem("quantity") * menuItem("m_final_price")
                            cart.Add(menuItem)
                        End If
                    End If
                Next

                ' Store updated cart back in session
                Session("Cart") = cart

                ' Redirect to cart page
                Response.Redirect("Cart.aspx")
            End If
        End If
    End Sub

    Private Function GetMenuItem(ByVal menuId As Integer) As Dictionary(Of String, Object)
        Dim menuItem As New Dictionary(Of String, Object)()

        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT m_id, m_name, m_image_url, m_final_price FROM Menu_Item WHERE m_id = @MenuId"
            Dim cmd As New SqlCommand(query, conn)
            cmd.Parameters.AddWithValue("@MenuId", menuId)

            conn.Open()
            Dim reader As SqlDataReader = cmd.ExecuteReader()

            If reader.Read() Then
                menuItem("m_id") = reader("m_id")
                menuItem("m_name") = reader("m_name")
                menuItem("m_image_url") = reader("m_image_url")
                menuItem("m_final_price") = reader("m_final_price")
            End If
        End Using

        Return menuItem
    End Function

    Private Function GetOrderItemsList(ByVal orderId As Integer) As List(Of Dictionary(Of String, Object))
        Dim orderItems As New List(Of Dictionary(Of String, Object))()

        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT mi.m_id, mi.m_name, mi.m_image_url, mi.m_final_price, od.quantity " &
                                  "FROM Order_Details od " &
                                  "INNER JOIN Menu_Item mi ON od.m_id = mi.m_id " &
                                  "WHERE od.order_id = @OrderId"

            Dim cmd As New SqlCommand(query, conn)
            cmd.Parameters.AddWithValue("@OrderId", orderId)

            conn.Open()
            Dim reader As SqlDataReader = cmd.ExecuteReader()

            While reader.Read()
                Dim item As New Dictionary(Of String, Object) From {
                    {"m_id", reader("m_id")},
                    {"m_name", reader("m_name")},
                    {"m_image_url", reader("m_image_url")},
                    {"m_final_price", reader("m_final_price")},
                    {"quantity", reader("quantity")}
                }
                orderItems.Add(item)
            End While
        End Using

        Return orderItems
    End Function
    Protected Sub btnPrintBill_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim btn As Button = CType(sender, Button)
        Dim orderId As String = btn.CommandArgument
        Dim dt As DataTable = GetOrderDetails(orderId)
        Dim customerDetails As DataRow = GetCustomerDetails(orderId)

        If dt.Rows.Count > 0 AndAlso customerDetails IsNot Nothing Then
            Dim htmlContent As String = GenerateInvoiceHTML(dt, customerDetails)

            Response.Clear()
            Response.Write("<html><head>")
            Response.Write("<script>")
            Response.Write("window.onload = function() { window.print(); };")
            Response.Write("</script>")
            Response.Write("</head><body>")
            Response.Write(htmlContent)
            Response.Write("</body></html>")
            Response.End()
        End If
    End Sub



    Private Function GetOrderDetails(ByVal orderId As String) As DataTable
        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT o.order_id, o.total_amount, o.order_date, o.payment_type, o.address, o.pincode, " &
                                  "od.quantity, od.price, od.total_price, mi.m_name " &
                                  "FROM Orders o " &
                                  "INNER JOIN Order_Details od ON o.order_id = od.order_id " &
                                  "INNER JOIN Menu_Item mi ON od.m_id = mi.m_id " &
                                  "WHERE o.order_id = @OrderId"

            Dim cmd As New SqlCommand(query, conn)
            cmd.Parameters.AddWithValue("@OrderId", orderId)

            Dim dt As New DataTable()
            Dim adapter As New SqlDataAdapter(cmd)
            adapter.Fill(dt)
            Return dt
        End Using
    End Function

    Private Function GenerateInvoiceHTML(ByVal dt As DataTable, ByVal customer As DataRow) As String

        Dim html As New StringBuilder()
        Dim grandTotal As Decimal = 0D

        html.Append("<!DOCTYPE html>")
        html.Append("<html>")
        html.Append("<head>")
        html.Append("<meta charset='UTF-8'>")
        html.Append("<meta name='viewport' content='width=device-width, initial-scale=1.0'>")

        ' Bootstrap + Icons
        html.Append("<link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css' rel='stylesheet'>")
        html.Append("<link href='https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css' rel='stylesheet'>")

        ' Google Font
        html.Append("<link href='https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap' rel='stylesheet'>")

        html.Append("<title>Invoice</title>")

        html.Append("<style>")

        ' =========================================
        ' PRINT COLOR SUPPORT
        ' =========================================
        html.Append("*{")
        html.Append("-webkit-print-color-adjust:exact !important;")
        html.Append("print-color-adjust:exact !important;")
        html.Append("}")

        ' =========================================
        ' HIDING SOMEE ADS
        ' =========================================
        html.Append("a[href*=""somee""]{display:none!important;}")
        html.Append(".somee-footer,[id*=""somee-footer""],[class*=""somee-footer""]{display:none!important;}")
        html.Append("div[style*=""background-color: #202020""][style*=""bottom: 0px""]{display:none!important;}")
        html.Append("div[onmouseover=""S_ssac();""]{display:none!important;}")
        html.Append("div[style=""height: 65px;""]{display:none!important;}")
        html.Append("iframe[src*=""somee""]{display:none!important;}")

        ' =========================================
        ' BODY
        ' =========================================
        html.Append("html,body{")
        html.Append("overflow-x:hidden!important;")
        html.Append("margin:0!important;")
        html.Append("padding:0!important;")
        html.Append("background:#f4f7fb;")
        html.Append("font-family:'Poppins',sans-serif;")
        html.Append("color:#1f2937;")
        html.Append("font-size:13px;")
        html.Append("line-height:1.4;")
        html.Append("}")

        ' =========================================
        ' WRAPPER
        ' =========================================
        html.Append(".invoice-wrapper{")
        html.Append("max-width:850px;")
        html.Append("margin:20px auto;")
        html.Append("background:#fff;")
        html.Append("border-radius:20px;")
        html.Append("overflow:hidden;")
        html.Append("box-shadow:0 15px 45px rgba(0,0,0,.08);")
        html.Append("}")

        ' =========================================
        ' HEADER
        ' =========================================
        html.Append(".invoice-top{")
        html.Append("background:linear-gradient(135deg,#4F7E76,#355b54)!important;")
        html.Append("padding:28px 35px;")
        html.Append("color:#fff!important;")
        html.Append("}")

        html.Append(".brand-title{")
        html.Append("font-size:32px;")
        html.Append("font-weight:800;")
        html.Append("margin-bottom:5px;")
        html.Append("}")

        html.Append(".invoice-badge{")
        html.Append("background:rgba(255,255,255,.15);")
        html.Append("padding:8px 18px;")
        html.Append("border-radius:50px;")
        html.Append("font-weight:600;")
        html.Append("display:inline-block;")
        html.Append("font-size:13px;")
        html.Append("}")

        ' =========================================
        ' BODY CONTENT
        ' =========================================
        html.Append(".invoice-body{")
        html.Append("padding:28px 35px;")
        html.Append("}")

        html.Append(".section-title{")
        html.Append("font-size:12px;")
        html.Append("font-weight:700;")
        html.Append("letter-spacing:1px;")
        html.Append("text-transform:uppercase;")
        html.Append("color:#6b7280;")
        html.Append("margin-bottom:10px;")
        html.Append("}")

        html.Append(".info-card{")
        html.Append("background:#f8fafc;")
        html.Append("padding:18px;")
        html.Append("border-radius:16px;")
        html.Append("height:100%;")
        html.Append("border:1px solid #eef2f7;")
        html.Append("}")

        html.Append(".info-card p{")
        html.Append("margin-bottom:8px;")
        html.Append("font-size:13px;")
        html.Append("}")

        ' =========================================
        ' TABLE
        ' =========================================
        html.Append(".table{")
        html.Append("margin-top:22px;")
        html.Append("margin-bottom:0;")
        html.Append("}")

        html.Append(".table thead th{")
        html.Append("background:#4F7E76!important;")
        html.Append("color:#fff!important;")
        html.Append("border:none!important;")
        html.Append("padding:12px;")
        html.Append("font-size:13px;")
        html.Append("}")

        html.Append(".table tbody td{")
        html.Append("padding:12px;")
        html.Append("vertical-align:middle;")
        html.Append("font-size:13px;")
        html.Append("}")

        html.Append(".table tbody tr:nth-child(even){")
        html.Append("background:#fafafa!important;")
        html.Append("}")

        ' =========================================
        ' TOTAL SECTION
        ' =========================================
        html.Append(".grand-total{")
        html.Append("background:#f8fafc;")
        html.Append("padding:22px;")
        html.Append("border-radius:16px;")
        html.Append("margin-top:22px;")
        html.Append("}")

        html.Append(".grand-total h3{")
        html.Append("font-size:28px;")
        html.Append("font-weight:800;")
        html.Append("color:#4F7E76!important;")
        html.Append("margin:0;")
        html.Append("}")

        ' =========================================
        ' PRINT BUTTON
        ' =========================================
        html.Append(".print-btn{")
        html.Append("background:linear-gradient(135deg,#4F7E76,#355b54);")
        html.Append("border:none;")
        html.Append("padding:13px 30px;")
        html.Append("border-radius:50px;")
        html.Append("color:#fff;")
        html.Append("font-weight:600;")
        html.Append("font-size:14px;")
        html.Append("box-shadow:0 10px 25px rgba(79,126,118,.25);")
        html.Append("transition:.3s;")
        html.Append("}")

        html.Append(".print-btn:hover{")
        html.Append("transform:translateY(-2px);")
        html.Append("}")

        ' =========================================
        ' FOOTER
        ' =========================================
        html.Append(".footer-note{")
        html.Append("text-align:center;")
        html.Append("margin-top:25px;")
        html.Append("font-size:13px;")
        html.Append("color:#6b7280;")
        html.Append("}")

        ' =========================================
        ' PRINT SETTINGS
        ' =========================================
        html.Append("@page{")
        html.Append("size:A4;")
        html.Append("margin:10mm;")
        html.Append("}")

        html.Append("@media print{")

        html.Append("html,body{")
        html.Append("background:#fff!important;")
        html.Append("}")

        html.Append(".invoice-wrapper{")
        html.Append("box-shadow:none!important;")
        html.Append("max-width:100%!important;")
        html.Append("margin:0!important;")
        html.Append("border-radius:0!important;")
        html.Append("}")

        html.Append(".print-area{")
        html.Append("display:none!important;")
        html.Append("}")

        html.Append(".invoice-top{")
        html.Append("background:#4F7E76!important;")
        html.Append("color:#fff!important;")
        html.Append("}")

        html.Append(".table thead th{")
        html.Append("background:#4F7E76!important;")
        html.Append("color:#fff!important;")
        html.Append("}")

        html.Append("}")

        html.Append("</style>")

        ' =========================================
        ' SCRIPT
        ' =========================================
        html.Append("<script>")
        html.Append("function printInvoice(){window.print();}")
        html.Append("</script>")

        html.Append("</head>")
        html.Append("<body>")

        ' =========================================
        ' MAIN WRAPPER
        ' =========================================
        html.Append("<div class='invoice-wrapper'>")

        ' =========================================
        ' HEADER
        ' =========================================
        html.Append("<div class='invoice-top'>")
        html.Append("<div class='d-flex justify-content-between align-items-center flex-wrap gap-3'>")

        html.Append("<div>")
        html.Append("<div class='brand-title'><i class='bi bi-bag-heart-fill'></i> Cloud Kitchen</div>")
        html.Append("<div>Fresh & Delicious Food Delivered To Your Doorstep</div>")
        html.Append("</div>")

        html.Append("<div class='text-end'>")
        html.Append("<div class='invoice-badge'>INVOICE</div>")
        html.Append("<div class='mt-3 small'>")
        html.Append("<div><i class='bi bi-geo-alt-fill'></i> Anand, Gujarat</div>")
        html.Append("<div><i class='bi bi-envelope-fill'></i> info@cloudkitchen.com</div>")
        html.Append("<div><i class='bi bi-telephone-fill'></i> +91 8160698196</div>")
        html.Append("</div>")
        html.Append("</div>")

        html.Append("</div>")
        html.Append("</div>")

        ' =========================================
        ' BODY
        ' =========================================
        html.Append("<div class='invoice-body'>")

        html.Append("<div class='row g-4'>")

        ' CUSTOMER DETAILS
        html.Append("<div class='col-md-6'>")
        html.Append("<div class='info-card'>")
        html.Append("<div class='section-title'>Customer Details</div>")

        html.Append("<p><strong>Name:</strong> " & customer("C_Name") & "</p>")
        html.Append("<p><strong>Phone:</strong> " & customer("Phone") & "</p>")
        html.Append("<p><strong>Address:</strong> " & customer("address") & "</p>")
        html.Append("<p><strong>Pincode:</strong> " & customer("pincode") & "</p>")

        html.Append("</div>")
        html.Append("</div>")

        ' INVOICE INFO
        html.Append("<div class='col-md-6'>")
        html.Append("<div class='info-card'>")
        html.Append("<div class='section-title'>Invoice Info</div>")

        html.Append("<p><strong>Date:</strong> " & DateTime.Now.ToString("dd MMM yyyy") & "</p>")
        html.Append("<p><strong>Time:</strong> " & DateTime.Now.ToString("hh:mm tt") & "</p>")
        html.Append("<p><strong>Status:</strong> Paid</p>")
        html.Append("<p><strong>Payment:</strong> Online</p>")

        html.Append("</div>")
        html.Append("</div>")

        html.Append("</div>")

        ' =========================================
        ' TABLE
        ' =========================================
        html.Append("<table class='table table-bordered align-middle'>")

        html.Append("<thead>")
        html.Append("<tr>")
        html.Append("<th>Item</th>")
        html.Append("<th width='120'>Quantity</th>")
        html.Append("<th width='140'>Price</th>")
        html.Append("<th width='160'>Total</th>")
        html.Append("</tr>")
        html.Append("</thead>")

        html.Append("<tbody>")

        For Each row As DataRow In dt.Rows

            Dim totalPrice As Decimal = Convert.ToDecimal(row("total_price"))
            grandTotal += totalPrice

            html.Append("<tr>")
            html.Append("<td><strong>" & row("m_name") & "</strong></td>")
            html.Append("<td>" & row("quantity") & "</td>")
            html.Append("<td>₹" & Convert.ToDecimal(row("price")).ToString("0.00") & "</td>")
            html.Append("<td><strong>₹" & totalPrice.ToString("0.00") & "</strong></td>")
            html.Append("</tr>")

        Next

        html.Append("</tbody>")
        html.Append("</table>")

        ' =========================================
        ' TOTAL
        ' =========================================
        html.Append("<div class='grand-total text-end'>")
        html.Append("<div class='text-muted mb-2'>Total Amount</div>")
        html.Append("<h3>₹" & grandTotal.ToString("0.00") & "</h3>")
        html.Append("</div>")

        ' =========================================
        ' PRINT BUTTON
        ' =========================================
        html.Append("<div class='print-area text-center mt-4'>")
        html.Append("<button class='print-btn' onclick='printInvoice()'>")
        html.Append("<i class='bi bi-printer-fill'></i> Print Invoice")
        html.Append("</button>")
        html.Append("</div>")

        ' =========================================
        ' FOOTER
        ' =========================================
        html.Append("<div class='footer-note'>")
        html.Append("Thank you for ordering from Cloud Kitchen ❤️")
        html.Append("</div>")

        html.Append("</div>")
        html.Append("</div>")

        html.Append("</body>")
        html.Append("</html>")

        Return html.ToString()

    End Function
    Private Function GetCustomerDetails(ByVal orderId As String) As DataRow
        Dim dt As New DataTable()

        Using conn As New SqlConnection(connString)
            Dim query As String = "SELECT c.C_Name, c.Phone, o.address, o.pincode " &
                                  "FROM Orders o INNER JOIN Customers c ON o.c_id = c.C_Id " &
                                  "WHERE o.order_id = @OrderId"

            Dim cmd As New SqlCommand(query, conn)
            cmd.Parameters.AddWithValue("@OrderId", orderId)

            Dim adapter As New SqlDataAdapter(cmd)
            adapter.Fill(dt)
        End Using

        If dt.Rows.Count > 0 Then
            Return dt.Rows(0)
        End If

        Return Nothing
    End Function

End Class
