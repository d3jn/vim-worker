" Vim Worker
" Author:     Serhii Yaniuk <serhiiyaniuk@gmail.com>
" Repository: github.com/d3jn/vim-worker
" License:    MIT License

function! worker#ShowTasks() abort
    let global_tasks_count = 0
    let tasks_count = 0

    if exists('g:worker_global_tasks_file') && filereadable(g:worker_global_tasks_file)
        let global_tasks_file = g:worker_global_tasks_file
        let g:worker_global_tasks = s:GetTasks(global_tasks_file, g:worker_shortcut_keys)
        let global_tasks_count = len(g:worker_global_tasks)
    endif
    if filereadable(g:worker_tasks_file)
        let tasks_file = g:worker_tasks_file
        let g:worker_local_tasks = s:GetTasks(tasks_file, g:worker_shortcut_keys)
        let tasks_count = len(g:worker_local_tasks)
    endif

    if (global_tasks_count + tasks_count) == 0 
        echo 'Vim-Worker: Tasks not found!'
        return
    endif

    new
    setlocal noswapfile
    setlocal buftype=nofile
    setlocal bufhidden=wipe
    setlocal nonumber
    setlocal norelativenumber

    syntax on
    syntax match WorkerHeading /\v^ Tasks / 
    syntax match WorkerHeading /\v^ Global /
    syntax match WorkerPoint /\v^ -/
    syntax region WorkerShortcut start=/\[ / skip=/\v\\./ end=/ \]/

    highlight link WorkerHeading Keyword
    highlight link WorkerPoint Operator
    highlight link WorkerShortcut String

    let buffer_size = 0

    if tasks_count > 0
        call s:RenderTasks(1, 'Tasks', g:worker_local_tasks, 0)
        let buffer_size = tasks_count + 1
    endif

    if global_tasks_count > 0
        let global_tasks_starting_line = 1
        let buffer_size = global_tasks_count + 1

        if tasks_count > 0
            call setline(tasks_count + 2, '')
            let global_tasks_starting_line = tasks_count + 3

            let buffer_size = tasks_count + global_tasks_count + 3
        endif

        call s:RenderTasks(global_tasks_starting_line, 'Global', g:worker_global_tasks, 1)
    endif

    execute 'resize ' . (buffer_size + 1)
    setlocal nomodifiable

    nnoremap <silent> <buffer> q :bdelete!<CR>
endfunction

function! worker#RunGlobalTask(task_id)
    call s:RunTask(g:worker_global_tasks, a:task_id, g:worker_task_running_strategy)
endfunction

function! worker#RunLocalTask(task_id)
    call s:RunTask(g:worker_local_tasks, a:task_id, g:worker_task_running_strategy)
endfunction

function! s:RenderTasks(starting_from_line, heading, tasks, should_be_global)
    let shortcut_prefix = ''
    let task_running_function = 'worker#RunLocalTask'
    if a:should_be_global
        let shortcut_prefix = 'g'
        let task_running_function = 'worker#RunGlobalTask'
    endif

    let line = a:starting_from_line
    call setline(line, ' ' . a:heading . ' (' . len(a:tasks) . ')')

    let line += 1
    let index = 0
    for task in a:tasks
        let shortcut = shortcut_prefix . task.shortcut

        call setline(line, ' - [ ' . shortcut . ' ] ' . task.command)
        let line += 1

        execute 'nnoremap <buffer> ' . shortcut . ' :call ' . task_running_function . '(' . index . ')<CR>'
        let index += 1
    endfor
endfunction

function! s:TermopenOnStdOut(job_id, data, event)
    execute "normal! G"
endfunction

function! s:TermopenOnExit(job_id, data, event)
    if g:worker_termopen_close_on_success == 1
        if a:data == 0
            bdelete!
        endif
    endif
endfunction

function! s:RunTask(tasks, task_id, strategy)
    let task = get(a:tasks, a:task_id, {})
    if task == {}
        echoerr "Vim-Worker: Mapped task #" . a:task_id . " no longer exists in the list of tasks!"
        return
    endif

    if g:worker_autoclose_tasks_list == 1
        bdelete!
    endif

    if a:strategy == 'system'
        echo system(task.command)
    elseif a:strategy == 'termopen'
        new
        setlocal noswapfile
        setlocal buftype=nofile
        setlocal bufhidden=wipe
        setlocal nonumber
        setlocal norelativenumber
        nnoremap <silent> <buffer> q :bdelete!<CR>

        call termopen(task.command, {'on_stdout': function('s:TermopenOnStdOut'), 'on_exit': function('s:TermopenOnExit')})
    else
        echoerr "Vim-Worker: Unknown strategy '" . a:strategy . "'! Can't run the task!"
        return
    endif
endfunction

function! s:GetTasks(file, shortcut_keys)
    let cmds = readfile(a:file)
    let tasks = []

    let i = 0
    let shortcut_length = s:GetShortcutLength(len(cmds), len(a:shortcut_keys))
    for cmd in cmds
        let tasks = add(tasks, {'command': cmd, 'shortcut': s:GetNextShortcut(i, a:shortcut_keys, shortcut_length)})
        let i += 1
    endfor

    return tasks
endfunction

function! s:GetNextShortcut(number, shortcut_keys, shortcut_length)
    let shortcut = ''

    let base = len(a:shortcut_keys)
    let n = a:number
    while 1
        let key_index = float2nr(fmod(n, base))
        let n = n / base

        let shortcut = get(a:shortcut_keys, key_index) . shortcut

        if n == 0
            break
        endif
    endwhile

    let shortage = a:shortcut_length - strlen(shortcut) 
    while shortage > 0
        let shortcut = get(a:shortcut_keys, 0) . shortcut
        let shortage -= 1
    endwhile

    return shortcut
endfunction

function! s:GetShortcutLength(number, base)
    let length = 1
    let comp = a:base
    while a:number >= comp
        let comp = comp * a:base
        let length += 1
    endwhile

    return length
endfunction
