Imports System.Data.SqlClient

Public Class Admin
    Inherits System.Web.UI.MasterPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        cntm()
        If Not IsPostBack Then

            'If Session("UserEmail") Is Nothing Then
            '    Response.Redirect("../Customers/Login.aspx")
            'End If
            cntm()
            cnto()
        End If
    End Sub


    Private Sub cntm()
        Try
            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("constr").ConnectionString)
                conn.Open()

                Dim msgg As Object = New SqlCommand("SELECT COUNT(*) FROM contact_messages where status=0", conn).ExecuteScalar()
                If Convert.ToInt32(msgg) = 0 Then
                    lblcnt.Visible = False
                Else
                    lblcnt.Text = If(IsDBNull(msgg), "0", msgg.ToString())
                End If


            End Using
        Catch ex As Exception
            Response.Write("<script>alert('Dashboard Data Error: " & ex.Message & "');</script>")
        End Try
    End Sub

    Private Sub cnto()
        Try
            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("constr").ConnectionString)
                conn.Open()

                Dim msgg As Object = New SqlCommand("SELECT COUNT(*) FROM Orders where order_status='Pending'", conn).ExecuteScalar()
                If Convert.ToInt32(msgg) = 0 Then
                    lblorder.Visible = False
                Else
                    lblorder.Text = If(IsDBNull(msgg), "0", msgg.ToString())
                End If


            End Using
        Catch ex As Exception
            Response.Write("<script>alert('Dashboard Data Error: " & ex.Message & "');</script>")
        End Try
    End Sub

End Class