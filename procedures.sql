use NutrifyHUb;

-- PROCEDURE DE ADICIONAR NUTRICIONISTA --

DELIMITER //
CREATE PROCEDURE add_nutri (nome varchar(100), email varchar(100), senha varchar(100), CRN VARCHAR(5), user_type int)
BEGIN
    DECLARE newUserID INT;
    
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

-- --------------------
Call add_nutri("nome", "email", "senha", "CRN", 0);
select * from nutri;
select * from usuario;
select * from log;
-- --------------------

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

-- --------------------
Call add_pacient("nome", "email", "senha", 1);
select * from pacient;
select * from usuario;
select * from log;
-- --------------------

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

-- --------------------
Call add_receita("Carne", 2);
select * from receita;
select * from usuario;
select * from log;
-- --------------------

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

-- --------------------
Call add_ing("ing", 1, "un", 8);
select * from ingredients;
select * from log;
-- --------------------

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


-- --------------------
Call add_step(1, "teste", 1);
select * from steps;
select * from log;
-- --------------------

 -- add step  --  
 
 
 
 --  NOVA DIETA --
 
 DELIMITER //
CREATE PROCEDURE add_dieta (creatorID int, pacientID int, calo int, prote int, carbo int, agua float)
BEGIN
    DECLARE id_criador INT;
    DECLARE id_pacient INT;
    
    -- Verifica se o criador existe
    SELECT nutriID INTO id_criador
    FROM nutri
    WHERE nutriID = creatorID;
    
    -- Verifica se o paciente existe
    SELECT pacienteID INTO id_pacient
    FROM pacient
    WHERE pacienteID = pacientID;
    
    IF id_criador IS NULL THEN
        INSERT INTO log (mensagem) VALUES ('O nutricionista não existe!');
    ELSE
    
        IF id_pacient IS NULL THEN
            INSERT INTO log (mensagem) VALUES ('O Paciente não existe!');
        ELSE
            INSERT INTO dieta (criadorID, pacienteID, calorias, proteinas, carboidratos, agua) 
            VALUES (creatorID, pacientID, calo, prote, carbo, agua);
        END IF;
    END IF;
END
// DELIMITER ;
 
 
-- --------------------
Call add_dieta(1, 1, 50, 40, 30, 2.5);
select * from dieta;
select * from log;
select * from nutri;
select * from pacient;
-- -------------------- 
 
--  NOVA DIETA --



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

-- --------------------
Call add_ReceitaDieta(3, 2, "Manhã");
select * from ReceitaDieta;
select * from log;
select * from dieta;
select * from receita;
select * from nutri;
select * from usuario;
-- -------------------- 

-- ADICIONAR RECEITA NA DIETA --