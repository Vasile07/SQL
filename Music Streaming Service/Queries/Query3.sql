-- Numarul de albume ale ficarui artist mai noi de 15 ani

SELECT Artisti.id_a, Artisti.nume, COUNT(Albume.id_a) AS 'Numar Albume'
from Artisti
INNER JOIN Albume ON Artisti.id_a = Albume.id_a
where DATEDIFF(yyyy, Albume.data_lansare, GETDATE()) < 15
group by Artisti.id_a, Artisti.nume;

select * from Albume;