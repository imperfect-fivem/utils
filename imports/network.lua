---@async
---@param netId integer
---@param attempts? integer 10 by default
---@param attemptDelayMs? integer 500 by default
---@return integer?
function WaitEntityWithNetworkIdToExistLocally(netId, attempts, attemptDelayMs)
    local exists = NetworkDoesEntityExistWithNetworkId(netId)
    if not attempts then attempts = 10 end
    if not attemptDelayMs then attemptDelayMs = 500 end
    while not exists and attempts > 0 do
        attempts -= 1
        Wait(attemptDelayMs)
        exists = NetworkDoesEntityExistWithNetworkId(netId)
    end
    if exists then return NetworkGetEntityFromNetworkId(netId) end
end

---@async
---@param netId integer
---@param attempts? integer 10 by default
---@param attemptDelayMs? integer 50 by default
---@return boolean
function NetworkWaitUntilHaveControlOfNetworkId(netId, attempts, attemptDelayMs)
    NetworkRequestControlOfNetworkId(netId)
    local hasControl = NetworkHasControlOfNetworkId(netId)
    if not attempts then attempts = 10 end
    if not attemptDelayMs then attemptDelayMs = 50 end
    while not hasControl and attempts > 0 do
        attempts -= 1
        Wait(attemptDelayMs)
        hasControl = NetworkHasControlOfNetworkId(netId)
    end
    return hasControl
end
