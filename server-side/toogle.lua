--[[ 

--- INFORMAÇÕES ---

Comando: /toogle.
Descrição: Sistema de toogle padrão mas com configuração e salvamento de tempo de serviço além de não ter aquela quantidade de IF.
Desenvolvedor: Striker
OBS: Configure os grupos de sua base primeira variavel.

]]--

-----------------------------------------------------------------------------------------------------------------------------------------
--[ TOOGLE ]-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local webhookpolicia = "https://discord.com/api/webhooks/825566902880436243/i-xPEM9DSY8ErHDzq6FmBJaq6zs8KqBW7YpcKXtk9OOlrHg4-GGzDXgirFJljzrHpYtw"
local webhookparamedico = "https://discord.com/api/webhooks/825567196784361492/P7BOz6BeFZlm8vsDEfiJdkW99E0gkH7VQzwbX1HccL-bY29PWHzMcz9nN4RRs7Gc9gRq"
local webhookmecanico = "https://discord.com/api/webhooks/833146716793733170/c23fsKGFqF58kqyA_v_76ua9i44sNXuTSbMQEE1Oo-Eaz6RrMZ_Bbd2rHHHiER5Rdecz"

local toogles = {
	{ ["tipo"] = "entrar", ["perm"] = "paisanapolicia.permissao", ["group"] = "Policia", ["tirarcolete"] = false, ["webhook"] = webhookpolicia, ["webhooktipo"] = "POLICIAL", ["removerblip"] = false },
	{ ["tipo"] = "entrar", ["perm"] = "paisanahospital.permissao", ["group"] = "Paramedico", ["tirarcolete"] = false, ["webhook"] = webhookparamedico, ["webhooktipo"] = "PARAMEDICO", ["removerblip"] = false },
	{ ["tipo"] = "entrar", ["perm"] = "paisanamecanico.permissao", ["group"] = "Mecanico", ["tirarcolete"] = false, ["webhook"] = webhookmecanico, ["webhooktipo"] = "MECANICO", ["removerblip"] = false },
	{ ["tipo"] = "sair", ["perm"] = "policia.permissao", ["group"] = "PaisanaPolicia", ["tirarcolete"] = true, ["webhook"] = webhookpolicia, ["webhooktipo"] = "POLICIAL", ["removerblip"] = true },
	{ ["tipo"] = "sair", ["perm"] = "hospital.permissao", ["group"] = "PaisanaParamedico", ["tirarcolete"] = false, ["webhook"] = webhookparamedico, ["webhooktipo"] = "PARAMEDICO", ["removerblip"] = true },
	{ ["tipo"] = "sair", ["perm"] = "mecanico.permissao", ["group"] = "PaisanaMecanico", ["tirarcolete"] = false, ["webhook"] = webhookmecanico, ["webhooktipo"] = "MECANICO", ["removerblip"] = false },
}

local tempo_servico = {}

RegisterCommand('toogle',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)

	for k,v in pairs(toogles) do
		if vRP.hasPermission(user_id, v["perm"]) then
			if v["removerblip"] then
				TriggerEvent('eblips:remove',source)
			end

			vRP.addUserGroup(user_id,v["group"])

			if v["tirarcolete"] then
				vRPclient.setArmour(source,0)
			end
			
			if v["tipo"] == "entrar" then
				tempo_servico[user_id] = os.time()
				TriggerClientEvent("Notify",source,"sucesso","Sucesso","Você <b>entrou</b> em serviço.")
				SendWebhookMessage(v["webhook"],"```prolog\n["..v["webhooktipo"].."]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[========== ENTROU EM SERVICO =========] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			elseif v["tipo"] == "sair" then
				local tempo_decorrido = vRP.getTimeFunction(os.time()-tempo_servico[user_id])

				TriggerClientEvent("Notify",source,"negado","Aviso","Você <b>saiu</b> de serviço. <br><br><b>Info:</b> Você ficou em serviço por <b>".. tempo_decorrido .. "</b>.")
				SendWebhookMessage(v["webhook"],"```prolog\n["..v["webhooktipo"].."]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[========== SAIU DE SERVICO =========] \n[TEMPO EM SERVICO]: "..sanitizeString(tempo_decorrido, "<b></b>").."."..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
				tempo_servico[user_id] = nil
			end

			break
		end
	end
end)
