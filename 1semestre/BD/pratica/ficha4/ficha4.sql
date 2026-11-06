1.
INSERT INTO artista (nome)
VALUES ("Compilações, colectâneas ou artista desconhecido")


2.
UPDATE album
set artista = (
    SELECT artista_id
    FROM artista
    WHERE nome = "Compilações, colectâneas ou artista desconhecido"
)
where artista is null


3.
update fx_comp
set compositor = (
    SELECT compositor_id
    from compositor
    where nome = "Paul McCartney"
)
where compositor=(
    select compositor_id
    from compositor
    where nome="P McCartney"
)
update fx_comp
set compositor = (
    select compositor_id
    from compositor
    where nome = "John Lennon"
)
where compositor=(
    select compositor_id
    from compositor
	where nome="J Lennon"
)

4.
update faixas2 as f
inner join (
    select 
    	album,
    	max(bitrate) as maximo
    from faixas2
    group by album
) m on f.album = m.album
set f.bitrate = m.maximo

5.
update faixas2 f
JOIN (
    SELECT
    	min(bitrate)*1.25 as novo_bitrate
    FROM faixas2
    WHERE ano <= 1973
) bitrate_calculado
join (
    SELECT
    	album,
    	sum(duracao) as duracao_total_album
    from faixas2
    group by album
) alb on f.album = alb.album
set f.bitrate = bitrate_calculado.novo_bitrate
where f.bitrate <= 192
	and f.ano BETWEEN 1974 and 1990
    and f.duracao > (0.10 * alb.duracao_total_album)


6.
with ContagemGeneros as (
    SELECT
    	f.album,
    	f.genero,
    	count(*) as total_faixas,
    	g.name as nome_genero
    from faixas f
	inner join genero g on f.genero = g.id
    group by f.album, f.genero, g.name
),
GeneroDominante as (
    select album,genero, row_number() over(partition by album order by total_faixas desc, nome genero asc) as rn
    from ContagemGeneros
)
update faixas f
inner join GeneroDominante gd on f.album=gd.album
set f.genero = gd.genero
where gd.rn = 1

7.
create table MACCA as
with PaulMcCartney as (
    select fc.faixa_id
    from fx_comp fc
    inner join compositor c on fc.compositor = c.compositor_id
    where c.nome = "Paul McCartney"
)
select
	f.titulo as titulo_faixa,
    f.faixa_numero,
    al.titulo as titulo_album,
    ar.nome as nome_artista
from faixas f
inner join PaulMcCartney cp on f.faixa_id = cp.faixa_id
inner join album al on f.album = al.album_id
inner join artista ar on al.artista=ar.artista_id

8.
ALTER TABLE fx_comp DROP FOREIGN KEY fx_comp_ibfk_1;
ALTER TABLE fx_comp ADD CONSTRAINT fx_comp_ibfk_1 FOREIGN KEY (faixa_id) REFERENCES faixas(faixa_id) ON DELETE CASCADE;
ALTER TABLE faixas DROP FOREIGN KEY faixas_ibfk_1;
ALTER TABLE faixas ADD CONSTRAINT faixas_ibfk_1 FOREIGN KEY (album) REFERENCES album(album_id) ON DELETE CASCADE;
DELETE FROM album 
WHERE album_id IN (
    SELECT id_apagar FROM (
        WITH AlbunsAIR AS (
            SELECT al.album_id 
            FROM album al
            INNER JOIN artista ar ON al.artista = ar.artista_id
            WHERE ar.nome = "AIR" AND al.titulo != "Moon Safari"
        )
        SELECT album_id AS id_apagar 
        FROM AlbunsAIR
    ) subconsulta_segura
);


9.
alter table album add collumn decada varchar(10);
update album
set decada = CASE
	when ano_album between 1961 and 1970 then "Sessenta"
    when ano_album between 1971 and 1980 then "Setenta"
    when ano_album between 1981 and 1990 then "Oitenta"
    else "Outras"
end;


insert into 2026_bd_lei.ficha4 (aluno,idresposta,resposta)
values(27226,,'');