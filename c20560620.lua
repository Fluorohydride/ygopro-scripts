--お代狸様の代算様
--not fully implemented
local s,id,o=GetID()
---@param c Card
function s.initial_effect(c)
	--cannot release
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UNRELEASABLE_SUM)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e2)
	--extra ritual material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_EXTRA_RITUAL_MATERIAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id)
	e3:SetTargetRange(LOCATION_EXTRA,0)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--workaround
	if not aux.rit_mat_hack_check then
		aux.rit_mat_hack_check=true
		function aux.rit_mat_hack_exmat_filter(tc)
			return tc:IsHasEffect(EFFECT_EXTRA_RITUAL_MATERIAL,tc:GetControler()) and tc:IsLocation(LOCATION_EXTRA)
		end
		function aux.RitualCheckGreater(g,rc,lv)
			if g:FilterCount(aux.rit_mat_hack_exmat_filter,nil)>1 then return false end
			Duel.SetSelectedCard(g)
			return g:CheckWithSumGreater(Card.GetRitualLevel,lv,rc)
		end
		function aux.RitualCheckEqual(g,rc,lv)
			if g:FilterCount(aux.rit_mat_hack_exmat_filter,nil)>1 then return false end
			return g:CheckWithSumEqual(Card.GetRitualLevel,lv,#g,#g,rc)
		end
		_ReleaseRitualMaterial=Duel.ReleaseRitualMaterial
		function Duel.ReleaseRitualMaterial(mat)
			local tc=mat:Filter(aux.rit_mat_hack_exmat_filter,nil):GetFirst()
			if tc then
				local te=tc:IsHasEffect(EFFECT_EXTRA_RITUAL_MATERIAL,tc:GetControler())
				te:UseCountLimit(tc:GetControler())
			end
			return _ReleaseRitualMaterial(mat)
		end
	end
end
