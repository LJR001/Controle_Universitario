CREATE DATABASE Universidade;

USE Universidade;
CREATE TABLE Aluno(
 RA int NOT NULL PRIMARY KEY,
 Nome varchar(50) NOT NULL,
 );

 SELECT * FROM Aluno;

 CREATE TABLE Disciplina(
	Sigla char(3) NOT NULL PRIMARY KEY,
	Nome varchar(20) NOT NULL,
	Carga_Horaria int NOT Null
	);

CREATE TABLE Matricula(
	
	RA int NOT NULL,
	Sigla char(3) NOT NULL,
	Data_Ano int NOT NULL PRIMARY KEY, 
	Data_Semestre int NOT NULL UNIQUE,
	Falta int,
	Nota_N1 float,
	Nota_N2 float,
	Nota_Sub float,
	Nota_Media float,
	Situacao  bit
	
	FOREIGN KEY (RA) REFERENCES Aluno(RA),
	FOREIGN KEY (SiglA) REFERENCES Disciplina(Sigla)
	);
 


 GO

--Crição do trigger que gera media e situação do aluno
 CREATE TRIGGER TG_Matricula
 ON dbo.Matricula 
 FOR UPDATE,INSERT 
	AS BEGIN
		  DECLARE @VN1 float
		  DECLARE @VN2 float
		  DECLARE @VFalta int
		  SELECT @VN1 = inserted.[Nota_N1] FROM inserted
		  SELECT @VN2 = inserted.[Nota_N2] FROM inserted
		  SELECT @VFalta = inserted.[Falta] FROM inserted

		   IF(@VN1 is not null AND @VN2 is not null AND  @VFalta is not null)
		BEGIN
		 
		  BEGIN
			DECLARE @Media  float
			DECLARE @RA INT 
			DECLARE @Sigla char(3)
			DECLARE @N1 float
			DECLARE @N2 float
			DECLARE @NSub float
			DECLARE @Ano int
			DECLARE @Falta int
			DECLARE @Semestre int
			DECLARE @CargaHoraria int
			SELECT @RA = inserted.[RA] FROM inserted
			SELECT @Sigla = inserted.[Sigla] FROM inserted
			SELECT @Ano = inserted.[Data_Ano] FROM inserted
			SELECT @Semestre = inserted.[Data_Semestre]FROM inserted
			SELECT @N1 = inserted.[Nota_N1] FROM inserted
			SELECT @N2 = inserted.[Nota_N2] FROM inserted
			SELECT @NSub = inserted.[Nota_Sub] FROM inserted
			SELECT @Falta = inserted.[Falta] FROM inserted

	   
			SELECT @CargaHoraria = Disciplina.[Carga_Horaria] FROM Disciplina inner join inserted ON Disciplina.Sigla = inserted.[Sigla];

			IF(@NSub is null or @NSub <@N1 AND @NSub < @N2)
			BEGIN
			 SELECT @Media = (@N1+@N2)/2 
			END
			ELSE IF (@NSub > @N1 AND  @N2 > @N1)
			BEGIN
				SELECT @Media = (@NSub+ @N2)/2
			END
			ELSE
			BEGIN
				SELECT @Media = (@NSub+@N1)/2
			END
			
				UPDATE dbo.Matricula SET Nota_Media = @Media WHERE Sigla = @Sigla and RA = @RA and Data_Ano = @Ano and Data_Semestre = @Semestre

		
		
						IF @Media < 5 OR @Falta > (@CargaHoraria * 0.25)
							BEGIN
								UPDATE dbo.Matricula SET Situacao = 0 WHERE Sigla = @Sigla and RA = @RA and Data_Ano = @Ano and Data_Semestre = @Semestre
								
							END
					   ELSE 
							BEGIN
								 UPDATE dbo.Matricula SET Situacao = 1 WHERE Sigla = @Sigla and RA = @RA and Data_Ano = @Ano and Data_Semestre = @Semestre

							END
		END
	END
END



