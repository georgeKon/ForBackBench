import fs from 'fs'

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
