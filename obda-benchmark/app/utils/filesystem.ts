import fs from 'fs'
import path from 'path'
import { promisify } from 'util'

export function readFileSync(filePath : string) {
  let file
  try {
    file = fs.readFileSync(filePath, 'utf8')
  } catch(err) {
    file = undefined
    throw new Error(err.message)
  }
  return file
}

export function resolve(filePath : string) {
  filePath = path.resolve(filePath)

  if(fs.existsSync(filePath) === false) {
    throw new Error(`Could not resolve path ${filePath}`)
  }

  return filePath
}

const read = promisify(fs.readFile)

export const copyFile = promisify(fs.copyFile)
export const writeFile = promisify(fs.writeFile)
export const readFile = (file : string) => read(file, 'utf8')
export const readdir = promisify(fs.readdir)
export const exists = promisify(fs.exists)
export const mkdir = promisify(fs.mkdir)
