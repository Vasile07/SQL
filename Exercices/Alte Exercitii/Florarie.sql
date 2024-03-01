create database MgazinDeFlori
use MgazinDeFlori

/*    1    */
create table CategoriiDeAranjamenteFlorare
(
	id_categorie int identity primary key,
	denumire varchar(100)
)

insert into CategoriiDeAranjamenteFlorare(denumire) values
('Botez'),('Nunta'),('Zi de nastere')



create table Florarii
(
	id_florarie int identity primary key,
	nume varchar(100),
	telefon varchar(10),
	adresa varchar(100)
)

insert into Florarii(nume, telefon, adresa) values
('Floraria Margareta','0781232332','Aleea Centrala 14'),
('Floraria Cala','0792182781','Strada Roz 123'),
('Floraria Maria','0726182931','Strada Horea 4')



create table AranjamenteFlorale
(
	id_aranjament int identity primary key,
	nume varchar(100),
	pret float,
	descriere varchar(100),
	inaltime int,
	id_categorie int foreign key references CategoriiDeAranjamenteFlorare(id_categorie),
	id_florarie int foreign key references Florarii(id_florarie)
)

insert into AranjamenteFlorale(nume, pret, descriere, inaltime, id_categorie, id_florarie) values
('Buchet de orhidee',45.62,'Orhidee de diferite culori',5,1,2),
('Trandafiri Rosii',33.81,'Perfect pentru persoanele care indragesc trandafiri',3,1,3),
('Vaza ornata',62.77,'Vaza cu flori la alegere',2,1,1),
('Buchet de primavara',21.25,'Toate florile speciale de primavara',5,2,2),
('Buchet de vara',32.32,'Toate florile speciale de vara',1,2,2),
('Curcubeu',47.53,'Flori de toate culorile',2,3,3),
('Aranjament Special',42.14,'Pentru momente speciale',2,3,1)



create table Plante
(
	id_planta int identity primary key,
	nume varchar(100),
	descriere varchar(100)
)

insert into Plante(nume, descriere) values
('Trandafir Rosu','D1'),
('Orhidee','D2'),
('Trandafir Roz','D3'),
('Margareta','D4'),
('Minirandafir','D5'),
('Trandafir Galben','D6'),
('Floarea Soarelui','D7')



create table AranjamenteFloralePlante
(
	id_aranjament int foreign key references AranjamenteFlorale(id_aranjament),
	id_planta int foreign key references Plante(id_planta),
	nr_exemplare int,
	constraint pk_AranjamenteFloralePlante primary key (id_aranjament, id_planta)
)

insert into AranjamenteFloralePlante(id_aranjament, id_planta, nr_exemplare) values
(1,1,2),
(1,3,3),
(2,2,2),
(2,5,5),
(2,3,2),
(3,1,3),
(3,5,5),
(4,6,2),
(4,5,3),
(5,3,4),
(6,7,3),
(7,2,2),
(7,6,5)

go
/*    2    */

create or alter procedure AddOrModifyAranjamentFloralPlanta(@id_aranjament int, @id_planta int, @nr_exemplare int) as
begin
	
	if exists (select * from AranjamenteFloralePlante where id_aranjament = @id_aranjament and id_planta = @id_planta)
	begin
		update AranjamenteFloralePlante
		set	
			nr_exemplare = @nr_exemplare
		where	id_aranjament = @id_aranjament and
				id_planta = @id_planta
	end
	else
	begin
		insert into AranjamenteFloralePlante(id_aranjament, id_planta, nr_exemplare) values
		(@id_aranjament, @id_planta, @nr_exemplare)
	end
end

select * from AranjamenteFloralePlante
exec AddOrModifyAranjamentFloralPlanta 7,7,3000


go
/*    3    */

create or alter view vw_FlorariiSiAranjamente as
	select F.nume 'Florarie', AF.nume 'Aranjament Floral', AF.pret, AFP.nr_exemplare, P.nume 'Planta'
	from Florarii F
	join AranjamenteFlorale AF on AF.id_florarie = F.id_florarie
	join AranjamenteFloralePlante AFP on AFP.id_aranjament = AF.id_aranjament
	join Plante P on AFP.id_planta = P.id_planta
	where F.nume not like 'M%'
go

select * from vw_FlorariiSiAranjamente