import {createDatabase} from './db.mjs';
import fs from 'node:fs/promises';
const file=process.argv[2];
if(!file){console.error('Uso: npm run query -- sql/queries/01_monthly_growth.sql');process.exit(1);}
const db=await createDatabase();
try{for(const result of await db.exec(await fs.readFile(file,'utf8')))console.table(result.rows);}finally{await db.close();}
// Cada execução usa base temporária limpa; alterações não são persistidas.
