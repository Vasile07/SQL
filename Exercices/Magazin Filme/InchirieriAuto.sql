create database InchirieriAuto;
go

use InchirieriAuto;
go

/*  1  */

create table Clienti
(
	id int identity primary key,
	nume varchar(100),
	prenume nvarchar(100)
);

create table Angajati
(
	id int identity primary key,
	nume varchar(100),
	prenume nvarchar(100)
);

create table Marci
(
	id int identity primary key,
	denumire varchar(100)
);

create table Autovehicule
(
	id int identity primary key,
	numarInmatriculare varchar(100) not null,
	tipMotorizare varchar(100),
	idMarca int foreign key references Marci(id)
);

create table Inchirieri
(
	id int identity primary key,
	idAngajat int foreign key references Angajati(id),
	idClient int foreign key references Clienti(id),
	idMasina int foreign key references Autovehicule(id),
	dataInchieri datetime,
	dataReturnari datetime
);

/*  Populare tabele  */

insert into Clienti(nume, prenume) values
('Dan','Pavel'),
('Pop','Ion'),
('Picovic','Paula'),
('Mitrut','Petru'),
('Aurel','Marcel')

insert into Angajati(nume, prenume) values
('Marcel','Pavel'),
('Badea','Lucian'),
('Lavanda','Oana'),
('Horia','Raul'),
('Man','Pavel')

insert into Marci(denumire) values
('Logan'),
('Mercedes'),
('BMW')

insert into Autovehicule(numarInmatriculare, tipMotorizare, idMarca) values
('CJ-17-MLV','Gaz',1),
('CJ-16-GPX','Gaz',2),
('CJ-11-AVZ','Benzina',2),
('CJ-19-VAV','Motorina',1),
('CJ-18-BXX','Gaz',3),
('CJ-27-AVQ','Benzina',1),
('CJ-58-AQA','Gaz',2),
('CJ-67-MVY','Benzina',3)
go


/*  2  */

create or alter procedure AdaugaSauModificaInchirieri(@idAngajat int, @idMasina int, @idClient int, @dataInchieri datetime, @dataReturnari datetime, @operatie bit) as
begin
	if @operatie = 1
	begin
		insert into Inchirieri(idAngajat, idClient, idMasina, dataInchieri, dataReturnari) values
		(@idAngajat, @idClient, @idMasina, @dataInchieri, @dataReturnari)
	end
		else
	begin
		update Inchirieri
			set	dataInchieri = @dataInchieri,
				dataReturnari = @dataReturnari
			where idAngajat = @idAngajat and idClient = @idClient and idMasina = @idMasina
	end
end
go

select * from Clienti;
select * from Angajati;
select * from Autovehicule

select * from Inchirieri
exec AdaugaSauModificaInchirieri 5,5,1,'2023-12-04 12:00:00','2023-12-06 12:00:00',1


go

/*  3  */
create or alter view AngajatiNumarInchieri as
	select A.nume + ' ' + A.prenume as Angajat, count(I.id) as 'Numar de autovhicule inchiriate'
	from Angajati A
	join Inchirieri I on I.idAngajat = A.id
	group by A.nume, A.prenume, A.id
	having count(I.id) > 1
go

select * from AngajatiNumarInchieri

go

/*  4  */

create or alter function AutovehiculeLibere(@data datetime) returns table as
	return	select Av.numarInmatriculare, M.denumire, Av.tipMotorizare
			from Autovehicule Av
			left join Marci M on M.id = Av.idMarca
			where Av.id not in (select I.idMasina from Inchirieri I where DATEDIFF(mm,I.dataInchieri,@data) >= 0 and DATEDIFF(ms,@data,I.dataReturnari) >= 0)
	
go