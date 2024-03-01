INSERT INTO Artisti (nume,email,parola,data_inscrierii) VALUES
('Maria Popescu', 'maria.popescu@example.com', 'Parola123', '1990-05-15'),
('Ion Georgescu', 'ion.georgescu@example.com', 'Parola456', '1985-11-22'),
('Andreea Radu', 'andreea.radu@example.com', 'Parola789', '1992-08-07'),
('Alexandra Stoica', 'alexandra.stoica@example.com', 'ParolaABC', '1987-03-30'),
('Cristian Gheorghe', 'cristian.gheorghe@example.com', 'ParolaXYZ', '1995-02-14'),
('Laura Mihai', 'laura.mihai@example.com', 'Parola789', '1991-04-17'),
('Andrei Dumitrescu', 'andrei.dumitrescu@example.com', 'ParolaXYZ', '1988-09-05'),
('Ana Popa', 'ana.popa@example.com', 'Parola456', '1993-06-12'),
('Cãtãlina Ionescu', 'catalina.ionescu@example.com', 'ParolaABC', '1984-12-03'),
('Gabriel Vasile', 'gabriel.vasile@example.com', 'Parola123', '1997-07-28'),
('Mihaila Luca', 'mihaila.luca@example.com', 'Parola321', '1989-02-19'),
('Daniel Ivan', 'daniel.ivan@example.com', 'Parola789', '1994-10-24');

SELECT * from Artisti;

INSERT INTO Albume (nume,data_lansare,id_a) VAlUES
('Sufletul Meu', '2005-12-15', 4),
('Cantece de Dragoste', '2010-08-02', 7),
('Ritmuri de Vara', '2008-04-10', 2),
('Melodii de Toamna', '2015-09-25', 4),
('In Lumina Lunii', '2006-03-17', 5),
('Serile de Jazz', '2012-07-08', 6),
('Pe Aripile Viselor', '2007-05-28', 1),
('Cantece pentru Tine', '2013-11-20', 2),
('Noaptea Magiei', '2009-06-07', 3),
('Sunetul Noptii', '2018-10-12', 3),
('In Zori', '2011-02-28', 4),
('Melodii de Vara', '2004-01-14', 11);

select * from Albume;

INSERT INTO Melodii (titlu, durata,gen,data_lansare) VALUES
('Cantec Fericit', '03:45', 'Pop', '2005-12-15'),
('Melodie de Dragoste', '04:20', 'Balada', '2010-08-02'),
('Ritmul Verii', '02:58', 'Dance', '2008-04-10'),
('Pe Aripile Iubirii', '03:30', 'Balada', '2015-09-25'),
('Seara Magica', '03:15', 'Pop', '2006-03-17'),
('Dansand Sub Stele', '04:05', 'Dance', '2012-07-08'),
('Sunetul Marii', '04:50', 'Relaxare', '2007-05-28'),
('In Lumina Lunii', '03:12', 'Pop', '2013-11-20'),
('Visul Meu', '03:25', 'Balada', '2009-06-07'),
('Zorii Zilei', '04:10', 'Rock', '2018-10-12'),
('Cantec Indraznet', '03:40', 'Pop', '2011-02-28'),
('Melodie de Vara', '03:52', 'Dance', '2004-01-14'),
('Amintiri Frumoase', '03:18', 'Pop', '2006-08-20'),
('Dansul Dragostei', '04:05', 'Dance', '2010-03-15'),
('Cantec de Toamna', '03:30', 'Balada', '2008-11-10'),
('Sufletul Inflorit', '03:55', 'Pop', '2014-06-25'),
('Melodia Serii', '04:30', 'Rock', '2007-05-03'),
('Ritmuri Tropicale', '03:20', 'Dance', '2011-07-28'),
('Cantecul Iubirii', '03:10', 'Balada', '2009-12-05'),
('Seara de Vara', '04:25', 'Pop', '2016-09-18'),
('Sunetul Noptii', '03:48', 'Relaxare', '2005-04-14'),
('In Aripa Viselor', '04:02', 'Pop', '2013-02-10'),
('Melodia Zilei', '03:36', 'Dance', '2017-11-30'),
('Dansand in Ploaie', '03:22', 'Pop', '2004-10-07');

SELECT * from Melodii;