DELETE FROM Matricula;

 --Matriculando aluno nas materias
 INSERT INTO Matricula (RA,Sigla,Data_Ano,Data_Semestre)
 VALUES (1,'CA1',2022,1),
		(1,'DW1',2022,1),
		(1,'ED1',2022,1),
		(1,'RC1',2022,1);

 INSERT INTO Matricula (RA,Sigla,Data_Ano,Data_Semestre)
 VALUES (2,'AL1',2021,1),
		(2,'ED1',2021,1),
		(2,'RC1',2021,1);

  INSERT INTO Matricula (RA,Sigla,Data_Ano,Data_Semestre)
 VALUES (3,'AL1',2021,1)

  INSERT INTO Matricula (RA,Sigla,Data_Ano,Data_Semestre)
 VALUES (4,'AL1',2021,1),
		(4,'CA1',2021,1),
		(4,'DW1',2021,1),
		(4,'ED1',2021,1),
		(4,'RC1',2021,1);

  INSERT INTO Matricula (RA,Sigla,Data_Ano,Data_Semestre)
 VALUES (5,'AL1',2021,1),
		(5,'CA1',2021,1),
		(5,'DW1',2021,1),
		(5,'ED1',2021,1),
		(5,'RC1',2021,1);


  INSERT INTO Matricula (RA,Sigla,Data_Ano,Data_Semestre)
 VALUES (6,'BD2',2021,2),
		(6,'ED2',2021,2),
		(6,'PO2',2021,2);

  INSERT INTO Matricula (RA,Sigla,Data_Ano,Data_Semestre)
 VALUES (7,'DW2',2021,2),
		(7,'ED2',2021,2),
		(7,'PO2',2021,2),
		(7,'TCC',2021,2);

  INSERT INTO Matricula (RA,Sigla,Data_Ano,Data_Semestre)
 VALUES (8,'PO2',2021,2),
		(8,'TCC',2021,2);
 
  INSERT INTO Matricula (RA,Sigla,Data_Ano,Data_Semestre)
 VALUES (9,'TCC',2021,2)

  INSERT INTO Matricula (RA,Sigla,Data_Ano,Data_Semestre)
 VALUES (10,'BD2',2021,2),
		(10,'TCC',2021,2);





--Inserção de notas e faltas

UPDATE Matricula SET  Falta = 15, Nota_N1 = 0, Nota_N2 =9,		Nota_Sub = 6		WHERE Sigla ='CA1' and RA=1 and Data_Ano = 2021 and Data_Semestre = 1 ;
UPDATE Matricula SET  Falta = 5, Nota_N1 = 8, Nota_N2 =9							WHERE Sigla ='DW1' and RA=1 and Data_Ano = 2021 and Data_Semestre = 1 ;
UPDATE Matricula SET  Falta = 7, Nota_N1 = 7, Nota_N2 =6							WHERE Sigla ='ED1' and RA=1 and Data_Ano = 2021 and Data_Semestre = 1 ;
UPDATE Matricula SET  Falta = 14, Nota_N1 = 2, Nota_N2 =3,		Nota_Sub = 6		WHERE Sigla ='RC1' and RA=1 and Data_Ano = 2021 and Data_Semestre = 1 ;

UPDATE Matricula SET  Falta = 29, Nota_N1 = 4, Nota_N2 =5,		Nota_Sub = 6		WHERE Sigla ='AL1' and RA=2 and Data_Ano = 2021 and Data_Semestre = 1 ;
UPDATE Matricula SET  Falta = 18, Nota_N1 = 3, Nota_N2 =2,		Nota_Sub = 9		WHERE Sigla ='ED1' and RA=2 and Data_Ano = 2021 and Data_Semestre = 1 ;
UPDATE Matricula SET  Falta = 32, Nota_N1 = 9, Nota_N2 =9							WHERE Sigla ='RC1' and RA=2 and Data_Ano = 2021 and Data_Semestre = 1 ;

UPDATE Matricula SET  Falta = 10, Nota_N1 = 9, Nota_N2 =9							WHERE Sigla ='AL1' and RA=3 and Data_Ano = 2021 and Data_Semestre = 1 ;

UPDATE Matricula SET  Falta = 5, Nota_N1 = 2, Nota_N2 =3,		Nota_Sub = 5		WHERE Sigla ='AL1' and RA=4 and Data_Ano = 2021 and Data_Semestre = 1 ;
UPDATE Matricula SET  Falta = 6, Nota_N1 = 4, Nota_N2 =5,		Nota_Sub = 6		WHERE Sigla ='CA1' and RA=4 and Data_Ano = 2021 and Data_Semestre = 1 ;
UPDATE Matricula SET  Falta = 13, Nota_N1 = 5, Nota_N2 =6							WHERE Sigla ='DW1' and RA=4 and Data_Ano = 2021 and Data_Semestre = 1 ;
UPDATE Matricula SET  Falta = 0, Nota_N1 = 1.5, Nota_N2 =3,		Nota_Sub = 6		WHERE Sigla ='ED1' and RA=4 and Data_Ano = 2021 and Data_Semestre = 1 ;
UPDATE Matricula SET  Falta = 4, Nota_N1 = 10, Nota_N2 =7							WHERE Sigla ='RC1' and RA=4 and Data_Ano = 2021 and Data_Semestre = 1 ;

