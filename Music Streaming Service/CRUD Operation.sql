-- CONSTRANGERI PE TABELE

alter table Artisti
add constraint Not_Empty_Name check ( (nume is not null) and TRIM(nume) <> '' )

alter table Artisti
add constraint Password_Constraint check ((parola is not null) and parola like '%[0-9]%[0-9]%')

alter table Artisti
add constraint Email_Constraint check ((email is not null) and email like '_%@_%._%')

alter table Melodii
add constraint Not_Empty_Titlu check ((titlu is not null) and Trim(titlu) <> '')

go


-- FUNCTII DE VALIDARE
create or alter function ValideazaArtist(@nume varchar(200), @email varchar(100), @parola varchar(100), @data date)
returns varchar(200) as
begin
	declare @erori varchar(200)
	set @erori = ''
	if (@nume is null or trim(@nume) = '' )
		set @erori += 'Nume invalid!\n'
	if(@email is null or @email not like '_%@_%._%')
		set @erori += 'Email invalid!\n'
	if(@parola is null or @parola not like '%[0-9]%[0-9]%')
		set @erori += 'Parola invalida!\n'
	if(@data is null)
		set @erori += 'Data invalida!\n'

	return @erori
end
go

create or alter function ValideazaMelodie(@titlu varchar(100),@durata time(7),@gen varchar(100),@data_lansare date, @id_album int)
returns varchar(200) as
begin
	declare @erori varchar(200)
	set @erori = ''

	if(@titlu is null or trim(@titlu) ='')
		set @erori += 'Titlu invalid!\n'
	if(@durata is null)
		set @erori += 'Durata invalida!\n'
	if(@gen is null or trim(@gen) = '')
		set @erori += 'Gen invalid!\n'
	if(@data_lansare is null)
		set @erori += 'Data lansarii invalida!\n'
	if(@id_album is not null and not exists (select * from Albume where id_album = @id_album))
		set @erori += 'Album inexistent!\n'

	return @erori
end
go

create or alter function ValideazaPublicare(@id_artist int, @id_melodie int, @data date)
returns varchar(200) as
begin
	declare @erori varchar(200)
	set @erori = ''

	if(not exists (select * from Artisti where id_a = @id_artist))
		set @erori += 'Artist inexistent!\n'
	if(not exists (select * from Melodii where id_m  = @id_melodie))
		set @erori += 'Melodie inexistenta!\n'
	if(@data is null)
		set @erori += 'Data publicarii invalida!\n'

	return @erori
end
go

-- PROCEDURI OPERATII CRUD

-- ADD

create or alter procedure addArtist(@nume varchar(200), @email varchar(100),@parola varchar(100), @data_inscrierii date) as
begin
	declare @erori varchar(200)
	set @erori = dbo.ValideazaArtist(@nume, @email, @parola, @data_inscrierii)
	if( @erori = '' )
	begin
		insert into Artisti(nume, email, parola, data_inscrierii) values
		(@nume, @email, @parola, @data_inscrierii)
	end
	else
		raiserror(@erori, 16,1)
end
go

create or alter procedure addMelodie(@titlu varchar(100),@durata time(7), @gen varchar(100), @data_lansarii date, @id_album int) as
begin
	declare @erori varchar(200)
	set @erori = dbo.ValideazaMelodie(@titlu, @durata, @gen, @data_lansarii, @id_album)
	if ( @erori = '' )
	begin
		insert into Melodii(titlu, durata, gen, data_lansare, id_album) values
		(@titlu, @durata, @gen,@data_lansarii, @id_album)
	end
	else
		raiserror(@erori,16,1)
end
go

create or alter procedure addPublicare(@id_artist int , @id_melodie int, @dataPublicarii date) as
begin
	declare @erori varchar(200)
	set @erori = dbo.ValideazaPublicare(@id_artist, @id_melodie, @dataPublicarii)
	if ( @erori = '' )
	begin
		insert into Publicari(id_a, id_m,dataPublicarii) values
		(@id_artist, @id_melodie, @dataPublicarii)
	end
	else
		raiserror(@erori, 16, 1)
