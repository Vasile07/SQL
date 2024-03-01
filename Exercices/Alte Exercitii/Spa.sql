create database Spa
use Spa
go

/*    1    */

create table Orase
(
	id_oras int identity primary key,
	nume varchar(100)
)

insert into Orase(nume) values
('Cluj'),('Bucuresti'),('Craiova')



create table CentreSpa
(
	id_centru_spa int identity primary key,
	nume varchar(100),
	site_web varchar(100),
	id_oras int foreign key references Orase(id_oras)
)

insert into CentreSpa(nume, site_web, id_oras) values
('Centrul Relaxarii','www.centrulrelaxarii.ro',1),
('Centrul Zen','www.centrulzen.ro',1),
('Relaxare Maxim A','www.relaxaremaxima.ro',2),
('Centrul ZZZ','www.centrulzzz.ro',3),
('Centrul Somn','www.centrulsomn.ro',3)



create table ServiciiSpa
(
	id_serviciu_spa int identity primary key,
	nume varchar(100),
	descriere varchar(100),
	pret float,
	recomandare varchar(100),
	id_centru_spa int foreign key references CentreSpa(id_centru_spa)
)

insert into ServiciiSpa(nume, descriere, pret, recomandare, id_centru_spa) values
('Serviciu 1','Descriere 1',67.86,'Recomandare 1',1),
('Serviciu 2','Descriere 2',62.42,'Recomandare 2',1),
('Serviciu 3','Descriere 3',82.36,'Recomandare 3',2),
('Serviciu 4',NULL,64.23,'Recomandare 4',2),
('Serviciu 5',NULL,91.08,'Recomandare 5',2),
('Serviciu 6','Descriere 6',84.21,'Recomandare 6',3),
('Serviciu 7',NULL,76.96,'Recomandare 7',3)



create table Clienti
(
	id_client int identity primary key,
	nume varchar(100),
	prenume varchar(100),
	ocupatie varchar(100)
)

insert into Clienti(nume, prenume, ocupatie) values
('Popescu','Ionela','Contabila'),
('Pop','Ion','Geamgiu'),
('Rus','Gheorghe','Inginer'),
('Marinescu','Marius','Vanzator')



create table ServiciiSpaClienti
(
	id_clienti int foreign key references Clienti(id_client),
	id_serviciu_spa int foreign key references ServiciiSpa(id_serviciu_spa),
	nota int,
	constraint pk_ServiciiSpaClienti primary key (id_clienti,id_serviciu_spa)
)

insert into ServiciiSpaClienti(id_clienti, id_serviciu_spa, nota) values
(1,2,2),
(1,4,3),
(2,5,5),
(2,2,7),
(2,1,9),
(3,7,2),
(3,5,7),
(3,6,8),
(4,2,7),
(4,3,8)

go

/*    2    */

create or alter procedure AddOrModifiServiciuSpaClient(@id_client int, @id_serviciu_spa int,@nota int) as
begin
	
	if exists (select * from ServiciiSpaClienti where id_clienti = @id_client and id_serviciu_spa = @id_serviciu_spa)
	begin
		update ServiciiSpaClienti
		set nota = @nota
		where	id_clienti = @id_client and
				id_serviciu_spa = @id_serviciu_spa
	end
	else
	begin
		insert into ServiciiSpaClienti(id_clienti, id_serviciu_spa, nota) values
		(@id_client, @id_serviciu_spa, @nota)
	end

end

select * from ServiciiSpaClienti
exec AddOrModifiServiciuSpaClient 4,7,8
go


/*    3    */

create or alter function GetCentreSpa() returns table as
	return	select C.nume 'Centru', S.nume 'Serviciu', S.descriere, SC.nota, Clienti.nume + ' ' + Clienti.prenume 'Client'
			from CentreSpa C
			join ServiciiSpa S on S.id_centru_spa = C.id_centru_spa
			join ServiciiSpaClienti SC on SC.id_serviciu_spa = S.id_serviciu_spa
			join Clienti on Clienti.id_client = SC.id_clienti
			where S.descriere is not null
go

select * from dbo.GetCentreSpa()