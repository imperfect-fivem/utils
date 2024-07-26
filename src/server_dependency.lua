AddEventHandler('onResourceStarting', function (resource)
    for index = 0, GetNumResourceMetadata(resource, 'server_dependency') do
        local dependencyResource = GetResourceMetadata(resource, 'server_dependency', index)
        if not dependencyResource then goto nextIteration end
        if not GetResourceMetadata(dependencyResource, 'server_only', 0) then
            print(("^3%s is not a server-only resource, use dependency instead of server_dependency.^7"):format(dependencyResource))
        end
        local dependencyState = GetResourceState(dependencyResource)
        if dependencyState == "missing" then
            print(("Could not find server dependency %s for resource %s."):format(dependencyResource, resource))
            CancelEvent()
        elseif dependencyState ~= "started" and dependencyState ~= "starting" then
            StartResource(dependencyResource)
        end
        ::nextIteration::
    end
end)
