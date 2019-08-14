" Vim Worker
" Author:     Serhii Yaniuk <serhiiyaniuk@gmail.com>
" Repository: github.com/d3jn/vim-worker
" License:    MIT License

function! worker#ShowTasks()
    let tasks = s:GetTasks(g:worker_tasks_file, g:worker_shortcut_keys)
    let count = len(tasks)

    new
    setlocal noswapfile
    setlocal buftype=nofile
    setlocal bufhidden=wipe
    setlocal nonumber
    setlocal norelativenumber

    call setline(1, " List of tasks (" . count . ")")

    let line = 2
    for task in tasks
        call setline(line, " - [ " . task.shortcut . " ] " . task.command)
        let line += 1

        execute "nnoremap <buffer> " . task.shortcut . " :!" . task.command . "<CR>"
    endfor

    execute "resize " . (count + 1)
    setlocal nomodifiable

    nnoremap <silent> <buffer> q :bdelete!<CR>
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