end
go

-- DELETE
create or alter procedure deleteByIdArtist(@id_artist int) as
begin
	delete from Artisti
	where id_a = @id_artist
	if @@ROWCOUNT = 0
		raiserror('Artist inexistent!\n',16,1)
end
go

create or alter procedure deleteByIdMelodie(@id_melodie int) as
begin
	delete from Melodii
	where id_m = @id_melodie
	if @@ROWCOUNT = 0
		raiserror('Melodie inexistenta!\n',16,1)
end
go

create or alter procedure deleteByIdPublicare(@id_artist int, @id_melodie int) as
begin
	delete from Publicari
	where id_a = @id_artist and id_m = @id_melodie
	if @@ROWCOUNT = 0
		raiserror('Publicare inexistenta!\n',16,1)
end
go

-- UPDATE
create or alter procedure updateArtist(@id_artist int,@nume varchar(200), @email varchar(100),@parola varchar(100), @data_inscrierii date) as
begin
	declare @erori varchar(200)
	set @erori = dbo.ValideazaArtist(@nume, @email, @parola, @data_inscrierii)
	if( @erori = '' )
	begin
		update Artisti
			set nume = @nume,
				email = @email,
				parola = @parola,
				data_inscrierii = @data_inscrierii
		where id_a = @id_artist
		if ( @@ROWCOUNT = 0 )
			raiserror('Artist inexistent!\n',16,1)
	end
	else
		raiserror(@erori, 16,1)
end
go

create or alter procedure updateMelodie(@id_melodie int,@titlu varchar(100),@durata time(7), @gen varchar(100), @data_lansarii date, @id_album int) as
begin
	declare @erori varchar(200)
	set @erori = dbo.ValideazaMelodie(@titlu, @durata, @gen, @data_lansarii, @id_album)
	if ( @erori = '' )
	begin
		update Melodii
			set titlu = @titlu,
				durata = @durata,
				gen = @gen,
				data_lansare = @data_lansarii,
				id_album = @id_album
		where id_m = @id_melodie
		if ( @@ROWCOUNT = 0 )
			raiserror('Melodie inexistenta!\n',16,1)
	end
	else
		raiserror(@erori,16,1)
end
go

create or alter procedure updatePublicare(@id_artist int , @id_melodie int, @dataPublicarii date) as
begin
	declare @erori varchar(200)
	set @erori = dbo.ValideazaPublicare(@id_artist, @id_melodie, @dataPublicarii)
	if ( @erori = '' )
	begin
		update Publicari
			set dataPublicarii = @dataPublicarii
		where id_a = @id_artist and id_m = @id_melodie
		if ( @@ROWCOUNT = 0 )
			raiserror('Publicare inexistenta!\n',16,1)
	end
	else
		raiserror(@erori, 16, 1)
end
go


-- GET ALL
create or alter procedure getAllArtisti as
begin
	select * from Artisti
end
go

create or alter procedure getAllMelodii as
begin
	select * from Melodii
end
go

create or alter procedure getAllPublicari as
begin
	select * from Publicari
end
go

-- CREARE VIEW-URI
create or alter view vwNumarMelodiiPerArtistiLunaDecembrie as
	select A.nume, COUNT(P.id_m) as NumarMelodii
	from Artisti A
	join Publicari P on P.id_a = A.id_a
	where MONTH(P.dataPublicarii) = 12
	group by A.nume
go

create or alter view vwArtistiiDePop as
	select A.nume, A.email
	from Artisti A
	join Publicari P on P.id_a = A.id_a
	join Melodii M on M.id_m = P.id_m
	where M.gen = 'pop'
go

-- CREARE INDECSI

create index index_NumeArtist on Artisti
( nume ASC )

create index index_GenMelodii on Melodii
( gen ASC )


exec getAllMelodii
exec getAllArtisti
exec getAllPublicari



exec deleteByIdPublicare 2, 12


select * from vwNumarMelodiiPerArtistiLunaDecembrie
select * from vwArtistiiDePop