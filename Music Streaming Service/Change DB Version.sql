USE MusicStreamingDatabase;

-- PROCEDURA DE MODIFICARE TIP COLOANA
GO
CREATE PROCEDURE DoModificaTipColoana
AS
BEGIN
alter table Artisti
alter column nume VARCHAR(200)
END;

GO
CREATE PROCEDURE UndoModificaTipColoana
AS
BEGIN
alter table Artisti
alter column nume NVARCHAR(100)
END;

-- ADAUGA CONSTRANGERE VALOARE DEFAUL

GO
CREATE PROCEDURE DoAdaugaValoareImplicita
AS
BEGIN
alter table Melodii
add constraint df_data_lansare DEFAULT GETDATE()for data_lansare
END;

GO 
CREATE PROCEDURE UndoAdaugaValoareImplicita
AS
BEGIN
alter table Melodii
drop constraint df_data_lansare
END;

-- Creare Tabela
GO
CREATE PROCEDURE DoCreareTabela
AS
BEGIN
create table Sponsori(id BIGINT, nume NVARCHAR(100),suma BIGINT);
END

GO
CREATE PROCEDURE UndoCreareTAbela
AS
BEGIN
drop table Sponsori;
END;

-- Adauga Camp Nou
GO
CREATE PROCEDURE DoAdaugaCampNou
AS
BEGIN
alter table Melodii
add id_album int
END;

GO
CREATE PROCEDURE UndoAdaugaCampNou
AS
BEGIN
alter table Melodii
drop column id_album
END;

-- CREARE CONSTRANGERE FK
GO
CREATE or ALTER PROCEDURE DoCreareConstrangereFK
AS
BEGIN
alter table Melodii
add constraint FK_Melodii_Albume foreign key (id_album) references Albume (id_album) ON DELETE CASCADE ON UPDATE CASCADE
END;

GO
CREATE PROCEDURE UndoCreareConstrangereFK
AS
BEGIN
alter table Melodii
drop constraint FK_Melodii_Albume
END;


-- Creare tabela cu Versiunea data
CREATE TABLE Versiune(numar_versiune int);
insert into Versiune Values (0);

-- Returneaza procedurea curenta
GO
CREATE PROCEDURE ReturneazaVersiuneaCurenta @versiune_curenta int output
AS
BEGIN
set @versiune_curenta = (select numar_versiune from Versiune)
END

--declare @v as int
--EXEC ReturneazaVersiuneaCurenta @versiune_curenta = @v output;
--print 'Versiune: ';
--print @v;

--Procedura returneaza numele procedurii ce trebuie aplicata pentru a se realiza transformarea
GO
CREATE PROCEDURE GetTranformationProcedure @versiune1 int, @versiune2 int, @procedura varchar(100) output
AS
BEGIN
DECLARE @gasit as int
SET @gasit = 0
IF(@versiune1 = 0 and @versiune2 = 1)
	set @procedura = 'DoModificaTipColoana'
	set @gasit = 1
IF(@versiune1 = 1 and @versiune2 = 0)
	set @procedura = 'UndoModificaTipColoana'
	set @gasit = 1
IF(@versiune1 = 1 and @versiune2 = 2)
	set @procedura = 'DoAdaugaValoareImplicita'
	set @gasit = 1
IF(@versiune1 = 2 and @versiune2 = 1)
	set @procedura = 'UndoAdaugaValoareImplicita'
	set @gasit = 1
IF(@versiune1 = 2 and @versiune2 = 3)
	set @procedura = 'DoCreareTabela'
	set @gasit = 1
IF(@versiune1 = 3 and @versiune2 = 2)
	set @procedura = 'UndoCreareTabela'
	set @gasit = 1
IF(@versiune1 = 3 and @versiune2 = 4)
	set @procedura = 'DoAdaugaCampNou'
	set @gasit = 1
IF(@versiune1 = 4 and @versiune2 = 3)
	set @procedura = 'UndoAdaugaCampNou'
	set @gasit = 1
IF(@versiune1 = 4 and @versiune2 = 5)
	set @procedura = 'DoCreareConstrangereFK'
	set @gasit = 1
IF(@versiune1 = 5 and @versiune2 = 4)
	set @procedura = 'UndoCreareConstrangereFK'
	set @gasit = 1
IF(@gasit = 0)
	raiserror('Versiunea data e invalida!',16,1)
END;


GO
CREATE Or Alter PROCEDURE TransformaInVersiuneaData @versiunea_data int
AS
BEGIN

	declare @versiune_curenta as int
	EXEC ReturneazaVersiuneaCurenta @versiune_curenta output;

	if ( @versiunea_data < 0 or @versiunea_data > 5)
		raiserror('Versiunea data e invalida!',16,1)
	else
	begin
		declare @pas as int
		if ( @versiune_curenta < @versiunea_data)
			set @pas = 1
		else
			set @pas = -1
				
		while ( @versiune_curenta != @versiunea_data )
		begin
			declare @versiunea_urmatoare as int;
			set @versiunea_urmatoare = @versiune_curenta + @pas;
			declare @proc as varchar(100);
			EXEC GetTranformationProcedure @versiune_curenta, @versiunea_urmatoare,@proc output;
			EXEC @proc;
			set @versiune_curenta = @versiunea_urmatoare
			update Versiune set numar_versiune = @versiune_curenta
		end
	end

	
END;

select * from Versiune;

exec TransformaInVersiuneaData -10;