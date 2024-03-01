CREATE DATABASE MusicStreamingDatabase;
GO
USE MusicStreamingDatabase;


CREATE TABLE Abonament
(
id_ab INT PRIMARY KEY IDENTITY,
tip NVARCHAR(100) NOT NULL,
durata TIME NOT NULL,
pret INT NOT NULL,
id_u INT,

);

CREATE TABLE Utilizatori
(
id_u INT PRIMARY KEY IDENTITY,
nume NVARCHAR(100) NOT NULL UNIQUE,
email NVARCHAR(100) NOT NULL UNIQUE,
parola NVARCHAR(100) NOT NULL,
id_ab INT,
CONSTRAINT fk_Abonament FOREIGN KEY (id_ab) REFERENCES Abonament(id_ab) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Carduri
(
id_card INT PRIMARY KEY IDENTITY,
numarCard VARCHAR(16) NOT NULL,
numeDetinator VARCHAR(100) NOT NULL,
dataExpirare DATE NOT NULL,
CVV VARCHAR(3) NOT NULL,
id_u INT,
CONSTRAINT fk_UtilizatoriCarduri FOREIGN KEY (id_u) REFERENCES Utilizatori(id_u) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Playlisturi
(
id_p INT PRIMARY KEY IDENTITY,
denumire NVARCHAR(100) NOT NULL,
id_u INT,
CONSTRAINT fk_UtilizatoriPlaylisturi FOREIGN KEY (id_u) REFERENCES Utilizatori(id_u) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Melodii
(
id_m INT PRIMARY KEY IDENTITY,
titlu NVARCHAR(100) NOT NULL,
durata TIME NOT NULL,
gen NVARCHAR(100) NOT NULL,
data_lansare DATE NOT NULL
);

CREATE TABLE MelodiiPlaylisturi
(
id_p INT,
id_m INT,
CONSTRAINT fk_PlaylisturiMelodiiPlaylisturi FOREIGN KEY (id_p) REFERENCES Playlisturi(id_p),
CONSTRAINT fk_MelodiiMelodiiPlaylisturi FOREIGN KEY (id_m) REFERENCES Melodii(id_m),
CONSTRAINT pk_MelodiiPlaylisturi PRIMARY KEY (id_p,id_m)
);

CREATE TABLE Ascultari
(
id_u INT,
id_m INT,
CONSTRAINT fk_UtilizatoriAscultari FOREIGN KEY (id_u) REFERENCES Utilizatori(id_u),
CONSTRAINT fk_MelodiiAscultari FOREIGN KEY (id_m) REFERENCES Melodii(id_m),
CONSTRAINT pk_Ascultari PRIMARY KEY (id_u,id_m)
);

CREATE TABLE Artisti
(
id_a INT PRIMARY KEY IDENTITY,
nume NVARCHAR(100) NOT NULL,
email NVARCHAR(100) NOT NULL,
parola NVARCHAR(100) NOT NULL,
data_inscrierii DATE NOT NULL
);

CREATE TABLE Publicari
(
id_a INT,
id_m INT,
CONSTRAINT fk_ArtistiPublicari FOREIGN KEY (id_a) REFERENCES Artisti(id_a),
CONSTRAINT fk_MelodiiPublicari FOREIGN KEY (id_m) REFERENCES Melodii(id_m),
CONSTRAINT pk_Publicari PRIMARY KEY (id_a, id_m)
);

CREATE TABLE Albume
(
id_album INT PRIMARY KEY IDENTITY,
nume NVARCHAR(100) NOT NULL,
data_lansare DATE,
id_a INT,
CONSTRAINT fk_ArtistiAlbume FOREIGN KEY (id_a) REFERENCES Artisti(id_a),
);