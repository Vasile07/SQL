-- artistul care a lansat cel putin o piesa in ultimii 10 ani

SELECT DISTINCT Artisti.nume
FROM Artisti
INNER JOIN Publicari ON Publicari.id_a = Artisti.id_a
INNER JOIN Melodii ON Melodii.id_m = Publicari.id_m
WHERE DATEDIFF(yyyy,Melodii.data_lansare, GETDATE()) < 10