# PlainTimer
You don't need a fancy app to keep track of your time.

PlainTimer helps me keep track of the time spend in some projects by simply managing a plain text file in the project folderrs. I've been doing this for some time now manually so I decided to build a simple tool that automated some of the actions.

# Usage

Just run `timer` and it will show a list of accepted commands.

- `log 1h "Description of the task."`: Adds a new entry to the text file.
- `start`: Run this when you are starting a new task. It will add a temporary entry in the text file to remember the start time.
- `end "Description of the task."`: Run when you finished the task. It uses the previously stored temporary entry to calculate the duration of the task and creates a new entry in the text file.
- `show`: Just displays the content of the text file.
- `help`: Displays the availalbe commands.

# Author

Alejandro Martinez | http://alejandromp.com | [@alexito4](https://twitter.com/alexito4)
