import { exec } from 'child_process'

export default async function execAsync(command : string) : Promise<string> {
  return new Promise((resolve, reject) => {
    exec(command, (error, stdout, stderr) => {
      if(error) {
        reject(error)
        return
      }
      resolve(stdout)
    })
  })
}
