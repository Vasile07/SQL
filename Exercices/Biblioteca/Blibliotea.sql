create database Biblioteca
go
use Biblioteca

/* 1 */

create table Librarii
(
	id int identity primary key,
	nume varchar(100),
	adresa varchar(100)
);

create table Domenii
(
	id int identity primary key,
	descriere varchar(100)
);

create table Carti
(
	id int identity primary key,
	titlu varchar(100),
	idDomeniu int foreign key references Domenii(id),
);

create table Achizitii
(
	id int identity primary key,
	idCarte int foreign key references Carti(id),
	idLibrarie int foreign key references Librarii(id),
	dataAchizitie date
);

create table Autori
(
	id int identity primary key,
	nume varchar(100),
	prenume varchar(100)
);

create table Publicari
(
	id int identity primary key,
	idCarte int foreign key references Carti(id),
	idAutor int foreign key references Autori(id)
);

go

/* Populare cu date */
go

insert into Librarii(nume, adresa) values
('Libraria 1','Cluj Strada 1'),
('Libraria 2','Cluj Strada 4'),
('Libraria 3','Iasi Strada 14'),
('Libraria 4','Bucuresti Strada Constanta'),
('Libraria 5', 'Petrosani Strada Unirii')

insert into Domenii(descriere) values  
('Literatura'),
('Psihologie'),
('Stiinta'),
('Sport'),
('Nutritie')

select * from Domenii

insert into Carti(titlu, idDomeniu) values
('Cartea 1',1),
('Cartea 2',2),
('Cartea 3',3),
('Cartea 4',1),
('Cartea 5',5),
('Cartea 6',4),
('Cartea 7',2),
('Cartea 8',5)

insert into Autori(nume, prenume) values
('Ion','Stanica'),
('Paul','Mitrut'),
('Petru','Oana'),
('Anghelescu','Dumitru'),
('Angelescu','Paula'),
('Pop','Ioana'),
('Rus','George'),
('Airizer','Viktor')

select * from Librarii;
select * from Carti;
select * from Achizitii
insert into Achizitii(idLibrarie, idCarte,dataAchizitie) values
(1,2,'2021-05-22'),
(1,4,'2022-02-21'),
(1,5,'2011-01-12'),
(1,7,'2010-06-25'),
(1,8,'2009-07-23'),
(2,1,'2007-02-22'),
(2,3,'2006-08-19'),
(2,4,'2023-02-10'),
(3,5,'2022-04-19'),
(3,2,'2021-05-15'),
(3,8,'2003-01-11'),
(3,7,'2005-02-02'),
(4,3,'2020-09-17'),
(4,2,'2013-10-22'),
(4,5,'2014-11-14'),
(5,1,'2009-04-11'),
(5,2,'2011-05-13')

insert into Publicari(idCarte, idAutor) values
(1,3),
(1,5),
(1,8),
(2,4),
(2,7),
(3,6),
(3,8),
(4,5),
(5,6),
(5,7),
(6,3),
(6,4),
(7,2),
(7,5),
(7,8),
(8,1),
(8,4)
go
/* 2 */


create or alter procedure PublicareCarte(@numeAutor varchar(100), @prenumeAutor varchar(100), @idCarte int) as
begin
	declare @idAutor int;
	set @idAutor = (select id from Autori where nume = @numeAutor and prenume = @prenumeAutor);

	if ( @idAutor is NULL )
	begin
		insert into Autori(nume,prenume) values (@numeAutor, @prenumeAutor);
		set @idAutor = @@IDENTITY;
	end

	if not exists (select * from Publicari where idCarte = @idCarte and idAutor = @idAutor)
	begin
		insert into Publicari(idCarte,idAutor) values (@idCarte, @idAutor)
	end
		else
		begin
			print('Cartea a fost deja asociata acestui autor!\n');
		end
end
go

/* 3 */

create or alter view NumarCartiPerLibrarieView as
	select L.nume as Librarie, count(A.idCarte) as 'Numar Carti'
	from Librarii L
	join Achizitii A on L.id = A.idLibrarie
	where YEAR(A.dataAchizitie) >= 2010
	group by L.nume, L.id
go

select * from NumarCartiPerLibrarieView
go

/* 4 */

create or alter function AfiseazaListCarti(@nrAutori int) returns table as
	return	select C.titlu as titlu, count(A.id) as 'nrAutori'
			from Carti C
			join Publicari P on P.idCarte = C.id
			join Autori A on A.id = P.idAutor
			group by C.titlu, C.id
			having count(A.id) >= @nrAutori;
go
