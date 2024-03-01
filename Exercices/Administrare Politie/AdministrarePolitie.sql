create database Politie
go

use Politie
go

/**   1    **/

create table SectiiDePolitie
(
	id int identity primary key,
	denumire varchar(100),
	adresa varchar(100)
);

insert into SectiiDePolitie(denumire, adresa) values
('Sectia 14','Bucuresti'),
('Sectia 21','Maramures'),
('Sectia 5','Cluj'),
('Sectia 14','Zorilor')


create table Grade
(
	id int identity primary key,
	denumire varchar(100)
);

insert into Grade(denumire) values
('Maior'),
('General'),
('Politist Local'),
('Sef de politie')


create table Politisti
(
	id int identity primary key,
	nume varchar(100),
	prenume varchar(100),
	idSectie int foreign key references SectiiDePolitie(id),
	idGrad int foreign key references Grade(id)
);

insert into Politisti(nume,prenume,idSectie,idGrad) values
('Pop','Ion',1,2),
('Marcel','Paul',3,3),
('Bordeanu','Pavel',3,2),
('Rus','George',2,1),
('Roman','Stefan',1,3),
('Airizer','Viktor',2,3),
('Irimies','Emilian',4,1),
('Saratean','Tudor',4,4)


create table Sectoare
(
	id int identity primary key,
	denumire varchar(100)
);

insert into Sectoare(denumire) values
('Sector 1'),
('Sector 2'),
('Sector 3')


create table Patrule
(
	idSectie int foreign key references SectiiDePolitie(id),
	idPolitist int foreign key references Politisti(id),
	intrareInTura datetime,
	iesireDinTura datetime,
	constraint pk_Patrule primary key (idSectie,idPolitist)
);


insert into Patrule(idSectie, idPolitist, intrareInTura, iesireDinTura) values
(1,1,'2023-12-11 12:20:00','2023-12-12 03:30:00'),
(1,2,'2023-11-14 11:35:00','2023-11-14 19:37:00'),
(2,3,'2023-12-11 09:28:00','2023-12-11 16:27:00'),
(2,4,'2023-10-19 11:21:00','2023-10-19 18:11:00'),
(2,5,'2023-11-22 12:22:00','2023-11-22 19:19:00'),
(3,6,'2023-12-27 18:22:00','2023-12-27 02:29:00'),
(3,7,'2023-12-30 12:26:00','2023-12-30 22:50:00')
go

/**    2    **/
create or alter procedure AdaugaPatrula(@idPolitist int, @idSectie int, @intrare datetime, @iesire datetime) as
begin
	if not exists (select * from Patrule where idPolitist = @idPolitist and idSectie = @idSectie)
	begin
		insert into Patrule(idPolitist, idSectie, intrareInTura, iesireDinTura) values
		(@idPolitist, @idSectie, @intrare, @iesire)
	end
		else
		begin
			update Patrule
				set intrareInTura = @intrare,
					iesireDinTura = @iesire
			where idPolitist = @idPolitist and idSectie = @idSectie
		end
end
go


select * from Patrule
go
/***   3    **/
create or alter view ViewPolitist as
	select P.nume + ' ' + P.prenume as Nume, G.denumire as Grad, SUM(datepart(HOUR,Pa.iesireDinTura) - datepart(hour,Pa.intrareInTura)) as 'Ore Muncite'
	from Politisti P
	join Grade G on G.id = P.idGrad
	join Patrule Pa on Pa.idPolitist = P.id
	where Month(Pa.intrareInTura) = 1
	group by P.id, P.nume, P.prenume, G.denumire
go

select * from ViewPolitist
/**    4    **/
