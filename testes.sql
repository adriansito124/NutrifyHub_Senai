-- PROCEDURE DE ADICIONAR NUTRICIONISTA --
Call add_nutri("nome", "email", "senha", "CRN", 1);
select * from nutri;
select * from usuario;
select * from log;
-- PROCEDURE DE ADICIONAR NUTRICIONISTA --


-- PROCEDURE DE CRIAR NOVO PACIENTE --
Call add_pacient("nome", "email", "senha", 1);
select * from pacient;
select * from usuario;
select * from log;
-- PROCEDURE DE CRIAR NOVO PACIENTE --


-- PROCEDURE DE ADICIONAR RECEITA --
Call add_receita("Carne", 2);
select * from receita;
select * from log;
-- PROCEDURE DE ADICIONAR RECEITA --


-- PROCEDURE DE ADICIONAR INGREDIENTE --
Call add_ing("ingrediente", 1, "un", 1);
select * from ingredients;
select * from log;
-- PROCEDURE DE ADICIONAR INGREDIENTE --


 -- add step  --  
Call add_step(1, "Comer", 1);
select * from steps;
select * from log;
 -- add step  --  


--  NOVA DIETA --
Call add_dieta(2, 3, 50, 40, 30, 2.5);
select * from dieta;
select * from log;
--  NOVA DIETA --
 
 
-- ADICIONAR RECEITA NA DIETA --
Call add_ReceitaDieta(1, 1, "Manhã");
select * from ReceitaDieta;
select * from log;
-- ADICIONAR RECEITA NA DIETA --


-- DELETAR USUARIO -- 
call delete_user(3);
select * from usuario;
select * from log;
-- DELETAR USUARIO -- 


-- DELETAR RECEITA --
call delete_recipe(1);
select * from receita;
select * from ingredients;
select * from steps;
select * from ReceitaDieta;
select * from log;
-- DELETAR RECEITA --