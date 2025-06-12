DROP DATABASE Tech_Tudo;
CREATE DATABASE IF NOT EXISTS Tech_Tudo;
USE Tech_Tudo;

   -- DROP TABLE estoque;
CREATE TABLE estoque(
id INT AUTO_INCREMENT PRIMARY Key,
produto VARCHAR(100),
quantidade INT

);

INSERT INTO estoque (produto, quantidade) VALUES ('Mouse USB', 50);
INSERT INTO estoque (produto, quantidade) VALUES ('Teclado Mecânico', 30);
INSERT INTO estoque (produto, quantidade) VALUES ('Monitor LED 24"', 20);
INSERT INTO estoque (produto, quantidade) VALUES ('Notebook Gamer', 10);



DELIMITER //

CREATE FUNCTION verificar_disponibilidade(prod VARCHAR(100))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE qtd INT;

    SELECT quantidade INTO qtd
    FROM estoque
    WHERE produto = prod
    LIMIT 1;

    IF qtd > 0 THEN
        RETURN 'Disponível';
    ELSE
        RETURN 'Indisponível';
    END IF;
END;
//

DELIMITER ;

-- Listar nomes dos produtos e disponibilidade
SELECT produto, verificar_disponibilidade(produto) AS disponibilidade
FROM estoque;

#########
ALTER TABLE estoque ADD preco DECIMAL(10,2); -- ADICIONA PRECO NA TABELA

-- ADICIONADO PRECO AOS PRODUTOS
UPDATE estoque SET preco = 80 WHERE produto = 'Mouse USB';
UPDATE estoque SET preco = 150 WHERE produto = 'Teclado Mecânico';
UPDATE estoque SET preco = 600 WHERE produto = 'Monitor LED 24"';


DELIMITER //
CREATE FUNCTION classificar_preco(prod VARCHAR(100))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE p DECIMAL(10,2);

    SELECT preco INTO p
    FROM estoque
    WHERE produto = prod
    LIMIT 1;

    IF p < 100 THEN
        RETURN 'Barato';
    ELSEIF p <= 500 THEN
        RETURN 'Moderado';
    ELSE
        RETURN 'Caro';
    END IF;
END;
//

DELIMITER ;

-- LISTA OS PRODUTOS COM A CLASSIFICAÇAO DE PRECO
SELECT produto, classificar_preco(produto) AS classificacao
FROM estoque;


-- Verifica Estoque

DELIMITER //

CREATE FUNCTION verificar_estoque_suficiente(prod VARCHAR(100), qtd_desejada INT)
RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN
    DECLARE qtd INT;

    SELECT quantidade INTO qtd
    FROM estoque
    WHERE produto = prod
    LIMIT 1;

    IF qtd >= qtd_desejada THEN
        RETURN 'Estoque suficiente';
    ELSE
        RETURN 'Estoque insuficiente';
    END IF;
END;
//

DELIMITER ;
-- add produto
INSERT INTO estoque (produto, quantidade, preco) VALUES ('Monitor LG', 5, 750.00);


SELECT verificar_estoque_suficiente('Monitor LG', 3) AS resultado;


SELECT verificar_disponibilidade('Notebook Gamer') 