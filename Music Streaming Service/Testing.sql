-- Create table copy
USE MusicStreamingDatabase;
go

create table CpyArtisti(
	id_a int,
	nume varchar(200),
	email nvarchar(100),
	parola nvarchar(100),
	data_inscrierii date,
	constraint PK_CpyArtisi primary key (id_a)
)

create table CpyAlbume(
	id_ab int,
	nume nvarchar(100),
	data_lansare date,
	id_a int,
	constraint PK_CpyAlbume primary key (id_ab),
	constraint FK_Albume_Artisti foreign key (id_a) references CpyArtisti(id_a)
)

create table CpyPublicari(
	id int identity,
	id_a int,
	id_m int,
	constraint PK_CpyPublicari primary key (id),
	constraint FK_Publicari_Artisti foreign key (id_a) references CpyArtisti(id_a),
	constraint FK_Publicari_Melodii foreign key (id_m) references Melodii(id_m)
)

-- Procedura populare tabele test
go
create or alter procedure addDatasCopyTables as
begin
	insert into CpyArtisti
	select * from Artisti;

	insert into CpyAlbume
	select * from Albume;

	insert into CpyPublicari
	select * from Publicari
end


-- Creaza un view cu datele artistului
go
create or alter view vwArtisi as
	select * from CpyArtisti;

go
--select * from vwArtisi

-- Creaza un view cu Albumul si numele artistului 
go
create or alter view vwAlbumArtist as
	select Ab.id_ab,A.nume
	from CpyAlbume Ab
	join CpyArtisti A on A.id_a = Ab.id_a;

go
--select * from vwAlbumArtist

-- Creaza un view cu numarul de albume ale unui artist
go
create or alter view vwArtistiNrAlbume as
	select A.id_a,A.nume, count(*) as NrAlbume
	from CpyArtisti A
	join CpyAlbume Ab on Ab.id_a = A.id_a
	group by A.nume, A.id_a;

go
--select * from vwArtistiNrAlbume



--Proceduri adaugare
go
create or alter procedure testAddCpyArtisti as
begin
	declare @id int
	set @id = (select max(id_a) from CpyArtisti)
	if @id is NUll
		set  @id = 0
	set @id = @id + 1
	insert into CpyArtisti(id_a,nume,email, parola, data_inscrierii) values (@id,'NumeTest','test@gmail.com','0193019301','2002-12-17')
end

go
create or alter procedure testAddCpyAlbume as
begin
	declare @id int
	set @id = (select max(id_ab) from CpyAlbume)
	if @id is NUll
		set  @id = 0
	set @id = @id + 1
	insert into CpyAlbume(id_ab,nume, data_lansare, id_a) values(@id,'AlbumTest','2001-12-07',1)
end

go
create or alter procedure testAddCpyPublicari as
begin
	insert into CpyPublicari(id_a,id_m) values (1, 1)
end


--Proceduri stergere
go
create or alter procedure testDeleteFromCpyArtisti as
begin
	delete from CpyArtisti
end

go
create or alter procedure testDeleteFromCpyAlbume as
begin
	delete from CpyAlbume
end

go
create or alter procedure testDeleteFromCpyPublicari as
begin
	delete from CpyPublicari
end

-- Proceduri Rulare Views

go
create or alter procedure testViewvwArtisti as
begin
	select * from vwArtisi;
end

go
create or alter procedure testViewvwAlbumArtist as
begin
	select * from vwAlbumArtist
end

go
create or alter procedure testViewvwArtistiNrAlbume as
begin
	select * from vwArtistiNrAlbume
end


