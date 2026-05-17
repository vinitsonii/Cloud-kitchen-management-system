Imports System.Data.SqlClient
Imports System.Configuration
Imports System.Net
Imports System.Net.Mail
Public Class Cart
    Inherits System.Web.UI.Page
    Dim connString As String = ConfigurationManager.ConnectionStrings("constr").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            LoadCartItems()
            Bindpincode()
            If Session("c_id") Is Nothing Then
                Response.Redirect("Login.aspx")
            End If
            If Request("__EVENTTARGET") = "PaymentSuccess" Then

                Dim paymentId As String = Request("__EVENTARGUMENT").ToString()

                Session("TransactionNumber") = paymentId

                lblTransaction.Text = "Payment ID : " & paymentId
                lblTransaction.ForeColor = Drawing.Color.Green
                lblTransaction.Visible = True

                Panel2.Visible = True

                dvLoader.Visible = False
                dvSuccess.Visible = True

                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "showPanel", "showPanel();", True)

            End If
        End If
    End Sub
    Private Sub SaveOrderAfterPayment()

        Dim paymentId As String = hdnPaymentId.Value

        If paymentId = "" Then

            Exit Sub

        End If

        Dim transactionNumber As String = paymentId

        Session("TransactionNumber") = transactionNumber

        lblTransaction.Text = "Payment ID: " & paymentId

        lblTransaction.ForeColor = Drawing.Color.Green

        lblTransaction.Visible = True

        up.Visible = False

        Panel2.Visible = True

        ScriptManager.RegisterStartupScript(Me,
                                        Me.GetType(),
                                        "showPanel",
                                        "showPanel();",
                                        True)

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
            pnlfill.Visible = True

            pnlempty.Visible = False
            Dim cart As List(Of Dictionary(Of String, Object)) = CType(Session("Cart"), List(Of Dictionary(Of String, Object)))

            rptCartItems.DataSource = cart
            rptCartItems.DataBind()

            Dim total As Decimal = cart.Sum(Function(x) Convert.ToDecimal(x("total_price")))
            lblTotalPrice.Text = total.ToString("F2")
        Else
            'Response.Write("<script>alert('Your Cart Is Empty. Please Order Something..!!');  window.location.href='Menu.aspx'; ;</script>")
            'Response.Redirect("Menu.aspx")
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
    Protected Sub RemoveCartItem(ByVal sender As Object, ByVal e As CommandEventArgs)

        If Session("Cart") IsNot Nothing Then
            Dim cart As List(Of Dictionary(Of String, Object)) = CType(Session("Cart"), List(Of Dictionary(Of String, Object)))

            cart.RemoveAll(Function(x) x("m_id").ToString() = e.CommandArgument.ToString())

            Session("Cart") = cart
            LoadCartItems()

        End If

    End Sub
    Protected Sub Checkout_Click(ByVal sender As Object, ByVal e As EventArgs)

        If Session("Cart") IsNot Nothing AndAlso Session("c_id") IsNot Nothing Then
            Dim cart As List(Of Dictionary(Of String, Object)) = CType(Session("Cart"), List(Of Dictionary(Of String, Object)))

            If cart.Count > 0 Then
                Using con As New SqlConnection(connString)
                    con.Open()
                    Dim transaction As SqlTransaction = con.BeginTransaction()

                    Try
                        Dim transactionNumber As String = If(Session("TransactionNumber") IsNot Nothing, Session("TransactionNumber").ToString(), GenerateTransactionNumber())

                        Dim cmdOrder As New SqlCommand("INSERT INTO orders (c_id, total_amount, order_status, order_date, address, pincode, payment_type, transaction_number) VALUES (@c_id, @total_amount, 'Pending', GETDATE(), @address, @pincode, @payment_type, @transaction_number); SELECT SCOPE_IDENTITY();", con, transaction)

                        cmdOrder.Parameters.AddWithValue("@transaction_number", transactionNumber)
                        cmdOrder.Parameters.AddWithValue("@c_id", Session("c_id"))
                        cmdOrder.Parameters.AddWithValue("@total_amount", cart.Sum(Function(x) Convert.ToDecimal(x("total_price"))))
                        cmdOrder.Parameters.AddWithValue("@address", txtAddress.Text)
                        cmdOrder.Parameters.AddWithValue("@pincode", ddlpincode.SelectedValue)
                        cmdOrder.Parameters.AddWithValue("@payment_type", ddlPaymentType.SelectedValue)

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

                        Dim userEmail As String = Session("UserEmail").ToString()
                        Dim emailSent As Boolean = SendOrderEmail(userEmail, orderId, transactionNumber, cart)

                        If emailSent Then
                            Response.Write("<script>alert('Order placed successfully! '); setTimeout(function(){ window.location.href='OrderConfirmation.aspx?OrderId=" & orderId & "'; }, 1000);</script>")
                        Else
                            Response.Write("<script>alert('Order placed successfully.'); setTimeout(function(){ window.location.href='OrderConfirmation.aspx?OrderId=" & orderId & "'; }, 2000);</script>")
                        End If

                    Catch ex As Exception
                        Response.Write("<script>alert('something went wrong while placing your order: " & ex.Message.Replace("'", "\'") & "');</script>")
                        transaction.Rollback()
                    End Try
                End Using
            End If
        Else
            Response.Write("<script>alert('Please add something your cart is empty!');</script>")
        End If
    End Sub

    Function SendOrderEmail(ByVal userEmail As String, ByVal orderId As Integer, ByVal transactionNumber As String, ByVal cart As List(Of Dictionary(Of String, Object))) As Boolean
        Try
            Dim senderEmail As String = ConfigurationManager.AppSettings("EmailUsername")

            Dim mail As New MailMessage()
            mail.From = New MailAddress(senderEmail, "Cloud Kitchen")
            mail.To.Add(userEmail)
            mail.Subject = "🍽 Your Cloud Kitchen Order is Confirmed! # " & orderId
            mail.IsBodyHtml = True

            Dim cartTable As String = "
