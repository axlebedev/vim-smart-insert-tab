A Vim plugin for easier indenting line from insert mode  
(sublime-like behavior)

# Usage

Press `<Tab>` in insert mode.

![Example of workflow](https://github.com/alexey-broadcast/vim-smart-insert-tab/blob/master/doc/example.gif)


# Configuration

The simplest way to make it work, map `<Tab>` key: 
```
inoremap <expr><Tab> SmartInsertTab()
```

Don't forget about other plugins that use `<Tab>`.
e.g. with _neocomplete_:
```
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : SmartInsertTab()
```

# Contribution

Contributions and pull requests are welcome.

# License

MIT
