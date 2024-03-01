-- cea mai ascultata piesa a fiecarui artist

SELECT Artisti.id_a, Artisti.nume, Melodii.titlu
from Artisti
INNER JOIN Publicari ON Artisti.id_a = Publicari.id_a
INNER JOIN Melodii On Melodii.id_m = Publicari.id_m
where ( select COUNT(*) from Ascultari where Ascultari.id_m = Melodii.id_m) = ( select MAX(NumarulDeAscultariAFiecareiPiese.NrAscultari) as Maxim
																				from 
																				(
																				select COUNT(Ascultari.id_u) as NrAscultari
																				from Ascultari
																				INNER JOIN Melodii ON Melodii.id_m = Ascultari.id_m
																				INNER JOIN Publicari ON Publicari.id_m = Melodii.id_m
																				where Publicari.id_a = Artisti.id_a
																				group by Melodii.id_m
																				) NumarulDeAscultariAFiecareiPiese
																				);

select Artisti.nume, Melodii.titlu
from Artisti
INNER JOIN Publicari ON Publicari.id_a = Artisti.id_a
INNER JOIN Melodii On Melodii.id_m = Publicari.id_m

select Melodii.titlu, COUNT(Ascultari.id_u)
from Melodii
INNER JOIN Ascultari ON Ascultari.id_m = Melodii.id_m
group by Melodii.titlu