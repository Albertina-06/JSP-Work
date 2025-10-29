-- Use o schema correto
USE `User`;

-- Cria a tabela se não existir
CREATE TABLE IF NOT EXISTS `Usuarios` (
	id INT AUTO_INCREMENT PRIMARY KEY,
	nome VARCHAR(150) NOT NULL,
	idade INT,
	email VARCHAR(255) NOT NULL UNIQUE,
	senha VARCHAR(255) NOT NULL
);

-- Insere um usuário de teste com hash bcrypt já gerado
-- Se o email já existir (chave única), atualiza os demais campos
INSERT INTO `Usuarios` (nome, idade, email, senha)
VALUES ('Usuário Teste', 30, 'user@example.com', '$2b$12$NWnAXxpIse.NGG6TPbYjJOZe6IxfwHWurVqM7ORhpl50gQycwJ.PO')
ON DUPLICATE KEY UPDATE
	nome = VALUES(nome),
	idade = VALUES(idade),
	senha = VALUES(senha);
