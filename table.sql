create database NutrifyHub;
use nutrifyhub;

-- drop database nutrifyhub

CREATE TABLE usuario (
    userID INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    senha VARCHAR(100) NOT NULL,
    ativo BOOLEAN NOT NULL,
    userType INT NOT NULL
);


CREATE TABLE nutri (
    nutriID INT PRIMARY KEY AUTO_INCREMENT,
    CRN VARCHAR(15) NOT NULL,
    userID INT,
    FOREIGN KEY (userID) REFERENCES usuario(userID)
);


CREATE TABLE pacient (
    pacienteID INT PRIMARY KEY AUTO_INCREMENT,
    userID INT,
    nutriID INT,
    FOREIGN KEY (userID) REFERENCES usuario(userID),
    FOREIGN KEY (nutriID) REFERENCES nutri(nutriID)
);


CREATE TABLE receita (
    receitaID INT PRIMARY KEY AUTO_INCREMENT,
    criadorID INT,
    nome VARCHAR(100) NOT NULL,
    FOREIGN KEY (criadorID) REFERENCES usuario(userID)
);


CREATE TABLE ingredients (
    ingredientsID INT PRIMARY KEY AUTO_INCREMENT,
    receitaID INT NOT NULL,
    ingrediente VARCHAR(100) NOT NULL,
    qtd FLOAT NOT NULL,
    sistema_de_medida VARCHAR(5) NOT NULL,
    FOREIGN KEY (receitaID) REFERENCES receita(receitaID)
);


CREATE TABLE steps (
    stepsID INT PRIMARY KEY AUTO_INCREMENT,
    receitaID INT NOT NULL,
    step INT NOT NULL,
    descricao VARCHAR(255) NOT NULL,
    FOREIGN KEY (receitaID) REFERENCES receita(receitaID)
);


CREATE TABLE dieta (
    dietaID INT PRIMARY KEY AUTO_INCREMENT,
    criadorID INT NOT NULL,
    pacienteID INT NOT NULL,
    calorias INT NOT NULL,
    proteinas INT NOT NULL,
    carboidratos INT NOT NULL,
    agua FLOAT NOT NULL,
    FOREIGN KEY (pacienteID) REFERENCES usuario(userID),
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


CREATE TABLE log (
    logID INT PRIMARY KEY AUTO_INCREMENT,
    mensagem VARCHAR(255) NOT NULL
);

-- -------------------------------------------------

INSERT INTO usuario (nome, email, senha, ativo, userType) 
VALUES ('Joaquim Silva', 'joca.silva@email.com', '123', TRUE, 0);
