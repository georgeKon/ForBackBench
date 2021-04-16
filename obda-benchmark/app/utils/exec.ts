import { exec } from 'child_process'

export default async function execAsync(command : string) : Promise<string> {
  return new Promise((resolve, reject) => {
    exec(command, { maxBuffer: 1024 * 500 }, (error, stdout, stderr) => {
      if(error) {
        reject(error)
        return
      }
      resolve(stdout)
    })
  })
}
