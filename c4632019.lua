--ヤマタコオロチ
function c4632019.initial_effect(c)
	--synclv
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SYNCHRO_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c4632019.synclv)
	c:RegisterEffect(e1)
	--gain effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCondition(c4632019.efcon)
	e2:SetOperation(c4632019.efop)
	c:RegisterEffect(e2)
end
function c4632019.synclv(e,c)
	local lv=aux.GetCappedLevel(e:GetHandler())
	return (8<<16)+lv
end
function c4632019.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function c4632019.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local lv=rc:GetOriginalLevel()
	local reg=nil
	if lv>0 and lv<=8 then
		--atkup
		local e1=Effect.CreateEffect(rc)
		e1:SetDescription(aux.Stringid(4632019,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(800)
		rc:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		rc:RegisterEffect(e2,true)
		reg=true
	elseif lv>=9 then
		--inflict damage
		local e2=Effect.CreateEffect(rc)
		e2:SetDescription(aux.Stringid(4632019,0))
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_PIERCE)
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
		reg=true
	end
	if reg then
		if not rc:IsType(TYPE_EFFECT) then
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetCode(EFFECT_ADD_TYPE)
			e0:SetValue(TYPE_EFFECT)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD)
			rc:RegisterEffect(e0,true)
		end
	end
end
