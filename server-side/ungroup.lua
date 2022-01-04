--[[ 

--- INFORMAÇÕES ---

Comando: /ungroup.
Descrição: Retire um grupo a um jogador offline e com proteção de remoções de grupos de forma hierarquica.
Desenvolvedor: Striker
OBS: Necessita do meu código de /group que está abaixo ou coloque o código acima deste que está no final da página.
Código de group: https://github.com/StrikerStore/codigos/blob/main/server-side/group.lua

]]--

-----------------------------------------------------------------------------------------------------------------------------------------
--[ UNGROUP ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('ungroup',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id,"suporte.permissao") then
        
        local nuser_id = parseInt(tonumber(args[1]))
        local grupo = args[2]

        if nuser_id and grupo then
            local nsource = vRP.getUserSource(nuser_id)

            -- PERMISSÃO QUE O SISTEMA DESCONSIDERARÁ DA PROTEÇÃO HIERARQUICA
            if not vRP.hasPermission(user_id,"dono.permissao") then
                for k, v in pairs(hierarquia_staff) do
                    
                    if string.lower(grupo) == v.group then
                        if not vRP.hasPermission(user_id, v.perm) and not vRP.hasGroup(user_id, v.group) or vRP.hasPermission(user_id, v.perm) and vRP.hasGroup(user_id, v.group) then
                            return
                        end
                    end
                end
            end

            if nsource then
                if vRP.hasGroup(nuser_id, grupo) then
                    vRP.removeUserGroup(nuser_id, grupo)
                    TriggerClientEvent("Notify",source,"sucesso", 'Sucesso',"Você <b>removeu</b> o passaporte <b>" .. nuser_id .. "</b> do grupo <b>" .. grupo .. "</b>.",8000)
                else
                    TriggerClientEvent('Notify', source, 'negado', 'Negado', "O passaporte <b>" .. nuser_id .. "</b> já <b>não pertence</b> ao grupo <b>" .. grupo .. "</b>.")
                end

            else
                local query = vRP.query('vRP/getdatatable', { user_id = nuser_id })

                if query[1] then
                    local datatable = json.decode(query[1].dvalue)

                    if not datatable['groups'][grupo] then
                        TriggerClientEvent('Notify', source, 'negado', 'Negado', "O passaporte <b>" .. nuser_id .. "</b> já <b>não pertence</b> ao grupo <b>" .. grupo .. "</b>.")

                    else
                        datatable['groups'][grupo] = nil
                        datatable = json.encode(datatable)
                        vRP.execute('vRP/attdatatable', {user_id = nuser_id, datatable = datatable})
                        TriggerClientEvent('Notify', source, 'sucesso', 'Sucesso', "O passaporte <b>" .. nuser_id .. "</b> foi <b>removido</b> do grupo <b>" .. grupo .. "</b>.")
                    end
                else
                    TriggerClientEvent("Notify",source,"negado", 'Negado',"O passaporte <b>" .. nuser_id .. '</b> não possui registros no <b>banco de dados</b>.',8000)
                end
            end
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
--[ DEPENDENCIAS - UNGROUP ]-------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------

-- APENAS IGNORE SE HOUVER MEU CÓDIGO DE GROUP --

local hierarquia_staff = {
    { group = "dono", perm = "dono.permissao" },
    { group = "admin", perm = "administrador.permissao" },
    { group = "mod", perm = "moderador.permissao" },
    { group = "sup", perm = "suporte.permissao" }
}

vRP.prepare('vRP/getdatatable', "SELECT * FROM vrp_user_data WHERE user_id = @user_id AND dkey = 'vRP:datatable'" )
vRP.prepare('vRP/attdatatable', "UPDATE vrp_user_data SET dvalue = @datatable WHERE user_id = @user_id AND dkey = 'vRP:datatable'")

-- APENAS IGNORE SE HOUVER MEU CÓDIGO DE GROUP --
