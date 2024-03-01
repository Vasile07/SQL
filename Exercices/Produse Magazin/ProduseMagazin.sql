create database DatabaseMagazine
use DatabaseMagazine
go

/**     1     **/
create table Locatii
(
	id_locatie int identity primary key,
	localitate varchar(100),
	strada varchar(100),
	numar int,
	cod_postal int
)

insert into Locatii(localitate, strada, numar, cod_postal) values
('Cluj-Napoca','Lalelor',12,14124),
('Cluj-Napoca','Unirii',14,251231),
('Giurgiu','Margaretelor',22,515324),
('Petrosani','Patrimoniului',14,24123)



create table Magazine
(
	id_magazin int identity primary key,
	denumire varchar(100),
	an_deschidere int,
	id_locatie int foreign key references Locatii(id_locatie)
)

insert into Magazine(denumire, an_deschidere, id_locatie) values
('La Paul',2021,3),
('Magazinul Aproape',2022,4),
('Magazinul Din Parcare',2020,1),
('La Avion',2019,2)



create table Clienti
(
	id_client int identity primary key,
	nume varchar(100),
	prenume varchar(100),
	gen varchar(100),
	data_nasterii date
)

insert into Clienti(nume, prenume, gen, data_nasterii) values
('Pop','Ion','male','2003-11-16'),
('Rus','George','male','2003-12-13'),
('Roman','Stefan','male','2002-11-14'),
('Aifrizer','Viktor','male','2005-12-12')



create table ProduseFavorite
(
	id_produsFavorit int identity primary key,
	denumire varchar(100),
	pret float,
	reducere int,
	id_client int foreign key references Clienti(id_client)
)

insert into ProduseFavorite(denumire, pret, reducere, id_client) values
('Paine',11.3,12,1),
('Zahar',12.54,11,1),
('Faina',33.12,22,2),
('Pudra',42.12,43,2),
('Piper',32.41,11,2),
('Sare',11.23,44,3),
('Patura',23.23,34,4),
('Floare',41.23,23,4)



create table MagazineClienti
(
	id_magazin int foreign key references Magazine(id_magazin),
	id_client int foreign key references Clienti(id_client),
	data_cumparaturii date,
	pret float,
	constraint pk_magazineClienti primary key (id_magazin, id_client)
)

insert into MagazineClienti(id_magazin,id_client, data_cumparaturii, pret) values
(1,1,'2023-12-24',12.55),
(1,3,'2023-11-28',33.62),
(2,2,'2023-10-19',14.41),
(2,3,'2023-09-29',25.12),
(3,3,'2023-10-10',16.23),
(3,4,'2023-09-11',18.44),
(4,1,'2023-11-12',11.42),
(4,4,'2023-12-23',22.44)


go
/**     2     **/

create or alter procedure AddOrModifyMagazineClienti(@id_magazin int, @id_client int, @data_cumparaturii date, @pret float) as
begin
	
	if exists (select * from MagazineClienti where id_client = @id_client and id_magazin = @id_magazin)
	begin
		update MagazineClienti
			set data_cumparaturii = @data_cumparaturii,
				pret = @pret
		where id_client = @id_client and id_magazin = @id_magazin

		print('Inregistrare modificata')
	end
	else
	begin
		insert into MagazineClienti(id_magazin, id_client, data_cumparaturii, pret)	values
			(@id_magazin, @id_client, @data_cumparaturii, @pret)

		print('Inregistrare adaugata')
	end

end

select * from MagazineClienti

exec AddOrModifyMagazineClienti 4,3,'2000-01-22',22.6


go
/**     3     **/

create or alter view vw_ClientiCuCelMult3ProduseFavorite as
	select C.nume + ' ' + C.prenume as 'Client', C.gen, C.data_nasterii 
	from Clienti C
	join ProduseFavorite PF on C.id_client = PF.id_client
	group by C.id_client, C.nume, C.prenume, C.gen, C.data_nasterii
	having count(PF.id_produsFavorit) <= 3
go

select  * from ProduseFavorite order by id_client
select * from vw_ClientiCuCelMult3ProduseFavorite
