# iGPT
Interactive GPT for text completions models

Welcome to iGPT, one way to call OpenAI's GPT models from Bash! This script allows you to easily query the OpenAI API from anywhere, using the text completions models available.

## Dependencies

**bash**: The born again shell. An sh-compatible shell to run sh scripts.

**curl**: A tool to transfer data from or to a server

**python**: To convert the json reponses

## Installation

Just download this script and run in your terminal by typing

`bash igpt.sh` 

![figura 000](https://raw.githubusercontent.com/jhonesto/files/main/images/iGPT/gpt000.png)

or make it executable and run it once

`chmod +x igpt.sh` 

and then just run `./igpt.sh`

![figura 001](https://raw.githubusercontent.com/jhonesto/files/main/images/iGPT/gpt001.png)

## Docker Image

You can download this image from [docker hub](https://hub.docker.com/r/jhonesto/igpt)

## Usage

To get started, you need to have an [OpenAI API Key](https://platform.openai.com/account/api-keys)

open your terminal or terminal emulator and run 

`bash igpt.sh`

If your TOKEN (**OpenAI API Key**) is empty you must informing before using. 

![figura 002](https://raw.githubusercontent.com/jhonesto/files/main/images/iGPT/gpt002.png)

or run the program passing the TOKEN value

`TOKEN=YOUR-TOKEN-HERE bash igpt.sh`

![figura 003](https://raw.githubusercontent.com/jhonesto/files/main/images/iGPT/gpt003.png)

Now you can make prompts to OpenAI. Enjoy it!

![figura 003a](https://raw.githubusercontent.com/jhonesto/files/main/images/iGPT/gpt003a.png)

### Default values

| FIELD | DESCRIPTION |
| --- | --- |
| TOKEN | (OpenAI API Key) Default is empty,  please provide a token before starting to prompt. |
| MODEL | text-davinci-003 |
| TEMPERATURE | 1.0 |
| MAX_TOKENS | 500 |

You can also start this program changing the default values:

```shell

TOKEN=TOKEN-HERE MODEL=YOUR-MODEL TEMPERATURE=0.9 MAX_TOKENS=1000  bash igpt.sh

```

![figura 004](https://raw.githubusercontent.com/jhonesto/files/main/images/iGPT/gpt004.png)


### Interactive menu

Just type `?` to interact with the menu and you'll see these following options:

| OPTION | DESCRIPTION |
| --- | --- |
| 1) Interact to ChatGPT |  Return to  prompt |
| 2) Insert Tokens | To change or insert a new Token |
| 3) Change Model | To change text completion models |
| 4) Change Temperature | To change the temperature of your response, from 0 to 2. |
| 5) Change Max Tokens | To change the max. tokens, according to the model. |
| 6) Quit | To exit the app. |

What would you like to do? [1-6]

![figura 005](https://raw.githubusercontent.com/jhonesto/files/main/images/iGPT/gpt005.png)

You can choose an option from the list and follow the instructions in the terminal.

![figura 006](https://raw.githubusercontent.com/jhonesto/files/main/images/iGPT/gpt006.png)

Remember your [OpenAI API Key](https://platform.openai.com/account/api-keys) must be valid.

![figura 007](https://raw.githubusercontent.com/jhonesto/files/main/images/iGPT/gpt007.png)

## Tip

If you don't like the colors or want to try new colors, you can change the INPUT_COLOR, OUTPUT_COLOR, INFO_COLOR and ERROR_COLOR parameters according to the ASCII table.

## Limitations

This script runs in a text completion mode from OpenAI's API, and I'm working on it to use other endpoints.

This script runs on Linux. I haven't tested it on Windows, so I recommend using it with WSL.

## Contributing
If you notice any issues or want to contribute to the project, feel free to create an issue or a pull request on the Github repository. I appreciate all contributions and feedback!
