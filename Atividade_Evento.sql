DROP DATABASE evento;
CREATE DATABASE IF NOT EXISTS evento;
USE evento;
SET GLOBAL EVENT_SCHEDULER = ON;
SHOW VARIABLES LIKE 'EVENT_SCHEDULER';

-- tabela tarefas
CREATE TABLE tarefas(
id INT auto_increment primary key,
descricao varchar (50),
status varchar(50)

);
 -- DROP TABLE tarefas;
INSERT INTO tarefas (descricao,status) values 
('Atividade Front','pendentes'),
('Fazer o footer','pendentes'),
('Prova Banco de dados','pendentes'),
('Estudar Matematica','pendentes'),
('Leitura do livro','pendentes');

 -- criando envento que após 1 minuto altera o status para Em andamento

CREATE EVENT atualizar_status_tarefas
ON SCHEDULE AT CURRENT_TIMESTAMP + INTERVAL 
 1 MINUTE
DO
	UPDATE tarefas SET status = 'Em andamento';


SELECT * FROM tarefas;


-- criando envento que após 15 minutos altera o status para Finalizado
 
CREATE EVENT finalizar_status_tarefas
ON SCHEDULE AT CURRENT_TIMESTAMP + INTERVAL 
 15 MINUTE
DO
	UPDATE tarefas SET status = 'Finalizado';


SELECT * FROM tarefas;


SHOW EVENTS; -- Utilizado para vizualizar os evento

DROP EVENT finalizar_status_tarefa; -- Utilizado para excluir um evento

-- Perguntas 
# •O que aconteceria se o event_scheduler estivesse desativado?
-- o evento nao funcionaria e nao iria alterar as tarefas 

# •Por que eventos são úteis em um sistema real?
-- sao uteis para automatizar as tarefas garantindo a integridade dos dados

# •Qual a diferença entre evento único e evento recorrente?
 --  o evento unico é utilizado apenas uma vez, ja o recorrente se repete em um ciclo determinado
 