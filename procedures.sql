use NutrifyHUb;

-- PROCEDURE DE ADICIONAR NUTRICIONISTA --

DELIMITER //
CREATE PROCEDURE add_nutri (nome varchar(100), email varchar(100), senha varchar(100), CRN VARCHAR(5), iduser int)
BEGIN
    DECLARE newUserID INT;
    DECLARE user_type int;
    
    SELECT userType INTO user_type
    FROM usuario
    WHERE userID = iduser;
    
    -- verifica o tipo de usuário que esta inserindo o nutricionista
    IF user_type = 0 THEN

        INSERT INTO usuario (nome, email, senha, ativo, userType) 
        VALUES (nome, email, senha, TRUE, 1);
        

        SET newUserID = LAST_INSERT_ID();


        INSERT INTO nutri (CRN, userID) 
        VALUES (CRN, newUserID);
          
    ELSE
		INSERT INTO log(mensagem) VALUES ("Tentativa não autorizada de inserir um nutricionista.");
        
    END IF;
END
//

DELIMITER ;

-- PROCEDURE DE ADICIONAR NUTRICIONISTA --



-- PROCEDURE DE CRIAR NOVO PACIENTE --
DELIMITER //
CREATE PROCEDURE add_pacient (nome VARCHAR(100), email VARCHAR(100), senha VARCHAR(100), nutricionista INT)
BEGIN
    DECLARE newUserID INT;
    DECLARE id_nutri INT;
    DECLARE stat BOOLEAN;
    -- Verificar se o nutricionista existe e obter seu ID
    SELECT nutriID INTO id_nutri
    FROM nutri
    WHERE nutriID = nutricionista;
    -- Verificar se o nutricionista esta ativo
    SELECT U.ativo INTO stat
    FROM usuario U
    INNER JOIN nutri N ON N.userID = U.userID
    WHERE N.nutriID = id_nutri;

    IF id_nutri IS NULL OR stat = FALSE THEN
        INSERT INTO log (mensagem) VALUES ('Nutricionista selecionado não existe ou está inativo');
    ELSE
        INSERT INTO usuario (nome, email, senha, ativo, userType) 
        VALUES (nome, email, senha, TRUE, 2); 

        SET newUserID = LAST_INSERT_ID();

        INSERT INTO pacient (userID, nutriID) 
        VALUES (newUserID, id_nutri);
    END IF;
END
// DELIMITER ;

-- PROCEDURE DE CRIAR NOVO PACIENTE --



-- PROCEDURE DE ADICIONAR RECEITA --

DELIMITER //
CREATE PROCEDURE add_receita (nome varchar(100), creator int)
BEGIN

	DECLARE id_usuario INT;
	DECLARE stat BOOLEAN;
    declare tipo int;

	SELECT userID INTO id_usuario
	FROM usuario
	WHERE userID = creator;
    
    SELECT userType INTO tipo
	FROM usuario
	WHERE userID = creator;

	SELECT ativo INTO stat
	FROM usuario 
	WHERE userID = id_usuario;

	IF id_usuario IS NULL OR stat = FALSE or tipo = 0 THEN
		INSERT INTO log (mensagem) VALUES ('O criador da receita não foi encontrado!');
	ELSE

		INSERT INTO receita VALUES 
        (default, creator, nome);

	END IF;

END
// DELIMITER ;

-- PROCEDURE DE ADICIONAR RECEITA --



-- PROCEDURE DE ADICIONAR INGREDIENTE --

DELIMITER //
CREATE PROCEDURE add_ing (ing varchar(100), qtd float, medida varchar(5), recipe int)
BEGIN

	DECLARE id_receita INT;

	SELECT receitaID INTO id_receita
	FROM receita
	WHERE receitaID = recipe;
    

	IF id_receita IS NULL THEN
		INSERT INTO log (mensagem) VALUES ('Esta receita não existe!');
	ELSE
    
		INSERT INTO ingredients VALUES 
        (default, recipe, ing, qtd, medida);

	END IF;

END
// DELIMITER ;

-- PROCEDURE DE ADICIONAR INGREDIENTE --



-- Add step --

DELIMITER //

CREATE PROCEDURE add_step (passo INT, descricao VARCHAR(255), recipe INT)
BEGIN
    DECLARE id_receita INT;
    DECLARE passo_existe BOOLEAN;
    
    -- Verificar se a receita existe
    SELECT receitaID INTO id_receita
    FROM receita
    WHERE receitaID = recipe;
    
    IF id_receita IS NULL THEN
        INSERT INTO log (mensagem) VALUES ('A receita não existe!');
    ELSE
        -- Verificar se o passo ja existe
        SELECT COUNT(*) INTO passo_existe
        FROM steps
        WHERE receitaID = recipe AND step = passo;
        
        IF passo_existe > 0 THEN
            INSERT INTO log (mensagem) VALUES ('O passo já existe para esta receita!');
        ELSE
            INSERT INTO steps (receitaID, step, descricao) 
            VALUES (recipe, passo, descricao);
        END IF;
    END IF;
