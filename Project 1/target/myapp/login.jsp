<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8" />
  <title>Login</title>
  <link rel="stylesheet" href="styles.css" />
  <style>
    .login-box { max-width: 380px; margin: 60px auto; background: rgba(255,255,255,.92); padding: 22px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,.15); }
    .login-box h2 { margin-top: 0; text-align:center; }
    .login-box label { display:block; margin-top:10px; font-weight:600; }
    .login-box input { width:100%; padding:8px; margin-top:6px; box-sizing:border-box; }
    .login-box button { margin-top: 14px; padding: 10px 16px; background-color: #007bff; color:#fff; border:0; border-radius:4px; cursor:pointer; width:100%; }
    .login-box button:hover { background:#0056b3; }
    .error { color:#c00; margin-top:10px; text-align:center; }
  </style>
</head>
<body>
  <div class="login-box">
    <h2>Login</h2>
    <form method="post" action="<%= request.getContextPath() %>/login">
      <label for="email">Email</label>
      <input type="email" id="email" name="email" required />

      <label for="password">Senha</label>
      <input type="password" id="password" name="password" required />

      <button type="submit">Entrar</button>
    </form>
    <% String err = (String) request.getAttribute("error"); if (err != null) { %>
      <p class="error"><%= err %></p>
    <% } %>
  </div>
</body>
</html>