UPDATE Matricula SET  Falta = 27, Nota_N1 = 6, Nota_N2 =2,		Nota_Sub = 6		WHERE Sigla ='AL1' and RA=5 and Data_Ano = 2021 and Data_Semestre = 1 ;
UPDATE Matricula SET  Falta = 8, Nota_N1 = 7, Nota_N2 =9							WHERE Sigla ='CA1' and RA=5 and Data_Ano = 2021 and Data_Semestre = 1 ;
UPDATE Matricula SET  Falta = 15, Nota_N1 = 2, Nota_N2 =4,		Nota_Sub = 5		WHERE Sigla ='DW1' and RA=5 and Data_Ano = 2021 and Data_Semestre = 1 ;
UPDATE Matricula SET  Falta = 9, Nota_N1 = 6, Nota_N2 =9							WHERE Sigla ='ED1' and RA=5 and Data_Ano = 2021 and Data_Semestre = 1 ;
UPDATE Matricula SET  Falta = 11, Nota_N1 = 10, Nota_N2 =4.5						WHERE Sigla ='RC1' and RA=5 and Data_Ano = 2021 and Data_Semestre = 1 ;

UPDATE Matricula SET  Falta = 11, Nota_N1 = 10, Nota_N2 =9							WHERE Sigla ='BD2' and RA=6 and Data_Ano = 2021 and Data_Semestre = 2 ;
UPDATE Matricula SET  Falta = 15, Nota_N1 = 5, Nota_N2 =9							WHERE Sigla ='ED2' and RA=6 and Data_Ano = 2021 and Data_Semestre = 2;
UPDATE Matricula SET  Falta = 13, Nota_N1 = 8, Nota_N2 =9							WHERE Sigla ='PO2' and RA=6 and Data_Ano = 2021 and Data_Semestre = 2;

UPDATE Matricula SET  Falta = 18, Nota_N1 = 9, Nota_N2 =9							WHERE Sigla ='DW2' and RA=7 and Data_Ano = 2021 and Data_Semestre = 2;
UPDATE Matricula SET  Falta = 10, Nota_N1 = 5, Nota_N2 =4,		 Nota_Sub = 6		WHERE Sigla ='ED2' and RA=7 and Data_Ano = 2021 and Data_Semestre = 2;
UPDATE Matricula SET  Falta = 5, Nota_N1 = 8, Nota_N2 =2							WHERE Sigla ='PO2' and RA=7 and Data_Ano = 2021 and Data_Semestre = 2;
UPDATE Matricula SET  Falta = 26, Nota_N1 = 3, Nota_N2 =3,		 Nota_Sub = 6		WHERE Sigla ='TCC' and RA=7 and Data_Ano = 2021 and Data_Semestre = 2;

UPDATE Matricula SET  Falta = 8, Nota_N1 = 8, Nota_N2 =3,		 Nota_Sub = 6		WHERE Sigla ='PO2' and RA=8 and Data_Ano = 2021 and Data_Semestre = 2;
UPDATE Matricula SET  Falta = 12, Nota_N1 = 2, Nota_N2 =8							WHERE Sigla ='TCC' and RA=8 and Data_Ano = 2021 and Data_Semestre = 2;

UPDATE Matricula SET  Falta = 3, Nota_N1 = 7.5, Nota_N2 =9							WHERE Sigla ='TCC' and RA=9 and Data_Ano = 2021 and Data_Semestre = 2;

UPDATE Matricula SET  Falta = 9, Nota_N1 = 5, Nota_N2 =9							WHERE Sigla ='BD2' and RA=10 and Data_Ano = 2021 and Data_Semestre = 2;
UPDATE Matricula SET  Falta = 1, Nota_N1 = 10, Nota_N2 =10							WHERE Sigla ='TCC' and RA=10 and Data_Ano = 2021 and Data_Semestre = 2;



--Consultar alunos da diciplina
SELECT Disciplina.Sigla, Disciplina.Nome, Aluno.RA, Aluno.Nome,Matricula.Data_Ano,Matricula.Nota_N1,Matricula.Nota_Sub,Matricula.Nota_Media,Matricula.Falta,Matricula.Situacao
FROM Aluno,Matricula, Disciplina
WHERE  Matricula.RA = Aluno.RA and Matricula.Sigla = Disciplina.Sigla and Disciplina.Sigla= 'AL1' and  Data_Ano = 2021 

--Consulta notas, faltas e situação de um aluno
SELECT Aluno.RA,Aluno.Nome,Matricula.Sigla,Matricula.Data_Ano,Matricula.Data_Semestre,Matricula.Nota_N1,Matricula.Nota_N2,Matricula.Nota_Sub,Matricula.Falta,Matricula.Situacao
FROM Aluno,Matricula
WHERE Matricula.RA = Aluno.RA and Aluno.Nome ='Luciano' and  Data_Ano = 2021 and Data_Semestre = 1

--Consultar média menor que 5 em 2021
SELECT Aluno.RA, Aluno.Nome, Matricula.Sigla,Matricula.Data_Ano,Matricula.Nota_N1,Matricula.Nota_Sub,Matricula.Nota_Media,Matricula.Situacao
FROM Aluno,Matricula
WHERE  Matricula.RA = Aluno.RA and Data_Ano = 2021 and Nota_Media < 5 





  

  

SELECT * FROM Matricula;


DELETE FROM Matricula;

  SELECT * FROM Matricula;


 SELECT * FROM Aluno;