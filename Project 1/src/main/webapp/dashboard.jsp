<%@ page session="true" contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8" />
  <title>Dashboard</title>
  <link rel="stylesheet" href="styles.css" />
</head>
<body>
<%
  String email = (String) session.getAttribute("userEmail");
  String nome = (String) session.getAttribute("userName");
  if (email == null) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
  }
%>
  <h1 style="text-align:center;">Bem-vindo, <%= (nome != null ? nome : email) %>!</h1>
  <div style="text-align:center; margin-top:20px;">
    <a class="my-button" href="<%= request.getContextPath() %>/logout">Sair</a>
  </div>
</body>
</html>
