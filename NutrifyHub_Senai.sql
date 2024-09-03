create database NutrifyHub;

CREATE TABLE usuario (
    userID INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    senha VARCHAR(100) NOT NULL,
    ativo BOOLEAN NOT NULL,
    userType INT NOT NULL
);


CREATE TABLE adm (
    admID INT PRIMARY KEY AUTO_INCREMENT,
    id_user INT NOT NULL,
    FOREIGN KEY (id_user) REFERENCES usuario(userID)
);


CREATE TABLE nutri (
    nutriID INT PRIMARY KEY AUTO_INCREMENT,
    CRN INT NOT NULL,
    id_user INT NOT NULL,
    id_adm INT NOT NULL,
    FOREIGN KEY (id_user) REFERENCES usuario(userID),
    FOREIGN KEY (id_adm) REFERENCES adm(admID)
);


CREATE TABLE pacient (
    pacientID INT PRIMARY KEY AUTO_INCREMENT,
    ofensiva INT NOT NULL,
    id_user INT NOT NULL,
    id_nutri INT NOT NULL,
    FOREIGN KEY (id_user) REFERENCES usuario(userID),
    FOREIGN KEY (id_nutri) REFERENCES nutri(nutriID)
);


CREATE TABLE receita (
    receitaID INT PRIMARY KEY AUTO_INCREMENT,
    criadorID INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    FOREIGN KEY (criadorID) REFERENCES usuario(userID),
    FOREIGN KEY (id_pacient) REFERENCES pacient(pacientID)
);


CREATE TABLE ingredients (
    ingredientsID INT PRIMARY KEY AUTO_INCREMENT,
    id_receita INT NOT NULL,
    ingrediente VARCHAR(100) NOT NULL,
    qtd FLOAT NOT NULL,
    FOREIGN KEY (id_receita) REFERENCES receita(receitaID)
);


CREATE TABLE steps (
    stepsID INT PRIMARY KEY AUTO_INCREMENT,
    id_receita INT NOT NULL,
    step INT NOT NULL,
    descricao VARCHAR(255) NOT NULL,
    FOREIGN KEY (id_receita) REFERENCES receita(receitaID)
);


CREATE TABLE dieta (
    dietaID INT PRIMARY KEY AUTO_INCREMENT,
    criadorID INT NOT NULL,
    id_pacient INT NOT NULL,
    calorias INT NOT NULL,
    proteinas INT NOT NULL,
    carboidratos INT NOT NULL,
    agua FLOAT NOT NULL,
    ativo BIT NOT NULL,
    FOREIGN KEY (id_pacient) REFERENCES pacient(pacientID),
    FOREIGN KEY (criadorID) REFERENCES usuario(userID)
);


CREATE TABLE ReceitaDieta (
    ReceitaDietaID INT PRIMARY KEY AUTO_INCREMENT,
    id_receita INT NOT NULL,
    id_dieta INT NOT NULL,
    periodo VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_receita) REFERENCES receita(receitaID),
    FOREIGN KEY (id_dieta) REFERENCES dieta(dietaID)
);

DELIMITER //
CREATE PROCEDURE add_nutri (nome varchar(100), email varchar(100), senha varchar(100), CRN int, adm int)
BEGIN

DECLARE newUserID INT;

INSERT INTO usuario VALUES
(DEFAULT, nome, email, senha, true, 2);

SET newUserID = new.userID;

INSERT INTO nutri VALUES
(DEFAULT, CRN, newUserID, adm);
END
// DELIMITER ;



