insert into 2026_bd_lei.ficha2 (aluno,idresposta,resposta)
values(27226,,'');

9.
SELECT 
    (
        SELECT count(*) 
        FROM faixas 
        WHERE titulo LIKE 'My%'
    ) AS 'Começa por My',
    (
        SELECT count(*) 
        FROM faixas 
        WHERE titulo LIKE 'Love%'
    ) AS 'Começa por Love',
    (
        SELECT count(*) 
        FROM faixas 
        WHERE titulo LIKE '%Love'
    ) AS 'Termina em Love';

10.
SELECT a.titulo
FROM album a
INNER JOIN faixas f ON a.album_id = f.album
GROUP BY a.album_id, a.titulo
HAVING COUNT(DISTINCT f.genero) > 1
ORDER BY a.titulo ASC
LIMIT 5

11.
SELECT a.faixa_id, a.titulo, a.ano
FROM faixas a
INNER JOIN (
    SELECT b.album_id
    FROM album b
    INNER JOIN faixas c ON b.album_id = c.album
    GROUP BY b.album_id
    ORDER BY COUNT(c.faixa_id) DESC
    LIMIT 10
) AS dez_com_mais_faixas ON a.album = dez_com_mais_faixas.album_id
WHERE a.ano > 1980
ORDER BY a.faixa_id ASC
LIMIT 10

18.
select c.nome as "Nome",count(distinct a.artista) as "nartistas"
from compositor c
inner join fx_comp fc on c.compositor_id=fc.compositor
inner join faixas f on fc.faixa_id=f.faixa_id
inner join album a on f.album = a.album_id
group by c.compositor_id,c.nome
order by count(distinct a.artista) DESC
LIMIT 1

19.
SELECT ar.nome
FROM artista ar
INNER JOIN album al ON ar.artista_id = al.artista
GROUP BY ar.nome
HAVING COUNT(al.album_id) >= 10 
   AND (MAX(al.ano_album) - MIN(al.ano_album)) >= 15
ORDER BY ar.nome ASC;

20.
select a.album_id as "album", a.titulo
from album a
inner join artista ar on a.artista=ar.artista_id
where ar.nome = "The Beatles"
	and a.ano_album >1967
    
    and a.album_id in (
        SELECT f.album
        FROM faixas f
        inner join fx_comp fc1 on f.faixa_id=fc1.faixa_id
        inner join fx_comp fc2 on f.faixa_id=fc2.faixa_id
        where fc1.compositor=140 AND fc2.compositor=139
    )
    and a.album_id in (
        SELECT f.album
        from faixas f 
        inner join fx_comp fc on f.faixa_id=fc.faixa_id
        where fc.compositor = 141
        group by f.album
        having count(distinct f.faixa_id) >= 2
    )

21.
select ar.nome
from artista ar
where (
    select count(al.album_id)
    from album al
    where al.artista=ar.artista_id
    	and(
            select count(f.faixa_id)
            from faixas f 
            where f.album=al.album_id
        ) > (
            select count(distinct fc.faixa_id)
            from faixas f 
            inner join fx_comp fc on f.faixa_id=fc.faixa_id
            inner join compositor c on c.compositor_id=fc.compositor
            where f.album = al.album_id and c.nome = ar.nome 
        )
) >= 2
order by ar.nome asc

22.
SELECT
	ar.nome as Artista,
    (
        select count(*)
        from album al 
        where al.artista = ar.artista_id
        	and al.ano_album between 1960 and 1969
    ) as "Década de 60s",
    (
        select count(*)
        from album al 
        where al.artista = ar.artista_id
        	and al.ano_album between 1970 and 1979
    ) as "Década de 70s",
    (
        select count(*)
        from album al 
        where al.artista = ar.artista_id
        	and al.ano_album between 1980 and 1989
    ) as "Década de 80s",
    (
        select count(*)
        from album al 
        where al.artista = ar.artista_id
        	and (al.ano_album < 1960 or al.ano_album > 1989)
    ) as "Outras"
from artista ar
where ar.artista_id in (SELECT DISTINCT artista from album)
order by ar.nome ASC

23.
select 
	g.name as Género,
	(
        select count(*)
        from faixas f 
        where f.genero = g.id 
        	and f.ficheiro_tamanho < 6039074
        ) as "Tamanho < 6039074",
        (
            select count(*)
            from faixas f 
            where f.genero = g.id
            	and f.ficheiro_tamanho >= 6039074
            ) as "Tamanho >= 6039074"
from genero g 
order by g.name ASC

24.
SELECT ar.nome as Artista,
	(
        select count(*)
        from album al 
        where al.artista = ar.artista_id
        	and (
                select count(f.faixa_id)
                from faixas f 
                inner join genero g on f.genero = g.id
                where f.album = al.album_id and g.name = "Rock"
            ) < 5
        ) as "Álbuns com menos de 5 faixas do género Rock",
        (
            select count(*)
            from album al 
            where al.artista = ar.artista_id
            	and (
                    select count(*)
                    from faixas f 
                    inner join genero g on f.genero = g.id 
                    where f.album = al.album_id and g.name= "Rock"
                ) > 5
            ) as "Álbuns com mais de 5 faixas do género Rock"
from artista ar 
order by ar.nome ASC

25.
select 
	g.name as Género,
    (
        select count(*)
        from faixas f
        where f.genero = g.id
        	and f.duracao > 240
        	and f.ano <= 2000
        ) as "Século XX",
        (
            select count(*)
            from faixas f 
            where f.genero = g.id 
            	and f.duracao > 240
            	and f.ano >= 2001
            ) as "Século XXI"
from genero g
ORDER BY g.name ASC