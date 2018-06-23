--王家の眠る谷－ネクロバレー
function c47355498.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Atk&Def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x2e))
	e2:SetValue(500)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--cannot remove
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_REMOVE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_GRAVE,0)
	e4:SetCondition(c47355498.contp)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetTargetRange(0,LOCATION_GRAVE)
	e5:SetCondition(c47355498.conntp)
	c:RegisterEffect(e5)
	--necro valley
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_NECRO_VALLEY)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTargetRange(LOCATION_GRAVE,0)
	e6:SetCondition(c47355498.contp)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetTargetRange(0,LOCATION_GRAVE)
	e7:SetCondition(c47355498.conntp)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_NECRO_VALLEY)
	e8:SetRange(LOCATION_FZONE)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e8:SetTargetRange(1,0)
	e8:SetCondition(c47355498.contp)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetTargetRange(0,1)
	e9:SetCondition(c47355498.conntp)
	c:RegisterEffect(e9)
	--disable
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_CHAIN_SOLVING)
	e10:SetRange(LOCATION_FZONE)
	e10:SetOperation(c47355498.disop)
	c:RegisterEffect(e10)
end
function c47355498.contp(e)
	return not Duel.IsPlayerAffectedByEffect(e:GetHandler():GetControler(),EFFECT_NECRO_VALLEY_IM)
end
function c47355498.conntp(e)
	return not Duel.IsPlayerAffectedByEffect(1-e:GetHandler():GetControler(),EFFECT_NECRO_VALLEY_IM)
end
function c47355498.disfilter(c,im0,im1)
	if c:IsControler(0) then return im0 and c:IsHasEffect(EFFECT_NECRO_VALLEY)
	else return im1 and c:IsHasEffect(EFFECT_NECRO_VALLEY) end
end
function c47355498.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not Duel.IsChainDisablable(ev) or rc:IsHasEffect(EFFECT_NECRO_VALLEY_IM) then return end
	local res=false
	local im0=not Duel.IsPlayerAffectedByEffect(0,EFFECT_NECRO_VALLEY_IM)
	local im1=not Duel.IsPlayerAffectedByEffect(1,EFFECT_NECRO_VALLEY_IM)
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if tg and tg:GetCount()>0 then
		res=tg:IsExists(c47355498.disfilter,1,nil,im0,im1)
	end
	if not res and rc.necrovalley_check_group then
		local groupfun=rc.necrovalley_check_group[re]
		local tg2
		if groupfun then tg2=groupfun() end
		if tg2 and tg2:GetCount()>0 then
			res=tg2:IsExists(c47355498.disfilter,1,nil,im0,im1)
		end
	end
	if res then Duel.NegateEffect(ev) end
end
