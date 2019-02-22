import { loadDataCmd } from './app/commands'

function run() {
  loadDataCmd('../scenarios/LUBM/schema.txt', '../scenarios/LUBM/data/', { clean: true, tgd: false })
}

run()
