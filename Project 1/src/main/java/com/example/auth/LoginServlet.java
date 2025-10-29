package com.example.auth;

import com.example.util.DBUtil;
import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        if (email == null || password == null) {
            req.setAttribute("error", "Preencha email e senha.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT id, nome, senha FROM Usuarios WHERE email = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, email);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        String nome = rs.getString("nome");
                        String hash = rs.getString("senha");
                        // Normalize bcrypt hash prefix for compatibility with different implementations
                        // jBCrypt (older versions) expects $2a$; many libs produce $2b$ or $2y$
                        String normalizedHash = hash;
                        if (hash != null) {
                            if (hash.startsWith("$2y$") || hash.startsWith("$2b$")) {
                                normalizedHash = "$2a$" + hash.substring(4);
                            }
                        }

                        if (normalizedHash != null && BCrypt.checkpw(password, normalizedHash)) {
                            HttpSession session = req.getSession(true);
                            session.setAttribute("userId", rs.getInt("id"));
                            session.setAttribute("userName", nome);
                            session.setAttribute("userEmail", email);
                            session.setMaxInactiveInterval(30 * 60);
                            resp.sendRedirect(req.getContextPath() + "/dashboard.jsp");
                            return;
                        }
                    }
                }
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }

        req.setAttribute("error", "Credenciais inválidas.");
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }
}
