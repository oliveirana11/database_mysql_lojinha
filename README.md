# database_mysql_lojinha

Modelagem de banco de dados relacional em MySQL para o sistema de estoque de uma loja pequena, com 3 funcionários e controle de produtos por categoria. Desenvolvido durante aula do curso Técnico em Desenvolvimento de Sistemas (SENAC-RS).

## 🗄️ Estrutura do banco

| Tabela | Descrição |
|---|---|
| `funcionarios` | Cadastro dos funcionários da loja (nome, função) |
| `categorias` | Categorias de produtos (ex: roupas, materiais para artesanato) |
| `produtos` | Produtos à venda, vinculados a uma categoria, com controle de estoque e preço |
| `movimentacoes_estoque` | Registro de entradas e saídas de estoque, vinculado a um produto e ao funcionário responsável |

## ⚙️ Destaque: atualização automática de estoque via TRIGGER

O ponto mais interessante deste projeto é a **trigger** `atualiza_estoque`, que roda automaticamente após cada inserção em `movimentacoes_estoque`:

```sql
DELIMITER $$
CREATE TRIGGER atualiza_estoque
AFTER INSERT ON movimentacoes_estoque
FOR EACH ROW
BEGIN
    IF NEW.tipo = 'entrada' THEN
        UPDATE produtos
        SET quantidade_estoque = quantidade_estoque + NEW.quantidade
        WHERE id_produto = NEW.id_produto;
    ELSE
        UPDATE produtos
        SET quantidade_estoque = quantidade_estoque - NEW.quantidade
        WHERE id_produto = NEW.id_produto;
    END IF;
END$$
```

Sempre que uma movimentação de **entrada** ou **saída** é registrada, o estoque do produto correspondente é ajustado automaticamente — sem precisar de uma segunda instrução manual. O uso de `DELIMITER $$` foi necessário para o MySQL não confundir os `;` internos do corpo da trigger com o fim do comando.

## 📁 Arquivo

- `lojinhaUC3.sql` — script completo: criação das tabelas, inserção de dados iniciais e a trigger de atualização de estoque

## 💡 Aprendizados

Esse foi meu primeiro contato com **triggers** em MySQL — entender como automatizar regras de negócio direto no banco de dados, em vez de depender de lógica na aplicação, foi um passo importante para pensar em bancos de dados de forma mais robusta.

---

*Exercício desenvolvido durante o curso Técnico em Desenvolvimento de Sistemas — SENAC-RS.*

