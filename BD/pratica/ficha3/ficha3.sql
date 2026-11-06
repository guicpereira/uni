1.
with DuracaoAlbuns as (
    SELECT
    	a.titulo as album,
    	sum(f.duracao) as total_segundos
    from album a 
    inner join faixas f on a.album_id=f.album
    group by a.album_id,a.titulo
)
SELECT
	album,
    sec_to_time(total_segundos) as duracao_total,
    rank() over (order by total_segundos DESC) as ranking
from DuracaoAlbuns
limit 10

2.
WITH FaixasAlbum AS (
    SELECT 
        f.faixa_numero AS faixa,
        f.titulo,
        f.duracao
    FROM faixas f
    INNER JOIN album a ON f.album = a.album_id
    WHERE a.titulo = 'The Joshua Tree'
)
SELECT 
    faixa,
    titulo,
    SEC_TO_TIME(
        COALESCE(
            SUM(duracao) OVER (
                ORDER BY faixa 
                ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
            ), 
            0
        )
    ) AS start
FROM FaixasAlbum
ORDER BY faixa ASC;

3.
with AlbunsAnuais as (
    SELECT 
    	ar.nome as nome,
    	al.ano_album as ano,
    	count(al.album_id) as total_albuns
    FROM artista ar 
    inner join album al on ar.artista_id=al.artista
    where al.ano_album BETWEEN 1970 and 1979
    group by ar.artista_id, ar.nome, al.ano_album
)
SELECT 
	nome,
	ano,
    total_albuns
from AlbunsAnuais
where total_albuns = 2
order by nome ASC, ano ASC