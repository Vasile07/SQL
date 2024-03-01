-- numarul de melodii mai vechi de 15 de ani grupate pe genuri muzicale

SELECT gen, COUNT(id_m) as 'Numar melodii'
from Melodii
where DATEDIFF(yyyy, Melodii.data_lansare, GETDATE()) > 15
group by gen
order by gen