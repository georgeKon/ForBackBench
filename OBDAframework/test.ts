import fs from 'fs'
import path from 'path'
import OBDAconverter from './app/utils/converter'
import { loadDataCmd } from './app/commands'

loadDataCmd('../scenarios/LUBM/schema.txt', '../scenarios/LUBM/data/')
