import assert from 'node:assert/strict';
import fs from 'node:fs/promises';
import {createDatabase} from '../scripts/db.mjs';
const db=await createDatabase();let checks=0;
async function rows(q){return (await db.query(q)).rows;}
async function rejects(q){await assert.rejects(()=>db.exec(q));checks++;}
try{
 assert.equal(Number((await rows('SELECT count(*) n FROM commerce.customers'))[0].n),240);checks++;
 assert.equal(Number((await rows('SELECT count(*) n FROM commerce.orders'))[0].n),1800);checks++;
 assert.equal(Number((await rows('SELECT count(*) n FROM commerce.order_items'))[0].n),3600);checks++;
 await rejects("INSERT INTO commerce.categories(name) VALUES('Casa')");
 await rejects("INSERT INTO commerce.order_items VALUES(999999,1,1,10,5,0)");
 await rejects("UPDATE commerce.order_items SET quantity=0 WHERE order_id=1");
 await rejects("UPDATE commerce.order_items SET discount=999999 WHERE order_id=1");
 await rejects("UPDATE commerce.payments SET paid_at=NULL WHERE status='approved'");
 await rejects("INSERT INTO commerce.returns(order_id,product_id,quantity,refund_amount,returned_at,reason) SELECT i.order_id,i.product_id,9999,1,o.ordered_at+1,'teste' FROM commerce.order_items i JOIN commerce.orders o USING(order_id) WHERE o.status='completed' AND NOT EXISTS(SELECT 1 FROM commerce.returns r WHERE r.order_id=i.order_id AND r.product_id=i.product_id) LIMIT 1");
 for(const file of (await fs.readdir(new URL('../sql/queries/',import.meta.url))).sort()){
  const result=await db.exec(await fs.readFile(new URL('../sql/queries/'+file,import.meta.url),'utf8'));
  if(file.startsWith('07_'))assert.equal(result[0].rows.length,0);
  if(file.startsWith('01_'))assert.equal(result[0].rows.length,12);
  if(file.startsWith('04_')){for(const row of result[0].rows)assert(Number(row.retention_pct)<=100);}
  checks++;
 }
 const totals=(await rows(`SELECT (SELECT sum(net_revenue) FROM analytics.sales_items) a,(SELECT sum(net_revenue) FROM analytics.sales_orders) b,(SELECT sum(net_revenue) FROM analytics.monthly_kpis) c`))[0];
 assert.equal(totals.a,totals.b);assert.equal(totals.b,totals.c);checks++;
 const before=await rows('SELECT sum(list_price) s FROM commerce.products');
 await db.exec(await fs.readFile(new URL('../sql/04_transaction_lab.sql',import.meta.url),'utf8'));
 assert.deepEqual(await rows('SELECT sum(list_price) s FROM commerce.products'),before);checks++;
 await db.exec(await fs.readFile(new URL('../sql/05_performance_lab.sql',import.meta.url),'utf8'));checks++;
 const kpis=await rows('SELECT * FROM analytics.monthly_kpis ORDER BY month');
 await fs.mkdir(new URL('../docs/',import.meta.url),{recursive:true});
 await fs.writeFile(new URL('../docs/sample-results.json',import.meta.url),JSON.stringify({dataset:'synthetic-v1',checks,monthly_kpis:kpis},null,2)+'\n');
 console.log(checks+' verificações passaram: integridade, regras de devolução, consultas, reconciliação e rollback.');
}finally{await db.close();}
