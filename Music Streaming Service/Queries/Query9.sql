-- numele melodiilor care apar intr-un singur playlist

select Melodii.titlu
from Melodii
INNER JOIN MelodiiPlaylisturi ON Melodii.id_m= MelodiiPlaylisturi.id_m
group by Melodii.titlu
having COUNT(MelodiiPlaylisturi.id_p) = 1