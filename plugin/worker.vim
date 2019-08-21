" Vim Worker
" Author:     Serhii Yaniuk <serhiiyaniuk@gmail.com>
" Repository: github.com/d3jn/vim-worker
" License:    MIT License

if exists('g:worker_loaded')
    finish
endif
let g:worker_loaded = 1

if !exists('g:worker_local_tasks')
    let g:worker_local_tasks = []
endif

if !exists('g:worker_global_tasks')
    let g:worker_global_tasks = []
endif

if !exists('g:worker_task_running_strategy')
    let g:worker_task_running_strategy = 'system'
endif

if !exists('g:worker_tasks_file')
    let g:worker_tasks_file = '.vim-worker'
endif

if !exists('g:worker_shortcut_keys')
    let g:worker_shortcut_keys = ['a', 's', 'd', 'f', 'j', 'k', 'l', ';', 'w', 'e', 'r', 'u', 'i', 'o', 'p', 'x']
endif

if !exists('g:worker_map_keys')
    let g:worker_map_keys = 1
endif

if g:worker_map_keys
    nnoremap <Leader>z :call worker#ShowTasks()<CR>
endif
