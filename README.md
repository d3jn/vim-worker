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
Create `.vim-worker` file in the directory you are working in. Each line of this file will represent one separate task (shell command). For example, this is how you can define three tasks in this file:

```
echo "It works"
vendor/bin/php-cs-fixer fix ./app
vendor/bin/phpunit tests --stop-on-failure --exclude-group deprecated
```

Now in Vim press `<Leader>z` (or your own mapping if configured) to open list with those tasks. Each task will have unique key combination automatically assigned to it - pressing such combination will execute corresponding command. Pressing `q` will close the list.

## Configuration
In order to change certain option add `let g:(option name) = '(new value)'` to your vimrc file. For example, `let g:worker_tasks_file='.my-tasks'`.

### Available options

#### `worker_map_keys`
> (default: `1`)

If enabled then plugin will map `<Leader>z` to show buffer with tasks list. In case you want to provide your own mapping set this option to `0` and map it yourself:
```
nnoremap <Leader>w :call worker#ShowTasks()<CR>
```

#### `worker_tasks_file`
> (default: `'.vim-worker'`)

This option specifies where to read tasks from. It is recommended to set relative path for this option since there is a separate option for global tasks (see below).

#### `worker_global_tasks_file`
> (default: none)

If defined then tasks from this file will be shown in seperate category regardless of whether local tasks file exists or not. All key combinations for it's commands are generated in the same order, but will have preceding `g` key to avoid conflicts with local ones.

#### `worker_autoclose_tasks_list`
> (default: 1)

If enabled this option makes plugin close tasks list buffer automatically once you run a task from it.

#### `worker_task_running_strategy`
> (default: `'system'`)

Choose how your tasks will be run from your Vim environment. Supported strategies for now are:
* `system` - plugin will execute your task's command via `system()` function call and echo the result in Vim;
* `termopen` - plugin will create new buffer, open terminal in it and execute task's command using `termopen()` function. Pressing `q` will close the buffer.

#### `worker_termopen_close_on_success`
> (default: 1)

This option only works for `termopen` task running strategy. If enabled the plugin will automatically close terminal buffer once running task finishes with 0 exit code (success).

#### `worker_shortcut_keys`
> (default: `['a', 's', 'd', 'f', 'j', 'k', 'l', ';', 'w', 'e', 'r', 'u', 'i', 'o', 'p', 'x']`)

List of keys that will be used in key combinations generated for your tasks.

## Authors/contributors
* Serhii Yaniuk - [d3jn](https://twitter.com/iamdejn)

## License
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
