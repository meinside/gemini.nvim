# gemini.nvim

A neovim plugin for generating texts using Google [Gemini APIs](https://ai.google.dev/tutorials/rest_quickstart).

## Installation

### lazy.nvim

```lua

  {
    'meinside/gemini.nvim', config = function()
      require'gemini'.setup {
        -- (default values)
        configFilepath = '~/.config/gemini.nvim/config.json',
        timeout = 30 * 1000,
        verbose = false,
      }
    end,
    dependencies = { { 'nvim-lua/plenary.nvim' } },
  },

```

## Configuration

Get your API key from [here](https://makersuite.google.com/app/apikey)

and create a config file at path `configFilepath` with following content:

```json
{
  "api_key": "AI0123456789-abcdefg-XYZW"
}
```

## Usage

### Insert Generated Text At Current Cursor Position

Run following command with a prompt:

```
:GeminiGenerate your prompt text here
```

It will generate a text from your prompt and insert it at the current cursor position.

### Generate Text With Selected Range As A Prompt

Select a range of text with visual block, and run following command:

```
:'<,'>GeminiGenerate
```

then it will generate a text from the selected text as a prompt, and replace the range with the generated one.

### Replace Selected Range With Generated Text

Select a range of text with visual block, and run following command with a prompt:

```
:'<,'>GeminiGenerate your prompt text here
```

then it will generate a text from both the selected text and prompt, and replace the range with the generated one.

## Todos / Improvements

- [ ] Handle multiple number of candidates and content parts.
- [ ] Add nice UIs for comparing & applying generated texts.

## License

MIT

