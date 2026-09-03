Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Public Class OrderConfirmation
    Inherits System.Web.UI.Page

    Dim connString As String = ConfigurationManager.ConnectionStrings("constr").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            If Session("c_id") Is Nothing Then
                Response.Redirect("Login.aspx")
                Exit Sub
            End If
            If Request.QueryString("OrderId") IsNot Nothing Then
                Dim orderId As Integer = Convert.ToInt32(Request.QueryString("OrderId"))
                LoadOrderDetails(orderId)
            Else
                Response.Redirect("Home.aspx")
            End If
        End If
    End Sub

    Private Sub LoadOrderDetails(ByVal orderId As Integer)
        If Session("c_id") Is Nothing Then
            Response.Redirect("Login.aspx")
            Exit Sub
        End If

        Dim customerId As Integer = Convert.ToInt32(Session("c_id"))

        Using con As New SqlConnection(connString)
            Dim cmd As New SqlCommand("SELECT order_id, order_status, transaction_number, total_amount, order_date, address, pincode, payment_type FROM orders WHERE order_id = @order_id AND c_id = @c_id", con)
            cmd.Parameters.AddWithValue("@order_id", orderId)
            cmd.Parameters.AddWithValue("@c_id", customerId)

            con.Open()
            Dim reader As SqlDataReader = cmd.ExecuteReader()
            If reader.Read() Then
                lblOrderId.Text = orderId.ToString()
                lblTransactionNumber.Text = If(IsDBNull(reader("transaction_number")), "N/A", reader("transaction_number").ToString())
                lblTotalAmount.Text = Convert.ToDecimal(reader("total_amount")).ToString("N2")

                If Not IsDBNull(reader("order_date")) Then
                    lblOrderDate.Text = Convert.ToDateTime(reader("order_date")).ToString("dd-MMM-yyyy hh:mm tt")
                Else
                    lblOrderDate.Text = "N/A"
                End If

                lblAddress.Text = reader("address").ToString() & ", " & reader("pincode").ToString()
                lblPaymentType.Text = reader("payment_type").ToString()

                Dim orderStatus As String = reader("order_status").ToString().Trim()

                If orderStatus.Equals("Pending", StringComparison.OrdinalIgnoreCase) Then
                    lblOrderStatus.Text = "⏳ Pending"
                    lblOrderStatus.CssClass = "status-badge status-pending"
                    pnlPendingMessage.Visible = True
                ElseIf orderStatus.Equals("Completed", StringComparison.OrdinalIgnoreCase) OrElse orderStatus.Equals("Delivered", StringComparison.OrdinalIgnoreCase) Then
                    lblOrderStatus.Text = "✅ " & orderStatus
                    lblOrderStatus.CssClass = "status-badge status-success"
                    pnlPendingMessage.Visible = False
                Else
                    lblOrderStatus.Text = "👨‍🍳 " & orderStatus
                    lblOrderStatus.CssClass = "status-badge status-pending"
                    pnlPendingMessage.Visible = False
                End If
            Else
                Response.Redirect("MyOrders.aspx")
                Exit Sub
            End If
            reader.Close()

            ' Fetch line items for receipt table
            Dim queryItems As String = "SELECT M.M_Name AS item_name, OI.quantity, OI.price, OI.total_price FROM Order_Details OI INNER JOIN Menu_Item M ON OI.m_id = M.M_Id WHERE OI.order_id = @order_id"
            Using cmdItems As New SqlCommand(queryItems, con)
                cmdItems.Parameters.AddWithValue("@order_id", orderId)
                Dim dtItems As New DataTable()
                Dim adapter As New SqlDataAdapter(cmdItems)
                adapter.Fill(dtItems)

                rptReceiptItems.DataSource = dtItems
                rptReceiptItems.DataBind()
            End Using

        End Using
    End Sub
End Class