<table class='order-table'>
<tr>
<th>Item</th>
<th>Price</th>
<th>Qty</th>
<th>Total</th>
</tr>
"

            For Each item In cart

                cartTable &= "
    <tr>
        <td>" & item("m_name") & "</td>
        <td>₹" & Convert.ToDecimal(item("m_final_price")).ToString("F2") & "</td>
        <td>" & item("quantity") & "</td>
        <td>₹" & Convert.ToDecimal(item("total_price")).ToString("F2") & "</td>
    </tr>
    "

            Next

            cartTable &= "</table>"

            '    Dim emailBody As String = "<!DOCTYPE html>" &
            '"<html>" &
            '"<head>" &
            '    "<style>" &
            '        "body { font-family: Arial, sans-serif; background-color: #f8f9fa; margin: 0; padding: 0; }" &
            '        ".container { max-width: 600px; margin: 20px auto; background: #ffffff; padding: 20px; border-radius: 8px; box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1); }" &
            '        ".header { background: #007bff; color: #ffffff; text-align: center; padding: 15px; font-size: 22px; font-weight: bold; border-top-left-radius: 8px; border-top-right-radius: 8px; }" &
            '        ".content { padding: 20px; text-align: center; }" &
            '        ".content h2 { color: #333; }" &
            '        ".content p { font-size: 16px; color: #555; }" &
            '        ".order-details { background: #f1f1f1; padding: 15px; border-radius: 8px; margin-top: 15px; text-align: left; }" &
            '        ".order-details p { margin: 5px 0; font-size: 16px; }" &
            '        ".footer { text-align: center; padding: 10px; font-size: 14px; color: #777; }" &
            '        ".button { display: inline-block; background: #28a745; color: #fff; padding: 10px 20px; text-decoration: none; font-size: 16px; border-radius: 5px; margin-top: 15px; }" &
            '        ".button:hover { background: #218838; }" &
            '    "</style>" &
            '"</head>" &
            '"<body>" &
            '    "<div class='container'>" &
            '        "<div class='header'>Cloud Kitchen 🍽</div>" &
            '        "<div class='content'>" &
            '            "<h2>Thank you for your order!</h2>" &
            '            "<p>Your order has been successfully placed. Below are the details:</p>" &
            '            "<div class='order-details'>" &
            '                "<p><strong>Order ID:</strong> #" & orderId & "</p>" &
            '                "<p><strong>Transaction No:</strong> " & transactionNumber & "</p>" &
            '                "<p><strong>Estimated Delivery:</strong> 30-40 mins</p>" &
            '            "</div>" &
            '            "<h3>Your Order Summary:</h3>" &
            '            cartTable &
            '            "<a href='http://www.cloudkitchen.somee.com/MyOrders.aspx' sclass='button'>View My Orders</a>" &
            '        "</div>" &
            '        "<div class='footer'>" &
            '            "If you have any questions, contact us at <a href='mailto:info.cloudkitchenn@gmail.com'>info.cloudkitchenn@gmail.com</a>" &
            '        "</div>" &
            '    "</div>" &
            '"</body>" &
            '"</html>"


            Dim emailBody As String = "
