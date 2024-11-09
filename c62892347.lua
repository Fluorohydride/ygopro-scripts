--アルカナフォース0－THE FOOL
---@param c Card
function c62892347.initial_effect(c)
	--battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e2:SetCondition(c62892347.poscon)
	c:RegisterEffect(e2)
	--coin
	aux.EnableArcanaCoin(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP_SUMMON_SUCCESS,EVENT_SPSUMMON_SUCCESS)
end
function c62892347.poscon(e)
	return e:GetHandler():IsPosition(POS_FACEUP_ATTACK)
end
function c62892347.arcanareg(c,coin)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetTarget(c62892347.distg)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	--disable effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c62892347.disop)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
	--self destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e3:SetTarget(c62892347.distg)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e3)
	c:RegisterFlagEffect(FLAG_ID_ARCANA_COIN,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,coin,63-coin)
end
function c62892347.distg(e,c)
	local ec=e:GetHandler()
	if c==ec or c:GetCardTargetCount()==0 then return false end
	local val=ec:GetFlagEffectLabel(FLAG_ID_ARCANA_COIN)
	if val==1 then
		return c:GetControler()==ec:GetControler() and c:GetCardTarget():IsContains(ec)
	else return c:GetControler()~=ec:GetControler() and c:GetCardTarget():IsContains(ec) end
end
function c62892347.disop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	if not ec:IsRelateToEffect(re) then return end
	local val=ec:GetFlagEffectLabel(FLAG_ID_ARCANA_COIN)
	if (val==1 and rp==1-ec:GetControler()) or (val==0 and rp==ec:GetControler()) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or not g:IsContains(ec) then return end
	if Duel.NegateEffect(ev,true) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(re:GetHandler(),REASON_EFFECT)
	end
end
