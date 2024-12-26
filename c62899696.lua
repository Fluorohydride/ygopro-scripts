--SRアクマグネ
---@param c Card
function c62899696.initial_effect(c)
	--cannot be synchro
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c62899696.smcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--synchro summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(62899696,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,62899696)
	e2:SetCondition(c62899696.spcon)
	e2:SetTarget(c62899696.sptg)
	e2:SetOperation(c62899696.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c62899696.smcon(e)
	return e:GetHandler():GetFlagEffect(62899696)==0
end
function c62899696.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
		and bit.band(Duel.GetCurrentPhase(),PHASE_MAIN1+PHASE_MAIN2)>0
end
function c62899696.filter(tc,c,tp)
	if tc:IsFacedown() or not tc:IsCanBeSynchroMaterial() then return false end
	c:RegisterFlagEffect(62899696,0,0,1)
	local mg=Group.FromCards(c,tc)
	local res=Duel.IsExistingMatchingCard(c62899696.synfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
	c:ResetFlagEffect(62899696)
	return res
end
function c62899696.synfilter(c,mg)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsSynchroSummonable(nil,mg)
end
function c62899696.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c62899696.filter(chkc,e:GetHandler(),tp) end
	if chk==0 then return Duel.IsExistingTarget(c62899696.filter,tp,0,LOCATION_MZONE,1,nil,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c62899696.filter,tp,0,LOCATION_MZONE,1,1,nil,e:GetHandler(),tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c62899696.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e)
		and tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		c:RegisterFlagEffect(62899696,RESET_EVENT+RESETS_STANDARD,0,1)
		local mg=Group.FromCards(c,tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c62899696.synfilter,tp,LOCATION_EXTRA,0,1,1,nil,mg)
		local sc=g:GetFirst()
		if sc then
			Duel.SynchroSummon(tp,sc,nil,mg)
		else
			c:ResetFlagEffect(62899696)
		end
	end
end