<!DOCTYPE html>
<html>
<head>
<meta charset='UTF-8'>
<style>

body{
    margin:0;
    padding:0;
    background:#f4f6f9;
    font-family:Arial,sans-serif;
}

.wrapper{
    width:100%;
    padding:30px 0;
}

.container{
    max-width:650px;
    background:#ffffff;
    margin:auto;
    border-radius:16px;
    overflow:hidden;
    box-shadow:0 8px 30px rgba(0,0,0,0.08);
}

.header{
    background:linear-gradient(135deg,#4F7E76,#3a5f59);
    padding:35px;
    text-align:center;
    color:#fff;
}

.header h1{
    margin:0;
    font-size:32px;
}

.header p{
    margin-top:8px;
    opacity:0.9;
    font-size:15px;
}

.content{
    padding:35px;
}

.success-box{
    background:#f0fff4;
    border-left:5px solid #28a745;
    padding:18px;
    border-radius:10px;
    margin-bottom:25px;
}

.success-box h2{
    margin:0;
    color:#28a745;
}

.details{
    background:#fafafa;
    padding:20px;
    border-radius:12px;
    margin-top:20px;
}

.details p{
    margin:10px 0;
    color:#444;
    font-size:15px;
}

.table-title{
    margin-top:30px;
    color:#333;
    font-size:22px;
}

.order-table{
    width:100%;
    border-collapse:collapse;
    margin-top:15px;
}

.order-table th{
    background:#4F7E76;
    color:white;
    padding:14px;
    text-align:left;
    font-size:14px;
}

.order-table td{
    padding:14px;
    border-bottom:1px solid #eee;
    font-size:14px;
}

.total-box{
    text-align:right;
    margin-top:20px;
    font-size:22px;
    color:#4F7E76;
    font-weight:bold;
}

.button{
    display:inline-block;
    background:#ff9f43;
    color:#fff !important;
    text-decoration:none;
    padding:14px 28px;
    border-radius:50px;
    margin-top:30px;
    font-weight:bold;
    font-size:15px;
}

.footer{
    background:#f8f8f8;
    padding:25px;
    text-align:center;
    color:#777;
    font-size:13px;
}

.footer a{
    color:#4F7E76;
    text-decoration:none;
}

</style>
</head>

<body>

<div class='wrapper'>

<div class='container'>

<div class='header'>
    <h1>🍽 Cloud Kitchen</h1>
    <p>Fresh Meals Delivered To Your Doorstep</p>
</div>

<div class='content'>

<div class='success-box'>
    <h2>✅ Order Confirmed Successfully</h2>
    <p>Thank you for ordering with Cloud Kitchen.</p>
</div>

<p>Hello Customer,</p>

<p>
We are preparing your delicious food and your order will arrive shortly.
Thank you for choosing Cloud Kitchen.
</p>

<div class='details'>

<p><strong>🧾 Order ID:</strong> #" & orderId & "</p>

<p><strong>💳 Transaction ID:</strong> " & transactionNumber & "</p>

<p><strong>🚚 Delivery Address:</strong> " & txtAddress.Text & "</p>

<p><strong>📍 Pincode:</strong> " & ddlpincode.SelectedValue & "</p>

<p><strong>💰 Payment Method:</strong> " & ddlPaymentType.SelectedValue & "</p>

<p><strong>⏰ Estimated Delivery:</strong> 30 - 40 Minutes</p>

</div>

<h3 class='table-title'>🛒 Order Summary</h3>

" & cartTable & "

<div class='total-box'>
Total Amount: ₹" & lblTotalPrice.Text & "
</div>

<center>
<a href='https://www.cloudkitchen.somee.com/Customers/MyOrders.aspx' class='button'>
View My Orders
</a>
</center>

</div>

<div class='footer'>

<p>
Need help? Contact us anytime
</p>

<p>
📧 info.cloudkitchenn@gmail.com
</p>

<p>
© Cloud Kitchen - All Rights Reserved
</p>

</div>

</div>

</div>

</body>
</html>
"

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
        If txtCard1.Text.Length = 4 And txtCard2.Text.Length = 4 And txtCard3.Text.Length = 4 And txtCard4.Text.Length = 4 And
           txtExpiryMonth.Text.Length = 2 And txtExpiryYear.Text.Length = 2 And txtCCV.Text.Length = 3 And txtExpiryYear.Text > 25 And
           Not String.IsNullOrEmpty(txtCardName.Text) Then


            label1.Text = "Card details verified successfully. Proceed To Payment."
            label1.ForeColor = System.Drawing.Color.Green
            label1.Visible = True

            Button3.Enabled = True
            Panel1.Visible = False
            Panel3.Visible = True
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "showPanel", "showPanel();", True)
            ddlPaymentType.Enabled = False

        Else
            label1.Text = "Invalid card details. Please check again."
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


    Protected Sub ddlPaymentType_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs) Handles ddlPaymentType.SelectedIndexChanged

        If ddlPaymentType.SelectedIndex = 2 Then

            Dim amount As Decimal = Convert.ToDecimal(lblTotalPrice.Text)

            ' Razorpay amount in paise
            Dim amountInPaise As Integer = amount * 100

            Dim customerName As String = ""
            Dim customerEmail As String = ""
            Dim customerPhone As String = ""

            Using con As New SqlConnection(connString)

                Dim query As String = "SELECT c_name, email, phone FROM Customers WHERE c_id=@cid"

                Using cmd As New SqlCommand(query, con)

                    cmd.Parameters.AddWithValue("@cid", Session("c_id"))

                    con.Open()

                    Dim dr As SqlDataReader = cmd.ExecuteReader()

                    If dr.Read() Then

                        customerName = dr("c_name").ToString()
                        customerEmail = dr("email").ToString()
                        customerPhone = dr("phone").ToString()

                    End If

                End Using

            End Using

            Dim script As String = "
        var options = {
            'key': 'rzp_test_Sq7x7OL1DUIl17',
            'amount': '" & amountInPaise & "',
            'currency': 'INR',
            'name': 'Cloud Kitchen',
            'description': 'Food Order Payment',
            'image': '../icons/money.png',

            'handler': function (response) {

    document.body.insertAdjacentHTML('beforeend', `

    <div id='paymentSuccessPopup' style='
        position:fixed;
        top:0;
        left:0;
        width:100%;
        height:100%;
        background:rgba(0,0,0,0.65);
        z-index:99999;
        display:flex;
        justify-content:center;
        align-items:center;
        animation:fadeIn 0.3s ease;
    '>

        <div style='
            background:#fff;
            width:420px;
            border-radius:20px;
            padding:35px;
            text-align:center;
            box-shadow:0 15px 40px rgba(0,0,0,0.25);
            font-family:Arial;
            animation:popupScale 0.35s ease;
        '>

            <div style='
                width:90px;
                height:90px;
                background:#e8fff1;
                margin:auto;
                border-radius:50%;
                display:flex;
                align-items:center;
                justify-content:center;
                font-size:45px;
                color:#28a745;
            '>
                ✓
            </div>

            <h2 style='margin-top:20px;color:#28a745;'>
                Payment Successful
            </h2>

            <p style='
                color:#666;
                font-size:15px;
                margin-top:10px;
                line-height:24px;
            '>
                Your payment has been processed successfully, please proceed to order ❤️.
                <br/>
                Thank you for ordering with Cloud Kitchen 🍽
            </p>

            <div style='
                background:#f8f9fa;
                padding:12px;
                border-radius:10px;
                margin-top:20px;
                font-size:14px;
                color:#444;
            '>
                Payment ID:
                <br/>
                <strong id='payid'></strong>
            </div>

            <button onclick='continueOrder()' style='
                margin-top:25px;
                background:#4F7E76;
                border:none;
                color:white;
                padding:14px 28px;
                border-radius:50px;
                cursor:pointer;
                font-size:15px;
                font-weight:bold;
            '>
                Continue
            </button>

        </div>

    </div>

    <style>

    @keyframes popupScale{
        from{
            transform:scale(0.7);
            opacity:0;
        }
        to{
            transform:scale(1);
            opacity:1;
        }
    }

    @keyframes fadeIn{
        from{
            opacity:0;
        }
        to{
            opacity:1;
        }
    }

    </style>

    `);

    document.getElementById('payid').innerText = response.razorpay_payment_id;

    window.continueOrder = function(){

        __doPostBack('PaymentSuccess', response.razorpay_payment_id);

    };

},
            'theme': {
                'color': '#4F7E76'
            },

            'modal': {
                'ondismiss': function () {
                    alert('Payment Cancelled');
                }
            }
        };

        var rzp1 = new Razorpay(options);
        rzp1.open();
        "

            ScriptManager.RegisterStartupScript(Me,
                                            Me.GetType(),
                                            "razorpay",
                                            script,
                                            True)

        Else
            Panel1.Visible = False
        End If

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