--[[ 

--- INFORMAÇÕES ---

Comando: /dc.
Descrição: Pega o discord do jogador mais próximo, se não houver ele tentara pegar o ID do jogador colocado nos argumentos primeiro vendo se ele está na cidade e depois no banco de dados.
Desenvolvedor: Striker

]]--

-----------------------------------------------------------------------------------------------------------------------------------------
--[ /DC ]--------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("vRP/identifier_byuserid","SELECT identifier FROM vrp_user_ids WHERE user_id = @user_id")

RegisterCommand("dc", function (source, args)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id, "moderador.permissao") then
        if args[1] then
            local nuser_id = tonumber(args[1])
            local nsource = vRP.getUserSource(nuser_id)

            if nsource then
    
                for k, v in pairs(GetPlayerIdentifiers(nsource)) do
                    if string.find(v, "discord") then

                        local dc = string.gsub(v, "discord:", "")
                        vRP.prompt(source, 'Discord do ID '..nuser_id..". (In-game)", '<@'..dc..'>')

                        return
                    end
                end
    
                TriggerClientEvent("Notify", source, "negado", "O ID <b>"..tonumber(args[1]).."</b> não possui <b>discord vinculado a conta</b>.")
            else
                local rows = vRP.query("vRP/identifier_byuserid", { user_id = nuser_id })

                if #rows > 0 then

                    for k, v in pairs(rows) do
                        if string.find(v["identifier"], "discord") then

                            local dc = string.gsub(v["identifier"], "discord:", "")
                            vRP.prompt(source, 'Discord do ID '..nuser_id..". (Não está in-game)", '<@'..dc..'>')

                            return
                        end
                    end

                    TriggerClientEvent("Notify", source, "negado", "O ID <b></b> não possui <b>discord vinculado a conta</b>. (MYSQL)")
                else
                    TriggerClientEvent("Notify", source, "negado", "O ID <b></b> não possui <b>conta criada</b> no banco de dados ainda.")
                end
            end
        else

            local nplayer = vRPclient.getNearestPlayer(source, 3)
            local nplayer_id = vRP.getUserId(nplayer)

            if nplayer then
                for k, v in pairs(GetPlayerIdentifiers(nplayer)) do
                    if string.find(v, "discord") then

                        local dc = string.gsub(v, "discord:", "")
                        vRP.prompt(source, 'Discord do ID '..nplayer_id..". (Jogador mais próximo)", '<@'..dc..'>')

                        return
                    end

                    TriggerClientEvent("Notify", source, "negado", "O ID <b>"..nplayer_id.."</b> não possui <b>discord vinculado a conta</b>.")
                end
            end
        end
    end
end)
