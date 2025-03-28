function gcmd() {
  local input_text="$LBUFFER"
  local evaluated_input=$(eval "echo \"$input_text\"") # nova linha adicionada
  local command=""

  if [[ -n "$USE_OLLAMA" ]]; then
    local model="${OLLAMA_MODEL:-llama2}"
    local response=$(curl -s http://localhost:11434/api/generate -d "{
      \"model\": \"$model\",
      \"prompt\": \"You are an AI that responds with only a single terminal command. The user wants to: $evaluated_input\",
      \"stream\": false
    }")
    command=$(echo "$response" | jq -r '.response')
  else
    if [[ -z "$OPENAI_API_KEY" ]]; then
      echo "Error: OPENAI_API_KEY is not set."
      return 1
    fi
    local response=$(curl -s https://api.openai.com/v1/chat/completions \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $OPENAI_API_KEY" \
      -d '{
        "model": "gpt-4",
        "messages": [
          {
            "role": "system",
            "content": "You are an AI that responds with only a single terminal command. No explanations, no repeating user text."
          },
          {
            "role": "user",
            "content": "'"$evaluated_input"'"
          }
        ],
        "temperature": 0.2
      }')
    command=$(echo "$response" | jq -r '.choices[0].message.content')
  fi

  command=$(echo "$command" | sed '/^[[:space:]]*$/d' | tail -n 1)

  if [[ -n "$command" && "$command" != "null" ]]; then
    LBUFFER="$command"
    zle reset-prompt
    print -s -- "$command"
  else
    echo "❌ Failed to generate command."
  fi
}

zle -N gcmd

: "${GCMD_BIND:='^X'}"

bindkey "$GCMD_BIND" gcmd
