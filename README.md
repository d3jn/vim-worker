# Vim Worker
Simple Vim plugin to grant easy access to the shell commands you've specified.

## Installation
Just use your preferred package manager. For example, [vim-plug](https://github.com/junegunn/vim-plug):

```vim
call plug#begin(...)
...
Plug 'd3jn/vim-worker'
...
call plug#end()
```

## Usage
Create `.vim-worker` file in the directory you are working in. Each line of this file will represent one separate task (shell command). For example, this is how you can define two tasks in this file:

```
echo "It works"
vendor/bin/phpunit tests --stop-on-failure --exclude-group deprecated
```

Now in Vim press `<Leader>z` to open list with those tasks. Each task will have unique key combination assigned to it - pressing such a combination will execute corresponding command. Pressing `q` will close the list.

## Configuration
In order to change certain option add `let g:(option name) = '(new value)'` to your vimrc file. For example, `let g:worker_tasks_file='.my-tasks'`.

### `worker_tasks_file`
> (default: `'.vim-worker'`)

This option specifies were to read tasks from. You can also specify absolute path in case you want to have one tasks file shared all the time regardless of your current working directory.

### `worker_shortcut_keys`
> (default: `['a', 's', 'd', 'f', 'j', 'k', 'l', ';', 'w', 'e', 'r', 'u', 'i', 'o', 'p', 'x']`)

List of keys that will be used in key combinations generated for your tasks.

## Authors/contributors
* Serhii Yaniuk - [d3jn](https://twitter.com/d3jn_)

## License
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
