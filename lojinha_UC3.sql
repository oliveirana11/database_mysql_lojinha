create database lojinha;
use lojinha;
create table funcionarios (
id_funcionario int not null auto_increment primary key,
nome varchar (100) not null,
funcao varchar (50) not null
);

insert into funcionarios (nome, funcao) values
('João Silva', 'Gerente'),
('Marcos Palmeiras', 'Caixa'),
('Ana Maria Aparecida', 'Vendedora');

create table categorias (
id_categoria int auto_increment primary key,
nome_categoria varchar(100) not null
);

insert into categorias (nome_categoria) values
('Roupas variadas'),
('Materiais para artesanato');

select*from categorias;

create table produtos(
id_produto int auto_increment primary key not null,
nome_produto varchar(100) not null,
id_categoria int not null,
quantidade_estoque int not null,
preco_unitario decimal(10,2),
foreign key (id_categoria)
references categorias(id_categoria)
);

Create table movimentacoes_estoque(
id_movimentacao int auto_increment primary key not null,
id_produto int not null,
id_funcionario int not null,
tipo enum('entrada','saida') not null,
quantidade int not null,
data_hora datetime,
foreign key (id_produto) 
references produtos(id_produto),
foreign key (id_funcionario) 
references funcionarios(id_funcionario)
);

# Para atualizar o estoque automaticamente a cada nova movimentação
# o programa estava se confundindo com o tanto de ; que havia dentro do trigger;
# a solução é esse delimiter, que avisa que agora o delimitador é o $$
delimiter $$
create trigger atualiza_estoque
after insert on movimentacoes_estoque
for each row
begin
if new.tipo='entrada' then
update produtos
set quantidade_estoque = quantidade_estoque + new.quantidade
where id_produto = new.id_produto;
else
update produtos
set quantidade_estoque = quantidade_estoque - new.quantidade
where id_produto = new.id_produto;
end if;
end$$




