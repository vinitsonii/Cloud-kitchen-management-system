Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Net
Imports System.Net.Mail
Public Class Cart
    Inherits System.Web.UI.Page
    Dim connString As String = ConfigurationManager.ConnectionStrings("constr").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Session("c_id") Is Nothing Then
            Response.Redirect("Login.aspx")
        End If

        If Not IsPostBack Then
            LoadCartItems()
            Bindpincode()
        End If

        If Request("__EVENTTARGET") = "PaymentSuccess" Then
            Dim paymentId As String = Request("__EVENTARGUMENT").ToString()
            If String.IsNullOrEmpty(paymentId) AndAlso Request("payment_id") IsNot Nothing Then
                paymentId = Request("payment_id").ToString()
            End If
            If Not String.IsNullOrEmpty(paymentId) Then
                hdnPaymentId.Value = paymentId
            End If
            SaveOrderAfterPayment()
        End If
    End Sub

    Private Sub SaveOrderAfterPayment()
        Dim paymentId As String = hdnPaymentId.Value
        If String.IsNullOrEmpty(paymentId) Then Exit Sub

        Dim transactionNumber As String = paymentId
        Session("TransactionNumber") = transactionNumber

        lblTransaction.Text = "Payment ID: " & paymentId
        lblTransaction.ForeColor = Drawing.Color.Green
        lblTransaction.Visible = True

        up.Visible = False
        Panel2.Visible = True

        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "showPanel", "showPanel();", True)

        dvLoader.Visible = True
        dvSuccess.Visible = False
        Timer1.Enabled = True

        Checkout_Click(Nothing, Nothing)
    End Sub
    Public Function GetValue(ByVal item As Object, ByVal key As String) As String
        Dim dict As Dictionary(Of String, Object) = CType(item, Dictionary(Of String, Object))
        If dict.ContainsKey(key) Then
            Return dict(key).ToString()
        End If
        Return ""
    End Function
    Private Sub LoadCartItems()
        If Session("Cart") IsNot Nothing Then
            Dim cart As List(Of Dictionary(Of String, Object)) = CType(Session("Cart"), List(Of Dictionary(Of String, Object)))
            If cart.Count > 0 Then
                pnlfill.Visible = True
                pnlempty.Visible = False

                rptCartItems.DataSource = cart
                rptCartItems.DataBind()

                Dim total As Decimal = cart.Sum(Function(x) Convert.ToDecimal(x("total_price")))
                lblTotalPrice.Text = total.ToString("F2")
                lblGrandTotal.Text = total.ToString("F2")
            Else
                pnlfill.Visible = False
                pnlempty.Visible = True
            End If
        Else
            pnlfill.Visible = False
            pnlempty.Visible = True
        End If
    End Sub
    Public Function GetImageUrl(ByVal item As Object) As String
        Dim dict As Dictionary(Of String, Object) = CType(item, Dictionary(Of String, Object))
        If dict.ContainsKey("m_image_url") AndAlso Not String.IsNullOrEmpty(dict("m_image_url").ToString()) Then
            Return dict("m_image_url").ToString()
        Else
            Return "../Images/default.jpg"
        End If
    End Function
    Protected Sub UpdateCartItem(ByVal sender As Object, ByVal e As CommandEventArgs)
        If Session("Cart") IsNot Nothing Then
            Dim cart As List(Of Dictionary(Of String, Object)) = CType(Session("Cart"), List(Of Dictionary(Of String, Object)))


            Dim item = cart.FirstOrDefault(Function(x) x("m_id").ToString() = e.CommandArgument.ToString())

            If item IsNot Nothing Then
                Dim itemContainer As RepeaterItem = CType(CType(sender, Control).NamingContainer, RepeaterItem)
                Dim txtQuantity As TextBox = CType(itemContainer.FindControl("txtQuantity"), TextBox)

                Dim newQuantity As Integer
                If Integer.TryParse(txtQuantity.Text, newQuantity) AndAlso newQuantity > 0 Then
                    item("quantity") = newQuantity
                    item("total_price") = newQuantity * Convert.ToDecimal(item("m_final_price"))
                End If
            End If

            Session("Cart") = cart
            LoadCartItems()

        End If
    End Sub
    Protected Sub IncreaseQuantity(ByVal sender As Object, ByVal e As CommandEventArgs)
        If Session("Cart") IsNot Nothing Then
            Dim cart As List(Of Dictionary(Of String, Object)) = CType(Session("Cart"), List(Of Dictionary(Of String, Object)))
            Dim item = cart.FirstOrDefault(Function(x) x("m_id").ToString() = e.CommandArgument.ToString())
            If item IsNot Nothing Then
                Dim currentQty As Integer = Convert.ToInt32(item("quantity"))
                Dim newQty As Integer = currentQty + 1
                item("quantity") = newQty
                item("total_price") = newQty * Convert.ToDecimal(item("m_final_price"))
            End If
            Session("Cart") = cart
            LoadCartItems()
        End If
    End Sub

    Protected Sub DecreaseQuantity(ByVal sender As Object, ByVal e As CommandEventArgs)
        If Session("Cart") IsNot Nothing Then
            Dim cart As List(Of Dictionary(Of String, Object)) = CType(Session("Cart"), List(Of Dictionary(Of String, Object)))
            Dim item = cart.FirstOrDefault(Function(x) x("m_id").ToString() = e.CommandArgument.ToString())
            If item IsNot Nothing Then
                Dim currentQty As Integer = Convert.ToInt32(item("quantity"))
                If currentQty <= 1 Then
                    cart.Remove(item)
                Else
                    Dim newQty As Integer = currentQty - 1
                    item("quantity") = newQty
                    item("total_price") = newQty * Convert.ToDecimal(item("m_final_price"))
                End If
            End If
            Session("Cart") = cart
            LoadCartItems()
        End If
    End Sub

    Protected Sub RemoveCartItem(ByVal sender As Object, ByVal e As CommandEventArgs)
        If Session("Cart") IsNot Nothing Then
            Dim cart As List(Of Dictionary(Of String, Object)) = CType(Session("Cart"), List(Of Dictionary(Of String, Object)))
            cart.RemoveAll(Function(x) x("m_id").ToString() = e.CommandArgument.ToString())
            Session("Cart") = cart
            LoadCartItems()
        End If
    End Sub
    Protected Sub Checkout_Click(ByVal sender As Object, ByVal e As EventArgs)
        If Session("Cart") Is Nothing OrElse Session("c_id") Is Nothing Then
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "emptyCart", "alert('Please add items to your cart!');", True)
            Exit Sub
        End If

        Dim cart As List(Of Dictionary(Of String, Object)) = CType(Session("Cart"), List(Of Dictionary(Of String, Object)))
        If cart.Count = 0 Then
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "emptyCart", "alert('Your cart is empty!');", True)
            Exit Sub
        End If

        Dim selectedPincode As String = ddlpincode.SelectedValue.Trim()
        If String.IsNullOrEmpty(selectedPincode) Then
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "pinErr", "alert('Please select a valid delivery pincode!');", True)
            Exit Sub
        End If

        If String.IsNullOrEmpty(txtAddress.Text.Trim()) Then
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "addrErr", "alert('Please enter a complete delivery address!');", True)
            Exit Sub
        End If

        Dim paymentType As String = ddlPaymentType.SelectedValue.Trim()
        If String.IsNullOrEmpty(paymentType) Then
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "payErr", "alert('Please select a payment method!');", True)
            Exit Sub
        End If

        ' IF RAZORPAY SELECTED AND PAYMENT NOT DONE YET -> LAUNCH RAZORPAY POPUP
        If paymentType = "Razorpay" AndAlso String.IsNullOrEmpty(hdnPaymentId.Value) Then
            Dim totalAmount As Decimal = cart.Sum(Function(x) Convert.ToDecimal(x("total_price")))
            TriggerRazorpayPayment(totalAmount)
            Exit Sub
        End If

        ' SAVE ORDER TO DATABASE (COD OR RAZORPAY PAID)
        Using con As New SqlConnection(connString)
            con.Open()
            Dim transaction As SqlTransaction = con.BeginTransaction()

            Try
                Dim cmdPincodeCheck As New SqlCommand("SELECT COUNT(*) FROM Area_Pincode WHERE Pincode = @pincode", con, transaction)
                cmdPincodeCheck.Parameters.AddWithValue("@pincode", selectedPincode)
                Dim pincodeCount As Integer = Convert.ToInt32(cmdPincodeCheck.ExecuteScalar())
                If pincodeCount = 0 Then
                    transaction.Rollback()
                    ScriptManager.RegisterStartupScript(Me, Me.GetType(), "areaErr", "alert('Delivery is not available in pincode area (" & selectedPincode.Replace("'", "\'") & ")!');", True)
                    Exit Sub
                End If

                Dim transactionNumber As String = If(Not String.IsNullOrEmpty(hdnPaymentId.Value), hdnPaymentId.Value, GenerateTransactionNumber())

                Dim cmdOrder As New SqlCommand("INSERT INTO orders (c_id, total_amount, order_status, order_date, address, pincode, payment_type, transaction_number) VALUES (@c_id, @total_amount, 'Pending', GETDATE(), @address, @pincode, @payment_type, @transaction_number); SELECT SCOPE_IDENTITY();", con, transaction)

                cmdOrder.Parameters.AddWithValue("@transaction_number", transactionNumber)
                cmdOrder.Parameters.AddWithValue("@c_id", Session("c_id"))
                cmdOrder.Parameters.AddWithValue("@total_amount", cart.Sum(Function(x) Convert.ToDecimal(x("total_price"))))
                cmdOrder.Parameters.AddWithValue("@address", txtAddress.Text.Trim())
                cmdOrder.Parameters.AddWithValue("@pincode", selectedPincode)
                cmdOrder.Parameters.AddWithValue("@payment_type", paymentType)

                Dim orderId As Integer = Convert.ToInt32(cmdOrder.ExecuteScalar())

                For Each item In cart
                    Dim cmdDetails As New SqlCommand("INSERT INTO order_details (order_id, m_id, quantity, price, total_price) VALUES (@order_id, @m_id, @quantity, @price, @total_price)", con, transaction)
                    cmdDetails.Parameters.AddWithValue("@order_id", orderId)
                    cmdDetails.Parameters.AddWithValue("@m_id", item("m_id"))
                    cmdDetails.Parameters.AddWithValue("@quantity", item("quantity"))
                    cmdDetails.Parameters.AddWithValue("@price", item("m_final_price"))
                    cmdDetails.Parameters.AddWithValue("@total_price", item("total_price"))
                    cmdDetails.ExecuteNonQuery()
                Next

                transaction.Commit()
                Session.Remove("Cart")

                Dim userEmail As String = ""
                If Session("UserEmail") IsNot Nothing Then
                    userEmail = Session("UserEmail").ToString()
                ElseIf Session("c_id") IsNot Nothing Then
                    Using cmdEmail As New SqlCommand("SELECT email FROM Customers WHERE c_id = @cid", con, transaction)
                        cmdEmail.Parameters.AddWithValue("@cid", Session("c_id"))
                        Dim resultObj As Object = cmdEmail.ExecuteScalar()
                        If resultObj IsNot Nothing AndAlso Not IsDBNull(resultObj) Then
                            userEmail = resultObj.ToString()
                            Session("UserEmail") = userEmail
                        End If
                    End Using
                End If

                If Not String.IsNullOrEmpty(userEmail) Then
                    SendOrderEmail(userEmail, orderId, transactionNumber, cart)
                End If

                Dim redirectScript As String = "window.location.href='OrderConfirmation.aspx?OrderId=" & orderId & "';"
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "orderDone", redirectScript, True)

            Catch ex As Exception
                transaction.Rollback()
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "orderFail", "alert('Order Error: " & ex.Message.Replace("'", "\'").Replace(vbCrLf, " ") & "');", True)
            End Try
        End Using
    End Sub

    Function SendOrderEmail(ByVal userEmail As String, ByVal orderId As Integer, ByVal transactionNumber As String, ByVal cart As List(Of Dictionary(Of String, Object))) As Boolean
        Try
            Dim senderEmail As String = ConfigurationManager.AppSettings("EmailUsername")

            Dim mail As New MailMessage()
            mail.From = New MailAddress(senderEmail, "Cloud Kitchen")
            mail.To.Add(userEmail)
            mail.Subject = "🍽 Your Cloud Kitchen Order is Confirmed! # " & orderId
            mail.IsBodyHtml = True

            Dim cartTable As String = "<table class='order-table'>" & _
