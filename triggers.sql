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