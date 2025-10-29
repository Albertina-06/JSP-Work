<%@ page import="java.sql.*" %>
<%@ page import="com.example.util.DBUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8" />
  <title>Lista de Usuários</title>
  <style>
    table { border-collapse: collapse; width: 80%; margin: 20px auto; }
    th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
    h2 { text-align: center; }
  </style>
</head>
<body>
  <h2>Usuários</h2>

<%
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        conn = DBUtil.getConnection();
        String sql = "SELECT id, nome, idade, email FROM Usuarios";
        ps = conn.prepareStatement(sql);
        rs = ps.executeQuery();
%>

<table>
  <thead>
    <tr><th>ID</th><th>Nome</th><th>Idade</th><th>Email</th></tr>
  </thead>
  <tbody>
  <%
    while (rs.next()) {
  %>
    <tr>
      <td><%= rs.getInt("id") %></td>
      <td><%= rs.getString("nome") %></td>
      <td><%= rs.getObject("idade") == null ? "" : rs.getInt("idade") %></td>
      <td><%= rs.getString("email") %></td>
    </tr>
  <%
    }
  %>
  </tbody>
</table>

<%
    } catch (Exception e) {
%>
    <p style="color:red; text-align:center;">Erro: <%= e.getMessage() %></p>
<%
    } finally {
        if (rs != null) try { rs.close(); } catch(Exception ignore) {}
        if (ps != null) try { ps.close(); } catch(Exception ignore) {}
        if (conn != null) try { conn.close(); } catch(Exception ignore) {}
    }
%>

</body>
</html>
