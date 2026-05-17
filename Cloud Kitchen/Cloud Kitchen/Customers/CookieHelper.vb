Public Module CookieHelper
    Public Sub SetPersistentCookie(ByVal name As String, ByVal value As String, ByVal days As Integer)
        Dim userCookie As New HttpCookie(name, value)
        userCookie.Expires = DateTime.Now.AddDays(days)
        userCookie.HttpOnly = True
        HttpContext.Current.Response.Cookies.Add(userCookie)
    End Sub

    Public Sub RemoveCookie(ByVal name As String)
        If HttpContext.Current.Request.Cookies(name) IsNot Nothing Then
            Dim userCookie As New HttpCookie(name)
            userCookie.Expires = DateTime.Now.AddDays(-1)
            HttpContext.Current.Response.Cookies.Add(userCookie)
        End If
    End Sub
End Module
