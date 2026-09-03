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
            Dim query As String = "SELECT O.order_id, O.order_date, O.transaction_number, O.total_amount, O.payment_type, O.address AS delivery_address, O.pincode, O.order_status, O.delivery_otp, D.driver_name, D.phone AS driver_phone, D.vehicle_no " &
                                  "FROM Orders O LEFT JOIN Drivers D ON O.driver_id = D.driver_id WHERE O.c_id = @CustomerId"

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
            Dim query As String = "SELECT o.order_id, o.total_amount, o.order_date, o.payment_type, o.transaction_number, o.order_status, o.address, o.pincode, " &
                                  "od.quantity, od.price, od.total_price, mi.m_name " &
                                  "FROM Orders o " &
                                  "INNER JOIN Order_Details od ON o.order_id = od.order_id " &
                                  "INNER JOIN Menu_Item mi ON od.m_id = mi.m_id " &
                                  "WHERE o.order_id = @OrderId AND o.c_id = @CustomerId"

            Dim cmd As New SqlCommand(query, conn)
            cmd.Parameters.AddWithValue("@OrderId", orderId)
            cmd.Parameters.AddWithValue("@CustomerId", If(Session("c_id") IsNot Nothing, Session("c_id"), 0))

            Dim dt As New DataTable()
            Dim adapter As New SqlDataAdapter(cmd)
            adapter.Fill(dt)
            Return dt
        End Using
    End Function

    Private Function GenerateInvoiceHTML(ByVal dt As DataTable, ByVal customer As DataRow) As String

        Dim html As New StringBuilder()
        Dim grandTotal As Decimal = 0D

        Dim firstRow As DataRow = dt.Rows(0)
        Dim orderIdStr As String = firstRow("order_id").ToString()
        Dim transactionNo As String = If(IsDBNull(firstRow("transaction_number")), "N/A", firstRow("transaction_number").ToString())
        Dim orderDateStr As String = If(Not IsDBNull(firstRow("order_date")), Convert.ToDateTime(firstRow("order_date")).ToString("dd-MMM-yyyy hh:mm tt"), "N/A")
        Dim paymentTypeStr As String = If(Not IsDBNull(firstRow("payment_type")), firstRow("payment_type").ToString(), "N/A")
        Dim orderStatusStr As String = If(Not IsDBNull(firstRow("order_status")), firstRow("order_status").ToString(), "Completed")

        html.Append("<!DOCTYPE html>")
        html.Append("<html>")
        html.Append("<head>")
        html.Append("<meta charset='UTF-8'>")
        html.Append("<meta name='viewport' content='width=device-width, initial-scale=1.0'>")

        ' Bootstrap + Icons + Google Fonts
        html.Append("<link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css' rel='stylesheet'>")
        html.Append("<link href='https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css' rel='stylesheet'>")
        html.Append("<link href='https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap' rel='stylesheet'>")

        html.Append("<title>Order Receipt #" & orderIdStr & " - Cloud Kitchen</title>")

        html.Append("<style>")
        html.Append("*{ -webkit-print-color-adjust:exact !important; print-color-adjust:exact !important; }")
        html.Append("a[href*=""somee""]{display:none!important;}")
        html.Append(".somee-footer,[id*=""somee-footer""],[class*=""somee-footer""]{display:none!important;}")
        html.Append("div[style*=""background-color: #202020""][style*=""bottom: 0px""]{display:none!important;}")

        html.Append("html,body{ background:#f1f5f9; font-family:'Poppins',sans-serif; color:#0f172a; font-size:13px; margin:0; padding:0; }")
        html.Append(".invoice-wrapper{ max-width:850px; margin:30px auto; background:#ffffff; border-radius:24px; overflow:hidden; box-shadow:0 20px 60px rgba(0,0,0,.12); border:1px solid #ffffff; }")

        html.Append(".invoice-top{ background:linear-gradient(135deg,#4F7E76,#31544e)!important; padding:32px 40px; color:#ffffff!important; }")
        html.Append(".brand-title{ font-size:30px; font-weight:800; margin-bottom:4px; letter-spacing:-0.5px; }")
        html.Append(".invoice-badge{ background:rgba(255,255,255,.18); padding:8px 20px; border-radius:50px; font-weight:800; display:inline-block; font-size:13px; letter-spacing:1px; border:1px solid rgba(255,255,255,.3); }")

        html.Append(".invoice-body{ padding:32px 40px; }")
        html.Append(".section-title{ font-size:12px; font-weight:800; letter-spacing:1px; text-transform:uppercase; color:#64748b; margin-bottom:12px; }")

        html.Append(".info-card{ background:#f8fafc; padding:20px; border-radius:18px; height:100%; border:1px solid #e2e8f0; }")
        html.Append(".info-card p{ margin-bottom:8px; font-size:13.5px; color:#1e293b; }")
        html.Append(".info-card p:last-child{ margin-bottom:0; }")

        html.Append(".table{ margin-top:24px; margin-bottom:0; border-color:#e2e8f0!important; }")
        html.Append(".table thead th{ background:#4F7E76!important; color:#ffffff!important; border:none!important; padding:14px; font-size:13px; font-weight:700; text-transform:uppercase; }")
        html.Append(".table tbody td{ padding:14px; vertical-align:middle; font-size:13.5px; border-color:#f1f5f9!important; }")
        html.Append(".table tbody tr:nth-child(even){ background:#f8fafc!important; }")

        html.Append(".grand-total{ background:#f8fafc; padding:24px; border-radius:18px; margin-top:24px; border:1.5px solid #e2e8f0; }")
        html.Append(".grand-total h3{ font-size:30px; font-weight:800; color:#4F7E76!important; margin:0; }")

        html.Append(".print-btn{ background:linear-gradient(135deg,#ff9f43,#e67e22); border:none; padding:14px 34px; border-radius:50px; color:#ffffff; font-weight:800; font-size:15px; box-shadow:0 10px 25px rgba(255,159,67,.35); transition:.25s; cursor:pointer; }")
        html.Append(".print-btn:hover{ transform:translateY(-2px); box-shadow:0 14px 30px rgba(255,159,67,.45); }")

        html.Append(".footer-note{ text-align:center; margin-top:28px; font-size:13px; color:#64748b; font-weight:500; }")

        html.Append("@page{ size:A4; margin:10mm; }")
        html.Append("@media print{ html,body{ background:#fff!important; } .invoice-wrapper{ box-shadow:none!important; max-width:100%!important; margin:0!important; border-radius:0!important; } .print-area{ display:none!important; } .invoice-top{ background:#4F7E76!important; color:#fff!important; } .table thead th{ background:#4F7E76!important; color:#fff!important; } }")
        html.Append("</style>")

        html.Append("<script>")
        html.Append("function printInvoice(){window.print();}")
        html.Append("</script>")

        html.Append("</head>")
        html.Append("<body>")

        html.Append("<div class='invoice-wrapper'>")

        html.Append("<div class='invoice-top'>")
        html.Append("<div class='d-flex justify-content-between align-items-center flex-wrap gap-3'>")

        html.Append("<div>")
        html.Append("<div class='brand-title'><i class='fas fa-utensils' style='color:#ff9f43;'></i> Cloud Kitchen</div>")
        html.Append("<div>Fresh & Delicious Food Delivered To Your Doorstep</div>")
        html.Append("</div>")

        html.Append("<div class='text-end'>")
        html.Append("<div class='invoice-badge'>OFFICIAL RECEIPT</div>")
        html.Append("<div class='mt-2 small'>")
        html.Append("<div><strong>Order ID:</strong> #" & orderIdStr & "</div>")
        html.Append("<div><strong>Ref No:</strong> " & transactionNo & "</div>")
        html.Append("</div>")
        html.Append("</div>")

        html.Append("</div>")
        html.Append("</div>")

        html.Append("<div class='invoice-body'>")
        html.Append("<div class='row g-4'>")

        html.Append("<div class='col-md-6'>")
        html.Append("<div class='info-card'>")
        html.Append("<div class='section-title'><i class='fas fa-user' style='color:#4F7E76;'></i> Customer & Delivery Details</div>")
        html.Append("<p><strong>Name:</strong> " & customer("C_Name") & "</p>")
        html.Append("<p><strong>Phone:</strong> " & customer("Phone") & "</p>")
        html.Append("<p><strong>Address:</strong> " & customer("address") & "</p>")
        html.Append("<p><strong>Pincode:</strong> " & customer("pincode") & "</p>")
        html.Append("</div>")
        html.Append("</div>")

        html.Append("<div class='col-md-6'>")
        html.Append("<div class='info-card'>")
        html.Append("<div class='section-title'><i class='fas fa-receipt' style='color:#4F7E76;'></i> Invoice & Payment Info</div>")
        html.Append("<p><strong>Order Date (IST):</strong> " & orderDateStr & "</p>")
        html.Append("<p><strong>Payment Method:</strong> " & paymentTypeStr & "</p>")
        html.Append("<p><strong>Order Status:</strong> <span style='color:#16a34a; font-weight:700;'>✅ " & orderStatusStr & "</span></p>")
        html.Append("</div>")
        html.Append("</div>")

        html.Append("</div>")

        html.Append("<table class='table table-bordered align-middle'>")
        html.Append("<thead>")
        html.Append("<tr>")
        html.Append("<th>Dish Item</th>")
        html.Append("<th width='110' class='text-center'>Qty</th>")
        html.Append("<th width='130' class='text-end'>Price</th>")
        html.Append("<th width='140' class='text-end'>Total</th>")
        html.Append("</tr>")
        html.Append("</thead>")

        html.Append("<tbody>")

        For Each row As DataRow In dt.Rows
            Dim totalPrice As Decimal = Convert.ToDecimal(row("total_price"))
            grandTotal += totalPrice

            html.Append("<tr>")
            html.Append("<td><strong>" & row("m_name") & "</strong></td>")
            html.Append("<td class='text-center'>" & row("quantity") & "</td>")
            html.Append("<td class='text-end'>₹" & Convert.ToDecimal(row("price")).ToString("N2") & "</td>")
            html.Append("<td class='text-end'><strong>₹" & totalPrice.ToString("N2") & "</strong></td>")
            html.Append("</tr>")
        Next

        html.Append("</tbody>")
        html.Append("</table>")

        html.Append("<div class='grand-total text-end'>")
        html.Append("<div class='text-muted mb-1' style='font-size:13px; font-weight:600;'>Grand Total (Incl. GST & Free Delivery)</div>")
        html.Append("<h3>₹" & grandTotal.ToString("N2") & "</h3>")
        html.Append("</div>")

        html.Append("<div class='print-area text-center mt-4'>")
        html.Append("<button class='print-btn' onclick='printInvoice()'>")
        html.Append("<i class='fas fa-print'></i> Print / Save PDF Invoice")
        html.Append("</button>")
        html.Append("</div>")

        html.Append("<div class='footer-note'>")
        html.Append("Thank you for dining with Cloud Kitchen! ❤️ Fresh Meals Delivered Fast.")
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
                                  "WHERE o.order_id = @OrderId AND o.c_id = @CustomerId"

            Dim cmd As New SqlCommand(query, conn)
            cmd.Parameters.AddWithValue("@OrderId", orderId)
            cmd.Parameters.AddWithValue("@CustomerId", If(Session("c_id") IsNot Nothing, Session("c_id"), 0))

            Dim adapter As New SqlDataAdapter(cmd)
            adapter.Fill(dt)
        End Using

        If dt.Rows.Count > 0 Then
            Return dt.Rows(0)
        End If

        Return Nothing
    End Function

End Class
