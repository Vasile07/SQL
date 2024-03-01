create database CampionatDeTenis
go
use CampionatDeTenis
go

/*  1  */

create table Turnee
(
	id int identity primary key,
	loc varchar(100),
	perioadaDeDesfasurare varchar(100)
);

create table Jucatori
(
	id int identity primary key,
	nume varchar(100),
	numarDePuncteAcumulate bigint,
	valoareaPremiilorCastigate bigint
);


create table Arene
(
	id int identity primary key,
	nume varchar(100)
)

create table Partide
(
	id int identity primary key,
	idTurneu int foreign key references Turnee(id),
	idArena int foreign key references Partide(id),
	idJucator1 int foreign key references Jucatori(id),
	idJucator2 int foreign key references Jucatori(id),
	idJucatorCastigator int foreign key references Jucatori(id),
	puncte bigint,
	sumaJucator1 bigint,
	sumaJucator2 bigint
);


/* Popularea tabelului */
insert into Turnee(loc, perioadaDeDesfasurare) values
('Cluj-Napoca','2023-12-02 - 2023-12-05'),
('Beius','2023-11-14 - 2023-11-16'),
('Iasi','2023-12-22 - 2023-12-25'),
('Cluj-Napoca','2024-01-02 - 2023-01-05')

insert into Jucatori(nume,numarDePuncteAcumulate, valoareaPremiilorCastigate) values
('Ion Paul',200,4000),
('Stanica Pop',150,2000),
('Paula Pop',300,4000),
('Marcel Petru',500,6000),
('Rus Stefan',250,3000),
('Vedea Petru',150,2000),
('Pavel Gal',225,1500)

insert into Arene(nume) values
('Arena 1'),
('Arena 2'),
('Arena 3'),
('Arena 4')

insert into Partide(idTurneu, idArena, idJucator1, idJucator2, idJucatorCastigator, puncte, sumaJucator1, sumaJucator2) values
(1,1,2,5,2,150,2000,1000),
(1,3,1,7,7,200,2000,3000),
(2,1,4,5,5,160,1000,3000),
(2,3,3,2,3,70,2000,500),
(2,4,6,7,6,220,1500,700),
(2,4,7,3,7,150,2200,1000),
(3,1,5,2,5,230,1500,2400),
(3,2,1,5,1,150,3000,1000),
(3,3,4,1,4,230,2000,700),
(3,3,2,3,3,140,1000,2500),
(3,3,7,3,7,220,2000,700),
(4,4,6,1,1,160,1500,2400),
(4,1,6,4,4,170,1200,2400),
(4,2,4,1,1,210,1000,2200),
(4,2,5,2,5,190,2250,1230)

go
/* 2 */

create or alter procedure AdaugaPartida(@idTurneu int, @idJucator1 int, @idJucator2 int, @puncte bigint, @sumaJucator1 bigint, @sumaJucator2 bigint, @idCastigator int, @idArena int) as
begin
	insert into Partide(idTurneu, idArena, idJucator1, idJucator2, idJucatorCastigator, puncte, sumaJucator1, sumaJucator2) values
	(@idTurneu, @idArena, @idJucator1, @idJucator2, @idCastigator, @puncte, @sumaJucator1, @sumaJucator2)
end
go

/*  3  */

create or alter view ListaJucatoriNrPartideCastigate as
	select J.nume as Jucator, count(P.id) as 'Numar partide castigate'
	from Jucatori J
	join Partide P on P.idJucatorCastigator = J.id
	group by J.nume, J.id
go

select * from ListaJucatoriNrPartideCastigate
go

/*  4  */

create or alter function NumarPuncteSiPremii(@idJucator int) returns table as
	return  select	( select SUM(sumaJucator1) from Partide where idJucator1 = @idJucator ) + 
					( select SUM(sumaJucator2) from Partide where idJucator2 = @idJucator) as 'Suma', 
					(select SUM(puncte) from Partide where idJucatorCastigator = @idJucator) as 'Puncte'
go

select * from Partide where idJucator1 = 1 or idJucator2 = 1 
select * from NumarPuncteSiPremii(1);

