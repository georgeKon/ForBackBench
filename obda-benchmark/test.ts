import { runBenchmark } from './app/commands'

async function run() {
  const result = await runBenchmark(
    '../scenarios/LUBM/schema.txt', '../scenarios/LUBM/cb-data/', '../scenarios/LUBM/Q1.rq',
    '../scenarios/LUBM/ontology.owl', 'rapid', { clean: true, format: 'rapid', common: false, tgd: false })
}

run()
