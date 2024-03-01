create database GestiuneaGarajelor

use GestiuneaGarajelor
go


/**   1   **/

create table Tipuri
(
	id_tip int identity primary key,
	tip varchar(100),
	descriere varchar(100)
)

insert into Tipuri(tip, descriere) values
('Masini','Perfect pentru depozitarea masinii'),
('Unelte','Perfect pentru a va putea organiza uneltele pe care le detineti'),
('Mare','Foarte incapator pentru a va depozita lucrurile')


create table Garaje
(
	id_garaj int identity primary key,
	denumire varchar(100),
	strada varchar(100),
	numar int,
	localitate varchar(100),
	id_tip int foreign key references Tipuri(id_tip)
)

insert into Garaje(denumire, strada, numar, localitate, id_tip) values
('Garaj 1','Strada 12',12,'Cluj-Napoca',1),
('Garaj 2','Strada 11',22,'Arad',1),
('Garaj 3','Strada Principala',14,'Pitesti',2),
('Garaj 4','Strada 22',44,'Cluj-Napoca',2),
('Garaj 5','Strada 14',51,'Pitesti',3)


create table Clienti
(
	id_client int identity primary key,
	nume varchar(100),
	prenume varchar(100),
	gen varchar(100),
	vechime int 
)

insert into Clienti(prenume, nume, gen,vechime) values
('Ionut','Pop','male',12),
('Paula','Pop','female',5),
('George','Rus','male',11),
('Stefan','Roman','male',7),
('Aurelia','Marcela','female',22),
('Tudor','Saratel','male',4)


create table Unelte
(
	id_unealta int identity primary key,
	denumire varchar(100),
	pret float,
	cantitate int,
	id_client int foreign key references Clienti(id_client)
)

insert into Unelte(denumire, pret, cantitate, id_client) values
('Ciocan',12.5,3,1),
('Matura',22.4,2,1),
('Foarfeca',11.2,4,2),
('Drujba',22.3,1,2),
('Aspirator',41.3,5,3),
('Flex',11.2,2,4),
('Surubelnita',22.2,3,5),
('Lanterna',23.1,1,6)



create table ClientiGaraje
(
	id_client int foreign key references Clienti(id_client),
	id_garaj int foreign key references Garaje(id_garaj),
	data_activitatii date,
	beneficiul varchar(100),
	constraint pk_ClientiGaraje primary key (id_client, id_garaj)
)


insert into ClientiGaraje(id_client, id_garaj, data_activitatii, beneficiul) values
(1,2,'2023-12-12','Depozitare Masina'),
(1,1,'2023-08-14','Depozitare Masina'),
(2,1,'2023-07-11','Depozitare Masina'),
(2,3,'2023-12-13','Depozitare Unelte'),
(2,5,'2023-11-12','Depozitare Mobilier'),
(3,1,'2023-07-15','Depozitare Masina'),
(4,2,'2023-09-18','Depozitare Masina'),
(4,4,'2023-10-21','Depozitare Unelte'),
(5,1,'2023-10-23','Depozitare Masina'),
(5,2,'2023-09-29','Depozitare Masina'),
(6,3,'2023-12-22','Depozitare Unelte'),
(6,4,'2023-11-11','Depozitare Unelte'),
(6,5,'2023-11-12','Depozitare Mobilier')

go


/**   2    **/

create or alter procedure AddOrModifyClientiGaraje(@id_client int, @id_garaj int, @data_activitatii date, @beneficiu varchar(100)) as
begin
	if exists (select * from ClientiGaraje where id_client = @id_client and id_garaj = @id_garaj)
	begin
		update ClientiGaraje
			set data_activitatii = @data_activitatii,
				beneficiul = @beneficiu
			where id_client = @id_client and id_garaj = @id_garaj
	end
		else
		begin
			insert into ClientiGaraje(id_client, id_garaj,data_activitatii,beneficiul) values
				(@id_client, @id_garaj, @data_activitatii, @beneficiu)
		end
end

select * from ClientiGaraje;
exec AddOrModifyClientiGaraje 1,3,'2024-11-21','Altceva'

go

/**   3   **/

create or alter function GetAllClientiActivitatiInNGaraje(@n int) returns table as
	return	select C.nume + ' ' + C.prenume as Client, C.gen, C.vechime, count(CG.id_garaj) as 'Numar de garaje inchiriate'
			from Clienti C
			join ClientiGaraje CG on CG.id_client = C.id_client
			group by C.nume, C.prenume, C.gen, C.vechime, C.id_client
			having count(CG.id_garaj) >= @n;
go

select * from dbo.GetAllClientiActivitatiInNGaraje(2)