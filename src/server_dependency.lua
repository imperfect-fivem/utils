local metadataKeys = { 'server_dependency', 'server_dependencie' --[[server_dependencies without s]] }
AddEventHandler('onResourceStarting', function (resource)
    for _, metadataKey in ipairs(metadataKeys) do
        for index = 0, GetNumResourceMetadata(resource, metadataKey) do
            local dependencyResource = GetResourceMetadata(resource, metadataKey, index)
            if not dependencyResource then goto nextIteration end
            local dependencyState = GetResourceState(dependencyResource)
            if dependencyState == "missing" then
                print(("Could not find server dependency %s for resource %s."):format(dependencyResource, resource))
                CancelEvent()
                goto nextIteration
            end
            if not GetResourceMetadata(dependencyResource, 'server_only', 0) then
                print(("^3%s is not a server-only resource, use dependency instead of server_dependency.^7"):format(dependencyResource))
            end
            if dependencyState ~= "started" and dependencyState ~= "starting" then
                StartResource(dependencyResource)
            end
            ::nextIteration::
        end
    end
end)