END
//

DELIMITER ;


 -- add step  --  
 
 
 
 --  NOVA DIETA --
 
 DELIMITER //
CREATE PROCEDURE add_dieta (creatorID int, pacientID int, calo int, prote int, carbo int, agua float)
BEGIN
    DECLARE id_criador INT DEFAULT 0;
    DECLARE id_pacient INT DEFAULT 0;
    
    -- Verifica se o criador existe
    SELECT userType INTO id_criador
    FROM usuario
    WHERE userID = creatorID;
    
    -- Verifica se o paciente existe
    SELECT userType INTO id_pacient
    FROM usuario
    WHERE userID = pacientID;
    
    IF id_criador != 1 THEN
        INSERT INTO log (mensagem) VALUES ('Nutricionista não encontrado!');
    ELSE
    
        IF id_pacient != 2 THEN
            INSERT INTO log (mensagem) VALUES ('Paciente não encontrado!');
        ELSE
            INSERT INTO dieta (criadorID, pacienteID, calorias, proteinas, carboidratos, agua) 
            VALUES (creatorID, pacientID, calo, prote, carbo, agua);
        END IF;
    END IF;
END
// DELIMITER ;
 
--  NOVA DIETA --

-- drop procedure add_dieta;

-- ADICIONAR RECEITA NA DIETA --

DELIMITER //
CREATE PROCEDURE add_ReceitaDieta (recipe int, diet int, period VARCHAR(50))
BEGIN
    DECLARE id_recipe INT;
    DECLARE id_diet INT;
    Declare nutri_dieta int;
    Declare nutri_receita int;
    
    -- Verifica se a receita existe
    SELECT receitaID INTO id_recipe
    FROM receita
    WHERE receitaID = recipe;
    
    -- Verifica se a dieta existe
    SELECT dietaID INTO id_diet
    FROM dieta
    WHERE dietaID = diet;
    
    -- Verifica o criador da dieta escolhida
    SELECT criadorID INTO nutri_dieta
    FROM dieta
    WHERE dietaID = diet;
    
    -- Verifica o criador da receita escolhida
    SELECT criadorID INTO nutri_receita
    FROM receita
    WHERE receitaID = recipe;
    
    IF id_recipe IS NULL THEN
        INSERT INTO log (mensagem) VALUES ('Esta receita não existe!');
    ELSE
    
		IF id_diet IS NULL THEN
			INSERT INTO log (mensagem) VALUES ('Esta dieta não existe!');
		ELSE
        
			IF nutri_dieta =  nutri_receita THEN
				INSERT INTO ReceitaDieta (id_receita, id_dieta, periodo) 
				VALUES (recipe, diet, period);
			ELSE	
				INSERT INTO log (mensagem) VALUES ('Receita escolhida não é do nutricionista correto!');

			END IF;
		END IF;
    END IF;
END
// DELIMITER ;

-- ADICIONAR RECEITA NA DIETA --



-- DELETAR USUARIO -- 

DELIMITER //
CREATE PROCEDURE delete_user (id int)
BEGIN

	DECLARE stat BOOLEAN;  
    DECLARE user_type int;
    DECLARE nomii varchar(100);
    
    SELECT userType INTO user_type
    FROM usuario
    WHERE userID = id;
    
    SELECT nome INTO nomii
    FROM usuario
    WHERE userID = id;
    
    SELECT ativo INTO stat
    FROM usuario
    WHERE userID = id;
    
    -- verifica quem esta excluindo
    IF user_type = 0 THEN
		
        INSERT INTO log(mensagem) VALUES ("Impossivel deletar um administrador!");
    
    ELSE
		
        IF stat = FALSE THEN
			INSERT INTO log(mensagem) VALUES ("Usuario ja esta desativado!");
        ELSE
			UPDATE usuario
			SET ativo = false
			WHERE id = userID;
			
			INSERT INTO log(mensagem) VALUES (CONCAT(nomii, ' foi desativado com sucesso!'));
        END IF;
    END IF;
END
//

DELIMITER ;

-- DELETAR USUARIO -- 



-- DELETAR RECEITA --

DELIMITER //
CREATE PROCEDURE delete_recipe (id int)
BEGIN

	declare idd int;
    
    SELECT receitaID INTO idd
	FROM receita
	WHERE receitaID = id;
    
    if idd is null then
		INSERT INTO log(mensagem) VALUES ("Receita não encontrada!");
    else
		DELETE FROM receita where id = receitaID;
    end if;

	
END
//

DELIMITER ;

-- DELETAR RECEITA --