INSERT INTO Publicari (id_a, id_m) VALUES
(6, 11),
(9, 3),
(3, 14),
(1, 19),
(11, 5),
(2, 23),
(10, 9),
(7, 16),
(12, 1),
(2, 20),
(5, 6),
(8, 13),
(1, 4),
(10, 21),
(7, 17),
(11, 12),
(1, 7),
(6, 24),
(7, 10),
(12, 2),
(8, 15),
(4, 22),
(3, 8),
(11, 18);

select * from Publicari;



INSERT INTO Abonament (tip,durata,pret) VALUES
('Standard', 0,00.00),
('Premium', 12,73.00),
('Deluxe', 12,100.00);

select * from Abonament;

INSERT INTO Utilizatori (nume, email, parola, id_ab) VALUES
('Marian Ionescu', 'marian.ionescu@example.com', 'Parola123', 4),
('Cristina Vasile', 'cristina.vasile@example.com', 'Parola456', 3),
('Andrei Gheorghe', 'andrei.gheorghe@example.com', 'Parola789', 5),
('Elena Popa', 'elena.popa@example.com', 'ParolaABC', 4),
('Gabriela Radu', 'gabriela.radu@example.com', 'ParolaXYZ', 3),
('Mihai Stoica', 'mihai.stoica@example.com', 'Parola321', 5),
('Diana Popescu', 'diana.popescu@example.com', 'Parola654', 3);

select * from Utilizatori;

INSERT INTO Ascultari(id_u, id_m) VALUES
(1, 10),
(2, 18),
(3, 7),
(4, 14),
(5, 3),
(6, 20),
(7, 12),
(1, 22),
(2, 6),
(3, 9),
(4, 1),
(5, 16),
(6, 4),
(7, 8),
(1, 19),
(2, 2),
(3, 11),
(4, 21),
(5, 5),
(6, 15),
(7, 24),
(1, 13),
(2, 17),
(3, 23),
(4, 7),
(5, 2),
(6, 11),
(7, 9),
(1, 6),
(2, 12),
(3, 4),
(4, 3),
(5, 20),
(6, 16),
(7, 15),
(1, 18),
(2, 5),
(3, 1),
(4, 10),
(5, 8),
(6, 14),
(7, 21),
(1, 3),
(2, 16),
(3, 12),
(4, 8),
(5, 19),
(6, 24),
(7, 11),
(1, 7);

select nume, titlu
from Utilizatori
INNER JOIN Ascultari ON Ascultari.id_u = Utilizatori.id_u 
INNER JOIN Melodii On Ascultari.id_m = Melodii.id_m

INSERT INTO Playlisturi (denumire, id_u) VALUES 
('Top Hits', 3),
('Chill Vibes', 2),
('Rock Classics', 6),
('Party Mix', 4),
('Mellow Melodies', 7),
('Road Trip Jams', 1),
('Morning Coffee', 5),
('Workout Beats', 3),
('Relaxation Station', 1),
('Acoustic Acoustics', 4),
('Late Night Tunes', 2),
('Sunny Day Sounds', 5),
('R&B Grooves', 6),
('Indie Anthems', 7),
('Throwback Hits', 1),
('Jazz Cafe', 3),
('Dance Party Anthems', 2);


INSERT INTO MelodiiPlaylisturi (id_p, id_m) VALUES
(1, 3),
(2, 16),
(3, 12),
(4, 8),
(5, 19),
(6, 24),
(7, 11),
(8, 7),
(9, 2),
(10, 15),
(11, 21),
(12, 5),
(13, 9),
(14, 17),
(15, 4),
(16, 20),
(17, 14),
(1, 23),
(2, 13),
(3, 18),
(4, 1),
(5, 10),
(6, 22),
(7, 6),
(8, 12),
(9, 19),
(10, 4),
(11, 16),
(12, 8),
(13, 7),
(14, 2),
(15, 21),
(16, 11),
(17, 5),
(1, 15),
(2, 20),
(3, 9),
(4, 24),
(5, 17),
(6, 3),
(7, 18),
(8, 14),
(9, 12),
(10, 6),
(11, 1),
(12, 23),
(13, 8),
(14, 21),
(15, 10),
(16, 13),
(17, 7);



select * from MelodiiPlaylisturi;