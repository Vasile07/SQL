-- Numarul de ascultari ale fiecarei piese

SELECT M.id_m, M.titlu, COUNT(*) as 'Numar de ascultari'
from Melodii M
INNER JOIN Ascultari A on A.id_m = M.id_m
group by M.id_m, M.titlu