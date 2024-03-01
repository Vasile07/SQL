-- Numarul de minute ascultate de useri

select U.id_u,U.nume, CAST(DATEADD(ms, SUM(DATEDIFF(ms, '00:00:00.000',M.durata)),'00:00:00.000') AS time) as 'Timp ascultat'
from Utilizatori U
INNER JOIN Ascultari A ON A.id_u = U.id_u
INNER JOIN Melodii M ON A.id_m = M.id_m
group by U.id_u, U.nume;