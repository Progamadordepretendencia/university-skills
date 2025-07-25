
USE universidade;

-- Criação da Tabela de Professores
CREATE TABLE `professores` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `nome` VARCHAR(255) NOT NULL,
    `email` VARCHAR(255) NOT NULL UNIQUE,
    `data_contratacao` DATE NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Criação da Tabela de Disciplinas
CREATE TABLE `disciplinas` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `codigo_disciplina` VARCHAR(20) NOT NULL UNIQUE,
    `nome` VARCHAR(255) NOT NULL,
    `carga_horaria` INT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Criação da Tabela de Relação de Aptidão
CREATE TABLE `professor_aptidao` (
    `professor_id` INT NOT NULL,
    `disciplina_id` INT NOT NULL,
    PRIMARY KEY (`professor_id`, `disciplina_id`),
    FOREIGN KEY (`professor_id`) REFERENCES `professores`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`disciplina_id`) REFERENCES `disciplinas`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Criação da Tabela de Histórico de Turmas
CREATE TABLE `turmas_ministradas` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `professor_id` INT,
    `disciplina_id` INT NOT NULL,
    `ano` INT NOT NULL,
    `semestre` INT NOT NULL COMMENT '1 para o primeiro semestre, 2 para o segundo',
    `numero_alunos` INT NOT NULL,
    `carga_horaria_efetiva` INT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`professor_id`) REFERENCES `professores`(`id`) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (`disciplina_id`) REFERENCES `disciplinas`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Inserção de Dados Iniciais (Seed Data)
INSERT INTO professores (nome, email, data_contratacao) VALUES
('Dr. Carlos Andrade', 'carlos.andrade@universidade.edu.br', '2015-03-10'),
('Dra. Beatriz Lima', 'beatriz.lima@universidade.edu.br', '2018-08-01'),
('Dr. Ricardo Souza', 'ricardo.souza@universidade.edu.br', '2020-02-20'),
('Dra. Juliana Ferreira', 'juliana.ferreira@universidade.edu.br', '2012-07-15'),
('Dr. Fernando Costa', 'fernando.costa@universidade.edu.br', '2021-01-18');

INSERT INTO disciplinas (codigo_disciplina, nome, carga_horaria) VALUES
('MAT01', 'Cálculo I', 90),
('FIS01', 'Física Básica', 60),
('COMP01', 'Algoritmos e Estrutura de Dados', 90),
('HUM01', 'Filosofia da Ciência', 45);
