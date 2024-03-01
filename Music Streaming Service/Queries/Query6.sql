-- toate piesele ascultate de un anumit user

SELECT Melodii.titlu
from Melodii
INNER JOIN Ascultari ON Melodii.id_m = Ascultari.id_m
INNER JOIN Utilizatori On Ascultari.id_u = Utilizatori.id_u
where Utilizatori.nume = 'Cristina Vasile'

select nume from Utilizatori;