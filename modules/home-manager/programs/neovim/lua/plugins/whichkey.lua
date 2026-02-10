local status, plugin = pcall(require,'which-key')
if not status then
    print('Error with plugin: ', plugin)
    return
end


