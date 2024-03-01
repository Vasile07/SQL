create database GestiuneaCaselor
use  GestiuneaCaselor
go

/**   1   **/

create table Proprietari
(
	id_proprietar int identity primary key,
	nume varchar(100),
	prenume varchar(100),
	gen varchar(100),
	functie varchar(100)
)

insert into Proprietari(prenume,nume, gen, functie) values
('Ionut','Pop','male','functie 1'),
('Paula','Pop','female','functie 2'),
('Marcel','Avram','male','functie 3'),
('Ionela','Pop','female','functie 5'),
('George','Rus','male','functie 7')


create table Chiriasi
(
	id_chirias int identity primary key,
	nume varchar(100),
	prenume varchar(100),
	gen varchar(100),
	data_nastere date,
	id_proprietar int foreign key references Proprietari(id_proprietar)
)

insert into Chiriasi(nume, prenume, gen, data_nastere, id_proprietar) values
('Roman','Stefan','male','2005-12-11',4),
('Airizer','Viktor','male','2003-12-22',5),
('Saratel','Tudor','male','2002-11-12',5),
('Carla','Pop','female','2003-12-11',1)


create table Houses
(
	id_casa int identity primary key,
	strada varchar(100),
	numar int,
	localitate varchar(100),
	cod_postal varchar(100),
	id_proprietar int foreign key references Proprietari(id_proprietar)
)

insert into Houses(strada, numar, localitate, cod_postal, id_proprietar) values
('Strada 1',12,'Cluj-Napoca','1234a',1),
('Strada 123',14,'Arad','131a4',4),
('Strada 14',51,'Cluj-Napoca','1321asd',5),
('Strada 22',14,'Pitesti','5151as4',5)



create table Mobiliere
(
	id_mobilier int identity primary key,
	denumire varchar(100),
	descriere varchar(100),
	cantitate int,
	pret float
)

insert into Mobiliere(denumire, descriere,cantitate, pret) values
('Scaun','12h12L15l',4,12.5),
('Comoda','14h11L12l',15,11.2),
('Pat','11h63L15l',22,22.5),
('Saltea','15h14L17l',11,12.5),
('Candelabru','12h12L11l',5,41.2),
('Dulap','15h11L19l',8,513.2)



create table MobiliereHouses
(
	id_casa int foreign key references Houses(id_casa),
	id_mobilier int foreign key references Mobiliere(id_mobilier),
	data_achizitionarii date,
	data_livrarii date,
	constraint pk_MobiliereHouses primary key (id_casa, id_mobilier)
)

insert into MobiliereHouses(id_casa, id_mobilier, data_achizitionarii, data_livrarii) values
(1,1,'2023-12-13','2023-12-15'),
(1,3,'2023-11-15','2023-11-17'),
(2,4,'2023-10-11','2023-10-13'),
(2,2,'2023-09-12','2023-09-14'),
(2,5,'2023-09-15','2023-09-17'),
(2,1,'2023-12-12','2023-12-14'),
(3,2,'2023-11-13','2023-11-15'),
(3,4,'2023-11-14','2023-11-16'),
(3,5,'2023-12-17','2023-12-19'),
(4,2,'2023-09-18','2023-09-20'),
(4,4,'2023-10-12','2023-10-14'),
(4,1,'2023-10-15','2023-10-17'),
(4,5,'2023-09-19','2023-09-21')
go

/**   2   **/

create or alter procedure AddOrModifyMobiliereHouses(@id_casa int, @id_mobilier int, @data_achizitionare date, @data_livrare date) as
begin
	if exists (select * from MobiliereHouses where id_casa = @id_casa and id_mobilier = @id_mobilier)
	begin
		update MobiliereHouses
			set data_achizitionarii = @data_achizitionare,
				data_livrarii = @data_livrare
			where id_casa = @id_casa and id_mobilier = @id_mobilier
	end
		else
		begin
			insert into MobiliereHouses(id_casa, id_mobilier, data_achizitionarii, data_livrarii) values
				(@id_casa, @id_mobilier, @data_achizitionare, @data_livrare)
		end
end

select * from MobiliereHouses
exec AddOrModifyMobiliereHouses 1,5,'2023-01-19','2023-01-29'
go

/**   3   **/

create or alter view PieseMobilierGasiteMaiPutinDeTrei as
	select M.denumire, M.descriere, M.cantitate, M.pret, count(MH.id_casa) as 'Numar gasiri'
	from Mobiliere M
	join MobiliereHouses MH on MH.id_mobilier = M.id_mobilier
	group by  M.denumire, M.descriere, M.cantitate, M.pret, M.id_mobilier
	having count(MH.id_casa) <= 3

go

select * from PieseMobilierGasiteMaiPutinDeTrei