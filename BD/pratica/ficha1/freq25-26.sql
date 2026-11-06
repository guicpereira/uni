SELECT c.nome,year(d.ano_album) as "Album editado em:",e.nome
FROM faixas a
inner join fx_comp b on a.faixa_id=b.faixa_id
inner join compositor c on c.compositor_id=b.compositor
inner join album d on d.album_id=a.album
inner join artista e on e.artista_id=d.artista
where e.nome="The Beatles" AND year(d.ano_album)<1965