---@param netId integer
---@param attempts? integer 10 by default
---@param attemptDelayMs? integer 500 by default
---@return integer?
function WaitEntityWithNetworkIdToExistLocally(netId, attempts, attemptDelayMs)
    local exists = false
    if not attempts then attempts = 10 end
    if not attemptDelayMs then attemptDelayMs = 500 end
    while not exists and attempts > 0 do
        exists = NetworkDoesEntityExistWithNetworkId(netId)
        attempts = attempts - 1
        Wait(attemptDelayMs)
    end
    return NetworkGetEntityFromNetworkId(netId)
end
