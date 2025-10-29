package com.example.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Utilitário simples para obter conexões JDBC com MariaDB.
 * Ajuste URL, usuário e senha conforme seu ambiente.
 * Em produção, prefira usar JNDI/DataSource e pool de conexões.
 */
public class DBUtil {
    // Database name corrected to "User" (schema), table remains "Usuarios"
    private static final String URL = "jdbc:mariadb://localhost:3306/User?useUnicode=true&characterEncoding=UTF-8";
    private static final String USER = "dbeaver";
    private static final String PASS = "senha123";

    static {
        try {
            Class.forName("org.mariadb.jdbc.Driver");
        } catch (ClassNotFoundException ex) {
            throw new RuntimeException("MariaDB JDBC Driver not found", ex);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
