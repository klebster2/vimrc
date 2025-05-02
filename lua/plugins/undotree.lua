return {
	---@type string
	"mbbill/undotree",
	---@type string
	run = 'vim -u NONE -c "helptags undotree/doc" -c q',
	---@type function
	config = function()
		vim.cmd([[
    if has('persistent_undo')
        " define a path to store persistent undo files.
        let target_path = expand('~/.config/vim-persisted-undo/')
        " create dir and any parent dirs if loc doesn't exist
        if !isdirectory(target_path)
            call system('mkdir -p ' . target_path)
        endif
        " point Vim to the defined undo directory.
        let &undodir = target_path
        " finally, enable undo persistence.
        set undofile
    endif
    ]])
	end,
}