"<tr><th>Item</th><th>Price</th><th>Qty</th><th>Total</th></tr>"

            For Each item In cart
                cartTable &= "<tr>" & _
                    "<td>" & item("m_name").ToString() & "</td>" & _
                    "<td>₹" & Convert.ToDecimal(item("m_final_price")).ToString("F2") & "</td>" & _
                    "<td>" & item("quantity").ToString() & "</td>" & _
                    "<td>₹" & Convert.ToDecimal(item("total_price")).ToString("F2") & "</td>" & _
                    "</tr>"
            Next

            cartTable &= "</table>"

            Dim baseUrl As String = ""
            If HttpContext.Current IsNot Nothing AndAlso HttpContext.Current.Request IsNot Nothing Then
                baseUrl = HttpContext.Current.Request.Url.Scheme & "://" & HttpContext.Current.Request.Url.Authority
            Else
                baseUrl = ConfigurationManager.AppSettings("WebsiteUrl")
                If String.IsNullOrEmpty(baseUrl) Then baseUrl = "http://localhost"
            End If
            Dim myOrdersUrl As String = baseUrl & "/Customers/MyOrders.aspx"

            Dim emailBody As String = "<!DOCTYPE html>" & vbCrLf & _
"<html>" & vbCrLf & _
"<head>" & vbCrLf & _
"<meta charset='UTF-8'>" & vbCrLf & _
"<style>" & vbCrLf & _
"body{ margin:0; padding:0; background:#f4f6f9; font-family:Arial,sans-serif; }" & vbCrLf & _
".wrapper{ width:100%; padding:30px 0; }" & vbCrLf & _
".container{ max-width:650px; background:#ffffff; margin:auto; border-radius:16px; overflow:hidden; box-shadow:0 8px 30px rgba(0,0,0,0.08); }" & vbCrLf & _
".header{ background:linear-gradient(135deg,#4F7E76,#3a5f59); padding:35px; text-align:center; color:#fff; }" & vbCrLf & _
".header h1{ margin:0; font-size:32px; }" & vbCrLf & _
".header p{ margin-top:8px; opacity:0.9; font-size:15px; }" & vbCrLf & _
".content{ padding:35px; }" & vbCrLf & _
".success-box{ background:#f0fff4; border-left:5px solid #28a745; padding:18px; border-radius:10px; margin-bottom:25px; }" & vbCrLf & _
".success-box h2{ margin:0; color:#28a745; }" & vbCrLf & _
".details{ background:#fafafa; padding:20px; border-radius:12px; margin-top:20px; }" & vbCrLf & _
".details p{ margin:10px 0; color:#444; font-size:15px; }" & vbCrLf & _
".table-title{ margin-top:30px; color:#333; font-size:22px; }" & vbCrLf & _
".order-table{ width:100%; border-collapse:collapse; margin-top:15px; }" & vbCrLf & _
".order-table th{ background:#4F7E76; color:white; padding:14px; text-align:left; font-size:14px; }" & _
".order-table td{ padding:14px; border-bottom:1px solid #eee; font-size:14px; }" & vbCrLf & _
".total-box{ text-align:right; margin-top:20px; font-size:22px; color:#4F7E76; font-weight:bold; }" & vbCrLf & _
".button{ display:inline-block; background:#ff9f43; color:#fff !important; text-decoration:none; padding:14px 28px; border-radius:50px; margin-top:30px; font-weight:bold; font-size:15px; }" & vbCrLf & _
".footer{ background:#f8f8f8; padding:25px; text-align:center; color:#777; font-size:13px; }" & vbCrLf & _
".footer a{ color:#4F7E76; text-decoration:none; }" & vbCrLf & _
"</style></head><body>" & vbCrLf & _
"<div class='wrapper'><div class='container'>" & vbCrLf & _
"<div class='header'><h1>🍽 Cloud Kitchen</h1><p>Fresh Meals Delivered To Your Doorstep</p></div>" & vbCrLf & _
"<div class='content'>" & vbCrLf & _
"<div class='success-box'><h2>✅ Order Confirmed Successfully</h2><p>Thank you for ordering with Cloud Kitchen.</p></div>" & vbCrLf & _
"<p>Hello Customer,</p><p>We are preparing your delicious food and your order will arrive shortly. Thank you for choosing Cloud Kitchen.</p>" & vbCrLf & _
"<div class='details'>" & vbCrLf & _
"<p><strong>🧾 Order ID:</strong> #" & orderId & "</p>" & vbCrLf & _
"<p><strong>💳 Transaction ID:</strong> " & transactionNumber & "</p>" & vbCrLf & _
"<p><strong>🚚 Delivery Address:</strong> " & txtAddress.Text & "</p>" & vbCrLf & _
"<p><strong>📍 Pincode:</strong> " & ddlpincode.SelectedValue & "</p>" & vbCrLf & _
"<p><strong>💰 Payment Method:</strong> " & ddlPaymentType.SelectedValue & "</p>" & vbCrLf & _
"<p><strong>⏰ Estimated Delivery:</strong> 30 - 40 Minutes</p>" & vbCrLf & _
"</div>" & vbCrLf & _
"<h3 class='table-title'>🛒 Order Summary</h3>" & cartTable & vbCrLf & _
"<div class='total-box'>Total Amount: ₹" & lblTotalPrice.Text & "<br/><span style='font-size:12px; color:#64748b; font-weight:normal;'>(Incl. of all taxes & GST)</span></div>" & vbCrLf & _
"<center><a href='" & myOrdersUrl & "' class='button'>View My Orders</a></center>" & vbCrLf & _
"</div>" & vbCrLf & _
"<div class='footer'><p>Need help? Contact us anytime</p><p>📧 info.cloudkitchenn@gmail.com</p><p>© Cloud Kitchen - All Rights Reserved</p></div>" & vbCrLf & _
"</div></div></body></html>"

            mail.Body = emailBody

            Dim smtp As New SmtpClient(ConfigurationManager.AppSettings("SMTPServer"), Convert.ToInt32(ConfigurationManager.AppSettings("SMTPPort")))
            smtp.Credentials = New System.Net.NetworkCredential(senderEmail, ConfigurationManager.AppSettings("EmailPassword"))
            smtp.EnableSsl = True

            smtp.Send(mail)
            Return True

        Catch ex As Exception
            HttpContext.Current.Response.Write("<script>alert('Email Error: " & ex.Message.Replace("'", "\'") & "');</script>")
            Return False
        End Try
    End Function

    Private Function GenerateTransactionNumber() As String
        Dim random As New Random()
        Dim timestamp As String = DateTime.Now.ToString("yyyyMMddHHmmss")
        Dim randomDigits As String = random.Next(1000, 9999).ToString()
        Return "TXN" & timestamp & randomDigits
    End Function

    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancel.Click
        up.Visible = False
        ddlPaymentType.SelectedIndex = 1
    End Sub

    Protected Sub rptCartItems_ItemCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.RepeaterCommandEventArgs) Handles rptCartItems.ItemCommand

    End Sub

    Protected Sub btnPayNow_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim expMonth As Integer = 0
        Dim expYear As Integer = 0
        Integer.TryParse(txtExpiryMonth.Text, expMonth)
        Integer.TryParse(txtExpiryYear.Text, expYear)
        Dim currentYearYY As Integer = Convert.ToInt32(DateTime.Now.ToString("yy"))

        If txtCard1.Text.Length = 4 AndAlso txtCard2.Text.Length = 4 AndAlso txtCard3.Text.Length = 4 AndAlso txtCard4.Text.Length = 4 AndAlso
           expMonth >= 1 AndAlso expMonth <= 12 AndAlso expYear >= currentYearYY AndAlso txtCCV.Text.Length = 3 AndAlso
           Not String.IsNullOrEmpty(txtCardName.Text.Trim()) Then

            label1.Text = "Card details verified successfully. Proceed To Payment."
            label1.ForeColor = System.Drawing.Color.Green
            label1.Visible = True

            Button3.Enabled = True
            Panel1.Visible = False
            Panel3.Visible = True
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "showPanel", "showPanel();", True)
            ddlPaymentType.Enabled = False
        Else
            label1.Text = "Invalid card details. Please check card number, expiry date (MM/YY), and CVV."
            label1.ForeColor = System.Drawing.Color.Red
            label1.Visible = True
        End If
    End Sub

    'Protected Sub ddlPaymentType_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs) Handles ddlPaymentType.SelectedIndexChanged

    '    If ddlPaymentType.SelectedIndex = 2 Then
    '        up.Visible = True
    '        Panel1.Visible = True
    '        lbltotamt.Text = lblTotalPrice.Text
    '        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "showPanel", "showPanel();", True)
    '    Else
    '        Panel1.Visible = False
    '    End If

    'End Sub

    'Protected Sub ddlPaymentType_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs) Handles ddlPaymentType.SelectedIndexChanged

    '    If ddlPaymentType.SelectedIndex = 2 Then

    '        Dim amount As Decimal = Convert.ToDecimal(lblTotalPrice.Text)

    '        ' Razorpay accepts amount in paise
    '        Dim amountInPaise As Integer = amount * 100

    '        Dim script As String = "
    '    var options = {
    '        'key': 'rzp_test_Sq7x7OL1DUIl17',
    '        'amount': '" & amountInPaise & "',
    '        'currency': 'INR',
    '        'name': 'Cloud Kitchen',
    '        'description': 'Food Order Payment',
    '        'image': '../Images/logo.png',

    '        'handler': function (response){

    '            alert('Payment Successful');

    '            __doPostBack('PaymentSuccess','' + response.razorpay_payment_id);

    '        },

    '        'prefill': {
    '            'name': 'Cloud Kitchen Customer',
    '            'email': 'customer@test.com',
    '            'contact': '9999999999'
    '        },

    '        'theme': {
    '            'color': '#4F7E76'
    '        },

    '        'modal': {
    '            'ondismiss': function () {
    '                alert('Payment Cancelled');
    '            }
    '        }
    '    };

    '    var rzp1 = new Razorpay(options);
    '    rzp1.open();
    '    "

    '        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "razorpay", script, True)

    '    Else
    '        Panel1.Visible = False
    '    End If

    'End Sub


    Private Sub TriggerRazorpayPayment(ByVal totalAmount As Decimal)
        Dim amountInPaise As Integer = Convert.ToInt32(totalAmount * 100)
        Dim customerName As String = "Customer"
        Dim customerEmail As String = ""

        If Session("c_name") IsNot Nothing Then customerName = Session("c_name").ToString()
        If Session("UserEmail") IsNot Nothing Then customerEmail = Session("UserEmail").ToString()

        Dim script As String = "var options = {" & _
            "'key': 'rzp_test_Sq7x7OL1DUIl17'," & _
            "'amount': '" & amountInPaise.ToString() & "'," & _
            "'currency': 'INR'," & _
            "'name': 'Cloud Kitchen'," & _
            "'description': 'Food Order Payment'," & _
            "'image': '../icons/money.png'," & _
            "'handler': function (response) {" & _
            "__doPostBack('PaymentSuccess', response.razorpay_payment_id);" & _
            "}," & _
            "'prefill': {'name': '" & customerName.Replace("'", "\'") & "', 'email': '" & customerEmail.Replace("'", "\'") & "'}," & _
            "'theme': {'color': '#4F7E76'}," & _
            "'modal': {'ondismiss': function () { alert('Payment Cancelled'); }}" & _
            "};" & _
            "var rzp1 = new Razorpay(options); rzp1.open();"

        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "razorpay", script, True)
    End Sub

    Protected Sub ddlPaymentType_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs) Handles ddlPaymentType.SelectedIndexChanged
        ' Left clean to avoid premature popups before user fills delivery address
    End Sub

    Private Sub Button1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Button1.Click
        Panel2.Visible = False
        Panel3.Visible = False
        ddlpincode.SelectedIndex = 0
        Response.Redirect("cart.aspx")
        Label2.Text = ""
        lblTransaction.Text = ""
    End Sub

    Private Sub Bindpincode()
        Using conn As New SqlConnection(connString)
            Dim cmd As New SqlCommand("SELECT * FROM Area_Pincode", conn)
            conn.Open()
            Dim rdr As SqlDataReader = cmd.ExecuteReader()
            ddlpincode.DataSource = rdr
            ddlpincode.DataTextField = "Pincode"
            ddlpincode.DataValueField = "Pincode"
            ddlpincode.DataBind()
        End Using
        ddlpincode.Items.Insert(0, New ListItem("📍 --Select Pincode --", ""))
    End Sub
    'Protected Sub Button3_Click(ByVal sender As Object, ByVal e As EventArgs) Handles Button3.Click

    '    Dim transactionNumber As String = GenerateTransactionNumber()
    '    Session("TransactionNumber") = transactionNumber
    '    lblTransaction.Text = "Transaction Number: " & transactionNumber
    '    lblTransaction.ForeColor = System.Drawing.Color.Green
    '    lblTransaction.Visible = True


    '    'Label2.Text = "<h3> Card Details Verified Successfully !!!  </h3>"

    '    Label2.ForeColor = System.Drawing.Color.Green
    '    'Label2.Visible = True
    '    up.Visible = False
    '    Panel2.Visible = True
    '    'ScriptManager.RegisterStartupScript(Me, Me.GetType(), "showPanel", "showPanel();", True)

    '    'Panel2.Visible = True
    '    dvLoader.Visible = True
    '    dvSuccess.Visible = False

    '    ' Simulate Payment Processing Delay
    '    System.Threading.Thread.Sleep(3000)

    '    ' After delay, hide loader and show success message
    '    dvLoader.Visible = False
    '    dvSuccess.Visible = True

    'End Sub
    Protected Sub Timer1_Tick(ByVal sender As Object, ByVal e As EventArgs) Handles Timer1.Tick
        Timer1.Enabled = False

        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "showPanel", "showPanel();", True)
        dvLoader.Visible = False
        dvSuccess.Visible = True
    End Sub
    Protected Sub Button3_Click(ByVal sender As Object, ByVal e As EventArgs) Handles Button3.Click
        Dim transactionNumber As String = GenerateTransactionNumber()
        Session("TransactionNumber") = transactionNumber
        lblTransaction.Text = "Transaction Number: " & transactionNumber
        lblTransaction.ForeColor = System.Drawing.Color.Green
        lblTransaction.Visible = True
        up.Visible = False
        Panel2.Visible = True
        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "showPanel", "showPanel();", True)
        dvLoader.Visible = True
        dvSuccess.Visible = False
        Timer1.Enabled = True
    End Sub

End Class