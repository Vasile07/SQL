-- numele artistilor care au cel putin 3 piese lansate

SELECT Artisti.id_a, Artisti.nume as 'Artist', COUNT(Publicari.id_m) as 'Numar piese lansate'
from Artisti
INNER JOIN Publicari ON Artisti.id_a = Publicari.id_a
group by Artisti.id_a, Artisti.nume
having COUNT(Publicari.id_m) >= 3;