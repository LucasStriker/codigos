--[[ 

--- INFORMAÇÕES ---

Comando: /group.
Descrição: Setar um grupo a um jogador offline e com proteção de setagens de grupos de forma hierárquica.
Desenvolvedor: Striker
OBS: Configure os grupos de sua base na primeira variavel.

]]--

-----------------------------------------------------------------------------------------------------------------------------------------
--[ /GROUP ]-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
⠀ local hierarquia_staff = {
    { group = "dono", perm = "dono.permissao" },
    { group = "admin", perm = "administrador.permissao" },
    { group = "mod", perm = "moderador.permissao" },
    { group = "sup", perm = "suporte.permissao" }
}

vRP.prepare('vRP/getdatatable', "SELECT * FROM vrp_user_data WHERE user_id = @user_id AND dkey = 'vRP:datatable'" )
vRP.prepare('vRP/attdatatable', "UPDATE vrp_user_data SET dvalue = @datatable WHERE user_id = @user_id AND dkey = 'vRP:datatable'")

RegisterCommand('group',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    local umavez = false

    if vRP.hasPermission(user_id,"suporte.permissao") then
        
        local nuser_id = parseInt(tonumber(args[1]))
        local grupo = args[2]

        if nuser_id and grupo then
            local nsource = vRP.getUserSource(nuser_id)

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

                if not vRP.hasGroup(parseInt(nuser_id), grupo) then
                    vRP.addUserGroup(parseInt(nuser_id), grupo)
                    TriggerClientEvent("Notify",source,"sucesso", "Você <b>setou</b> o passaporte <b>" .. nuser_id .. "</b> no grupo <b>" .. grupo .. "</b>.",8000)
                else
                    TriggerClientEvent('Notify', source, 'negado', 'O passaporte <b>' .. nuser_id .. '</b> já <b>pertence</b> ao grupo <b>' .. grupo .. '</b>.')
                end

            else
                local query = vRP.query('vRP/getdatatable', { user_id = nuser_id })

                if query[1] then
                    local datatable = json.decode(query[1].dvalue)

                    if datatable['groups'][grupo] then
                        TriggerClientEvent('Notify', source, 'negado', 'O passaporte <b>'.. nuser_id ..'</b> já pertence ao grupo <b>' .. grupo .. '</b>.')

                    else
                        datatable['groups'][grupo] = true
                        datatable = json.encode(datatable)
                        vRP.execute('vRP/attdatatable', {user_id = nuser_id, datatable = datatable})
                        TriggerClientEvent('Notify', source, 'sucesso', 'O passaporte <b>' .. nuser_id .. '</b> foi <b>adicionado</b> ao grupo <b>' .. grupo .. '</b>.')
                    end
                else
                    TriggerClientEvent("Notify",source,"negado", "O jogador <b>" .. nuser_id .. '</b> não possui registros no <b>banco de dados</b>.',8000)
                end
            end
        end
    end
end)
