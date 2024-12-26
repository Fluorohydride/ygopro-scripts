--閉ザサレシ世界ノ冥神
---@param c Card
function c98127546.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),4)
	c:EnableReviveLimit()
	--extra material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(c98127546.matval)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98127546,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c98127546.discon)
	e2:SetTarget(c98127546.distg)
	e2:SetOperation(c98127546.disop)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetCondition(c98127546.immcon)
	e3:SetValue(c98127546.efilter)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98127546,1))
	e4:SetCategory(CATEGORY_NEGATE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c98127546.negcon)
	e4:SetTarget(c98127546.negtg)
	e4:SetOperation(c98127546.negop)
	c:RegisterEffect(e4)
end
function c98127546.exmatcheck(c,lc,tp)
	if not c:IsControler(1-tp) then return false end
	local le={c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
	for _,te in pairs(le) do	 
		local f=te:GetValue()
		local related,valid=f(te,lc,nil,c,tp)
		if related and not te:GetHandler():IsCode(98127546) then return false end
	end
	return true	 
end
function c98127546.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true,not mg or not mg:IsExists(c98127546.exmatcheck,1,nil,lc,tp)
end
function c98127546.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c98127546.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end
function c98127546.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
function c98127546.immcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c98127546.efilter(e,te)
	if te:GetOwnerPlayer()==e:GetHandlerPlayer() or not te:IsActivated() then return false end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(e:GetHandler())
end
function c98127546.cfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_MONSTER)
end
function c98127546.negcon(e,tp,eg,ep,ev,re,r,rp)
	local ex,g,gc,dp,dv=Duel.GetOperationInfo(ev,CATEGORY_SPECIAL_SUMMON)
	return Duel.IsChainNegatable(ev) and rp==1-tp
		and (ex and (dv&LOCATION_GRAVE==LOCATION_GRAVE or g and g:IsExists(c98127546.cfilter,1,nil)) or re:IsHasCategory(CATEGORY_GRAVE_SPSUMMON))
end
function c98127546.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c98127546.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
