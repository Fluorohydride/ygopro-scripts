--HSRコルク－10
function c23361526.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--choose effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23361526,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,23361526)
	e1:SetCondition(c23361526.condition)
	e1:SetCost(c23361526.cost)
	e1:SetTarget(c23361526.target)
	e1:SetOperation(c23361526.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c23361526.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(23361526,ACTIVITY_SPSUMMON,c23361526.counterfilter)
end
function c23361526.counterfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND)
end
function c23361526.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c23361526.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(23361526,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c23361526.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c23361526.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(ATTRIBUTE_WIND)
end
function c23361526.thfilter(c)
	return c:IsSetCard(0x2016) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c23361526.spfilter(c,e,tp,sync)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
		and bit.band(c:GetReason(),0x80008)==0x80008 and c:GetReasonCard()==sync
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c23361526.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	local ct=mg:GetCount()
	local b1=Duel.IsExistingMatchingCard(c23361526.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=e:GetLabel()==1 and ct>0 and mg:FilterCount(c23361526.spfilter,nil,e,tp,c)==ct
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct and not Duel.IsPlayerAffectedByEffect(tp,59822133)
	if chk==0 then return b1 or b2 end
	local off=1
	local ops,opval={},{}
	if b1 then
		ops[off]=aux.Stringid(23361526,1)
		opval[off]=0
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(23361526,2)
		opval[off]=1
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==0 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetTargetCard(mg)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,mg,ct,0,0)
	end
end
function c23361526.operation(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c23361526.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
		local mg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local g=mg:Filter(Card.IsRelateToEffect,nil,e)
		if g:GetCount()<mg:GetCount() then return end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<g:GetCount() then return end
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c23361526.mfilter(c)
	return not c:IsSetCard(0x2016)
end
function c23361526.valcheck(e,c)
	local g=c:GetMaterial()
	if g:GetCount()>0 and not g:IsExists(c23361526.mfilter,1,nil) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
