# gcmd
Quick generation of terminal commands using ZSH with ChatGPT and Ollama


## Overview

When you type a request into your terminal and hit the shortcut (default: `Ctrl+X`), **gcmd** sends your prompt to a generative AI model. The AI figures out the exact command you need and returns it directly into your terminal, ready for execution.

##  Features

- Uses OpenAI GPT-4 by default (requires API key)
- Supports local models via Ollama (no API key required)
- Automatically evaluates embedded shell commands (like `$(cat file.txt)`)

## Installation

**Prerequisites:**

- Zsh shell
- `jq` and `curl` installed (`brew install jq curl`)

**1. Clone the repo or download**:

```sh
git clone <your-repo-url> ~/.zsh/gcmd
```

**2. Source the script in your** `.zshrc`

```sh
echo 'source ~/.zsh/gcmd/gcmd.zsh' >> ~/.zshrc
```

**3. Set your API key (for OpenAI)**

Add your OpenAI API key to your `.zshrc`:

```sh
export OPENAI_API_KEY="your-key-here"
```

Or use Ollama instead (optional):

```sh
export USE_OLLAMA=1
export OLLAMA_MODEL="llama2" # or your favorite local model
```

**4. Restart your terminal or reload your** `.zshrc`

```sh
source ~/.zshrc
```

## Usage

Simply type your request directly in your terminal, for example:

```sh
list all the my s3 buckets with insecure policy allowing public access 
```

Then hit `Ctrl+X` (or your customized key-binding), and **gcmd** will insert the command into your terminal prompt:

```sh
aws s3api list-buckets --query 'Buckets[].Name' | xargs -I {} aws s3api get-bucket-acl --bucket {} | grep -B 1 -A 2 AllUsers
```

### Example using embedded shell command

You can use embedded shell commands, and GCMD will evaluate them first:

```sh
extract emails from $(cat contacts.txt)
```

Hit your shortcut and that's it!

## Customizing shortcut

To customize the default shortcut, add this to your `.zshrc` before sourcing the script:

```sh
export GCMD_BIND='^G' # Ctrl+G
```

## Keep hacking

While **gcmd** is a fantastic shortcut to speed things up, remember to not fully rely on GenAI. Building a solid understanding of commands and scripts is crucial. Curiosity and experimentation are what make a great hacker, **don’t let comfort kill the creativity!**

