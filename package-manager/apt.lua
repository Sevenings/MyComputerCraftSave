local command = arg[1]

local repository = 'https://raw.githubusercontent.com/Sevenings/MyComputerCraftSave/main/'

-- apt get <package>
if command == 'get' then
    local pkg = arg[2]
    shell.run('wget', repository+pkg)

-- apt update
elseif command == 'update' then


-- apt remove <package>
elseif command == 'remove' then


-- apt list 
elseif command == 'list' then


-- apt search <package>
elseif command == 'search' then


-- help
else
    print('Help:')
    print('  - apt get <package>')
    print('  - apt update')
    print('  - apt remove <package>')
    print('  - apt list')
    print('  - apt search <package>')
end

