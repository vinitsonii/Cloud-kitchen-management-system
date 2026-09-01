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
            Dim cmd As New SqlCommand("SELECT order_status, transaction_number, total_amount FROM orders WHERE order_id = @order_id AND c_id = @c_id", con)
            cmd.Parameters.AddWithValue("@order_id", orderId)
            cmd.Parameters.AddWithValue("@c_id", customerId)

            con.Open()
            Dim reader As SqlDataReader = cmd.ExecuteReader()
            If reader.Read() Then
                lblOrderId.Text = orderId.ToString()
                lblTransactionNumber.Text = reader("transaction_number").ToString()
                lblTotalAmount.Text = Convert.ToDecimal(reader("total_amount")).ToString("F2")

                Dim orderStatus As String = reader("order_status").ToString()
                lblOrderStatus.Text = orderStatus

                ' Show message and button only if status is Pending
                If orderStatus = "Pending" Then
                    lblOrderStatus.CssClass = "status-pending"
                    pnlPendingMessage.Visible = True
                Else
                    lblOrderStatus.CssClass = "status-success"
                End If
            Else
                Response.Redirect("MyOrders.aspx")
            End If
            reader.Close()
        End Using
    End Sub
End Class
