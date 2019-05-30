The project is split across 3 repositories

- obdabenchmark https://git.soton.ac.uk/gk1e17/obdabenchmark
- chasestepper https://git.soton.ac.uk/jde1g16/chasestepper
- obda-converter https://github.com/JamesErrington/obda-converter

This structure is very fluid and can be easily changed if needed - probably will need to be as the 'chasestepper' name was only meant to be a placeholder, and having stuff across 2 different git systems on 3 accounts probably isn't the best

obda-converter is a JavaScript project, written using TypeScript and bundled with NPM. obdabenchmark also contains a TypeScript segment, but is mostly bash scripts, data integration tools and scenario data. chasestepper is a Java project, bundled with Gradle - this could be altered to use maven or some other system if needed but is probably not recommended? It also contains the data generator files

ChaseStepper
To build - `gradle chasestepperJar`
         - `gradle dataJar`
Can also use `gradle clean` to clear previous builds 

Obdabenchmark
To download dependencies - `yarn` - this must be done on first downloading the code, or any time the 'node_modules' folder is deleted
To build - `yarn build`
Use `sudo npm link` to update the local binary command

Obda-converter
To download dependencies - `yarn` - this must be done on first downloading the code, or any time the 'node_modules' folder is deleted
To build - `yarn build`
Use `sudo npm link` to update the local binary command

The `obdabenchmark llunatic <folder>` command is used to generate the llunatic xml files for a scenario