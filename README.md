# MyApp — Guia completo de execução e solução de problemas

Aplicativo web Java (WAR) com JSP/Servlets (Jakarta) + MariaDB. Este guia resume os passos e também os problemas reais encontrados e como resolvê-los.

Pré-requisitos
- Java 11+ e Maven
- MariaDB (localhost:3306)
- Tomcat 10 (instalação manual em /opt/tomcat) ou Jetty (via Maven)

Estrutura do banco
- Schema: `User` (atenção: é sensível a maiúsculas e é palavra reservada; use sempre crases `\``User`\``)
- Tabela: `Usuarios (id, nome, idade, email UNIQUE, senha)`

SQL inicial (se precisar criar):
```sql
CREATE DATABASE IF NOT EXISTS `User`
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `User`;
CREATE TABLE IF NOT EXISTS `Usuarios` (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(150) NOT NULL,
  idade INT,
  email VARCHAR(255) NOT NULL UNIQUE,
  senha VARCHAR(255) NOT NULL
);
```

O arquivo `insert_user.sql` já faz:
- USE `User`;
- CREATE TABLE IF NOT EXISTS `Usuarios`;
- INSERT com `ON DUPLICATE KEY UPDATE` (idempotente)

Para inserir o usuário de teste:
```bash
mariadb -u dbeaver -p User < insert_user.sql
```

Sobre senhas (bcrypt)
- A coluna `senha` armazena hash bcrypt (ex.: `$2b$12$...`).
- O `LoginServlet` normaliza `$2b$`/`$2y$` para `$2a$` antes de validar com jBCrypt, evitando o erro “Invalid salt revision”.
- Recomenda-se gerar hashes no servidor com jBCrypt ao registrar usuários (futuro).

Assets estáticos (CSS/Imagens)
- Coloque imagens em `src/main/webapp/images/` (ex.: `images/wallpaper.jpg`).
- O CSS principal está em `src/main/webapp/styles.css` e referencia `background-image: url('images/wallpaper.jpg')`.
- Após adicionar imagens, rode `mvn clean package` e redeploy.

Rodar localmente (Jetty) — recomendado para desenvolvimento
```bash
# No diretório do projeto
mvn clean package
mvn jetty:run
# Acesse: http://localhost:8080/login.jsp
```

Deploy no Tomcat 10 (instalação manual)
1) Copie o WAR e reinicie:
```bash
mvn clean package
sudo cp target/myapp.war /opt/tomcat/webapps/
sudo chown tomcat:tomcat /opt/tomcat/webapps/myapp.war  # ajuste usuário se seu Tomcat roda como outro usuário
sudo /opt/tomcat/bin/shutdown.sh
sudo /opt/tomcat/bin/startup.sh
```
2) Verifique logs e contexto:
```bash
sudo tail -n 200 /opt/tomcat/logs/catalina.out
sudo ls -la /opt/tomcat/webapps
```
3) URL:
- http://localhost:8080/myapp/login.jsp (se implantado como `myapp.war`)
- http://localhost:8080/login.jsp (se renomeado para `ROOT.war`)

Driver MariaDB no Tomcat (quando usar JNDI)
- Copie o JAR do driver para `/opt/tomcat/lib/`:
```bash
sudo cp ~/.m2/repository/org/mariadb/jdbc/mariadb-java-client/3.0.10/mariadb-java-client-3.0.10.jar /opt/tomcat/lib/
sudo chown tomcat:tomcat /opt/tomcat/lib/mariadb-java-client-3.0.10.jar
sudo /opt/tomcat/bin/shutdown.sh && sudo /opt/tomcat/bin/startup.sh
```
- Se NÃO usar JNDI e sim `DriverManager` (como `DBUtil` atual), o driver já vai dentro do WAR e não precisa copiar para `/opt/tomcat/lib/`.

Checklist rápido (pós-deploy)
- [ ] `target/myapp.war` existe e foi copiado para `/opt/tomcat/webapps/`
- [ ] Tomcat re-iniciado e logs sem erros SEVERE/Exception
- [ ] Contexto aparece em `/opt/tomcat/webapps/myapp/` (diretório expandido)
- [ ] A URL correta está sendo usada (com `myapp` ou `/`)
- [ ] Imagens estão em `src/main/webapp/images/` e carregam (ver DevTools/Network)

Problemas reais enfrentados e soluções
1) “Unknown database ‘Usuarios’/‘usuarios’”
  - No Linux, nomes são sensíveis a maiúsculas. O schema correto é `User`. Use crases: `USE `User`;`

2) “Access denied for user 'root'@'localhost'” ao usar `-p`
  - Em Debian/Ubuntu o root usa `unix_socket`. Conecte como root com `sudo mariadb`. Para usuários normais: `mariadb -u dbeaver -p User` (digite a senha quando solicitado).
  - Crie/ajuste usuário e privilégios:
```sql
CREATE USER IF NOT EXISTS 'dbeaver'@'localhost' IDENTIFIED BY 'senha123';
GRANT ALL PRIVILEGES ON `User`.* TO 'dbeaver'@'localhost';
FLUSH PRIVILEGES;
```

3) “Table 'User.Usuarios' doesn't exist”
  - A tabela não existia naquele momento. `insert_user.sql` passou a criar a tabela com `CREATE TABLE IF NOT EXISTS` antes do INSERT.

4) “Duplicate entry 'user@example.com' for key 'email'”
  - O INSERT agora usa `ON DUPLICATE KEY UPDATE`, tornando o script idempotente.

5) “HTTP 404 Not Found” ao abrir a app
  - O WAR não estava em `/opt/tomcat/webapps/` ou não foi expandido. Copie `target/myapp.war` para lá e reinicie o Tomcat. Verifique `catalina.out`.

6) “Invalid salt revision” ao logar (bcrypt)
  - O hash veio com `$2b$` e jBCrypt esperava `$2a$`. O `LoginServlet` normaliza `$2b$/$2y$` para `$2a$` antes de validar.

7) Imagem de fundo não aparece
  - A imagem precisa estar no WAR. Coloque em `src/main/webapp/images/wallpaper.jpg`, atualize `styles.css` (já aponta para `images/wallpaper.jpg`), refaça o build e redeploy.

URLs da aplicação
- Login: `/login.jsp`
- Dashboard (pós-login): `/dashboard.jsp`
- Logout: `/logout`

Próximos passos sugeridos
- Criar `RegisterServlet` + página de registro (gerar hash com jBCrypt).
- Migrar `DBUtil` para JNDI/DataSource (pool de conexões no Tomcat).
- Adicionar `index.jsp` que redireciona para `/login.jsp`.
- Colocar HTTPS/proxy reverso para produção e restringir Tomcat Manager.

Qualquer dúvida, verifique os logs do Tomcat:
```bash
sudo tail -n 200 /opt/tomcat/logs/catalina.out
```

email: user@example.com
senha senha123