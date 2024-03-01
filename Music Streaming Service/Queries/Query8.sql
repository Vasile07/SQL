-- toate melodiile care apar cel putin intr-un playlist

SELECT DISTINCT Melodii.titlu
from Melodii
INNER JOIN MelodiiPlaylisturi ON MelodiiPlaylisturi.id_m = Melodii.id_m
order by Melodii.titlu