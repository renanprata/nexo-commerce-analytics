import { PGlite } from '@electric-sql/pglite';
import fs from 'node:fs/promises';
export async function createDatabase(path){
 const db=new PGlite(path);
 for(const name of ['01_schema.sql','02_seed.sql','03_analytics.sql']) await db.exec(await fs.readFile(new URL('../sql/'+name,import.meta.url),'utf8'));
 return db;
}