go
create or alter procedure TestProcedure @testID int as
begin
	--Adaugam datele existente in tabele si in copiile tabelelor
	--exec addDatasCopyTables;


	declare @ViewName nvarchar(50);
	declare @cmd nvarchar (1000);
	declare @tableName nvarchar(50);
	declare @NrRows int;
	declare @TableId int;
	declare @ViewId int;

	declare @TestRunID int;
	declare @globalStartDateTime datetime;
	declare @globalEndDateTime datetime;
	declare @startDateTime datetime;
	declare @endDateTime datetime;


	declare @description nvarchar(2000);
	
	-- Populare tabela TestRuns

	set @globalStartDateTime = getdate();
	
	set @description = (select Name from Tests where TestID = @testID);

	insert into TestRuns(Description, StartAt, EndAt) values (@description, @globalStartDateTime, null);
	
	set @TestRunID = (select max(TestRunID) from TestRuns)

	-- Test for DELETE

	declare cursorTestDelete cursor fast_forward for 
		select T.Name, TestT.NoOfRows, T.TableID
		from TestTables TestT
		join Tables T on T.TableID = TestT.TableID
		where TestT.TestID = @testID
		order by TestT.Position

	open cursorTestDelete;
	fetch next from cursorTestDelete into @tableName, @NrRows, @TableId;

	while @@FETCH_STATUS = 0
	begin
		set @cmd = 'exec testDeleteFrom' + @tableName;

		--set @startDateTime = GETDATE();

		exec sp_executesql @cmd;

		--set @endDateTime = GETDATE();

		--insert into TestRunTables(TestRunID, TableID, StartAt, EndAt) values (@TestRunID, @TableId, @startDateTime, @endDateTime);

		fetch next from cursorTestDelete into @tableName, @NrRows, @TableId;
	end

	close cursorTestDelete;
	deallocate cursorTestDelete;

	-- Test For ADD
	declare cursorTestAdd cursor fast_forward for
		select T.Name, TestT.NoOfRows, T.TableID
		from TestTables TestT
		join Tables T on T.TableID = TestT.TableID
		where TestT.TestID = @testID
		order by TestT.Position desc

	open cursorTestAdd;
	fetch next from cursorTestAdd into @tableName, @NrRows, @TableID

	while @@FETCH_STATUS = 0
	begin
		set @cmd = 'exec testAdd' + @tableName;

		set @startDateTime = GETDATE();

		while @NrRows > 0
		begin
			exec sp_executesql @cmd;
			set @NrRows = @NrRows - 1;
		end

		set @endDateTime = GETDATE();

		insert into TestRunTables(TestRunID, TableID, StartAt, EndAt) values (@TestRunID, @TableId, @startDateTime, @endDateTime);

		fetch next from cursorTestAdd into @tableName, @NrRows, @TableID;
	end

	close cursorTestAdd;
	deallocate cursorTestAdd;


	-- Test For VIEWS
	declare cursorTestViews cursor fast_forward for
		select V.Name, V.ViewID
		from TestViews TestV
		join Views V on V.ViewID = TestV.ViewID
		where TestV.TestID = @testID
		order by TestV.ViewID;

	open cursorTestViews;
	fetch next from cursorTestViews into @ViewName, @ViewID;
	
	while @@FETCH_STATUS = 0
	begin
		set @cmd = 'exec testView' + @ViewName;

		set @startDateTime = GETDATE();

		exec sp_executesql @cmd;

		set @endDateTime = GETDATE();

		insert into TestRunViews(TestRunID, ViewID, StartAt, EndAt) values (@TestRunID, @ViewId, @startDateTime, @endDateTime);

		fetch next from cursorTestViews into @ViewName, @ViewID;
	end
	close cursorTestViews
	deallocate cursorTestViews;




	set @globalEndDateTime = GETDATE();

	update TestRuns set EndAt = @globalEndDateTime where TestRunID = @TestRunID;

end

exec testDeleteFromCpyPublicari;
exec testDeleteFromCpyAlbume;
exec testDeleteFromCpyArtisti;

select * from Tests;

exec TestProcedure 1;


delete from TestRuns

select * from TestRuns
select * from TestRunTables
select * from TestRunViews