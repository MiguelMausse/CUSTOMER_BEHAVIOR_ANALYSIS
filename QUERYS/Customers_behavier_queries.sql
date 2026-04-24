SELECT * FROM customer LIMIT 100;
--P1. Qual é a receita total gerada por clientes do sexo masculino em comparação com clientes do sexo feminino?
SELECT gender, SUM(purchase_amount) as receita FROM customer 
GROUP BY gender;

--P2. Quais clientes usaram um desconto, mas ainda gastaram mais do que o valor médio de compra?
SELECT customer_id, purchase_amount from customer
where discount_applied = 'Yes' and purchase_amount > (select AVG(purchase_amount) from customer) LIMIT 100;

--P3. Quais são os 5 produtos com a maior classificação média de avaliação?
SELECT item_purchased, ROUND(AVG(review_rating::numeric),2) as Average_Product_Item
from customer 
group by item_purchased
order by avg(review_rating) desc
limit 5;

--P4. Compare os valores médios de compra entre o frete padrão e o frete expresso.
SELECT shipping_type, ROUND(AVG(purchase_amount::numeric),2) from customer
where shipping_type in ('Standard', 'Free Shipping')
group by shipping_type

--P5. Os clientes assinantes gastam mais? Compare o gasto médio e a receita total
-- entre assinantes e não assinantes.
SELECT subscription_status, COUNT(customer_id) as total_customers,
ROUND(AVG(purchase_amount),2) as gasto_medio,
ROUND(SUM(purchase_amount),2) as receita_total
from customer
group by subscription_status
order by receita_total, gasto_medio desc;

--P6. Quais são os 5 produtos com a maior porcentagem de compras com descontos aplicados?

SELECT item_purchased,
ROUND(100.0 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END)/COUNT(*),2) AS discount_rate
FROM customer
GROUP BY item_purchased
ORDER BY discount_rate DESC
LIMIT 5;

--P7. Segmente os clientes em Novos, Recorrentes e Fiéis com base no número total de compras anteriores e mostre a contagem de cada segmento.
--P8. Quais são os 3 produtos mais comprados em cada categoria?
WITH item_counts AS (
    SELECT category,
           item_purchased,
           COUNT(customer_id) AS total_orders,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY COUNT(customer_id) DESC) AS item_rank
    FROM customer
    GROUP BY category, item_purchased
)
SELECT item_rank,category, item_purchased, total_orders
FROM item_counts
WHERE item_rank <=3;

--P9. Os clientes que compram repetidamente (mais de 5 compras anteriores) também têm probabilidade de assinar?

SELECT subscription_status,
       COUNT(customer_id) AS repeat_buyers
FROM customer
WHERE previous_purchases > 5
GROUP BY subscription_status;

--P10. Qual é a contribuição de cada faixa etária para a receita?
SELECT age_group , SUM(purchase_amount) as receita_total
from customer
group by age_group
order by receita_total desc;

SELECT * FROM 	customer;