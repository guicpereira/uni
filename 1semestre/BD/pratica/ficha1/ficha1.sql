1.
select *
from album

insert into 2026_bd_lei.ficha1 (aluno,idresposta,resposta)
values(27226,1,'select *
from album');

2.
select titulo,bitrate,duracao,ano
from faixas;

insert into 2026_bd_lei.ficha1 (aluno,idresposta,resposta)
values(27226,2,'select titulo,bitrate,duracao,ano
from faixas;
');



3.
select a.titulo,a.duracao
from faixas a
where bitrate>200 or bitrate<192

insert into 2026_bd_lei.ficha1 (aluno,idresposta,resposta)
values(27226,3,'select a.titulo,a.duracao
from faixas a
where bitrate>200 or bitrate<192');


4.

6.
select titulo
from faixas
where titulo like "Y%S"
SELECT titulo,bitrate,duracao,sec_to_time(duracao)
FROM faixas a
where a.faixa_numero=1 and sec_to_time(duracao)>'00:05:00' and sec_to_time(duracao)<'00:07:00' and bitrate in (128,256,320)

insert into 2026_bd_lei.ficha1 (aluno,idresposta,resposta)
values(27226,4,"SELECT titulo,bitrate,duracao,sec_to_time(duracao)
FROM faixas a
where a.faixa_numero=1 and sec_to_time(duracao)>'00:05:00' and sec_to_time(duracao)<'00:07:00' and bitrate in (128,256,320)");

5.
select titulo,from_unixtime(criacao),from_unixtime(alteracao)
from faixas

7.
select titulo
from faixas
where titulo like "Y%S"

insert into 2026_bd_lei.ficha1 (aluno,idresposta,resposta)
values(27226,7,'select titulo
from faixas
where titulo like "Y%S"');


8.
select titulo
from faixas
where titulo like '__v%' or '_____v%';

insert into 2026_bd_lei.ficha1 (aluno,idresposta,resposta)
values(27226,8,'select titulo
from faixas
where titulo like "__v%" or "_____v%";');

9.
select titulo
from faixas
where titulo like "%love%" and "%my%"

insert into 2026_bd_lei.ficha1 (aluno,idresposta,resposta)
values(27226,9,'select titulo
from faixas
where titulo like "%love%" and "%my%"');

10.
select titulo, criacao, duracao
from faixas
order by criacao, duracao;

insert into 2026_bd_lei.ficha1 (aluno,idresposta,resposta)
values(27226,10,'select titulo, criacao, duracao
from faixas
order by criacao, duracao;');

11.
select titulo,duracao
from faixas
order by duracao
limit 10

insert into 2026_bd_lei.ficha1 (aluno,idresposta,resposta)
values(27226,11,'select titulo,duracao
from faixas
order by duracao
limit 10');

12.
SELECT titulo,bitrate,alteracao
from faixas
where alteracao % 2 = 0
order by bitrate
limit 5;

insert into 2026_bd_lei.ficha1 (aluno,idresposta,resposta)
values(27226,12,'SELECT titulo,bitrate,alteracao
from faixas
where alteracao % 2 = 0
order by bitrate
limit 5;');

13.
select titulo,duracao,bitrate
from faixas
where bitrate>256
order by duracao desc
limit 10;

insert into 2026_bd_lei.ficha1 (aluno,idresposta,resposta)
values(27226,13,'select titulo,duracao,bitrate
from faixas
where bitrate>256
order by duracao desc
limit 10;');


14.
SELECT b.titulo, b.faixa_numero
FROM faixas b JOIN album a ON b.album = a.album_id
WHERE a.titulo = "Revolver";

insert into 2026_bd_lei.ficha1 (aluno,idresposta,resposta)
values(27226,14,'SELECT b.titulo, b.faixa_numero
FROM faixas b JOIN album a ON b.album = a.album_id
WHERE a.titulo = "Revolver";');

15.
SELECT a.titulo,b.titulo,c.nome
FROM faixas a 
inner join album b on a.album=b.album_id
inner join artista c on b.artista=c.artista_id
where c.nome = "Zero 7";

insert into 2026_bd_lei.ficha1 (aluno,idresposta,resposta)
values(27226,15,'SELECT a.titulo,b.titulo,c.nome
FROM faixas a 
inner join album b on a.album=b.album_id
inner join artista c on b.artista=c.artista_id
where c.nome = "Zero 7";');

16.
SELECT a.titulo,b.titulo,c.nome,year(from_unixtime(a.alteracao)) as "Ano de edicao"
FROM faixas a
INNER JOIN album b on a.album = b.album_id
INNER JOIN artista c on b.artista = c.artista_id
WHERE c.nome="Archive" and year(from_unixtime(a.alteracao)) >= 2000
ORDER BY year(from_unixtime(a.alteracao)) ASC

insert into 2026_bd_lei.ficha1 (aluno,idresposta,resposta)
values(27226,16,'SELECT a.titulo,b.titulo,c.nome,year(from_unixtime(a.alteracao)) as "Ano de edicao"
FROM faixas a
INNER JOIN album b on a.album = b.album_id
INNER JOIN artista c on b.artista = c.artista_id
WHERE c.nome="Archive" and year(from_unixtime(a.alteracao)) >= 2000
ORDER BY year(from_unixtime(a.alteracao)) ASC');

17.
SELECT b.titulo,d.nome,sec_to_time(b.duracao)
FROM album a
INNER JOIN faixas b on b.album=a.album_id
INNER JOIN fx_comp c on b.faixa_id=c.faixa_id
INNER JOIN compositor d on c.compositor=d.compositor_id
WHERE (d.nome="Benny Andersson" or d.nome="B. Tommy Andersson") and sec_to_time(b.duracao)>"00:05:00"

insert into 2026_bd_lei.ficha1 (aluno,idresposta,resposta)
values(27226,17,'SELECT b.titulo,d.nome,sec_to_time(b.duracao)
FROM album a
INNER JOIN faixas b on b.album=a.album_id
INNER JOIN fx_comp c on b.faixa_id=c.faixa_id
INNER JOIN compositor d on c.compositor=d.compositor_id
WHERE (d.nome="Benny Andersson" or d.nome="B. Tommy Andersson") and sec_to_time(b.duracao)>"00:05:00"');