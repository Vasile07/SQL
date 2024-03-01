create database InchirieriFilme
go

use InchirieriFilme;
go

/**   1   **/

create table Regizori
(
	id int identity primary key,
	nume varchar(100),
	dataNasterii date
);

insert into Regizori(nume,dataNasterii) values
('Ion Pop','2000-12-22'),
('Aurel Pavel','1999-11-23'),
('Marcel Ion','2000-10-11'),
('Bob Paul','1999-11-12')


create table TipFilm
(
	id int identity primary key,
	descriere varchar(100)
);

insert into TipFilm(descriere) values
('Comedie'),
('Drama'),
('Actiune'),
('Horror')


create table Tari
(
	id int identity primary key,
	nume varchar(100)
);

insert into Tari(nume) values
('Romania'),
('Italia'),
('Austria')


create table Actori
(
	id int identity primary key,
	nume varchar(100) unique,
	idTara int foreign key references Tari(id)
);

insert into Actori(nume, idTara) values
('Paul Istriu',1),
('Kolt Norbert',3),
('Faedi Luca',2),
('Marcel Pop',1)


create table Filme
(
	id int identity primary key,
	titlu varchar(100),
	durata time,
	anulAparitiei int,
	pretInchiriere float,
	idRegizor int foreign key references Regizori(id),
	idTip int foreign key references TipFilm(id)
);

insert into Filme(titlu,durata,anulAparitiei,pretInchiriere,idRegizor,idTip) values
('Seara de poveste','01:22:33',2022,32,1,2),
('A fost candva','02:11:32',2021,31,1,1),
('Trenul de noapte','01:56:44',2011,11,2,3),
('O poveste','01:25:34',2021,30,3,4),
('A spus o poveste','02:32:34',2022,22,4,1),
('Greierele','01:11:32',2021,35,4,2),
('Furnica','01:11:33',2020,23,3,4)


create table ActoriFilme
(
	idFilm int foreign key references Filme(id),
	idActor int foreign key references Actori(id),
	constraint pk_ActoriFilme primary key  (idFilm,IdActor)
);

insert into ActoriFilme(idFilm, idActor) values
(1,1),
(1,3),
(1,4),
(2,1),
(2,2),
(3,2),
(3,3),
(3,1),
(3,4),
(4,2),
(4,3),
(4,4),
(5,2),
(5,1),
(5,4),
(6,3),
(7,2),
(7,4)


create table Clienti
(
	id int identity primary key,
	nume varchar(100)
);

insert into Clienti(nume) values
('Irimies Vasile'),
('Vik Airizer'),
('Rus George'),
('Stefan Dac')


create table Inchirieri
(
	idFilm int foreign key references Filme(id),
	idClient int foreign key references Clienti(id),
	dataInchirierii date,
	dataReturnarii date,
	constraint pk_Inchirieri primary key (idFilm, idClient, dataInchirierii, dataReturnarii)
);

insert into Inchirieri(idFilm, idClient, dataInchirierii, dataReturnarii) values
(1,1,'2023-12-11','2023-12-13'),
(1,2,'2023-12-11','2023-12-12'),
(1,1,'2023-12-17','2023-12-18'),
(2,3,'2023-11-10','2023-12-01'),
(3,1,'2023-12-01','2023-12-02'),
(3,4,'2023-11-11','2023-11-13'),
(4,2,'2023-10-11','2023-10-11'),
(4,3,'2023-11-14','2023-11-15')
go

/**    2    **/
select F.titlu
from Filme F
where F.titlu like '%[p,P]oveste%'
go

/**   3   **/
create or alter view ViewActoriCareAuJucatInMaiMulteFilme as
	select A.nume as Actor, T.nume as Tara, count(AF.idFilm) as 'Numar filme in care a jucat'
	from Actori A
	join Tari T on T.id = A.id
	join ActoriFilme AF on AF.idActor = A.id
	group by A.nume, A.id, T.nume
	having count(AF.idFilm) > 3
go

select * from ViewActoriCareAuJucatInMaiMulteFilme
go

/**   4   **/

create or alter procedure FilmeNeinchiriate as 
begin
	select F.titlu, F.anulAparitiei, F.durata, F.pretInchiriere, T.descriere, R.nume
	from Filme F
	join TipFilm T on T.id = F.idTip
	join Regizori R on R.id = F.idRegizor
	left join Inchirieri I on I.idFilm = F.id
	group by F.id,F.titlu, F.anulAparitiei, F.durata, F.pretInchiriere, T.descriere, R.nume
	having count(I.idClient) = 0
end

exec FilmeNeinchiriate

go


/**   5    **/

create or alter function NumarClienti() returns int as
begin
	return	(
				select count(distinct I.idClient) from Inchirieri I
				join Filme F on F.id = I.idFilm
				where F.pretInchiriere > 30 and F.anulAparitiei = 2021
			)
end
go


select I.*, F.pretInchiriere, F.anulAparitiei
from Inchirieri I
join Filme F on F.id = I.idFilm

declare @variabila int
set @variabila = dbo.NumarClienti()
print(@variabila)