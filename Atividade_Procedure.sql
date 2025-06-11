DROP DATABASE Estoque;
CREATE DATABASE IF NOT EXISTS Estoque;
USE Estoque;

-- tabela estoque
CREATE TABLE estoque(
id INT auto_increment primary key,
produto varchar (100),
quantidade INT

);
 -- DROP TABLE Produtos;
INSERT INTO estoque (produto,quantidade) values 
('Arroz', 5),
('Caixas de Leite', 24 ),
('Fardo de Feijão', 30 ),
('Farinha', 10 ),
('Bolacha', 10 );

-- Criação da procedure
DELIMITER $$

CREATE PROCEDURE registrar_saida (
    IN nome_produto VARCHAR(100),
    IN qtd_retirar INT
)
BEGIN
    DECLARE estoque_atual INT;

    -- Buscar o estoque atual do produto
    SELECT quantidade INTO estoque_atual
    FROM estoque
    WHERE produto = nome_produto;

    -- Verifica se o produto existe
    IF estoque_atual IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Produto não encontrado.';
    -- Verifica se há estoque suficiente
    ELSEIF estoque_atual < qtd_retirar THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Estoque insuficiente.';
    ELSE
        -- Atualiza o estoque
        UPDATE estoque
        SET quantidade = quantidade - qtd_retirar
        WHERE produto = nome_produto;
    END IF;
END $$

DELIMITER ;

CALL registrar_saida('Arroz', 3); -- subtrair 3 do estoque de Arroz

CALL registrar_saida('Bolacha', 20);  --  gerar erro: Estoque insuficiente

CALL registrar_saida('Refrigerante', 2); --  gerar erro: Produto não encontrado

-- ########################################
DELIMITER $$

CREATE PROCEDURE consultar_estoque (
    IN nome_produto VARCHAR(100)
)
BEGIN
    DECLARE qtd_disponivel INT;

    -- Obter a quantidade disponível
    SELECT quantidade INTO qtd_disponivel
    FROM estoque
    WHERE produto = nome_produto;

    -- Verificar se o produto existe
    IF qtd_disponivel IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Produto não encontrado.';
    ELSE
        -- Retornar a quantidade disponível
        SELECT CONCAT('Quantidade disponível de "', nome_produto, '": ', qtd_disponivel) AS resultado;
    END IF;
END $$

DELIMITER ;

CALL consultar_estoque('Farinha');