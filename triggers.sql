use NutrifyHub;

-- TRIGGER DE CRIAR NOVO USUÁRIO --

DELIMITER //

CREATE TRIGGER msg_new_user
AFTER INSERT ON usuario 
FOR EACH ROW
BEGIN
    INSERT INTO log 
    VALUES (
        DEFAULT, 
        CONCAT('Novo usuário cadastrado do tipo: ', NEW.userType, ' de ID: ', NEW.userID, ' às ', DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:%s'))
    );
END;

// DELIMITER ;

-- TRIGGER DE CRIAR NOVO USUÁRIO --



-- TRIGGER DE DELETAR PACIENTE --

DELIMITER //

CREATE TRIGGER before_delete_paciente
BEFORE DELETE ON usuario
FOR EACH ROW
BEGIN
    -- Atualiza o campo 'ativo' para FALSE na tabela 'usuario'
    UPDATE usuario
    SET ativo = FALSE
    WHERE userID = OLD.userID;
    
    INSERT INTO log (mensagem) 
    VALUES (
        CONCAT(
            'Usuário de ID: ', 
            OLD.userID, 
            ' inativado às ', 
            DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:%s')
        )
    );
    
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Usuário inativado.';
    
END //

// DELIMITER ;

-- TRIGGER DE DELETAR PACIENTE --


-- TRIGGER DE DELETAR RECEITA --

DELIMITER //

CREATE TRIGGER deletar_receita
BEFORE DELETE ON receita
FOR EACH ROW
BEGIN

    delete from ReceitaDieta
    WHERE id_receita = OLD.receitaID;
    
    delete from ingredients
    WHERE receitaID = OLD.receitaID;
    
    delete from steps
    WHERE receitaID = OLD.receitaID;
    
    
INSERT INTO log 
    VALUES (
        DEFAULT, 
        CONCAT('Receita: ', OLD.nome, ' foi deletada com sucesso!')
    );
    
END //

// DELIMITER ;

-- TRIGGER DE DELETAR RECEITA --