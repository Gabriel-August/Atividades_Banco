#- ******** EVENTOS ********

DROP DATABASE IF EXISTS eventos;
CREATE DATABASE eventos;
USE eventos;

-- Ativando o agendador de eventos
SET GLOBAL event_scheduler = ON;
SHOW VARIABLES LIKE 'event_scheduler';

-- Tabela de logs
CREATE TABLE logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    mensagem VARCHAR(255),
    data_hora DATETIME
);

-- Tabela de produtos
CREATE TABLE produtos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    preco DECIMAL(10,2),
    categoria VARCHAR(50)
);

-- Tabela de notificações
CREATE TABLE notificacoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    mensagem VARCHAR(255),
    data_hora DATETIME
);

-- Evento para inserir logs
CREATE EVENT insere_log
ON SCHEDULE EVERY 1 MINUTE
DO
    INSERT INTO logs(mensagem, data_hora)
    VALUES ('execução automática', NOW());

-- Inserindo produtos
INSERT INTO produtos (nome, preco, categoria)
VALUES 
    ('notebook', 5000.99, 'Eletrônicos'),
    ('smartphone', 2000.00, 'Eletrônicos'),
    ('camiseta', 100.00, 'Vestuário');

-- Evento para aplicar desconto
CREATE EVENT aplica_desconto
ON SCHEDULE AT CURRENT_TIMESTAMP + INTERVAL 1 MINUTE
DO
    UPDATE produtos
    SET preco = preco * 0.9
    WHERE categoria = 'Eletrônicos';

-- Evento para limpar logs antigos
CREATE EVENT limpa_logs
ON SCHEDULE EVERY 1 DAY
DO
    DELETE FROM logs
    WHERE data_hora < NOW() - INTERVAL 30 DAY;

-- Verificação de eventos
SHOW EVENTS;
SHOW CREATE EVENT insere_log;

-- Limpando logs
TRUNCATE TABLE logs;

-- Ver produtos
SELECT id, nome, preco, categoria FROM produtos;

-- Ver status de execução do evento
SELECT LAST_EXECUTED, STATUS 
FROM information_schema.EVENTS 
WHERE EVENT_NAME = 'insere_log';

-- ******** STORED PROCEDURES ********

DROP DATABASE IF EXISTS loja;
CREATE DATABASE loja;
USE loja;

-- Tabela de clientes
CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(100),
    ativo BOOLEAN DEFAULT TRUE
);

-- Tabela de vendas (corrigida)
CREATE TABLE vendas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,
    valor DECIMAL(10,2),
    data_venda DATE,
    FOREIGN KEY(cliente_id) REFERENCES clientes(id)
);

-- Procedure para inserir cliente
DELIMITER //
CREATE PROCEDURE inserir_cliente(
    IN nome_cliente VARCHAR(100),
    IN email_cliente VARCHAR(100)
)
BEGIN
    INSERT INTO clientes(nome, email)
    VALUES (nome_cliente, email_cliente);
END //
DELIMITER ;

-- Inserir um cliente de exemplo
CALL inserir_cliente('Diogo Campos', 'diogo@email.com');
SELECT * FROM clientes;

-- Procedure para calcular total de vendas por cliente
DELIMITER //
CREATE PROCEDURE total_vendas_cliente(
    IN cliente INT,
    OUT total DECIMAL(10,2)
)
BEGIN
    SELECT SUM(valor) INTO total
    FROM vendas
    WHERE cliente_id = cliente;
END //
DELIMITER ;

-- Teste com cliente sem vendas
CALL inserir_cliente('Cliente sem vendas', 'semvendas@teste.com');
SET @cliente_id = LAST_INSERT_ID();
SET @total = 0;
CALL total_vendas_cliente(@cliente_id, @total);
SELECT @total;

-- Teste com cliente com vendas
CALL inserir_cliente('Cliente com vendas', 'comvendas@teste.com');
SET @cliente_id = LAST_INSERT_ID();

-- Inserindo vendas para o cliente
INSERT INTO vendas(cliente_id, valor, data_venda) VALUES
(@cliente_id, 100.50, '2025-01-01'),
(@cliente_id, 200.70, '2025-01-02'),
(@cliente_id, 55.25, '2025-01-03');

SELECT * FROM vendas;

-- Calcular total de vendas
SET @total = 0;
CALL total_vendas_cliente(@cliente_id, @total);
SELECT @total;

-- Procedure para inserir 100 clientes automaticamente
DELIMITER //
CREATE PROCEDURE inserir_clientes_automatico()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 100 DO
        CALL inserir_cliente(CONCAT('Cliente', i), CONCAT('cliente', i, '@teste.com'));
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;

-- Executar inserção em massa
CALL inserir_clientes_automatico();
SELECT * FROM clientes;

#***************************
#********function***********
#***************************

/* TEORIA:
blocos de codigo armazenado no Bd que executa um calculo e retorna o valor correspondente
select, where, order by etc....
- calculos repetitivos
- organizacao de codigo
*/


CREATE DATABASE funcao;
use funcao;
DELIMITER //
	CREATE FUNCTION multiplica_por_dois(valor int)
    returns int
    deterministic
    begin
		return valor * 2 ;
    end //
DELIMITER ;

SELECT multiplica_por_dois(5);

#criar tabelas produtos

CREATE TABLE produtos (
	id int auto_increment primary key,
    nome varchar(100),
    preco decimal(10,2),
    quantidade int
);

insert into produtos (nome, preco, quantidade) values
('notebook dell', 4200.00, 4),
('fone de ouvido', 199.90, 12),
('monitor 24 polegadas 120hz', 899.00, 0);

SELECT * FROM produtos;
#funcao para calcular o valoe total de mercadoria!!
DELIMITER //
	CREATE FUNCTION calcular_valor_total(produto_id int)
    RETURNS DECIMAL(10,2)
    deterministic
    BEGIN
		DECLARE total DECIMAL(10,2);
        SELECT preco * quantidade INTO total
        FROM produtos
        WHERE id = produto_id;
        return total;
	END //
DELIMITER ;

SELECT id, nome, calcular_valor_total(id) as total_em_estoque
FROM produtos;