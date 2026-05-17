Public Class Logout
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Session.Abandon()
            Session.Clear()
            Session.RemoveAll()


            Response.Cache.SetCacheability(HttpCacheability.NoCache)
            Response.Cache.SetExpires(DateTime.UtcNow.AddMinutes(-1))
            Response.Cache.SetNoStore()

            RemoveCookie("UserEmail")
            RemoveCookie("UserPass")
            Response.Redirect("Login.aspx")
        End If
    End Sub
    Private Sub RemoveCookie(ByVal cookieName As String)
        If Request.Cookies(cookieName) IsNot Nothing Then
            Dim myCookie As New HttpCookie(cookieName)
            myCookie.Expires = DateTime.Now.AddDays(-1)
            Response.Cookies.Add(myCookie)
        End If
    End Sub
End Class